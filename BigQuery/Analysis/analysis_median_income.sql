--- Refresh script that calculates analysis tables that stem from the staging_median_income table

--- 1. Creating the fact_median_income table from the recently updated staging_median_income table
CREATE OR REPLACE TABLE nyc_analysis.fact_median_income AS
SELECT
    CAST(area_name AS STRING) AS neighborhood,
    CAST(borough AS STRING) AS borough,
    district_name,
    year,
    CAST(income_all_hhs AS NUMERIC) AS income_all_hhs,
    CAST(COALESCE(income_singles, 0) AS NUMERIC) AS income_singles,
    CAST(COALESCE(income_married_kids, 0) AS NUMERIC) AS income_married_kids,
    CAST(COALESCE(income_other_kids, 0) AS NUMERIC) AS income_other_kids,
    district_id,
    borough_id,
FROM (
    SELECT
        s.`NAME` AS area_name,
        -- Extract borough name from NAME field (contains neighborhood and borough)
        CASE
            WHEN s.`NAME` LIKE '%Manhattan%' THEN 'Manhattan'
            WHEN s.`NAME` LIKE '%Brooklyn%' THEN 'Brooklyn'
            WHEN s.`NAME` LIKE '%Queens%' THEN 'Queens'
            WHEN s.`NAME` LIKE '%Bronx%' THEN 'Bronx'
            WHEN s.`NAME` LIKE '%Staten Island%' THEN 'Staten Island'
            ELSE NULL
        END AS borough,
        s.year,
        s.income_all_hhs,
        s.income_singles,
        s.income_married_kids,
        s.income_other_kids,
        
        -- Map borough name (extracted from NAME) to borough_id
        CASE
            WHEN s.`NAME` LIKE '%Manhattan%' THEN 1
            WHEN s.`NAME` LIKE '%Brooklyn%' THEN 2
            WHEN s.`NAME` LIKE '%Queens%' THEN 3
            WHEN s.`NAME` LIKE '%Bronx%' THEN 4
            WHEN s.`NAME` LIKE '%Staten Island%' THEN 5
            ELSE NULL
        END AS borough_id,
        
        -- Map area_name (from NAME field) to district_id
        CASE
            -- Brooklyn Districts (1-18)
            WHEN s.`NAME` LIKE '%Greenpoint%' OR s.`NAME` LIKE '%Williamsburg%' THEN 1
            WHEN s.`NAME` LIKE '%Fort Greene%' OR s.`NAME` LIKE '%Downtown Brooklyn%' OR s.`NAME` LIKE '%Brooklyn Heights%' THEN 2
            WHEN s.`NAME` LIKE '%Bedford-Stuyvesant%' THEN 3
            WHEN s.`NAME` LIKE '%Bushwick%' THEN 4
            WHEN s.`NAME` LIKE '%East New York%' OR s.`NAME` LIKE '%Cypress Hills%' OR s.`NAME` LIKE '%Starrett City%' THEN 5
            WHEN s.`NAME` LIKE '%Park Slope%' OR s.`NAME` LIKE '%Red Hook%' OR s.`NAME` LIKE '%Carroll Gardens%' THEN 6
            WHEN s.`NAME` LIKE '%Sunset Park%' OR s.`NAME` LIKE '%Windsor Terrace%' THEN 7
            WHEN s.`NAME` LIKE '%Crown Heights (North)%' OR s.`NAME` LIKE '%Prospect Heights%' THEN 8
            WHEN s.`NAME` LIKE '%Crown Heights (South)%' OR s.`NAME` LIKE '%Prospect Lefferts%' OR s.`NAME` LIKE '%Wingate%' THEN 9
            WHEN s.`NAME` LIKE '%Bay Ridge%' OR s.`NAME` LIKE '%Dyker Heights%' THEN 10
            WHEN s.`NAME` LIKE '%Bensonhurst%' OR s.`NAME` LIKE '%Bath Beach%' THEN 11
            WHEN s.`NAME` LIKE '%Borough Park%' OR s.`NAME` LIKE '%Ocean Parkway%' THEN 12
            WHEN s.`NAME` LIKE '%Brighton Beach%' OR s.`NAME` LIKE '%Coney Island%' THEN 13
            WHEN s.`NAME` LIKE '%Flatbush%' OR s.`NAME` LIKE '%Midwood%' THEN 14
            WHEN s.`NAME` LIKE '%Sheepshead Bay%' OR s.`NAME` LIKE '%Gravesend%' OR s.`NAME` LIKE '%Gerritsen Beach%' THEN 15
            WHEN s.`NAME` LIKE '%Brownsville%' OR s.`NAME` LIKE '%Ocean Hill%' THEN 16
            WHEN s.`NAME` LIKE '%East Flatbush%' OR s.`NAME` LIKE '%Rugby%' THEN 17
            WHEN s.`NAME` LIKE '%Canarsie%' OR s.`NAME` LIKE '%Flatlands%' THEN 18
            
            -- Manhattan Districts (19-30)
            WHEN s.`NAME` LIKE '%Battery Park%' THEN 19
            WHEN s.`NAME` LIKE '%Financial District%' THEN 20
            WHEN s.`NAME` LIKE '%Lower East Side%' OR s.`NAME` LIKE '%Chinatown%' THEN 21
            WHEN s.`NAME` LIKE '%Chelsea%' OR s.`NAME` LIKE "%Hell''s Kitchen%" THEN 22
            WHEN s.`NAME` LIKE '%Midtown%' OR s.`NAME` LIKE '%Flatiron%' THEN 23
            WHEN s.`NAME` LIKE '%Gramercy%' OR s.`NAME` LIKE '%Stuyvesant Town%' THEN 24
            WHEN s.`NAME` LIKE '%Upper West Side%' THEN 25
            WHEN s.`NAME` LIKE '%Upper East Side%' OR s.`NAME` LIKE '%Roosevelt Island%' THEN 26
            WHEN s.`NAME` LIKE '%Morningside Heights%' OR s.`NAME` LIKE '%Hamilton Heights%' OR s.`NAME` LIKE '%Manhattanville%' THEN 27
            WHEN s.`NAME` LIKE '%Harlem%' AND NOT (s.`NAME` LIKE '%East Harlem%') THEN 28
            WHEN s.`NAME` LIKE '%East Harlem%' THEN 29
            WHEN s.`NAME` LIKE '%Washington Heights%' OR s.`NAME` LIKE '%Marble Hill%' THEN 30
            
            -- Queens Districts (31-44)
            WHEN s.`NAME` LIKE '%Astoria%' THEN 31
            WHEN s.`NAME` LIKE '%Sunnyside%' OR s.`NAME` LIKE '%Woodside%' THEN 32
            WHEN s.`NAME` LIKE '%Jackson Heights%' THEN 33
            WHEN s.`NAME` LIKE '%Elmhurst%' AND s.`NAME` LIKE '%Corona%' THEN 34
            WHEN s.`NAME` LIKE '%Ridgewood%' OR s.`NAME` LIKE '%Maspeth%' THEN 35
            WHEN s.`NAME` LIKE '%Forest Hills%' OR s.`NAME` LIKE '%Rego Park%' THEN 36
            WHEN s.`NAME` LIKE '%Flushing%' OR s.`NAME` LIKE '%Whitestone%' THEN 37
            WHEN s.`NAME` LIKE '%Fresh Meadows%' OR s.`NAME` LIKE '%Briarwood%' THEN 38
            WHEN s.`NAME` LIKE '%Kew Gardens%' OR s.`NAME` LIKE '%Woodhaven%' THEN 39
            WHEN s.`NAME` LIKE '%Howard Beach%' OR s.`NAME` LIKE '%Ozone Park%' THEN 40
            WHEN s.`NAME` LIKE '%Bayside%' OR s.`NAME` LIKE '%Auburndale%' THEN 41
            WHEN s.`NAME` LIKE '%Jamaica%' OR s.`NAME` LIKE '%Hollis%' THEN 42
            WHEN s.`NAME` LIKE '%Cambria Heights%' OR s.`NAME` LIKE '%Bellerose%' THEN 43
            WHEN s.`NAME` LIKE '%Rockaway%' OR s.`NAME` LIKE '%Broad Channel%' THEN 44
            
            -- Bronx Districts (45-56)
            WHEN s.`NAME` LIKE '%Hunts Point%' THEN 45
            WHEN s.`NAME` LIKE '%Longwood%' OR s.`NAME` LIKE '%Melrose%' OR s.`NAME` LIKE '%Mott Haven%' THEN 46
            WHEN s.`NAME` LIKE '%Belmont%' OR s.`NAME` LIKE '%East Tremont%' THEN 47
            WHEN s.`NAME` LIKE '%Concourse%' OR s.`NAME` LIKE '%Highbridge%' THEN 48
            WHEN s.`NAME` LIKE '%Morris Heights%' THEN 49
            WHEN s.`NAME` LIKE '%Crotona Park East%' OR s.`NAME` LIKE '%West Farms%' OR s.`NAME` LIKE '%Morrisania%' THEN 50
            WHEN s.`NAME` LIKE '%Bedford Park%' OR s.`NAME` LIKE '%Fordham%' OR s.`NAME` LIKE '%Norwood%' THEN 51
            WHEN s.`NAME` LIKE '%Riverdale%' OR s.`NAME` LIKE '%Kingsbridge%' THEN 52
            WHEN s.`NAME` LIKE '%Parkchester%' OR s.`NAME` LIKE '%Castle Hill%' OR s.`NAME` LIKE '%Soundview%' THEN 53
            WHEN s.`NAME` LIKE '%Co-op City%' OR s.`NAME` LIKE '%Pelham Bay%' OR s.`NAME` LIKE '%Schuylerville%' OR s.`NAME` LIKE '%Throgs Neck%' THEN 54
            WHEN s.`NAME` LIKE '%Pelham Parkway%' OR s.`NAME` LIKE '%Morris Park%' OR s.`NAME` LIKE '%Laconia%' THEN 55
            WHEN s.`NAME` LIKE '%Wakefield%' OR s.`NAME` LIKE '%Williamsbridge%' OR s.`NAME` LIKE '%Eastchester%' OR s.`NAME` LIKE '%Woodlawn%' THEN 56
            
            -- Staten Island Districts (57-59)
            WHEN s.`NAME` LIKE '%North Shore%' OR s.`NAME` LIKE '%New Springville%' OR s.`NAME` LIKE '%South Beach%' THEN 57
            WHEN s.`NAME` LIKE '%South Shore%' OR s.`NAME` LIKE '%Tottenville%' OR s.`NAME` LIKE '%Great Kills%' OR s.`NAME` LIKE '%Annadale%' THEN 58
            WHEN s.`NAME` LIKE '%Mid-Island%' OR s.`NAME` LIKE '%Port Richmond%' OR s.`NAME` LIKE '%Stapleton%' OR s.`NAME` LIKE '%Mariners Harbor%' THEN 59
            
            ELSE NULL
        END AS district_id,
        
        -- Retrieve official district name
        CASE
            WHEN s.`NAME` LIKE '%Greenpoint%' OR s.`NAME` LIKE '%Williamsburg%' THEN 'Greenpoint & Williamsburg'
            WHEN s.`NAME` LIKE '%Fort Greene%' OR s.`NAME` LIKE '%Downtown Brooklyn%' OR s.`NAME` LIKE '%Brooklyn Heights%' THEN 'Brooklyn Heights, Downtown Brooklyn, & Fort Greene'
            WHEN s.`NAME` LIKE '%Bedford-Stuyvesant%' THEN 'Bedford-Stuyvesant'
            WHEN s.`NAME` LIKE '%Bushwick%' THEN 'Bushwick'
            WHEN s.`NAME` LIKE '%East New York%' OR s.`NAME` LIKE '%Cypress Hills%' OR s.`NAME` LIKE '%Starrett City%' THEN 'East New York, Cypress Hills, & Starrett City'
            WHEN s.`NAME` LIKE '%Park Slope%' OR s.`NAME` LIKE '%Red Hook%' OR s.`NAME` LIKE '%Carroll Gardens%' THEN 'Park Slope, Carroll Gardens & Red Hook'
            WHEN s.`NAME` LIKE '%Sunset Park%' OR s.`NAME` LIKE '%Windsor Terrace%' THEN 'Sunset Park & Windsor Terrace'
            WHEN s.`NAME` LIKE '%Crown Heights (North)%' OR s.`NAME` LIKE '%Prospect Heights%' THEN 'Crown Heights North & Prospect Heights'
            WHEN s.`NAME` LIKE '%Crown Heights (South)%' OR s.`NAME` LIKE '%Prospect Lefferts%' OR s.`NAME` LIKE '%Wingate%' THEN 'Crown Heights South, Prospect Lefferts & Wingate'
            WHEN s.`NAME` LIKE '%Bay Ridge%' OR s.`NAME` LIKE '%Dyker Heights%' THEN 'Bay Ridge & Dyker Heights'
            WHEN s.`NAME` LIKE '%Bensonhurst%' OR s.`NAME` LIKE '%Bath Beach%' THEN 'Bensonhurst & Bath Beach'
            WHEN s.`NAME` LIKE '%Borough Park%' OR s.`NAME` LIKE '%Ocean Parkway%' THEN 'Borough Park, Kensington & Ocean Parkway'
            WHEN s.`NAME` LIKE '%Brighton Beach%' OR s.`NAME` LIKE '%Coney Island%' THEN 'Brighton Beach & Coney Island'
            WHEN s.`NAME` LIKE '%Flatbush%' OR s.`NAME` LIKE '%Midwood%' THEN 'Flatbush & Midwood'
            WHEN s.`NAME` LIKE '%Sheepshead Bay%' OR s.`NAME` LIKE '%Gravesend%' OR s.`NAME` LIKE '%Gerritsen Beach%' THEN 'Sheepshead Bay, Gravesend, Gerritsen Beach & Homecrest'
            WHEN s.`NAME` LIKE '%Brownsville%' OR s.`NAME` LIKE '%Ocean Hill%' THEN 'Brownsville & Ocean Hill'
            WHEN s.`NAME` LIKE '%East Flatbush%' OR s.`NAME` LIKE '%Rugby%' THEN 'East Flatbush, Farragut & Rugby'
            WHEN s.`NAME` LIKE '%Canarsie%' OR s.`NAME` LIKE '%Flatlands%' THEN 'Canarsie & Flatlands'
            WHEN s.`NAME` LIKE '%Battery Park%' THEN 'Financial District & Battery Park City'
            WHEN s.`NAME` LIKE '%Financial District%' THEN 'Financial District & Battery Park City'
            WHEN s.`NAME` LIKE '%Lower East Side%' OR s.`NAME` LIKE '%Chinatown%' THEN 'Lower East Side & Chinatown'
            WHEN s.`NAME` LIKE '%Chelsea%' OR s.`NAME` LIKE "%Hell''s Kitchen%" THEN "Chelsea & Hell''s Kitchen"
            WHEN s.`NAME` LIKE '%Midtown%' OR s.`NAME` LIKE '%Flatiron%' THEN 'Midtown, Midtown East & Flatiron'
            WHEN s.`NAME` LIKE '%Gramercy%' OR s.`NAME` LIKE '%Stuyvesant Town%' THEN 'Murray Hill, Gramercy & Stuyvesant Town'
            WHEN s.`NAME` LIKE '%Upper West Side%' THEN 'Upper West Side'
            WHEN s.`NAME` LIKE '%Upper East Side%' OR s.`NAME` LIKE '%Roosevelt Island%' THEN 'Upper East Side & Roosevelt Island'
            WHEN s.`NAME` LIKE '%Morningside Heights%' OR s.`NAME` LIKE '%Hamilton Heights%' OR s.`NAME` LIKE '%Manhattanville%' THEN 'Morningside Heights & Hamilton Heights'
            WHEN s.`NAME` LIKE '%Harlem%' AND NOT (s.`NAME` LIKE '%East Harlem%') THEN 'Central Harlem'
            WHEN s.`NAME` LIKE '%East Harlem%' THEN 'East Harlem'
            WHEN s.`NAME` LIKE '%Washington Heights%' OR s.`NAME` LIKE '%Marble Hill%' THEN 'Washington Heights, Inwood & Marble Hill'
            WHEN s.`NAME` LIKE '%Astoria%' THEN 'Astoria & Long Island City'
            WHEN s.`NAME` LIKE '%Sunnyside%' OR s.`NAME` LIKE '%Woodside%' THEN 'Long Island City, Sunnyside & Woodside'
            WHEN s.`NAME` LIKE '%Jackson Heights%' THEN 'Jackson Heights & North Corona'
            WHEN s.`NAME` LIKE '%Elmhurst%' AND s.`NAME` LIKE '%Corona%' THEN 'Elmhurst & South Corona'
            WHEN s.`NAME` LIKE '%Ridgewood%' OR s.`NAME` LIKE '%Maspeth%' THEN 'Ridgewood, Glendale, Maspeth, & Middle Village'
            WHEN s.`NAME` LIKE '%Forest Hills%' OR s.`NAME` LIKE '%Rego Park%' THEN 'Forest Hills & Rego Park'
            WHEN s.`NAME` LIKE '%Flushing%' OR s.`NAME` LIKE '%Whitestone%' THEN 'Flushing, Murray Hill & Whitestone'
            WHEN s.`NAME` LIKE '%Fresh Meadows%' OR s.`NAME` LIKE '%Briarwood%' THEN 'Fresh Meadows, Hillcrest & Briarwood'
            WHEN s.`NAME` LIKE '%Kew Gardens%' OR s.`NAME` LIKE '%Woodhaven%' THEN 'Kew Gardens, Richmond Hill & Woodhaven'
            WHEN s.`NAME` LIKE '%Howard Beach%' OR s.`NAME` LIKE '%Ozone Park%' THEN 'Howard Beach & Ozone Park'
            WHEN s.`NAME` LIKE '%Bayside%' OR s.`NAME` LIKE '%Auburndale%' THEN 'Bayside, Douglaston, Auburndale, & Little Neck'
            WHEN s.`NAME` LIKE '%Jamaica%' OR s.`NAME` LIKE '%Hollis%' THEN 'Jamaica, Hollis & St. Albans'
            WHEN s.`NAME` LIKE '%Cambria Heights%' OR s.`NAME` LIKE '%Bellerose%' THEN 'Queens Village, Cambria Heights, Bellerose, & Rosedale'
            WHEN s.`NAME` LIKE '%Rockaway%' OR s.`NAME` LIKE '%Broad Channel%' THEN 'Far Rockaway, Breezy Point & Broad Channel'
            WHEN s.`NAME` LIKE '%Hunts Point%' THEN 'Hunts Point'
            WHEN s.`NAME` LIKE '%Longwood%' OR s.`NAME` LIKE '%Melrose%' OR s.`NAME` LIKE '%Mott Haven%' THEN 'Longwood, Melrose, & Mott Haven'
            WHEN s.`NAME` LIKE '%Belmont%' OR s.`NAME` LIKE '%East Tremont%' THEN 'Belmont & East Tremont'
            WHEN s.`NAME` LIKE '%Concourse%' OR s.`NAME` LIKE '%Highbridge%' THEN 'Concourse, High Bridge, & Mount Eden'
            WHEN s.`NAME` LIKE '%Morris Heights%' THEN 'Morris Heights, Mount Hope'
            WHEN s.`NAME` LIKE '%Crotona Park East%' OR s.`NAME` LIKE '%West Farms%' OR s.`NAME` LIKE '%Morrisania%' THEN 'Crotona Park East, West Farms, & Morrisania'
            WHEN s.`NAME` LIKE '%Bedford Park%' OR s.`NAME` LIKE '%Fordham%' OR s.`NAME` LIKE '%Norwood%' THEN 'Bedford Park, Fordham, & Norwood'
            WHEN s.`NAME` LIKE '%Riverdale%' OR s.`NAME` LIKE '%Kingsbridge%' THEN 'Riverdale & Kingsbridge'
            WHEN s.`NAME` LIKE '%Parkchester%' OR s.`NAME` LIKE '%Castle Hill%' OR s.`NAME` LIKE '%Soundview%' THEN 'Parkchester, Castle Hill, Clason Point, & Soundview'
            WHEN s.`NAME` LIKE '%Co-op City%' OR s.`NAME` LIKE '%Pelham Bay%' OR s.`NAME` LIKE '%Schuylerville%' OR s.`NAME` LIKE '%Throgs Neck%' THEN 'Co-op City, Pelham Bay, Schuylerville, & Throgs Neck'
            WHEN s.`NAME` LIKE '%Pelham Parkway%' OR s.`NAME` LIKE '%Morris Park%' OR s.`NAME` LIKE '%Laconia%' THEN 'Pelham Parkway, Morris Park, & Laconia'
            WHEN s.`NAME` LIKE '%Wakefield%' OR s.`NAME` LIKE '%Williamsbridge%' OR s.`NAME` LIKE '%Eastchester%' OR s.`NAME` LIKE '%Woodlawn%' THEN 'Wakefield, Williamsbridge, Eastchester, & Woodlawn'
            WHEN s.`NAME` LIKE '%North Shore%' OR s.`NAME` LIKE '%New Springville%' OR s.`NAME` LIKE '%South Beach%' THEN 'North Shore: New Springville & South Beach'
            WHEN s.`NAME` LIKE '%South Shore%' OR s.`NAME` LIKE '%Tottenville%' OR s.`NAME` LIKE '%Great Kills%' OR s.`NAME` LIKE '%Annadale%' THEN 'South Shore: Tottenville, Great Kills, & Annadale'
            WHEN s.`NAME` LIKE '%Mid-Island%' OR s.`NAME` LIKE '%Port Richmond%' OR s.`NAME` LIKE '%Stapleton%' OR s.`NAME` LIKE '%Mariners Harbor%' THEN 'Mid-Island: Port Richmond, Stapleton, & Mariners Harbor'
            
            ELSE NULL
        END AS district_name
        
    FROM
        nyc_analysis.staging_median_income s
    WHERE
        -- Data quality filter: must have at least the main household income
        s.income_all_hhs IS NOT NULL
)
WHERE
    -- Exclude records where we couldn't map to district_id or borough_id
    district_id IS NOT NULL
    AND borough_id IS NOT NULL
