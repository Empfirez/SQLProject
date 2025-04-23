# Walmart Sales Analysis



## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning/Preparation](#data-cleaningpreparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Results/Findings](#resultsfindings)
- [Recommendations](#recommendations)
- [Limitations](#limitations)





### Project Overview
This data analysis project aims to uncover insights into the sales performance of Walmart through the analysis of its sales data. By analyzing certain key aspects of the dataset such as temperature, holidays and fuel prices, we aim to gain a deeper understanding of how certain factors affect sales performance as well as the extent of the impact. Through our findings, we hope to provide data-driven recommendations to help raise sales revenue for Walmart and ultimately improve its profitability.


### Data Sources

The primary dataset used for this analysis is the "Walmart_Sales.csv" file, containing historical sales data of Walmart. This dataset is downloaded from Kaggle.


### Tools

- SQL Server (Data Analysis/Data Exploration)
  
- Tableau (Data Visualization)




### Data Cleaning/Preparation

In the data preparation phase of the project, we performed the following tasks:
1.  Data loading and inspection (in SQL server)
2.  Handling of missing values from the dataset and checking for any inconsistencies
3.  Data cleaning and formatting (adding new temperature column and populating it with new values)

### Exploratory Data Analysis

EDA is used to summarize the sales data and allows us gain a deeper understanding of the dataset. It answers key questions such as:

-  What is the total number of distinct stores?
-  What is the total sales for each store?
-  Which store performed the best and which store performed the worst?
-  What is the average weekly sales during holiday periods and non-holiday periods?
-  What are the peak sales periods for each year?


### Data Analysis

Cumulative sum of weekly sales for each store:

     SELECT Store, Date, Weekly_Sales,
	   SUM(Weekly_Sales) OVER(
	   PARTITION BY Store
	   ORDER BY Date) AS Cumulative_Weekly_Sales
     FROM walmart_sales
     ORDER BY Store, Date;



7 day rolling average of weekly sales for each store:

     SELECT Store, Date, Weekly_Sales,
	   AVG(Weekly_Sales) OVER(
	   PARTITION BY Store
	   ORDER BY Date
	   ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Rolling_Avg_Weekly_Sales, Holiday_Flag
     FROM walmart_sales
     ORDER BY Store, Date;






### Results/Findings



### Recommendations




### Limitations




### 




