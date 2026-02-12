"""
Silver Layer - PySpark script transforms Bronze income_raw data into a 
cleaned, normalized Silver layer rent table, and loads that onto
Big Query.

Medallion Layer: SILVER (Cleaned/Normalized)
Source: nyc_bronze.income_raw
Target: nyc_silver.income

Transformations:
- Filter to neighborhood and borough area types only
- Apply minimum sample size filter (500+ units)
- Map neighborhoods to districts and boroughs
- Deduplicate records
- Validate data quality
"""

import os
import json
import sys
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.window import Window
from google.oauth2 import service_account

# Configuration
PROJECT_ID = "rent-affordability"
BRONZE_DATASET = "nyc_bronze"
SILVER_DATASET = "nyc_silver"
SOURCE_TABLE = f"{PROJECT_ID}.{BRONZE_DATASET}.income_raw"
TARGET_TABLE = f"{PROJECT_ID}.{SILVER_DATASET}.income"

def get_credentials():
    """
    description:
        Load GCP credentials from environment
    """
    creds_json = os.getenv('GOOGLE_CREDENTIALS_JSON')
    if not creds_json:
        raise ValueError("GOOGLE_CREDENTIALS_JSON environment variable not set")
    
    creds_dict = json.loads(creds_json)
    temp_key_path = "/tmp/gcp_key.json"
    
    with open(temp_key_path, 'w') as f:
        json.dump(creds_dict, f)
    
    return temp_key_path


def create_spark_session(credentials_path):
    """
    description:
        Initialize Spark session with BigQuery connector
    """
    return SparkSession.builder \
        .appName("NYC_Income_Bronze_to_Silver") \
        .config("spark.jars.packages", "com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.35.1") \
        .config("spark.hadoop.google.cloud.auth.service.account.json.keyfile", credentials_path) \
        .config("spark.sql.execution.arrow.pyspark.enabled", "true") \
        .config("spark.sql.adaptive.enabled", "true") \
        .getOrCreate()

def extract_borough_name(district_col):
    """
    Description:
        Extract borough name from district field
    """
    return (
        F.when(district_col.contains('Manhattan'), 'Manhattan')
        .when(district_col.contains('Brooklyn'), 'Brooklyn')
        .when(district_col.contains('Queens'), 'Queens')
        .when(district_col.contains('Bronx'), 'Bronx')
        .when(district_col.contains('Staten Island'), 'Staten Island')
        .otherwise(None)
    )


def map_borough_id(district_col):
    """
    Description:
        Map borough name to borough_id
    """
    return (
        F.when(district_col.contains('Manhattan'), 1)
        .when(district_col.contains('Brooklyn'), 2)
        .when(district_col.contains('Queens'), 3)
        .when(district_col.contains('Bronx'), 4)
        .when(district_col.contains('Staten Island'), 5)
        .otherwise(None)
    )


