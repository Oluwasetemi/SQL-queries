-- Gettting Started
USE sql_store;
-- Retireving Data From a Single Table 

-- SELECT first_name, last_name, points, (points * 10 + 100) AS discount
-- FROM sql_store.customers 
-- WHERE customer_id = 1 
-- ORDER BY first_name;

SELECT *
FROM customers;

-- Exercises Return all the products name, unit price new price(unit price * 1.1

SELECT name, unit_price, unit_price * 1.1 AS new_price
FROM products;

SELECT *
FROM customers
WHERE points > 400;

SELECT *
FROM customers
WHERE state != 'VA';

SELECT *
FROM customers
WHERE birth_date > '1991-01-01';

-- Exercise get the orders places this year
SELECT * 
FROM orders
WHERE order_date >= '2019-01-10';

SELECT *
FROM customers
WHERE NOT (birth_date > '1991-01-01' OR (points > 1000 AND state = 'VA'));

SELECT *
FROM customers
WHERE (birth_date <= '1991-01-01' AND (points <= 1000 OR state != 'VA'));

-- Exercise from the order_items table get the items from order #6 where the total prices is greater than 30
SELECT * 
FROM order_items 
WHERE order_id = 6 AND (unit_price * quantity ) > 30;

-- IN operators
SELECT *
FROM customers
WHERE state NOT IN ('VA', 'FL', 'GA');

-- Exercise Return the products with quantity in stock equal to 49, 38, 72
SELECT * 
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

-- BETWEEN operators
SELECT * 
FROM customers
WHERE NOT points BETWEEN 1000 AND 4000;

-- Exercises Return customers born between 1/1/1990 and 1/1/2000
SELECT * 
FROM customers
WHERE birth_date BETWEEN '1990/01/01' AND '2000/01/01';

-- The LIKE Operator
SELECT * 
FROM customers
WHERE last_name LIKE 'B____y';

-- Exercises get customers whose 
-- addresses contain TRAIL or AVENUE
SELECT * 
FROM customers
WHERE address LIKE '%trail%' OR 
	  address LIKE '%avenue%'; 
      
-- phone_number ends with 9
SELECT * 
FROM customers
WHERE phone LIKE '%9'; 

-- 1:02:31 The REGEXP Operator

SELECT * 
FROM customers
WHERE last_name REGEXP 'field$|mac|rose';

-- Exercises get the customer whose 
-- 		first_name are ELKA and AMBUR
SELECT *
FROM customers
WHERE first_name REGEXP 'ELKA|AMBUR';

-- 		last_name ends EY or ON
SELECT *
FROM customers
WHERE last_name REGEXP 'ON$|EY$';

-- 		last_name starts with OY and contains SE
SELECT *
FROM customers
WHERE last_name REGEXP '^MY|SE';


-- 		last_name contains B followed by R or U
SELECT *
FROM customers
WHERE last_name REGEXP 'br|bu';

-- 1:11:51 The IS NULL Operator
SELECT *
FROM customers
WHERE phone IS NULL;

-- Exercise get the orders that are not shipped
SELECT * 
FROM orders
WHERE shipper_id IS NULL;


-- 1:14:18 The ORDER BY Operator
SELECT first_name, last_name
FROM customers
ORDER BY birth_date;

-- Exercise: Sort the order_items table 
SELECT *
FROM order_items
WHERE order_id = 2
ORDER BY quantity * unit_price DESC;


-- 1:21:23 The LIMIT Operator
SELECT *
FROM customers
LIMIT 6, 4;

-- Exercise: get the top 3 loyal customers, more point
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

-- Retrieving Data From Multiple Tables

-- 1:24:50 Inner Joins
SELECT o.order_id, o.customer_id, first_name, last_name, oi.product_id, p.name
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_items oi
	ON oi.order_id = o.order_id
JOIN products p
	ON p.product_id = oi.order_id;
    
-- Exercise: Join the product table with the order_items
SELECT order_id, oi.product_id, name, quantity, quantity_in_stock
FROM order_items oi
JOIN products p
	ON oi.product_id = p.product_id;

-- 1:33:16 Joining Across Databases
USE sql_inventory;

SELECT order_id, oi.product_id, name, quantity, quantity_in_stock
FROM sql_store.order_items oi
JOIN products p
	ON oi.product_id = p.product_id;
    
-- 1:36:03 Self Joins
USE sql_hr;

SELECT *
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id;

-- 1:40:17 Joining Multiple Tables
use sql_store;

SELECT 
	o.order_id,
    o.shipped_date,
    c.first_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id;
    
-- Exercise: join the client, payment and payment method table together for 
-- reporting showing the name of the client and payment details and payment method

use sql_invoicing;
SELECT 
	c.name,
    c.address,
    p.payment_id,
    p.invoice_id,
    p.amount,
    pm.name AS payment_method,
    i.number,
    i.invoice_total,
    i.payment_total
FROM clients c
JOIN payments p
	ON c.client_id = p.client_id
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
JOIN invoices i
	ON p.invoice_id = i.invoice_id;


-- 1:47:03 Compound Join Conditions
USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;

-- 1:50:44 Implicit Join Syntax
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;

-- implicit join
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

-- 1:53:04 Outer Joins
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
RIGHT JOIN customers c
	ON o.customer_id = c.customer_id
ORDER BY o.customer_id;

-- all the orders whether they have customers
SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
ORDER BY o.customer_id;

-- Exercise  do an outer join of the product table with order
SELECT 
	p.product_id,
	p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON oi.product_id = p.product_id
ORDER BY p.product_id;

SELECT 
	p.product_id,
	p.name,
    oi.quantity
FROM order_items oi
RIGHT JOIN products p
	ON oi.product_id = p.product_id
ORDER BY p.product_id;

-- 1:59:31 Outer Join Between Multiple Tables 
SELECT 
    c.customer_id,
    order_id,
    first_name, 
    last_name,
    o.shipper_id,
    s.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers s
	ON o.shipper_id = s.shipper_id
ORDER BY o.customer_id;

-- Exercise Join the orders table with the customers and shippers showing order_date, order_id, first_name, shipper, status

SELECT 
	o.order_date,
    o.order_id,
    c.first_name,
    sh.name,
    os.name as status_name
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY order_id ASC;

-- 2:05:50 Self Outer Joins
USE sql_hr;

SELECT 
	e.id,
    e.name
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id;

-- 2:08:02 The USING Clause
USE sql_store;

SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
-- ON o.customer_id = c.customer_id
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);
    
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	USING (order_id, product_id);
    
