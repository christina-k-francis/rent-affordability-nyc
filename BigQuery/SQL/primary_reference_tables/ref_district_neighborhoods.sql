--- BigQuery Database Development
--- Creating the Junction Table for connecting District and Neighborhood data

CREATE OR REPLACE TABLE `nyc_analysis.ref_district_neighborhoods` (
    district_id INT64,
    neighborhood_id INT64,
    borough_id INT64
    -- PRIMARY KEY (district_id, neighborhood_id)
    -- FOREIGN KEY (district_id) REFERENCES districts(district_id)
    -- FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(neighborhood_id)
    -- FOREIGN KEY (borough_id) REFERENCES boroughs(borough_id)
);

-- Adding foreign keys to the district_neighborhoods junction table
-- Brooklyn Community Districts
-- District 1: Greenpoint & Williamsburg
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (1, 73, 2),  -- Greenpoint
    (1, 90, 2);  -- Williamsburg

-- District 2: Brooklyn Heights, Downtown Brooklyn, & Fort Greene
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (2, 51, 2),  -- Brooklyn Heights
    (2, 69, 2),  -- Fort Greene
    (2, 62, 2);  -- Downtown Brooklyn

-- District 3: Bedford-Stuyvesant
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (3, 45, 2);  -- Bedford-Stuyvesant

-- District 4: Bushwick
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (4, 53, 2);  -- Bushwick

-- District 5: East New York, Cypress Hills, & Starrett City
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (5, 66, 2);  -- East New York

-- District 6: Park Slope, Carroll Gardens & Red Hook
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (6, 82, 2),  -- Park Slope
    (6, 55, 2),  -- Carroll Gardens
    (6, 86, 2);  -- Red Hook

-- District 7: Sunset Park & Windsor Terrace
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (7, 89, 2),  -- Sunset Park
    (7, 91, 2);  -- Windsor Terrace

-- District 8: Crown Heights North & Prospect Heights
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (8, 60, 2),  -- Crown Heights
    (8, 83, 2);  -- Prospect Heights

-- District 9: Crown Heights South, Prospect Lefferts & Wingate
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (9, 60, 2),  -- Crown Heights
    (9, 84, 2);  -- Prospect Lefferts Gardens

-- District 10: Bay Ridge & Dyker Heights
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (10, 44, 2),  -- Bay Ridge
    (10, 64, 2);  -- Dyker Heights

-- District 11: Bensonhurst & Bath Beach
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (11, 46, 2),  -- Bensonhurst
    (11, 43, 2);  -- Bath Beach

-- District 12: Borough Park, Kensington & Ocean Parkway
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (12, 49, 2),  -- Borough Park
    (12, 75, 2),  -- Kensington
    (12, 80, 2);  -- Ocean Parkway

-- District 13: Brighton Beach & Coney Island
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (13, 50, 2),  -- Brighton Beach
    (13, 59, 2);  -- Coney Island

-- District 14: Flatbush & Midwood
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (14, 67, 2),  -- Flatbush
    (14, 78, 2);  -- Midwood

-- District 15: Sheepshead Bay, Gravesend, Gerritsen Beach & Homecrest
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (15, 88, 2),  -- Sheepshead Bay
    (15, 70, 2),  -- Gerritsen Beach
    (15, 72, 2);  -- Gravesend

-- District 16: Brownsville & Ocean Hill
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (16, 52, 2);  -- Brownsville

-- District 17: East Flatbush, Farragut & Rugby
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (17, 65, 2);  -- East Flatbush

-- District 18: Canarsie & Flatlands
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (18, 54, 2),  -- Canarsie
    (18, 68, 2);  -- Flatlands

-- Manhattan Community Districts
-- District 19: Financial District & Battery Park City
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (19, 100, 1),  -- Financial District
    (19, 92, 1);   -- Battery Park City

-- District 20: Greenwich Village
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (20, 103, 1);  -- Greenwich Village

