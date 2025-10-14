"""
DAG Orchestration script that checks for BigQuery staging_median_rent table changes,
and then runs the corresponding SQL file, thus refreshing all related analysis tables
"""

from airflow import DAG
from airflow.sensors.base import BaseSensorOperator, poke_mode_only
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from datetime import datetime, timedelta
from google.cloud import bigquery

#  custom sensor to detect modifications to the staging_median_rent table
class BigQueryTableUpdateSensor(BaseSensorOperator):
    """Check if a BigQuery table was modified within the last N minutes"""
    
    template_fields = []
    ui_color = '#e3f2fd'

    def __init__(self, project_id, dataset_id, table_id, modified_within_minutes=60, **kwargs):
        super().__init__(**kwargs)
        self.project_id = project_id
        self.dataset_id = dataset_id
        self.table_id = table_id
        self.modified_within_minutes = modified_within_minutes
    
    def poke(self, context):
        """Check if table was modified within N minutes"""
        try:
            client = bigquery.Client(project=self.project_id)
            table = client.get_table(f"{self.project_id}.{self.dataset_id}.{self.table_id}")
            
            if table.modified_time is None:
                self.log.info(f"Table {self.table_id} has no modification time recorded")
                return False
            
            # Convert to UTC naive datetime for comparison
            modified_time = table.modified_time.replace(tzinfo=None)
            time_since_modified = datetime.utcnow() - modified_time
            
            self.log.info(
                f"Table {self.table_id} was last modified {time_since_modified.total_seconds()} seconds ago"
            )
            
            was_modified = time_since_modified <= timedelta(minutes=self.modified_within_minutes)
            
            if was_modified:
                self.log.info(f"Table {self.table_id} was modified within the last {self.modified_within_minutes} minutes")
            else:
                self.log.info(f"Table {self.table_id} was NOT modified within the last {self.modified_within_minutes} minutes")
            
            return was_modified
        
        except Exception as e:
            self.log.error(f"Error checking table update: {e}")
            return False

# Configuration
PROJECT_ID = "rent-affordability"
DATASET_ID = "nyc_analysis"
STAGING_TABLE = "staging_median_rent"
SQL_PATH = "/home/airflow/gcs/dags/sql/refresh_median_rent.sql"

default_args = {
    "owner": "Christina",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="refresh_median_rent_dag",
    default_args=default_args,
    description="Run refresh SQL when staging_median_rent table changes",
    schedule_interval="0 */2 * * *",  # checks every 2 hours
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["bigquery", "refresh", "dag", "rent"],
) as dag:

    # Sensor: Check if the staging table has changed since last run
    wait_for_rent_update = BigQueryTableUpdateSensor(
        task_id="wait_for_staging_rent_update",
        project_id=PROJECT_ID,
        dataset_id=DATASET_ID,
        table_id=STAGING_TABLE,
        modified_within_minutes=120,  # look for changes in past 2 hours
        poke_interval=60,              # check metadata every 60 seconds
        timeout=600,                   # give up after 10 minutes of checking
        mode="poke",
    )

    # Task: Run the refresh SQL
    refresh_rent = BigQueryInsertJobOperator(
        task_id="run_refresh_rent_sql",
        configuration={
            "query": {
                "query": open(SQL_PATH).read(),
                "useLegacySql": False,
            }
        },
        location="US",
    )

    # defining the task dependency
    wait_for_rent_update >> refresh_rent