-- Exercise: join the client, payment and payment method table together for 
-- reporting showing the name of the client and payment details and payment method

use sql_invoicing;
SELECT 
	c.name AS client,
    c.address,
    p.date,
    p.amount,
    pm.name AS payment_method
FROM clients c
JOIN payments p
	USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
JOIN invoices i
	ON p.invoice_id = i.invoice_id; 

-- 2:13:25 Natural Joins
USE sql_store;

SELECT
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;

-- 2:14:46 Cross Joins
USE sql_invoicing;

SELECT *
FROM clients c
CROSS JOIN payments p;

USE sql_store;

SELECT
	c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;

SELECT
	c.first_name AS customer,
    p.name AS product
FROM customers c, products p
ORDER BY c.first_name;

-- Exercise: DO a cross join between shippers and products


-- using implicit 
SELECT 
	sh.name AS shipper,
    p.name AS product
FROM shippers sh
CROSS JOIN products p;

-- using explicit
SELECT 
	sh.name AS shipper,
    p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

-- 2:18:01 Unions
USE sql_store;

SELECT 
	order_id,
    order_date,
	'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT 
	order_id,
    order_date,
	'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';

SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers;

-- Exercise: Write a query that returns customer_id, first_name, points type = less than 2000=Bronze, greater than 2000 and less than 3000 Silver, Above 3000 = Gold
SELECT 
	customer_id, 
    first_name, 
    points, 
	'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT 
	customer_id, 
    first_name, 
    points, 
	'Silver' AS type
FROM customers
WHERE points > 2000 AND points < 3000
UNION
SELECT 
	customer_id, 
    first_name, 
    points, 
	'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name ASC;


-- 2:26:29 Column Attributes

-- Inserting, Updating, and Deleting Data

-- 2:29:54 Inserting a Single Row 
INSERT INTO customers
VALUES (DEFAULT, 'John', 'Setemi', '1990-01-01', NULL, 'Surulere', 'Lagos', 'LG', 2900);

INSERT INTO customers (first_name, last_name, birth_date,  address, city, state, points)
VALUES ( 'John', 'Adewale', '1990-01-01', 'Surulere', 'Lagos', 'LG', 2900);
 
-- 2:35:40 Inserting Multiple Rows 
INSERT INTO shippers (name) 
VALUES ('Shippers1'), ('Shippers2'), ('Shippers');