-- District 21: Lower East Side & Chinatown
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (21, 108, 1),  -- Lower East Side
    (21, 96, 1);   -- Chinatown

-- District 22: Chelsea & Hell's Kitchen
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (22, 95, 1),   -- Chelsea
    (22, 105, 1);   -- Hell's Kitchen

-- District 23: Midtown, Midtown East & Flatiron
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (23, 110, 1),  -- Midtown
    (23, 111, 1),  -- Midtown East
    (23, 112, 1),  -- Midtown South
    (23, 113, 1),  -- Midtown West
    (23, 101, 1);  -- Flatiron

-- District 24: Murray Hill, Gramercy & Stuyvesant Town
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (24, 102, 1),  -- Gramercy Park
    (24, 118, 1);  -- Stuyvesant Town/PCV

-- District 25: Upper West Side
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (25, 121, 1);  -- Upper West Side

-- District 26: Upper East Side & Roosevelt Island
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (26, 120, 1),  -- Upper East Side
    (26, 116, 1);  -- Roosevelt Island

-- District 27: Morningside Heights & Hamilton Heights
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (27, 114, 1),  -- Morningside Heights
    (27, 104, 1);  -- Hamilton Heights

-- District 28: Central Harlem
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (28, 93, 1);   -- Central Harlem

-- District 29: East Harlem
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (29, 98, 1);   -- East Harlem

-- District 30: Washington Heights, Inwood & Marble Hill
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (30, 122, 1),  -- Washington Heights
    (30, 106, 1),  -- Inwood
    (30, 109, 1);  -- Marble Hill

-- Queens Community Districts
-- District 31: Astoria & Long Island City
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (31, 125, 3),  -- Astoria
    (31, 155, 3);  -- Long Island City

-- District 32: Long Island City, Sunnyside & Woodside
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (32, 155, 3),  -- Long Island City
    (32, 174, 3),  -- Sunnyside
    (32, 178, 3);  -- Woodside

-- District 33: Jackson Heights & North Corona
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (33, 147, 3),  -- Jackson Heights
    (33, 159, 3);  -- North Corona

-- District 34: Elmhurst & South Corona
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (34, 137, 3),  -- Elmhurst
    (34, 134, 3);  -- Corona

-- District 35: Ridgewood, Glendale, Maspeth, & Middle Village
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (35, 166, 3),  -- Ridgewood
    (35, 143, 3),  -- Glendale
    (35, 156, 3),  -- Maspeth
    (35, 157, 3);  -- Middle Village

-- District 36: Forest Hills & Rego Park
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (36, 140, 3),  -- Forest Hills
    (36, 164, 3);  -- Rego Park

-- District 37: Flushing, Murray Hill & Whitestone
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (37, 139, 3),  -- Flushing
    (37, 176, 3);  -- Whitestone

-- District 38: Fresh Meadows, Hillcrest & Briarwood
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (38, 141, 3),  -- Fresh Meadows
    (38, 144, 3),  -- Hillcrest
    (38, 129, 3);  -- Briarwood

-- District 39: Kew Gardens, Richmond Hill & Woodhaven
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (39, 151, 3),  -- Kew Gardens
    (39, 152, 3),  -- Kew Gardens Hills
    (39, 165, 3),  -- Richmond Hill
    (39, 171, 3),  -- South Richmond Hill
    (39, 177, 3);  -- Woodhaven

-- District 40: Howard Beach & Ozone Park
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (40, 146, 3),  -- Howard Beach
    (40, 170, 3),  -- South Ozone Park
    (40, 161, 3);  -- Ozone Park

-- District 41: Bayside, Douglaston, Auburndale, & Little Neck
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (41, 127, 3),  -- Bayside
    (41, 135, 3),  -- Douglaston
    (41, 126, 3),  -- Auburndale
    (41, 154, 3);  -- Little Neck

