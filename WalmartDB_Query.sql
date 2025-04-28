SELECT * FROM walmart_sales
WHERE Temperature_Celcius = -0.83


--Check for null values in each column
Select SUM(CASE WHEN Weekly_Sales is NULL THEN 1 ELSE 0 END) as weekly_sales_null,
	   SUM(CASE WHEN Temperature is NULL THEN 1 ELSE 0 END) as temp_null,
	   SUM(CASE WHEN Fuel_Price is NULL THEN 1 ELSE 0 END) as fuel_price_null,
	   SUM(CASE WHEN CPI is NULL THEN 1 ELSE 0 END) as CPI_null,
	   SUM(CASE WHEN Unemployment is NULL THEN 1 ELSE 0 END) as unemployment_null
FROM walmart_sales;


ALTER TABLE walmart_sales 
ALTER COLUMN Temperature DECIMAL(10,2);

ALTER TABLE walmart_sales  
ALTER COLUMN Unemployment DECIMAL(10,3);


--Adding a new temperature column in degree Celcius
ALTER TABLE walmart_sales
ADD Temperature_Celcius DECIMAL(10,2);

--Updating the new column with Celcius values
UPDATE walmart_sales
SET Temperature_Celcius = (Temperature - 32) * 5/9;



--Looking at the number of distinct stores in the dataset
SELECT DISTINCT Store FROM walmart_sales ORDER BY Store;


--Looking at the total number of holidays vs non-holidays in the dataset
SELECT Holiday_Flag, COUNT(DISTINCT Date) as Count_Days, 'Holidays' as Type
FROM walmart_sales
WHERE Holiday_Flag = 1 
GROUP BY Holiday_Flag
UNION
SELECT Holiday_Flag, COUNT(DISTINCT Date) as Count_Days, 'Non-Holidays' as Type
FROM walmart_sales
WHERE Holiday_Flag = 0 
GROUP BY Holiday_Flag;



--Looking at the start and end date from the dataset and calculating the datediff
SELECT MIN(Date) as sale_start_date, 
	   MAX(Date) as sale_end_date,
	   DATEDIFF(YEAR, MIN(Date), MAX(Date)) as sale_period_years,
	   DATEDIFF(MONTH, MIN(Date), MAX(Date)) as sale_period_months,
	   DATEDIFF(WEEK, MIN(Date), MAX(Date)) as sale_period_weeks,
	   DATEDIFF(Day, MIN(Date), MAX(Date)) as sale_period_days
FROM walmart_sales;



--Looking at total sales for each store in descending order
SELECT Store, SUM(Weekly_Sales) as Total_Sales
FROM walmart_sales
GROUP BY Store
ORDER BY Total_Sales DESC;


--Looking at which store/s has the lowest and highest fuel price in the region along with their weekly sales
SELECT Store, Fuel_Price, Weekly_Sales
FROM walmart_sales
WHERE Fuel_Price = (SELECT MAX(Fuel_Price) FROM walmart_sales)
   OR Fuel_Price = (SELECT MIN(Fuel_Price) FROM walmart_sales)
ORDER BY Fuel_Price ASC;



--Looking at average CPI across the years
SELECT Year(Date) as Date, AVG(CPI) as Average_CPI
FROM walmart_sales
GROUP BY Year(Date);


--Comparing average weekly sales during holidays and non-holidays
SELECT AVG(Weekly_Sales) as avg_weekly_sales, Holiday_Flag,
CASE 
	 WHEN Holiday_Flag = 1 THEN 'Holiday'
	 WHEN Holiday_Flag = 0 THEN 'Non-Holiday'
END 
AS Holiday_Type
FROM walmart_sales
GROUP BY Holiday_Flag;


--Looking at weekly_sales during the coldest period vs the hottest period
SELECT Weekly_Sales, Temperature_Celcius
FROM walmart_sales
WHERE Temperature_Celcius = (SELECT MIN(Temperature_Celcius) FROM walmart_sales) 
	  OR Temperature_Celcius = (SELECT MAX(Temperature_Celcius) FROM walmart_sales);


