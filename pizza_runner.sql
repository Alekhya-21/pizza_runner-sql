-- pizza_runner schema
-- create tables   
DROP TABLE if exists runners;
CREATE TABLE runners(
	runner_id INTEGER(10),
    registration_date DATE
);
INSERT INTO runners VALUES(1,'2021-01-01');
INSERT INTO runners VALUES(2,'2021-01-03');
INSERT INTO runners VALUES(3,'2021-01-08');
INSERT INTO runners VALUES(4,'2021-01-15');
-- SELECT * FROM pizza_runner.runners;

DROP TABLE if exists customer_orders;
CREATE TABLE customer_orders(
	order_id INTEGER(10),
    customer_id INTEGER(10),
    pizza_id INTEGER(10),
	exclusions VARCHAR(10),
	extras VARCHAR(10),
	order_time TIMESTAMP
);
INSERT INTO customer_orders VALUES(1, 101, 1, '', '', '2020-01-01 18:05:02');
INSERT INTO customer_orders VALUES(2, 101, 1, '', '', '2020-01-01 19:00:52');
INSERT INTO customer_orders VALUES(3, 102, 1, '', '', '2020-01-02 23:51:23');
INSERT INTO customer_orders VALUES(3, 102, 2, '', NULL, '2020-01-02 23:51:23');
INSERT INTO customer_orders VALUES(4, 103, 1, '4', '', '2020-01-04 13:23:46');
INSERT INTO customer_orders VALUES(4, 103, 1, '4', '', '2020-01-04 13:23:46');
INSERT INTO customer_orders VALUES(4, 103, 2, '4', '', '2020-01-04 13:23:46');
INSERT INTO customer_orders VALUES(5, 104, 1, 'null', '1', '2020-01-08 21:00:29');
INSERT INTO customer_orders VALUES(6, 101, 2, 'null', 'null', '2020-01-08 21:03:13');
INSERT INTO customer_orders VALUES(7, 105, 2, 'null', '1', '2020-01-08 21:20:29');
INSERT INTO customer_orders VALUES(8, 102, 1, 'null', 'null', '2020-01-09 23:54:33');
INSERT INTO customer_orders VALUES(9, 103, 1, '4', '1, 5', '2020-01-10 11:22:59');
INSERT INTO customer_orders VALUES(10,104, 1, 'null', 'null', '2020-01-11 18:34:49');
INSERT INTO customer_orders VALUES(10,104, 1, '2, 6', '1, 4', '2020-01-11 18:34:49');
-- SELECT * FROM pizza_runner.customer_orders;

DROP TABLE if exists runner_orders;
CREATE TABLE runner_orders(
	order_id INTEGER(10),
    runner_id INTEGER(10),
    pickup_time VARCHAR(30),
    distance VARCHAR(30),
    duration VARCHAR(30),
    cancellation VARCHAR(30)
);
INSERT INTO runner_orders VALUES(1, 1, '2020-01-01 18:15:34', '20km', '32 minutes', '');
INSERT INTO runner_orders VALUES(2, 1, '2020-01-01 19:10:54', '20km', '27 minutes', '');
INSERT INTO runner_orders VALUES(3, 1, '2020-01-03 00:12:37', '13.4km', '20 mins', NULL);
INSERT INTO runner_orders VALUES(4, 2, '2020-01-04 13:53:03', '23.4', '40', NULL);
INSERT INTO runner_orders VALUES(5, 3, '2020-01-08 21:10:57', '10', '15', NULL);
INSERT INTO runner_orders VALUES(6, 3, 'null', 'null', 'null', 'Restaurant Cancellation');
INSERT INTO runner_orders VALUES(7, 2, '2020-01-08 21:30:45', '25km', '25mins', 'null');
INSERT INTO runner_orders VALUES(8, 2, '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null');
INSERT INTO runner_orders VALUES(9, 2, 'null', 'null', 'null', 'Customer Cancellation');
INSERT INTO runner_orders VALUES(10,1, '2020-01-11 18:50:20', '10km', '10minutes', 'null');
-- SELECT * FROM pizza_runner.runner_orders;