-- Exercise Insert 3 rows into the product table
INSERT into products
VALUES (DEFAULT, 'soap', 10, 43.5), (DEFAULT, 'milk', 90, 44.5), (DEFAULT, 'rice', 80, 45.5);

-- 2:38:58 Inserting Hierarchical Rows 
INSERT INTO orders (customer_id, status, order_date)
VALUES (12, 1, '1990-10-1');

SELECT last_insert_id();

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 13, 2, 45.50), (LAST_INSERT_ID(), 12, 2, 44.50), (LAST_INSERT_ID(), 11, 2, 43.50);

-- 2:44:51 Creating a Copy of a Table users
CREATE TABLE orders_archived AS 
SELECT * FROM orders;

-- Using subquery

INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01';

-- Exercise: Create an invoice archived table where you archive the invoices that have a payment data showing the client name;
USE sql_invoicing;

CREATE TABLE invoicing_archive
SELECT 
	i.invoice_id,
    i.number,
    c.name AS client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.payment_date
FROM invoices i
JOIN clients c
	USING (client_id)
WHERE payment_date IS NOT NULL;

-- 2:53:38 Updating a Single Row 
UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE invoice_id = 3;

-- 2:57:33 Updating Multiple Rows 
USE sql_invoicing;
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id = 3;

USE sql_invoicing;
UPDATE invoices
SET 
	payment_total = invoice_total * 0.7, payment_date = due_date
WHERE client_id IN (3, 4);

-- Exercise: Write a SQL statement to give any customer born before 1990 -50 extra point
USE sql_store;
UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

-- 3:00:47 Using Subqueries in Updates 
USE sql_invoicing;
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id IN 
			(SELECT client_id
			FROM clients
			WHERE state IN ('CA', 'NY'));
            
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5, payment_date = due_date
WHERE payment_date IS NULL;

-- Exercise: Update the comment of customers orders who have a point of Gold(point is greater than 3000)
USE sql_store;
UPDATE orders
SET comments = 'Gold customer'
WHERE customer_id IN (
			SELECT customer_id 
			FROM customers
			WHERE points > 3000);
-- 3:06:24 Deleting Rows
USE sql_invoicing;

DELETE FROM invoices
WHERE client_id = (
				SELECT client_id 
				FROM clients
				WHERE name = 'Myworks');


-- 3:07:48 Restoring Course Databases

-- Summarizing Data

-- Aggregate Functions
use sql_invoicing;

SELECT 
	MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total) AS total,
    COUNT(invoice_total) AS number_of_invoices,
    COUNT(DISTINCT client_id) AS total_records
FROM invoices
WHERE invoice_date > '2019-07-01';

-- Exercise
-- Write an sql aggregate to find the date_range, total_sales, total_payments and what_to_expect for the First half of 2019, Second half of 2019, and total;
-- Solution

SELECT 
	'First half of 2019' AS data_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS 'what_to_expect'
from invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT 
	'Second half of 2019' AS data_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS 'what_to_expect'
from invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT 
	'Total' AS data_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS 'what_to_expect'
from invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31';


-- The GROUPBY Clause
SELECT 
    state,
    city,
	SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients USING (client_id)
GROUP BY state, city;

-- Exercise
-- GROUP By multiple columns - payment_method, date calculate total_payment using the payment table

SELECT 
	p.date AS date,
    pm.name AS payment_method,
    SUM(p.amount) AS total_payments
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY date, payment_method
ORDER BY date;

-- The HAVING Clause

SELECT 
	client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING 
	total_sales > 500 AND number_of_invoices > 5;

-- Difference btw WHERE and HAVING clause (before clause to filter data before group our rows and having clause after grouping our rows) - support compound state and the field must be available in the slect clause
-- Exercises
-- Get customers located in virgina who have spent more than $100

USE sql_store;

SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity*oi.unit_price) AS total_sales
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING(order_id)
WHERE state = 'VA'
GROUP BY c.customer_id,
    c.first_name,
    c.last_name
HAVING total_sales > 100;

-- The ROLLUP Operator
USE sql_invoicing;

SELECT 
	city,
    state,
    SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING (client_id)
GROUP BY city, state WITH ROLLUP;

-- Exercises 
-- Write a query to product a payment_method report

SELECT 
	pm.name,
	SUM(amount) as total
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY name WITH ROLLUP;

-- Writing Complex Query

-- Subqueries 
USE sql_hr;
USE sql_inventory;
USE sql_invoicing;
USE sql_store;

