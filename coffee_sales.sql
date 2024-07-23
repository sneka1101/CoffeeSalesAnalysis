SELECT * FROM coffee.coffee_shop_sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

alter table coffee_shop_sales
modify column transaction_date DATE;

UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H.%i.%s');

alter table coffee_shop_sales
modify column transaction_time TIME;

 describe coffee_shop_sales;
 
alter table coffee_shop_sales
change column ï»¿transaction_id transaction_id int;

select round(sum(unit_price * transaction_qty )) as total_sales
from coffee_shop_sales where month(transaction_date) =3; -- march

-- know about the sales between prev ious and this month

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
    
-- total quality
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)

SELECT MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    -- calender heat map
    select 
    round(sum(unit_price * transaction_qty)) as total_sales,
    sum(transaction_qty) as total_qty_sales,
    count(transaction_id) as total_orders
    from coffee_shop_sales where transaction_date='2023-05-18';

-- sales by weekend or weekday
select 
case when dayofweek(transaction_date)in (1,7) then 'weekday'
else 'weekend'
end as day_type,
round(sum(unit_price*transaction_qty) )as total_sales
from coffee_shop_sales
where month(transaction_date)=2
group by day_type;


-- store location
select 
 store_location,
 round(sum(unit_price*transaction_qty)) as total_sales
 from coffee_shop_sales
 where month(transaction_date)=5
 group by store_location
order by total_sales desc;

-- average and daily sales line
select round(avg(total_sales)) as avg_sales
from (
select sum(transaction_qty * unit_price)as total_sales
from coffee_shop_sales
where month(transaction_date)=5
group by transaction_date) as inner_query;

select
day(transaction_date) as day_month,
round(sum(transaction_qty * unit_price)) as total_sales
from coffee_shop_sales
where month(transaction_date)=5
group by day_month
order by day_month;

-- selection by product
select product_category,
round(sum(transaction_qty * unit_price)) as total_sales
from coffee_shop_sales
where month(transaction_date)=5
group by product_category
order by total_sales desc;


-- top10 sales
select product_type,
round(sum(transaction_qty * unit_price)) as total_sales
from coffee_shop_sales
where month(transaction_date)=5 and product_category='Coffee'
group by product_type
order by total_sales desc
limit 10;


