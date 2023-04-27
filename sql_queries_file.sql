#### 1. Creating new database ####
CREATE DATABASE house_price_regression;


#### 2. Creating table house_price_data ####
USE house_price_regression;

#drop table house_price_data;
CREATE TABLE house_price_data (
    house_id TEXT NOT NULL,
    date TEXT DEFAULT NULL,		# Importing it as text because in its current format it cannot be imported. Can be fixed after import if needed. Set to default null, as this will be useful to check for errors in its conversion to date
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

## *the table does not have a primary key, which could be an issue, so the sales will be indexed and the index will play the role of the table's primary key.*
ALTER TABLE house_price_data
ADD sales_id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
	ADD PRIMARY KEY (sales_id);

## *After the primary key was added, its relative position in relation to the table will be changed to first.*
ALTER TABLE house_price_data
MODIFY COLUMN sales_id INT UNSIGNED NOT NULL AUTO_INCREMENT
FIRST;


#### 4. Checking if data was imported correctly ####
SELECT 
    *
FROM
    house_price_data;


#### 5. Dropping date ####
#ALTER TABLE house_price_data
#DROP DATE;
## This step will be skipped, because the date column is needed in task 11.

## Instead the column will be standardised and its datatype will be fixed.
UPDATE house_price_data 
SET 
    date = DATE(STR_TO_DATE(date, '%c/%d/%y'));

## Checking to see if it worked
SELECT 
    date
FROM
    house_price_data;

## Checking to see how well
SELECT 
    date
FROM
    house_price_data
WHERE date IS NULL;
# no nulls

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


#### 8. Arranging the data in a decreasing order by the price of the house. Returning 10 most expensive. ####
SELECT 
    house_id, price
FROM
    house_price_data
ORDER BY price DESC
LIMIT 10;
# most expensive house ids and prices:
# 6762700020:	7,700,000$
# 9808700762:	7,060,000$
# 9208900037:	6,890,000$
# 2470100110:	5,570,000$
# 8907500070:	5,350,000$
# 7558700030:	5,300,000$
# 1247600105:	5,110,000$
# 1924059029:	4,670,000$
# 7738500731:	4,500,000$
# 3835500195:	4,490,000$


#### 9. Average price of all properties
SELECT 
    ROUND(AVG(price), 2) as avg_price
FROM
    house_price_data;
# average price is 540,311.32 $


#### 10. Using group by to check categorical variable properties ####
## 10.1 Average price by bedrooms
SELECT 
    bedrooms AS n_bedrooms,
    ROUND(AVG(price), 2) AS average_price
FROM
    house_price_data
GROUP BY bedrooms
ORDER BY bedrooms ASC;
# n_bedrooms	average_price
# 		1			318239.46$
# 		2			401387.75$
# 		3			466301.47$
# 		4			635564.68$
# 		5			786874.13$
# 		6			825853.50$
# 		7			951447.82$
# 		8			1105076.92$
# 		9			893999.83$
# 		10			820000.00$
# 		11			520000.00$
# 		33			640000.00$

## 10.2 Average sqft_living of houses by bedrooms
SELECT 
    sqft_living AS square_footage,
    ROUND(AVG(price), 2) AS average_price
FROM
    house_price_data
GROUP BY sqft_living
ORDER BY sqft_living ASC;
# (1034 rows returned)

## 10.3 Average price with/without waterfront
SELECT 
    waterfront,
    ROUND(AVG(price), 2) AS average_price
FROM
    house_price_data
GROUP BY waterfront;
# # waterfront	average_price
#		0			531776.78$
#		1			1662524.18$

## 10.4 Correlation between condition and grade(?)
SELECT 
    condition_ as `condition`,
    AVG(grade) AS avg_grade_by_condition
FROM
    house_price_data
GROUP BY `condition`
ORDER BY `condition` ASC;
# positive correlation up to condition=3, then interestingly a negative correlation develops as the grade starts to decrease by each increase in the condition from condition 4 up to 5.

#### 11. Addressing customer's interest in specific estates
SELECT 
    *
FROM
    house_price_data
WHERE
    bedrooms = 3
        OR bedrooms = 4 AND bathrooms > 3
        AND floors = 1
        AND waterfront = 0
        AND condition_ >= 3
        AND grade >= 5
        AND price < 300000;
# 9823 rows returned

# however, some houses might have been sold more than once
SELECT 
    house_id, COUNT(sales_id)
FROM
    house_price_data
GROUP BY house_id
HAVING COUNT(sales_id) > 1
ORDER BY COUNT(sales_id) DESC;
# 176 houses have been sold more than once in the timeframe given

# The customer would not be interested to see the same listing twice or thrice. The chance that this is the case for some of the listings can be checked with the following query
WITH sales_short AS ( 
SELECT 
    *
FROM
    house_price_data
WHERE
    bedrooms = 3
        OR bedrooms = 4 AND bathrooms > 3
        AND floors = 1
        AND waterfront = 0
        AND condition_ >= 3
        AND grade >= 5
        AND price < 300000
        )
SELECT house_id, count(sales_id) FROM sales_short
GROUP BY house_id
HAVING count(sales_id) > 1;
# 92 of the 9823 houses that meet the criteria have been sold more than once. 

# To only have each of the 92 houses once in the table returned, only the last date will have to be picked, since this is the only relevant date as well. So all that remains to be done is to add this one conditional to the previous query
WITH sales_short AS ( 
SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY house_id ORDER BY date DESC) AS date_ranking
FROM
    house_price_data
WHERE
    bedrooms = 3
        OR bedrooms = 4 AND bathrooms > 3
        AND floors = 1
        AND waterfront = 0
        AND condition_ >= 3
        AND grade >= 5
        AND price < 300000
        )
SELECT
	house_id,
	bedrooms,
    bathrooms,
    sqft_living15 AS living_footage,
    sqft_lot15 AS lot_footage,
    floors,
    waterfront,
    view,
    condition_,
    grade,
    yr_built AS year_built,
    yr_renovated AS year_renovated,
    zipcode,
    latid AS latitude,
    longit AS longitude,
    price
FROM
    sales_short
WHERE date_ranking = 1;
# finally 9730 items returned

