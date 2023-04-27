#### 1. Creating new database ####
CREATE DATABASE house_price_regression;


#### 2. Creating table house_price_data ####
USE house_price_regression;

#drop table house_price_data;
CREATE TABLE house_price_data (
    id TEXT NOT NULL,
    date TEXT NOT NULL,		# importing it as text because in its current format it cannot be imported. could be fixed after import if needed
    bedrooms INT DEFAULT NULL,
    bathrooms INT DEFAULT NULL,
    sqft_living INT DEFAULT NULL,
    sqft_lot INT DEFAULT NULL,
    floors DOUBLE DEFAULT NULL,
    waterfront INT DEFAULT NULL,
    view INT DEFAULT NULL,
    condition_ INT DEFAULT NULL,
    grade INT DEFAULT NULL,
    sqft_above INT DEFAULT NULL,
    sqft_basement INT DEFAULT NULL,
    yr_built int DEFAULT NULL,
    yr_renovated INT DEFAULT NULL,
    zipcode INT DEFAULT NULL,
    latid DOUBLE DEFAULT NULL,
    longit DOUBLE DEFAULT NULL,
    sqft_living15 INT DEFAULT NULL,
    sqft_lot15 INT DEFAULT NULL,
    price INT DEFAULT NULL
);							# numericals set to default null to easily check if something went wrong during data importing. ***what was set to null and what not might need to be reviewed***


#### 3. Importing data from .csv file ####
SHOW VARIABLES LIKE 'local_infile';		# local_infile off

SET GLOBAL local_infile = 1;	# because local_infile is off

# my.ini file in C:\ProgramData\MySQL\MySQL Server 8.0 was altered and "secure-file-priv" was given an empty ("") value to allow following query
# file regression_data.csv was copied to C:\ProgramData\MySQL\MySQL Server 8.0\Data\house_price_regression in order to be accessible using this query
LOAD DATA INFILE 'regression_data.csv' 	
INTO TABLE house_price_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


#### 4. Checking if data was imported correctly ####
SELECT 
    *
FROM
    house_price_data;


#### 5. Dropping date ####
ALTER TABLE house_price_data
DROP DATE;


#### 6. How many rows? ####
SELECT 
    COUNT(*)
FROM
    house_price_data;
# n_rows = 21596


#### 7. Unique values in some categoricals ####
# bedrooms
SELECT DISTINCT
    bedrooms
FROM
    house_price_data
ORDER BY bedrooms ASC;
# 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 33

# bathrooms
SELECT DISTINCT
    bathrooms
FROM
    house_price_data
ORDER BY bathrooms ASC;
# 1, 2, 3, 4, 5, 6, 7, 8

# floors
SELECT DISTINCT
    floors
FROM
    house_price_data
ORDER BY floors ASC;
# 1, 1.5, 2, 2.5, 3, 3.5

# condition_
SELECT DISTINCT
    condition_
FROM
    house_price_data
ORDER BY condition_ ASC;
# 1, 2, 3, 4, 5

# grade
SELECT DISTINCT
    grade
FROM
    house_price_data
ORDER BY grade ASC;
# 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13


#### 8. 