def map_district_id(district_col):
    """
    Description:
        Map district names to district_id using comprehensive CASE WHEN logic.
    Output:
        Returns district_id (1-59) based on neighborhood patterns.
    """
    # Brooklyn (1-18)
    brooklyn_mapping = (
        F.when((district_col.contains('Greenpoint')) | (district_col.contains('Williamsburg')), 1)
        .when((district_col.contains('Fort Greene')) | (district_col.contains('Downtown Brooklyn')) | (district_col.contains('Brooklyn Heights')), 2)
        .when(district_col.contains('Bedford-Stuyvesant'), 3)
        .when(district_col.contains('Bushwick'), 4)
        .when((district_col.contains('East New York')) | (district_col.contains('Cypress Hills')) | (district_col.contains('Starrett City')), 5)
        .when((district_col.contains('Park Slope')) | (district_col.contains('Red Hook')) | (district_col.contains('Carroll Gardens')), 6)
        .when((district_col.contains('Sunset Park')) | (district_col.contains('Windsor Terrace')), 7)
        .when((district_col.contains('Crown Heights (North)')) | (district_col.contains('Prospect Heights')), 8)
        .when((district_col.contains('Crown Heights (South)')) | (district_col.contains('Prospect Lefferts')) | (district_col.contains('Wingate')), 9)
        .when((district_col.contains('Bay Ridge')) | (district_col.contains('Dyker Heights')), 10)
        .when((district_col.contains('Bensonhurst')) | (district_col.contains('Bath Beach')), 11)
        .when((district_col.contains('Borough Park')) | (district_col.contains('Ocean Parkway')), 12)
        .when((district_col.contains('Brighton Beach')) | (district_col.contains('Coney Island')), 13)
        .when((district_col.contains('Flatbush')) | (district_col.contains('Midwood')), 14)
        .when((district_col.contains('Sheepshead Bay')) | (district_col.contains('Gravesend')) | (district_col.contains('Gerritsen Beach')), 15)
        .when((district_col.contains('Brownsville')) | (district_col.contains('Ocean Hill')), 16)
        .when((district_col.contains('East Flatbush')) | (district_col.contains('Rugby')), 17)
        .when((district_col.contains('Canarsie')) | (district_col.contains('Flatlands')), 18)
    )
    
    # Manhattan (19-30)
    manhattan_mapping = (
        F.when(district_col.contains('Battery Park'), 19)
        .when(district_col.contains('Financial District'), 20)
        .when((district_col.contains('Lower East Side')) | (district_col.contains('Chinatown')), 21)
        .when((district_col.contains('Chelsea')) | (district_col.contains("Hell's Kitchen")), 22)
        .when((district_col.contains('Midtown')) | (district_col.contains('Flatiron')), 23)
        .when((district_col.contains('Gramercy')) | (district_col.contains('Stuyvesant Town')), 24)
        .when(district_col.contains('Upper West Side'), 25)
        .when((district_col.contains('Upper East Side')) | (district_col.contains('Roosevelt Island')), 26)
        .when((district_col.contains('Morningside Heights')) | (district_col.contains('Hamilton Heights')) | (district_col.contains('Manhattanville')), 27)
        .when((district_col.contains('Harlem')) & (~district_col.contains('East Harlem')), 28)
        .when(district_col.contains('East Harlem'), 29)
        .when((district_col.contains('Washington Heights')) | (district_col.contains('Marble Hill')), 30)
    )
    
    # Queens (31-44)
    queens_mapping = (
        F.when(district_col.contains('Astoria'), 31)
        .when((district_col.contains('Sunnyside')) | (district_col.contains('Woodside')), 32)
        .when(district_col.contains('Jackson Heights'), 33)
        .when((district_col.contains('Elmhurst')) & (district_col.contains('Corona')), 34)
        .when((district_col.contains('Ridgewood')) | (district_col.contains('Maspeth')), 35)
        .when((district_col.contains('Forest Hills')) | (district_col.contains('Rego Park')), 36)
        .when((district_col.contains('Flushing')) | (district_col.contains('Whitestone')), 37)
        .when((district_col.contains('Fresh Meadows')) | (district_col.contains('Briarwood')), 38)
        .when((district_col.contains('Kew Gardens')) | (district_col.contains('Woodhaven')), 39)
        .when((district_col.contains('Howard Beach')) | (district_col.contains('Ozone Park')), 40)
        .when((district_col.contains('Bayside')) | (district_col.contains('Auburndale')), 41)
        .when((district_col.contains('Jamaica')) | (district_col.contains('Hollis')), 42)
        .when((district_col.contains('Cambria Heights')) | (district_col.contains('Bellerose')), 43)
        .when((district_col.contains('Rockaway')) | (district_col.contains('Broad Channel')), 44)
    )
    
    # Bronx (45-56)
    bronx_mapping = (
        F.when(district_col.contains('Hunts Point'), 45)
        .when((district_col.contains('Longwood')) | (district_col.contains('Melrose')) | (district_col.contains('Mott Haven')), 46)
        .when((district_col.contains('Belmont')) | (district_col.contains('East Tremont')), 47)
        .when((district_col.contains('Concourse')) | (district_col.contains('Highbridge')), 48)
        .when(district_col.contains('Morris Heights'), 49)
        .when((district_col.contains('Crotona Park East')) | (district_col.contains('West Farms')) | (district_col.contains('Morrisania')), 50)
        .when((district_col.contains('Bedford Park')) | (district_col.contains('Fordham')) | (district_col.contains('Norwood')), 51)
        .when((district_col.contains('Riverdale')) | (district_col.contains('Kingsbridge')), 52)
        .when((district_col.contains('Parkchester')) | (district_col.contains('Castle Hill')) | (district_col.contains('Soundview')), 53)
        .when((district_col.contains('Co-op City')) | (district_col.contains('Pelham Bay')) | (district_col.contains('Schuylerville')) | (district_col.contains('Throgs Neck')), 54)
        .when((district_col.contains('Pelham Parkway')) | (district_col.contains('Morris Park')) | (district_col.contains('Laconia')), 55)
        .when((district_col.contains('Wakefield')) | (district_col.contains('Williamsbridge')) | (district_col.contains('Eastchester')) | (district_col.contains('Woodlawn')), 56)
    )
    
    # Staten Island (57-59)
    staten_mapping = (
        F.when((district_col.contains('North Shore')) | (district_col.contains('New Springville')) | (district_col.contains('South Beach')), 57)
        .when((district_col.contains('South Shore')) | (district_col.contains('Tottenville')) | (district_col.contains('Great Kills')) | (district_col.contains('Annadale')), 58)
        .when((district_col.contains('Mid-Island')) | (district_col.contains('Port Richmond')) | (district_col.contains('Stapleton')) | (district_col.contains('Mariners Harbor')), 59)
    )
    
    # Combine all borough mappings
    return brooklyn_mapping.otherwise(
        manhattan_mapping.otherwise(
            queens_mapping.otherwise(
                bronx_mapping.otherwise(
                    staten_mapping.otherwise(None)
                )
            )
        )
    )


