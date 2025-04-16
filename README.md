# 🛍️ Retail Sales Analysis (SQL Project)

A structured SQL project for analyzing retail sales data to uncover trends, customer behavior, product performance, and time-based insights.

---

## 📦 Database Overview

**Database Name**: `retail_sales_project`  
**Primary Table**: `retail_sales`

### Table Schema

| Column Name       | Data Type   | Description                         |
|-------------------|-------------|-------------------------------------|
| transaction_id    | INT         | Unique transaction identifier       |
| sale_date         | DATE        | Date when the sale occurred         |
| sale_time         | TIME        | Time when the sale occurred         |
| customer_id       | INT         | Unique customer ID                  |
| gender            | VARCHAR(6)  | Gender of the customer              |
| age               | INT         | Age of the customer                 |
| category          | VARCHAR(20) | Product category                    |
| quantity          | INT         | Quantity of items sold              |
| price_per_unit    | FLOAT       | Price per individual item           |
| cogs              | FLOAT       | Cost of goods sold                  |
| total_sale        | FLOAT       | Total sale value                    |

---

## 🧹 Data Cleaning

Removed rows containing `NULL` values in any critical column to ensure accuracy in analysis:

```sql
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


## Key Analysis
**General Metrics**
.Total number of transactions

.Total number of unique customers

**Customer Behavior**
.Top 5 customers by total sales

.Average age of customers in the Beauty category

.Unique customers per product category

**Product Insights**
.Total sales by category

.High-value transactions (sales > 1000)

.Clothing sales with quantity > 3 (Nov 2022)

**Time-Based Trends**
.Average monthly sales per year

.Best-performing month in each year

.Daily sales trends

**Time-of-Day Analysis**
.Classify sales by time of day into shifts and count orders in each shift:

.Morning: Before 12:00

.Afternoon: Between 12:00 and 17:00

.Evening: After 17:00 E.G

```sql
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

## Potential Enhancements
.Add Tableau or Power BI dashboard for visual storytelling

.Automate monthly reports using stored procedures

.Analyze discount/promotions impact on sales