DROP TABLE if exists pizza_names;
CREATE TABLE pizza_names(
	pizza_id INTEGER(10),
    pizza_name VARCHAR(20)
);
INSERT INTO pizza_names VALUES(1,'Meat Lovers');
INSERT INTO pizza_names VALUES(2,'Vegetarian');
-- SELECT * FROM pizza_runner.pizza_names;

DROP TABLE if exists pizza_recipes;
CREATE TABLE pizza_recipes(
	pizza_id INTEGER(10),
    toppings TEXT
);
INSERT INTO pizza_recipes VALUES(1,'1, 2, 3, 4, 5, 6, 8, 10');
INSERT INTO pizza_recipes VALUES(2,'4, 6, 7, 9, 11, 12');
-- SELECT * FROM pizza_runner.pizza_recipes;

DROP TABLE if exists pizza_toppings;
CREATE TABLE pizza_toppings(
	topping_id INTEGER(10),
    topping_name VARCHAR(20)
);
INSERT INTO pizza_toppings VALUES(1,'Bacon');
INSERT INTO pizza_toppings VALUES(2, 'BBQ Sauce');
INSERT INTO pizza_toppings VALUES(3, 'Beef');
INSERT INTO pizza_toppings VALUES(4, 'Cheese');
INSERT INTO pizza_toppings VALUES(5, 'Chicken');
INSERT INTO pizza_toppings VALUES(6, 'Mushrooms');
INSERT INTO pizza_toppings VALUES(7, 'Onions');
INSERT INTO pizza_toppings VALUES(8, 'Pepperoni');
INSERT INTO pizza_toppings VALUES(9, 'Peppers');
INSERT INTO pizza_toppings VALUES(10, 'Salami');
INSERT INTO pizza_toppings VALUES(11, 'Tomatoes');
INSERT INTO pizza_toppings VALUES(12, 'Tomato Sauce');
-- SELECT * FROM pizza_runner.pizza_toppings;

-- Data cleaning remove null values from customer_orders & runner_orders table
-- describe- To see Null values in table
DESCRIBE customer_orders;

-- creating a temporary table and storing the new values in that table
CREATE TEMPORARY TABLE new_customer_orders
SELECT order_id,customer_id,pizza_id,
CASE
	WHEN exclusions LIKE 'null' THEN ''
	ELSE exclusions
END,
CASE
	WHEN extras LIKE 'null' THEN ''
	ELSE extras
END,
order_time
FROM customer_orders;
SELECT * FROM new_customer_orders;

-- verify whether the null values are removed or not from customer_orders table
DESCRIBE new_customer_orders;

DESCRIBE runner_orders;
SELECT * FROM runner_orders;
CREATE TEMPORARY TABLE new_runner_orders
SELECT order_id,runner_id,
CASE 
	WHEN pickup_time LIKE 'null' THEN ''
    ELSE pickup_time
END,
CASE
	WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
    WHEN distance LIKE 'null' THEN ''
    ELSE distance
END,
CASE
	WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
    WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
    WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)
    WHEN duration LIKE 'null' THEN ''
    ELSE duration
END,
CASE
	WHEN cancellation LIKE 'null' THEN ''
    ELSE cancellation
END
FROM runner_orders;
SELECT * FROM new_runner_orders;

-- A. Pizza Metrics
-- 1. How many pizzas were ordered?
SELECT COUNT(pizza_id) 
AS no_of_pizzas_ordered
FROM new_cutomer_orders; 

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id)
AS no_of_distinct_orders
FROM new_customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS successful_delivery
FROM new_runner_orders
WHERE cancellation NOT LIKE "%cancellation%"
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT pizza_names.pizza_name, COUNT(new_customer_orders.order_id) AS no_of_pizzas_delivered
FROM pizza_names
LEFT JOIN new_customer_orders
ON pizza_names.pizza_id=new_customer_orders.pizza_id
LEFT JOIN new_runner_orders
ON new_runner_orders.order_id=new_customer_orders.order_id
WHERE cancellation NOT LIKE "%cancellation%"
GROUP BY pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT new_customer_orders.customer_id,
	SUM(CASE 
		WHEN new_customer_orders.pizza_id=1 THEN 1 
        ELSE 0
        END) AS no_of_meatlovers,
	SUM(CASE
		WHEN new_customer_orders.pizza_id=2 THEN 1
        ELSE 0
        END) AS no_of_vegetarian
