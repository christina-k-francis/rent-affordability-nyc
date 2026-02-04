--- Refresh script that calculates analysis tables that stem from the fact_median_rent table

--- Calculating Year-over-Year Changes in asking rent prices
CREATE OR REPLACE TABLE `nyc_analysis.agg_yoy_rent_change` AS
SELECT
    neighborhood_name,
    borough_name,
    year,
    
    -- All Apartments metrics
    ROUND(avg_monthly_rent_all, 2) AS avg_monthly_rent_all,
    ROUND(prev_rent_all, 2) AS prev_rent_all,
    CASE
        WHEN prev_rent_all > 0 THEN
            ROUND(((avg_monthly_rent_all - prev_rent_all) / prev_rent_all * 100), 2)
        ELSE NULL
    END AS yoy_change_pct_all,
    
    -- 1 Bedroom metrics
    ROUND(avg_monthly_rent_1bdr, 2) AS avg_monthly_rent_1bdr,
    ROUND(prev_rent_1bdr, 2) AS prev_rent_1bdr,
    CASE
        WHEN prev_rent_1bdr > 0 THEN
            ROUND(((avg_monthly_rent_1bdr - prev_rent_1bdr) / prev_rent_1bdr * 100), 2)
        ELSE NULL
    END AS yoy_change_pct_1bdr,
    
    -- 3+ Bedroom metrics
    ROUND(avg_monthly_rent_3bdr, 2) AS avg_monthly_rent_3bdr,
    ROUND(prev_rent_3bdr, 2) AS prev_rent_3bdr,
    CASE
        WHEN prev_rent_3bdr > 0 THEN
            ROUND(((avg_monthly_rent_3bdr - prev_rent_3bdr) / prev_rent_3bdr * 100), 2)
        ELSE NULL
    END AS yoy_change_pct_3bdr,
    
    -- Data quality metric
    months_of_data,
    -- Reference IDs
    neighborhood_id,
    borough_id,
    
    -- Metadata
    CURRENT_TIMESTAMP() AS refresh_timestamp
FROM (
    SELECT
        n.name AS neighborhood_name,
        b.name AS borough_name,
        mr.year,
        mr.neighborhood_id,
        b.borough_id,
        
        -- Current year averages
        AVG(mr.all_apartments) AS avg_monthly_rent_all,
        AVG(mr.one_bedroom) AS avg_monthly_rent_1bdr,
        AVG(mr.three_plus_bedroom) AS avg_monthly_rent_3bdr,
        
        -- Previous year averages (using LAG window)
        LAG(AVG(mr.all_apartments)) OVER (
            PARTITION BY mr.neighborhood_id, b.borough_id
            ORDER BY mr.year
        ) AS prev_rent_all,
        
        LAG(AVG(mr.one_bedroom)) OVER (
            PARTITION BY mr.neighborhood_id, b.borough_id
            ORDER BY mr.year
        ) AS prev_rent_1bdr,
        
        LAG(AVG(mr.three_plus_bedroom)) OVER (
            PARTITION BY mr.neighborhood_id, b.borough_id
            ORDER BY mr.year
        ) AS prev_rent_3bdr,
        
        -- Data quality metrics
        COUNT(mr.month) AS months_of_data,
        
    FROM
        nyc_analysis.fact_median_rent mr
    JOIN
        nyc_analysis.ref_neighborhoods n
        ON mr.neighborhood_id = n.neighborhood_id
    JOIN
        nyc_analysis.ref_boroughs b
        ON mr.borough_id = b.borough_id
    WHERE
        mr.all_apartments IS NOT NULL
    GROUP BY
        n.name,
        b.name,
        mr.neighborhood_id,
        b.borough_id,
        mr.year
) rent_with_lag
ORDER BY
    borough_name,
    neighborhood_name,
    year