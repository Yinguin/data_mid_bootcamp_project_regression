### Project Description

We are conducting an end-to-end analysis of a dataset. The analysis includes three regression models to **Predict selling prices of houses in King County, WA** based on certain features provided in the dataset, such as location, age and size. The models also aim at understanding which factors are responsible for higher property value ($650K and above). Hence our target feature is the property's price.
The dataset consists of historic data of around 22,000 properties sold between May 2014 and May 2015 in King County, WA, United States.

We model **Linear Regression, KNN Regression and XGBoost** both on the original dataset (with cosmetic cleaning) and on the preprocessed dataset.

**To sum up our findings:**

On the original datset all three models performed surprisingly well. The XGBoost model performed best, followed by the Linear Regression and lastly the KNN Regression model.

During preprocessing we converted a number of features and based on the effect on the baseline models found out that:
- the selling date is irrelevant.
- we achieve better results calculating the age of the properties based on the year the properties were built/renovated than using the year itself.
- we can group the zipcodes in categories by selling price to achieve more meaningful results.
- even though latitude and longitude seem to indicate the same as zipcode, excluding them reduces the performance of the baseline models.

We looked at the dataset in Python, Tableau and SQL. Due to high correlations, similar meaning or better plot distribution of certain dependent features we assessed that:  
- many features related to size of living space, basement and plot are having the same effect on our target, the price.
- the data collected before renovation of some properties in 2015 is more meaningful thatn the one collected afterwards.
- the number of bathrooms do not impact the price.
- the features grade (grading the property from 1 to 13) and condition (rating the condition of the property from 1 to 5) essentially indicate the same. 
Consequently, we dropped the respective features to slim the dataset.

When analyzing different features for outliers, which are extreme datapoints, we concluded that:
- 5 properties with a very high amount of bedrooms are most likely data entry errors. 
- 1 property in a rural area has an unproportionally large plot size, but location, living space and age seem to have a stronger impact on the price.
- there are a few properties with an extremely large living space, removing them removed also those properties with extreme basement size in relation to the entire dataset.

After preprocessing, we applied again our three prediction models **Linear Regression, KNN Regression and XGBoost**. As before, the XGBoost model performed best, followed by the Linear Regression and lastly the KNN Regression model. All models improved in performance, the Linear Regression model the most while XGBoost showed only small improvement.

We extracted a subset that includes only those properties with prices of 650K and above. Comparing the results of the models with and without the high-priced subset, we found that the higher-proced properties are not significantly different from the rest in terms of the features that are important for predicting property prices.

**Conclusions**






### Usage Instructions

The repository contains:
- A folder (datasets) with the original dataset provided for the project (regression_data.csv/.xls) and a dataset after cleaning (data_cleaned.csv) as well as after processing (data_processed.csv).
- A Jupyter notebook with the analysis and the regression models (mid-bootcamp-project-regression.ipynb). 
- An SQL-Query-File exploring the data further (sql_mid_bootcamp_project_regression.sql)
- A Tableau Public workbook to visualize the data (tableau_mid_bootcamp_project_regression.twbx)

We have created a documentation of our workflow here: https://trello.com/b/Sg2OBiDB/mid-bootcamp-project-property-prices

And a visual presentation of the project's findings here: https://slides.com/inga-1/b 

This project is part of the IRONHACK Data Analysis bootcamp from January to June 2023.
