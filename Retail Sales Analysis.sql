CREATE DATABASE Retail_sales;
USE Retail_sales;

CREATE TABLE retail_sales_analysis (
    transactions_id INT NOT NULL PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(50),
    age INT,
    category VARCHAR(50),
    quantiy INT,
    price_per_unit INT,
    cogs FLOAT,
    total_sale FLOAT
);


ALTER TABLE retail_sales_analysis MODIFY age INT NULL;
ALTER TABLE retail_sales_analysis MODIFY quantity INT NULL;
ALTER TABLE retail_sales_analysis MODIFY price_per_unit INT NULL;
ALTER TABLE retail_sales_analysis MODIFY cogs INT NULL;
ALTER TABLE retail_sales_analysis MODIFY total_sale INT NULL;

---------------------------------------------------- 

-- THERE ARE SOME NULL VALUES HERE SO-------------------------------------------------

SELECT 
    *
FROM
    retail_sales_analysis
WHERE
    transactions_id IS NULL
        OR customer_id IS NULL
        OR quantiy IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
    

DELETE FROM retail_sales_analysis 
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

SET SQL_SAFE_UPDATES = 0;                   --- -------to turn off the safe mode------------ 

SELECT 
    *
FROM
    retail_sales_analysis;
    
-- Q1. how many sales we have?----------------

SELECT 
    COUNT(*)
FROM
    retail_sales_analysis;

-- Q2. how many customers we have?

SELECT 
    COUNT(DISTINCT customer_id)
FROM
    retail_sales_analysis;

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05.

SELECT 
    *
FROM
    retail_sales_analysis
WHERE
    sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
    
    
SELECT *
FROM retail_sales_analysis
WHERE 
    category = 'Clothing'
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND quantiy >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category, SUM(total_sale), COUNT(*) AS total_orders
FROM
    retail_sales_analysis
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
    category, ROUND(AVG(age), 2)
FROM
    retail_sales_analysis
WHERE
    category = 'Beauty';
    
-- Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT 
    *
FROM
    retail_sales_analysis
WHERE
    total_sale > '1000';

-- Write a SQL query to find the total number of transactions made by each gender in each category.

SELECT 
    COUNT(*) AS total_no_of_transactions, gender, category
FROM
    retail_sales_analysis
GROUP BY gender , category
ORDER BY 1;


-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT * FROM(
	SELECT
		year_val,
		month_val,
		avg_sale,
		RANK() OVER (PARTITION BY year_val ORDER BY avg_sale) AS rnk
		FROM (
			SELECT
				year(sale_date) AS year_val, month(sale_date) AS month_val, AVG(total_sale) AS avg_Sale 
			FROM retail_sales_analysis
		GROUP BY 1,2) AS var1
) AS var2
WHERE rnk = 1;


-- year(sale_date)---used to extract the year from sale_date----------
-- month(sale_date)---used to extract the month from sale_date----------
-- date(sale_date)---used to extract the date from sale_date----------


-- Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
    SUM(total_sale), customer_id
FROM
    retail_sales_analysis
GROUP BY 2
ORDER BY 2 DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:


SELECT 
    category, COUNT(DISTINCT customer_id)
FROM
    retail_sales_analysis
GROUP BY 1;



-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17:

SELECT 
    COUNT(transactions_id), shift
FROM
    (SELECT 
        *,
            CASE
                WHEN HOUR(sale_time) < 12 THEN 'MORNING'
                WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
                ELSE 'EVENING'
            END AS SHIFT
    FROM
        retail_sales_analysis) AS HOURLY_SALE
GROUP BY 2;

-- ------------------------------------------OR----------------------------------------------------------------------------


WITH HOURLY_SALE AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'MORNING'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
            ELSE 'EVENING'
        END AS SHIFT
    FROM retail_sales_analysis
)
SELECT COUNT(transactions_id), SHIFT
FROM HOURLY_SALE
GROUP BY SHIFT;