SELECT 
	*
FROM products
WHERE unit_price > (
	SELECT unit_price
    FROM products
    WHERE product_id = 3
);

-- Exercise
-- sql_hr - find employee who earns more than average.
USE sql_hr;

SELECT 
	* 
FROM employees
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
);

-- The IN Operator 
USE sql_store;

SELECT 
	*
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id
	FROM order_items 
);

-- Exercise
-- In the sql_invoicing db find clients without invoicing
USE sql_invoicing;

SELECT 
	*
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
    FROM invoices
);

-- Subqueries vs Joins 

SELECT 
	*
FROM clients
LEFT JOIN invoices using (client_id)
WHERE invoice_id IS NULL;

-- Exercise 
-- Find customers who have ordered lettuce (id = 3)
-- Select customer_id, first_name, last_name
USE sql_store;

SELECT 
	customer_id,
    first_name,
    last_name
FROM customers
WHERE customer_id IN (
	SELECT customer_id 
	FROM orders
	WHERE order_id IN (
		SELECT 
			order_id
		FROM order_items
		WHERE product_id = 3
	)
);

SELECT 
	customer_id,
    first_name,
    last_name
FROM customers
WHERE customer_id IN (
	SELECT o.customer_id 
	FROM order_items oi
    LEFT JOIN orders o USING (order_id)
		WHERE product_id = 3
);

SELECT 
	DISTINCT customer_id,
    first_name,
    last_name
FROM order_items
LEFT JOIN orders USING (order_id)
LEFT JOIN customers USING (customer_id)
WHERE product_id = 3;


-- The ALL Keyword 
USE sql_invoicing;

SELECT *
FROM invoices
WHERE invoice_total > (
	SELECT 
		MAX(invoice_total)
	FROM invoices
	WHERE client_id = 3
);

SELECT *
FROM invoices
WHERE invoice_total > ALL (
	SELECT 
		invoice_total
	FROM invoices
	WHERE client_id = 3
);

-- The ANY Keyword or SOME
-- = ANY is equal to IN operator 

SELECT * 
FROM clients
WHERE client_id IN (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
    HAVING COUNT(*) >= 2
);

SELECT * 
FROM clients
WHERE client_id = ANY (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
    HAVING COUNT(*) >= 2
);

-- Correlated Subqueries 
USE sql_hr;

-- for each employee
-- 		calculate the avg salary for employee.office
-- 		return the employee if salary > avg

SELECT AVG(salary)
FROM employees;


SELECT *
FROM EMPLOYEES e
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id
);

-- Exercises
-- Get the invoice that are larger than the client's average invoice

USE sql_invoicing;

SELECT * 
FROM invoices i
WHERE invoice_total > (
	SELECT AVG(invoice_total)
    FROM invoices
    WHERE client_id = i.client_id
);

-- The EXISTS Operator 
-- SELECT clients that have an invoice
-- 3 methods IN, JOIN, EXIST operator

SELECT * 
FROM clients
WHERE client_id IN (
	SELECT client_id
    FROM invoices
);

SELECT * 
FROM clients c
WHERE EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
);

-- Exercies
-- Find the products that have never been ordered

USE sql_store;
-- USING IN 

SELECT * 
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT(product_id)
    FROM order_items
);

SELECT * 
FROM products p
WHERE NOT EXISTS (
	SELECT product_id
    FROM order_items
    WHERE product_id = p.product_id
);



-- Subqueries in the SELECT Clause 
USE sql_invoicing;

SELECT 
	invoice_id, 
    invoice_total, 
    (SELECT AVG(invoice_total) FROM invoices) AS average, 
    invoice_total - (SELECT average) AS difference
FROM invoices;

-- Exercise 
-- Write a query to find total_sales by each client, average, difference

