--- Refresh script that calculates analysis tables that stem from the staging_median_income table

--- 1. Creating the fact_median_income table from the recently updated staging_median_income table
CREATE OR REPLACE TABLE nyc_analysis.fact_median_income AS
SELECT
    CAST(area_name AS STRING) AS neighborhood,
    CAST(borough AS STRING) AS borough,
    district_name,
    year,
    CAST(`all_HHs` AS NUMERIC) AS all_hhs,
    CAST(COALESCE(singles, 0) AS NUMERIC) AS singles,
    CAST(COALESCE(married_kids, 0) AS NUMERIC) AS married_kids,
    CAST(COALESCE(other_kids, 0) AS NUMERIC) AS other_kids,
    district_id,
    borough_id,
FROM (
    SELECT
        s.district AS area_name,
        -- Extract borough name from district field (contains neighborhood and borough)
        CASE
            WHEN s.district LIKE '%Manhattan%' THEN 'Manhattan'
            WHEN s.district LIKE '%Brooklyn%' THEN 'Brooklyn'
            WHEN s.district LIKE '%Queens%' THEN 'Queens'
            WHEN s.district LIKE '%Bronx%' THEN 'Bronx'
            WHEN s.district LIKE '%Staten Island%' THEN 'Staten Island'
            ELSE NULL
        END AS borough,
        s.year,
        s.all_hhs,
        s.singles,
        s.married_kids,
        s.other_kids,
        
        -- Map borough name (extracted from district) to borough_id
        CASE
            WHEN s.district LIKE '%Manhattan%' THEN 1
            WHEN s.district LIKE '%Brooklyn%' THEN 2
            WHEN s.district LIKE '%Queens%' THEN 3
            WHEN s.district LIKE '%Bronx%' THEN 4
            WHEN s.district LIKE '%Staten Island%' THEN 5
            ELSE NULL
        END AS borough_id,
        
        -- Map area_name (from district field) to district_id
        CASE
            -- Brooklyn Districts (1-18)
            WHEN s.district LIKE '%Greenpoint%' OR s.district LIKE '%Williamsburg%' THEN 1
            WHEN s.district LIKE '%Fort Greene%' OR s.district LIKE '%Downtown Brooklyn%' OR s.district LIKE '%Brooklyn Heights%' THEN 2
            WHEN s.district LIKE '%Bedford-Stuyvesant%' THEN 3
            WHEN s.district LIKE '%Bushwick%' THEN 4
            WHEN s.district LIKE '%East New York%' OR s.district LIKE '%Cypress Hills%' OR s.district LIKE '%Starrett City%' THEN 5
            WHEN s.district LIKE '%Park Slope%' OR s.district LIKE '%Red Hook%' OR s.district LIKE '%Carroll Gardens%' THEN 6
            WHEN s.district LIKE '%Sunset Park%' OR s.district LIKE '%Windsor Terrace%' THEN 7
            WHEN s.district LIKE '%Crown Heights (North)%' OR s.district LIKE '%Prospect Heights%' THEN 8
            WHEN s.district LIKE '%Crown Heights (South)%' OR s.district LIKE '%Prospect Lefferts%' OR s.district LIKE '%Wingate%' THEN 9
            WHEN s.district LIKE '%Bay Ridge%' OR s.district LIKE '%Dyker Heights%' THEN 10
            WHEN s.district LIKE '%Bensonhurst%' OR s.district LIKE '%Bath Beach%' THEN 11
            WHEN s.district LIKE '%Borough Park%' OR s.district LIKE '%Ocean Parkway%' THEN 12
            WHEN s.district LIKE '%Brighton Beach%' OR s.district LIKE '%Coney Island%' THEN 13
            WHEN s.district LIKE '%Flatbush%' OR s.district LIKE '%Midwood%' THEN 14
            WHEN s.district LIKE '%Sheepshead Bay%' OR s.district LIKE '%Gravesend%' OR s.district LIKE '%Gerritsen Beach%' THEN 15
            WHEN s.district LIKE '%Brownsville%' OR s.district LIKE '%Ocean Hill%' THEN 16
            WHEN s.district LIKE '%East Flatbush%' OR s.district LIKE '%Rugby%' THEN 17
            WHEN s.district LIKE '%Canarsie%' OR s.district LIKE '%Flatlands%' THEN 18
            
            -- Manhattan Districts (19-30)
            WHEN s.district LIKE '%Battery Park%' THEN 19
            WHEN s.district LIKE '%Financial District%' THEN 20
            WHEN s.district LIKE '%Lower East Side%' OR s.district LIKE '%Chinatown%' THEN 21
            WHEN s.district LIKE '%Chelsea%' OR s.district LIKE "%Hell''s Kitchen%" THEN 22
            WHEN s.district LIKE '%Midtown%' OR s.district LIKE '%Flatiron%' THEN 23
            WHEN s.district LIKE '%Gramercy%' OR s.district LIKE '%Stuyvesant Town%' THEN 24
            WHEN s.district LIKE '%Upper West Side%' THEN 25
            WHEN s.district LIKE '%Upper East Side%' OR s.district LIKE '%Roosevelt Island%' THEN 26
            WHEN s.district LIKE '%Morningside Heights%' OR s.district LIKE '%Hamilton Heights%' OR s.district LIKE '%Manhattanville%' THEN 27
            WHEN s.district LIKE '%Harlem%' AND NOT (s.district LIKE '%East Harlem%') THEN 28
            WHEN s.district LIKE '%East Harlem%' THEN 29
            WHEN s.district LIKE '%Washington Heights%' OR s.district LIKE '%Marble Hill%' THEN 30
            
            -- Queens Districts (31-44)
            WHEN s.district LIKE '%Astoria%' THEN 31
            WHEN s.district LIKE '%Sunnyside%' OR s.district LIKE '%Woodside%' THEN 32
            WHEN s.district LIKE '%Jackson Heights%' THEN 33
            WHEN s.district LIKE '%Elmhurst%' AND s.district LIKE '%Corona%' THEN 34
            WHEN s.district LIKE '%Ridgewood%' OR s.district LIKE '%Maspeth%' THEN 35
            WHEN s.district LIKE '%Forest Hills%' OR s.district LIKE '%Rego Park%' THEN 36
            WHEN s.district LIKE '%Flushing%' OR s.district LIKE '%Whitestone%' THEN 37
            WHEN s.district LIKE '%Fresh Meadows%' OR s.district LIKE '%Briarwood%' THEN 38
            WHEN s.district LIKE '%Kew Gardens%' OR s.district LIKE '%Woodhaven%' THEN 39
            WHEN s.district LIKE '%Howard Beach%' OR s.district LIKE '%Ozone Park%' THEN 40
            WHEN s.district LIKE '%Bayside%' OR s.district LIKE '%Auburndale%' THEN 41
            WHEN s.district LIKE '%Jamaica%' OR s.district LIKE '%Hollis%' THEN 42
            WHEN s.district LIKE '%Cambria Heights%' OR s.district LIKE '%Bellerose%' THEN 43
            WHEN s.district LIKE '%Rockaway%' OR s.district LIKE '%Broad Channel%' THEN 44
            
            -- Bronx Districts (45-56)
            WHEN s.district LIKE '%Hunts Point%' THEN 45
            WHEN s.district LIKE '%Longwood%' OR s.district LIKE '%Melrose%' OR s.district LIKE '%Mott Haven%' THEN 46
            WHEN s.district LIKE '%Belmont%' OR s.district LIKE '%East Tremont%' THEN 47
            WHEN s.district LIKE '%Concourse%' OR s.district LIKE '%Highbridge%' THEN 48
            WHEN s.district LIKE '%Morris Heights%' THEN 49
            WHEN s.district LIKE '%Crotona Park East%' OR s.district LIKE '%West Farms%' OR s.district LIKE '%Morrisania%' THEN 50
            WHEN s.district LIKE '%Bedford Park%' OR s.district LIKE '%Fordham%' OR s.district LIKE '%Norwood%' THEN 51
            WHEN s.district LIKE '%Riverdale%' OR s.district LIKE '%Kingsbridge%' THEN 52
            WHEN s.district LIKE '%Parkchester%' OR s.district LIKE '%Castle Hill%' OR s.district LIKE '%Soundview%' THEN 53
            WHEN s.district LIKE '%Co-op City%' OR s.district LIKE '%Pelham Bay%' OR s.district LIKE '%Schuylerville%' OR s.district LIKE '%Throgs Neck%' THEN 54
            WHEN s.district LIKE '%Pelham Parkway%' OR s.district LIKE '%Morris Park%' OR s.district LIKE '%Laconia%' THEN 55
            WHEN s.district LIKE '%Wakefield%' OR s.district LIKE '%Williamsbridge%' OR s.district LIKE '%Eastchester%' OR s.district LIKE '%Woodlawn%' THEN 56
            
            -- Staten Island Districts (57-59)
            WHEN s.district LIKE '%North Shore%' OR s.district LIKE '%New Springville%' OR s.district LIKE '%South Beach%' THEN 57
            WHEN s.district LIKE '%South Shore%' OR s.district LIKE '%Tottenville%' OR s.district LIKE '%Great Kills%' OR s.district LIKE '%Annadale%' THEN 58
            WHEN s.district LIKE '%Mid-Island%' OR s.district LIKE '%Port Richmond%' OR s.district LIKE '%Stapleton%' OR s.district LIKE '%Mariners Harbor%' THEN 59
            
            ELSE NULL
        END AS district_id,
        
        -- Retrieve official district name
        CASE
            WHEN s.district LIKE '%Greenpoint%' OR s.district LIKE '%Williamsburg%' THEN 'Greenpoint & Williamsburg'
            WHEN s.district LIKE '%Fort Greene%' OR s.district LIKE '%Downtown Brooklyn%' OR s.district LIKE '%Brooklyn Heights%' THEN 'Brooklyn Heights, Downtown Brooklyn, & Fort Greene'
            WHEN s.district LIKE '%Bedford-Stuyvesant%' THEN 'Bedford-Stuyvesant'
            WHEN s.district LIKE '%Bushwick%' THEN 'Bushwick'
            WHEN s.district LIKE '%East New York%' OR s.district LIKE '%Cypress Hills%' OR s.district LIKE '%Starrett City%' THEN 'East New York, Cypress Hills, & Starrett City'
            WHEN s.district LIKE '%Park Slope%' OR s.district LIKE '%Red Hook%' OR s.district LIKE '%Carroll Gardens%' THEN 'Park Slope, Carroll Gardens & Red Hook'
            WHEN s.district LIKE '%Sunset Park%' OR s.district LIKE '%Windsor Terrace%' THEN 'Sunset Park & Windsor Terrace'
            WHEN s.district LIKE '%Crown Heights (North)%' OR s.district LIKE '%Prospect Heights%' THEN 'Crown Heights North & Prospect Heights'
            WHEN s.district LIKE '%Crown Heights (South)%' OR s.district LIKE '%Prospect Lefferts%' OR s.district LIKE '%Wingate%' THEN 'Crown Heights South, Prospect Lefferts & Wingate'
            WHEN s.district LIKE '%Bay Ridge%' OR s.district LIKE '%Dyker Heights%' THEN 'Bay Ridge & Dyker Heights'
            WHEN s.district LIKE '%Bensonhurst%' OR s.district LIKE '%Bath Beach%' THEN 'Bensonhurst & Bath Beach'
            WHEN s.district LIKE '%Borough Park%' OR s.district LIKE '%Ocean Parkway%' THEN 'Borough Park, Kensington & Ocean Parkway'
            WHEN s.district LIKE '%Brighton Beach%' OR s.district LIKE '%Coney Island%' THEN 'Brighton Beach & Coney Island'
            WHEN s.district LIKE '%Flatbush%' OR s.district LIKE '%Midwood%' THEN 'Flatbush & Midwood'
            WHEN s.district LIKE '%Sheepshead Bay%' OR s.district LIKE '%Gravesend%' OR s.district LIKE '%Gerritsen Beach%' THEN 'Sheepshead Bay, Gravesend, Gerritsen Beach & Homecrest'
            WHEN s.district LIKE '%Brownsville%' OR s.district LIKE '%Ocean Hill%' THEN 'Brownsville & Ocean Hill'
            WHEN s.district LIKE '%East Flatbush%' OR s.district LIKE '%Rugby%' THEN 'East Flatbush, Farragut & Rugby'
            WHEN s.district LIKE '%Canarsie%' OR s.district LIKE '%Flatlands%' THEN 'Canarsie & Flatlands'
            WHEN s.district LIKE '%Battery Park%' THEN 'Financial District & Battery Park City'
            WHEN s.district LIKE '%Financial District%' THEN 'Financial District & Battery Park City'
            WHEN s.district LIKE '%Lower East Side%' OR s.district LIKE '%Chinatown%' THEN 'Lower East Side & Chinatown'
            WHEN s.district LIKE '%Chelsea%' OR s.district LIKE "%Hell''s Kitchen%" THEN "Chelsea & Hell''s Kitchen"
            WHEN s.district LIKE '%Midtown%' OR s.district LIKE '%Flatiron%' THEN 'Midtown, Midtown East & Flatiron'
            WHEN s.district LIKE '%Gramercy%' OR s.district LIKE '%Stuyvesant Town%' THEN 'Murray Hill, Gramercy & Stuyvesant Town'
            WHEN s.district LIKE '%Upper West Side%' THEN 'Upper West Side'
            WHEN s.district LIKE '%Upper East Side%' OR s.district LIKE '%Roosevelt Island%' THEN 'Upper East Side & Roosevelt Island'
            WHEN s.district LIKE '%Morningside Heights%' OR s.district LIKE '%Hamilton Heights%' OR s.district LIKE '%Manhattanville%' THEN 'Morningside Heights & Hamilton Heights'
            WHEN s.district LIKE '%Harlem%' AND NOT (s.district LIKE '%East Harlem%') THEN 'Central Harlem'
            WHEN s.district LIKE '%East Harlem%' THEN 'East Harlem'
            WHEN s.district LIKE '%Washington Heights%' OR s.district LIKE '%Marble Hill%' THEN 'Washington Heights, Inwood & Marble Hill'
            WHEN s.district LIKE '%Astoria%' THEN 'Astoria & Long Island City'
            WHEN s.district LIKE '%Sunnyside%' OR s.district LIKE '%Woodside%' THEN 'Long Island City, Sunnyside & Woodside'
            WHEN s.district LIKE '%Jackson Heights%' THEN 'Jackson Heights & North Corona'
            WHEN s.district LIKE '%Elmhurst%' AND s.district LIKE '%Corona%' THEN 'Elmhurst & South Corona'
            WHEN s.district LIKE '%Ridgewood%' OR s.district LIKE '%Maspeth%' THEN 'Ridgewood, Glendale, Maspeth, & Middle Village'
            WHEN s.district LIKE '%Forest Hills%' OR s.district LIKE '%Rego Park%' THEN 'Forest Hills & Rego Park'
            WHEN s.district LIKE '%Flushing%' OR s.district LIKE '%Whitestone%' THEN 'Flushing, Murray Hill & Whitestone'
            WHEN s.district LIKE '%Fresh Meadows%' OR s.district LIKE '%Briarwood%' THEN 'Fresh Meadows, Hillcrest & Briarwood'
            WHEN s.district LIKE '%Kew Gardens%' OR s.district LIKE '%Woodhaven%' THEN 'Kew Gardens, Richmond Hill & Woodhaven'
            WHEN s.district LIKE '%Howard Beach%' OR s.district LIKE '%Ozone Park%' THEN 'Howard Beach & Ozone Park'
            WHEN s.district LIKE '%Bayside%' OR s.district LIKE '%Auburndale%' THEN 'Bayside, Douglaston, Auburndale, & Little Neck'
            WHEN s.district LIKE '%Jamaica%' OR s.district LIKE '%Hollis%' THEN 'Jamaica, Hollis & St. Albans'
            WHEN s.district LIKE '%Cambria Heights%' OR s.district LIKE '%Bellerose%' THEN 'Queens Village, Cambria Heights, Bellerose, & Rosedale'
            WHEN s.district LIKE '%Rockaway%' OR s.district LIKE '%Broad Channel%' THEN 'Far Rockaway, Breezy Point & Broad Channel'
            WHEN s.district LIKE '%Hunts Point%' THEN 'Hunts Point'
            WHEN s.district LIKE '%Longwood%' OR s.district LIKE '%Melrose%' OR s.district LIKE '%Mott Haven%' THEN 'Longwood, Melrose, & Mott Haven'
            WHEN s.district LIKE '%Belmont%' OR s.district LIKE '%East Tremont%' THEN 'Belmont & East Tremont'
            WHEN s.district LIKE '%Concourse%' OR s.district LIKE '%Highbridge%' THEN 'Concourse, High Bridge, & Mount Eden'
            WHEN s.district LIKE '%Morris Heights%' THEN 'Morris Heights, Mount Hope'
            WHEN s.district LIKE '%Crotona Park East%' OR s.district LIKE '%West Farms%' OR s.district LIKE '%Morrisania%' THEN 'Crotona Park East, West Farms, & Morrisania'
            WHEN s.district LIKE '%Bedford Park%' OR s.district LIKE '%Fordham%' OR s.district LIKE '%Norwood%' THEN 'Bedford Park, Fordham, & Norwood'
            WHEN s.district LIKE '%Riverdale%' OR s.district LIKE '%Kingsbridge%' THEN 'Riverdale & Kingsbridge'
            WHEN s.district LIKE '%Parkchester%' OR s.district LIKE '%Castle Hill%' OR s.district LIKE '%Soundview%' THEN 'Parkchester, Castle Hill, Clason Point, & Soundview'
            WHEN s.district LIKE '%Co-op City%' OR s.district LIKE '%Pelham Bay%' OR s.district LIKE '%Schuylerville%' OR s.district LIKE '%Throgs Neck%' THEN 'Co-op City, Pelham Bay, Schuylerville, & Throgs Neck'
            WHEN s.district LIKE '%Pelham Parkway%' OR s.district LIKE '%Morris Park%' OR s.district LIKE '%Laconia%' THEN 'Pelham Parkway, Morris Park, & Laconia'
            WHEN s.district LIKE '%Wakefield%' OR s.district LIKE '%Williamsbridge%' OR s.district LIKE '%Eastchester%' OR s.district LIKE '%Woodlawn%' THEN 'Wakefield, Williamsbridge, Eastchester, & Woodlawn'
            WHEN s.district LIKE '%North Shore%' OR s.district LIKE '%New Springville%' OR s.district LIKE '%South Beach%' THEN 'North Shore: New Springville & South Beach'
            WHEN s.district LIKE '%South Shore%' OR s.district LIKE '%Tottenville%' OR s.district LIKE '%Great Kills%' OR s.district LIKE '%Annadale%' THEN 'South Shore: Tottenville, Great Kills, & Annadale'
            WHEN s.district LIKE '%Mid-Island%' OR s.district LIKE '%Port Richmond%' OR s.district LIKE '%Stapleton%' OR s.district LIKE '%Mariners Harbor%' THEN 'Mid-Island: Port Richmond, Stapleton, & Mariners Harbor'
            
            ELSE NULL
        END AS district_name
        
    FROM
        nyc_analysis.staging_median_income s
    WHERE
        -- Data quality filter: must have at least the main household income
        s.`all_HHs` IS NOT NULL
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