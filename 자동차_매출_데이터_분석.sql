SELECT A.orderDate, sum(priceEach*quantityOrdered) as Sales
FROM classicmodels.orders A
LEFT JOIN classicmodels.orderdetails B
ON A.orderNumber = B.orderNumber
GROUP BY orderDate;

SELECT substr(A.orderDate,1,7) FROM classicmodels.orders A;

SELECT substr(A.orderDate,1,7) as Month_data, sum(priceEach*quantityOrdered) as Sales
FROM classicmodels.orders A
LEFT JOIN classicmodels.orderdetails B
ON A.orderNumber = B.orderNumber
GROUP BY substr(A.orderDate,1,7);

SELECT substr(A.orderDate,1,4)
FROM classicmodels.orders A;

SELECT substr(A.orderDate,1,4) as Month_data, sum(priceEach*quantityOrdered) as Sales
FROM classicmodels.orders A
LEFT JOIN classicmodels.orderdetails B
ON A.orderNumber = B.orderNumber
GROUP BY substr(A.orderDate,1,4);

SELECT orderDate, count(distinct customerNumber) as customer_orders, count(orderNumber) as orders_total
FROM classicmodels.orders
GROUP BY 1;

SELECT substr(orderDate,1,7), count(distinct customerNumber) as customer_orders, count(orderNumber) as orders_total
FROM classicmodels.orders
GROUP BY 1;

SELECT substr(orderDate,1,4), count(distinct customerNumber) as customer_orders, count(orderNumber) as orders_total
FROM classicmodels.orders
GROUP BY 1;

SELECT substr(A.orderDate,1,7) as MM, count(distinct customerNumber) as customer_orders, sum(priceEach*quantityOrdered) as Sales, 
sum(priceEach*quantityOrdered)/count(distinct customerNumber) as AMV
FROM classicmodels.orders A
LEFT JOIN classicmodels.orderdetails B
ON A.orderNumber = B.orderNumber
GROUP BY 1;

SELECT substr(A.orderDate,1,7) as MM,count(distinct A.orderNumber) as orders_total, sum(priceEach*quantityOrdered) as Sales, 
sum(priceEach*quantityOrdered)/count(distinct A.orderNumber) as ATV
FROM classicmodels.orders A
LEFT JOIN classicmodels.orderdetails B
ON A.orderNumber = B.orderNumber
GROUP BY 1;

SELECT C.country, C.city, sum(priceEach*quantityOrdered) as Sales
FROM classicmodels.orders A
LEFT JOIN classicmodels.orderdetails B
ON A.orderNumber = B.orderNumber
LEFT JOIN classicmodels.customers C
ON A.customerNumber = C.customerNumber
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT CASE WHEN country IN ('USA', 'Canada') 
	   THEN 'North America'
       ELSE 'Others' END,
	   sum(priceEach*quantityOrdered) as Sales
FROM classicmodels.orders A
LEFT JOIN classicmodels.orderdetails B
ON A.orderNumber = B.orderNumber
LEFT JOIN classicmodels.customers C
ON A.customerNumber = C.customerNumber
GROUP BY 1
ORDER BY 2 DESC;

SELECT C.country, sum(priceEach*quantityOrdered) as Sales,
DENSE_RANK() OVER(ORDER BY sum(priceEach*quantityOrdered) DESC) RNK
FROM classicmodels.orders A
LEFT JOIN classicmodels.orderdetails B
ON A.orderNumber = B.orderNumber
LEFT JOIN classicmodels.customers C
ON A.customerNumber = C.customerNumber
GROUP BY 1;

SELECT A.customerNumber, A.orderDate, B.customerNumber, B.orderDate
FROM classicmodels.orders A