-- District 42: Jamaica, Hollis & St. Albans
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (42, 148, 3),  -- Jamaica
    (42, 149, 3),  -- Jamaica Estates
    (42, 150, 3),  -- Jamaica Hills
    (42, 169, 3),  -- South Jamaica
    (42, 145, 3),  -- Hollis
    (42, 173, 3);  -- St. Albans

-- District 43: Queens Village, Cambria Heights, Bellerose, & Rosedale
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (43, 163, 3),  -- Queens Village
    (43, 131, 3),  -- Cambria Heights
    (43, 128, 3),  -- Bellerose
    (43, 168, 3);  -- Rosedale

-- District 44: Far Rockaway, Breezy Point & Broad Channel
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES
    (44, 167, 3);  -- Rockaway All

-- Bronx Community Districts
-- District 45: Hunts Point
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (45, 16, 4);   -- Hunts Point

-- District 46: Longwood, Melrose, & Mott Haven
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (46, 19, 4),   -- Longwood
    (46, 20, 4),   -- Melrose
    (46, 24, 4);   -- Mott Haven

-- District 47: Belmont & East Tremont
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (47, 3, 4),    -- Belmont
    (47, 11, 4);   -- East Tremont

-- District 48: Concourse, High Bridge, & Mount Eden
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (48, 8, 4),    -- Concourse
    (48, 15, 4);   -- Highbridge

-- District 49: Morris Heights & Mount Hope
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (49, 21, 4);   -- Morris Heights

-- District 50: Crotona Park East, West Farms, & Morrisania
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (50, 10, 4),   -- Crotona Park East
    (50, 23, 4);   -- Morrisania

-- District 51: Bedford Park, Fordham, & Norwood
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (51, 2, 4),    -- Bedford Park
    (51, 14, 4),   -- Fordham
    (51, 25, 4);   -- Norwood

-- District 52: Riverdale & Kingsbridge
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (52, 31, 4),   -- Riverdale
    (52, 17, 4);   -- Kingsbridge

-- District 53: Parkchester, Castle Hill, Clason Point, & Soundview
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (53, 26, 4),   -- Parkchester
    (53, 5, 4),    -- Castle Hill
    (53, 33, 4);   -- Soundview

-- District 54: Co-op City, Pelham Bay, Schuylerville, & Throgs Neck
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (54, 7, 4),    -- Co-op City
    (54, 27, 4),   -- Pelham Bay
    (54, 32, 4),   -- Schuylerville
    (54, 34, 4);   -- Throgs Neck

-- District 55: Pelham Parkway, Morris Park, & Laconia
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (55, 29, 4),   -- Pelham Parkway
    (55, 22, 4),   -- Morris Park
    (55, 18, 4);   -- Laconia

-- District 56: Wakefield, Williamsbridge, Eastchester, & Woodlawn
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (56, 38, 4),   -- Wakefield
    (56, 40, 4),   -- Williamsbridge
    (56, 12, 4),   -- Eastchester
    (56, 41, 4);   -- Woodlawn

-- Staten Island Community Districts
-- District 57: North Shore: New Springville & South Beach
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (57, 179, 5),  -- North Shore
    (57, 184, 5),  -- New Springville
    (57, 185, 5);  -- South Beach

-- District 58: South Shore: Tottenville, Great Kills, & Annadale
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (58, 186, 5),  -- South Shore
    (58, 187, 5),  -- Tottenville
    (58, 188, 5),  -- Great Kills
    (58, 189, 5);  -- Annadale

-- District 59: Mid-Island: Port Richmond, Stapleton, & Mariners Harbor
INSERT INTO nyc_analysis.ref_district_neighborhoods (district_id, neighborhood_id, borough_id) VALUES 
    (59, 183, 5),  -- Mid-Island
    (59, 180, 5),  -- Port Richmond
    (59, 181, 5),  -- Stapleton
    (59, 182, 5);  -- Mariners Harbor
