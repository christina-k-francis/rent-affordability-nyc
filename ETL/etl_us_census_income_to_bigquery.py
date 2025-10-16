"""
ETL script that downloads the latest U.S. Census Median Income data (annual) from 
the American Community Survey, cleans it, and then exports it as a data table to BigQuery.
"""

import os
import json
import pandas as pd
from google.cloud import bigquery
from google.oauth2 import service_account
from utils.us_census_data_tools import Import_ACS_Table

# --- Configuration ---
PROJECT_ID = "rent-affordability"
DATASET = "nyc_analysis"
TABLE_ID = f"{PROJECT_ID}.{DATASET}.staging_median_income"

ACS_Tables = [
    'B19013_001E',  # All HHs
    'B19202_001E',  # Singles
    'B19131_002E',  # Married w/ children
    'B19131_005E'   # Other families w/ children
]

# --- 1. Download ACS Data ---
print("Downloading Median Income Data from U.S. Census API...")

dfs = []
for table_code in ACS_Tables:
    df = Import_ACS_Table(os.getenv('CENSUS_API'), 36, table_code)
    dfs.append(df)

# --- 2. Merge Datasets ---
merged = dfs[0]
for df in dfs[1:]:
    merged = pd.merge(
        merged, df,
        on=['NAME', 'public use microdata area', 'year', 'state'],
        how='outer'
    )

# --- 3. Clean and rename columns ---
merged.rename(columns={
    'B19013_001E': 'income_all_HHs',
    'B19202_001E': 'income_singles',
    'B19131_002E': 'income_married_kids',
    'B19131_005E': 'income_other_kids'
}, inplace=True)

# --- 4. Convert datatypes ---
for col in ['income_all_HHs', 'income_singles', 'income_married_kids', 'income_other_kids']:
    merged[col] = pd.to_numeric(merged[col], errors='coerce').astype('Int64')

merged['year'] = merged['year'].astype(int)
merged['state'] = merged['state'].astype(str)
merged['public use microdata area'] = merged['public use microdata area'].astype(str)

# --- 5. Upload to BigQuery ---
print("Uploading Median Income Table to BigQuery...")
# load credentials
service_account_info = json.loads(os.environ["GOOGLE_CREDENTIALS_JSON"])
credentials = service_account.Credentials.from_service_account_info(service_account_info)
# initialize client
client = bigquery.Client(project=PROJECT_ID, credentials=credentials)
job_config = bigquery.LoadJobConfig(
    write_disposition="WRITE_TRUNCATE",  # Replace staging table each time
)

job = client.load_table_from_dataframe(merged, TABLE_ID, job_config=job_config)
job.result() # ensures the script waits for the job to complete

# --- 5a. check if the upload was successful ---
if job.state == 'DONE':
    if job.error_result:
        print(f"Job completed with errors: {job.error_result}")
    else:
        print(f"Job completed successfully. Loaded {job.output_rows} rows to {TABLE_ID}")
else:
    print(f"Job state: {job.state}")