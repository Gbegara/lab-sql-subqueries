use sakila;


-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?


SELECT f.title, COUNT(i.inventory_id) as Number_of_films
FROM inventory i
JOIN film f
USING (film_id)
WHERE f.title LIKE 'Hunchback Impossible';




-- 2. List all films whose length is longer than the average of all the films.

SELECT * 
FROM film 
WHERE length > (
SELECT avg(length) as avg_length 
FROM film);


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT CONCAT(first_name,' ', last_name) AS Actors
FROM film_actor
JOIN actor
USING (actor_id) 
WHERE film_id LIKE (
SELECT film_id 
FROM film
WHERE title LIKE 'Alone Trip');


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title as Fam_Films
FROM film_category
JOIN film
USING (film_id) 
WHERE category_id LIKE (
SELECT category_id 
FROM category
WHERE name LIKE 'family');



-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
	-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- Using subqueries  
SELECT email as Customers_from_Canada
FROM customer
	WHERE address_id in 
(SELECT address_id
FROM address
WHERE city_id in (SELECT city_id
FROM city
WHERE country_id in (SELECT country_id
FROM country
WHERE country = 'Canada')));


-- Using joins
SELECT email as Customers_from_Canada
FROM customer
JOIN address
USING (address_id) 
JOIN city
USING (city_id)
JOIN country
USING (country_id)
WHERE country.country LIKE 'Canada';
    
    
-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
	-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT *
FROM film_actor;

SELECT *
FROM film;

CREATE TEMPORARY TABLE prolific_actor AS 
(SELECT actor_id, count(*) as number_of_movies 
FROM film_actor 
GROUP BY actor_id 
ORDER BY number_of_movies DESC
LIMIT 1
);

SELECT title FROM film_actor 
JOIN film USING(film_id)
WHERE actor_id = (SELECT actor_id FROM prolific_actor);

    
    
    
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select * 
from payment;
CREATE TEMPORARY TABLE best_customer AS 
(SELECT customer_id, sum(amount) as amount_spent 
FROM payment 
GROUP BY customer_id 
ORDER BY amount_spent DESC
LIMIT 1
);

SELECT title as films_rented_bestcustomer FROM rental
JOIN inventory 
USING (inventory_id)
JOIN film 
USING (film_id)
WHERE customer_id = (SELECT customer_id FROM best_customer);



-- 8. Customers who spent more than the average payments.
select *
from customer;
CREATE TEMPORARY TABLE best_customers AS 
(SELECT customer_id, sum(amount) as total_payments
FROM payment
GROUP BY customer_id
HAVING total_payments >
    (
    SELECT avg(payment_sum) as avg_sum FROM (
	SELECT customer_id, sum(amount) as payment_sum FROM payment
	GROUP BY customer_id
	) avg_table
    )
ORDER BY total_payments DESC);

SELECT concat(first_name, ' ' , last_name) as Customer_Above_AvgSpent
FROM best_customers
JOIN customer USING(customer_id);





