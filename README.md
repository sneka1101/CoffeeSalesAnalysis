# CoffeeSalesAnalysis



## About

This project analyzes coffee sales data to gain insights into sales trends, customer preferences, and product performance. The objective is to enhance sales strategies and optimize operations. The dataset contains various sales transactions from coffee shops.

## Purposes Of The Project

The main objectives of this project are to:

Understand sales trends and patterns across different months.
Identify high-performing products and analyze store performance.
Optimize sales strategies based on detailed data analysis.

## About Data

The dataset includes sales transactions from multiple coffee shops, featuring details such as sale date, product information, and sales quantities. It comprises 17 columns and multiple rows representing sales transactions over a period.



### Updated List

1. Data Updates

To ensure consistency in the transaction_date and transaction_time columns, the following updates were made:
Converted transaction_date from the string format to a proper DATE format.
Converted transaction_time from the string format to a TIME format.

3. Table Alterations
The transaction_date column was altered to have a DATE data type.
The transaction_time column was altered to have a TIME data type.
Renamed and corrected the column ï»¿transaction_id to transaction_id to fix encoding issues.


4. Data Analysis and Query Updates
Several SQL queries were executed to answer specific questions about the sales data, such as calculating total sales, comparing sales trends between months, and analyzing sales patterns by date and store location.


##  Question includes
1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?

```sql

-- updating table

UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

alter table coffee_shop_sales
modify column transaction_date DATE;



UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H.%i.%s');

alter table coffee_shop_sales
modify column transaction_time TIME;



-- solving question
-- - know about the sales between prev ious and this month

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- total order
select count(transaction_id)
from coffee_shop_sales
where month(transaction_date)=5;

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


```




