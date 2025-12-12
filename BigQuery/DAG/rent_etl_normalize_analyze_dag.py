"""
DAG Orchestration script that downloads the latest Streeteasy Rent Price
data, uploads it to BigQuery as the staging_median_rent table, and then subsequently
runs SQL scripts that refresh the fact_median_rent table and recalculates the 
agg_yoy_rent_change analysis table.

This will run on the first of every month at 2AM UTC
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
ETL_SCRIPT_PATH = "/home/airflow/gcs/data/etl/etl_streeteasy_rent_to_bigquery.py"
SQL_ANALYSIS_PATH = "/home/airflow/gcs/data/sql/normalize_analyze_median_rent.sql"

default_args = {
    "owner": "Christina",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=10)
}

# helper function - handles env variables
def get_credentials():
    """
    This fx retrieves and returns Google credentials in the form of a dict with 
    a 'google_creds' key.
    """
    try:
        google_creds_json = Variable.get("GOOGLE_CREDENTIALS_SECRET")
        
        if not google_creds_json:
            raise ValueError("GOOGLE_CREDENTIALS_JSON not found in Airflow Variables")
        
        return {
            "google_creds_json": google_creds_json,
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
    dag_id="rent_etl_and_analysis_dag",
    default_args=default_args,
    description="Downloads Streeteasy rent data and refreshs analysis tables monthly",
    schedule_interval="0 2 1 * *",  # 1st of every month at 2 AM UTC
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["etl", "rent", "streeteasy", "bigquery", "monthly"]
)

# 1. Run the Streeteasy Rent ETL script
def run_streeteasy_rent_etl():
    """Execute the Streeteasy rent ETL script"""
    import subprocess
    import sys

    creds = get_credentials()
    
    # create env with necesary variables
    env = os.environ.copy()
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
        raise Exception(f"Error running streeteasy rent ETL: {str(e)}")

download_rent_data = PythonOperator(
    task_id="download_streeteasy_rent_data",
    python_callable=run_streeteasy_rent_etl,
    dag=dag,
)

# 1a. Query for the latest rent data that is available
def check_rent_data_availability(**context):
    """Query BigQuery for latest rent data year and month"""

    creds = get_credentials()
    client = get_bigquery_client(creds['google_creds_json'])
    
    # checking for row count and total available years
    query = f"""
    SELECT 
        COUNT(*) as row_count,
        COUNT(DISTINCT year) as years_available
    FROM `{PROJECT_ID}.{DATASET_ID}.staging_median_rent`;
    """
    result = client.query(query).result()
    row = list(result)[0]
    row_count = row['row_count']
    years_available = row['years_available']

    # checking for latest month-year date of data
    query = f"""
    SELECT
        `month`,
        `year`
        FROM `{PROJECT_ID}.{DATASET_ID}.staging_median_rent`
        ORDER BY year DESC, month DESC
        LIMIT 1;
    """
    row = list(result)[0]
    month, year = row['month'], row['year']

    print(f"Latest Streeteasy rent date: {month}, {year}")
    print(f"Total rows in staging_median_rent: {row_count}")
    print(f"Years available: {years_available}")
    
    # Push to XCom for use in downstream tasks
    context['task_instance'].xcom_push(key='latest_rent_year', value=year)
    context['task_instance'].xcom_push(key='rent_row_count', value=row_count)
    
    return {
        "latest_date": f"{month:02d}-{year}",
        "row_count": row_count,
        "years_available": years_available
    }

verify_rent_data = PythonOperator(
    task_id="verify_rent_data_availability",
    python_callable=check_rent_data_availability,
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

# 2. Refresh the rent analysis tables, and conduct database normalization again
refresh_rent_analysis = BigQueryInsertJobOperator(
    task_id="refresh_rent_analysis_tables",
    configuration={
        "query": {
            "query": open(SQL_ANALYSIS_PATH).read(),
            "useLegacySql": False,
        }
    },
    location="us-east4",
    gcp_conn_id="google_cloud_default", # explicitly use default connection
    dag=dag,
)

# 2a. Validate that the refresh was successful
def validate_rent_refresh_completion(**context):
    """Verify that refresh tables were created/updated"""
    print('Checking that the analysis refresh was successful...')

    creds = get_credentials()
    client = get_bigquery_client(creds['google_creds_json'])
    
    tables_to_check = ['fact_median_rent', 'agg_yoy_rent_change']
    
    for table in tables_to_check:
        query = f"SELECT COUNT(*) as row_count FROM `{PROJECT_ID}.{DATASET_ID}.{table}`"
        result = client.query(query).result()
        row = list(result)[0]
        row_count = row['row_count']
        
        if row_count == 0:
            raise Exception(f"Validation failed: {table} is empty")
    
    print("\nAll rent analysis tables validated successfully")
    return True

validate_rent = PythonOperator(
    task_id="validate_rent_refresh",
    python_callable=validate_rent_refresh_completion,
    provide_context=True,
    dag=dag,
)

# Defining task dependencies
download_rent_data >> verify_rent_data >> test_connection >> refresh_rent_analysis >> validate_rent