--- Creating Primary Tables for use with median rent and income data uploaded via python

CREATE TABLE boroughs (
    borough_id SERIAL PRIMARY KEY,
    name VARCHAR(128)
);

CREATE TABLE neighborhoods (
    neighborhood_id SERIAL PRIMARY KEY,
    name VARCHAR(128),
    borough_id INT,
    FOREIGN KEY (borough_id)
        REFERENCES boroughs(borough_id)
);

CREATE TABLE districts (
    district_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    district_num INT, -- predetermined NYC data
    borough_id INT,
    FOREIGN KEY (borough_id)
        REFERENCES boroughs(borough_id)
);

CREATE TABLE district_neighborhoods (
    district_id INT,
    neighborhood_id INT,
    borough_id INT,
    PRIMARY KEY (district_id, neighborhood_id),
    FOREIGN KEY (district_id) REFERENCES districts(district_id) ON DELETE CASCADE,
    FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(neighborhood_id) ON DELETE CASCADE,
    FOREIGN KEY (borough_id) REFERENCES boroughs(borough_id) ON DELETE CASCADE
);

-- Adding borough table data
INSERT INTO boroughs (name) VALUES ('Manhattan');
INSERT INTO boroughs (name) VALUES ('Brooklyn');
INSERT INTO boroughs (name) VALUES ('Queens');
INSERT INTO boroughs (name) VALUES ('Bronx');
INSERT INTO boroughs (name) VALUES ('Staten Island');

