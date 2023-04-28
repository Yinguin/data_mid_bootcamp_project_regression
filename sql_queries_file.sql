#### 1. Creating new database ####
CREATE DATABASE house_price_regression;


#### 2. Creating table house_price_data ####
USE house_price_regression;

#drop table house_price_data;
CREATE TABLE house_price_data (
    house_id BIGINT NOT NULL,
    date TEXT DEFAULT NULL,		# Importing it as text because in its current format it cannot be imported. Can be fixed after import if needed. Set to default null, as this will be useful to check for errors in its conversion to date
    bedrooms INT DEFAULT NULL,
    bathrooms DOUBLE DEFAULT NULL,
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
);							# numericals set to default null to easily check if something went wrong during data importing.


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
# 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3, 3.25, 3.5, 3.75, 4, 4.25, 4.5, 4.75, 5, 5.25, 5.5, 5.75, 6, 6.25, 6.5, 6.75, 7.5, 7.75, 8

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


#### 9. Average price of all properties ####
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
# 		1			318,239.46$
# 		2			401,387.75$
# 		3			466,301.47$
# 		4			635,564.68$
# 		5			786,874.13$
# 		6			825,853.50$
# 		7			951,447.82$
# 		8			110,5076.92$
# 		9			893,999.83$
# 		10			820,000.00$
# 		11			520,000.00$
# 		33			640,000.00$

## 10.2 Average sqft_living of houses by bedrooms
SELECT 
    sqft_living AS square_footage,
    ROUND(AVG(price), 2) AS average_price
FROM
    house_price_data
GROUP BY sqft_living
ORDER BY sqft_living ASC;
# 1034 rows returned

## 10.3 Average price with/without waterfront
SELECT 
    waterfront,
    ROUND(AVG(price), 2) AS average_price
FROM
    house_price_data
GROUP BY waterfront;
# # waterfront	average_price
#		No			531,776.78$
#		Yes			1,662,524.18$

## 10.4 Correlation between condition and grade(?)
SELECT 
    condition_ as `condition`,
    AVG(grade) AS avg_grade_by_condition
FROM
    house_price_data
GROUP BY `condition`
ORDER BY `condition` ASC;
# A positive correlation is observed up to condition=3, then interestingly a negative correlation develops as the grade starts to decrease by each increase in the condition from 4 to 5.
## condition	avg_grade_by_condition
#		1			5.9655
#		2			6.5412
#		3			7.8274
#		4			7.3826
#		5			7.3210


#### 11. Addressing customer's interest in specific estates ####
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

# However, some houses might have been sold more than once...
SELECT 
    house_id, COUNT(sales_id)
FROM
    house_price_data
GROUP BY house_id
HAVING COUNT(sales_id) > 1
ORDER BY COUNT(sales_id) DESC;
# 176 houses have been sold more than once in the timeframe given

# The customer would not be interested to see the same listing twice or thrice. The chance that this is the case for some of the listings can be checked with the following query:
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

# To only have each of the 92 houses appear once in the table returned, only the last date will have to be picked, since this is the only relevant date as well. So all that remains to be done is to add this one condition to the previous query:
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
	sqft_above AS footage_above,
    sqft_basement AS basement_footage,
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
# Finally 9730 items returned		## Note: 9730 + 92 = 9822, but as shown with the previous query, one of the houses was sold thrice, while all the rest 91 were sold twice, which means that both of its oldest purchase records would be excluded by the last query and thus 9822 + 1 = 9823 gives the expected output, which is correct. ##


#### 12. Manager's request: show properties with price = 2*avg(price) ####
WITH highest_cte AS (	
SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY house_id ORDER BY date DESC) AS date_ranking
FROM
    house_price_data
    )
SELECT
	house_id,
	bedrooms,
    bathrooms,
    sqft_living AS living_footage,
    sqft_living15 AS living_footage_15,
    sqft_lot AS lot_footage,
    sqft_lot15 AS lot_footage15,
    sqft_above AS footage_above,
    sqft_basement AS basement_footage,
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
	highest_cte
WHERE
    price >= 2 * (SELECT # no properties have exactly 2 times the price of the average, thus the ones with a greater or equal price than that will be shown instead
            AVG(price)
        FROM
            house_price_data)
	AND date_ranking = 1; # making sure only the last sales' record for each property is shown
# 1240 properties to show


#### 13. Turn query above into view ####
CREATE VIEW highest_priced_properties AS
WITH highest_cte AS (
SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY house_id ORDER BY date DESC) AS date_ranking
FROM
    house_price_data
    )
SELECT
	house_id,
	bedrooms,
    bathrooms,
    sqft_living AS living_footage,
    sqft_living15 AS living_footage_15,
    sqft_lot AS lot_footage,
    sqft_lot15 AS lot_footage15,
    sqft_above AS footage_above,
    sqft_basement AS basement_footage,
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
	highest_cte
WHERE
    price >= 2 * (SELECT 
            AVG(price)
        FROM
            house_price_data)
	AND date_ranking = 1
ORDER BY price DESC;

select * from highest_priced_properties;
# The view functions well (again 1240 items returned)

#### 14. Difference in avg(price) between properties with 3 and 4 bedrooms ####
WITH avg_price_4 as (
	SELECT
		AVG(price) as avg_4
	FROM
		house_price_data
	WHERE
		bedrooms = 4)
SELECT ROUND(avg_4 - (
					SELECT
						AVG(price)
					FROM
						house_price_data
					WHERE
						bedrooms = 3
						),2) AS diff_avg_3_4_beds
FROM
	avg_price_4;
# difference = 169,263.21$

#### 15. Distinct zipcodes
SELECT DISTINCT
    zipcode
FROM
    house_price_data;
# 70 rows returned


#### 16. List of renovated properties
SELECT 
    *
FROM
    house_price_data
WHERE
    yr_renovated <> 0;
# 914 rows returned


#### 17. 11th most expensive property in database
CREATE VIEW highest_to_lowest AS
WITH ranked_expensive AS (
SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY house_id ORDER BY price DESC) AS price_rank1 # to be used to ensure that no houses are listed twice
FROM
    house_price_data
    )
SELECT
	*,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS price_rank2	# the actual ranking that is relevant to the question and will be used in the next query
FROM
	ranked_expensive
WHERE
	price_rank1 = 1;

SELECT
	*
FROM
	highest_to_lowest
WHERE price_rank2 = 11;
# sales_id	house_id		date	bedrooms	bathrooms	sqft_living		sqft_lot	floors	waterfront	view	condition_	grade	sqft_above	sqft_basement	yr_built	yr_renovated	zipcode		latid	 longit		sqft_living15	sqft_lot15	price	price_ranking
#	12364	6065300370	2015-05-06		5			6			7440		21540		  2			0		  0			3		  12		5550		1890		  2003			0			  98006	    47.5692	 -122.189		4740			19329	4210000		11

# alternatively, as expected, the same property can be returned by using the view highest_priced_properties, which was created earlier
WITH test_cte AS (
	SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS price_rank
    FROM
    highest_priced_properties
    )
SELECT
	 *
FROM
	test_cte
WHERE
	price_rank = 11;
# same output as above
