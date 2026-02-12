"""
Airflow DAG that orchestrates:
1. Census data download → BigQuery Bronze table
2. PySpark normalization → BigQuery Silver table
3. SQL-based YoY analysis → BigQuery Gold table

Bronze: Raw ingestion from StreetEasy public data
Silver: Cleaned, normalized database at the neighborhood level
Gold: YoY analysis

Runs monthly on the 1st at 2 AM UTC
"""

import os
import sys
import json
import subprocess
from datetime import datetime, timedelta
from airflow import DAG
from airflow.models import Variable
from airflow.providers.standard.operators.python import PythonOperator
from google.cloud import bigquery
from google.oauth2 import service_account

# Configuration
PROJECT_ID = "rent-affordability"
AIRFLOW_HOME = os.getenv('AIRFLOW_HOME', '~/nyc-rent-airflow')

# Paths to scripts
BRONZE_ETL = f"{AIRFLOW_HOME}/etl_scripts/ingest_streeteasy_rent_bronze.py"
SILVER_PYSPARK = f"{AIRFLOW_HOME}/spark_jobs/bronze_to_silver/rent_bronze_to_silver.py"
GOLD_SQL = f"{AIRFLOW_HOME}/sql/rent_yoy_gold.sql"

# BigQuery tables
BRONZE_TABLE = f"{PROJECT_ID}.nyc_bronze.rent_raw"
SILVER_TABLE = f"{PROJECT_ID}.nyc_silver.rent"
GOLD_TABLE = f"{PROJECT_ID}.nyc_gold.rent_yoy_changes"

default_args = {
    "owner": "Christina",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=10),
    "email_on_failure": False,
}


def get_credentials():
    """
    Description:
        Retrieves credentials from Airflow Variables
    """
    try:
        google_creds = Variable.get("GOOGLE_CREDENTIALS_SECRET")
        
        if not google_creds:
            raise ValueError("GOOGLE_CREDENTIALS_JSON not found in Airflow Variables")
        
        return {"google_creds": google_creds}
    except Exception as e:
        raise Exception(f"Credential retrieval failed: {str(e)}")


def get_bq_client(google_creds):
    """
    Description:
        Create BigQuery client
    """
    creds_info = json.loads(google_creds)
    credentials = service_account.Credentials.from_service_account_info(creds_info)
    return bigquery.Client(project=PROJECT_ID, credentials=credentials)


# ======= BRONZE LAYER: Raw Ingestion =======
def ingest_to_bronze(**context):
    """
    Description:
        Ingest raw Streeteasy Rent data to Bronze layr
    """
    
    creds = get_credentials()
    
    env = os.environ.copy()
    env['GOOGLE_CREDENTIALS_JSON'] = creds['google_creds']
    
    try:
        print("Starting Bronze ingestion from StreetEasy...")
        
        result = subprocess.run(
            [sys.executable, BRONZE_ETL],
            capture_output=True,
            text=True,
            timeout=600,  # 10 minute timeout
            env=env,
            check=True
        )
        
        print(result.stdout)
        
        # Push metadata to XCom
        context['task_instance'].xcom_push(key='bronze_status', value='success')
        
        return {"status": "success", "layer": "bronze", "output": result.stdout}
        
    except subprocess.CalledProcessError as e:
        raise Exception(f"Bronze ingestion failed: {e.stderr}")

