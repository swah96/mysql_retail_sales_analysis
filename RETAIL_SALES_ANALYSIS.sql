-- RETAIL SALES ANALYSIS
CREATE DATABASE retail_sales_project;
USE retail_sales_project;

-- CREATE TABLE
CREATE TABLE retail_sales (
  transaction_id INT NOT NULL PRIMARY KEY,
  sale_date DATE NOT NULL,
  sale_time TIME NOT NULL,
  customer_id INT NOT NULL,
  gender VARCHAR(6) NOT NULL,
  age INT DEFAULT NULL,
  category VARCHAR(20) NOT NULL,
  quantity INT DEFAULT NULL,
  price_per_unit FLOAT DEFAULT NULL,
  cogs FLOAT DEFAULT NULL,
  total_sale FLOAT DEFAULT NULL
);


-- DATA CLEANING
SELECT *  FROM retail_sales
WHERE transactions_id is null
or
sale_date is null
or
sale_time is null
or
total_sale is null
or
cogs is null
or
price_per_unit is null
or
quantiy is null
or
category is null
or
age is null
or
gender is null
or
customer_id is null;

DELETE FROM retail_sales
WHERE transactions_id is null
or
sale_date is null
or
sale_time is null
or
total_sale is null
or
cogs is null
or
price_per_unit is null
or
quantiy is null
or
category is null
or
age is null
or
gender is null
or
customer_id is null;
            
SELECT COUNT(*) FROM retail_sales;      

-- DATA EXPLORATIONS

-- HOW MANY SALES WE HAVE 
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- HOW MANY CUSTOMERS
SELECT COUNT(DISTINCT CUSTOMER_ID) FROM retail_sales;

-- DAILY SALES TREND
SELECT sale_date, SUM(total_sale) AS daily_sales
FROM retail_sales
GROUP BY sale_date
ORDER BY sale_date;

-- REVENUE PER UNIT
SELECT category, SUM(total_sale) / SUM(quantiy) AS revenue_per_unit
FROM retail_sales
GROUP BY category;

-- DATA ANALYSIS

-- ALL COLUMNS FOR SALE MADE ON 2022/11/05
SELECT * 
FROM retail_sales
WHERE SALE_DATE = '2022-11-05';

-- ALL TRANSACTION WHERE THE CATEGORY IS CLOTHING AND THE QUANTITY SOLD IS MORE THAN 3 IN THE MONTH OF NOV-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy > 3
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';

-- Total Sales for Each Category
SELECT category, sum(total_sale) AS sum_total_sales
FROM retail_sales
GROUP BY 1;

-- AVG Age of Customers Who Purchased From the Beauty Category
SELECT AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- All the Transaction Where the Total Sale is Greater Than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Total Number of Transaction(transaction_id) Made by Each Gender in Each Category
SELECT category, gender, count(transactions_id)   
FROM retail_sales
GROUP BY category, gender
ORDER BY category;          
            
-- AVG Sale For Each Month, Find the Best Selling Month in Each Year
SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    AVG(total_sale) AS avg_monthly_sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY sale_year, sale_month;

SELECT sale_year, sale_month, total_sales
FROM (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale) AS total_sales,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail_sales
    GROUP BY sale_year, sale_month
) ranked_sales
WHERE sales_rank = 1;

-- Top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Number of Unique Customers Who Purchased Items From Each Category
SELECT COUNT(DISTINCT customer_id) AS num_of_customers, category
FROM retail_sales
GROUP BY category;

 -- Classify sales by time of day into shifts (Morning, Afternoon, Evening) and count the number of orders in each shift — e.g., Morning: before 12:00, Afternoon: 12:00–17:00, Evening: after 17:00.
SELECT shift, COUNT(*) AS number_of_orders
FROM (
  SELECT 
    CASE 
      WHEN sale_time < '12:00:00' THEN 'Morning'
      WHEN sale_time >= '12:00:00' AND sale_time < '17:00:00' THEN 'Afternoon'
      ELSE 'Evening'
    END AS shift
  FROM retail_sales
) AS shift_data
GROUP BY shift;

-- Most Popular Time Slot by Category
SELECT category, shift, COUNT(*) AS orders
FROM (
  SELECT category,
         CASE 
           WHEN sale_time < '12:00:00' THEN 'Morning'
           WHEN sale_time >= '12:00:00' AND sale_time < '17:00:00' THEN 'Afternoon'
           ELSE 'Evening'
         END AS shift
  FROM retail_sales
) AS category_shift
GROUP BY category, shift
ORDER BY category, orders DESC;
