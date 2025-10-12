import os
import pandas as pd
from utils.streeteasy_data_tools import tidy_asking_rent 
from utils.psql_connection_tools import get_engine

#---------------------------------------------------
# 1. Downloading latest streeteasy data of rental prices
print("Downloading Asking Rent and Rental Index Data...")

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
print("Cleaning Datasets...")

# 2a. Cleaning Median Asking Rent DFs
rent_all_clean = tidy_asking_rent(df_rent_all)
rent_1bdr_clean = tidy_asking_rent(df_rent_1bdr)
rent_3bdr_clean = tidy_asking_rent(df_rent_3bdr)

#---------------------------------------------------
# 3. Merging Median Asking Rent Datasets
print("Merging Datasets...")

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

print('Final tables uploaded to Postgres!')