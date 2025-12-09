--- Refresh script that calculates analysis tables that stem from the staging_median_rent table

--- 1. Creating the fact_median_rent table from the recently updated staging_median_rent table
CREATE OR REPLACE TABLE nyc_analysis.fact_median_rent AS
SELECT
    neighborhood,
    borough,
    area_type,
    year,
    month,    
    CAST(all_apts AS NUMERIC) AS all_apartments,
    CAST(COALESCE(`1bdr_apts`, 0) AS NUMERIC) AS one_bedroom,
    CAST(COALESCE(`3bdr_apts`, 0) AS NUMERIC) AS three_plus_bedroom,
    neighborhood_id,
    borough_id,
FROM (
    SELECT
        s.area_name as neighborhood,
        s.borough,
        s.area_type,
        s.year,
        s.month,
        s.all_apts,
        s.`1bdr_apts`,
        s.`3bdr_apts`,
        
        -- Map borough name to borough_id
        CASE
            WHEN s.borough = 'Manhattan' THEN 1
            WHEN s.borough = 'Brooklyn' THEN 2
            WHEN s.borough = 'Queens' THEN 3
            WHEN s.borough = 'Bronx' THEN 4
            WHEN s.borough = 'Staten Island' THEN 5
            ELSE NULL
        END AS borough_id,
        
        -- Map area_name to neighborhood_id (Brooklyn: 43-91)
        CASE
            WHEN s.area_name LIKE '%Bath Beach%' THEN 43
            WHEN s.area_name LIKE '%Bay Ridge%' THEN 44
            WHEN s.area_name LIKE '%Bedford-Stuyvesant%' THEN 45
            WHEN s.area_name LIKE '%Bensonhurst%' THEN 46
            WHEN s.area_name LIKE '%Bergen Beach%' THEN 47
            WHEN s.area_name LIKE '%Boerum Hill%' THEN 48
            WHEN s.area_name LIKE '%Borough Park%' THEN 49
            WHEN s.area_name LIKE '%Brighton Beach%' THEN 50
            WHEN s.area_name LIKE '%Brooklyn Heights%' THEN 51
            WHEN s.area_name LIKE '%Brownsville%' THEN 52
            WHEN s.area_name LIKE '%Bushwick%' THEN 53
            WHEN s.area_name LIKE '%Canarsie%' THEN 54
            WHEN s.area_name LIKE '%Carroll Gardens%' THEN 55
            WHEN s.area_name LIKE '%Clinton Hill%' THEN 56
            WHEN s.area_name LIKE '%Cobble Hill%' THEN 57
            WHEN s.area_name LIKE '%Columbia St Waterfront District%' THEN 58
            WHEN s.area_name LIKE '%Coney Island%' THEN 59
            WHEN s.area_name LIKE '%Crown Heights%' THEN 60
            WHEN s.area_name LIKE '%Ditmas Park%' THEN 61
            WHEN s.area_name LIKE '%Downtown Brooklyn%' THEN 62
            WHEN s.area_name LIKE '%DUMBO%' THEN 63
            WHEN s.area_name LIKE '%Dyker Heights%' THEN 64
            WHEN s.area_name LIKE '%East Flatbush%' THEN 65
            WHEN s.area_name LIKE '%East New York%' THEN 66
            WHEN s.area_name LIKE '%Flatbush%' THEN 67
            WHEN s.area_name LIKE '%Flatlands%' THEN 68
            WHEN s.area_name LIKE '%Fort Greene%' THEN 69
            WHEN s.area_name LIKE '%Gerritsen Beach%' THEN 70
            WHEN s.area_name LIKE '%Gowanus%' THEN 71
            WHEN s.area_name LIKE '%Gravesend%' THEN 72
            WHEN s.area_name LIKE '%Greenpoint%' THEN 73
            WHEN s.area_name LIKE '%Greenwood%' THEN 74
            WHEN s.area_name LIKE '%Kensington%' THEN 75
            WHEN s.area_name LIKE '%Manhattan Beach%' THEN 76
            WHEN s.area_name LIKE '%Marine Park%' THEN 77
            WHEN s.area_name LIKE '%Midwood%' THEN 78
            WHEN s.area_name LIKE '%Mill Basin%' THEN 79
            WHEN s.area_name LIKE '%Ocean Parkway%' THEN 80
            WHEN s.area_name LIKE '%Old Mill Basin%' THEN 81
            WHEN s.area_name LIKE '%Park Slope%' THEN 82
            WHEN s.area_name LIKE '%Prospect Heights%' THEN 83
            WHEN s.area_name LIKE '%Prospect Lefferts Gardens%' THEN 84
            WHEN s.area_name LIKE '%Prospect Park South%' THEN 85
            WHEN s.area_name LIKE '%Red Hook%' THEN 86
            WHEN s.area_name LIKE '%Seagate%' THEN 87
            WHEN s.area_name LIKE '%Sheepshead Bay%' THEN 88
            WHEN s.area_name LIKE '%Sunset Park%' THEN 89
            WHEN s.area_name LIKE '%Williamsburg%' THEN 90
            WHEN s.area_name LIKE '%Windsor Terrace%' THEN 91
            
            -- Manhattan neighborhoods (92-123)
            WHEN s.area_name LIKE '%Battery Park City%' THEN 92
            WHEN s.area_name LIKE '%Central Harlem%' THEN 93
            WHEN s.area_name LIKE '%Central Park South%' THEN 94
            WHEN s.area_name LIKE '%Chelsea%' THEN 95
            WHEN s.area_name LIKE '%Chinatown%' THEN 96
            WHEN s.area_name LIKE '%Civic Center%' THEN 97
            WHEN s.area_name LIKE '%East Harlem%' THEN 98
            WHEN s.area_name LIKE '%East Village%' THEN 99
            WHEN s.area_name LIKE '%Financial District%' THEN 100
            WHEN s.area_name LIKE '%Flatiron%' THEN 101
            WHEN s.area_name LIKE '%Gramercy Park%' THEN 102
            WHEN s.area_name LIKE '%Greenwich Village%' THEN 103
            WHEN s.area_name LIKE '%Hamilton Heights%' THEN 104
            WHEN s.area_name LIKE "%Hell's Kitchen%" THEN 105
            WHEN s.area_name LIKE '%Inwood%' THEN 106
            WHEN s.area_name LIKE '%Little Italy%' THEN 107
            WHEN s.area_name LIKE '%Lower East Side%' THEN 108
            WHEN s.area_name LIKE '%Marble Hill%' THEN 109
            WHEN s.area_name LIKE '%Midtown East%' THEN 111
            WHEN s.area_name LIKE '%Midtown South%' THEN 112
            WHEN s.area_name LIKE '%Midtown West%' THEN 113
            WHEN s.area_name LIKE '%Morningside Heights%' THEN 114
            WHEN s.area_name LIKE '%Nolita%' THEN 115
            WHEN s.area_name LIKE '%Roosevelt Island%' THEN 116
            WHEN s.area_name LIKE '%Soho%' THEN 117
            WHEN s.area_name LIKE '%Stuyvesant Town%' THEN 118
            WHEN s.area_name LIKE '%Tribeca%' THEN 119
            WHEN s.area_name LIKE '%Upper East Side%' THEN 120
            WHEN s.area_name LIKE '%Upper West Side%' THEN 121
            WHEN s.area_name LIKE '%Washington Heights%' THEN 122
            WHEN s.area_name LIKE '%West Harlem%' THEN 123
            WHEN s.area_name LIKE '%West Village%' THEN 124
            WHEN s.area_name LIKE '%Midtown%' AND s.area_name NOT LIKE '%Midtown East%' AND s.area_name NOT LIKE '%Midtown South%' AND s.area_name NOT LIKE '%Midtown West%' THEN 110
            
            -- Queens neighborhoods (124-177)
            WHEN s.area_name LIKE '%Astoria%' THEN 125
            WHEN s.area_name LIKE '%Auburndale%' THEN 126
            WHEN s.area_name LIKE '%Bayside%' THEN 127
            WHEN s.area_name LIKE '%Bellerose%' THEN 128
            WHEN s.area_name LIKE '%Briarwood%' THEN 129
            WHEN s.area_name LIKE '%Brookville%' THEN 130
            WHEN s.area_name LIKE '%Cambria Heights%' THEN 131
            WHEN s.area_name LIKE '%Clearview%' THEN 132
            WHEN s.area_name LIKE '%College Point%' THEN 133
            WHEN s.area_name LIKE '%Corona%' THEN 134
            WHEN s.area_name LIKE '%Douglaston%' THEN 135
            WHEN s.area_name LIKE '%East Elmhurst%' THEN 136
            WHEN s.area_name LIKE '%Elmhurst%' THEN 137
            WHEN s.area_name LIKE '%Floral Park%' THEN 138
            WHEN s.area_name LIKE '%Flushing%' THEN 139
            WHEN s.area_name LIKE '%Forest Hills%' THEN 140
            WHEN s.area_name LIKE '%Fresh Meadows%' THEN 141
            WHEN s.area_name LIKE '%Glen Oaks%' THEN 142
            WHEN s.area_name LIKE '%Glendale%' THEN 143
            WHEN s.area_name LIKE '%Hillcrest%' THEN 144
            WHEN s.area_name LIKE '%Hollis%' THEN 145
            WHEN s.area_name LIKE '%Howard Beach%' THEN 146
            WHEN s.area_name LIKE '%Jackson Heights%' THEN 147
            WHEN s.area_name LIKE '%Jamaica Estates%' THEN 149
            WHEN s.area_name LIKE '%Jamaica Hills%' THEN 150
            WHEN s.area_name LIKE '%Jamaica%' THEN 148
            WHEN s.area_name LIKE '%Kew Gardens Hills%' THEN 152
            WHEN s.area_name LIKE '%Kew Gardens%' THEN 151
            WHEN s.area_name LIKE '%Laurelton%' THEN 153
            WHEN s.area_name LIKE '%Little Neck%' THEN 154
            WHEN s.area_name LIKE '%Long Island City%' THEN 155
            WHEN s.area_name LIKE '%Maspeth%' THEN 156
            WHEN s.area_name LIKE '%Middle Village%' THEN 157
            WHEN s.area_name LIKE '%New Hyde Park%' THEN 158
            WHEN s.area_name LIKE '%North Corona%' THEN 159
            WHEN s.area_name LIKE '%Oakland Gardens%' THEN 160
            WHEN s.area_name LIKE '%Ozone Park%' THEN 161
            WHEN s.area_name LIKE '%Pomonok%' THEN 162
            WHEN s.area_name LIKE '%Queens Village%' THEN 163
            WHEN s.area_name LIKE '%Rego Park%' THEN 164
            WHEN s.area_name LIKE '%Richmond Hill%' THEN 165
            WHEN s.area_name LIKE '%Ridgewood%' THEN 166
            WHEN s.area_name LIKE '%Rockaway%' THEN 167
            WHEN s.area_name LIKE '%Rosedale%' THEN 168
            WHEN s.area_name LIKE '%South Jamaica%' THEN 169
            WHEN s.area_name LIKE '%South Ozone Park%' THEN 170
            WHEN s.area_name LIKE '%South Richmond Hill%' THEN 171
            WHEN s.area_name LIKE '%Springfield Gardens%' THEN 172
            WHEN s.area_name LIKE '%St. Albans%' THEN 173
            WHEN s.area_name LIKE '%Sunnyside%' THEN 174
            WHEN s.area_name LIKE '%Utopia%' THEN 175
            WHEN s.area_name LIKE '%Whitestone%' THEN 176
            WHEN s.area_name LIKE '%Woodhaven%' THEN 177
            WHEN s.area_name LIKE '%Woodside%' THEN 178
            
            -- Bronx neighborhoods (1-42)
            WHEN s.area_name LIKE '%Baychester%' THEN 1
            WHEN s.area_name LIKE '%Bedford Park%' THEN 2
            WHEN s.area_name LIKE '%Belmont%' THEN 3
            WHEN s.area_name LIKE '%Bronxwood%' THEN 4
            WHEN s.area_name LIKE '%Castle Hill%' THEN 5
            WHEN s.area_name LIKE '%City Island%' THEN 6
            WHEN s.area_name LIKE '%Co-op City%' THEN 7
            WHEN s.area_name LIKE '%Concourse%' THEN 8
            WHEN s.area_name LIKE '%Country Club%' THEN 9
            WHEN s.area_name LIKE '%Crotona Park East%' THEN 10
            WHEN s.area_name LIKE '%East Tremont%' THEN 11
            WHEN s.area_name LIKE '%Eastchester%' THEN 12
            WHEN s.area_name LIKE '%Edenwald%' THEN 13
            WHEN s.area_name LIKE '%Fordham%' THEN 14
            WHEN s.area_name LIKE '%Highbridge%' THEN 15
            WHEN s.area_name LIKE '%Hunts Point%' THEN 16
            WHEN s.area_name LIKE '%Kingsbridge%' THEN 17
            WHEN s.area_name LIKE '%Laconia%' THEN 18
            WHEN s.area_name LIKE '%Longwood%' THEN 19
            WHEN s.area_name LIKE '%Melrose%' THEN 20
            WHEN s.area_name LIKE '%Morris Heights%' THEN 21
            WHEN s.area_name LIKE '%Morris Park%' THEN 22
            WHEN s.area_name LIKE '%Morrisania%' THEN 23
            WHEN s.area_name LIKE '%Mott Haven%' THEN 24
            WHEN s.area_name LIKE '%Norwood%' THEN 25
            WHEN s.area_name LIKE '%Parkchester%' THEN 26
            WHEN s.area_name LIKE '%Pelham Bay%' THEN 27
            WHEN s.area_name LIKE '%Pelham Gardens%' THEN 28
            WHEN s.area_name LIKE '%Pelham Parkway%' THEN 29
            WHEN s.area_name LIKE '%Port Morris%' THEN 30
            WHEN s.area_name LIKE '%Riverdale%' THEN 31
            WHEN s.area_name LIKE '%Schuylerville%' THEN 32
            WHEN s.area_name LIKE '%Soundview%' THEN 33
            WHEN s.area_name LIKE '%Throgs Neck%' THEN 34
            WHEN s.area_name LIKE '%Tremont%' THEN 35
            WHEN s.area_name LIKE '%University Heights%' THEN 36
            WHEN s.area_name LIKE '%Van Nest%' THEN 37
            WHEN s.area_name LIKE '%Wakefield%' THEN 38
            WHEN s.area_name LIKE '%Westchester Village%' THEN 39
            WHEN s.area_name LIKE '%Williamsbridge%' THEN 40
            WHEN s.area_name LIKE '%Woodlawn%' THEN 41
            WHEN s.area_name LIKE '%Woodstock%' THEN 42
            
            ELSE NULL
        END AS neighborhood_id
    FROM
        nyc_analysis.staging_median_rent s
    WHERE
        -- Data quality: must have rent data
        s.all_apts IS NOT NULL
        -- Filter to only neighborhood and borough level data
        AND UPPER(s.area_type) IN ('NEIGHBORHOOD', 'BOROUGH')
)
WHERE
    -- Exclude records where we couldn't map to a neighborhood_id or borough_id
    neighborhood_id IS NOT NULL
    AND borough_id IS NOT NULL
-- Remove duplicates: keep most recent record per neighborhood/year/month
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY neighborhood_id, year, month 
) = 1
ORDER BY
    borough_id,
    neighborhood_id,
    year,
    month;

--- 2. Calculating subsequent Year-over-Year Changes in asking rent prices
CREATE OR REPLACE TABLE nyc_analysis.agg_yoy_rent_change AS
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
        
        -- Previous year averages (using LAG window function)
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
    year;