--Looking at average weekly_sales during the periods with the highest unemployment vs lowest unemployment
SELECT AVG(weekly_sales) as avg_weekly_sales, Unemployment
FROM walmart_sales
WHERE Unemployment = (SELECT MIN(Unemployment) FROM walmart_sales)
	  OR Unemployment = (SELECT MAX(Unemployment) FROM walmart_sales)
GROUP BY Unemployment;



--Looking at the peak sales period per year
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




--Looking at the average weekly sales from a range of temperature values
SELECT AVG(Weekly_Sales) as Average_Sales, 
	   CASE WHEN Temperature_Celcius < 0 THEN 'Cold'
			WHEN Temperature_Celcius BETWEEN 0 AND 25 THEN 'Moderate'
			WHEN Temperature_Celcius > 25 THEN 'Hot'
	   END AS Temp_Range
FROM walmart_sales
GROUP BY CASE WHEN Temperature_Celcius < 0 THEN 'Cold'
			  WHEN Temperature_Celcius BETWEEN 0 AND 25 THEN 'Moderate'
			  WHEN Temperature_Celcius > 25 THEN 'Hot'
	     END
ORDER BY Average_Sales;
			

--Cleaner version of the query above
WITH Temperature_Range AS(
SELECT Weekly_Sales, 
	   CASE WHEN Temperature_Celcius < 0 THEN 'Cold'
			WHEN Temperature_Celcius BETWEEN 0 AND 25 THEN 'Moderate'
			WHEN Temperature_Celcius > 25 THEN 'Hot'
	   END AS Temp_Range
FROM walmart_sales)
SELECT AVG(Weekly_Sales) as Average_Sales, Temp_Range
FROM Temperature_Range
GROUP BY Temp_Range
ORDER BY Average_Sales;
	  



--Overview on CPI, Fuel Prices and Weekly Sales over Year and Month
SELECT YEAR(Date) AS Year, 
       MONTH(Date) AS Month, 
       AVG(CPI) AS Avg_CPI, 
       AVG(Fuel_Price) AS Avg_Fuel_Price, 
       AVG(Weekly_Sales) AS Avg_Weekly_Sales
FROM walmart_sales
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;



--Overview on CPI, Fuel Prices and Weekly Sales over time 
SELECT Date, 
       AVG(CPI) AS Avg_CPI, 
       AVG(Fuel_Price) AS Avg_Fuel_Price, 
       AVG(Weekly_Sales) AS Avg_Weekly_Sales,
	   Holiday_Flag
FROM walmart_sales
GROUP BY Date, Holiday_Flag
ORDER BY Date;



--Overview on CPI, Fuel Prices and Weekly Sales over the years, separated by holidays and non-holidays 
SELECT Year(Date) as Year, 
       AVG(CPI) AS Avg_CPI, 
       AVG(Fuel_Price) AS Avg_Fuel_Price, 
       AVG(Weekly_Sales) AS Avg_Weekly_Sales,
	   Holiday_Flag
FROM walmart_sales
GROUP BY Year(Date), Holiday_Flag
ORDER BY Year(Date), Holiday_Flag;



--7 day rolling average of weekly sales for each store
SELECT Store, Date, Weekly_Sales,
	   AVG(Weekly_Sales) OVER (
	   PARTITION BY Store
	   ORDER BY Date
	   ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Rolling_Avg_Weekly_Sales, Holiday_Flag
FROM walmart_sales
ORDER BY Store, Date;


--Cumulative sum of weekly sales for each store
SELECT Store, Date, Weekly_Sales,
	   SUM(Weekly_Sales) OVER (
	   PARTITION BY Store
	   ORDER BY Date) AS Cumulative_Weekly_Sales
FROM walmart_sales
ORDER BY Store, Date;






