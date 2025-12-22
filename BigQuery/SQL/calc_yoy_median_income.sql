--- Refresh script that calculates analysis tables that stem from the fact_median_rent table

--- Calculating Year-over-Year Changes in Household Median Income
CREATE OR REPLACE TABLE `nyc_analysis.agg_yoy_income_change` AS
SELECT
    neighborhood_name,
    borough_name,
    year,
    
    -- All Households metrics
    ROUND(avg_income_all_hhs, 2) AS avg_income_all_hhs,
    ROUND(prev_income_all_hhs, 2) AS prev_income_all_hhs,
    CASE
        WHEN prev_income_all_hhs > 0 THEN
            ROUND(((avg_income_all_hhs - prev_income_all_hhs) / prev_income_all_hhs * 100), 2)
        ELSE NULL
    END AS yoy_change_pct_all_hhs,
    
    -- Single Adult Households metrics
    ROUND(avg_income_singles, 2) AS avg_income_singles,
    ROUND(prev_income_singles, 2) AS prev_income_singles,
    CASE
        WHEN prev_income_singles > 0 THEN
            ROUND(((avg_income_singles - prev_income_singles) / prev_income_singles * 100), 2)
        ELSE NULL
    END AS yoy_change_pct_singles,
    
    -- Married Families with Kids metrics
    ROUND(avg_income_married_kids, 2) AS avg_income_married_kids,
    ROUND(prev_income_married_kids, 2) AS prev_income_married_kids,
    CASE
        WHEN prev_income_married_kids > 0 THEN
            ROUND(((avg_income_married_kids - prev_income_married_kids) / prev_income_married_kids * 100), 2)
        ELSE NULL
    END AS yoy_change_pct_married_kids,
    
    -- Other Families with Kids metrics
    ROUND(avg_income_other_kids, 2) AS avg_income_other_kids,
    ROUND(prev_income_other_kids, 2) AS prev_income_other_kids,
    CASE
        WHEN prev_income_other_kids > 0 THEN
            ROUND(((avg_income_other_kids - prev_income_other_kids) / prev_income_other_kids * 100), 2)
        ELSE NULL
    END AS yoy_change_pct_other_kids,
    
    -- Reference IDs
    district_id,
    borough_id,
    
    -- Metadata
    CURRENT_TIMESTAMP() AS refresh_timestamp
FROM (
    SELECT
        n.name AS neighborhood_name,
        b.name AS borough_name,
        mi.year,
        mi.district_id,
        b.borough_id,
        
        -- Current year averages
        AVG(mi.all_hhs) AS avg_income_all_hhs,
        AVG(mi.singles) AS avg_income_singles,
        AVG(mi.married_kids) AS avg_income_married_kids,
        AVG(mi.other_kids) AS avg_income_other_kids,
        
        -- Previous year averages (using LAG window function)
        LAG(AVG(mi.all_hhs)) OVER (
            PARTITION BY n.neighborhood_id, b.borough_id
            ORDER BY mi.year
        ) AS prev_income_all_hhs,
        
        LAG(AVG(mi.singles)) OVER (
            PARTITION BY n.neighborhood_id, b.borough_id
            ORDER BY mi.year
        ) AS prev_income_singles,
        
        LAG(AVG(mi.married_kids)) OVER (
            PARTITION BY n.neighborhood_id, b.borough_id
            ORDER BY mi.year
        ) AS prev_income_married_kids,
        
        LAG(AVG(mi.other_kids)) OVER (
            PARTITION BY n.neighborhood_id, b.borough_id
            ORDER BY mi.year
        ) AS prev_income_other_kids
        
    FROM
        nyc_analysis.fact_median_income mi
    JOIN
        nyc_analysis.ref_district_neighborhoods dn
        ON mi.district_id = dn.district_id
    JOIN
        nyc_analysis.ref_neighborhoods n
        ON dn.neighborhood_id = n.neighborhood_id
    JOIN
        nyc_analysis.ref_boroughs b
        ON n.borough_id = b.borough_id
    WHERE
        mi.all_hhs IS NOT NULL
        AND mi.singles IS NOT NULL
        AND mi.married_kids IS NOT NULL
        AND mi.other_kids IS NOT NULL
    GROUP BY
        n.name,
        b.name,
        n.neighborhood_id,
        b.borough_id,
        mi.district_id,
        mi.year
) income_with_lag
ORDER BY
    borough_name,
    neighborhood_name,
    year;
