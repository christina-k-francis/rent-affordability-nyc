import pandas as pd
from utils.streeteasy_data_tools import tidy_asking_rent, tidy_rent_index
from utils.psql_connection_tools import get_engine

#---------------------------------------------------
# 1. Downloading latest streeteasy data of rental prices

# Streeteasy's Rental Index, measuring changes in rent prices across all APT sizes
df_rent_index = pd.read_csv("https://cdn-charts.streeteasy.com/rentals"
                            "/All/rentalIndex_All.zip", compression='zip')

# Median asking rent for All APT sizes
df_rent_all = pd.read_csv("https://cdn-charts.streeteasy.com/rentals/"
                          "All/medianAskingRent_All.zip", compression='zip')

# Median asking rent for 1-Bedroom APTs
df_rent_1bdr = pd.read_csv("https://cdn-charts.streeteasy.com/rentals/"
                           "OneBd/medianAskingRent_OneBd.zip", compression='zip')

# Median asking rent for 3-Bedroom (or More APTs
df_rent_3bdr = pd.read_csv("https://cdn-charts.streeteasy.com/rentals/"
                           "ThreePlusBd/medianAskingRent_ThreePlusBd.zip",
                            compression='zip')

#---------------------------------------------------
# 2. Cleaning up all datasets

# 2a. Cleaning Median Asking Rent DFs
rent_all_clean = tidy_asking_rent(df_rent_all)
rent_1bdr_clean = tidy_asking_rent(df_rent_1bdr)
rent_3bdr_clean = tidy_asking_rent(df_rent_3bdr)

# 2b. Cleaning Rent Index DF
rent_index_clean = tidy_rent_index(df_rent_index)

#---------------------------------------------------
# 3. Merging Median Asking Rent Datasets

merged_table = pd.merge(rent_all_clean.rename(columns={"median_rent":"all_apts"}), 
                        rent_1bdr_clean.rename(columns={"median_rent":"1bdr_apts"}), 
                        how='inner', on=["area_name", "borough", "area_type","year","month"]
                        )

median_rent_table = pd.merge(merged_table, 
                        rent_3bdr_clean.rename(columns={"median_rent":"3bdr_apts"}), 
                        how='inner', on=["area_name", "borough", "area_type","year","month"]
                        )

#---------------------------------------------------
# 4. Uploading Finalized Dataframes to PostgreSQL DB!

engine = get_engine('postgres',
                    os.getenv('PSQL_PWD'),
                    'localhost',
                    '5432',
                    'rent_affordability')

median_rent_table.to_sql('median_rent', con=engine, 
                   if_exists='replace', index=False)

rent_index_clean.to_sql('rent_index', con=engine,
                        if_exists='replace', index=False
                        )

print('Final tables uploaded to Postgres!')

































# I can validate the StreetEasy rent data by looking at U.S. Census data
import requests
import time
import os

import pandas as pd
MAX_RETRIES = 5
#---------------------------------------------------
# 0. Defining Data Query Variables

# Census API key
API_KEY = os.getenv("CENSUS_API2")
# Available years of 1-year ACS data (update as needed)
years = list(range(2012,2023))
years_2012up = list(range(2012, 2022))
years_2021up = list(range(2021,2023)) 
years.remove(2020) #pandemic data gap
# New York State FIPS
state_fips = "36"
# Public-Use Microdata Areas - NYC
PUMS_2020 = [# Manhattan - 10 areas
             '04103', '04104', '04107', '04108', '04109', '04110', '04111', 
             '04112','04121', '04165',
             # Brooklyn - 18 areas
             '04301', '04302', '04303', '04304', '04305', '04306', '04307', 
             '04308','04309', '04310', '04311', '04312', '04313', '04314', 
             '04315', '04316','04317', '04318',
             # Queens - 14 areas
             '04401', '04402', '04403', '04404', '04405', '04406', '04407', 
             '04408','04409', '04410', '04411', '04412', '04413', '04414']

PUMS_2010 = [# Manhattan - 10 areas
             '03801', '03802', '03803', '03804', '03805', '03806', '03807', 
             '03808','03809', '03810',
             # Brooklyn - 18 areas
             '04001', '04002', '04003', '04004', '04005', '04006', '04007', 
             '04008', '04009', '04010', '04011', '04012', '04013', '04014', 
             '04015', '04016', '04017', '04018',
             # Queens - 14 areas
             '04101', '04102', '04103', '04104', '04105', '04106', '04107', 
             '04108', '04109', '04110', '04111', '04112', '04113', '04114'

    ]

#---------------------------------------------------
# 1. Importing Median Gross Rent (B25064_001E)

rent_data = []
missing_rent_year = []

print('processing historical median rent')
# 2010s
for year in years:
    print(f'downloading {year}')
    url = (
        f"https://api.census.gov/data/{year}/acs/acs1?get=NAME,B25064_001E"
        f"&for=public%20use%20microdata%20area:*&in=state:{state_fips}"
        f"&key={API_KEY}"
        )
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            response = requests.get(url)
            if response.status_code == 200:
                # Debug: check content type and first few characters
                print(f"Content-Type: {response.headers.get('content-type')}")
                print(f"First 50 chars: {response.text[:50]}")
                
                # Verify it's actually JSON before parsing
                if response.headers.get('content-type', '').startswith('application/json'):
                    data = response.json()
                    cols = data[0]
                    rows = data[1:]
                    df = pd.DataFrame(rows, columns=cols)
                    df["year"] = year
                    rent_data.append(df)
                    break
                else:
                    print(f"Unexpected content type, response: {response.text[:200]}")
                    missing_rent_year.append(year)
                    break
            else:
                print(f'request failure, code {response.status_code}')
                missing_rent_year.append(year)
                break
        except requests.exceptions.RequestException as e:
            print(f"Request error on try {attempt}/{MAX_RETRIES}: {e}")
        except ValueError as e:  # JSON decode error
            print(f"JSON decode error on try {attempt}/{MAX_RETRIES}: {e}")
            print(f"Response content: {response.text[:200]}")
        except Exception as e:
            print(f"Unexpected error on try {attempt}/{MAX_RETRIES}: {e}")
        
        if attempt < MAX_RETRIES:
            wait_time = 2 ** attempt
            print(f"Waiting {wait_time} seconds before retry...")
            time.sleep(wait_time)

# create dataframe
df_rent = pd.concat(rent_data, ignore_index=True)
# Subsetting PUMAs using 2010 and 2020 definitions
cond_1 = df_rent['year'].isin(years_2012up) 
cond_2 = df_rent['public use microdata area'].isin(PUMS_2010)
early_rent_data = df_rent[cond_1 & cond_2]
cond_1 = df_rent['year'].isin(years_2021up) 
cond_2 = df_rent['public use microdata area'].isin(PUMS_2020)
recent_rent_data = df_rent[cond_1 & cond_2]
# merge to create a DF of all pertinent data
nyc_rent_data = pd.merge(early_rent_data, recent_rent_data, how='outer')