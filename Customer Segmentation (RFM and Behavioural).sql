Create Table Customer_orders
(
	ORDERNUMBER INT,
    QUANTITYORDERED INT,
    PRICEEACH DECIMAL(10, 2),
    ORDERLINENUMBER INT,
    SALES DECIMAL(10, 2),
    ORDERDATE DATE,
    STATUS VARCHAR(50),
    QTR_ID INT,
    MONTH_ID INT,
    YEAR_ID INT,
    PRODUCTLINE VARCHAR(50),
    MSRP DECIMAL(10, 2),
    PRODUCTCODE VARCHAR(50),
    CUSTOMERNAME VARCHAR(100),
    PHONE VARCHAR(20),
    ADDRESSLINE1 VARCHAR(100),
    ADDRESSLINE2 VARCHAR(100),
    CITY VARCHAR(50),
    "STATE" VARCHAR(50),
    POSTALCODE VARCHAR(20),
    COUNTRY VARCHAR(50),
    TERRITORY VARCHAR(10),
    CONTACTLASTNAME VARCHAR(50),
    CONTACTFIRSTNAME VARCHAR(50),
    DEALSIZE VARCHAR(20)
);

--Inspecting DATA
SELECT * From customer_orders;

SELECT status, SUM(sales) potential_revenue, SUM(quantityordered) As cancelled_sales
	From customer_orders
	WHERE status = 'Cancelled'
	GROUP BY 1
		/* we see that a lot of sales were cancelled and as a result some of the
			revenue was never realized */
	-- Deleting cancelled sales data.
DELETE FROM customer_orders WHERE status = 'Cancelled';



--Checking Unique values
SELECT DISTINCT status FROM customer_orders
SELECT DISTINCT productline FROM customer_orders
SELECT DISTINCT year_id FROM customer_orders
SELECT DISTINCT country FROM customer_orders
SELECT DISTINCT territory FROM customer_orders
SELECT DISTINCT dealsize FROM customer_orders

SELECT DISTINCT Year_id, MIN(month_id), MAX(month_id) FROM customer_orders
GROUP BY year_id
ORDER BY 1

--Which country has the highest number of sales?
SELECT DISTINCT(country), SUM(sales) AS Revenue
FROM customer_orders
GROUP BY country
ORDER BY 2 DESC
			/* USA has the highest Revenue almost
			3 times the revenue of the runner up country */

--Which city has the highest sales in USA?
SELECT DISTINCT country, city, SUM(sales) AS Revenue
FROM customer_orders
GROUP BY 1, 2
HAVING country = 'USA'
ORDER BY 3 DESC
			/* San Rafael generates the most revenue out of all the US cities
				Infact the top 5 cities generate 50% of the total revenue. */

--Which is the best product in US?
SELECT DISTINCT productline,
		SUM(quantityordered) AS best_selling,
		SUM(sales)			 AS most_revenue
FROM customer_orders
GROUP BY 1
ORDER BY 3 DESC
			/*  Cars (Classic & Vintage) are dominating the market,
				bringing in ~60% of the revenue and sales */

--Grouping sales by :

SELECT productline,
		SUM(sales) AS REVENUE
FROM customer_orders
GROUP BY 1
ORDER BY 2 DESC		--Cars are the most revenue generating products


SELECT year_id,
		SUM(sales) AS REVENUE
FROM customer_orders
GROUP BY 1
ORDER BY 2 DESC		--2004 was the best year revenue wise.


SELECT dealsize,
		SUM(sales) AS REVENUE
FROM customer_orders
GROUP BY 1
ORDER BY 2 DESC		--Medium sized deals generate ~2 times more revenue than small sized deals,
					--And ~4.5 times more revenue than large size deals.

--What was the best month for sales in any specific year?
SELECT month_id, SUM(sales)
FROM customer_orders
	WHERE year_id = '2003' --(Replace 2003 with any other year)
GROUP BY 1
ORDER by 2 DESC

--Which product is responsible for high revenue in November?
SELECT Productline, SUM(sales) AS "Revenue", SUM(quantityordered) AS "Quantity_Sold"
FROM customer_orders
	WHERE month_id = '11'
GROUP BY 1
ORDER BY 3 DESC
			/*  The companies best seller i.e, Cars is the reason for November's
				high revenues  */


-- RFM ANALYSIS

WITH Recency AS (
	SELECT customername, '2005-06-01'::DATE - MAX(orderdate) AS Recency
	FROM Customer_orders
	GROUP BY Customername
),
Frequency AS (
	SELECT customername, COUNT(ordernumber) AS Frequency
	FROM customer_orders
	GROUP BY customername
),
Monetary AS (
	SELECT customername, SUM(sales) AS Monetary
	FROM customer_orders
	GROUP BY customername
),
RFM_Score AS (
	SELECT R.customername, R.Recency, F.Frequency, M.Monetary,
		NTILE(4) OVER(ORDER BY Recency) AS RecencyRank,
		NTILE(4) OVER(ORDER BY Frequency DESC) AS FrequencyRank,
		NTILE(4) OVER(ORDER BY Monetary DESC) AS MonetaryRank
FROM Recency R
		JOIN Frequency F ON R.customername = F.customername
		JOIN Monetary M ON R.customername = M.customername
)
--Categorizing Customers
SELECT customername,
	CASE
		WHEN RecencyRank = 1 AND FrequencyRank = 4 AND MonetaryRank >= 3 THEN 'Loyal'
		WHEN RecencyRank = 1 AND FrequencyRank IN (3,4) AND MonetaryRank IN (3,4) THEN 'Active'
		WHEN RecencyRank IN (2,3)  AND FrequencyRank >= 3 AND MonetaryRank >= 3 THEN 'Potential Churner'
		WHEN RecencyRank >= 3 AND FrequencyRank IN (2,3) AND MonetaryRank >= 2 THEN 'Slipping Away'
		WHEN RecencyRank = 1 AND FrequencyRank = 1 AND MonetaryRank = 1 THEN 'New Customer'
		WHEN RecencyRank = 4 AND FrequencyRank >= 1 AND MonetaryRank >= 1 THEN 'Inactive'
		ELSE 'Other'
	END AS CustomerCategory
FROM RFM_Score
ORDER BY CustomerCategory;

--BEHAVIOURAL SEGMENTATION.

		--Grouping customers by productline to see their purchasing behaviour.
SELECT customername, productline, SUM(sales) AS Total_Sales
FROM customer_orders
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

		--Extract the productline with highest sales for each cutomer.
--From this query we can see the Top Preference of each customer.

WITH CustomerProductPreference AS (
	SELECT customername, productline, SUM(sales) AS Total_Sales,
	ROW_NUMBER() OVER (PARTITION BY customername ORDER BY SUM(sales)DESC)AS Rank
	FROM customer_orders
	GROUP BY 1, 2
)
SELECT customername, productline, Total_Sales,
	CASE
		WHEN productline IN ('Classic Cars','Vintage Cars') THEN 'Car Enthusiast'
		WHEN productline = 'Trains' THEN 'Train Collectors'
		WHEN productline = 'Planes' THEN 'Plane Lover'
		WHEN productline = 'Trucks and Buses' THEN 'Heavy Vehicles Fan'
		WHEN productline = 'Motorcycles' THEN '2-Wheeler Fan'
		WHEN productline = 'Ships' THEN 'Water vehicle lover'
	END AS Customer_Segment
	FROM CustomerProductPreference
WHERE Rank = 1;