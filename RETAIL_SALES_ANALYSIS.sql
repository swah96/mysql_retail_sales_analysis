-- RETAIL SALES ANALYSIS
CREATE DATABASE retail_sales_project;
USE retail_sales_project;

-- CREATE TABLE
CREATE TABLE retail_sales (
  transactions_id int NOT NULL PRIMARY KEY,
  sale_date date NOT NULL,
  sale_time varchar(8) NOT NULL,
  customer_id int NOT NULL,
  gender varchar(6) NOT NULL,
  age int DEFAULT NULL,
  category varchar(11) NOT NULL,
  quantiy int DEFAULT NULL,
  price_per_unit int DEFAULT NULL,
  cogs float DEFAULT NULL,
  total_sale float DEFAULT NULL
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

-- DATA ANALYSIS

-- QUERY TO RETRIEVE ALL COLUMNS FOR SALE MADE ON 2022/11/05
SELECT * 
FROM retail_sales
WHERE SALE_DATE = '2022-11-05';

-- WRITE A QUERY TO RETRIEVE ALL TRANSACTION WHERE THE CATEGORY IS CLOTHING AND THE QUANTITY SOLD IS MORE THAN 3 IN THE MONTH OF NOV-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy > 3
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';

-- write query to calculate the total sales for each category
SELECT category, sum(total_sale) AS sum_total_sales
FROM retail_sales
GROUP BY 1;

-- write query to show the avg age of customers who purchased from the beauty category
SELECT AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- write a query to find all the transaction where the total sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- write a query to find the total number of transaction(transaction_id) made by each gender in each category
SELECT category, gender, count(transactions_id)   
FROM retail_sales
GROUP BY category, gender
ORDER BY category;          
            
-- wirte query to calculate the avg sale for each month, find the best selling month in each year
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

-- write query to find top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- write query to find the number of unique customers who purchased item from each category
SELECT COUNT(DISTINCT customer_id) AS num_of_cuustomers, category
FROM retail_sales
GROUP BY category;

 -- write query to categorize sale time into shifts and then the number of orders in each shift(example morning < 12:00, between 12:00 & 17:00, evening > 17:00)
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