SELECT 
	client_id,
    (SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
    (SELECT AVG(invoice_total) FROM invoices) AS average,
    (SELECT total_sales - average) AS difference
FROM clients c;


-- Subqueries in the FROM Clause 
SELECT * 
FROM (
	SELECT 
		client_id,
		(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
		(SELECT AVG(invoice_total) FROM invoices) AS average,
		(SELECT total_sales - average) AS difference
	FROM clients c
) as sales_summary
WHERE total_sales IS NOT NULL;

-- view can replace complex subqueries in the from clause



-- Essential MySQL Functions (00:33)
 -- Numeric Functions (2:54) https://dev.mysql.com/doc/refman/8.0/en/numeric-functions.html
 -- round, ceil, floor, abs, rand
 
 SELECT date_format(NOW(), '%m %d %y');
 
 -- String Functions (5:47) https://dev.mysql.com/doc/refman/8.0/en/string-functions.html
 -- length, trim, left, upper, rtrim, trim, right, lower, substring, locate, replace, concat
 
 -- Date Functions in MySQL (4:08) https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html
 -- now, curdate, curtime, year, dayname, monthname, extract
 
 SELECT *
 FROM orders
 WHERE YEAR(order_date) >= YEAR(NOW());
 
 -- Formatting Dates and Times (2:14) https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html
 -- date_format, time_format, 
 
 -- Calculating Dates and Times (3:08) https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html
 -- date_add, date_sub, datediff, time_to_sec, from_days() 
 
 -- The IFNULL and COALESCE Functions (3:29)
 
 USE sql_store;
 
 SELECT 
	order_id,
    -- IFNULL(shipper_id, 'No shipper') AS shipper
    COALESCE(shipper_id, comments, 'no shipper') AS shipper
FROM orders;

-- Exercise 
USE sql_store;

SELECT 
	CONCAT(first_name, ' ', last_name) AS customer, 
    IFNULL(phone, 'unknown') AS phone 
FROM sql_store.customers;

 -- The IF Function (4:54)
SELECT
	order_id,
    order_date,
    IF (
		YEAR(order_date) = YEAR(NOW()),
        'Active',
        'Archived') AS category
FROM orders;

-- Exercise 
-- Write a query to produce product_id, name, order, frequency from orders table

SELECT 
	product_id,
    name,
    COUNT(*) AS orders,
    IF (COUNT(*) > 1, 'Many times', 'Once') AS frequency
FROM products
JOIN order_items USING (product_id)
GROUP BY product_id, name;

 
 -- The CASE Operator (5:23)
 SELECT
	order_id,
    order_date,
    CASE
		WHEN YEAR(order_date) = YEAR(NOW()) THEN 'Active'
        WHEN YEAR(order_date) = YEAR(NOW()) - 3 THEN 'Last Year'
        WHEN YEAR(order_date) = YEAR(NOW()) - 4 THEN 'Archived'
        ELSE 'Future'
	END AS category
FROM orders;

-- Exercise: Write a query that returns customer_id, first_name, 
-- points type = less than 2000=Bronze, 
-- greater than 2000 and less than 3000 Silver, 
-- Above 3000 = Gold

SELECT 
	CONCAT(first_name, ' ', last_name) AS customer, 
    points,
    CASE
		WHEN points < 2000 THEN 'Bronze'
        WHEN points > 2000 AND points < 3000 THEN 'Silver'
        WHEN points > 3000 THEN 'Gold'
	END as category
FROM customers
ORDER BY points DESC;
 
 
-- Views (00:18)
 -- Start1- Creating Views (5:36)
 USE sql_invoicing;
 
 CREATE VIEW sales_by_client AS
 SELECT 
	client_id,
    name,
    SUM(invoice_total) AS total_sales
 FROM clients c
 JOIN invoices i USING (client_id)
 GROUP BY client_id, name; 
 
 -- Exercise 
 -- CCreate a view to calculate the balance for each client with client_id, name, balance(payment-total - invoice_total)
 CREATE OR REPLACE VIEW client_balance AS
 SELECT 
	c.client_id,
    c.name,
    SUM(invoice_total-payment_total) AS balance
 FROM clients c
 JOIN invoices i USING (client_id)
 GROUP BY client_id, name;

 -- Start2- Altering or Dropping Views (2:52)
 
 DROP VIEW view_name;
 -- Start3- Updatable Views (5:12)
 SELECT * FROM sql_invoicing.invoices_with_balance;

DELETE FROM invoices_with_balance
WHERE invoice_id = 1;

UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;

UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 3;
 -- Start4- THE WITH OPTION CHECK Clause (2:18)
 USE sql_invoicing;

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
	invoice_id, number, invoice_total, payment_total, due_date, payment_date,
    (invoice_total - payment_total) AS balance
FROM invoices
WHERE (invoice_total - payment_total) > 0
WITH CHECK OPTION;
 -- Start5- Other Benefits of Views (2:37)
 
 

-- Stored Procedures (00:48)
 -- Start1- What are Stored Procedures (2:18)
 
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT *
	FROM clients;
END$$

DELIMITER ;


 
 -- Start2- Creating a Stored Procedure (5:34)
 USE sql_invoicing;
 
 call get_clients();
 
 -- Exercise 
 -- Create a stored procedure called 
	-- get_invoices_with_balance
    -- to return all the invoices with a balance > 0;
    
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN 
	SELECT 
		invoice_id, number, client_id, invoice_total, payment_total, (invoice_total - payment_total) AS balamce, invoice_date, due_date, payment_date
	FROM invoices;
END $$
DELIMITER ;
 
 -- Start3- Creating Procedures Using MySQLWorkbench (1:21)
 
 -- Start4- Dropping Stored Procedures (2:09)
 DROP PROCEDURE IF EXISTS get_clients;
 -- Start5- Parameters (5:26)
 
 DELIMITER $$
CREATE PROCEDURE get_clients_by_state(
	state CHAR(2)
)
BEGIN
	SELECT *
	FROM clients c
    WHERE c.state = state;
END$$

DELIMITER ;

-- Exercise
-- Write a stored procedure to return invoices
	-- for a given client
    --
    -- get_invoices_by_client
    
DELIMITER $$
CREATE PROCEDURE get_invoices_by_client(
	client_id INT
)
BEGIN
	SELECT *
	FROM invoices i
    WHERE i.client_id = client_id;
END$$

DELIMITER ;
 
 -- Start6- Parameters with Default Value (8:18)
 
  DELIMITER $$
CREATE PROCEDURE get_clients_by_state_default(
	state CHAR(2)
)
BEGIN
	IF state IS NULL THEN
		SELECT * 
        FROM clients;
	ELSE
		SELECT *
		FROM clients c
		WHERE c.state = state;
	END IF;
END$$

DELIMITER ;

 -- Start7- Parameter Validation (6:40)
 -- with SIGNAL ERROR message
DELIMITER $$ 
CREATE PROCEDURE `make_payment`(
	invoice_id INT,
    payment_amount DECIMAL(9, 2),
    payment_date DATE
)
BEGIN

	IF payment_amount <= 0 THEN
		SIGNAL SQLSTATE '22003'
			SET MESSAGE_TEXT = 'Invalid payment amount';
	END IF;
    
	UPDATE invoices i
    SET 
		i.payment_total = payment_amount,
        i.payment_date = payment_date
	WHERE i.invoice_id = invoice_id;
END $$
DELIMITER ;

 -- Start8- Output Parameters (3:55)
 
 DELIMITER $$
 CREATE PROCEDURE `get_unpaid_invoices_for_client`(
	client_id INT,
    OUT invoices_count INT,
    OUT invoices_total DECIMAL(9, 2)
    
)
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id AND payment_total = 0;
END $$
DELIMITER ;
 
 -- Start9- Variables (4:33)
 -- User or session variables
set @invoices_count = 0;
set @invoices_total = 0;
call sql_invoicing.get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);
select @invoices_count, @invoices_total;

call sql_invoicing.get_risk_factor();

-- Local variables
-- DECLARE KEYWORD within a procedure
 
 -- Start10- Functions (6:28)
 
-- creating user defined functions, difference btw functions and stored procedure is that fxn can return only a single value;

DELIMITER $$
CREATE FUNCTION `get_risk_factor_for_client`(
	client_id INT
) RETURNS int
    READS SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
	DECLARE invoices_total DECIMAL(9, 2);
	DECLARE invoices_count INT;

	SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id;
	
    SET risk_factor = invoices_total / invoices_count * 5;

	RETURN IFNULL(risk_factor, 0);
END $$
DELIMITER ;

SELECT 
	client_id,
	name,
    get_risk_factor_for_client(client_id) AS risk_factor
FROM clients;

-- DROP FUNCTION IF EXISTS get_risk_factor_for_client;
 
 -- Start11- Other Conventions (1:51)
 

-- Start1- Triggers (7:31)
DELIMITER $$

CREATE TRIGGER payments_after_insert 
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END $$
DELIMITER ;

-- Exercise
-- Create a trigger when we dalete a payment

DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_delete;

CREATE TRIGGER payments_after_delete 
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW());
END $$
DELIMITER ;

