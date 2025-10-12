--- Calculating YoY Rate Changes in Rent by Neighborhood
CREATE TABLE yoy_rent_change AS
SELECT 
    neighborhood_name,
    borough_name,
    year,
    avg_monthly_rent_all,
    prev_rent_all,
    CASE 
        WHEN prev_rent_all > 0 THEN 
            ROUND(((avg_monthly_rent_all - prev_rent_all) / prev_rent_all * 100), 2)
        ELSE NULL 
    END AS yoy_change_pct_all,
    
    avg_monthly_rent_1bdr,
    prev_rent_1bdr,
    CASE 
        WHEN prev_rent_1bdr > 0 THEN 
            ROUND(((avg_monthly_rent_1bdr - prev_rent_1bdr) / prev_rent_1bdr * 100), 2)
        ELSE NULL 
    END AS yoy_change_pct_1bdr,
    
    avg_monthly_rent_3bdr,
    prev_rent_3bdr,
    CASE 
        WHEN prev_rent_3bdr > 0 THEN 
            ROUND(((avg_monthly_rent_3bdr - prev_rent_3bdr) / prev_rent_3bdr * 100), 2)
        ELSE NULL 
    END AS yoy_change_pct_3bdr,
    
    months_of_data,

    neighborhood_id,
    borough_id

FROM (
    SELECT 
        n.name AS neighborhood_name,
        b.name AS borough_name,
        mr.year,
        ROUND(AVG(mr.all_apts::NUMERIC), 2) AS avg_monthly_rent_all,
        ROUND(AVG(mr."1bdr_apts"::NUMERIC), 2) AS avg_monthly_rent_1bdr,
        ROUND(AVG(mr."3bdr_apts"::NUMERIC), 2) AS avg_monthly_rent_3bdr,
        COUNT(mr.month) AS months_of_data,
        LAG(ROUND(AVG(mr.all_apts::NUMERIC), 2)) OVER (
            PARTITION BY n.name, b.name ORDER BY mr.year
        ) AS prev_rent_all,
        LAG(ROUND(AVG(mr."1bdr_apts"::NUMERIC), 2)) OVER (
            PARTITION BY n.name, b.name ORDER BY mr.year
        ) AS prev_rent_1bdr,
        LAG(ROUND(AVG(mr."3bdr_apts"::NUMERIC), 2)) OVER (
            PARTITION BY n.name, b.name ORDER BY mr.year
        ) AS prev_rent_3bdr,
        mr.neighborhood_id,
        mr.borough_id
    FROM median_rent mr
    JOIN neighborhoods n ON mr.neighborhood_id = n.neighborhood_id
    JOIN boroughs b ON n.borough_id = b.borough_id
    WHERE mr.all_apts IS NOT NULL
    GROUP BY n.name, b.name, mr.year,
        mr.neighborhood_id, mr.borough_id
) rent_with_lag
ORDER BY borough_name, neighborhood_name, year;


--- Calculating YoY Rate Changes in Income by Neighborhood
CREATE TABLE yoy_income_change AS
SELECT 
    neighborhood_name,
    borough_name,
    year,
    avg_income_all_hhs,
    prev_income_all,
    CASE 
        WHEN prev_income_all > 0 THEN 
            ROUND(((avg_income_all_hhs - prev_income_all) / prev_income_all * 100), 2)
        ELSE NULL 
    END AS yoy_change_pct_all_hhs,
    
    avg_income_singles,
    prev_income_singles,
    CASE 
        WHEN prev_income_singles > 0 THEN 
            ROUND(((avg_income_singles - prev_income_singles) / prev_income_singles * 100), 2)
        ELSE NULL 
    END AS yoy_change_pct_singles,

    avg_income_married_kids,
    prev_income_married_kids,
    CASE 
        WHEN prev_income_married_kids > 0 THEN 
            ROUND(((avg_income_married_kids - prev_income_married_kids) / prev_income_married_kids * 100), 2)
        ELSE NULL 
    END AS yoy_change_pct_married_kids,

    avg_income_other_kids,
    prev_income_other_kids,
    CASE 
        WHEN prev_income_other_kids > 0 THEN 
            ROUND(((avg_income_other_kids - prev_income_other_kids) / prev_income_other_kids * 100), 2)
        ELSE NULL 
    END AS yoy_change_pct_other_kids,

    district_id
    
FROM (
    SELECT 
        n.name AS neighborhood_name,
        b.name AS borough_name,
        mi.district_id,
        mi.year,
        ROUND(AVG(mi."income_all_HHs"::NUMERIC), 2) AS avg_income_all_hhs,
        ROUND(AVG(mi.income_singles::NUMERIC), 2) AS avg_income_singles,
        ROUND(AVG(mi.income_married_kids::NUMERIC), 2) AS avg_income_married_kids,
        ROUND(AVG(mi.income_other_kids::NUMERIC), 2) AS avg_income_other_kids,
        LAG(ROUND(AVG(mi."income_all_HHs"::NUMERIC), 2)) OVER (
            PARTITION BY n.name, b.name ORDER BY mi.year
        ) AS prev_income_all,
        LAG(ROUND(AVG(mi.income_singles::NUMERIC), 2)) OVER (
            PARTITION BY n.name, b.name ORDER BY mi.year
        ) AS prev_income_singles,
        LAG(ROUND(AVG(mi.income_married_kids::NUMERIC), 2)) OVER (
            PARTITION BY n.name, b.name ORDER BY mi.year
        ) AS prev_income_married_kids,
        LAG(ROUND(AVG(mi.income_other_kids::NUMERIC), 2)) OVER (
            PARTITION BY n.name, b.name ORDER BY mi.year
        ) AS prev_income_other_kids
    FROM median_income mi
    JOIN district_neighborhoods dn ON mi.district_id = dn.district_id
    JOIN neighborhoods n ON dn.neighborhood_id = n.neighborhood_id
    JOIN boroughs b ON n.borough_id = b.borough_id
    WHERE mi."income_all_HHs" IS NOT NULL
        AND mi.income_singles IS NOT NULL
        AND mi.income_married_kids IS NOT NULL
        AND mi.income_other_kids IS NOT NULL
    GROUP BY n.name, b.name, mi.district_id, mi.year
) income_with_lag
ORDER BY borough_name, neighborhood_name, year;