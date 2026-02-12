"""
Bronze Layer ETL Script
Downloads the latest U.S. Census Median Income data (annual) from 
the American Community Survey and loads it 
as-is to BigQuery Bronze layer (income_raw table).

Medallion Layer: BRONZE (Raw Ingestion)
Source: U.S. Census API Data
Target: nyc_bronze.income_raw
"""

import os
import json
import logging
import pandas as pd
from datetime import datetime
import logging
from google.cloud import bigquery
from google.oauth2 import service_account
from utils.us_census_data_tools import Import_ACS_Table

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Configuration
PROJECT_ID = "rent-affordability"
BRONZE_DATASET = "nyc_bronze"
TABLE_ID = f"{PROJECT_ID}.{BRONZE_DATASET}.income_raw"

ACS_Tables = [
    'B19013_001E',  # All HHs
    'B19202_001E',  # Singles
    'B19131_002E',  # Married w/ children
    'B19131_005E'   # Other families w/ children
]

print("BRONZE LAYER: U.S. Census Income Data Ingestion")

# 1. Download ACS Data
print("\n[1/5] Downloading Median Income Data from U.S. Census API...")

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
print("\n[2/5] Merging DataFrames of all Census Populations...")

merged = dfs[0]
for df in dfs[1:]:
    merged = pd.merge(
        merged, df,
        on=['NAME', 'public use microdata area', 'year', 'state'],
        how='outer'
    )

# 3. Rename columns
print("\n[3/5] Renaming columns...")

merged.rename(columns={
    'B19013_001E': 'all_HHs',
    'B19202_001E': 'singles',
    'B19131_002E': 'married_kids',
    'B19131_005E': 'other_kids',
    "NAME": "district",
    "public use microdata area": "PUMA"
}, inplace=True)

# 4. Convert datatypes
print("\n[4/5] Converting datatypes...")

for col in ['all_HHs', 'singles', 'married_kids', 'other_kids']:
    merged[col] = pd.to_numeric(merged[col], errors='coerce').astype('Int64')

merged['year'] = merged['year'].astype(int)
merged['state'] = merged['state'].astype(str)
merged['PUMA'] = merged['PUMA'].astype(str)

# Add Bronze layer metadata
merged["bronze_load_timestamp"] = datetime.utcnow()
merged["source_system"] = "U.S. Census"

print(f"Datatype conversion complete")
print(f"Added metadata: bronze_load_timestamp, source_system")


#5. Upload to BigQuery Bronze Layer
print(f"\n[5/5] Uploading to BigQuery Bronze layer: {TABLE_ID}...")

# quickly movinf income columns to right side of df
cols = list(merged.columns)
cols.insert(5, cols[1])
del cols[1:3]
merged = merged[cols]

try:
    # load credentials
    service_account_info = json.loads(os.environ["GOOGLE_CREDENTIALS_JSON"])
    credentials = service_account.Credentials.from_service_account_info(service_account_info)
    
    # initialize BQ client
    client = bigquery.Client(project=PROJECT_ID, credentials=credentials)
    
    # Configure job to replace table (full Bronze table refresh)
    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE",  # Replace staging table each time
        schema_update_options=[
            bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION
        ],
    )

    # load dataframe to BigQuery
    job = client.load_table_from_dataframe(merged, TABLE_ID, job_config=job_config)
    job.result() # ensures the script waits for the job to complete

    # 5a. check if the upload was successful...
    if job.state == 'DONE':
        if job.error_result:
            raise Exception(f"Job completed with errors: {job.error_result}")
        else:
            print(f"\n{'=' * 70}")
            print("✓ BRONZE INGESTION SUCCESSFUL")
            print(f"{'=' * 70}")
            print(f"  Table: {TABLE_ID}")
            print(f"  Rows Loaded: {job.output_rows:,}")
            print(f"  Timestamp: {datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')}")
            print(f"{'=' * 70}\n")
    else:
        raise Exception(f"Job state: {job.state}")
    
except Exception as e:
    print(f"\n{'=' * 70}")
    print("✗ BRONZE INGESTION FAILED")
    print(f"{'=' * 70}")
    print(f"  Error: {str(e)}")
    print(f"{'=' * 70}\n")
    raise