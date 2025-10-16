"""
Functions for Transforming Data for Exploratory Data Analysis
"""
from datetime import datetime
from dateutil.relativedelta import relativedelta

def find_continuous_periods(date_list):
    """
    Find continuous periods of time in a list of YYYY-MM date strings.
    
    Inputs:
        date_list (list): List of date strings in 'YYYY-MM' format
    
    Outputs:
        list: List of strings representing continuous periods
              Single dates: 'YYYY-MM'
              Ranges: 'YYYY-MM to YYYY-MM'
    """
    if not date_list:
        return []
    
    # Convert strings to datetime objects and sort
    dates = []
    for date_str in date_list:
        try:
            date_obj = datetime.strptime(date_str, '%Y-%m')
            dates.append(date_obj)
        except ValueError:
            print(f"Warning: Invalid date format '{date_str}', skipping...")
            continue
    
    if not dates:
        return []
    
    dates.sort()
    
    periods = []
    start_date = dates[0]
    end_date = dates[0]
    
    for i in range(1, len(dates)):
        current_date = dates[i]
        # Check if current date is consecutive to the end_date
        next_expected = end_date + relativedelta(months=1)
        
        if current_date == next_expected:
            # Extend the current period
            end_date = current_date
        else:
            # End the current period and start a new one
            if start_date == end_date:
                periods.append(start_date.strftime('%Y-%m'))
            else:
                periods.append(f"{start_date.strftime('%Y-%m')} to {end_date.strftime('%Y-%m')}")
            
            start_date = current_date
            end_date = current_date
    
    # Handle the last period
    if start_date == end_date:
        periods.append(start_date.strftime('%Y-%m'))
    else:
        periods.append(f"{start_date.strftime('%Y-%m')} to {end_date.strftime('%Y-%m')}")
    
    return periods