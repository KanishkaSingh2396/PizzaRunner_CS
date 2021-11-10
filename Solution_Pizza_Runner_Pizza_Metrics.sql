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

--------------------------------------------------------------
--Part A. Pizza Metrics
--1. How many pizzas were ordered?
--table used: customer_orders
select count(order_id) from pizza_runner.customer_orders;

--2. How many unique customer orders were made?
select count(distinct order_id) from pizza_runner.customer_orders;
  
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

--4. How many of each type of pizza was delivered?


  
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




