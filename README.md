# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

### 2. Create a table
```sql
create table retail_sales(
                          transactions_id int primary key,
                          sale_date date,
			  sale_time time,
			  customer_id int,
                          gender varchar(10),
			  age int,	
			  category varchar(35),
			  quantity int,	
			  price_per_unit float,	
			  cogs float,
			  total_sale float
			);
```


### 3. Drop a table
```sql
drop table if exists retail_sales;
```
### 4. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
select * from retail_sales limit 10;
select 
   count (*) 
from retail_sales;
```
### 5.DATA CLEANING
--checking the null values in all columns (individual column check)
```sql
select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where customer_id is null;

select * from retail_sales
where gender is null;
```
### Alternative Method to check the null values in one command for all columns
```sql
select * from retail_sales
where 
     transactions_id is null 
     or
     sale_date is null
     or
     sale_time is null
     or
     customer_id is null
     or
     gender is null
     or
     age is null
     or
     category is null
     or
     quantity is null
     or
     price_per_unit is null
     or
     cogs is null
     or
     total_sale is null;
```
### Deleting null values considering all the columns into the criteria
```sql
delete from retail_sales
where 
     transactions_id is null 
     or
	 sale_date is null
	 or
	 sale_time is null
	 or
	 customer_id is null
	 or
	 gender	is null
	 or
	 age is null
	 or
	 category is null
	 or
	 quantity is null
	 or
	 price_per_unit	is null
	 or
	 cogs is null
	 or
	 total_sale is null;
```
### 6. DATA EXPLORATION 

--how many sales we have?
```sql
select count(*) as total_sales from retail_sales;
```
--how many customers we have?
```sql
select
 count(distinct(customer_id)) as total_customers from retail_sales;
``` 
--how many categories we have?
```sql
select
 count(distinct(category)) as total_customers from retail_sales;
```
--What are the categories we have
```sql
select 
      distinct(category) as types_in_categories 
	  from retail_sales;
```

### 7. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from retail_sales
where
sale_date = '2022-11-05';
```
2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * from retail_sales
where category = 'Clothing' 
  and 
     quantity >= 4 
  and 
  to_char(sale_date,'YYYY-MM') ='2022-11';
```
--3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select 
  category,
  sum(total_sale) as net_sales,
  count(transactions_id) as total_transcations
from retail_sales
group by 1;
```
--4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select 
     round(avg(age)) as Avg_age
from retail_sales
where category='Beauty';
```
--5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select
* 
from retail_sales
where 
total_sale > 1000;
```

--6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select gender,category,
count(*) as total_trans
from retail_sales
group by gender,category
order by 2;
```
--7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
--(Additional notes:Rank is a window function Partition in the below used to diffenetiatie the ranking in both 2022 and 2023 and nte we should not use alias inside the windows function,as in the below we created --a new row called Rank,we will not be able  to directly print the value so use the sub query function.)
```sql
select *
from
(select
    Extract(YEAR from sale_date) as year,
    Extract(MONTH from sale_date) as month,
	avg(total_sale) as avg_sales,
	Rank() over(Partition by Extract(YEAR from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2)
where rank = 1;
```
--8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select customer_id,
       sum(total_sale) as total_sale
from  retail_sales
group by 1
order by 2 desc
limit 5;
```
--9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select 
count(distinct(customer_id)) as unique_number_of_customers,category
from retail_sales
group by 2
order by 1;
```
--10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
--Used CTE Common Table EXpression
```sql
with hourly_sales as
(
select *,
   case
     when extract (HOUR from sale_time)< 12 then 'Morning'
     when extract (HOUR from sale_time) between 12 and 17 then 'Afternoon'
     Else 'Evening'
   End as shift
from retail_sales
)
select shift,
       count(*) as total_orders 
from hourly_sales
group by shift
```

--End of the project
 

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


## Author - Malleswari Kosuri



