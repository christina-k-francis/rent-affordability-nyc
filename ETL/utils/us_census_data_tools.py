# -*- coding: utf-8 -*-
"""
Created on Wed Aug 27 20:47:04 2025

@author: Chris
"""

import pandas as pd
import requests
import time

"""
Helpful functions for downloading U.S. Census ACS data, calculating inflation ratios, 
and re-inflating constant dollar income values to nominal dollars.
"""

#---------------------------------------------------
# Essential variables
MAX_RETRIES = 5

# Available years of 1-year ACS data (update as needed)
years = list(range(2012,2023))
years_2012up = list(range(2012, 2022))
years_2021up = list(range(2021,2023)) 
years.remove(2020) #pandemic data gap

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
             '04408','04409', '04410', '04411', '04412', '04413', '04414',
             # Bronx - 10 areas
             '04204', '04205', '04207', '04208', '04209', '04210', '04211',
             '04212', '04221', '04263',
             # Staten Island - 3 areas
             '04501', '04502', '04503']

PUMS_2010 = [# Manhattan - 10 areas
             '03801', '03802', '03803', '03804', '03805', '03806', '03807', 
             '03808','03809', '03810',
             # Brooklyn - 18 areas
             '04001', '04002', '04003', '04004', '04005', '04006', '04007', 
             '04008', '04009', '04010', '04011', '04012', '04013', '04014', 
             '04015', '04016', '04017', '04018',
             # Queens - 14 areas
             '04101', '04102', '04103', '04104', '04105', '04106', '04107', 
             '04108', '04109', '04110', '04111', '04112', '04113', '04114',
             # Bronx - 10 areas
             '03701', '03702', '03703', '03704', '03705', '03706', '03707',
             '03708', '03709', '03710',
             # Staten Island - 3 areas
             '03901', '03902', '03903']


#---------------------------------------------------
# The functions!

def Import_ACS_Table(API_KEY, state_fips, ACS_table_name):
    income_data = []
    missing_income_year = []
    
    for year in years:
        #print(f'downloading {year}')
        url = (
            f"https://api.census.gov/data/{year}/acs/acs1?get=NAME,{ACS_table_name}"
            f"&for=public%20use%20microdata%20area:*&in=state:{state_fips}"
            f"&key={API_KEY}"        
            )
        for attempt in range(1, MAX_RETRIES + 1):
            try:
                response = requests.get(url)
                if response.status_code == 200:
                    if response.headers.get('content-type', '').startswith('application/json'):
                        data = response.json()
                        cols = data[0]
                        rows = data[1:]
                        df = pd.DataFrame(rows, columns=cols)
                        df["year"] = year
                        income_data.append(df)
                        break
                    else:
                        print(f"Unexpected content type, response: {response.text[:200]}")
                        missing_income_year.append(year)
                        break
                else:
                    print(f'request failure, code {response.status_code}')
                    missing_income_year.append(year)
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

    # Highlighting missing data
    if len(missing_income_year) > 0:
        print(f'Years w/ missing data:{missing_income_year}')

    # Create Dataframe
    df_income = pd.concat(income_data, ignore_index=True)
    # Subsetting PUMAs using 2010 and 2020 definitions
    cond_1 = df_income['year'].isin(years_2012up) 
    cond_2 = df_income['public use microdata area'].isin(PUMS_2010)
    early_income_data = df_income[cond_1 & cond_2]
    cond_1 = df_income['year'].isin(years_2021up) 
    cond_2 = df_income['public use microdata area'].isin(PUMS_2020)
    recent_income_data = df_income[cond_1 & cond_2]
    # merge to create a DF of all pertinent data
    return pd.merge(early_income_data, recent_income_data, how='outer')

######################################
def create_affordability_comparison(inflated_income_df, streeteasy_df, 
                                  income_col, rent_col='median_rent', 
                                  year_column='year'):
    """
    Create affordability comparison using inflated (nominal) ACS income vs StreetEasy rent.
    Both datasets now use nominal/inflated dollar values for proper comparison.
    
    Parameters:
    inflated_income_df: DataFrame with inflated ACS income data
    streeteasy_df: DataFrame with StreetEasy rent data
    income_col: Base name of income column to use
    rent_col: Name of rent column in streeteasy_df
    year_column: Name of year column
    
    Returns:
    DataFrame with affordability metrics
    """
    
    # Use nominal/inflated income for comparison
    nominal_income_col = f"{income_col}_nominal"
    
    # Merge datasets
    affordability_df = inflated_income_df.merge(streeteasy_df, on=year_column, how='inner')
    
    # Calculate affordability metrics
    affordability_df['monthly_income'] = affordability_df[nominal_income_col] / 12
    affordability_df['rent_to_income_ratio'] = (
        affordability_df[rent_col] / affordability_df['monthly_income']
    )
    affordability_df['affordable_rent_30pct'] = affordability_df['monthly_income'] * 0.30
    affordability_df['affordability_gap'] = (
        affordability_df[rent_col] - affordability_df['affordable_rent_30pct']
    )
    affordability_df['is_affordable_30pct'] = affordability_df['rent_to_income_ratio'] <= 0.30
    
    print("Affordability Analysis (Nominal/Inflated Dollars):")
    print("=" * 60)
    print("Using inflated ACS income vs. StreetEasy nominal rents")
    print("Both datasets now use current-year dollar values (not adjusted for inflation)")
    
    summary = affordability_df.groupby(year_column).agg({
        'rent_to_income_ratio': ['mean', 'median'],
        'affordability_gap': ['mean', 'median'], 
        'is_affordable_30pct': 'mean'
    }).round(3)
    
    print(summary)
    
    return affordability_df