-- Start2- Viewing Triggers (1:20)
SHOW TRIGGERS;
SHOW TRIGGERS LIKE 'payments%';
-- Start3- Dropping Triggers (0:52)
DROP TRIGGER IF EXISTS payments_after_insert;

-- Start4- Using Triggers for Auditing (4:52)
USE sql_invoicing;

CREATE TABLE payments_audit (
	client_id INT NOT NULL AUTO_INCREMENT,
    date DATE NOT NULL,
    amount DECIMAL(9, 2) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL,
    PRIMARY KEY (client_id)
);

DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_insert;

CREATE TRIGGER payments_after_insert 
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW());
    
END $$
DELIMITER ;

-- Start5- Events (4:33)

SHOW VARIABLES;

SHOW VARIABLES LIKE 'event%';

DELIMITER $$

CREATE EVENT yearly_delete_state_audit_rows
ON SCHEDULE
	-- AT '2019-05-01'
    EVERY 1 YEAR STARTS '2021-11-12' ENDS '2029-01-01'
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
    
END $$
DELIMITER ;


-- Start6- Viewing, Dropping and Altering Events (2:04)
SHOW EVENTS;

SHOW EVENTS LIKE 'yearly%';

DROP EVENT IF EXISTS yearly_delete_state_audit_rows;