# ======= BRONZE VALIDATION: Data Quality Check =======
def validate_bronze_layer(**context):
    """
    Description:
        Running data quality check on Bronze table    
    """
    creds = get_credentials()
    client = get_bq_client(creds['google_creds'])
    
    print("Validating Bronze Layer: rent_raw")
    
    # Check 1: Row count
    query = f"""
    SELECT 
        COUNT(*) as row_count,
        COUNT(DISTINCT area_name) as area_count,
        COUNT(DISTINCT CONCAT(CAST(year AS STRING), '-', month)) as date_count,
        MAX(CONCAT(CAST(year AS STRING), '-', month)) as latest_date
    FROM `{BRONZE_TABLE}`
    """
    
    result = list(client.query(query).result())[0]
    
    row_count = result['row_count']
    area_count = result['area_count']
    date_count = result['date_count']
    latest_date = result['latest_date']
    
    print(f"\nBronze Layer Statistics:")
    print(f"  Total Rows: {row_count:,}")
    print(f"  Unique Areas: {area_count}")
    print(f"  Date Range: {date_count} months")
    print(f"  Latest Data: {latest_date}")
    
    # Validation rules
    if row_count == 0:
        raise ValueError("Bronze validation failed: Table is empty!")
    
    if area_count < 50:
        raise ValueError(f"Bronze validation failed: Only {area_count} areas (expected 50+)")
    
    print("\nBronze validation passed!")
    
    # Push to XCom
    context['task_instance'].xcom_push(key='bronze_rows', value=row_count)
    context['task_instance'].xcom_push(key='latest_date', value=latest_date)
    
    return {
        "row_count": row_count,
        "area_count": area_count,
        "latest_date": latest_date
    }

# ======= SILVER LAYER: Normalization & Cleaning =======
def transform_bronze_to_silver(**context):
    """
    Description:
        Execute PySpark normalization job
    """
    
    creds = get_credentials()
    
    env = os.environ.copy()
    env['GOOGLE_CREDENTIALS_JSON'] = creds['google_creds']
    env['PYSPARK_PYTHON'] = sys.executable
    env['PYSPARK_DRIVER_PYTHON'] = sys.executable
    
    try:
        print("Starting Silver transformation (PySpark)...")
        
        result = subprocess.run(
            [
                'spark-submit',
                '--packages', 'com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.35.1',
                '--conf', 'spark.sql.execution.arrow.pyspark.enabled=true',
                '--conf', 'spark.sql.adaptive.enabled=true',
                SILVER_PYSPARK
            ],
            capture_output=True,
            text=True,
            timeout=1200,  # 20 minute timeout
            env=env,
            check=True
        )
        
        print(result.stdout)
        
        context['task_instance'].xcom_push(key='silver_status', value='success')
        
        return {"status": "success", "layer": "silver", "output": result.stdout}
        
    except subprocess.CalledProcessError as e:
        print(f"Silver transformation failed: {e.stderr}")
        raise Exception(f"Silver transformation failed: {e.stderr}")

# ======= SILVER VALIDATION: Data Quality Check =======
def validate_silver_layer(**context):
    """
    Description:
        Run quality checks on Silver layer
    """
    creds = get_credentials()
    client = get_bq_client(creds['google_creds'])

    print("Validating Silver Layer: rent")
    
    # Check 1: Row count and basic stats
    query = f"""
    SELECT 
        COUNT(*) as row_count,
        COUNT(DISTINCT neighborhood) as neighborhood_count,
        COUNT(DISTINCT borough_id) as borough_count,
        COUNT(DISTINCT district_id) as district_count,
        AVG(all_price) as avg_all_price,
        MIN(year) as min_year,
        MAX(year) as max_year
    FROM `{SILVER_TABLE}`
    WHERE all_price IS NOT NULL
    """
    
    result = list(client.query(query).result())[0]
    
    row_count = result['row_count']
    neighborhood_count = result['neighborhood_count']
    borough_count = result['borough_count']
    district_count = result['district_count']
    avg_all_price = result['avg_all_price']
    
    print(f"\nSilver Layer Statistics:")
    print(f"  Total Rows: {row_count:,}")
    print(f"  Neighborhoods: {neighborhood_count}")
    print(f"  Boroughs: {borough_count}")
    print(f"  Districts: {district_count}")
    print(f"  Avg Rent (All): ${avg_all_price:,.2f}")
    print(f"  Year Range: {result['min_year']} - {result['max_year']}")
    
    # Check 2: Null key validation
    query_nulls = f"""
    SELECT 
        COUNT(*) as null_borough_id,
    FROM `{SILVER_TABLE}`
    WHERE borough_id IS NULL
    """
    
    null_result = list(client.query(query_nulls).result())[0]
    null_count = null_result['null_borough_id']
    
    # Validation rules
    if row_count == 0:
        raise ValueError("Silver validation failed: Table is empty!")
    
    if borough_count != 5:
        print(f"Warning: Expected 5 boroughs, found {borough_count}")
    
    if null_count > 0:
        print(f"Warning: {null_count} rows with null borough_id")
    
    print("\nSilver validation passed!")
    
    context['task_instance'].xcom_push(key='silver_rows', value=row_count)
    
    return {"row_count": row_count, "neighborhood_count": neighborhood_count}

