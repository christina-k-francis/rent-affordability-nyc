--- BigQuery Database Development
--- Creating the Primary Table for Borough data

CREATE OR REPLACE TABLE `nyc_analysis.ref_boroughs` (
    borough_id INT64,
    name STRING
);

-- Adding borough table data
INSERT INTO nyc_analysis.ref_boroughs (borough_id, name) VALUES (1, 'Manhattan');
INSERT INTO nyc_analysis.ref_boroughs (borough_id, name) VALUES (2, 'Brooklyn');
INSERT INTO nyc_analysis.ref_boroughs (borough_id, name) VALUES (3, 'Queens');
INSERT INTO nyc_analysis.ref_boroughs (borough_id, name) VALUES (4, 'Bronx');
INSERT INTO nyc_analysis.ref_boroughs (borough_id, name) VALUES (5, 'Staten Island');