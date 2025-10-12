--- BigQuery Database Development
--- Primary Tables Schema for use with Median Rent & Income data

CREATE TABLE nyc_analysis.boroughs (
    borough_id INT64,
    name STRING
);

CREATE TABLE nyc_analysis.neighborhoods (
    neighborhood_id INT64,
    name STRING,
    borough_id INT64
    -- FOREIGN KEY (borough_id) REFERENCES boroughs(borough_id)
);

CREATE TABLE nyc_analysis.districts (
    district_id INT64,
    name STRING,
    district_num INT64,
    borough_id INT64
    -- FOREIGN KEY (borough_id) REFERENCES boroughs(borough_id)
);

CREATE TABLE nyc_analysis.district_neighborhoods (
    district_id INT64,
    neighborhood_id INT64,
    borough_id INT64
    -- PRIMARY KEY (district_id, neighborhood_id)
    -- FOREIGN KEY (district_id) REFERENCES districts(district_id)
    -- FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(neighborhood_id)
    -- FOREIGN KEY (borough_id) REFERENCES boroughs(borough_id)
);

-- Adding borough table data
INSERT INTO nyc_analysis.boroughs (borough_id, name) VALUES (1, 'Manhattan');
INSERT INTO nyc_analysis.boroughs (borough_id, name) VALUES (2, 'Brooklyn');
INSERT INTO nyc_analysis.boroughs (borough_id, name) VALUES (3, 'Queens');
INSERT INTO nyc_analysis.boroughs (borough_id, name) VALUES (4, 'Bronx');
INSERT INTO nyc_analysis.boroughs (borough_id, name) VALUES (5, 'Staten Island');