DELIMITER $$

ALTER EVENT yearly_delete_state_audit_rows
ON SCHEDULE
	-- AT '2019-05-01'
    EVERY 1 YEAR STARTS '2021-11-12' ENDS '2029-01-01'
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
    
END $$
DELIMITER ;

ALTER EVENT yearly_delete_state_audit_rows DISABLE;

ALTER EVENT yearly_delete_state_audit_rows ENABLE;


-- Transactions and Concurrency (00:49) Atomicity Consitency Isolation Durability
USE sql_store;

SELECT *
FROM orders;

START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status)
VALUE (1, '2019-01-01', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1);

COMMIT; -- ROLLBACK

SHOW VARIABLES LIKE 'autocommit';

-- Start1- Transactions (2:44)
-- Start2- Creating Transactions (5:11)
-- Start3- Concurrency and Locking (4:07)

START TRANSACTION;
UPDATE customers
SET points = points + 10
WHERE customer_id = 1;
COMMIT;
-- Start4- Concurrency Problems (7:25) 
-- Lost updates, Dirty Reads, Non-repeating Reads, Phantom reads.

-- Start5- Transaction Isolation Levels (5:42)
SHOW VARIABLES LIKE 'transaction_isolation'; 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE ; 
-- SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;  
-- Start6- READ UNCOMMITTED Isolation Level (3:26)
USE sql_store;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT points
FROM customers
WHERE customer_id = 1;

-- Start7- READ COMMITTED Isolation Level (3:01)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT points
FROM customers
WHERE customer_id = 1;

SELECT points
FROM customers
WHERE customer_id = 1;

COMMIT;

-- Start8- REPEATABLE READ Isolation Level (3:29)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

SELECT points
FROM customers
WHERE customer_id = 1;

SELECT points
FROM customers
WHERE customer_id = 1;

COMMIT;

START TRANSACTION;

SELECT * FROM customers WHERE state = 'VA';

COMMIT;
-- Start9- SERIALIZABLE Isolation Level (2:18)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

SELECT * FROM customers WHERE state = 'VA';

COMMIT;
-- Start10- Deadlocks (6:11)
START TRANSACTION;
UPDATE customers SET state = 'VA' WHERE customer_id = 1;
UPDATE orders SET status = 1 WHERE order_id = 1;
COMMIT;
			

/*
Data Types (00:35)
 Start1- Introduction (0:43)
 Start2- String Types (2:25)
 Start3- Integer Types (2:52)
 Start4- Fixed-point and Floating-point Types (1:42)
 Start5- Boolean Types (0:46)
 Start6- Enum and Set Types (3:36)
 Start7- Date and Time Types (0:44)
 Start8- Blob Types (1:17)
 Start9- JSON Type (10:24)
 */
 
SELECT product_id, JSON_EXTRACT(properties, '$.manufacturer') FROM sql_store.products WHERE product_id = 3;

SELECT * FROM products;

-- ->> column pass operator
SELECT product_id, properties -> '$.manufacturer' FROM sql_store.products WHERE product_id = 3;

UPDATE products
SET properties = '
{
	"dimensions": [1,2,4],
    "weight": 10,
    "manufacturer": {"name": "sony"}
}
'
WHERE product_id = 1;

UPDATE products
SET properties = JSON_OBJECT(
	'weight', 10,
    'dimensions', JSON_ARRAY(1, 2, 3),
    'manufacturer', JSON_OBJECT('name', 'sony')
)
WHERE product_id = 3;

UPDATE products
SET properties = JSON_SET(
	properties,
	'$.weight', 20,
    '$.age', 99,
    '$.manufacturer.name', 'lg'
)
WHERE product_id = 3;

