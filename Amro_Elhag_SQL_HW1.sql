USE SAKILA;

-- 1a
SELECT first_name, last_name
FROM actor;

-- 1b
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM actor;

-- 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'JOE';

-- 2b
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan' , 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b
ALTER TABLE actor
DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(actor_id) AS 'number of actors'
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(actor_id) AS number_of_actors
FROM actor
GROUP BY last_name
HAVING number_of_actors >= 2;

-- 4c
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
LEFT JOIN address ON staff.address_id=address.address_id;

-- 6b
SELECT staff.first_name, staff.last_name,
COUNT(payment.payment_id) AS number_of_purchases, SUM(payment.amount) AS total_paid
FROM staff 
JOIN payment ON staff.staff_id=payment.staff_id
GROUP BY staff.staff_id;

-- 6c
SELECT film.title, COUNT(film_actor.actor_id) AS number_of_actors
FROM film
INNER JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.film_id;

-- 6d
SELECT film.title, COUNT(inventory.inventory_id) AS number_of_copies
FROM film
JOIN inventory ON film.film_id=inventory.film_id
WHERE film.title= 'HUNCHBACK IMPOSSIBLE'
GROUP BY film.film_id;

-- 6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS total_amount_paid
FROM payment
INNER JOIN customer ON payment.customer_id=customer.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

-- 7a
SELECT title, language_id FROM film
WHERE language_id IN(SELECT language_id FROM language WHERE language.name='English')
AND title LIKE 'k%' 
OR title LIKE'Q%';

-- 7b
SELECT first_name, last_name FROM actor
WHERE actor_id IN 
(SELECT actor_id FROM film_actor
WHERE film_id IN (SELECT film_id FROM film WHERE title='ALONE TRIP'));

-- 7c
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM (((country
JOIN city ON country.country_id=city.country_id)
JOIN address ON city.city_id=address.city_id)
JOIN customer ON address.address_id=customer.address_id)
WHERE country='Canada';

-- 7d
SELECT film.film_id, film.title
FROM ((category
JOIN film_category ON category.category_id= film_category.category_id)
JOIN film ON film_category.film_id=film.film_id)
WHERE name='family';

-- 7e
SELECT film.title, COUNT(rental.rental_id) AS number_of_rentals
FROM (rental 
LEFT JOIN inventory ON rental.inventory_id=inventory.inventory_id)
JOIN film ON film.film_id=inventory.film_id
GROUP BY film.title
ORDER BY number_of_rentals DESC;

-- 7f 
SELECT store.store_id, SUM(payment.amount) AS income
FROM store
JOIN payment ON store.manager_staff_id=payment.staff_id
GROUP BY store.store_id;

-- 7g
SELECT store.store_id, city.city, country.country
FROM (((country
JOIN city ON country.country_id=city.country_id)
JOIN address ON address.city_id=city.city_id)
JOIN store ON store.address_id=address.address_id);

-- 7h
SELECT category.name, SUM(payment.amount) AS total_profit
FROM ((((payment
JOIN rental ON payment.rental_id=rental.rental_id)
JOIN inventory ON inventory.inventory_id=rental.inventory_id)
JOIN film_category ON film_category.film_id=inventory.film_id)
JOIN category ON category.category_id=film_category.category_id)
GROUP BY category.name
ORDER BY total_profit DESC
LIMIT 5;

-- 8a
CREATE VIEW top_five_genres AS
SELECT category.name, SUM(payment.amount) AS total_profit
FROM ((((payment
JOIN rental ON payment.rental_id=rental.rental_id)
JOIN inventory ON inventory.inventory_id=rental.inventory_id)
JOIN film_category ON film_category.film_id=inventory.film_id)
JOIN category ON category.category_id=film_category.category_id)
GROUP BY category.name
ORDER BY total_profit DESC
LIMIT 5;

-- 8b
SELECT * FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;