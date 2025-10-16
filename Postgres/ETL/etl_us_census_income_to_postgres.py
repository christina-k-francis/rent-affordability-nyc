""" 
    2010 U.S. Census PUMA definitions were used 2012-2021
    2020 U.S. Census PUMA definitions are used 2022-present
"""

import os
import pandas as pd
from utils.us_census_data_tools import Import_ACS_Table
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

# 5. Merging tables with income data
income_dfs = [median_HH_income_all,
              median_HH_income_singles,
              median_HH_income_other_kids,
              median_HH_income_married_kids
]

for idx, df in enumerate(income_dfs):
    if idx == 0:
        merged_table = pd.merge(df, income_dfs[idx+1], how='outer',
                                on=['NAME','public use microdata area', 'year', 'state']
                                )
    elif idx == (len(income_dfs)-1):
        break
    else:
        merged_table = pd.merge(merged_table, income_dfs[idx+1], how='outer', # type: ignore
                                on=['NAME','public use microdata area', 'year', 'state']
                                )

# 5b. Rename columns for easier querying
merged_table.rename(columns={"B19013_001E":"income_all_HHs",
                             "B19202_001E":"income_singles",
                             "B19131_002E":"income_married_kids",
                             "B19131_005E":"income_other_kids"
}, inplace=True)

# 5c. Reordering columns for logical organization
cols = list(merged_table.columns)
# move income columns to right side of df
cols.insert(5, cols[1])
del cols[1]
final_table = merged_table[cols]

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