"""
Silver Layer - PySpark script transforms Bronze rent_raw data into a 
cleaned, normalized Silver layer rent table, and loads that onto
Big Query.

Medallion Layer: SILVER (Cleaned/Normalized)
Source: nyc_bronze.rent_raw
Target: nyc_silver.rent

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
from datetime import datetime
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Configuration
PROJECT_ID = "rent-affordability"
BRONZE_DATASET = "nyc_bronze"
SILVER_DATASET = "nyc_silver"
SOURCE_TABLE = f"{PROJECT_ID}.{BRONZE_DATASET}.rent_raw"
TARGET_TABLE = f"{PROJECT_ID}.{SILVER_DATASET}.rent"

# Minimum sample size for reliable rent statistics
MIN_SAMPLE_SIZE = 500


def get_credentials():
    """Load GCP credentials from environment"""
    creds_json = os.getenv('GOOGLE_CREDENTIALS_JSON')
    if not creds_json:
        raise ValueError("GOOGLE_CREDENTIALS_JSON environment variable not set")
    
    creds_dict = json.loads(creds_json)
    temp_key_path = "/tmp/gcp_key.json"
    
    with open(temp_key_path, 'w') as f:
        json.dump(creds_dict, f)
    
    return temp_key_path


def create_spark_session(credentials_path):
    """Initialize Spark session with BigQuery connector"""
    return SparkSession.builder \
        .appName("NYC_Rent_Bronze_to_Silver") \
        .config("spark.jars.packages", "com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.35.1") \
        .config("spark.hadoop.google.cloud.auth.service.account.json.keyfile", credentials_path) \
        .config("spark.sql.execution.arrow.pyspark.enabled", "true") \
        .config("spark.sql.adaptive.enabled", "true") \
        .getOrCreate()


def map_borough_id(borough_col):
    """Map borough name to borough_id"""
    return (
        F.when(borough_col == 'Manhattan', 1)
        .when(borough_col == 'Brooklyn', 2)
        .when(borough_col == 'Queens', 3)
        .when(borough_col == 'Bronx', 4)
        .when(borough_col == 'Staten Island', 5)
        .otherwise(None)
    )


def map_neighborhood_to_district(area_name_col, borough_col):
    """
    Map neighborhood names to district_id (1-59)
    Based on NYC community district boundaries
    """
    # Brooklyn Districts (1-18)
    brooklyn = (
        F.when((area_name_col == 'Greenpoint') | (area_name_col == 'Williamsburg'), 1)
        .when((area_name_col == 'Fort Greene') | (area_name_col == 'Downtown Brooklyn') | (area_name_col == 'Brooklyn Heights'), 2)
        .when(area_name_col == 'Bedford-Stuyvesant', 3)
        .when(area_name_col == 'Bushwick', 4)
        .when((area_name_col == 'East New York') | (area_name_col == 'Cypress Hills'), 5)
        .when((area_name_col == 'Park Slope') | (area_name_col == 'Carroll Gardens') | (area_name_col == 'Red Hook'), 6)
        .when((area_name_col == 'Sunset Park') | (area_name_col == 'Windsor Terrace'), 7)
        .when((area_name_col == 'Crown Heights') | (area_name_col == 'Prospect Heights'), 8)
        .when((area_name_col == 'Prospect Lefferts Gardens') | (area_name_col == 'Wingate'), 9)
        .when((area_name_col == 'Bay Ridge') | (area_name_col == 'Dyker Heights'), 10)
        .when((area_name_col == 'Bensonhurst') | (area_name_col == 'Bath Beach'), 11)
        .when((area_name_col == 'Borough Park') | (area_name_col == 'Kensington'), 12)
        .when((area_name_col == 'Brighton Beach') | (area_name_col == 'Coney Island'), 13)
        .when((area_name_col == 'Flatbush') | (area_name_col == 'Midwood'), 14)
        .when((area_name_col == 'Sheepshead Bay') | (area_name_col == 'Gravesend'), 15)
        .when((area_name_col == 'Brownsville') | (area_name_col == 'Ocean Hill'), 16)
        .when((area_name_col == 'East Flatbush') | (area_name_col == 'Farragut'), 17)
        .when((area_name_col == 'Canarsie') | (area_name_col == 'Flatlands'), 18)
    )
    
    # Manhattan Districts (19-30)
    manhattan = (
        F.when((area_name_col == 'Battery Park City') | (area_name_col == 'Financial District'), 19)
        .when(area_name_col == 'Tribeca', 20)
        .when((area_name_col == 'Lower East Side') | (area_name_col == 'Chinatown'), 21)
        .when((area_name_col == 'Chelsea') | (area_name_col == "Hell's Kitchen"), 22)
        .when((area_name_col == 'Midtown') | (area_name_col == 'Midtown East'), 23)
        .when((area_name_col == 'Gramercy') | (area_name_col == 'Stuyvesant Town'), 24)
        .when(area_name_col == 'Upper West Side', 25)
        .when((area_name_col == 'Upper East Side') | (area_name_col == 'Roosevelt Island'), 26)
        .when((area_name_col == 'Morningside Heights') | (area_name_col == 'Hamilton Heights'), 27)
        .when((area_name_col == 'Harlem') | (area_name_col == 'Central Harlem'), 28)
        .when(area_name_col == 'East Harlem', 29)
        .when((area_name_col == 'Washington Heights') | (area_name_col == 'Inwood'), 30)
    )
    
    # Queens Districts (31-44)
    queens = (
        F.when((area_name_col == 'Astoria') | (area_name_col == 'Long Island City'), 31)
        .when((area_name_col == 'Sunnyside') | (area_name_col == 'Woodside'), 32)
        .when(area_name_col == 'Jackson Heights', 33)
        .when((area_name_col == 'Elmhurst') | (area_name_col == 'Corona'), 34)
        .when((area_name_col == 'Ridgewood') | (area_name_col == 'Maspeth'), 35)
        .when((area_name_col == 'Forest Hills') | (area_name_col == 'Rego Park'), 36)
        .when((area_name_col == 'Flushing') | (area_name_col == 'Whitestone'), 37)
        .when((area_name_col == 'Fresh Meadows') | (area_name_col == 'Briarwood'), 38)
        .when((area_name_col == 'Kew Gardens') | (area_name_col == 'Woodhaven'), 39)
        .when((area_name_col == 'Howard Beach') | (area_name_col == 'Ozone Park'), 40)
        .when((area_name_col == 'Bayside') | (area_name_col == 'Auburndale'), 41)
        .when((area_name_col == 'Jamaica') | (area_name_col == 'Hollis'), 42)
        .when((area_name_col == 'Cambria Heights') | (area_name_col == 'Queens Village'), 43)
        .when((area_name_col == 'Rockaway') | (area_name_col == 'Broad Channel'), 44)
    )
    
    # Bronx Districts (45-56)
    bronx = (
        F.when(area_name_col == 'Hunts Point', 45)
        .when((area_name_col == 'Longwood') | (area_name_col == 'Mott Haven'), 46)
        .when((area_name_col == 'Belmont') | (area_name_col == 'East Tremont'), 47)
        .when((area_name_col == 'Concourse') | (area_name_col == 'Highbridge'), 48)
        .when(area_name_col == 'Morris Heights', 49)
        .when((area_name_col == 'Morrisania') | (area_name_col == 'Crotona Park'), 50)
        .when((area_name_col == 'Bedford Park') | (area_name_col == 'Fordham'), 51)
        .when((area_name_col == 'Riverdale') | (area_name_col == 'Kingsbridge'), 52)
        .when((area_name_col == 'Soundview') | (area_name_col == 'Parkchester'), 53)
        .when((area_name_col == 'Co-op City') | (area_name_col == 'Pelham Bay'), 54)
        .when((area_name_col == 'Pelham Parkway') | (area_name_col == 'Morris Park'), 55)
        .when((area_name_col == 'Wakefield') | (area_name_col == 'Williamsbridge'), 56)
    )
    
    # Staten Island Districts (57-59)
    staten = (
        F.when((area_name_col == 'North Shore') | (area_name_col == 'St. George'), 57)
        .when((area_name_col == 'South Shore') | (area_name_col == 'Tottenville'), 58)
        .when((area_name_col == 'Mid-Island') | (area_name_col == 'New Springville'), 59)
    )
    
    # Apply mappings based on borough
    return (
        F.when(borough_col == 'Brooklyn', brooklyn)
        .when(borough_col == 'Manhattan', manhattan)
        .when(borough_col == 'Queens', queens)
        .when(borough_col == 'Bronx', bronx)
        .when(borough_col == 'Staten Island', staten)
        .otherwise(None)
    )


def transform_bronze_to_silver(spark, source_table, target_table):
    """
    Main transformation logic: Bronze → Silver
    
    Steps:
    1. Read from Bronze
    2. Filter to relevant area types
    3. Apply sample size filters
    4. Map to borough/district IDs
    5. Remove duplicates
    6. Add Silver metadata
    7. Write to Silver layer
    """
    
    print("SILVER LAYER: Rent Data Normalization")
    
    # Step 1: Read from Bronze
    print(f"\n[1/7] Reading Bronze data from {source_table}...")
    bronze_df = spark.read \
        .format("bigquery") \
        .option("table", source_table) \
        .load()
    
    bronze_count = bronze_df.count()
    print(f"Loaded {bronze_count:,} rows from Bronze layer")
    
    # Step 2: Filter to neighborhood and borough area types only
    print("\n[2/7] Filtering to relevant area types (neighborhood, borough)...")
    filtered_df = bronze_df.filter(
        (F.col('area_type') == 'neighborhood') | (F.col('area_type') == 'borough')
    )
    
    filtered_count = filtered_df.count()
    print(f"Filtered to {filtered_count:,} rows ({bronze_count - filtered_count:,} excluded)")
    
    # Step 3: Apply sample size filters for data quality
    print(f"\n[3/7] Applying minimum sample size filter (>= {MIN_SAMPLE_SIZE} units)...")
    
    quality_df = filtered_df \
        .withColumn('all_price',
                   F.when(F.col('all_count') >= MIN_SAMPLE_SIZE, F.col('all_price'))
                   .otherwise(None)) \
        .withColumn('1bdr_price',
                   F.when(F.col('1bdr_count') >= MIN_SAMPLE_SIZE, F.col('1bdr_price'))
                   .otherwise(None)) \
        .withColumn('3bdr_price',
                   F.when(F.col('3bdr_count') >= MIN_SAMPLE_SIZE, F.col('3bdr_price'))
                   .otherwise(None))
    
    # Remove rows where ALL bedroom types have insufficient sample size
    quality_df = quality_df.filter(
        F.col('all_price').isNotNull() |
        F.col('1bdr_price').isNotNull() |
        F.col('3bdr_price').isNotNull()
    )
    
    quality_count = quality_df.count()
    print(f"Quality filter applied: {quality_count:,} rows retained")
    
    # Step 4: Map neighborhoods to district and borough IDs
    print("\n[4/7] Mapping neighborhoods to borough_id and district_id...")
    
    mapped_df = quality_df \
        .withColumn('borough_id', map_borough_id(F.col('borough'))) \
        .withColumn('district_id', 
                   map_neighborhood_to_district(F.col('area_name'), F.col('borough')))
    
    # Step 5: Rename columns for Silver schema
    print("\n[5/7] Standardizing column names for Silver layer...")
    
    silver_df = mapped_df \
        .withColumnRenamed('area_name', 'neighborhood') \
        .select(
            'neighborhood',
            'borough',
            'borough_id',
            'district_id',
            'area_type',
            'year',
            'month',
            'all_price',
            '1bdr_price',
            '3bdr_price',
            'all_count',
            '1bdr_count',
            '3bdr_count'
        )
    
    # Step 6: Remove duplicates (keep most recent by price)
    print("\n[6/7] Removing duplicates...")
    
    window_spec = Window.partitionBy('neighborhood', 'year', 'month') \
        .orderBy(F.desc('all_price'))
    
    deduped_df = silver_df \
        .withColumn('row_num', F.row_number().over(window_spec)) \
        .filter(F.col('row_num') == 1) \
        .drop('row_num')
    
    deduped_count = deduped_df.count()
    print(f"Deduplicated: {deduped_count:,} unique records")
    
    # Step 7: Add Silver layer metadata
    print("\n[7/7] Adding Silver metadata and writing to BigQuery...")
    
    final_df = deduped_df \
        .withColumn('silver_load_timestamp', F.lit(datetime.utcnow())) \
        .withColumn('data_quality_tier', F.lit('silver')) \
        .orderBy('borough_id', 'neighborhood', 'year', 'month')
    
    # Write to BigQuery Silver layer
    final_df.write \
        .format("bigquery") \
        .option("table", target_table) \
        .option("writeMethod", "direct") \
        .mode("overwrite") \
        .save()
    
    print("✓ SILVER TRANSFORMATION SUCCESSFUL")
    print(f"  Source: {source_table}")
    print(f"  Target: {target_table}")
    print(f"  Rows Written: {deduped_count:,}")
    print(f"  Timestamp: {datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')}")
    
    return final_df


def main():
    """
    description:
        Main execution function
    """
    try:
        print("Starting PySpark Rent Bronze → Silver Transformation & Normalization...\n")
        
        # Get credentials
        credentials_path = get_credentials()
        
        # Create Spark session
        spark = create_spark_session(credentials_path)
        spark.sparkContext.setLogLevel("WARN")
        
        # Run transformation + normalization
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