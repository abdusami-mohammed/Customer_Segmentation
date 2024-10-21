# CUSTOMER SEGMENTATION ANALYSIS FOR RETAIL SALES
Advanced customer segmentation analysis using SQL to enhance marketing strategies and drive sales growth.
## PROJECT OVERVIEW
This SQL project focuses on advanced customer segmentation techniques to derive actionable insights from sales data.The analysis includes-
- **RFM (Recency, Frequency, Monetary) Segmentation**, which categorizes customers based on their purchase behavior, helping to identify valuable customers and optimize marketing strategies.
- The project also explores **Behavioral Segmentation**, analyzing customer preferences by product line to understand buying behavior and enhance customer targeting.

Through these methodologies, the project aims to provide a comprehensive understanding of customer value and preferences, ultimately aiding businesses in improving customer retention and maximizing sales opportunities.

[![Watch the demo video](https://github.com/abdusami-mohammed/Customer_Segmentation/blob/b5b65b530fc2bf9a4bb8593d1e34a5c323c1e6da/Images/Dashboard.png)](https://github.com/abdusami-mohammed/Customer_Segmentation/blob/b5b65b530fc2bf9a4bb8593d1e34a5c323c1e6da/Images/Customer_segment_Dashboard_vid.mp4)

## [SQL QUERY](https://github.com/abdusami-mohammed/Customer_Segmentation/blob/e34060442a3411942d82e14137a2d0331095c54f/Customer%20Segmentation%20(RFM%20and%20Behavioural).sql)
## RFM ANALYSIS
![pic](https://github.com/abdusami-mohammed/Customer_Segmentation/blob/5509405c69b83a59de39888eeeb01ddcb7c19a65/Images/RFM%20Image.png?raw=true)
* RFM (*Recency, Frequency, Monetary*) is a powerful method used by businesses to segment customers
* Based on how recently they purchased(*Recency*), how often they buy(*Frequency*), and how much they spend(*Monetary*).
* This approach helps identify loyal customers, re-engage those slipping away, and focus efforts on high-value customers.
* With this data, businesses can create more targeted and personalized marketing strategies.

Sneak Peek into the RFM Segmentation Technique.
### For the complete code, Click here -> [SQL QUERY](https://github.com/abdusami-mohammed/Customer_Segmentation/blob/e34060442a3411942d82e14137a2d0331095c54f/Customer%20Segmentation%20(RFM%20and%20Behavioural).sql)
```sql
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
```

### TAILORED STRATEGIES FOR CUSTOMER SEGMENTS
In this RFM analysis, customers were divided into six distinct categories: Loyal, Active, New, Potential Churners, Slipping Away, and Lost. Each segment represents different customer behaviors and helps the business address unique challenges.

### **1. Lost Customers**
  * Action: Reach out to understand their reasons for leaving.
  * Initiatives:
      * Address common issues like product quality or delivery concerns.
      * Offer incentives or personalized deals to re-engage.
      * Provide updated services for those who relocated.

### **2. Slipping Away Customers** *(High-Value, Declining Engagement)*
* Action: Act fast with tailored offers to retain them.
* Initiatives:
    * Offer exclusive discounts and loyalty rewards.
    * Ease their shopping experience through digital payment solutions.
    * Provide special delivery options to new or changing locations.

### **3. New Customers**
* Action: Build trust and encourage repeat purchases.
* Initiatives:
    * Offer rewards points for each purchase that can be redeemed for gifts or discounts.
    * Collect feedback to improve their experience.
    * Ensure seamless delivery to homes or preferred locations.

### **4. Potential Churners**
* Action: Prevent disengagement by re-establishing value.
* Initiatives:
    * Provide personalized offers and discounts based on previous purchase behavior.
    * Send reminders for products they frequently buy, along with exclusive coupons.
    * Request feedback on their shopping experience and address any concerns.

### **5. Active Customers** *(Frequent, Mid-Spend Shoppers)*
* Action: Encourage them to spend more or shop more frequently.
* Initiatives:
    * Introduce a credit billing service to allow easier transactions.
    * Provide smaller quantity products at affordable prices to increase their purchase
      frequency.
    * Offer discounts on their usual purchases to build long-term engagement.

### **6. Loyal Customers** *(High-Value, Frequent Buyers)*
* Action: Keep them satisfied and maintain their loyalty.
* Initiatives:
    * Regularly follow up with them during their usual shopping periods.
    * Offer premium services, including sourcing special items not typically available.
    * Provide priority delivery to any location, with personalized customer service.


![pic](https://github.com/abdusami-mohammed/Customer_Segmentation/blob/5509405c69b83a59de39888eeeb01ddcb7c19a65/Images/Behavioural%20segmentation%20image.avif?raw=true)
## Behavioral Segmentation
* Customer Preferences: Focuses on customers' buying habits and product preferences.
* Targeted Offerings: Helps businesses tailor promotions based on purchasing patterns.
* Improved Engagement: Drives better customer satisfaction with personalized recommendations
* Understanding Customer.
* Enhanced Satisfaction.

Sneak Peek into the Behavioural Segmentation Technique.
### For the complete code, Click here -> [SQL QUERY](https://github.com/abdusami-mohammed/Customer_Segmentation/blob/e34060442a3411942d82e14137a2d0331095c54f/Customer%20Segmentation%20(RFM%20and%20Behavioural).sql)
```sql
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
```

* Through Behavioral Segmentation, customers were categorized based on their product preferences, enhancing targeted marketing efforts:
    * Car Enthusiast:
    * Train Collectors:
    * Plane Lovers:
    * Heavy Vehicle Fans:
    * 2-Wheeler Fans:
    * Water Vehicle Lovers:


# THANK YOU
