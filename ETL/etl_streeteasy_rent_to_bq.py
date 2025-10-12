"""
ETL script that downloads the latest StreetEasy Median Rent data (monthly), 
cleans it, and then exports it as a data table to BigQuery.
"""

import os
import json
import pandas as pd
from google.cloud import bigquery
from google.oauth2 import service_account
from utils.streeteasy_data_tools import tidy_asking_rent

# --- configuration ---
PROJECT_ID = "rent-affordability"
DATASET = "nyc_analysis"
TABLE_ID = f"{PROJECT_ID}.{DATASET}.staging_median_rent"

# --- 1. download streeteasy data ---
print("Downloading Streeteasy rent data...")

urls = {
    "All": "https://cdn-charts.streeteasy.com/rentals/All/medianAskingRent_All.zip",
    "1Bd": "https://cdn-charts.streeteasy.com/rentals/OneBd/medianAskingRent_OneBd.zip",
    "3Bd": "https://cdn-charts.streeteasy.com/rentals/ThreePlusBd/medianAskingRent_ThreePlusBd.zip"
}

dfs = {name: pd.read_csv(url, compression='zip') for name, url in urls.items()}

# --- 2. clean and rename Columns ---
print("Tidying DataFrames...")
cleaned = {name: tidy_asking_rent(df) for name, df in dfs.items()}

# --- 3. merge datasets ---
merged = (
    cleaned["All"].rename(columns={"median_rent": "all_apts"})
    .merge(cleaned["1Bd"].rename(columns={"median_rent": "1bdr_apts"}),
           on=["area_name", "borough", "area_type", "year", "month"])
    .merge(cleaned["3Bd"].rename(columns={"median_rent": "3bdr_apts"}),
           on=["area_name", "borough", "area_type", "year", "month"])
)

# --- 4. convert datatypes ---
for col in ["all_apts", "1bdr_apts", "3bdr_apts"]:
    merged[col] = pd.to_numeric(merged[col], errors='coerce').astype('Int64')

merged["year"] = merged["year"].astype(int)
merged["month"] = merged["month"].astype(str)

# --- 5. Upload to BigQuery ---
print("Uploading Median Rent Table to BigQuery...")
# load credentials
service_account_info = json.loads(os.environ["GOOGLE_CREDENTIALS_JSON"])
credentials = service_account.Credentials.from_service_account_info(service_account_info)
# initialize client
client = bigquery.Client(project=PROJECT_ID, credentials=credentials)
job_config = bigquery.LoadJobConfig(write_disposition="WRITE_TRUNCATE")

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