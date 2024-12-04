--create table
--cogs purchasing cost
drop table if exists retail_sales;
create table retail_sales(
                          transactions_id int primary key,
                          sale_date date,	
						  sale_time time,	
						  customer_id int,	
						  gender varchar(10),
						  age int,	
						  category	varchar(35),
						  quantity int,	
						  price_per_unit float,	
						  cogs float,
						  total_sale float
						  );
--
select * from retail_sales;
--
select * from retail_sales limit 10;
--
select 
   count (*) 
from retail_sales;
--DATA CLEANING
--checking the null values in all columns (individula check)

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
-- to check the null values in one command for all columns

select * from retail_sales
where 
     transactions_id is null 
     or
	 sale_date is null
	 or
	 sale_time is null
	 or
	 customer_id	is null
	 or
	 gender	is null
	 or
	 age	is null
	 or
	 category	is null
	 or
	 quantity	is null
	 or
	 price_per_unit	is null
	 or
	 cogs	is null
	 or
	 total_sale is null;
---deleting null values considering all the columns into the criteria
delete from retail_sales
where 
     transactions_id is null 
     or
	 sale_date is null
	 or
	 sale_time is null
	 or
	 customer_id	is null
	 or
	 gender	is null
	 or
	 age	is null
	 or
	 category	is null
	 or
	 quantity	is null
	 or
	 price_per_unit	is null
	 or
	 cogs	is null
	 or
	 total_sale is null;


----DATA EXPLORATION 

--how many sales we have?
select count(*) as total_sales from retail_sales;

--how many customers we have?
select
 count(distinct(customer_id)) as total_customers from retail_sales;
 
--how many categories we have?
select
 count(distinct(category)) as total_customers from retail_sales;

--What are the categories we have
select 
      distinct(category) as types_in_categories 
	  from retail_sales;

-- Data Analysis:
--Bussiness Key Problems and Answers
--1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

select * from retail_sales
where
sale_date = '2022-11-05';

--2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022**:

select * from retail_sales
where category = 'Clothing' 
  and 
  quantity >= 4 
  and 
  to_char(sale_date,'YYYY-MM') ='2022-11';
  
--3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
select 
  category,
  sum(total_sale) as net_sales,
  count(transactions_id) as total_transcations
from retail_sales
group by 1;

--4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select 
     round(avg(age)) as Avg_age
from retail_sales
where category='Beauty';

--5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
select
* 
from retail_sales
where 
total_sale > 1000;

--6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
select gender,category,
count(*) as total_trans
from retail_sales
group by gender,category
order by 2;

--7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
--Rank is a window function
--Partition in the below used to diffenetiatie the ranking in both 2022 and 2023 and nte we should not use alias inside the windows function
--as in the below we created a new row called Rank,we will not be bale  to diercetly print the value
--so use the sub query function.
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

--8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id,
       sum(total_sale) as total_sale
from  retail_sales
group by 1
order by 2 desc
limit 5;

--9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:

select 
count(distinct(customer_id)) as unique_number_of_customers,category
from retail_sales
group by 2
order by 1;

--10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
--Used CTE Common Table EXpression
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


--End of the project
 





