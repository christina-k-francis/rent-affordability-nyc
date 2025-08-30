""" 
    2010 U.S. Census PUMA definitions were used 2012-2021
    2020 U.S. Census PUMA definitions are used 2022-present
"""

import os
import pandas as pd
from utils.us_census_data_tools import calc_acs_inflation_ratio, inflate_acs_data, Import_ACS_Table
from utils.psql_connection_tools import get_engine


ACS_Tables = [
    'B19013_001E',  # All HHs - median income
    'B19202_001E',  # 1-person HH - median income
    'B19131_002E',  # Married HHs w/ children - median income
    'B19131_005E',  # Other HHs w/ children - median income (foster, grandparents, etc.)
    ]

#---------------------------------------------------
# 1. Importing Median Income for All Households (B19013_001E)

print('Downloading Median Income for All HHs...')
median_HH_income_all = Import_ACS_Table(os.getenv('CENSUS_API'), 36,
                                        ACS_Tables[0])

#---------------------------------------------------
# 2. Importing Median Income for Single Adult Households (B19202_001E)

print("Downloading Median Income for Single Adult HHs...")
median_HH_income_singles = Import_ACS_Table(os.getenv('CENSUS_API'), 36,
                                            ACS_Tables[1])

#---------------------------------------------------
# 3. Importing Median Income for Married Households w/ Children (B19131_002E)

print("Downloading Median Income for Married HHs w/ Children...")
median_HH_income_married_kids = Import_ACS_Table(os.getenv('CENSUS_API'), 36,
                                            ACS_Tables[2])

#---------------------------------------------------
# 4. Importing Median Income for Other Households w/ Children (B19131_005E)

print("Downloading Median Income for Other HHs w/ Children...")
median_HH_income_other_kids = Import_ACS_Table(os.getenv('CENSUS_API'), 36,
                                            ACS_Tables[3])

#---------------------------------------------------
# 5. Deflating ACS Income Data to Re-Introduce Inflation Effects

df_Retro_CPI = pd.read_excel("C:/Users/Chris/OneDrive/Documents/"
                             "Professional_Important/Comp_Sci_Journey/"
                             "NYC_Rent_Affordability_Investigation/"
                             "r-cpi-u-rs-allitems.xlsx", header=5, 
                             engine='calamine', index_col=0)

inflation_lookup = calc_acs_inflation_ratio(df_Retro_CPI, inflation_impact=False)

# 5a. Inflating median income for ALL HHs
# Remove rows with missing income data
all_deflated = median_HH_income_all.loc[median_HH_income_all['B19013_001E'].notnull()]
# reintroduce inflation to income values
all_inflated = inflate_acs_data(all_deflated,
                                inflation_lookup,
                                'B19013_001E')

# 5b. Inflating median income for Single Adult HHs
# Remove rows with missing income data
singles_deflated = median_HH_income_singles.loc[median_HH_income_singles['B19202_001E'].notnull()]
# reintroduce inflation to income values
singles_inflated = inflate_acs_data(singles_deflated,
                                inflation_lookup,
                                'B19202_001E')

# 5c. Inflating median income for Married HHs w/ Children
# Remove rows with missing income data
married_kids_deflated = median_HH_income_married_kids.loc[median_HH_income_married_kids['B19131_002E'].notnull()]
# reintroduce inflation to income values
married_kids_inflated = inflate_acs_data(married_kids_deflated,
                                inflation_lookup,
                                'B19131_002E')

# 5d. Inflating median income for Other HHs w/ Children
# Remove rows with missing income data
other_kids_deflated = median_HH_income_other_kids.loc[median_HH_income_other_kids['B19131_005E'].notnull()]
# reintroduce inflation to income values
other_kids_inflated = inflate_acs_data(other_kids_deflated,
                                inflation_lookup,
                                'B19131_005E')

# 6. Merging tables with income data
inflated_tables = [all_inflated, singles_inflated,
                   married_kids_inflated,
                   other_kids_inflated]

for idx, table in enumerate(inflated_tables):
    if idx == 0:
        merged_table = pd.merge(table, inflated_tables[idx+1], how='inner',
                                on=['NAME','public use microdata area', 'year', 'state','AVG','DEC','Inflation_Ratio']
                                )
    elif idx == (len(inflated_tables)-1):
        print('Merging Tables Complete!')
    else:
        merged_table = pd.merge(merged_table, inflated_tables[idx+1], how='inner', # type: ignore
                                on=['NAME','public use microdata area', 'year', 'state','AVG','DEC','Inflation_Ratio']
                                )

# 7a. Rename columns for easier querying
merged_table.rename(columns={"AVG":"annual_avg_cpi", "DEC":"dec_cpi", # pyright: ignore[reportPossiblyUnboundVariable]
                             "B19013_001E":"all_deflated","B19013_001E_nominal":"all_nominal",
                             "B19202_001E":"singles_deflated","B19202_001E_nominal":"singles_nominal",
                             "B19131_002E":"married_kids_deflated","B19131_002E_nominal":"married_kids_nominal",
                             "B19131_005E":"other_kids_deflated","B19131_005E_nominal":"other_kids_nominal"
}, inplace=True)

# 7b. Reordering columns for logical organization
cols = list(merged_table.columns) # type: ignore
# moving deflated cols next to nominal cols
cols.insert(8, cols[1]) 
del cols[1]
del cols[cols.index('state')]
final_table = merged_table[cols] # type: ignore

# 8. Uploading Finalized Datatable to PostgreSQL DB
engine = get_engine('postgres',
                    os.getenv('PSQL_PWD'),
                    'localhost',
                    '5432',
                    'rent_affordability')

final_table.to_sql('median_income', con=engine, 
                   if_exists='replace', index=False)
print('Final table uploaded to Postgres!')
# Complete!