-- Remove duplicates: keep most recent record per district/year
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY district_id, year 
) = 1
ORDER BY
    borough_id,
    district_id,
    year;

--- 2. Calculating subsequent Year-over-Year Changes in HH Median Income
CREATE OR REPLACE TABLE nyc_analysis.agg_yoy_income_change AS
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
        AVG(mi.income_all_hhs) AS avg_income_all_hhs,
        AVG(mi.income_singles) AS avg_income_singles,
        AVG(mi.income_married_kids) AS avg_income_married_kids,
        AVG(mi.income_other_kids) AS avg_income_other_kids,
        
        -- Previous year averages (using LAG window function)
        LAG(AVG(mi.income_all_hhs)) OVER (
            PARTITION BY n.neighborhood_id, b.borough_id
            ORDER BY mi.year
        ) AS prev_income_all_hhs,
        
        LAG(AVG(mi.income_singles)) OVER (
            PARTITION BY n.neighborhood_id, b.borough_id
            ORDER BY mi.year
        ) AS prev_income_singles,
        
        LAG(AVG(mi.income_married_kids)) OVER (
            PARTITION BY n.neighborhood_id, b.borough_id
            ORDER BY mi.year
        ) AS prev_income_married_kids,
        
        LAG(AVG(mi.income_other_kids)) OVER (
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
        mi.income_all_hhs IS NOT NULL
        AND mi.income_singles IS NOT NULL
        AND mi.income_married_kids IS NOT NULL
        AND mi.income_other_kids IS NOT NULL
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