# ======= GOLD LAYER: Aggregations + YoY Analysis =======
def transform_silver_to_gold(**context):
    """
    Description:
        SQL job: Silver → Gold YoY aggregations
    """
    creds = get_credentials()
    client = get_bq_client(creds['google_creds'])

    try:
        print("Starting Gold transformation (SQL YoY)...")
        
        # Read SQL file
        sql_file = Path(GOLD_SQL)
        if not sql_file.exists():
            raise FileNotFoundError(f"SQL script not found: {GOLD_SQL}")
        
        with open(sql_file, 'r') as f:
            sql_query = f.read()
        
        print(f"\nExecuting SQL query ({len(sql_query)} characters)...")
        
        # Configure query job
        job_config = bigquery.QueryJobConfig(
            use_legacy_sql=False,
            labels={"layer": "gold", "pipeline": "rent_medallion"}
        )
        
        # Execute the query
        query_job = client.query(sql_query, job_config=job_config)
        
        # Wait for query to complete
        result = query_job.result()
        
        # Get job statistics
        if query_job.state == 'DONE':
            if query_job.error_result:
                raise Exception(f"BigQuery job failed: {query_job.error_result}")
            
            # Extract metrics
            bytes_processed = query_job.total_bytes_processed if hasattr(query_job, 'total_bytes_processed') else 0
            bytes_billed = query_job.total_bytes_billed if hasattr(query_job, 'total_bytes_billed') else 0
    
            print(f"  SQL Script: {sql_file.name}")
            print(f"  Job ID: {query_job.job_id}")
            print(f"  Bytes Processed: {bytes_processed:,} bytes ({bytes_processed / 1024 / 1024:.2f} MB)")
            print(f"  Bytes Billed: {bytes_billed:,} bytes ({bytes_billed / 1024 / 1024:.2f} MB)")
            print(f"  Duration: {query_job.ended - query_job.started}")
  
            context['task_instance'].xcom_push(key='gold_status', value='success')
            context['task_instance'].xcom_push(key='bytes_processed', value=bytes_processed)

            return {
                "status": "success",
                "layer": "gold",
                "job_id": query_job.job_id,
                "bytes_processed": bytes_processed
            }
        else:
            raise Exception(f"Query job in unexpected state: {query_job.state}")
        
    except FileNotFoundError as e:
        print(f"\n✗ SQL file not found: {e}")
        raise

    except Exception as e:
        print(f"  Error: {str(e)}")
        print(f"  SQL Script: {GOLD_SQL}")
    
# ======= GOLD VALIDATION: Metric Validation =======
def validate_gold_layer(**context):
    """
    Description:
        Verify Gold Layer YoY analysis table
    """
    creds = get_credentials()
    client = get_bq_client(creds['google_creds'])
    
    print("Validating Gold Layer: rent_yoy_changes")
    
    query = f"""
    SELECT 
        COUNT(*) as row_count,
        COUNT(DISTINCT neighborhood) as neighborhood_count,
        MAX(year) as latest_year,
        AVG(yoy_change_pct_all) as avg_yoy_all,
        AVG(yoy_change_pct_1bdr) as avg_yoy_1bdr,
        AVG(yoy_change_pct_3bdr) as avg_yoy_3bdr,
        COUNT(CASE WHEN yoy_change_pct_all IS NOT NULL THEN 1 END) as records_with_yoy
    FROM `{GOLD_TABLE}`
    """
    
    result = list(client.query(query).result())[0]
    
    row_count = result['row_count']
    neighborhood_count = result['neighborhood_count']
    latest_year = result['latest_year']
    records_with_yoy = result['records_with_yoy']
    
    print(f"\nGold Layer Statistics:")
    print(f"  Total Rows: {row_count:,}")
    print(f"  Neighborhoods: {neighborhood_count}")
    print(f"  Latest Year: {latest_year}")
    print(f"  Records with YoY: {records_with_yoy:,}")
    
    if result['avg_yoy_all']:
        print(f"  Avg YoY Change (All): {result['avg_yoy_all']:.2f}%")
    if result['avg_yoy_1bdr']:
        print(f"  Avg YoY Change (1BR): {result['avg_yoy_1bdr']:.2f}%")
    if result['avg_yoy_3bdr']:
        print(f"  Avg YoY Change (3BR): {result['avg_yoy_3bdr']:.2f}%")
    
    # Validation rules
    if row_count == 0:
        raise ValueError("Gold validation failed: Table is empty!")
    
    if records_with_yoy == 0:
        raise ValueError("Gold validation failed: No YoY calculations found!")
    
    print("\nGold validation passed!")
    
    context['task_instance'].xcom_push(key='gold_rows', value=row_count)
    
    return {"row_count": row_count}

