# PizzaRunner_CS
B. Runner_And_Custumer_Experience
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

 

