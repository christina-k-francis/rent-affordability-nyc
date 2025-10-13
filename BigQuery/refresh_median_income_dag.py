"""
DAG Orchestration script that checks for BigQuery staging_median_income table changes,
and then runs the corresponding SQL file, thus refreshing all related analysis tables
"""

from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryCheckOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from datetime import datetime, timedelta

# Configuration
PROJECT_ID = "rent-affordability"
DATASET_ID = "nyc_analysis"
STAGING_TABLE = "staging_median_income"
SQL_PATH = "/home/airflow/gcs/dags/sql/refresh_median_income.sql"

default_args = {
    "owner": "Christina",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="refresh_median_income_dag",
    default_args=default_args,
    description="Run refresh SQL when staging_median_income table changes",
    schedule_interval="*/15 * * * *",  # checks every 15 minutes
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["bigquery", "refresh", "dag", "income"],
) as dag:

    # Sensor: Check if the staging table has changed since last run
    wait_for_income_table = BigQueryCheckOperator(
        task_id="wait_for_staging_income_update",
        sql=f"""
            SELECT TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), TIMESTAMP_MILLIS(last_modified_time), MINUTE)
            FROM `{PROJECT_ID}.{DATASET_ID}.__TABLES__`
            WHERE table_id = '{STAGING_TABLE}'
            AND TIMESTAMP_MILLIS(last_modified_time) > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
        """,
        use_legacy_sql=False,
        do_xcom_push=False,
        retries=0,
        retry_delay=timedelta(minutes=15),
        fail_on_empty=False  # this allows DAG to continue even if no updated rows are found
    )

    # Task: Run the refresh SQL
    refresh_income = BigQueryInsertJobOperator(
        task_id="run_refresh_income_sql",
        configuration={
            "query": {
                "query": open(SQL_PATH).read(),
                "useLegacySql": False,
            }
        },
        location="US",
    )

    wait_for_income_table >> refresh_income