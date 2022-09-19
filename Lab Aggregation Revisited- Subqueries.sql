#1. Select the first name, last name, and email address of all the customers who have rented a movie.
use sakila;

SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email
FROM
    customer
        JOIN
    rental USING (customer_id)
WHERE
    rental_id <> ' ' AND rental_id <> ''
GROUP BY customer_name;

#2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT 
    CONCAT(customer_id,
            ' ',
            first_name,
            ' ',
            last_name) AS customer_id_name,
    ROUND(AVG(amount), 2) AS average_payment
FROM
    customer
        JOIN
    payment USING (customer_id)
GROUP BY customer_id_name;

#3. Select the name and email address of all the customers who have rented the "Action" movies.
# 3.1 Write the query using multiple join statements


CREATE OR REPLACE VIEW customers_rented_action_joins AS
    SELECT 
        CONCAT(first_name, ' ', last_name) AS customer_name, email
    FROM
        customer
            JOIN
        rental USING (customer_id)
            JOIN
        inventory USING (inventory_id)
            JOIN
        film_category USING (film_id)
            JOIN
        category USING (category_id)
    WHERE
        name = 'Action'
    GROUP BY customer_name;

SELECT 
    *
FROM
    customers_rented_action_joins;

#3.2 Write the query using sub queries with multiple WHERE clause and IN condition
CREATE OR REPLACE VIEW customers_rented_action_subquery AS
    SELECT 
        CONCAT(first_name, ' ', last_name) AS customer_name, email
    FROM
        customer
    WHERE
        customer_id IN (SELECT 
                customer_id
            FROM
                rental
            WHERE
                inventory_id IN (SELECT 
                        inventory_id
                    FROM
                        inventory
                    WHERE
                        film_id IN (SELECT 
                                film_id
                            FROM
                                film_category
                            WHERE
                                category_id IN (SELECT 
                                        category_id
                                    FROM
                                        category
                                    WHERE
                                        name = 'Action'))));

SELECT 
    *
FROM
    customers_rented_action_subquery;

#3.3 Verify if the above two queries produce the same results or not
# in order to verify both the views have been compared. 
SELECT 
    *
FROM
    customers_rented_action_joins
WHERE
    customer_name NOT IN (SELECT 
            customer_name
        FROM
            customers_rented_action_subquery); -- executing query return empty columns which shows that results from both queries are same. 

# 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
# If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

SELECT 
    *,
    (CASE
        WHEN amount > 4 THEN 'high'
        WHEN amount BETWEEN 2 AND 4 THEN 'medium'
        ELSE 'low'
    END) AS 'classification'
FROM
    payment;














