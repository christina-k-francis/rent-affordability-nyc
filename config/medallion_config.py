"""
Medallion Architecture Configuration for NYC Rent Affordability Project
Defines table naming conventions and data flow between layers.

Usage:
    from config.medallion_config import BRONZE_TABLES, SILVER_TABLES, GOLD_TABLES
"""

PROJECT_ID = "rent-affordability"

# Dataset names by layer
DATASETS = {
    "bronze": "nyc_bronze",
    "silver": "nyc_silver", 
    "gold": "nyc_gold"
}

# ============================================================
# BRONZE LAYER TABLES (Raw Ingestion)
# ============================================================

BRONZE_TABLES = {
    "income": {
        "table": "income_raw",
        "full_name": f"{PROJECT_ID}.nyc_bronze.income_raw",
        "description": "Raw US Census income data from ACS API",
        "source": "US Census American Community Survey API",
        "refresh_frequency": "monthly",
        "write_disposition": "WRITE_TRUNCATE"  # Full refresh
    },
    "rent": {
        "table": "rent_raw",
        "full_name": f"{PROJECT_ID}.nyc_bronze.rent_raw",
        "description": "Raw rent data from StreetEasy",
        "source": "StreetEasy public data",
        "refresh_frequency": "monthly",
        "write_disposition": "WRITE_TRUNCATE"  # Full refresh
    }
}

# ============================================================
# SILVER LAYER TABLES (Cleaned, Normalized)
# ============================================================

SILVER_TABLES = {
    "income": {
        "table": "income",
        "full_name": f"{PROJECT_ID}.nyc_silver.income",
        "description": "Cleaned and normalized median income by neighborhood",
        "grain": "district_id, year",
        "scd_type": "Type 1 (overwrite)",
        "write_disposition": "WRITE_TRUNCATE",
        "partition_field": "year",
        "cluster_fields": ["borough_id", "district_id"]
    },
    "rent": {
        "table": "rent",
        "full_name": f"{PROJECT_ID}.nyc_silver.rent",
        "description": "Cleaned and normalized median rent by neighborhood",
        "grain": "neighborhood, year, month",
        "scd_type": "Type 1 (overwrite)",
        "write_disposition": "WRITE_TRUNCATE",
        "partition_field": "year",
        "cluster_fields": ["borough_id", "neighborhood"]
    },
    
    # Dimension tables (conform layer)
    "dim_boroughs": {
        "table": "dim_boroughs",
        "full_name": f"{PROJECT_ID}.nyc_silver.dim_boroughs",
        "description": "Borough reference dimension (5 NYC boroughs)",
        "grain": "borough_id",
        "scd_type": "Type 1 (overwrite)",
        "write_disposition": "WRITE_TRUNCATE"
    },
    "dim_neighborhoods": {
        "table": "dim_neighborhoods",
        "full_name": f"{PROJECT_ID}.nyc_silver.dim_neighborhoods",
        "description": "Neighborhood reference dimension",
        "grain": "neighborhood_id",
        "scd_type": "Type 1 (overwrite)",
        "write_disposition": "WRITE_TRUNCATE"
    },
    "dim_districts": {
        "table": "dim_districts",
        "full_name": f"{PROJECT_ID}.nyc_silver.dim_districts",
        "description": "Census district reference dimension (59 districts)",
        "grain": "district_id",
        "scd_type": "Type 1 (overwrite)",
        "write_disposition": "WRITE_TRUNCATE"
    }
}

# ============================================================
# GOLD LAYER TABLES (Aggregated Analytics)
# ============================================================

GOLD_TABLES = {
    "income_yoy_changes": {
        "table": "income_yoy_changes",
        "full_name": f"{PROJECT_ID}.nyc_gold.income_yoy_changes",
        "description": "Year-over-year income changes by neighborhood and household type",
        "grain": "neighborhood, year",
        "write_disposition": "WRITE_TRUNCATE",
        "partition_field": "year",
        "business_owner": "Analytics Team"
    },
    "rent_yoy_changes": {
        "table": "rent_yoy_changes",
        "full_name": f"{PROJECT_ID}.nyc_gold.rent_yoy_changes",
        "description": "Year-over-year rent changes by neighborhood and bedroom count",
        "grain": "neighborhood, year",
        "write_disposition": "WRITE_TRUNCATE",
        "partition_field": "year",
        "business_owner": "Analytics Team"
    },
    "affordability_metrics": {
        "table": "affordability_metrics",
        "full_name": f"{PROJECT_ID}.nyc_gold.affordability_metrics",
        "description": "Rent-to-income ratios and affordability indicators",
        "grain": "neighborhood, year",
        "write_disposition": "WRITE_TRUNCATE",
        "partition_field": "year",
        "business_owner": "Analytics Team"
    },
    "neighborhood_trends": {
        "table": "neighborhood_trends",
        "full_name": f"{PROJECT_ID}.nyc_gold.neighborhood_trends",
        "description": "Multi-year trends for gentrification analysis",
        "grain": "neighborhood",
        "write_disposition": "WRITE_TRUNCATE",
        "business_owner": "Data Science Team"
    }
}

# ============================================================
# DATA QUALITY RULES PER LAYER
# ============================================================

DATA_QUALITY_RULES = {
    "bronze": {
        "allow_nulls": True,
        "allow_duplicates": True,
        "schema_validation": False,
        "checks": [
            "row_count > 0",
            "load_timestamp exists"
        ]
    },
    "silver": {
        "allow_nulls": False,  # For key fields
        "allow_duplicates": False,
        "schema_validation": True,
        "checks": [
            "no_duplicates_on_grain",
            "referential_integrity_to_dimensions",
            "valid_date_ranges",
            "numeric_bounds_validation"
        ]
    },
    "gold": {
        "allow_nulls": False,
        "allow_duplicates": False,
        "schema_validation": True,
        "checks": [
            "aggregation_accuracy",
            "metric_completeness",
            "business_rule_validation"
        ]
    }
}

