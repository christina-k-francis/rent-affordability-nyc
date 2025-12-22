--- BigQuery Database Development
--- Creating the Primary Table for District data

CREATE OR REPLACE TABLE `nyc_analysis.ref_districts` (
    district_id INT64,
    name STRING,
    district_num INT64,
    borough_id INT64
    -- FOREIGN KEY (borough_id) REFERENCES boroughs(borough_id)
);

-- Adding NYC community district data to the district table
-- Brooklyn Community Districts (Borough ID: 2)
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (1, 'Greenpoint & Williamsburg', 1, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (2, 'Brooklyn Heights, Downtown Brooklyn, & Fort Greene', 2, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (3, 'Bedford-Stuyvesant', 3, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (4, 'Bushwick', 4, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (5, 'East New York, Cypress Hills, & Starrett City', 5, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (6, 'Park Slope, Carroll Gardens & Red Hook', 6, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (7, 'Sunset Park & Windsor Terrace', 7, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (8, 'Crown Heights North & Prospect Heights', 8, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (9, 'Crown Heights South, Prospect Lefferts & Wingate', 9, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (10, 'Bay Ridge & Dyker Heights', 10, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (11, 'Bensonhurst & Bath Beach', 11, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (12, 'Borough Park, Kensington & Ocean Parkway', 12, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (13, 'Brighton Beach & Coney Island', 13, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (14, 'Flatbush & Midwood', 14, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (15, 'Sheepshead Bay, Gravesend, Gerritsen Beach & Homecrest', 15, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (16, 'Brownsville & Ocean Hill', 16, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (17, 'East Flatbush, Farragut & Rugby', 17, 2);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (18, 'Canarsie & Flatlands', 18, 2);
-- Manhattan Community Districts (Borough ID: 1)
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (19, 'Financial District & Battery Park City', 1, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (20, 'Greenwich Village', 2, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (21, 'Lower East Side & Chinatown', 3, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (22, "Chelsea & Hell's Kitchen", 4, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (23, 'Midtown, Midtown East & Flatiron', 5, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (24, 'Murray Hill, Gramercy & Stuyvesant Town', 6, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (25, 'Upper West Side', 7, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (26, 'Upper East Side & Roosevelt Island', 8, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (27, 'Morningside Heights & Hamilton Heights', 9, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (28, 'Central Harlem', 10, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (29, 'East Harlem', 11, 1);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (30, 'Washington Heights, Inwood & Marble Hill', 12, 1);
-- Queens Community Districts (Borough ID: 3)
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (31, 'Astoria & Long Island City', 1, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (32, 'Long Island City, Sunnyside & Woodside', 2, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (33, 'Jackson Heights & North Corona', 3, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (34, 'Elmhurst & South Corona', 4, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (35, 'Ridgewood, Glendale, Maspeth, & Middle Village', 5, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (36, 'Forest Hills & Rego Park', 6, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (37, 'Flushing, Murray Hill & Whitestone', 7, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (38, 'Fresh Meadows, Hillcrest & Briarwood', 8, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (39, 'Kew Gardens, Richmond Hill & Woodhaven', 9, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (40, 'Howard Beach & Ozone Park', 10, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (41, 'Bayside, Douglaston, Auburndale, & Little Neck', 11, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (42, 'Jamaica, Hollis & St. Albans', 12, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (43, 'Queens Village, Cambria Heights, Bellerose, & Rosedale', 13, 3);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (44, 'Far Rockaway, Breezy Point & Broad Channel', 14, 3);

-- Bronx Community Districts (Borough ID: 4)
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (45, 'HuntsPoint', 1, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (46, 'Longwood, Melrose, & Mott Haven', 2, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (47, 'Belmont & East Tremont', 3, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (48, 'Concourse, High Bridge, & Mount Eden', 4, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (49, 'Morris Heights, Mount Hope', 5, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (50, 'Crotona Park East, West Farms, & Morrisania', 6, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (51, 'Bedford Park, Fordham, & Norwood', 7, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (52, 'Riverdale & Kingsbridge', 8, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (53, 'Parkchester, Castle Hill, Clason Point, & Soundview', 9, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (54, 'Co-op City, Pelham Bay, Schuylerville, & Throgs Neck', 10, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (55, 'Pelham Parkway, Morris Park, & Laconia', 11, 4);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (56, 'Wakefield, Williamsbridge, Eastchester, & Woodlawn', 12, 4);

-- Staten Island Community Districts (Borough ID: 5)
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (57, 'North Shore: New Springville & South Beach', 1, 5);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (58, 'South Shore: Tottenville, Great Kills, & Annadale', 3, 5);
INSERT INTO nyc_analysis.ref_districts (district_id, name, district_num, borough_id) VALUES (59, 'Mid-Island: Port Richmond, Stapleton, & Mariners Harbor', 2, 5);
