/*

SALES PERFORMANCE EVALUATION AT NORTHWIND TRADERS

USED: JOINS, AGGREGATE FUNCTIONS, DATE FUNCTIONS, STRING FUNCTIONS
	  
*/

--What is the annual sales?
SELECT
	ROUND(SUM((det.unitprice*det.quantity)*(1.0-det.discount)), 0)
FROM order_details AS det
LEFT JOIN orders AS ord
		ON det.orderid = ord.orderid
WHERE ord.orderdate BETWEEN '2014-01-01' AND '2014-12-31';
--The annual gross sales for 2014 is $617,085



--Who is the top performing sales representative?
SELECT
	emp.employeename
	, ROUND(SUM((det.unitprice*det.quantity)*(1.0-det.discount)), 0) AS total_sales
FROM order_details AS det
LEFT JOIN orders AS ord
		ON det.orderid = ord.orderid
LEFT JOIN employees AS emp
		ON ord.employeeid = emp.employeeid
WHERE DATE_PART('year', ord.orderdate) = 2014
	AND emp.title = 'Sales Representative'
GROUP BY emp.employeename
ORDER BY total_sales DESC;
--The top performing sales representative is Margaret Peacock with a total of $128,810 in annual sales. 



--Who is the most profitable customer?
SELECT
	cust.companyname
	, ROUND(SUM((det.unitprice*det.quantity)*(1.0-det.discount)), 0) AS total_sales
FROM order_details AS det
LEFT JOIN orders AS ord
		ON det.orderid = ord.orderid
LEFT JOIN customers AS cust
		ON ord.customerid = cust.customerid
WHERE ord.orderdate BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY cust.companyname
ORDER BY total_sales DESC;
--The most profitable customer is QUICK-Stop with $61,110 in annual sales. 




--What is the top selling product?
SELECT
	prod.productname
	, ROUND(SUM((det.unitprice*det.quantity)*(1.0-det.discount)), 0) AS total_sales
FROM order_details AS det
LEFT JOIN orders AS ord
		ON det.orderid = ord.orderid
LEFT JOIN products AS prod
		ON det.productid = prod.productid
WHERE ord.orderdate BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY prod.productname
ORDER BY total_sales DESC;
--The top selling product is the Cote de Blaye with $49,198 in annual sales. 

SELECT
	cat.categoryname
	, ROUND(SUM((det.unitprice*det.quantity)*(1.0-det.discount)), 0) AS total_sales
FROM order_details AS det
LEFT JOIN orders AS ord
		ON det.orderid = ord.orderid
LEFT JOIN products AS prod
		ON det.productid = prod.productid
LEFT JOIN categories AS cat
		ON cat.categoryid = prod.categoryid
WHERE ord.orderdate BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY cat.categoryname
ORDER BY total_sales DESC;
--The top selling category is Dairy Products with $115,388 in annual sales. 



--What is the most profitable region?
SELECT
	cust.country
	, ROUND(SUM((det.unitprice*det.quantity)*(1.0-det.discount)), 0) AS total_sales
FROM order_details AS det
LEFT JOIN orders AS ord
		ON det.orderid = ord.orderid
LEFT JOIN customers AS cust
		ON ord.customerid = cust.customerid
WHERE ord.orderdate BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY cust.country
ORDER BY total_sales DESC;
-- The most profitable country is Germany with $117,320 in annual sales. 



--Are there seasonality/trends with sales or volume of orders?
SELECT
	TO_CHAR(ord.orderdate, 'Month') AS month
	, ROUND(SUM((det.unitprice*det.quantity)*(1.0-det.discount)), 0) AS total_sales
FROM order_details AS det
LEFT JOIN orders AS ord
		ON det.orderid = ord.orderid
WHERE ord.orderdate BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY month
ORDER BY total_sales DESC;


SELECT
	TO_CHAR(ord.orderdate, 'Month') AS month
	, COUNT(DISTINCT ord.orderid) AS total_volume
FROM order_details AS det
LEFT JOIN orders AS ord
		ON det.orderid = ord.orderid
WHERE ord.orderdate BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY month
ORDER BY total_volume DESC;


		
		

	