# ============================================================
# DATA LINEAGE TRACKING
# ============================================================

LINEAGE = {
    # Silver dependencies
    "nyc_silver.income": ["nyc_bronze.income_raw"],
    "nyc_silver.rent": ["nyc_bronze.rent_raw"],
    
    # Gold dependencies
    "nyc_gold.income_yoy_changes": [
        "nyc_silver.income",
        "nyc_silver.dim_neighborhoods",
        "nyc_silver.dim_boroughs"
    ],
    "nyc_gold.rent_yoy_changes": [
        "nyc_silver.rent",
        "nyc_silver.dim_neighborhoods",
        "nyc_silver.dim_boroughs"
    ],
    "nyc_gold.affordability_metrics": [
        "nyc_silver.income",
        "nyc_silver.rent",
        "nyc_silver.dim_neighborhoods"
    ],
    "nyc_gold.neighborhood_trends": [
        "nyc_gold.income_yoy_changes",
        "nyc_gold.rent_yoy_changes",
        "nyc_gold.affordability_metrics"
    ]
}

# ============================================================
# LAYER CHARACTERISTICS
# ============================================================

LAYER_CHARACTERISTICS = {
    "bronze": {
        "purpose": "Raw ingestion",
        "data_quality": "Unvalidated",
        "schema": "Source schema",
        "users": ["Data Engineers"],
        "retention": "Indefinite (audit trail)",
        "update_pattern": "Full refresh"
    },
    "silver": {
        "purpose": "Cleaned, normalized",
        "data_quality": "Validated, deduplicated",
        "schema": "Star schema (facts + dimensions)",
        "users": ["Data Engineers", "Data Analysts"],
        "retention": "Indefinite",
        "update_pattern": "Full refresh or incremental"
    },
    "gold": {
        "purpose": "Business metrics",
        "data_quality": "Aggregated, enriched",
        "schema": "Denormalized",
        "users": ["Data Analysts", "Business Users", "Dashboards", "ML Models"],
        "retention": "As per business requirements",
        "update_pattern": "Full refresh"
    }
}

# ============================================================
# HELPER FUNCTIONS
# ============================================================

def get_table_config(layer: str, entity: str) -> dict:
    """
    Get table configuration by layer and entity name.
    
    Args:
        layer: 'bronze', 'silver', or 'gold'
        entity: entity name (e.g., 'income', 'rent')
    
    Returns:
        Dictionary with table configuration
    
    Example:
        >>> get_table_config('bronze', 'income')
        {'table': 'income_raw', 'full_name': 'rent-affordability.nyc_bronze.income_raw', ...}
    """
    layer_tables = {
        "bronze": BRONZE_TABLES,
        "silver": SILVER_TABLES,
        "gold": GOLD_TABLES
    }
    
    if layer not in layer_tables:
        raise ValueError(f"Invalid layer: {layer}. Must be 'bronze', 'silver', or 'gold'")
    
    if entity not in layer_tables[layer]:
        raise ValueError(f"Entity '{entity}' not found in {layer} layer")
    
    return layer_tables[layer][entity]


def get_upstream_dependencies(table_full_name: str) -> list:
    """
    Get upstream dependencies for a given table.
    
    Args:
        table_full_name: Full table name (e.g., 'nyc_gold.income_yoy_changes')
    
    Returns:
        List of upstream table dependencies
    
    Example:
        >>> get_upstream_dependencies('nyc_gold.income_yoy_changes')
        ['nyc_silver.income', 'nyc_silver.dim_neighborhoods', 'nyc_silver.dim_boroughs']
    """
    return LINEAGE.get(table_full_name, [])


def get_all_tables_by_layer(layer: str) -> dict:
    """
    Get all table configurations for a given layer.
    
    Args:
        layer: 'bronze', 'silver', or 'gold'
    
    Returns:
        Dictionary of all tables in that layer
    """
    layer_tables = {
        "bronze": BRONZE_TABLES,
        "silver": SILVER_TABLES,
        "gold": GOLD_TABLES
    }
    
    if layer not in layer_tables:
        raise ValueError(f"Invalid layer: {layer}")
    
    return layer_tables[layer]


# ============================================================
# VALIDATION
# ============================================================

def validate_config():
    """Validate configuration consistency"""
    errors = []
    
    # Check that all lineage references exist
    all_tables = set()
    for layer in [BRONZE_TABLES, SILVER_TABLES, GOLD_TABLES]:
        all_tables.update(table['full_name'].split('.')[-2:][0] + '.' + 
                         table['full_name'].split('.')[-1] 
                         for table in layer.values())
    
    for target, sources in LINEAGE.items():
        if target not in all_tables:
            errors.append(f"Lineage target not found: {target}")
        for source in sources:
            if source not in all_tables:
                errors.append(f"Lineage source not found: {source} (referenced by {target})")
    
    if errors:
        raise ValueError(f"Configuration validation failed:\n" + "\n".join(errors))
    
    return True


# Validate on import
try:
    validate_config()
except ValueError as e:
    print(f"Warning: {e}")


if __name__ == "__main__":
    # Print configuration summary
    print("=" * 70)
    print("MEDALLION ARCHITECTURE CONFIGURATION")
    print("=" * 70)
    
    for layer_name, tables in [("Bronze", BRONZE_TABLES), 
                                 ("Silver", SILVER_TABLES), 
                                 ("Gold", GOLD_TABLES)]:
        print(f"\n{layer_name} Layer Tables:")
        for entity, config in tables.items():
            print(f"  • {config['full_name']}")
    
    print("\n" + "=" * 70)