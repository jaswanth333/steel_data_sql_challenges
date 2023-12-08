use steeldata;
#sales,cars,salespersons
-- 1. What are the details of all cars purchased in the year 2022?

select distinct(make),`type`,style,cost_$ from cars inner join sales using (car_id) where DATE_FORMAT(purchase_date,'%Y')='2022'; 

-- 2. What is the total number of cars sold by each salesperson?

select salesman_id,`name`,count(sale_id) as total_cars_sold from sales inner join salespersons using (salesman_id) group by salesman_id ;

-- 3. What is the total revenue generated by each salesperson?

select salesman_id,`name`,sum(cost_$) as total_rev 
from sales inner join cars using (car_id)
inner join salespersons using (salesman_id)
group by salesman_id
order by total_rev desc;
 
-- 4. What are the details of the cars sold by each salesperson?
select salesman_id,`name`,make,`type`,style,cost_$ from cars inner join sales using (car_id) inner join salespersons using (salesman_id) order by salesman_id;
-- 5. What is the total revenue generated by each car type
select `type`,sum(cost_$) as total_rev from cars inner join sales using (car_id)  group by `type` order by total_rev desc;
-- 6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?
select make,`type`,style,cost_$ from sales
inner join salespersons using (salesman_id)
inner join cars using (car_id)
where name='Emily Wong' and DATE_FORMAT(purchase_date,'%Y')='2021';
-- 7. What is the total revenue generated by the sales of hatchback cars?
select style,sum(cost_$) as total_rev from  cars inner join sales using (car_id)  where style='Hatchback' group by style;
-- 8. What is the total revenue generated by the sales of SUV cars in the year 2022?
select style,sum(cost_$) as total_rev from cars inner join sales using (car_id)  where style='SUV' and DATE_FORMAT(purchase_date,'%Y')='2022' group by style;
-- 9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?
with total_cars_sold_2023 as
(
select salesman_id,count(1) as total_cars_sold,rank() over ( order by count(1) desc) as rnk
from cars inner join sales using (car_id) 
where DATE_FORMAT(purchase_date,'%Y')='2023'
group by salesman_id
),
sales_person_lookup as
(
select name,city,total_cars_sold from salespersons inner join total_cars_sold_2023  using (salesman_id) where rnk=1) 

select * from sales_person_lookup;

-- 10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?

with highest_sales_person_2022 as
(
select salesman_id,sum(cost_$) as total_revenue,rank() over ( order by count(1) desc) as rnk 
from cars inner join sales using (car_id) 
where DATE_FORMAT(purchase_date,'%Y')='2022'
group by salesman_id
order by total_revenue desc),
sales_person_lookup as
(
select name,age,total_revenue from salespersons inner join highest_sales_person_2022  using (salesman_id) where rnk=1) 

select * from sales_person_lookup;