UPDATE products
SET properties = JSON_REMOVE(
	properties,
	'$.weight'
)
WHERE product_id = 3;
 
 /*
Designing Databases (01:30)
 Start1- Introduction (1:25)
 Start2- Data Modelling (2:26)
 Start3- Conceptual Models (4:34)
 Start4- Logical Models (7:24)
 Start5- Physical Models (6:27)
 Start6- Primary Keys (3:23)
 Start7- Foreign Keys (5:48)
 Start8- Foreign Key Constraints (5:22) 
 Start9- Normalization (1:24)
 Start10- 1NF- First Normal Form (2:42)
 Start11- Link Tables (4:01)
 Start12- 2NF- Second Normal Form (6:32)
 Start13- 3NF- Third Normal Form (1:43)
 Start14- My Pragmatic Advice (2:55)
 Start15- Dont Model the Universe (4:24)
 Start16- Forward Engineering a Model (2:35)
 Start17- Synchronizing a Model with a Database (4:48)
 Start18- Reverse Engineering a Database (3:11)
 
 Start19- Project- Flight Booking System (0:23)
 Start20- Solution- Conceptual Model (7:59)
 Start21- Solution- Logical Model (9:03)
 
 Start22- Project - Video Rental Application (1:05)
 Start23- Solution- Conceptual Model (6:59)
 Start24- Solution- Logical Model (8:29)
 */
 
 
 -- Start25- Creating and Dropping Databases (1:41)
 
 CREATE DATABASE IF NOT EXISTS sql_store2;
 
 DROP DATABASE IF EXISTS sql_store2;
 
 -- Start26- Creating Tables (3:13)
 USE sql_store2;
 DROP TABLE IF EXISTS customers;
 CREATE TABLE IF NOT EXISTS customers (
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    email VARCHAR(255) NOT NULL UNIQUE
 );
 
 -- Start27- Altering Tables (2:56)
 ALTER TABLE customers
	ADD last_name VARCHAR(55) NOT NULL AFTER first_name,
    ADD city VARCHAR(50) NOT NULL,
    MODIFY COLUMN first_name VARCHAR(55) DEFAULT '';
 -- Start28- Creating Relationships (4:47)
 DROP TABLE IF EXISTS orders;
 CREATE TABLE IF NOT EXISTS orders (
	order_id INT PRIMARY kEY,
    customer_id INT NOT NULL,
    FOREIGN KEY fk_orders_customers (customer_id) 
		REFERENCES customers (customer_id) 
        ON UPDATE CASCADE 
        ON DELETE NO ACTION
 );
 -- Start29- Altering Primary and Foreign Key Constraints (2:10)
 ALTER TABLE orders
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (order_id),
    DROP FOREIGN KEY fk_orders_customers,
    ADD FOREIGN KEY fk_orders_customers (customer_id)
		REFERENCES customers (customer_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION;
 -- Start30- Character Sets and Collations (6:29)
 SHOW CHARSET;
 
 CREATE DATABASE name
	CHARACTER SET latin1;
    
 ALTER DATABASE name
	CHARACTER SET latin1;

-- we can set the CHARACTER SET at column level either when creating or altering a table column
 -- Start31- Storage Engines (2:27)
 SHOW ENGINES;
 -- set storage enginees at table level
 ALTER TABLE customers
	  ENGINE=InnoDB;

 
 /*
Indexing for High Performance (00:58)
 Start1- Introduction (0:41)
 Start2- Indexes (2:49)
 Start3- Creating Indexes (5:00)
 Start4- Viewing Indexes (3:19)
 Start5- Prefix Indexes (3:40)
 Start6- Full-text Indexes (7:50)
 Start7- Composite Indexes (5:12)
 Start8- Order of Columns in Composite Indexes (9:16)
 Start9- When Indexes are Ignored (5:03)
 Start10- Using Indexes for Sorting (7:02)
 Start11- Covering Indexese (1:58)
 Start12- Index Maintenance (1:25)
 Start13- Performance Best Practices
 
Securing Databases (00:20)
 Start1- Introduction (0:33)
 Start2- Creating a User (3:12)
 Start3- Viewing Users (1:29)
 Start4- Dropping Users (0:48)
 Start5- Changing Passwords (1:06)
 Start6- Granting Privileges (4:53)
 Start7- Viewing Privileges (1:34)
 Start8- Revoking Privileges (1:20)
 Start9- Wrap Up (0:44)
*/









