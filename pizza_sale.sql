
use pga50;
select * from orders;
select* from order_details;
select * from pizza_types;
select * from pizzas;


show tables;
select * from deliveries;
-- query1 Retrieve the total number of oreders Placed.
Select count(order_id ) As total_orders 
from
orders;
-- query2 Calculate the total Revenue Generated from pizza sales
select round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id;

-- querry 3 Identify the highest - priced pizza
select pizza_types.name,pizza.price from pizza_types
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- query 4 Identify the most comman pizza size ordered

select 
pizzas.size, Count(order_details.order_details_id) order_count
from pizzas 
join order_details on pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
order by order_count DESC;

-- query 5 List the top 5 most ordered Pizza type along with their quantities.
select pizza_types.name,
SUM(order_details.quantity) AS quantity
FROM pizza_types
join
pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join 
order_details on order_details.pizza_id=pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC limit 5;

-- query 6 Join the necessary tables to find the total quantity of each pizza category ordered
select 
      pizza_types.category,
      sum(order_details.quantity) as quantity
FROM
    pizza_types join pizzas
    on pizza_types.pizza_type_id=pizzas.pizza_type_id
JOIN
order_details
group by pizza_types.category
order by quantity desc;


-- 7 Determine the distribution of orders by hour of the day.
select hour(order_time),count(order_id) as order_count
from orders
group by hour(order_time);

-- 8 Join relevant tables to find the category wise distribution of pizzas.
select category,count(name)
from pizza_types
Group by category;

-- 9 Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0)
from(select orders.order_date,sum(order_details.quantity) as qunatity
from orders join order_details on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;


-- 10 Determine the top 3 most ordered pizza types based on revenue
select pizza_types.name, sum(order_details.quantity*pizza.prices) as revanue
FROM pizza_types 
join pizzas
on pizzas.pizza_type_id=pizza_types.pizza_types_id
join
order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by revanue desc
limit 3;


-- 11 calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,
round(sum(order_details.quantity*pizzas.price)/(select 
round(sum(order_details.quantity*pizzas.orice),2) as total_sales
from order_details
join pizzas on pizzas.pizza_type_id=order_details.pizza_id))*100 as revanue
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by revanue desc;



-- 12 Determine the top 3 most ordered pizza types based on revenue for each pizza category
select name,revanue from
(select category,name,revanue,
rank() over(partition by category order by revanue desc)as rn 
from
(select pizza_types.category,pizza_types.name,
sum((order_details.quantity)*pizzas.price) as revanue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category,pizza_types.name)as a)as b where rn <=3;