-- Adding neighborhood table data
-- Bronx neighborhoods (Borough ID: 4)
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (1, 'Baychester', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (2, 'Bedford Park', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (3, 'Belmont', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (4, 'Bronxwood', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (5, 'Castle Hill', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (6, 'City Island', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (7, 'Co-op City', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (8, 'Concourse', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (9, 'Country Club', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (10, 'Crotona Park East', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (11, 'East Tremont', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (12, 'Eastchester', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (13, 'Edenwald', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (14, 'Fordham', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (15, 'Highbridge', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (16, 'Hunts Point', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (17, 'Kingsbridge', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (18, 'Laconia', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (19, 'Longwood', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (20, 'Melrose', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (21, 'Morris Heights', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (22, 'Morris Park', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (23, 'Morrisania', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (24, 'Mott Haven', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (25, 'Norwood', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (26, 'Parkchester', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (27, 'Pelham Bay', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (28, 'Pelham Gardens', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (29, 'Pelham Parkway', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (30, 'Port Morris', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (31, 'Riverdale', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (32, 'Schuylerville', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (33, 'Soundview', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (34, 'Throgs Neck', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (35, 'Tremont', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (36, 'University Heights', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (37, 'Van Nest', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (38, 'Wakefield', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (39, 'Westchester Village', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (40, 'Williamsbridge', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (41, 'Woodlawn', 4);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (42, 'Woodstock', 4);
-- Brooklyn Neighborhoods (Borough ID: 2)
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (43, 'Bath Beach', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (44, 'Bay Ridge', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (45, 'Bedford-Stuyvesant', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (46, 'Bensonhurst', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (47, 'Bergen Beach', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (48, 'Boerum Hill', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (49, 'Borough Park', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (50, 'Brighton Beach', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (51, 'Brooklyn Heights', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (52, 'Brownsville', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (53, 'Bushwick', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (54, 'Canarsie', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (55, 'Carroll Gardens', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (56, 'Clinton Hill', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (57, 'Cobble Hill', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (58, 'Columbia St Waterfront District', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (59, 'Coney Island', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (60, 'Crown Heights', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (61, 'Ditmas Park', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (62, 'Downtown Brooklyn', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (63, 'DUMBO', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (64, 'Dyker Heights', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (65, 'East Flatbush', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (66, 'East New York', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (67, 'Flatbush', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (68, 'Flatlands', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (69, 'Fort Greene', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (70, 'Gerritsen Beach', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (71, 'Gowanus', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (72, 'Gravesend', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (73, 'Greenpoint', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (74, 'Greenwood', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (75, 'Kensington', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (76, 'Manhattan Beach', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (77, 'Marine Park', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (78, 'Midwood', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (79, 'Mill Basin', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (80, 'Ocean Parkway', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (81, 'Old Mill Basin', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (82, 'Park Slope', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (83, 'Prospect Heights', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (84, 'Prospect Lefferts Gardens', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (85, 'Prospect Park South', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (86, 'Red Hook', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (87, 'Seagate', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (88, 'Sheepshead Bay', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (89, 'Sunset Park', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (90, 'Williamsburg', 2);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (91, 'Windsor Terrace', 2);
-- Manhattan Neighborhoods (Borough ID: 1)
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (92, 'Battery Park City', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (93, 'Central Harlem', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (94, 'Central Park South', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (95, 'Chelsea', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (96, 'Chinatown', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (97, 'Civic Center', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (98, 'East Harlem', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (99, 'East Village', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (100, 'Financial District', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (101, 'Flatiron', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (102, 'Gramercy Park', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (103, 'Greenwich Village', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (104, 'Hamilton Heights', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (105, 'Inwood', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (106, 'Little Italy', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (107, 'Lower East Side', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (108, 'Marble Hill', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (109, 'Midtown', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (110, 'Midtown East', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (111, 'Midtown South', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (112, 'Midtown West', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (113, 'Morningside Heights', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (114, 'Nolita', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (115, 'Roosevelt Island', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (116, 'Soho', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (117, 'Stuyvesant Town/PCV', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (118, 'Tribeca', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (119, 'Upper East Side', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (120, 'Upper West Side', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (121, 'Washington Heights', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (122, 'West Harlem', 1);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (123, 'West Village', 1);
-- Queens Neighborhoods (Borough ID: 3)
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (124, 'Astoria', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (125, 'Auburndale', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (126, 'Bayside', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (127, 'Bellerose', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (128, 'Briarwood', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (129, 'Brookville', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (130, 'Cambria Heights', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (131, 'Clearview', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (132, 'College Point', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (133, 'Corona', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (134, 'Douglaston', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (135, 'East Elmhurst', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (136, 'Elmhurst', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (137, 'Floral Park', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (138, 'Flushing', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (139, 'Forest Hills', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (140, 'Fresh Meadows', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (141, 'Glen Oaks', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (142, 'Glendale', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (143, 'Hillcrest', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (144, 'Hollis', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (145, 'Howard Beach', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (146, 'Jackson Heights', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (147, 'Jamaica', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (148, 'Jamaica Estates', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (149, 'Jamaica Hills', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (150, 'Kew Gardens', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (151, 'Kew Gardens Hills', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (152, 'Laurelton', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (153, 'Little Neck', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (154, 'Long Island City', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (155, 'Maspeth', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (156, 'Middle Village', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (157, 'New Hyde Park', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (158, 'North Corona', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (159, 'Oakland Gardens', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (160, 'Ozone Park', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (161, 'Pomonok', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (162, 'Queens Village', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (163, 'Rego Park', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (164, 'Richmond Hill', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (165, 'Ridgewood', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (166, 'Rockaway All', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (167, 'Rosedale', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (168, 'South Jamaica', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (169, 'South Ozone Park', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (170, 'South Richmond Hill', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (171, 'Springfield Gardens', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (172, 'St. Albans', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (173, 'Sunnyside', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (174, 'Utopia', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (175, 'Whitestone', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (176, 'Woodhaven', 3);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (177, 'Woodside', 3);
-- Staten Island Neighborhoods (Borough ID: 5)
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (178, 'North Shore', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (179, 'Port Richmond', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (180, 'Stapleton', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (181, 'Mariners Harbor', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (182, 'Mid-Island', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (183, 'New Springville', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (184, 'South Beach', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (185, 'South Shore', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (186, 'Tottenville', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (187, 'Great Kills', 5);
INSERT INTO nyc_analysis.neighborhoods (neighborhood_id, name, borough_id) VALUES (188, 'Annadale', 5);

-- Adding NYC community district data to the district table
-- Brooklyn Community Districts (Borough ID: 2)
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (1, 'Greenpoint & Williamsburg', 1, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (2, 'Brooklyn Heights, Downtown Brooklyn, & Fort Greene', 2, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (3, 'Bedford-Stuyvesant', 3, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (4, 'Bushwick', 4, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (5, 'East New York, Cypress Hills, & Starrett City', 5, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (6, 'Park Slope, Carroll Gardens & Red Hook', 6, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (7, 'Sunset Park & Windsor Terrace', 7, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (8, 'Crown Heights North & Prospect Heights', 8, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (9, 'Crown Heights South, Prospect Lefferts & Wingate', 9, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (10, 'Bay Ridge & Dyker Heights', 10, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (11, 'Bensonhurst & Bath Beach', 11, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (12, 'Borough Park, Kensington & Ocean Parkway', 12, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (13, 'Brighton Beach & Coney Island', 13, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (14, 'Flatbush & Midwood', 14, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (15, 'Sheepshead Bay, Gravesend, Gerritsen Beach & Homecrest', 15, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (16, 'Brownsville & Ocean Hill', 16, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (17, 'East Flatbush, Farragut & Rugby', 17, 2);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (18, 'Canarsie & Flatlands', 18, 2);
-- Manhattan Community Districts (Borough ID: 1)
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (19, 'Financial District & Battery Park City', 1, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (20, 'Greenwich Village', 2, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (21, 'Lower East Side & Chinatown', 3, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (22, "Chelsea & Hell's Kitchen", 4, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (23, 'Midtown, Midtown East & Flatiron', 5, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (24, 'Murray Hill, Gramercy & Stuyvesant Town', 6, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (25, 'Upper West Side', 7, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (26, 'Upper East Side & Roosevelt Island', 8, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (27, 'Morningside Heights & Hamilton Heights', 9, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (28, 'Central Harlem', 10, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (29, 'East Harlem', 11, 1);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (30, 'Washington Heights, Inwood & Marble Hill', 12, 1);
-- Queens Community Districts (Borough ID: 3)
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (31, 'Astoria & Long Island City', 1, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (32, 'Long Island City, Sunnyside & Woodside', 2, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (33, 'Jackson Heights & North Corona', 3, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (34, 'Elmhurst & South Corona', 4, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (35, 'Ridgewood, Glendale, Maspeth, & Middle Village', 5, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (36, 'Forest Hills & Rego Park', 6, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (37, 'Flushing, Murray Hill & Whitestone', 7, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (38, 'Fresh Meadows, Hillcrest & Briarwood', 8, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (39, 'Kew Gardens, Richmond Hill & Woodhaven', 9, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (40, 'Howard Beach & Ozone Park', 10, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (41, 'Bayside, Douglaston, Auburndale, & Little Neck', 11, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (42, 'Jamaica, Hollis & St. Albans', 12, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (43, 'Queens Village, Cambria Heights, Bellerose, & Rosedale', 13, 3);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (44, 'Far Rockaway, Breezy Point & Broad Channel', 14, 3);

-- Bronx Community Districts (Borough ID: 4)
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (45, 'HuntsPoint', 1, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (46, 'Longwood, Melrose, & Mott Haven', 2, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (47, 'Belmont & East Tremont', 3, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (48, 'Concourse, High Bridge, & Mount Eden', 4, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (49, 'Morris Heights, Mount Hope', 5, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (50, 'Crotona Park East, West Farms, & Morrisania', 6, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (51, 'Bedford Park, Fordham, & Norwood', 7, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (52, 'Riverdale & Kingsbridge', 8, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (53, 'Parkchester, Castle Hill, Clason Point, & Soundview', 9, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (54, 'Co-op City, Pelham Bay, Schuylerville, & Throgs Neck', 10, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (55, 'Pelham Parkway, Morris Park, & Laconia', 11, 4);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (56, 'Wakefield, Williamsbridge, Eastchester, & Woodlawn', 12, 4);

-- Staten Island Community Districts (Borough ID: 5)
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (57, 'North Shore: New Springville & South Beach', 1, 5);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (58, 'South Shore: Tottenville, Great Kills, & Annadale', 3, 5);
INSERT INTO nyc_analysis.districts (district_id, name, district_num, borough_id) VALUES (59, 'Mid-Island: Port Richmond, Stapleton, & Mariners Harbor', 2, 5);

-- Adding foreign keys to the district_neighborhoods junction table
-- Brooklyn Community Districts
-- District 1: Greenpoint & Williamsburg
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (1, 73, 2),  -- Greenpoint
    (1, 90, 2);  -- Williamsburg

-- District 2: Brooklyn Heights, Downtown Brooklyn, & Fort Greene
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (2, 51, 2),  -- Brooklyn Heights
    (2, 69, 2),  -- Fort Greene
    (2, 62, 2);  -- Downtown Brooklyn

-- District 3: Bedford-Stuyvesant
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (3, 45, 2);  -- Bedford-Stuyvesant

-- District 4: Bushwick
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (4, 53, 2);  -- Bushwick

-- District 5: East New York, Cypress Hills, & Starrett City
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (5, 66, 2);  -- East New York

-- District 6: Park Slope, Carroll Gardens & Red Hook
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (6, 82, 2),  -- Park Slope
    (6, 55, 2),  -- Carroll Gardens
    (6, 86, 2);  -- Red Hook

-- District 7: Sunset Park & Windsor Terrace
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (7, 89, 2),  -- Sunset Park
    (7, 91, 2);  -- Windsor Terrace

-- District 8: Crown Heights North & Prospect Heights
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (8, 60, 2),  -- Crown Heights
    (8, 83, 2);  -- Prospect Heights

-- District 9: Crown Heights South, Prospect Lefferts & Wingate
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (9, 60, 2),  -- Crown Heights
    (9, 84, 2);  -- Prospect Lefferts Gardens

-- District 10: Bay Ridge & Dyker Heights
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (10, 44, 2),  -- Bay Ridge
    (10, 64, 2);  -- Dyker Heights

-- District 11: Bensonhurst & Bath Beach
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (11, 46, 2),  -- Bensonhurst
    (11, 43, 2);  -- Bath Beach

-- District 12: Borough Park, Kensington & Ocean Parkway
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (12, 49, 2),  -- Borough Park
    (12, 75, 2),  -- Kensington
    (12, 80, 2);  -- Ocean Parkway

-- District 13: Brighton Beach & Coney Island
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (13, 50, 2),  -- Brighton Beach
    (13, 59, 2);  -- Coney Island

-- District 14: Flatbush & Midwood
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (14, 67, 2),  -- Flatbush
    (14, 78, 2);  -- Midwood

-- District 15: Sheepshead Bay, Gravesend, Gerritsen Beach & Homecrest
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (15, 88, 2),  -- Sheepshead Bay
    (15, 70, 2),  -- Gerritsen Beach
    (15, 72, 2);  -- Gravesend

-- District 16: Brownsville & Ocean Hill
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (16, 52, 2);  -- Brownsville

-- District 17: East Flatbush, Farragut & Rugby
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (17, 65, 2);  -- East Flatbush

-- District 18: Canarsie & Flatlands
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (18, 54, 2),  -- Canarsie
    (18, 68, 2);  -- Flatlands

-- Manhattan Community Districts
-- District 19: Financial District & Battery Park City
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (19, 100, 1),  -- Financial District
    (19, 92, 1);   -- Battery Park City

-- District 20: Greenwich Village
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (20, 103, 1);  -- Greenwich Village

-- District 21: Lower East Side & Chinatown
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (21, 107, 1),  -- Lower East Side
    (21, 96, 1);   -- Chinatown

-- District 22: Chelsea & Hell's Kitchen
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (22, 95, 1);   -- Chelsea

-- District 23: Midtown, Midtown East & Flatiron
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (23, 109, 1),  -- Midtown
    (23, 110, 1),  -- Midtown East
    (23, 111, 1),  -- Midtown South
    (23, 112, 1),  -- Midtown West
    (23, 101, 1);  -- Flatiron

-- District 24: Murray Hill, Gramercy & Stuyvesant Town
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (24, 102, 1),  -- Gramercy Park
    (24, 117, 1);  -- Stuyvesant Town/PCV

-- District 25: Upper West Side
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (25, 120, 1);  -- Upper West Side

-- District 26: Upper East Side & Roosevelt Island
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (26, 119, 1),  -- Upper East Side
    (26, 115, 1);  -- Roosevelt Island

-- District 27: Morningside Heights & Hamilton Heights
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (27, 113, 1),  -- Morningside Heights
    (27, 104, 1);  -- Hamilton Heights

-- District 28: Central Harlem
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (28, 93, 1);   -- Central Harlem

-- District 29: East Harlem
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (29, 98, 1);   -- East Harlem

-- District 30: Washington Heights, Inwood & Marble Hill
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (30, 121, 1),  -- Washington Heights
    (30, 105, 1),  -- Inwood
    (30, 108, 1);  -- Marble Hill

-- Queens Community Districts
-- District 31: Astoria & Long Island City
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (31, 124, 3),  -- Astoria
    (31, 154, 3);  -- Long Island City

-- District 32: Long Island City, Sunnyside & Woodside
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (32, 154, 3),  -- Long Island City
    (32, 173, 3),  -- Sunnyside
    (32, 177, 3);  -- Woodside

-- District 33: Jackson Heights & North Corona
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (33, 146, 3),  -- Jackson Heights
    (33, 158, 3);  -- North Corona

-- District 34: Elmhurst & South Corona
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (34, 136, 3),  -- Elmhurst
    (34, 133, 3);  -- Corona

-- District 35: Ridgewood, Glendale, Maspeth, & Middle Village
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (35, 165, 3),  -- Ridgewood
    (35, 142, 3),  -- Glendale
    (35, 155, 3),  -- Maspeth
    (35, 156, 3);  -- Middle Village

-- District 36: Forest Hills & Rego Park
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (36, 139, 3),  -- Forest Hills
    (36, 163, 3);  -- Rego Park

-- District 37: Flushing, Murray Hill & Whitestone
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (37, 138, 3),  -- Flushing
    (37, 175, 3);  -- Whitestone

-- District 38: Fresh Meadows, Hillcrest & Briarwood
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (38, 140, 3),  -- Fresh Meadows
    (38, 143, 3),  -- Hillcrest
    (38, 128, 3);  -- Briarwood

-- District 39: Kew Gardens, Richmond Hill & Woodhaven
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (39, 150, 3),  -- Kew Gardens
    (39, 151, 3),  -- Kew Gardens Hills
    (39, 164, 3),  -- Richmond Hill
    (39, 170, 3),  -- South Richmond Hill
    (39, 176, 3);  -- Woodhaven

-- District 40: Howard Beach & Ozone Park
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (40, 145, 3),  -- Howard Beach
    (40, 169, 3),  -- South Ozone Park
    (40, 160, 3);  -- Ozone Park

-- District 41: Bayside, Douglaston, Auburndale, & Little Neck
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (41, 126, 3),  -- Bayside
    (41, 134, 3),  -- Douglaston
    (41, 125, 3),  -- Auburndale
    (41, 153, 3);  -- Little Neck

-- District 42: Jamaica, Hollis & St. Albans
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (42, 147, 3),  -- Jamaica
    (42, 148, 3),  -- Jamaica Estates
    (42, 149, 3),  -- Jamaica Hills
    (42, 168, 3),  -- South Jamaica
    (42, 144, 3),  -- Hollis
    (42, 172, 3);  -- St. Albans

-- District 43: Queens Village, Cambria Heights, Bellerose, & Rosedale
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (43, 162, 3),  -- Queens Village
    (43, 130, 3),  -- Cambria Heights
    (43, 127, 3),  -- Bellerose
    (43, 167, 3);  -- Rosedale

-- District 44: Far Rockaway, Breezy Point & Broad Channel
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES
    (44, 166, 3);  -- Rockaway All

-- Bronx Community Districts
-- District 45: Hunts Point
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (45, 16, 4);   -- Hunts Point

-- District 46: Longwood, Melrose, & Mott Haven
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (46, 19, 4),   -- Longwood
    (46, 20, 4),   -- Melrose
    (46, 24, 4);   -- Mott Haven

-- District 47: Belmont & East Tremont
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (47, 3, 4),    -- Belmont
    (47, 11, 4);   -- East Tremont

-- District 48: Concourse, High Bridge, & Mount Eden
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (48, 8, 4),    -- Concourse
    (48, 15, 4);   -- Highbridge

-- District 49: Morris Heights & Mount Hope
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (49, 21, 4);   -- Morris Heights

-- District 50: Crotona Park East, West Farms, & Morrisania
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (50, 10, 4),   -- Crotona Park East
    (50, 23, 4);   -- Morrisania

-- District 51: Bedford Park, Fordham, & Norwood
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (51, 2, 4),    -- Bedford Park
    (51, 14, 4),   -- Fordham
    (51, 25, 4);   -- Norwood

-- District 52: Riverdale & Kingsbridge
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (52, 31, 4),   -- Riverdale
    (52, 17, 4);   -- Kingsbridge

-- District 53: Parkchester, Castle Hill, Clason Point, & Soundview
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (53, 26, 4),   -- Parkchester
    (53, 5, 4),    -- Castle Hill
    (53, 33, 4);   -- Soundview

-- District 54: Co-op City, Pelham Bay, Schuylerville, & Throgs Neck
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (54, 7, 4),    -- Co-op City
    (54, 27, 4),   -- Pelham Bay
    (54, 32, 4),   -- Schuylerville
    (54, 34, 4);   -- Throgs Neck

-- District 55: Pelham Parkway, Morris Park, & Laconia
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (55, 29, 4),   -- Pelham Parkway
    (55, 22, 4),   -- Morris Park
    (55, 18, 4);   -- Laconia

-- District 56: Wakefield, Williamsbridge, Eastchester, & Woodlawn
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (56, 38, 4),   -- Wakefield
    (56, 40, 4),   -- Williamsbridge
    (56, 12, 4),   -- Eastchester
    (56, 41, 4);   -- Woodlawn

-- Staten Island Community Districts
-- District 57: North Shore: New Springville & South Beach
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (57, 178, 5),  -- North Shore
    (57, 183, 5),  -- New Springville
    (57, 184, 5);  -- South Beach

-- District 58: South Shore: Tottenville, Great Kills, & Annadale
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (58, 185, 5),  -- South Shore
    (58, 186, 5),  -- Tottenville
    (58, 187, 5),  -- Great Kills
    (58, 188, 5);  -- Annadale

-- District 59: Mid-Island: Port Richmond, Stapleton, & Mariners Harbor
INSERT INTO nyc_analysis.district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (59, 182, 5),  -- Mid-Island
    (59, 179, 5),  -- Port Richmond
    (59, 180, 5),  -- Stapleton
    (59, 181, 5);  -- Mariners Harbor