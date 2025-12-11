"""
DAG Orchestration script that downloads the latest U.S. Census ACS household income
data, uploads it to BigQuery as the staging_median_income table, and then subsequently
runs SQL scripts that refresh the fact_median_income table and recalculates the 
agg_yoy_income_change analysis table.

This runs on the first of every month at 2AM UTC
"""

import os
import json
import pandas as pd
from datetime import datetime, timedelta
from google.oauth2 import service_account
from google.cloud import bigquery
from airflow import DAG
from airflow.models import Variable
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator

# configuration
PROJECT_ID = "rent-affordability"
DATASET_ID = "nyc_analysis"
ETL_SCRIPT_PATH = "/home/airflow/gcs/data/etl/etl_us_census_income_to_bigquery.py"
SQL_ANALYSIS_PATH = "/home/airflow/gcs/data/sql/normalize_analyze_median_income.sql"

default_args = {
    "owner": "Christina",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=10)
}

# helper function - handles env variables
def get_credentials():
    """
    This fx retrieves and returns Google credentials and a Census API key
    in the form of a dict with 'google_creds' and 'census_api' keys.
    """
    try:
        google_creds_json = Variable.get("GOOGLE_CREDENTIALS_SECRET")
        census_api = Variable.get("CENSUS_API_SECRET")
        
        if not google_creds_json:
            raise ValueError("GOOGLE_CREDENTIALS_JSON not found in Airflow Variables")
        if not census_api:
            raise ValueError("CENSUS_API not found in Airflow Variables")
        
        return {
            "google_creds_json": google_creds_json,
            "census_api": census_api
        }
    except Exception as e:
        raise Exception(f"Failed to retrieve credentials: {str(e)}")

# helper function - create big query client
def get_bigquery_client(google_creds_json):
    """This FX creates and returns a BigQuery client using credentials"""
    service_account_info = json.loads(google_creds_json)
    credentials = service_account.Credentials.from_service_account_info(service_account_info)
    return bigquery.Client(project=PROJECT_ID, credentials=credentials)

# defining the DAG
dag = DAG(
    dag_id="income_etl_and_analysis_dag",
    default_args=default_args,
    description="Download U.S. Census income data and refresh analysis tables monthly",
    schedule_interval="0 2 1 * *",  # 1st of every month at 2 AM UTC
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["etl", "income", "census", "bigquery", "monthly"],
)

# 1. Run the Census Income ETL Script
def run_census_income_etl():
    """Execute the U.S. Census income data ETL script"""
    import subprocess
    import sys

    creds = get_credentials()
    
    # create env with necesary variables
    env = os.environ.copy()
    env['CENSUS_API'] = creds['census_api']
    env['GOOGLE_CREDENTIALS_JSON'] = creds['google_creds_json']

    try:
        result = subprocess.run(
            [sys.executable, ETL_SCRIPT_PATH],
            capture_output=True,
            text=True,
            timeout=600,  # 10 minute timeout
            env=env # pass env vars
        )
        
        if result.returncode != 0:
            raise Exception(f"ETL script failed: {result.stderr}")
        
        print(result.stdout)
        return {"status": "success", "output": result.stdout}
    
    except Exception as e:
        raise Exception(f"Error running Census Income ETL: {str(e)}")

download_income_data = PythonOperator(
    task_id="download_census_income_data",
    python_callable=run_census_income_etl,
    dag=dag,
)

# 1a. Query for the latest income data that is available
def check_income_data_availability(**context):
    """Query BigQuery for latest income data year"""

    creds = get_credentials()
    client = get_bigquery_client(creds['google_creds_json'])
    
    query = f"""
    SELECT 
        MAX(year) as latest_income_year,
        COUNT(*) as row_count,
        COUNT(DISTINCT year) as years_available
    FROM `{PROJECT_ID}.{DATASET_ID}.staging_median_income`
    """
    
    result = client.query(query).result()
    row = list(result)[0]
    
    latest_year = row['latest_income_year']
    row_count = row['row_count']
    years_available = row['years_available']
    
    print(f"Latest U.S. Census Income Data: {latest_year}")
    print(f"Total rows in staging_median_income: {row_count}")
    print(f"Years available: {years_available}")
    
    # Push to XCom for use in downstream tasks
    context['task_instance'].xcom_push(key='latest_income_year', value=latest_year)
    context['task_instance'].xcom_push(key='income_row_count', value=row_count)
    
    return {
        "latest_year": latest_year,
        "row_count": row_count,
        "years_available": years_available
    }

verify_income_data = PythonOperator(
    task_id="verify_income_data_availability",
    python_callable=check_income_data_availability,
    provide_context=True,
    dag=dag,
)

# 1b. Debug step: testing conxn to project and dataset in BQ
def verify_bigquery_connection():
    """Test BigQuery connection and list available datasets"""
    creds = get_credentials()
    client = get_bigquery_client(creds['google_creds_json'])
    
    # List all datasets in the project
    datasets = list(client.list_datasets())
    print(f"Datasets in project {client.project}:")
    for ds in datasets:
        print(f"  - {ds.dataset_id}")
    
    # Try to get the specific dataset
    try:
        dataset = client.get_dataset(f"{PROJECT_ID}.{DATASET_ID}")
        print(f"\n✓ Successfully accessed {PROJECT_ID}.{DATASET_ID}")
        print(f"  Location: {dataset.location}")
        print(f"  Tables: {len(list(client.list_tables(dataset)))}")
        return True
    except Exception as e:
        print(f"\n✗ Cannot access {PROJECT_ID}.{DATASET_ID}: {str(e)}")
        raise

test_connection = PythonOperator(
    task_id="verify_bigquery_connection",
    python_callable=verify_bigquery_connection,
    dag=dag,
)

# 2. Refresh the income analysis tables and conduct database normalization again
refresh_income_analysis = BigQueryInsertJobOperator(
    task_id="refresh_income_analysis_tables",
    configuration={
        "query": {
            "query": open(SQL_ANALYSIS_PATH).read(),
            "useLegacySql": False,
        }
    },
    location="us-east4",
    gcp_conn_id="google_cloud_default",  # explicitly use default connection
    dag=dag,
)

# 2a. Validate that the refresh was successful
def validate_income_refresh_completion(**context):
    """Verify that refresh tables were created/updated"""
    print('Checking that the analysis refresh was successful...')

    creds = get_credentials()
    client = get_bigquery_client(creds['google_creds_json'])
    
    tables_to_check = ['fact_median_income', 'agg_yoy_income_change']
    
    for table in tables_to_check:
        query = f"SELECT COUNT(*) as row_count FROM `{PROJECT_ID}.{DATASET_ID}.{table}`"
        result = client.query(query).result()
        row = list(result)[0]
        row_count = row['row_count']
        
        if row_count == 0:
            raise Exception(f"Validation failed: {table} is empty")
    
    print("\nAll income analysis tables validated successfully")
    return True

validate_income = PythonOperator(
    task_id="validate_income_refresh",
    python_callable=validate_income_refresh_completion,
    provide_context=True,
    dag=dag,
)

# Defining task dependencies
download_income_data >> verify_income_data >> test_connection >> refresh_income_analysis >> validate_income
