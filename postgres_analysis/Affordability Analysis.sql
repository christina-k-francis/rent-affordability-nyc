-- Analyzing Affordability Over Time for Different Household Populations

CREATE TABLE affordability AS
SELECT
    borough,
    neighborhood,
    year,
    rent_all,
    rent_1bdr,
    rent_3bdr,
    income_all,
    income_singles,
    income_married_kids,
    income_other_kids,
    afford_ratio_all,
    afford_ratio_singles,
    afford_ratio_married_kids,
    afford_ratio_other_kids,
    neighborhood_id,
    borough_id,
    district_id
FROM (
    SELECT
        mr.area_name AS neighborhood,
        mr.borough AS borough,
        mr.year AS year,
        mr.neighborhood_id,
        mr.borough_id,
        mi.district_id,
        -- Average monthly median rent values to get annual averages
        ROUND(AVG(mr.all_apts)::NUMERIC, 2) AS rent_all,
        ROUND(AVG(mr."1bdr_apts")::NUMERIC, 2) AS rent_1bdr,
        ROUND(AVG(mr."3bdr_apts")::NUMERIC, 2) AS rent_3bdr,
        ROUND(AVG(mi."income_all_HHs"::NUMERIC), 2) AS income_all,
        ROUND(AVG(mi.income_singles::NUMERIC), 2) AS income_singles,
        ROUND(AVG(mi.income_married_kids::NUMERIC), 2) AS income_married_kids,
        ROUND(AVG(mi.income_other_kids::NUMERIC), 2) AS income_other_kids,
        -- Calculate affordability ratios using annual averages
        ROUND(AVG(mr.all_apts)::NUMERIC / 
            (AVG(mi."income_all_HHs"::NUMERIC)/12), 2) AS afford_ratio_all,
        ROUND(AVG(mr."1bdr_apts")::NUMERIC / 
            (AVG(mi.income_singles::NUMERIC)/12), 2) AS afford_ratio_singles,
        ROUND(AVG(mr."3bdr_apts")::NUMERIC / 
            (AVG(mi.income_married_kids::NUMERIC)/12), 2) AS afford_ratio_married_kids,
        ROUND(AVG(mr."3bdr_apts")::NUMERIC / 
            (AVG(mi.income_other_kids::NUMERIC)/12), 2) AS afford_ratio_other_kids
    FROM median_rent mr
    JOIN district_neighborhoods dn ON dn.neighborhood_id = mr.neighborhood_id
    JOIN median_income mi ON mi.district_id = dn.district_id
        AND mi.year::INTEGER = mr.year::INTEGER
    WHERE mi."income_all_HHs" IS NOT NULL AND mi."income_all_HHs" > 0
        AND mi.income_singles IS NOT NULL AND mi.income_singles > 0
        AND mi.income_married_kids IS NOT NULL AND mi.income_married_kids > 0
        AND mi.income_other_kids IS NOT NULL AND mi.income_other_kids > 0
        AND mr.all_apts IS NOT NULL AND mr.all_apts > 0
        AND mr."1bdr_apts" IS NOT NULL AND mr."1bdr_apts" > 0
        AND mr."3bdr_apts" IS NOT NULL AND mr."3bdr_apts" > 0
    GROUP BY mr.area_name, mr.borough, mr.year, 
        mr.neighborhood_id, mr.borough_id, mi.district_id
) affordability_ratios
ORDER BY borough, neighborhood, year;