-- Adding neigborhood table data
-- Bronx neighborhoods
INSERT INTO neighborhoods (name, borough_id) VALUES ('Baychester', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bedford Park', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Belmont', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bronxwood', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Castle Hill', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('City Island', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Co-op City', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Concourse', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Country Club', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Crotona Park East', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('East Tremont', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Eastchester', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Edenwald', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Fordham', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Highbridge', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Hunts Point', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Kingsbridge', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Laconia', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Longwood', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Melrose', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Morris Heights', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Morris Park', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Morrisania', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Mott Haven', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Norwood', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Parkchester', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Pelham Bay', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Pelham Gardens', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Pelham Parkway', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Port Morris', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Riverdale', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Schuylerville', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Soundview', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Throgs Neck', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Tremont', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('University Heights', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Van Nest', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Wakefield', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Westchester Village', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Williamsbridge', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Woodlawn', 4);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Woodstock', 4);

-- Brooklyn Neighborhoods
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bath Beach', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bay Ridge', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bedford-Stuyvesant', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bensonhurst', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bergen Beach', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Boerum Hill', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Borough Park', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Brighton Beach', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Brooklyn Heights', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Brownsville', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bushwick', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Canarsie', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Carroll Gardens', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Clinton Hill', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Cobble Hill', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Columbia St Waterfront District', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Coney Island', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Crown Heights', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Ditmas Park', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Downtown Brooklyn', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('DUMBO', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Dyker Heights', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('East Flatbush', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('East New York', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Flatbush', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Flatlands', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Fort Greene', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Gerritsen Beach', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Gowanus', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Gravesend', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Greenpoint', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Greenwood', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Kensington', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Manhattan Beach', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Marine Park', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Midwood', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Mill Basin', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Ocean Parkway', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Old Mill Basin', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Park Slope', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Prospect Heights', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Prospect Lefferts Gardens', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Prospect Park South', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Red Hook', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Seagate', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Sheepshead Bay', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Sunset Park', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Williamsburg', 2);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Windsor Terrace', 2);

-- Manhattan Neighborhoods
INSERT INTO neighborhoods (name, borough_id) VALUES ('Battery Park City', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Central Harlem', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Central Park South', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Chelsea', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Chinatown', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Civic Center', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('East Harlem', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('East Village', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Financial District', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Flatiron', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Gramercy Park', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Greenwich Village', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Hamilton Heights', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Inwood', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Little Italy', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Lower East Side', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Marble Hill', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Midtown', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Midtown East', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Midtown South', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Midtown West', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Morningside Heights', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Nolita', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Roosevelt Island', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Soho', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Stuyvesant Town/PCV', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Tribeca', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Upper East Side', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Upper West Side', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Washington Heights', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('West Harlem', 1);
INSERT INTO neighborhoods (name, borough_id) VALUES ('West Village', 1);

-- Queens Neighborhoods
INSERT INTO neighborhoods (name, borough_id) VALUES ('Astoria', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Auburndale', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bayside', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Bellerose', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Briarwood', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Brookville', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Cambria Heights', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Clearview', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('College Point', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Corona', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Douglaston', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('East Elmhurst', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Elmhurst', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Floral Park', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Flushing', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Forest Hills', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Fresh Meadows', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Glen Oaks', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Glendale', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Hillcrest', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Hollis', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Howard Beach', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Jackson Heights', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Jamaica', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Jamaica Estates', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Jamaica Hills', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Kew Gardens', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Kew Gardens Hills', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Laurelton', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Little Neck', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Long Island City', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Maspeth', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Middle Village', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('New Hyde Park', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('North Corona', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Oakland Gardens', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Ozone Park', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Pomonok', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Queens Village', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Rego Park', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Richmond Hill', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Ridgewood', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Rockaway All', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Rosedale', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('South Jamaica', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('South Ozone Park', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('South Richmond Hill', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Springfield Gardens', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('St. Albans', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Sunnyside', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Utopia', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Whitestone', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Woodhaven', 3);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Woodside', 3);

-- Staten Island Neighborhoods
INSERT INTO neighborhoods (name, borough_id) VALUES ('North Shore', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Port Richmond', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Stapleton', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ("Mariners Harbor", 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Mid-Island', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('New Springville', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('South Beach', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('South Shore', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Tottenville', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Great Kills', 5);
INSERT INTO neighborhoods (name, borough_id) VALUES ('Annadale', 5);

-- Adding NYC community district data to the district table
-- Brooklyn Community Districts (Borough ID: 2)
INSERT INTO districts (name, district_num, borough_id) VALUES ('Greenpoint & Williamsburg', 1, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Brooklyn Heights, Downtown Brooklyn, & Fort Greene', 2, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Bedford-Stuyvesant', 3, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Bushwick', 4, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('East New York, Cypress Hills, & Starrett City', 5, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Park Slope, Carroll Gardens & Red Hook', 6, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Sunset Park & Windsor Terrace', 7, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Crown Heights North & Prospect Heights', 8, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Crown Heights South, Prospect Lefferts & Wingate', 9, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Bay Ridge & Dyker Heights', 10, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Bensonhurst & Bath Beach', 11, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Borough Park, Kensington & Ocean Parkway', 12, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Brighton Beach & Coney Island', 13, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Flatbush & Midwood', 14, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Sheepshead Bay, Gravesend, Gerritsen Beach & Homecrest', 15, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Brownsville & Ocean Hill', 16, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('East Flatbush, Farragut & Rugby', 17, 2);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Canarsie & Flatlands', 18, 2);

-- Manhattan Community Districts (Borough ID: 1)
INSERT INTO districts (name, district_num, borough_id) VALUES ('Financial District & Battery Park City', 1, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Greenwich Village', 2, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Lower East Side & Chinatown', 3, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Chelsea & Hell''s Kitchen', 4, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Midtown, Midtown East & Flatiron', 5, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Murray Hill, Gramercy & Stuyvesant Town', 6, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Upper West Side', 7, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Upper East Side & Roosevelt Island', 8, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Morningside Heights & Hamilton Heights', 9, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Central Harlem', 10, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('East Harlem', 11, 1);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Washington Heights, Inwood & Marble Hill', 12, 1);

-- Queens Community Districts (Borough ID: 3)
INSERT INTO districts (name, district_num, borough_id) VALUES ('Astoria & Long Island City', 1, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Long Island City, Sunnyside & Woodside', 2, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Jackson Heights & North Corona', 3, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Elmhurst & South Corona', 4, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Ridgewood, Glendale, Maspeth, & Middle Village', 5, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Forest Hills & Rego Park', 6, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Flushing, Murray Hill & Whitestone', 7, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Fresh Meadows, Hillcrest & Briarwood', 8, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Kew Gardens, Richmond Hill & Woodhaven', 9, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Howard Beach & Ozone Park', 10, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Bayside, Douglaston, Auburndale, & Little Neck', 11, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Jamaica, Hollis & St. Albans', 12, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Queens Village, Cambria Heights, Bellerose, & Rosedale', 13, 3);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Far Rockaway, Breezy Point & Broad Channel', 14, 3);

-- Bronx Community Districts (Borough ID: 4)
INSERT INTO districts (name, district_num, borough_id) VALUES ('Hunts Point', 1, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Longwood, Melrose, & Mott Haven', 2, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Belmont & East Tremont', 3, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Concourse, High Bridge, & Mount Eden', 4, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Morris Heights, Mount Hope', 5, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Crotona Park East, West Farms, & Morrisania', 6, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Bedford Park, Fordham, & Norwood', 7, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Riverdale & Kingsbridge', 8, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Parkchester, Castle Hill, Clason Point, & Soundview', 9, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Co-op City, Pelham Bay, Schuylerville, & Throgs Neck', 10, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Pelham Parkway, Morris Park, & Laconia', 11, 4);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Wakefield, Williamsbridge, Eastchester, & Woodlawn', 12, 4);

-- Staten Island Community Districts (Borough ID: 5)
INSERT INTO districts (name, district_num, borough_id) VALUES ('North Shore: New Springville & South Beach', 1, 5);
INSERT INTO districts (name, district_num, borough_id) VALUES ('Mid-Island: Port Richmond, Stapleton, & Mariners Harbor', 2, 5);
INSERT INTO districts (name, district_num, borough_id) VALUES ('South Shore: Tottenville, Great Kills, & Annadale', 3, 5);

--- Adding foreign keys to the district_neighborhoods junction table
-- Brooklyn Community Districts
-- District 1: Greenpoint & Williamsburg -- BK 1
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (1, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Greenpoint')),
    (1, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Williamsburg'));

-- District 2: Brooklyn Heights, Downtown BK & Fort Greene -- BK 2
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (2, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Brooklyn Heights')),
    (2, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Fort Greene')),
    (2, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Downtown Brooklyn'));

-- District 3: Bedford-Stuyvesant -- BK 3
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (3, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Bedford-Stuyvesant'));

-- District 4: Bushwick -- BK 4
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (4, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Bushwick'));

-- District 5: East New York, Cypress Hills, & Starrett City -- BK 5
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (5, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'East New York'));

-- District 6: Park Slope, Carroll Gardens & Red Hook -- BK 6
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (6, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Park Slope')),
    (6, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Carroll Gardens')),
    (6, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Red Hook'));

-- District 7: Sunset Park & Windsor Terrace -- BK 7
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (7, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Sunset Park')),
    (7, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Windsor Terrace'));

-- District 8: Crown Heights North & Prospect Heights
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (8, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Crown Heights')),
    (8, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Prospect Heights'));

-- District 9: Crown Heights South, Prospect Lefferts & Wingate (inside PLG)
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (9, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Crown Heights')),
    (9, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Prospect Lefferts Gardens'));

-- District 10: Bay Ridge & Dyker Heights -- BK 10
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (10, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Bay Ridge')),
    (10, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Dyker Heights'));

-- District 11: Bensonhurst & Bath Beach -- BK 11
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (11, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Bensonhurst')),
    (11, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Bath Beach'));

-- District 12: Borough Park, Kensington & Ocean Parkway -- BK 12
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (12, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Borough Park')),
    (12, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Kensington')),
    (12, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Ocean Parkway'));

-- District 13: Brighton Beach & Coney Island -- BK 13
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (13, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Brighton Beach')),
    (13, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Coney Island'));

-- District 14: Flatbush & Midwood -- BK 14
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (14, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Flatbush')),
    (14, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Midwood'));

-- District 15: Sheepshead Bay, Gravesend, Gerritsen Beach & Homecrest (in Sheepshead Bay) -- BK 15
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (15, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Sheepshead Bay')),
    (15, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Gerritsen Beach')),
    (15, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Gravesend'));

-- District 16: Brownsville & Ocean Hill (inside Brownsville) -- BK 16
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (16, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Brownsville'));

-- District 17: East Flatbush, & Farragut & Rugby (within E.FB) -- BK 17
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (17, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'East Flatbush'));

-- District 18: Canarsie & Flatlands -- BK 18
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (18, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Canarsie')),
    (18, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Flatlands'));

-- Manhattan Community Districts
-- District 19: Financial District & Battery Park City -- Man 1
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (19, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Financial District')),
    (19, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Battery Park City'));
    
-- District 20: Greenwich Village -- Man 2  
    (20, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Greenwich Village'));

-- District 21: Lower East Side & Chinatown -- Man 3
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (21, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Lower East Side')),
    (21, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Chinatown'));

-- District 22: Chelsea & Hell's Kitchen -- Man 4
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (22, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Chelsea'));

-- District 23: Midtown, Midtown East & Flatiron -- Man 5
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (23, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Midtown')),
    (23, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Midtown East')),
    (23, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Midtown South')),
    (23, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Midtown West')),
    (23, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Flatiron'));

-- District 24: Murray Hill, Gramercy & Stuyvesant Town -- Man 6
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (24, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Gramercy Park')),
    (24, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Stuyvesant Town/PCV'));

-- District 25: Upper West Side -- Man 7
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (25, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Upper West Side'));

-- District 26: Upper East Side & Roosevelt Island -- Man 8
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (26, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Upper East Side')),
    (26, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Roosevelt Island'));

-- District 27: Morningside Heights & Hamilton Heights -- Man 9
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (27, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Morningside Heights')),
    (27, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Hamilton Heights'));

-- District 28: Central Harlem -- Man 10
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (28, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Central Harlem'));

-- District 29: East Harlem -- Man 11
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (29, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'East Harlem'));

-- District 30: Washington Heights, Inwood & Marble Hill -- Man 12
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (30, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Washington Heights')),
    (30, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Inwood')),
    (30, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Marble Hill'));

-- Queens Community Districts
-- District 31: Astoria & Long Island City -- Queens 1
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (31, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Astoria')),
    (31, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Long Island City'));

-- District 32: Long Island City, Sunnyside & Woodside -- Queens 2
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (32, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Long Island City')),
    (32, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Sunnyside')),
    (32, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Woodside'));

-- District 33: Jackson Heights & North Corona -- Queens 3
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (33, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Jackson Heights')),
    (33, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'North Corona'));

-- District 34: Elmhurst & South Corona -- Queens 4
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (34, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Elmhurst')),
    (34, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Corona'));

-- District 35: Ridgewood, Glendale, Maspeth, & Middle Village -- Queens 5
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (35, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Ridgewood')),
    (35, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Glendale')),
    (35, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Maspeth')),
    (35, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Middle Village'));

-- District 36: Forest Hills & Rego Park -- Queens 6
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (36, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Forest Hills')),
    (36, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Rego Park'));

-- District 37: Flushing, Murray Hill & Whitestone -- Queens 7
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (37, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Flushing')),
    (37, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Whitestone'));

-- District 38: Fresh Meadows, Hillcrest & Briarwood -- Queens 8
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (38, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Fresh Meadows')),
    (38, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Hillcrest')),
    (38, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Briarwood'));

-- District 39: Kew Gardens, Richmond Hill & Woodhaven  -- Queens 9
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (39, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Kew Gardens')),
    (39, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Kew Gardens Hills')),
    (39, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Richmond Hill')),
    (39, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'South Richmond Hill')),
    (39, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Woodhaven'));

-- District 40: Howard Beach & Ozone Park -- Queens 10
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (40, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Howard Beach')),
    (40, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'South Ozone Park')),
    (40, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Ozone Park'));

-- District 41: Bayside, Douglaston, Auburndale, & Little Neck - Queens 11
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (41, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Bayside')),
    (41, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Douglaston')),
    (41, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Auburndale')),
    (41, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Little Neck'));

-- District 42: Jamaica, Hollis & St. Albans -- Queens 12
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (42, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Jamaica')),
    (42, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Jamaica Estates')),
    (42, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Jamaica Hills')),
    (42, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'South Jamaica')),
    (42, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Hollis')),
    (42, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'St. Albans'));

-- District 43: Queens Village, Cambria Heights, Bellerose, & Rosedale -- Queens 13
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (43, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Queens Village')),
    (43, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Cambria Heights')),
    (43, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Bellerose')),
    (43, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Rosedale'));

-- District 44: Far Rockaway, Breezy Point & Broad Channel -- Queens 14
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES
    (44, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Rockaway All'));

-- Bronx Community Districts
-- District 45: Hunts Point -- Bronx 1
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (45, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Hunts Point'));
    
-- District 46: Longwood, Melrose, & Motthaven -- Bronx 2  
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (46, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Longwood')),
    (46, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Melrose')),
    (46, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Mott Haven'));

-- District 47: Belmont & East Tremont -- Bronx 3
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (47, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Belmont')),
    (47, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'East Tremont'));

-- District 48: Concourse, High Bridge, & Mount Eden -- Bronx 4
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (48, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Concourse')),
    (48, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Highbridge'));

-- District 49: Morris Heights & Mount Hope -- Bronx 5
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (49, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Morris Heights'));

-- District 50: Crotona Park East, West Farms, & Morrisania -- Bronx 6
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (50, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Crotona Park East')),
    (50, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Morrisania'));

-- District 51: Bedford Park, Fordham, & Norwood -- Bronx 7
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (51, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Bedford Park')),
    (51, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Fordham')),
    (51, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Norwood'));

-- District 52: Riverdale & Kingsbridge -- Bronx 8
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (52, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Riverdale')),
    (52, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Kingsbridge'));

-- District 53: Parkchester, Castle Hill, Clason Point, & Soundview -- Bronx 9
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (53, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Parkchester')),
    (53, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Castle Hill')),
    (53, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Soundview'));

-- District 54: Co-op City, Pelham Bay, Schuylerville, & Throgs Neck -- Bronx 10
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (54, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Co-op City')),
    (54, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Pelham Bay')),
    (54, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Schuylerville')),
    (54, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Throgs Neck'));

-- District 55: Pelham Parkway, Morris Park, & Laconia -- Bronx 11
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (55, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Pelham Parkway')),
    (55, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Morris Park')),
    (55, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Laconia'));

-- District 56: Wakefield, Williamsbridge, Eastchester, & Woodlawn -- Bronx 12
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (56, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Wakefield')),
    (56, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Williamsbridge')),
    (56, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Eastchester')),
    (56, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Woodlawn'));

-- Staten Island Community Districts
-- District 57: North Shore: New Springville & South Beach -- SI 1
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (57, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'North Shore')),
    (57, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'New Springville')),
    (57, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'South Beach'));
    
-- District 58: South Shore: Tottenville, Great Kills -- SI 3  
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (58, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'South Shore')),
    (58, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Tottenville')),
    (58, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Great Kills'));

-- District 59: Mid-Island: Port Richmond, Stapleton, & Mariners Harbor -- SI 2
INSERT INTO district_neighborhoods (district_id, neighborhood_id) VALUES 
    (59, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Mid-Island')),
    (59, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Port Richmond')),
    (59, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Stapleton')),
    (59, (SELECT neighborhood_id FROM neighborhoods WHERE name = 'Mariners Harbor'));

--- Modify Median Income table to add district_id data
ALTER TABLE median_income 
    ADD COLUMN district_id INT;
ALTER TABLE median_income
    ADD CONSTRAINT district_income
    FOREIGN KEY (district_id) REFERENCES districts(district_id);
--- Modify Median Income table to add borough_id data
ALTER TABLE median_income 
    ADD COLUMN borough_id INT;
ALTER TABLE median_income
    ADD CONSTRAINT borough_income
    FOREIGN KEY (borough_id) REFERENCES boroughs(borough_id);
--- Adding a column for official district names
ALTER TABLE median_income
    ADD COLUMN district_name VARCHAR(75);
UPDATE median_income 
SET district_name = (
    SELECT districts.name 
    FROM districts 
    WHERE districts.district_id = median_income.district_id
);

--- Adding borough_id context to existing rows
UPDATE median_income SET borough_id = 1 WHERE "NAME" LIKE '%Manhattan%';
UPDATE median_income SET borough_id = 2 WHERE "NAME" LIKE '%Brooklyn%';
UPDATE median_income SET borough_id = 3 WHERE "NAME" LIKE '%Queens%';
UPDATE median_income SET borough_id = 4 WHERE "NAME" LIKE '%Bronx%';
UPDATE median_income SET borough_id = 5 WHERE "NAME" LIKE '%Staten Island%';

--- Adding district_id context to existing rows
--- Brooklyn
UPDATE median_income SET district_id = 1 WHERE "NAME" LIKE '%Greenpoint%'
    OR "NAME" LIKE '%Williamsburg%';
UPDATE median_income SET district_id = 2 WHERE "NAME" LIKE '%Fort Greene%'
    OR "NAME" LIKE '%Downtown Brooklyn%' OR "NAME" LIKE '%Brooklyn Heights%';
UPDATE median_income SET district_id = 3 WHERE "NAME" LIKE '%Bedford-Stuyvesant%';
UPDATE median_income SET district_id = 4 WHERE "NAME" LIKE '%Bushwick%';
UPDATE median_income SET district_id = 5 WHERE "NAME" LIKE '%East New York%'
    OR "NAME" LIKE 'Cypress Hills' OR "NAME" LIKE '%Starrett City%';
UPDATE median_income SET district_id = 6 WHERE "NAME" LIKE '%Park Slope%'
    OR "NAME" LIKE '%Red Hook%' OR "NAME" LIKE '%Carroll Gardens%';
UPDATE median_income SET district_id = 7 WHERE "NAME" LIKE '%Sunset Park%'
    OR "NAME" LIKE '%Windsor Terrace%';
UPDATE median_income SET district_id = 8 WHERE "NAME" LIKE '%Crown Heights (North)%'
    OR "NAME" LIKE '%Prospect Heights%';
UPDATE median_income SET district_id = 9 WHERE "NAME" LIKE '%Crown Heights (South)%'
    OR "NAME" LIKE '%Prospect Lefferts%' OR "NAME" LIKE '%Wingate%';
UPDATE median_income SET district_id = 10 WHERE "NAME" LIKE '%Bay Ridge%'
    OR "NAME" LIKE '%Dyker Heights%';
UPDATE median_income SET district_id = 11 WHERE "NAME" LIKE '%Bensonhurst%'
    OR "NAME" LIKE '%Bath Beach%';
UPDATE median_income SET district_id = 12 WHERE "NAME" LIKE '%Borough Park%'
    OR "NAME" LIKE '%Ocean Parkway%';
UPDATE median_income SET district_id = 13 WHERE "NAME" LIKE '%Brighton Beach%'
    OR "NAME" LIKE '%Coney Island%';
UPDATE median_income SET district_id = 14 WHERE "NAME" LIKE '%Flatbush%'
    OR "NAME" LIKE '%Midwood%';
UPDATE median_income SET district_id = 15 WHERE "NAME" LIKE '%Sheepshead Bay%'
    OR "NAME" LIKE '%Gravesend%' OR "NAME" LIKE '%Gerritsen Beach%';
UPDATE median_income SET district_id = 16 WHERE "NAME" LIKE '%Brownsville%'
    OR "NAME" LIKE '%Ocean Hill%';
UPDATE median_income SET district_id = 17 WHERE "NAME" LIKE '%East Flatbush%'
    OR "NAME" LIKE '%Rugby%';
UPDATE median_income SET district_id = 18 WHERE "NAME" LIKE '%Canarsie%'
    OR "NAME" LIKE '%Flatlands%';
--- Manhattan
UPDATE median_income SET district_id = 19 WHERE "NAME" LIKE '%Battery Park%';
UPDATE median_income SET district_id = 20 WHERE "NAME" LIKE '%Financial District%';
UPDATE median_income SET district_id = 21 WHERE "NAME" LIKE '%Lower East Side%'
    OR "NAME" LIKE '%Chinatown%';
UPDATE median_income SET district_id = 22 WHERE "NAME" LIKE '%Chelsea%'
    OR "NAME" LIKE '%Hell''s Kitchen%';
UPDATE median_income SET district_id = 23 WHERE "NAME" LIKE '%Midtown%'
    OR "NAME" LIKE '%Flatiron%';
UPDATE median_income SET district_id = 24 WHERE "NAME" LIKE '%Gramercy%'
    OR "NAME" LIKE '%Stuyvesant Town%';
UPDATE median_income SET district_id = 25 WHERE "NAME" LIKE '%Upper West Side%';
UPDATE median_income SET district_id = 26 WHERE "NAME" LIKE '%Upper East Side%'
    OR "NAME" LIKE '%Roosevelt Island%';
UPDATE median_income SET district_id = 28 WHERE "NAME" LIKE '%Harlem%';
UPDATE median_income SET district_id = 29 WHERE "NAME" LIKE '%East Harlem%';
UPDATE median_income SET district_id = 27 WHERE "NAME" LIKE '%Morningside Heights%'
    OR "NAME" LIKE '%Hamilton Heights%' OR "NAME" LIKE '%Manhattanville%';
UPDATE median_income SET district_id = 30 WHERE "NAME" LIKE '%Washington Heights%'
    OR "NAME" LIKE '%Marble Hill%';
--- Queens
UPDATE median_income SET district_id = 31 WHERE "NAME" LIKE '%Astoria%';
UPDATE median_income SET district_id = 32 WHERE "NAME" LIKE '%Sunnyside%'
    OR "NAME" LIKE '%Woodside%';
UPDATE median_income SET district_id = 33 WHERE "NAME" LIKE '%Jackson Heights%';
UPDATE median_income SET district_id = 34 WHERE "NAME" LIKE '%Elmhurst%'
    AND "NAME" LIKE '%Corona%';
UPDATE median_income SET district_id = 35 WHERE "NAME" LIKE '%Ridgewood%'
    OR "NAME" LIKE '%Maspeth%';
UPDATE median_income SET district_id = 36 WHERE "NAME" LIKE '%Forrest Hills%'
    OR "NAME" LIKE '%Rego Park%';
UPDATE median_income SET district_id = 37 WHERE "NAME" LIKE '%Flushing%'
    OR "NAME" LIKE '%Whitestone%';
UPDATE median_income SET district_id = 38 WHERE "NAME" LIKE '%Fresh Meadows%'
    OR "NAME" LIKE '%Briarwood%';
UPDATE median_income SET district_id = 39 WHERE "NAME" LIKE '%Kew Gardens%'
    OR "NAME" LIKE '%Woodhaven%';
UPDATE median_income SET district_id = 40 WHERE "NAME" LIKE '%Howard Beach%'
    OR "NAME" LIKE '%Ozone Park%';
UPDATE median_income SET district_id = 41 WHERE "NAME" LIKE '%Bayside%'
    OR "NAME" LIKE '%Auburndale%';
UPDATE median_income SET district_id = 42 WHERE "NAME" LIKE '%Jamaica%'
    OR "NAME" LIKE '%Hollisg%';
UPDATE median_income SET district_id = 43 WHERE "NAME" LIKE '%Cambria Heights%'
    OR "NAME" LIKE '%Bellerose%';
UPDATE median_income SET district_id = 44 WHERE "NAME" LIKE '%Rockaway%'
    OR "NAME" LIKE '%Broad Channel%';
--- Bronx
UPDATE median_income SET district_id = 45 WHERE "NAME" LIKE '%Hunts Point%';
UPDATE median_income SET district_id = 46 WHERE "NAME" LIKE '%Longwood%'
    OR "NAME" LIKE '%Melrose%'
    OR "NAME" LIKE '%Mott Haven%';
UPDATE median_income SET district_id = 47 WHERE "NAME" LIKE '%Belmont%'
    OR "NAME" LIKE '%East Tremont%';
UPDATE median_income SET district_id = 48 WHERE "NAME" LIKE '%Concourse%'
    OR "NAME" LIKE '%Highbridge%';
UPDATE median_income SET district_id = 49 WHERE "NAME" LIKE '%Morris Heights%';
UPDATE median_income SET district_id = 50 WHERE "NAME" LIKE '%Crotona Park East%'
    OR "NAME" LIKE '%West Farms%'
    OR "NAME" LIKE '%Morrisania%';
UPDATE median_income SET district_id = 51 WHERE "NAME" LIKE '%Bedford Park%'
    OR "NAME" LIKE '%Fordham%'
    OR "NAME" LIKE '%Norwood%';
UPDATE median_income SET district_id = 52 WHERE "NAME" LIKE '%Riverdale%'
    OR "NAME" LIKE '%Kingsbridge%';
UPDATE median_income SET district_id = 53 WHERE "NAME" LIKE '%Parkchester%'
    OR "NAME" LIKE '%Castle Hill%'
    OR "NAME" LIKE '%Soundview%';
UPDATE median_income SET district_id = 54 WHERE "NAME" LIKE '%Co-op City%'
    OR "NAME" LIKE '%Pelham Bay%'
    OR "NAME" LIKE '%Schuylerville%'
    OR "NAME" LIKE '%Throgs Neck%';
UPDATE median_income SET district_id = 55 WHERE "NAME" LIKE '%Pelham Parkway%'
    OR "NAME" LIKE '%Morris Park%'
    OR "NAME" LIKE '%Laconia%';
UPDATE median_income SET district_id = 56 WHERE "NAME" LIKE '%Wakefield%'
    OR "NAME" LIKE '%Williamsbridge%'
    OR "NAME" LIKE '%Eastchester%'
    OR "NAME" LIKE '%Woodlawn%';
--- Staten Island
UPDATE median_income SET district_id = 57 WHERE "NAME" LIKE '%North Shore%'
    OR "NAME" LIKE '%New Springville%'
    OR "NAME" LIKE '%New South Beach%';
UPDATE median_income SET district_id = 58 WHERE "NAME" LIKE '%South Shore%'
    OR "NAME" LIKE '%Tottenville%'
    OR "NAME" LIKE '%Great Kills%'
    OR "NAME" LIKE '%Annadale%';
UPDATE median_income SET district_id = 59 WHERE "NAME" LIKE '%Mid-Island%'
    OR "NAME" LIKE '%Port Richmond%'
    OR "NAME" LIKE '%Stapleton%'
    OR "NAME" LIKE '%Mariners Harbor%';

--- updating data type for already-existing columns
ALTER TABLE median_income
ALTER COLUMN "income_all_HHs" TYPE integer USING "income_all_HHs"::integer;
ALTER TABLE median_income
ALTER COLUMN income_singles TYPE integer USING income_singles::integer;
ALTER TABLE median_income
ALTER COLUMN income_other_kids TYPE integer USING income_other_kids::integer;
ALTER TABLE median_income
ALTER COLUMN income_married_kids TYPE integer USING income_married_kids::integer;

--- Modify Median Asking Rent table to add neighborhood_id data and borough_id data
ALTER TABLE median_rent 
    ADD COLUMN neighborhood_id INT;
ALTER TABLE median_rent
    ADD CONSTRAINT neigborhood_rent
    FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(neighborhood_id);
--- Adding neighborhood_id context to existing rows
-- Brooklyn Neighborhoods (43-91)
UPDATE median_rent SET neighborhood_id = 43 WHERE area_name LIKE '%Bath Beach%';
UPDATE median_rent SET neighborhood_id = 44 WHERE area_name LIKE '%Bay Ridge%';
UPDATE median_rent SET neighborhood_id = 45 WHERE area_name LIKE '%Bedford-Stuyvesant%';
UPDATE median_rent SET neighborhood_id = 46 WHERE area_name LIKE '%Bensonhurst%';
UPDATE median_rent SET neighborhood_id = 47 WHERE area_name LIKE '%Bergen Beach%';
UPDATE median_rent SET neighborhood_id = 48 WHERE area_name LIKE '%Boerum Hill%';
UPDATE median_rent SET neighborhood_id = 49 WHERE area_name LIKE '%Borough Park%';
UPDATE median_rent SET neighborhood_id = 50 WHERE area_name LIKE '%Brighton Beach%';
UPDATE median_rent SET neighborhood_id = 51 WHERE area_name LIKE '%Brooklyn Heights%';
UPDATE median_rent SET neighborhood_id = 52 WHERE area_name LIKE '%Brownsville%';
UPDATE median_rent SET neighborhood_id = 53 WHERE area_name LIKE '%Bushwick%';
UPDATE median_rent SET neighborhood_id = 54 WHERE area_name LIKE '%Canarsie%';
UPDATE median_rent SET neighborhood_id = 55 WHERE area_name LIKE '%Carroll Gardens%';
UPDATE median_rent SET neighborhood_id = 56 WHERE area_name LIKE '%Clinton Hill%';
UPDATE median_rent SET neighborhood_id = 57 WHERE area_name LIKE '%Cobble Hill%';
UPDATE median_rent SET neighborhood_id = 58 WHERE area_name LIKE '%Columbia St Waterfront District%';
UPDATE median_rent SET neighborhood_id = 59 WHERE area_name LIKE '%Coney Island%';
UPDATE median_rent SET neighborhood_id = 60 WHERE area_name LIKE '%Crown Heights%';
UPDATE median_rent SET neighborhood_id = 61 WHERE area_name LIKE '%Ditmas Park%';
UPDATE median_rent SET neighborhood_id = 62 WHERE area_name LIKE '%Downtown Brooklyn%';
UPDATE median_rent SET neighborhood_id = 63 WHERE area_name LIKE '%DUMBO%';
UPDATE median_rent SET neighborhood_id = 64 WHERE area_name LIKE '%Dyker Heights%';
UPDATE median_rent SET neighborhood_id = 67 WHERE area_name LIKE '%Flatbush%';
UPDATE median_rent SET neighborhood_id = 65 WHERE area_name LIKE '%East Flatbush%';
UPDATE median_rent SET neighborhood_id = 66 WHERE area_name LIKE '%East New York%';
UPDATE median_rent SET neighborhood_id = 68 WHERE area_name LIKE '%Flatlands%';
UPDATE median_rent SET neighborhood_id = 69 WHERE area_name LIKE '%Fort Greene%';
UPDATE median_rent SET neighborhood_id = 70 WHERE area_name LIKE '%Gerritsen Beach%';
UPDATE median_rent SET neighborhood_id = 71 WHERE area_name LIKE '%Gowanus%';
UPDATE median_rent SET neighborhood_id = 72 WHERE area_name LIKE '%Gravesend%';
UPDATE median_rent SET neighborhood_id = 73 WHERE area_name LIKE '%Greenpoint%';
UPDATE median_rent SET neighborhood_id = 74 WHERE area_name LIKE '%Greenwood%';
UPDATE median_rent SET neighborhood_id = 75 WHERE area_name LIKE '%Kensington%';
UPDATE median_rent SET neighborhood_id = 76 WHERE area_name LIKE '%Manhattan Beach%';
UPDATE median_rent SET neighborhood_id = 77 WHERE area_name LIKE '%Marine Park%';
UPDATE median_rent SET neighborhood_id = 78 WHERE area_name LIKE '%Midwood%';
UPDATE median_rent SET neighborhood_id = 79 WHERE area_name LIKE '%Mill Basin%';
UPDATE median_rent SET neighborhood_id = 80 WHERE area_name LIKE '%Ocean Parkway%';
UPDATE median_rent SET neighborhood_id = 81 WHERE area_name LIKE '%Old Mill Basin%';
UPDATE median_rent SET neighborhood_id = 82 WHERE area_name LIKE '%Park Slope%';
UPDATE median_rent SET neighborhood_id = 83 WHERE area_name LIKE '%Prospect Heights%';
UPDATE median_rent SET neighborhood_id = 84 WHERE area_name LIKE '%Prospect Lefferts Gardens%';
UPDATE median_rent SET neighborhood_id = 85 WHERE area_name LIKE '%Prospect Park South%';
UPDATE median_rent SET neighborhood_id = 86 WHERE area_name LIKE '%Red Hook%';
UPDATE median_rent SET neighborhood_id = 87 WHERE area_name LIKE '%Seagate%';
UPDATE median_rent SET neighborhood_id = 88 WHERE area_name LIKE '%Sheepshead Bay%';
UPDATE median_rent SET neighborhood_id = 89 WHERE area_name LIKE '%Sunset Park%';
UPDATE median_rent SET neighborhood_id = 90 WHERE area_name LIKE '%Williamsburg%';
UPDATE median_rent SET neighborhood_id = 91 WHERE area_name LIKE '%Windsor Terrace%';

-- Manhattan Neighborhoods (92-123)
UPDATE median_rent SET neighborhood_id = 92 WHERE area_name LIKE '%Battery Park City%';
UPDATE median_rent SET neighborhood_id = 93 WHERE area_name LIKE '%Central Harlem%';
UPDATE median_rent SET neighborhood_id = 94 WHERE area_name LIKE '%Central Park South%';
UPDATE median_rent SET neighborhood_id = 95 WHERE area_name LIKE '%Chelsea%';
UPDATE median_rent SET neighborhood_id = 96 WHERE area_name LIKE '%Chinatown%';
UPDATE median_rent SET neighborhood_id = 97 WHERE area_name LIKE '%Civic Center%';
UPDATE median_rent SET neighborhood_id = 98 WHERE area_name LIKE '%East Harlem%';
UPDATE median_rent SET neighborhood_id = 99 WHERE area_name LIKE '%East Village%';
UPDATE median_rent SET neighborhood_id = 100 WHERE area_name LIKE '%Financial District%';
UPDATE median_rent SET neighborhood_id = 101 WHERE area_name LIKE '%Flatiron%';
UPDATE median_rent SET neighborhood_id = 102 WHERE area_name LIKE '%Gramercy Park%';
UPDATE median_rent SET neighborhood_id = 103 WHERE area_name LIKE '%Greenwich Village%';
UPDATE median_rent SET neighborhood_id = 104 WHERE area_name LIKE '%Hamilton Heights%';
UPDATE median_rent SET neighborhood_id = 105 WHERE area_name LIKE '%Inwood%';
UPDATE median_rent SET neighborhood_id = 106 WHERE area_name LIKE '%Little Italy%';
UPDATE median_rent SET neighborhood_id = 107 WHERE area_name LIKE '%Lower East Side%';
UPDATE median_rent SET neighborhood_id = 108 WHERE area_name LIKE '%Marble Hill%';
UPDATE median_rent SET neighborhood_id = 109 WHERE area_name LIKE '%Midtown%';
UPDATE median_rent SET neighborhood_id = 110 WHERE area_name LIKE '%Midtown East%';
UPDATE median_rent SET neighborhood_id = 111 WHERE area_name LIKE '%Midtown South%';
UPDATE median_rent SET neighborhood_id = 112 WHERE area_name LIKE '%Midtown West%';
UPDATE median_rent SET neighborhood_id = 113 WHERE area_name LIKE '%Morningside Heights%';
UPDATE median_rent SET neighborhood_id = 114 WHERE area_name LIKE '%Nolita%';
UPDATE median_rent SET neighborhood_id = 115 WHERE area_name LIKE '%Roosevelt Island%';
UPDATE median_rent SET neighborhood_id = 116 WHERE area_name LIKE '%Soho%';
UPDATE median_rent SET neighborhood_id = 117 WHERE area_name LIKE '%Stuyvesant Town%';
UPDATE median_rent SET neighborhood_id = 118 WHERE area_name LIKE '%Tribeca%';
UPDATE median_rent SET neighborhood_id = 119 WHERE area_name LIKE '%Upper East Side%';
UPDATE median_rent SET neighborhood_id = 120 WHERE area_name LIKE '%Upper West Side%';
UPDATE median_rent SET neighborhood_id = 121 WHERE area_name LIKE '%Washington Heights%';
UPDATE median_rent SET neighborhood_id = 122 WHERE area_name LIKE '%West Harlem%';
UPDATE median_rent SET neighborhood_id = 123 WHERE area_name LIKE '%West Village%';

-- Queens Neighborhoods (124-177)
UPDATE median_rent SET neighborhood_id = 124 WHERE area_name LIKE '%Astoria%';
UPDATE median_rent SET neighborhood_id = 125 WHERE area_name LIKE '%Auburndale%';
UPDATE median_rent SET neighborhood_id = 126 WHERE area_name LIKE '%Bayside%';
UPDATE median_rent SET neighborhood_id = 127 WHERE area_name LIKE '%Bellerose%';
UPDATE median_rent SET neighborhood_id = 128 WHERE area_name LIKE '%Briarwood%';
UPDATE median_rent SET neighborhood_id = 129 WHERE area_name LIKE '%Brookville%';
UPDATE median_rent SET neighborhood_id = 130 WHERE area_name LIKE '%Cambria Heights%';
UPDATE median_rent SET neighborhood_id = 131 WHERE area_name LIKE '%Clearview%';
UPDATE median_rent SET neighborhood_id = 132 WHERE area_name LIKE '%College Point%';
UPDATE median_rent SET neighborhood_id = 133 WHERE area_name LIKE '%Corona%';
UPDATE median_rent SET neighborhood_id = 134 WHERE area_name LIKE '%Douglaston%';
UPDATE median_rent SET neighborhood_id = 136 WHERE area_name LIKE '%Elmhurst%';
UPDATE median_rent SET neighborhood_id = 135 WHERE area_name LIKE '%East Elmhurst%';
UPDATE median_rent SET neighborhood_id = 137 WHERE area_name LIKE '%Floral Park%';
UPDATE median_rent SET neighborhood_id = 138 WHERE area_name LIKE '%Flushing%';
UPDATE median_rent SET neighborhood_id = 139 WHERE area_name LIKE '%Forest Hills%';
UPDATE median_rent SET neighborhood_id = 140 WHERE area_name LIKE '%Fresh Meadows%';
UPDATE median_rent SET neighborhood_id = 141 WHERE area_name LIKE '%Glen Oaks%';
UPDATE median_rent SET neighborhood_id = 142 WHERE area_name LIKE '%Glendale%';
UPDATE median_rent SET neighborhood_id = 143 WHERE area_name LIKE '%Hillcrest%';
UPDATE median_rent SET neighborhood_id = 144 WHERE area_name LIKE '%Hollis%';
UPDATE median_rent SET neighborhood_id = 145 WHERE area_name LIKE '%Howard Beach%';
UPDATE median_rent SET neighborhood_id = 146 WHERE area_name LIKE '%Jackson Heights%';
UPDATE median_rent SET neighborhood_id = 147 WHERE area_name LIKE '%Jamaica%';
UPDATE median_rent SET neighborhood_id = 148 WHERE area_name LIKE '%Jamaica Estates%';
UPDATE median_rent SET neighborhood_id = 149 WHERE area_name LIKE '%Jamaica Hills%';
UPDATE median_rent SET neighborhood_id = 150 WHERE area_name LIKE '%Kew Gardens%';
UPDATE median_rent SET neighborhood_id = 151 WHERE area_name LIKE '%Kew Gardens Hills%';
UPDATE median_rent SET neighborhood_id = 152 WHERE area_name LIKE '%Laurelton%';
UPDATE median_rent SET neighborhood_id = 153 WHERE area_name LIKE '%Little Neck%';
UPDATE median_rent SET neighborhood_id = 154 WHERE area_name LIKE '%Long Island City%';
UPDATE median_rent SET neighborhood_id = 155 WHERE area_name LIKE '%Maspeth%';
UPDATE median_rent SET neighborhood_id = 156 WHERE area_name LIKE '%Middle Village%';
UPDATE median_rent SET neighborhood_id = 157 WHERE area_name LIKE '%New Hyde Park%';
UPDATE median_rent SET neighborhood_id = 158 WHERE area_name LIKE '%North Corona%';
UPDATE median_rent SET neighborhood_id = 159 WHERE area_name LIKE '%Oakland Gardens%';
UPDATE median_rent SET neighborhood_id = 160 WHERE area_name LIKE '%Ozone Park%';
UPDATE median_rent SET neighborhood_id = 161 WHERE area_name LIKE '%Pomonok%';
UPDATE median_rent SET neighborhood_id = 162 WHERE area_name LIKE '%Queens Village%';
UPDATE median_rent SET neighborhood_id = 163 WHERE area_name LIKE '%Rego Park%';
UPDATE median_rent SET neighborhood_id = 164 WHERE area_name LIKE '%Richmond Hill%';
UPDATE median_rent SET neighborhood_id = 165 WHERE area_name LIKE '%Ridgewood%';
UPDATE median_rent SET neighborhood_id = 166 WHERE area_name LIKE '%Rockaway%';
UPDATE median_rent SET neighborhood_id = 167 WHERE area_name LIKE '%Rosedale%';
UPDATE median_rent SET neighborhood_id = 168 WHERE area_name LIKE '%South Jamaica%';
UPDATE median_rent SET neighborhood_id = 169 WHERE area_name LIKE '%South Ozone Park%';
UPDATE median_rent SET neighborhood_id = 170 WHERE area_name LIKE '%South Richmond Hill%';
UPDATE median_rent SET neighborhood_id = 171 WHERE area_name LIKE '%Springfield Gardens%';
UPDATE median_rent SET neighborhood_id = 172 WHERE area_name LIKE '%St. Albans%';
UPDATE median_rent SET neighborhood_id = 173 WHERE area_name LIKE '%Sunnyside%';
UPDATE median_rent SET neighborhood_id = 174 WHERE area_name LIKE '%Utopia%';
UPDATE median_rent SET neighborhood_id = 175 WHERE area_name LIKE '%Whitestone%';
UPDATE median_rent SET neighborhood_id = 176 WHERE area_name LIKE '%Woodhaven%';
UPDATE median_rent SET neighborhood_id = 177 WHERE area_name LIKE '%Woodside%';

-- Bronx Neighborhoods (1-42)
UPDATE median_rent SET neighborhood_id = 1 WHERE area_name LIKE '%Baychester%';
UPDATE median_rent SET neighborhood_id = 2 WHERE area_name LIKE '%Bedford Park%';
UPDATE median_rent SET neighborhood_id = 3 WHERE area_name LIKE '%Belmont%';
UPDATE median_rent SET neighborhood_id = 4 WHERE area_name LIKE '%Bronxwood%';
UPDATE median_rent SET neighborhood_id = 5 WHERE area_name LIKE '%Castle Hill%';
UPDATE median_rent SET neighborhood_id = 6 WHERE area_name LIKE '%City Island%';
UPDATE median_rent SET neighborhood_id = 7 WHERE area_name LIKE '%Co-op City%';
UPDATE median_rent SET neighborhood_id = 8 WHERE area_name LIKE '%Concourse%';
UPDATE median_rent SET neighborhood_id = 9 WHERE area_name LIKE '%Country Club%';
UPDATE median_rent SET neighborhood_id = 10 WHERE area_name LIKE '%Crotona Park East%';
UPDATE median_rent SET neighborhood_id = 11 WHERE area_name LIKE '%East Tremont%';
UPDATE median_rent SET neighborhood_id = 12 WHERE area_name LIKE '%Eastchester%';
UPDATE median_rent SET neighborhood_id = 13 WHERE area_name LIKE '%Edenwald%';
UPDATE median_rent SET neighborhood_id = 14 WHERE area_name LIKE '%Fordham%';
UPDATE median_rent SET neighborhood_id = 15 WHERE area_name LIKE '%Highbridge%';
UPDATE median_rent SET neighborhood_id = 16 WHERE area_name LIKE '%Hunts Point%';
UPDATE median_rent SET neighborhood_id = 17 WHERE area_name LIKE '%Kingsbridge%';
UPDATE median_rent SET neighborhood_id = 18 WHERE area_name LIKE '%Laconia%';
UPDATE median_rent SET neighborhood_id = 19 WHERE area_name LIKE '%Longwood%';
UPDATE median_rent SET neighborhood_id = 20 WHERE area_name LIKE '%Melrose%';
UPDATE median_rent SET neighborhood_id = 21 WHERE area_name LIKE '%Morris Heights%';
UPDATE median_rent SET neighborhood_id = 22 WHERE area_name LIKE '%Morris Park%';
UPDATE median_rent SET neighborhood_id = 23 WHERE area_name LIKE '%Morrisania%';
UPDATE median_rent SET neighborhood_id = 24 WHERE area_name LIKE '%Mott Haven%';
UPDATE median_rent SET neighborhood_id = 25 WHERE area_name LIKE '%Norwood%';
UPDATE median_rent SET neighborhood_id = 26 WHERE area_name LIKE '%Parkchester%';
UPDATE median_rent SET neighborhood_id = 27 WHERE area_name LIKE '%Pelham Bay%';
UPDATE median_rent SET neighborhood_id = 28 WHERE area_name LIKE '%Pelham Gardens%';
UPDATE median_rent SET neighborhood_id = 29 WHERE area_name LIKE '%Pelham Parkway%';
UPDATE median_rent SET neighborhood_id = 30 WHERE area_name LIKE '%Port Morris%';
UPDATE median_rent SET neighborhood_id = 31 WHERE area_name LIKE '%Riverdale%';
UPDATE median_rent SET neighborhood_id = 32 WHERE area_name LIKE '%Schuylerville%';
UPDATE median_rent SET neighborhood_id = 33 WHERE area_name LIKE '%Soundview%';
UPDATE median_rent SET neighborhood_id = 34 WHERE area_name LIKE '%Throgs Neck%';
UPDATE median_rent SET neighborhood_id = 35 WHERE area_name LIKE '%Tremont%';
UPDATE median_rent SET neighborhood_id = 36 WHERE area_name LIKE '%University Heights%';
UPDATE median_rent SET neighborhood_id = 37 WHERE area_name LIKE '%Van Nest%';
UPDATE median_rent SET neighborhood_id = 38 WHERE area_name LIKE '%Wakefield%';
UPDATE median_rent SET neighborhood_id = 39 WHERE area_name LIKE '%Westchester Village%';
UPDATE median_rent SET neighborhood_id = 40 WHERE area_name LIKE '%Williamsbridge%';
UPDATE median_rent SET neighborhood_id = 41 WHERE area_name LIKE '%Woodlawn%';
UPDATE median_rent SET neighborhood_id = 42 WHERE area_name LIKE '%Woodstock%';

ALTER TABLE median_rent 
    ADD COLUMN borough_id INT;
ALTER TABLE median_rent
    ADD CONSTRAINT borough_rent
    FOREIGN KEY (borough_id) REFERENCES boroughs(borough_id);
--- Adding borough_id context to existing rows
UPDATE median_rent SET borough_id=1 WHERE borough='Manhattan';
UPDATE median_rent SET borough_id=2 WHERE borough='Brooklyn';
UPDATE median_rent SET borough_id=3 WHERE borough='Queens';
UPDATE median_rent SET borough_id=4 WHERE borough='Bronx';

--- Additional Cleaning, we are only interested in neighborhood level data
DELETE FROM median_rent WHERE area_type <> 'neighborhood';

--- Looking at pertinent table information
SELECT column_name FROM information_schema.columns 
WHERE table_name='neighborhoods' AND table_schema='public';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'median_rent';

