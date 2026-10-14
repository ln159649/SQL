-- Sales Orders Analytics (MySQL)
-- Queries a database of monthly customer orders to answer business questions about sales.
-- Tables: JanSales, FebSales (orders), customers (account numbers by order).

-- 1. How many orders were placed in January?
SELECT COUNT(*) AS jan_orders
FROM BIT_DB.JanSales;

-- 2. How many of those orders were for an iPhone?
SELECT COUNT(*) AS jan_iphone_orders
FROM BIT_DB.JanSales
WHERE Product = 'iPhone';

-- 3. Customer account numbers for all orders placed in February.
SELECT cust.acctnum
FROM BIT_DB.customers cust
INNER JOIN BIT_DB.FebSales feb
    ON cust.order_id = feb.orderid;

-- 4. Cheapest product sold in January and its price.
SELECT Product, Price
FROM BIT_DB.JanSales
ORDER BY Price ASC
LIMIT 1;

-- 5. Total revenue for each product sold in January.
SELECT Product,
       SUM(Quantity)         AS units_sold,
       SUM(Quantity * Price) AS revenue
FROM BIT_DB.JanSales
GROUP BY Product
ORDER BY revenue DESC;

-- 6. Products sold in February at 548 Lincoln St, Seattle: units and revenue.
SELECT Product,
       SUM(Quantity)         AS units_sold,
       SUM(Quantity * Price) AS revenue
FROM BIT_DB.FebSales
WHERE Location = '548 Lincoln St, Seattle, WA 98101'
GROUP BY Product;

-- 7. Customers who ordered more than 2 products at a time, and their average spend.
SELECT COUNT(DISTINCT cust.acctnum) AS customers,
       AVG(feb.Quantity * feb.Price) AS avg_order_value
FROM BIT_DB.FebSales feb
INNER JOIN BIT_DB.customers cust
    ON feb.orderid = cust.order_id
WHERE feb.Quantity > 2;

-- 8. Orders between February 13 and February 18, 2019 (inclusive of the 18th).
-- Dates are stored as text like '02/13/19 00:00', so convert before comparing.
SELECT orderid, STR_TO_DATE(OrderDate, '%m/%d/%y %H:%i') AS order_ts
FROM BIT_DB.FebSales
WHERE STR_TO_DATE(OrderDate, '%m/%d/%y %H:%i') >= '2019-02-13'
  AND STR_TO_DATE(OrderDate, '%m/%d/%y %H:%i') <  '2019-02-19'
ORDER BY order_ts DESC;

-- 9. Products sold in Los Angeles in February and units of each.
SELECT Product, SUM(Quantity) AS total_sold
FROM BIT_DB.FebSales
WHERE Location LIKE '%Los Angeles%'
GROUP BY Product;

-- 10. New York locations with at least 3 orders in January.
SELECT Location, COUNT(orderID) AS orders
FROM BIT_DB.JanSales
WHERE Location LIKE '%NY%'
GROUP BY Location
HAVING COUNT(orderID) >= 3;

-- 11. Units sold of each type of headphone in February.
SELECT Product, SUM(Quantity) AS total
FROM BIT_DB.FebSales
WHERE Product LIKE '%Headphones%'
GROUP BY Product;

-- 12. Average amount spent per account in February.
SELECT AVG(account_spend) AS avg_spend_per_account
FROM (
    SELECT cust.acctnum, SUM(feb.Quantity * feb.Price) AS account_spend
    FROM BIT_DB.FebSales feb
    INNER JOIN BIT_DB.customers cust ON feb.orderid = cust.order_id
    GROUP BY cust.acctnum
) AS per_account;

-- 13. Average quantity of products purchased per account in February.
SELECT AVG(account_units) AS avg_units_per_account
FROM (
    SELECT cust.acctnum, SUM(feb.Quantity) AS account_units
    FROM BIT_DB.FebSales feb
    INNER JOIN BIT_DB.customers cust ON feb.orderid = cust.order_id
    GROUP BY cust.acctnum
) AS per_account;

-- 14. Product with the most revenue in January and its total revenue.
SELECT Product, SUM(Quantity * Price) AS revenue
FROM BIT_DB.JanSales
GROUP BY Product
ORDER BY revenue DESC
LIMIT 1;
