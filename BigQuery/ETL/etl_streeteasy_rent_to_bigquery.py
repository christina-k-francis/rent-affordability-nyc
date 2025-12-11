"""
ETL script that downloads the latest StreetEasy Median Rent data (monthly), 
cleans it, and then exports it as a data table to BigQuery.
"""

import os
import json
import numpy as np
import pandas as pd
from google.cloud import bigquery
from google.oauth2 import service_account
from utils.streeteasy_data_tools import tidy_asking_rent

# configuration
PROJECT_ID = "rent-affordability"
DATASET = "nyc_analysis"
TABLE_ID = f"{PROJECT_ID}.{DATASET}.staging_median_rent"

# 1. download streeteasy data
print("Downloading Streeteasy rent data...")

urls = {
    # asking rent prices
    "All": "https://cdn-charts.streeteasy.com/rentals/All/medianAskingRent_All.zip",
    "1Bd": "https://cdn-charts.streeteasy.com/rentals/OneBd/medianAskingRent_OneBd.zip",
    "3Bd": "https://cdn-charts.streeteasy.com/rentals/ThreePlusBd/medianAskingRent_ThreePlusBd.zip",
    # volume of apartment units contributing to each price stat
    "All_Inv": "https://cdn-charts.streeteasy.com/rentals/All/rentalInventory_All.zip",
    "1Bd_Inv": "https://cdn-charts.streeteasy.com/rentals/OneBd/rentalInventory_OneBd.zip",
    "3Bd_Inv": "https://cdn-charts.streeteasy.com/rentals/ThreePlusBd/rentalInventory_ThreePlusBd.zip",
}

dfs = {name: pd.read_csv(url, compression='zip') for name, url in urls.items()}

# 2. clean and rename Columns
print("Tidying DataFrames...")
cleaned = {name: tidy_asking_rent(df) for name, df in dfs.items()}

# 3. merge datasets
merged = (
    cleaned["All"].rename(columns={"median_rent": "all_price"})
    .merge(cleaned["1Bd"].rename(columns={"median_rent": "1bdr_price"}),
           on=["area_name", "borough", "area_type", "year", "month"])
    .merge(cleaned["3Bd"].rename(columns={"median_rent": "3bdr_price"}),
           on=["area_name", "borough", "area_type", "year", "month"])
    .merge(cleaned["All_Inv"].rename(columns={"median_rent": "all_count"}),
           on=["area_name", "borough", "area_type", "year", "month"])
    .merge(cleaned["1Bd_Inv"].rename(columns={"median_rent": "1bdr_count"}),
           on=["area_name", "borough", "area_type", "year", "month"])
    .merge(cleaned["3Bd_Inv"].rename(columns={"median_rent": "3bdr_count"}),
           on=["area_name", "borough", "area_type", "year", "month"])
)

# 4. convert datatypes
for col in ["all_price", "1bdr_price", "3bdr_price",
            "all_count", "1bdr_count", "3bdr_count"]:
    merged[col] = pd.to_numeric(merged[col], errors='coerce').astype('float32')

merged["year"] = merged["year"].astype(int)
merged["month"] = merged["month"].astype(str)

# 5. cleaning dataset, so it contains only pertinent data
print("keeping only 'neighborhood' and 'borough' area types")
merged = merged[(merged['area_type'] == 'neighborhood')|(merged['area_type'] == 'borough')]
print("keeping only data with sample size >= 500")
merged.loc[~(merged['all_count'] >= 500), 'all_price'] = np.nan
merged.loc[~(merged['1bdr_count'] >= 500), '1bdr_price'] = np.nan
merged.loc[~(merged['3bdr_count'] >= 500), '3bdr_price'] = np.nan
# let's remove rows where all 3 apartment types have less than 500 units
merged = merged.loc[~((np.isnan(merged['all_price']))&(np.isnan(merged['1bdr_price']))&(np.isnan(merged['3bdr_price'])))]

# 6. Upload to BigQuery
print("Uploading Median Rent Table to BigQuery...")
# load credentials
service_account_info = json.loads(os.environ["GOOGLE_CREDENTIALS_JSON"])
credentials = service_account.Credentials.from_service_account_info(service_account_info)
# initialize client
client = bigquery.Client(project=PROJECT_ID, credentials=credentials)
job_config = bigquery.LoadJobConfig(write_disposition="WRITE_TRUNCATE")

job = client.load_table_from_dataframe(merged, TABLE_ID, job_config=job_config)
job.result() # ensures the script waits for the job to complete

# 5a. check if the upload was successful
if job.state == 'DONE':
    if job.error_result:
        print(f"Job completed with errors: {job.error_result}")
    else:
        print(f"Job completed successfully. Loaded {job.output_rows} rows to {TABLE_ID}")
else:
    print(f"Job state: {job.state}")