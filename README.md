# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis   
**Database**: `Retail_sales`


## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_sales`.
- **Table Creation**: A table named `retail_sales_analysis ` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity , price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Retail_sales;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales_analysis;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales_analysis;
SELECT DISTINCT category FROM retail_sales_analysis;

SELECT * FROM retail_sales_analysis
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT 
    *
FROM
    retail_sales_analysis
WHERE
    sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales_analysis
WHERE 
    category = 'Clothing'
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND quantiy >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category, SUM(total_sale), COUNT(*) AS total_orders
FROM
    retail_sales_analysis
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
    category, ROUND(AVG(age), 2)
FROM
    retail_sales_analysis
WHERE
    category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT 
    *
FROM
    retail_sales_analysis
WHERE
    total_sale > '1000';
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    COUNT(*) AS total_no_of_transactions, gender, category
FROM
    retail_sales_analysis
GROUP BY gender , category
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    SUM(total_sale), customer_id
FROM
    retail_sales_analysis
GROUP BY 2
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category, COUNT(DISTINCT customer_id)
FROM
    retail_sales_analysis
GROUP BY 1;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

Thank You!
