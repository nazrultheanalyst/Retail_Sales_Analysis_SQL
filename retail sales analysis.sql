
--Create  Database
CREATE DATABASE RETAIL_SALES_DB;

-- Create Table Retail Sales DB
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,	
    customer_id INT,
    gender VARCHAR(15),	
    age INT,
    category VARCHAR(15),	
    quantiy INT,  -- spelling kept same as dataset
    price_per_unit FLOAT,	
    cogs FLOAT,	
    total_sale FLOAT
);

-- Rename column in the retail_sales table
ALTER TABLE RETAIL_SALES
RENAME COLUMN QUANTIY TO QUANTITY;

-- Data Cleaning
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;
	
-- DELETE NULL VALUE
DELETE FROM RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR COGS IS NULL
	OR TOTAL_SALEIS NULL;

SELECT
	COUNT(*)
FROM
	RETAIL_SALES;

-- Data Exploration

-- How many sales we have?
SELECT
	COUNT(*) AS TOTAL_SALE
FROM
	RETAIL_SALES;

-- How many uniuque customers we have ?
SELECT
	COUNT(DISTINCT customer_id) AS Unique_Customer
FROM
	RETAIL_SALES;

-- How many uniuque Category we have ?
SELECT
	DISTINCT category AS Category_Name
FROM
	RETAIL_SALES;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTITY >= 4;
	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS TOTAL_SALE_CATEGORY,
	COUNT(*) as total_orders
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;
	
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(AGE), 2) AS AVG_AGE
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty'
	
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT *
FROM(
SELECT 
	Extract(YEAR From sale_date) as Year,
	Extract(MONTH From sale_date) as Month,
	Round(Avg(total_sale)::numeric, 2) as Avg_Sale,
	Rank() OVER(Partition By Extract(YEAR From sale_date) ORDER By Round(Avg(total_sale)::numeric, 2) DESC) as rank
From retail_sales
GROUP By 1,2) as ranked_sale
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
	Sum(total_sale) as total_sale
FROM retail_sales
GROUP By 1
ORDER By total_sale DESC
LIMIT 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	Count( Distinct customer_id) as unique_customer
FROM retail_sales
GROUP By 1
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS (
SELECT 
	sale_time,
	Case 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
From retail_sales
)
SELECT 
	shift,
	Count(*) as total_orders
FROM hourly_sale
GROUP By 1;


WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

Select * From retail_sales;

-- Project End 