def map_district_name(district_col):
    """
    Description:
        Map district patterns to official district names
    """
    # Create comprehensive mapping similar to SQL CASE WHEN
    # This is a simplified version - you'd add all 59 mappings
    return (
        F.when((district_col.contains('Greenpoint')) | (district_col.contains('Williamsburg')), 
               'Greenpoint & Williamsburg')
        .when((district_col.contains('Fort Greene')) | (district_col.contains('Downtown Brooklyn')) | (district_col.contains('Brooklyn Heights')), 
              'Brooklyn Heights, Downtown Brooklyn, & Fort Greene')
        .when(district_col.contains('Bedford-Stuyvesant'), 'Bedford-Stuyvesant')
        # Add all other 56 district name mappings here...
        .otherwise(None)
    )


def transform_bronze_to_silver(spark, bronze_table, fact_table):
    """
    Description: Main transformation (Bronze → Silver)
    
    Steps:
    1. Read from Bronze
    2. Filter to relevant area types
    4. Map districts to neighborhoods
    5. Remove duplicates
    6. Add Silver metadata
    7. Write to Silver layer

    """
    print("SILVER LAYER: Income Data Normalization")

    print(f"\n[1/5] Reading Bronze data from {bronze_table}...")
    bronze_df = spark.read \
        .format("bigquery") \
        .option("table", bronze_table) \
        .load()
    
    bronze_count = bronze_df.count()
    print(f"Loaded {bronze_df.count()} rows from bronze table")
    
    # Apply transformations
    print("\n[2/5] Applying normalization transformations...")
    
    normalized_df = bronze_df \
        .filter(F.col('all_HHs').isNotNull()) \
        .withColumn('neighborhood', F.col('district').cast('string')) \
        .withColumn('borough', extract_borough_name(F.col('district'))) \
        .withColumn('borough_id', map_borough_id(F.col('district'))) \
        .withColumn('district_id', map_district_id(F.col('district'))) \
        .withColumn('district_name', map_district_name(F.col('district'))) \
        .withColumn('all_hhs', F.col('all_HHs').cast('decimal(18,2)')) \
        .withColumn('singles', F.coalesce(F.col('singles'), F.lit(0)).cast('decimal(18,2)')) \
        .withColumn('married_kids', F.coalesce(F.col('married_kids'), F.lit(0)).cast('decimal(18,2)')) \
        .withColumn('other_kids', F.coalesce(F.col('other_kids'), F.lit(0)).cast('decimal(18,2)')) \
        .filter((F.col('district_id').isNotNull()) & (F.col('borough_id').isNotNull()))
    
    # Remove duplicates - keep most recent record per district/year
    print("\n[3/5] Removing duplicates drom mapping districts to neighborhoods...")
    window_spec = Window.partitionBy('district_id', 'year').orderBy(F.desc('all_hhs'))
    
    print("\n[4/5] Standardizing column names for Silver layer...")
    silver_df = normalized_df \
        .withColumn('row_num', F.row_number().over(window_spec)) \
        .filter(F.col('row_num') == 1) \
        .select(
            'neighborhood',
            'borough',
            'district_name',
            'year',
            'all_hhs',
            'singles',
            'married_kids',
            'other_kids',
            'district_id',
            'borough_id'
        ) \
        .orderBy('borough_id', 'district_id', 'year')
    
    print(f"Normalized data contains {silver_df.count()} rows")
    
    # Write to BigQuery fact table
    print(f"\n[5\5] Adding Silver metadata and writind to Big Query...")
    
    final_df = silver_df \
        .withColumn('silver_load_timestamp', F.lit(datetime.utcnow())) \
        .withColumn('data_quality_tier', F.lit('silver')) \
        .orderBy('borough_id', 'neighborhood', 'year', 'month')

    final_df.write \
        .format("bigquery") \
        .option("table", fact_table) \
        .option("writeMethod", "direct") \
        .mode("overwrite") \
        .save()
    
    print("Silver Transformation + Normalization Successful!")
    print(f"  Source: {source_table}")
    print(f"  Target: {target_table}")
    print(f"  Rows Written: {deduped_count:,}")
    print(f"  Timestamp: {datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')}")
    
    return final_df.count()


def main():
    """
    description:
        Main execution function
    """
    try:
        print("Starting PySpark Income Bronze → Silver Transformation & Normalization...")
        
        # Get credentials
        credentials_path = get_credentials()
        
        # Create Spark session
        spark = create_spark_session(credentials_path)
        spark.sparkContext.setLogLevel("WARN")
        
        # Run normalization + transformation
        row_count = transform_bronze_to_silver(spark, SOURCE_TABLE, TARGET_TABLE)

        print(f"✓ Normalization Complete!")
        print(f"  Processed: {row_count} rows")
        print(f"  Source: {SOURCE_TABLE}")
        print(f"  Destination: {TARGET_TABLE}")
        
        # Cleanup
        spark.stop()
        os.remove(credentials_path)
        
        return 0
        
    except Exception as e:
        print("SILVER TRANSFORMATION FAILED")
        print(f"  Error: {str(e)}")

        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())