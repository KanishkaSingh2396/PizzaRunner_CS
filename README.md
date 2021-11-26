# PizzaRunner_CS
![image](https://user-images.githubusercontent.com/89623051/143556857-bbfc6c54-ea67-48ff-bcf5-5a1b8ecd8d20.png)

![image](https://user-images.githubusercontent.com/89623051/143557019-c7d4c62e-e248-40cb-914f-df5a14b8c8bf.png)

### Datasets

![image](https://user-images.githubusercontent.com/89623051/143557129-e0d29cab-56af-4a15-8a59-fcdff5f86c5a.png)

#### Table 2: customer_orders

Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.

The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.

Note that customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!

The exclusions and extras columns will need to be cleaned up before using them in your queries.

![image](https://user-images.githubusercontent.com/89623051/143557314-aa6c11fd-72e3-48c2-b230-0b7e30e8f8ce.png)

#### Table 3: runner_orders

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the ERD!

![image](https://user-images.githubusercontent.com/89623051/143557442-7ebf74ce-ee7f-4a26-b06d-a1464b90ec4f.png)

![image](https://user-images.githubusercontent.com/89623051/143557509-4282aac9-2c1f-486c-baf1-266eeee2f7e1.png)

![image](https://user-images.githubusercontent.com/89623051/143557607-8c97dd58-9631-488f-9ee1-4bc72bcb2ebf.png)

### Case Study Questions

This case study has LOTS of questions - they are broken up by area of focus including: * Pizza Metrics * Runner and Customer Experience * Ingredient Optimisation * Pricing and Ratings * Bonus DML Challenges (DML = Data Manipulation Language)

Each of the following case study questions can be answered using a single SQL statement.

Again, there are many questions in this case study - please feel free to pick and choose which ones you’d like to try!

Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!

### A. Pizza Metrics

How many pizzas were ordered?

How many unique customer orders were made?

How many successful orders were delivered by each runner?

How many of each type of pizza was delivered?

How many Vegetarian and Meatlovers were ordered by each customer?

What was the maximum number of pizzas delivered in a single order?

For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

How many pizzas were delivered that had both exclusions and extras?

What was the total volume of pizzas ordered for each hour of the day?

What was the volume of orders for each day of the week?

### B. Runner and Customer Experience

How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

Is there any relationship between the number of pizzas and how long the order takes to prepare?

What was the average distance travelled for each customer?

What was the difference between the longest and shortest delivery times for all orders?

What was the average speed for each runner for each delivery and do you notice any trend for these values?

What is the successful delivery percentage for each runner?

### C. Ingredient Optimisation

What are the standard ingredients for each pizza?

What was the most commonly added extra?

What was the most common exclusion?

Generate an order item for each record in the customers_orders table in the format of one of the following:

Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

### D. Pricing and Ratings

If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra

The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas

If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

### E. Bonus Questions

If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

### SOLUTION

###  data cleaning for runner_orders table

```sql
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
```
![image](https://user-images.githubusercontent.com/89623051/142488444-af56bfb6-2674-48a5-a7cb-1d0cccf0dbf1.png)

--------------------------------------------
### data cleaning customer_orders table

```sql
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
```
![image](https://user-images.githubusercontent.com/89623051/142488641-57d20d3c-14ca-4f4a-879d-9f601d6b03fc.png)

--------------------------------------------------------------
### Part A. Pizza Metrics
##### 1. How many pizzas were ordered?
--table used: customer_orders
```sql
select count(order_id) from pizza_runner.customer_orders;
```
![image](https://user-images.githubusercontent.com/89623051/142488775-2945a587-3ac4-478a-856d-56f0c3e22ab2.png)

##### 2. How many unique customer orders were made?

```sql 
select count(distinct order_id) from pizza_runner.customer_orders;
 ```
 ![image](https://user-images.githubusercontent.com/89623051/142488895-76223df0-402e-4e6c-820d-7b2a78ac1c57.png)

##### 3. How many successful orders were delivered by each runner?
select* from runner_orders_1;
```sql
select runner_id, count(cancellation) as completed_orders
from runner_orders_1
where cancellation = ''
group by runner_id;
```
![image](https://user-images.githubusercontent.com/89623051/141170308-83c32fd8-787a-45b3-9164-c31c6e9ebed5.png)

##### 4. How many of each type of pizza was delivered?

![image](https://user-images.githubusercontent.com/89623051/141170376-3c208a99-b4d4-42a7-9805-104843534a8c.png)

```sql
  
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
```
-------------------------------------------
##### 5. How many Vegetarian and Meatlovers were ordered by each customer?
```sql
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
```

![image](https://user-images.githubusercontent.com/89623051/141170490-18f19bfb-37a8-44ab-99cd-b45fffa12fa3.png)

------------------------------------------
```sql
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
```

![image](https://user-images.githubusercontent.com/89623051/141170625-2e9b634b-6dda-4791-8840-82c87b8e7cfd.png)

--------------------------------------------------
##### 6. What was the maximum number of pizzas delivered in a single order?
```sql
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
```

![image](https://user-images.githubusercontent.com/89623051/141170762-607bf7bc-d9dc-44e6-b66b-d8420653cedf.png)

##### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
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
```

![image](https://user-images.githubusercontent.com/89623051/141170866-8d868eac-607b-45b2-a5da-85f801f342c0.png)

-----------------------------------------
##### 8. How many pizzas were delivered that had both exclusions and extras?
```sql
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
```
![image](https://user-images.githubusercontent.com/89623051/141170975-13f11a7f-260b-4793-b56e-cc6f5a04be6d.png)


##### 9. What was the total volume of pizzas ordered for each hour of the day?
```sql
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
```

![image](https://user-images.githubusercontent.com/89623051/141171082-f7157cfa-de4e-4dcf-9975-d13f5d3c94f9.png)


##### 10. What was the volume of orders for each day of the week?
```sql
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
```
![image](https://user-images.githubusercontent.com/89623051/141171274-ca625d8f-1faa-41f6-bb7d-d1c230363d4a.png)


### B. Runner_And_Custumer_Experience

##### Runner and Customer Experience

##### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```sql
select 
  (date_trunc('week', registration_date - interval '4 day') + interval '4 day')::date as week_starting_date,
  count(runner_id) as runners_count
from pizza_runner.runners
group by week_starting_date
order by runners_count desc;
```
![image](https://user-images.githubusercontent.com/89623051/141165486-e449103f-e866-471f-980f-1bfaf2d44d41.png)

 
##### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```sql
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
```
![image](https://user-images.githubusercontent.com/89623051/141165704-5f8742bf-1eee-4800-8f54-9d7d1333efd9.png)

##### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
```sql
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
```

![image](https://user-images.githubusercontent.com/89623051/141165768-f0a22343-6d9d-418e-b7dd-fa3778a69c46.png)
 
##### 4. What was the average distance travelled for each customer?
```sql
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
```

![image](https://user-images.githubusercontent.com/89623051/141165838-a687fe6f-aeef-431a-ba6a-872452a5dc03.png)


##### 5. What was the difference between the longest and shortest delivery times for all orders?
```sql
with duration_cast as(
select TO_NUMBER(duration_mins, '99') as duration_1
from runner_orders_1 where duration_mins != ''),

max_min_tb as (select 
  max(duration_1) as max_duration,
  min(duration_1) as min_duration
from duration_cast)

select (max_duration - min_duration) as difference_in_duration
from max_min_tb
```
![image](https://user-images.githubusercontent.com/89623051/141165897-63dac1da-51c6-46eb-a671-d7638d9fec15.png)


##### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
```sql
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
```
![image](https://user-images.githubusercontent.com/89623051/141165948-677926ed-b59b-4677-90fa-fdfdc6684a4d.png)


##### 7. What is the successful delivery percentage for each runner?
```sql
SELECT
  runner_id,
  ROUND(
    100 * sum(CASE WHEN pickup_time != '' THEN 1 ELSE 0 END) /
    COUNT(*) ,2) AS success_percentage
FROM runner_orders_1
GROUP BY runner_id
ORDER BY runner_id;
```
![image](https://user-images.githubusercontent.com/89623051/141165986-0a554c9c-567d-47ec-b71e-73426d3d5bfc.png)


### Part C. Ingredient Optimisation

##### Question 1 What are the standard ingredients for each pizza?
```sql
with regex_tb as (
select pizza_id, REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+') as topping_id
from pizza_runner.pizza_recipes )

select* from regex_tb
select  
  pizza_id, 
  STRING_AGG(pt.topping_name::TEXT, ', ') AS standard_ingredients
from regex_tb rt
join pizza_runner.pizza_toppings pt
  on rt.topping_id:: text = pt.topping_id :: text
group by pizza_id
order by pizza_id
```
![image](https://user-images.githubusercontent.com/89623051/142489438-0b5b5c0a-c3a6-460b-9bec-30a2d357ef65.png)

##### Question 2 What was the most commonly added extra?
```sql
with extras_tb as(
select order_id, pizza_id, extras from customer_orders_1 where extras != ''),

count_tb as (select 
  REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+') :: int as topping_id,
  count(*) as topping_counts
from extras_tb
group by topping_id
order by topping_counts desc)

select count_tb.topping_id, topping_name, topping_counts
from count_tb 
left join pizza_runner.pizza_toppings pt
on count_tb.topping_id = pt.topping_id
```
![image](https://user-images.githubusercontent.com/89623051/142489534-70fbb8b5-4514-4be3-8297-e8f6bfe534a8.png)

##### Question 3 What was the most common exclusion?
```sql
with exclusion_tb as(
select order_id, pizza_id, exclusions 
from customer_orders_1 
where exclusions != ''),

count_tb as (select 
  REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+') :: int as topping_id,
  count(*) as topping_counts
from exclusion_tb
group by topping_id)

select count_tb.topping_id, topping_name, topping_counts
from count_tb 
left join pizza_runner.pizza_toppings pt
on count_tb.topping_id = pt.topping_id
order by topping_counts desc
```
![image](https://user-images.githubusercontent.com/89623051/142489634-0bb4cab3-4422-4b50-8279-f40fb8b4568c.png)

##### Question 4. Generate an order item for each record in the customers_orders table in the format of one of the following: 
-- Meat Lovers + Meat Lovers - Exclude Beef + Meat Lovers - Extra Bacon + Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
```sql
with adjusted_tb as(
select order_id, customer_id, pizza_id, extras, exclusions from customer_orders_1),

split_tb as (
select 
  order_id, 
  customer_id,
  pizza_id,
  REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+') :: text as topping_id,
  REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+') :: text as exclusions
from adjusted_tb)

select order_id, customer_id, st.pizza_id, pizza_name, topping_name, st.topping_id, exclusions
from split_tb st
join pizza_runner.pizza_names pn
on st.pizza_id = pn.pizza_id
left join pizza_runner.pizza_toppings pt
on st.topping_id = pt.topping_id::text
```

![image](https://user-images.githubusercontent.com/89623051/142489865-e3f209c2-c9ae-4842-b135-b341da85a5c1.png)

