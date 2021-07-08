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
LEFT JOIN classicmodels.orders B
ON A.customerNumber = B.customerNumber AND substr(A.orderDate,1,4) = substr(B.orderDate,1,4) -1;

SELECT C.country, substr(A.orderDate,1,4) YY,
count(distinct A.customerNumber) BU_1,
count(distinct B.customerNumber) BU_2,
count(distinct B.customerNumber)/count(distinct A.customerNumber) Rate
FROM classicmodels.orders A
LEFT JOIN classicmodels.orders B
ON A.customerNumber = B.customerNumber AND substr(A.orderDate,1,4) = substr(B.orderDate,1,4) -1
LEFT JOIN classicmodels.customers C
ON A.customerNumber = C.customerNumber
GROUP BY 1, 2
ORDER BY 2;

CREATE TABLE classicmodels.product_sales
SELECT D.productName, sum(quantityordered*priceeach) Sales
FROM classicmodels.orders A
LEFT JOIN classicmodels.customers B
ON A.customerNumber = B.customerNumber
LEFT JOIN classicmodels.orderdetails C
ON A.orderNumber = C.orderNumber
LEFT JOIN classicmodels.products D
ON C.productCode = D.productCode
WHERE B.country = 'USA'
GROUP BY 1;

SELECT * 
FROM (SELECT *, row_number() OVER(ORDER BY Sales DESC) RNK
	  FROM classicmodels.product_sales) A
WHERE RNK <=5
ORDER BY RNK;

CREATE TABLE classicmodels.churn_list AS
SELECT CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE, customerNumber
FROM (SELECT customerNumber, max_order, '2005-06-01' END_PONIT,
	  datediff('2005-06-01',max_order) DIFF
	  FROM (SELECT customerNumber, max(orderDate) max_order
			FROM classicmodels.orders
			GROUP BY 1) 
	  BASE) BASE;
      
SELECT D.churn_type, C.productline, count(distinct B.customerNumber) BU
FROM classicmodels.orderdetails A
LEFT JOIN classicmodels.orders B
ON A.orderNumber = B.orderNumber
LEFT JOIN classicmodels.products C
ON A.productCode = C.productCode
LEFT JOIN classicmodels.churn_list D
ON B.customerNumber = D.customerNumber
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
