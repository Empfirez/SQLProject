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


![image](https://github.com/user-attachments/assets/165cc2e9-65a3-4ab2-9269-dceddb054449)



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


Comparing average weekly sales during holidays and non-holidays:

	SELECT AVG(Weekly_Sales) as avg_weekly_sales, Holiday_Flag,
	       CASE  WHEN Holiday_Flag = 1 THEN 'Holiday'
		     WHEN Holiday_Flag = 0 THEN 'Non-Holiday'
	       END AS Holiday_Type
	FROM walmart_sales
	GROUP BY Holiday_Flag;


Looking at the peak sales period per year:

	WITH peak_sales AS
	     (SELECT MAX(Weekly_Sales) as Peak_Sales, Year(Date) AS Year
	      FROM walmart_sales
	      GROUP BY Year(Date))
	SELECT p.Peak_Sales, p.Year, w.Date as Peak_Period
	FROM peak_sales p
	JOIN walmart_sales w
	ON p.Peak_Sales = w.Weekly_Sales
	AND p.year = Year(w.Date)
	ORDER BY Date




### Results/Findings

After careful analysis, the results are as follows:
1. Store 20 has the highest sales amount of $301,397,792.46 while Store 33 has the lowest sales amount of $37,160,221.96.
2. Sales revenue has been slowly rising over the past 3 years, with sales peaking around December each year. This increase in sales is likely due to the holiday season where people are busy shopping for Christmas
   goods and decorations.
3. Average CPI and fuel prices have been gradually increasing over time, with fuel prices increasing significantly from 2010 to 2011.
4. There is no significant correlation between fuel prices and sales revenue.
5. Average sales are at their highest during holiday seasons regardless of CPI or fuel prices.
6. Average sales are the lowest when the temperature is hot(>25 degrees) while sales are the highest when the temperature is moderate(between 0 degrees and 25 degrees).
  


### Recommendations

Based on analysis above, here are some recommended actions to take in order to increase sales revenue:
1. Offering special promotions during peak seasons to maximise revenue and attract more customers.
2. Analyzing the differences between Store 20 and Store 33 to figure out the reasons behind the large discrepancy in sales. For instance promotions, propduct placement, store environment, customer service, location.
3. As sales drop during hotter days, Walmart can run targeted promotions on specific products such as beverages, cooling applicances and swimwear.
4. During hotter days where customers are reluctant to shop in physical stores, Walmart can increase sales by offering discount vouchers whenever consumers shop online. 
5. As sales are the highest in moderate temperatures, more emphasis should be placed on outdoor products such as gardening tools, sports apparel as well as sports equipment. Beauty products may also see a rise in sales
   as people tend to repair their damaged skin and hair after cold periods.
6. Since CPI and fuel prices do not affect sales significantly, Walmart should focus on their customer service and increasing customer satisfaction so as to build a more loyal consumer base.  




### Limitations

- Converted fuel_price and CPI column to 2 decimal places for easier analysis and readability.
- Created a new column for temperature called temperature_celcius as the original temperature column was recorded in Kelvin. The newly created column was then populated with values in Celcius after conversion.
  








