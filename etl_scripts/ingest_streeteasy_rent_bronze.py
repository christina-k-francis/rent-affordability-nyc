"""
Bronze Layer ETL Script
Downloads the latest StreetEasy Median Rent data (monthly) and loads it 
as-is to BigQuery Bronze layer (rent_raw table).

Medallion Layer: BRONZE (Raw Ingestion)
Source: StreetEasy Public Data
Target: nyc_bronze.rent_raw
"""

import os
import json
import numpy as np
import pandas as pd
from datetime import datetime
import logging
from google.cloud import bigquery
from google.oauth2 import service_account
from utils.streeteasy_data_tools import tidy_asking_rent

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Configuration
PROJECT_ID = "rent-affordability"
BRONZE_DATASET = "nyc_bronze"
TABLE_ID = f"{PROJECT_ID}.{BRONZE_DATASET}.rent_raw"

print("BRONZE LAYER: StreetEasy Rent Data Ingestion")

# 1. Download StreetEasy data from public URLs
print("\n[1/5] Downloading StreetEasy rent data from public URLs...")

urls = {
    # Asking rent prices by bedroom count
    "All": "https://cdn-charts.streeteasy.com/rentals/All/medianAskingRent_All.zip",
    "1Bd": "https://cdn-charts.streeteasy.com/rentals/OneBd/medianAskingRent_OneBd.zip",
    "3Bd": "https://cdn-charts.streeteasy.com/rentals/ThreePlusBd/medianAskingRent_ThreePlusBd.zip",
    
    # Volume of apartment units (inventory) contributing to each price stat
    "All_Inv": "https://cdn-charts.streeteasy.com/rentals/All/rentalInventory_All.zip",
    "1Bd_Inv": "https://cdn-charts.streeteasy.com/rentals/OneBd/rentalInventory_OneBd.zip",
    "3Bd_Inv": "https://cdn-charts.streeteasy.com/rentals/ThreePlusBd/rentalInventory_ThreePlusBd.zip",
}

dfs = {}
for name, url in urls.items():
    try:
        df = pd.read_csv(url, compression='zip')
        dfs[name] = df
        print(f"Downloaded {name}: {len(df)} rows")
    except Exception as e:
        raise Exception(f"Failed to download {name} from {url}: {str(e)}")

# 2. Tidy rent datasets (convert from wide to long format)
print("\n[2/5] Tidying DataFrames (wide → long format)...")

cleaned = {}
for name, df in dfs.items():
    try:
        cleaned[name] = tidy_asking_rent(df)
        print(f"  ✓ Tidied {name}: {len(cleaned[name])} rows")
    except Exception as e:
        raise Exception(f"Failed to tidy {name}: {str(e)}")

# 3. Merge datasets into single Bronze table
print("\n[3/5] Merging datasets...")

merged = (
    cleaned["All"]
    .rename(columns={"median_rent": "all_price"})
    .merge(
        cleaned["1Bd"].rename(columns={"median_rent": "1bdr_price"}),
        on=["area_name", "borough", "area_type", "year", "month"],
        how="outer"
    )
    .merge(
        cleaned["3Bd"].rename(columns={"median_rent": "3bdr_price"}),
        on=["area_name", "borough", "area_type", "year", "month"],
        how="outer"
    )
    .merge(
        cleaned["All_Inv"].rename(columns={"median_rent": "all_count"}),
        on=["area_name", "borough", "area_type", "year", "month"],
        how="outer"
    )
    .merge(
        cleaned["1Bd_Inv"].rename(columns={"median_rent": "1bdr_count"}),
        on=["area_name", "borough", "area_type", "year", "month"],
        how="outer"
    )
    .merge(
        cleaned["3Bd_Inv"].rename(columns={"median_rent": "3bdr_count"}),
        on=["area_name", "borough", "area_type", "year", "month"],
        how="outer"
    )
)

print(f"Merged datasets: {len(merged)} total rows")

# 4. Convert datatypes (minimal transformations for Bronze)
print("\n[4/5] Converting datatypes...")

for col in ["all_price", "1bdr_price", "3bdr_price",
            "all_count", "1bdr_count", "3bdr_count"]:
    merged[col] = pd.to_numeric(merged[col], errors='coerce').astype('float32')

merged["year"] = merged["year"].astype(int)
merged["month"] = merged["month"].astype(str)

# Add Bronze layer metadata
merged["bronze_load_timestamp"] = datetime.utcnow()
merged["source_system"] = "StreetEasy"

print(f"Datatype conversion complete")
print(f"Added metadata: bronze_load_timestamp, source_system")

# 5. Upload to BigQuery Bronze layer
print(f"\n[5/5] Uploading to BigQuery Bronze layer: {TABLE_ID}...")

try:
    # Load credentials
    service_account_info = json.loads(os.environ["GOOGLE_CREDENTIALS_JSON"])
    credentials = service_account.Credentials.from_service_account_info(service_account_info)
    
    # Initialize BigQuery client
    client = bigquery.Client(project=PROJECT_ID, credentials=credentials)
    
    # Configure job to replace table (BRONZE = full refresh)
    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE",  # Replace Bronze table each time
        schema_update_options=[
            bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION
        ],
    )
    
    # Load dataframe to BigQuery
    job = client.load_table_from_dataframe(merged, TABLE_ID, job_config=job_config)
    job.result()  # Wait for job to complete
    
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