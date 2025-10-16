"""
Helpful functions for tidying Median Asking Rent and
Rent Index data from the StreetEasy Data Dashboard
"""

import pandas as pd

def tidy_asking_rent(original_df):
    # Initial Melt using pandas built-in FX
    df_melted = original_df.melt(id_vars=(original_df.columns[:3]))
    # splitting year-month into separate columns
    year = df_melted['variable'].str.split('-', expand=True).loc[:,0]
    month = df_melted['variable'].str.split('-', expand=True).loc[:,1]
    df_melted.insert(0, 'month', month)
    df_melted.insert(0, 'year', year)

    # Renaming Columns
    df_melted.rename(columns={"areaName":"area_name","areaType":"area_type", 
                            "value":"median_rent", "Borough":"borough"},
                              inplace=True)

    # Reorganizing columns, Deleting those no longer needed
    cols = list(df_melted.columns)
    del cols[cols.index('variable')]
    # Placing neighborhood/borough names before dates
    cols.insert(5, cols[0])
    cols.insert(6, cols[1])
    del cols[0], cols[0]
    
    return df_melted[cols]

def tidy_rent_index(original_df):
    # Splitting the year-month-day column into separate year and month columns
    year = original_df['Month'].str.split('-', expand=True).iloc[:,0]
    month = original_df['Month'].str.split('-', expand=True).iloc[:,1]
    # removing original date column, before inserting new ones
    df_modified = original_df[original_df.columns[1:]]
    df_modified.insert(0, 'month', month)
    df_modified.insert(0, 'year', year)

    # Melting DF using pandas built-in function
    df_melted = df_modified.melt(id_vars=['year','month'],
                               value_vars=df_modified.columns[2:])
    
    # Renaming Columns
    df_melted.rename(columns={"variable":"area_name",
                           "value":"rent_index"}, 
                           inplace=True)
    
    return df_melted