FROM new_customer_orders
INNER JOIN pizza_names
ON new_customer_orders.pizza_id=pizza_names.pizza_id
GROUP BY customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT order_id, 
COUNT(order_id) AS no_of_pizzas
FROM new_customer_orders
GROUP BY order_id
ORDER BY no_of_pizzas DESC
LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT new_customer_orders.customer_id,
	SUM(CASE
		WHEN CAST(new_customer_orders.exclusions AS UNSIGNED) IN (1,2,3,4,5,6,7,8,9,10,11,12) OR 
        CAST(new_customer_orders.extras AS UNSIGNED) IN (1,2,3,4,5,6,7,8,9,10,11,12) THEN 1 
        ELSE 0
        END) AS atleast_1_change,
	SUM(CASE
		WHEN CAST(new_customer_orders.exclusions AS UNSIGNED) = 0 AND
        CAST(new_customer_orders.extras AS UNSIGNED) = 0 THEN 1 
        ELSE 0
        END) AS no_change
FROM new_customer_orders
LEFT JOIN new_runner_orders
ON new_customer_orders.order_id=new_runner_orders.order_id
WHERE cancellation NOT LIKE "%cancellation%"
GROUP BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT SUM(CASE
		WHEN CAST(new_customer_orders.exclusions AS UNSIGNED) IN (1,2,3,4,5,6,7,8,9,10,11,12) AND
		CAST(new_customer_orders.extras AS UNSIGNED) IN (1,2,3,4,5,6,7,8,9,10,11,12) THEN 1 
        ELSE 0
        END) AS exclusions_and_extras
FROM new_customer_orders
LEFT JOIN new_runner_orders
ON new_customer_orders.order_id=new_runner_orders.order_id
WHERE cancellation NOT LIKE "%cancellation%";

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT DATE(order_time) AS order_date,
	   HOUR(order_time) AS order_hour,
       COUNT(order_id) AS no_of_pizzas_delivered
FROM new_customer_orders
GROUP BY order_time,order_id
ORDER BY order_time,order_id;

-- 10. What was the volume of orders for each day of the week?
SELECT  DAYNAME(DATE(order_time)) AS week_day,
        COUNT(order_id) AS no_of_pizzas_ordered
FROM new_customer_orders
GROUP BY 1;

-- B. Runner and Customer Experience

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT WEEK(registration_date) AS registration_week,
       COUNT(DISTINCT runner_id) AS no_of_runners
FROM runners
GROUP BY 1;
SELECT WEEK(registration_date) AS registration_week,
       MIN(DATE(registration_date)) date_start_of_week,
       COUNT(DISTINCT runner_id) AS no_of_runners
FROM runners
GROUP BY 1;

-- 2. What was the average distance travelled for each customer?
SELECT new_customer_orders.customer_id,
	ROUND(AVG(new_runner_orders.distance),2) AS avg_distance
FROM new_runner_orders 
LEFT JOIN new_customer_orders
ON new_customer_orders.order_id=new_runner_orders.order_id
WHERE distance!=0
GROUP BY 1
ORDER BY 1;

-- 3. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT runner_id,
	   ROUND(SUM(distance)/SUM(duration)*60,2) AS average_speed
FROM new_runner_orders
WHERE distance!=0
GROUP BY runner_id
ORDER BY runner_id;

-- 4. What is the successful delivery percentage for each runner?
SELECT runner_id,
	ROUND((SUM(CASE 
			  WHEN distance!=0 THEN 1
              ELSE 0
              END)/COUNT(order_id)*100),0) AS successful_delivery
FROM runner_orders
GROUP BY 1;