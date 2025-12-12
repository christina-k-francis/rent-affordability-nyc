"""
ETL script that downloads the latest U.S. Census Median Income data (annual) from 
the American Community Survey, cleans it, and then exports it as a data table to BigQuery.
"""

import os
import json
import logging
import pandas as pd
from google.cloud import bigquery
from google.oauth2 import service_account
from utils.us_census_data_tools import Import_ACS_Table

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Configuration
PROJECT_ID = "rent-affordability"
DATASET = "nyc_analysis"
TABLE_ID = f"{PROJECT_ID}.{DATASET}.staging_median_income"

ACS_Tables = [
    'B19013_001E',  # All HHs
    'B19202_001E',  # Singles
    'B19131_002E',  # Married w/ children
    'B19131_005E'   # Other families w/ children
]

# 1. Download ACS Data
print("Downloading Median Income Data from U.S. Census API...")

dfs = []
for table_code in ACS_Tables:
    logger.info(f"Fetching table: {table_code}")
    try:
        df = Import_ACS_Table(os.getenv('CENSUS_API'), 36, table_code)
        logger.info(f"Successfully fetched {table_code}: {len(df)} rows")
        dfs.append(df)
    except Exception as e:
        logger.error(f"Failed to fetch {table_code}: {str(e)}", exc_info=True)
        raise

if not dfs:
    logger.error("No DataFrames were successfully fetched!")
    raise ValueError("All Census API calls failed")

logger.info(f"Total DataFrames collected: {len(dfs)}")

# 2. Merge Datasets
merged = dfs[0]
for df in dfs[1:]:
    merged = pd.merge(
        merged, df,
        on=['NAME', 'public use microdata area', 'year', 'state'],
        how='outer'
    )

# 3. Rename columns
merged.rename(columns={
    'B19013_001E': 'all_HHs',
    'B19202_001E': 'singles',
    'B19131_002E': 'married_kids',
    'B19131_005E': 'other_kids',
    "NAME": "district",
    "public use microdata area": "PUMA"
}, inplace=True)

# 4. Convert datatypes
for col in ['all_HHs', 'singles', 'married_kids', 'other_kids']:
    merged[col] = pd.to_numeric(merged[col], errors='coerce').astype('Int64')

merged['year'] = merged['year'].astype(int)
merged['state'] = merged['state'].astype(str)
merged['public use microdata area'] = merged['public use microdata area'].astype(str)

# 5. clean dataset, so it only contains pertinent data
cols = list(merged.columns)
# move income columns to right side of df
cols.insert(5, cols[1])
del cols[1:3]
merged = merged[cols]


# 6. Upload to BigQuery
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

# 5a. check if the upload was successful ---
if job.state == 'DONE':
    if job.error_result:
        print(f"Job completed with errors: {job.error_result}")
    else:
        print(f"Job completed successfully. Loaded {job.output_rows} rows to {TABLE_ID}")
else:
    print(f"Job state: {job.state}")