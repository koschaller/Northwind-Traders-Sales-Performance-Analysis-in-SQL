/*

Creating Sales and Performance Metrics for Sales Representatives at Northwind Traders

USED: Create Table, Views, CTEs, Aliases, ROUND(), JOINs, Aggregate Functions
	  
*/

--Create a CTE to display all employee and product details for each order
CREATE VIEW employee_stats AS
WITH revenue AS(
	SELECT 
	  d.orderid AS order_id
	, o.employeeid AS employee_id
	, e.employeename AS employee_name
	, o.customerid AS customer_id
	, d.productid AS product_id
	, d.unitprice AS unit_price
	, d.quantity AS unit_quantity
	, d.discount AS discount_rate
	, ROUND((d.unitprice*d.quantity)*(1.0-d.discount), 2) AS product_cost
	FROM order_details d
	JOIN orders o
		ON o.orderid = d.orderid
	JOIN employees e
		ON o.employeeid = e.employeeid
	WHERE o.orderdate BETWEEN '2013-12-31'
  		AND '2015-01-01'
)
--Use aggregations to calculate the total revenue and count of orders for each employee using the CTE above
SELECT 
      employee_name
	, SUM(product_cost) AS total_revenue
	, COUNT(DISTINCT(order_id)) AS total_order_count
	, COUNT(DISTINCT(customer_id)) AS count_of_customer_clients
FROM revenue
GROUP BY employee_name
ORDER BY total_revenue DESC



--Creating a view of only the CTE above
CREATE VIEW order_stats AS
SELECT 
	  d.orderid AS order_id
	, o.employeeid AS employee_id
	, e.employeename AS employee_name
	, o.customerid AS customer_id
	, d.productid AS product_id
	, d.unitprice AS unit_price
	, d.quantity AS unit_quantity
	, d.discount AS discount_rate
	, ROUND((d.unitprice*d.quantity)*(1.0-d.discount), 2) AS product_cost
	FROM order_details d
	JOIN orders o
		ON o.orderid = d.orderid
	JOIN employees e
		ON o.employeeid = e.employeeid
	WHERE o.orderdate BETWEEN '2013-12-31'
  		AND '2015-01-01'
		
		

--Calculating total revenue for each employee based on product and category
CREATE VIEW product_stats AS
SELECT c.categoryname, p.productid, os.employee_name, SUM(os.product_cost) total_revenue
FROM products p
JOIN categories c
	ON p.categoryid = c.categoryid
JOIN order_stats os
	ON os.product_id = p.productid
GROUP BY c.categoryname, p.productid, os.employee_name
ORDER BY c.categoryname, p.productid, SUM(os.product_cost) DESC



--Calulating revenue based on client details
CREATE VIEW company_stats AS
SELECT 
	  cu.companyname AS company_name
	, cu.country AS country
	, cu.city AS city
	, os.employee_name AS employee_name
	, SUM(os.product_cost) AS total_revenue
FROM customers cu
JOIN order_stats os
	ON cu.customerid = os.customer_id
GROUP BY cu.companyname
	, cu.country
	, cu.city
	, os.employee_name
ORDER BY cu.companyname
	, cu.country
	, cu.city
	, SUM(os.product_cost)
	
