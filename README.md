# PizzaRunner_CS

-- data cleaning for runner_orders table
----------------------------------------------------
create table runner_orders_1 as (
select
  order_id, 
  runner_id, 
  
  case 
    when pickup_time = 'null' then ''
    else pickup_time
  end as pickup_time,
  
  case
    when cancellation is null or cancellation like 'null' then ''
    else cancellation 
  end as cancellation,
  
  case 
    WHEN duration is null or duration like 'null' then ''
    WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
    WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)        
    WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
    else duration 
  end as duration_mins,
  
  case
  when distance is null or distance like 'null' then ''
  when distance like '%km' then TRIM('km' from distance)
  else distance
  end as distance_km
from pizza_runner.runner_orders)
select* from runner_orders_1;

![image](https://user-images.githubusercontent.com/89623051/141168858-9a531dfe-a18d-4d62-894a-933b5920ba25.png)


--------------------------------------------
---data cleaning customer_orders table
create table customer_orders_1 as
select
order_id,
customer_id, pizza_id, 
case
  when exclusions is null or exclusions like 'null' then ''
  else exclusions
end as exclusions,
case
  when extras is null or extras like 'null' then ''
  else extras
end as extras,
order_time

from pizza_runner.customer_orders;
select* from customer_orders_1;

![image](https://user-images.githubusercontent.com/89623051/141169061-00e3b91b-eaa1-4057-a339-e1ae965546fb.png)


--------------------------------------------------------------
**--Part A. Pizza Metrics**
--1. How many pizzas were ordered?
--table used: customer_orders
select count(order_id) from pizza_runner.customer_orders;

![image](https://user-images.githubusercontent.com/89623051/141169731-0dbd3265-5beb-4724-9e62-59ec4271eeff.png)


--2. How many unique customer orders were made?
select count(distinct order_id) from pizza_runner.customer_orders;

![image](https://user-images.githubusercontent.com/89623051/141169808-cf7f3fce-1e38-4607-9c3a-fe822d51ee8b.png)
  
--3. How many successful orders were delivered by each runner?
select cancellation 
from runner_orders_1
where cancellation = '';

--------------------------------------------------
---------------------------------------------------
-- data cleaning for runner_orders table
----------------------------------------------------
drop table if exists runner_orders_1
create table runner_orders_1 as (
select
  order_id, 
  runner_id, 
  
  case 
    when pickup_time = 'null' then ''
    else pickup_time
  end as pickup_time,
  
  case
    when cancellation is null or cancellation like 'null' then ''
    else cancellation 
  end as cancellation,
  
  case 
    WHEN duration is null or duration like 'null' then ''
    WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
    WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)        
    WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
    else duration 
  end as duration_mins,
  
  case
  when distance is null or distance like 'null' then ''
  when distance like '%km' then TRIM('km' from distance)
  else distance
  end as distance_km
from pizza_runner.runner_orders)
select* from runner_orders_1;

--------------------------------------------
---data cleaning customer_orders table
drop table if exists customer_orders_1
create table customer_orders_1 as
select
order_id,
customer_id, pizza_id, 
case
  when exclusions = 'null' then ''
  else exclusions
end as exclusions,
case
  when extras = 'null' then ''
  else extras
end as extras,
order_time

from pizza_runner.customer_orders;
select* from customer_orders_1;

--------------------------------------------------------------
--Part A. Pizza Metrics
--1. How many pizzas were ordered?
--table used: customer_orders
select count(order_id) from pizza_runner.customer_orders;

--2. How many unique customer orders were made?
select count(distinct order_id) from pizza_runner.customer_orders;
  
--3. How many successful orders were delivered by each runner?
select* from runner_orders_1;

select runner_id, count(cancellation) as completed_orders
from runner_orders_1
where cancellation = ''
group by runner_id;

![image](https://user-images.githubusercontent.com/89623051/141170308-83c32fd8-787a-45b3-9164-c31c6e9ebed5.png)

--4. How many of each type of pizza was delivered?

![image](https://user-images.githubusercontent.com/89623051/141170376-3c208a99-b4d4-42a7-9805-104843534a8c.png)


  
with co_ro_pn_joined as(
select  co.order_id, co.customer_id, co.pizza_id, ro.runner_id, ro.cancellation, pn.pizza_name
from customer_orders_1 co
join runner_orders_1 ro
 on co.order_id = ro.order_id
join pizza_runner.pizza_names pn 
  on pn.pizza_id = co.pizza_id)
 
 
select pizza_name, count(*) as pizza_delivered
from co_ro_pn_joined
where cancellation = ''
group by pizza_name;

-------------------------------------------
--5. How many Vegetarian and Meatlovers were ordered by each customer?
with co_ro_pn_joined as(
select  co.order_id, co.customer_id, co.pizza_id, ro.runner_id, ro.cancellation, pn.pizza_name
from customer_orders_1 co
join runner_orders_1 ro
 on co.order_id = ro.order_id
join pizza_runner.pizza_names pn 
  on pn.pizza_id = co.pizza_id)

select customer_id, 
sum(CASE WHEN pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) as Meatlovers,
sum(CASE WHEN pizza_name = 'Vegetarian' THEN 2 ELSE 0 END) as Vegetarian
from co_ro_pn_joined
group by customer_id
order by customer_id;


![image](https://user-images.githubusercontent.com/89623051/141170490-18f19bfb-37a8-44ab-99cd-b45fffa12fa3.png)

------------------------------------------
with co_ro_pn_joined as(
select  co.order_id, co.customer_id, co.pizza_id, ro.runner_id, ro.cancellation, pn.pizza_name
from customer_orders_1 co
join runner_orders_1 ro
 on co.order_id = ro.order_id
join pizza_runner.pizza_names pn 
  on pn.pizza_id = co.pizza_id)
  
select customer_id, pizza_name,
count(pizza_name) as pizza_ordered
from co_ro_pn_joined
group by customer_id, pizza_name
order by customer_id;

![image](https://user-images.githubusercontent.com/89623051/141170625-2e9b634b-6dda-4791-8840-82c87b8e7cfd.png)

--------------------------------------------------
--6. What was the maximum number of pizzas delivered in a single order?
with co_ro_pn_joined as(
select  co.order_id, co.customer_id, co.pizza_id, ro.runner_id, ro.cancellation, pn.pizza_name
from customer_orders_1 co
join runner_orders_1 ro
 on co.order_id = ro.order_id
join pizza_runner.pizza_names pn 
  on pn.pizza_id = co.pizza_id)
  
select order_id, count( order_id) as max_del_in_singleOrder
from co_ro_pn_joined
group by order_id
order by count( order_id) desc
limit 1;

![image](https://user-images.githubusercontent.com/89623051/141170762-607bf7bc-d9dc-44e6-b66b-d8420653cedf.png)


--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

with co_ro_pn_joined as(
select  co.order_id, co.customer_id, co.pizza_id, ro.runner_id, ro.cancellation, pn.pizza_name, co.exclusions, co.extras, co.order_time
from customer_orders_1 co
join runner_orders_1 ro
 on co.order_id = ro.order_id
join pizza_runner.pizza_names pn 
  on pn.pizza_id = co.pizza_id),
  
variation_tb as (
  select customer_id, cancellation, exclusions, extras,
    case 
      when exclusions != '' or extras != '' then 'change'
      else 'no change'
    end as variation
 from co_ro_pn_joined)
 
select customer_id, count(variation), variation
from variation_tb
where cancellation = ''
group by variation, customer_id
order by customer_id

![image](https://user-images.githubusercontent.com/89623051/141170866-8d868eac-607b-45b2-a5da-85f801f342c0.png)

-----------------------------------------
--8. How many pizzas were delivered that had both exclusions and extras?

with co_ro_pn_joined as(
select  co.order_id, co.customer_id, co.pizza_id, ro.runner_id, ro.cancellation, pn.pizza_name, co.exclusions, co.extras
from customer_orders_1 co
join runner_orders_1 ro
 on co.order_id = ro.order_id
join pizza_runner.pizza_names pn 
  on pn.pizza_id = co.pizza_id)

select  count(order_id) as order_with_exc_extras
from co_ro_pn_joined
where exclusions != '' and extras != ''

![image](https://user-images.githubusercontent.com/89623051/141170975-13f11a7f-260b-4793-b56e-cc6f5a04be6d.png)


----9. What was the total volume of pizzas ordered for each hour of the day?

with co_ro_pn_joined as(
select  co.order_id, co.customer_id, co.pizza_id, ro.runner_id, ro.cancellation, pn.pizza_name, co.exclusions, co.extras, co.order_time
from customer_orders_1 co
join runner_orders_1 ro
 on co.order_id = ro.order_id
join pizza_runner.pizza_names pn 
  on pn.pizza_id = co.pizza_id),
  
hour_table as (select order_id, order_time,  
  extract(HOUR from order_time) as hours
from co_ro_pn_joined)

select count(order_id) as pizza_volume_ordered, hours
from hour_table
group by hours
order by hours

![image](https://user-images.githubusercontent.com/89623051/141171082-f7157cfa-de4e-4dcf-9975-d13f5d3c94f9.png)


--10. What was the volume of orders for each day of the week?
with co_ro_pn_joined as(
select  co.order_id, co.customer_id, co.pizza_id, ro.runner_id, ro.cancellation, pn.pizza_name, co.exclusions, co.extras, co.order_time
from customer_orders_1 co
join runner_orders_1 ro
 on co.order_id = ro.order_id
join pizza_runner.pizza_names pn 
  on pn.pizza_id = co.pizza_id),
  
day_tb as (select 
  To_Char(order_time, 'DAY') as day_of_week,
  order_id
from co_ro_pn_joined)

select day_of_week, count (order_id) as pizza_count
from day_tb
group by day_of_week
order by day_of_week

![image](https://user-images.githubusercontent.com/89623051/141171274-ca625d8f-1faa-41f6-bb7d-d1c230363d4a.png)


**B. Runner_And_Custumer_Experience**

--Runner and Customer Experience

--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select 
  (date_trunc('week', registration_date - interval '4 day') + interval '4 day')::date as week_starting_date,
  count(runner_id) as runners_count
from pizza_runner.runners
group by week_starting_date
order by runners_count desc;

![image](https://user-images.githubusercontent.com/89623051/141165486-e449103f-e866-471f-980f-1bfaf2d44d41.png)

 
--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

with joined_table as (
  select 
    runner_id,
    order_time,
    pickup_time,
    to_timestamp(pickup_time, 'yyyy-mm-dd hh24:mi:ss') as pickup_time_
  from customer_orders_1 co
  join runner_orders_1 ro
    on co.order_id = ro.order_id),
    
time_diff_tb as (select 
  
  runner_id,
  (((extract(epoch from pickup_time_) - extract(epoch from order_time))/(60))::real) as time_difference
from joined_table),

final_table as (select*
from time_diff_tb
where time_difference> 0)

select avg(time_difference) as avg_arrival_time, runner_id
from final_table
group by runner_id
order by runner_id

![image](https://user-images.githubusercontent.com/89623051/141165704-5f8742bf-1eee-4800-8f54-9d7d1333efd9.png)

--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
with joined_table as (
  select 
    co.order_time,
    ro.pickup_time,
    co.order_id,
    co.pizza_id,
    to_timestamp(pickup_time, 'yyyy-mm-dd hh24:mi:ss') as pickup_time_
  from customer_orders_1 co
  join runner_orders_1 ro
    on co.order_id = ro.order_id),
    
time_diff_tb as(
select 
  order_id,
  pizza_id,
  (((extract(epoch from pickup_time_) - extract(epoch from order_time))/(60))::real) as time_difference
from joined_table)

select 
  order_id, 
  count(pizza_id) as total_pizza, 
  avg(time_difference) as avg_preparation_time
from time_diff_tb 
where time_difference > 0
group by order_id
order by total_pizza desc, order_id

![image](https://user-images.githubusercontent.com/89623051/141165768-f0a22343-6d9d-418e-b7dd-fa3778a69c46.png)
 
--4. What was the average distance travelled for each customer?

with dis_travelled_tb as(
select TO_NUMBER(distance_km, '99D0') as distance_travelled, customer_id
from runner_orders_1 ro
join customer_orders_1 co
  on co.order_id = ro.order_id
where distance_km != '')

select 
  customer_id,
  round(avg(distance_travelled),2) as avg_distance
from dis_travelled_tb
group by customer_id
order by customer_id

![image](https://user-images.githubusercontent.com/89623051/141165838-a687fe6f-aeef-431a-ba6a-872452a5dc03.png)


--5. What was the difference between the longest and shortest delivery times for all orders?
with duration_cast as(
select TO_NUMBER(duration_mins, '99') as duration_1
from runner_orders_1 where duration_mins != ''),

max_min_tb as (select 
  max(duration_1) as max_duration,
  min(duration_1) as min_duration
from duration_cast)

select (max_duration - min_duration) as difference_in_duration
from max_min_tb

![image](https://user-images.githubusercontent.com/89623051/141165897-63dac1da-51c6-46eb-a671-d7638d9fec15.png)


--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
with joined_table as(
select 
  TO_NUMBER(distance_km, '99D0') as distance, 
  TO_NUMBER(duration_mins, '99') as duration,
  runner_id, 
  co.order_id
from runner_orders_1 ro
join customer_orders_1 co
  on co.order_id = ro.order_id
where distance_km != '' and duration_mins != '')

select
  order_id,
  runner_id,
  round(avg( distance / (duration/60)),2) as avg_speed_km_per_hr
from joined_table
group by runner_id, order_id
order by order_id

![image](https://user-images.githubusercontent.com/89623051/141165948-677926ed-b59b-4677-90fa-fdfdc6684a4d.png)


--7. What is the successful delivery percentage for each runner?
SELECT
  runner_id,
  ROUND(
    100 * sum(CASE WHEN pickup_time != '' THEN 1 ELSE 0 END) /
    COUNT(*) ,2) AS success_percentage
FROM runner_orders_1
GROUP BY runner_id
ORDER BY runner_id;

![image](https://user-images.githubusercontent.com/89623051/141165986-0a554c9c-567d-47ec-b71e-73426d3d5bfc.png)

 