# ======= Pipeline Summary =======
def pipeline_summary(**context):
    """Print summary of entire pipeline execution"""
    ti = context['task_instance']
    
    bronze_rows = ti.xcom_pull(task_ids='bronze_ingest_streeteasy_rent', key='bronze_rows')
    silver_rows = ti.xcom_pull(task_ids='silver_transform_rent', key='silver_rows')
    gold_rows = ti.xcom_pull(task_ids='gold_transform_yoy_rent', key='gold_rows')
    latest_date = ti.xcom_pull(task_ids='validate_bronze_layer', key='latest_date')
    
    print("\n" + "=" * 70)
    print("PIPELINE EXECUTION SUMMARY")
    print("=" * 70)
    print(f"\n  Pipeline: Rent Medallion ETL")
    print(f"  Execution Date: {datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')}")
    print(f"  Latest Data: {latest_date}")
    print(f"\n  Layer Flow:")
    print(f"    Bronze (rent_raw):         {bronze_rows:,} rows")
    print(f"    Silver (rent):             {silver_rows:,} rows")
    print(f"    Gold (rent_yoy_changes):   {gold_rows:,} rows")
    print(f"\n  Status: ✓ ALL LAYERS SUCCESSFUL")
    print("=" * 70 + "\n")
    
    return {
        "pipeline": "rent_medallion",
        "bronze_rows": bronze_rows,
        "silver_rows": silver_rows,
        "gold_rows": gold_rows,
        "status": "success"
    }

# ======= DAG Definition =======
dag = DAG(
    dag_id="rent_medallion_pipeline",
    default_args=default_args,
    description="Bronze → Silver → Gold pipeline for StreetEasy rent data",
    schedule="0 2 1 * *",  # 1st of month at 2 AM UTC
    start_date=datetime(2025, 2, 1),
    catchup=False,
    tags=["medallion", "rent", "streeteasy", "bronze", "silver", "gold"],
)

# Define tasks
task_bronze_ingest = PythonOperator(
    task_id="bronze_ingest_streeteasy_rent",
    python_callable=ingest_to_bronze,
    dag=dag,
)

task_validate_bronze = PythonOperator(
    task_id="validate_bronze_layer",
    python_callable=validate_bronze_layer,
    dag=dag,
)

task_silver_transform = PythonOperator(
    task_id="silver_transform_rent",
    python_callable=transform_bronze_to_silver,
    dag=dag,
)

task_validate_silver = PythonOperator(
    task_id="validate_silver_layer",
    python_callable=validate_silver_layer,
    dag=dag,
)

task_gold_transform = PythonOperator(
    task_id="gold_transform_yoy_rent",
    python_callable=transform_silver_to_gold,
    dag=dag,
)

task_validate_gold = PythonOperator(
    task_id="validate_gold_layer",
    python_callable=validate_gold_layer,
    dag=dag,
)

task_summary = PythonOperator(
    task_id="pipeline_summary",
    python_callable=pipeline_summary,
    dag=dag,
)

# ======= Task Dependencies (Medallion Flow Framework) =======
task_bronze_ingest >> task_validate_bronze >> \
task_silver_transform >> task_validate_silver >> \
task_gold_transform >> task_validate_gold >> \
task_summary