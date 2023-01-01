-- 5 Tables
-- 1x Fact, 4x Dimension
-- search google, how to add foreign key
-- write SQL 3-5 queries analyze data
-- 1x subquery/ with

--DIMENSION
CREATE TABLE beers (
  productid INT PRIMARY key,
  brewery TEXT,
  beertype TEXT,
  beer_name TEXT
);

INSERT INTO beers values
  (1, 'SAMATA', 'NEIPA', 'SAMATA x TBP New England IPA'),
  (2, 'Widowmaker', 'NEIPA', 'Polychronic Bloom'),
 (3, 'SAMATA', 'Sour', 'Greena Colada'),
   (4, 'Ominipollo', 'Stout', 'Noa Pecan Pancake');


--DIMENSION
CREATE TABLE stocks (
  productid INT,
  servingtype TEXT,
  price INT,
  amount INT
);

INSERT INTO stocks values
  (1, 'Draft', 240, 300),
  (2, 'Can', 320, 80),
  (3, 'Can', 260, 80),
  (4, 'Bottle', 420, 40);

--DIMENSION
CREATE TABLE customers (
  id INT PRIMARY key,
  customer_name TEXT
);

INSERT INTO customers values
  (1, 'Iggy'),
  (2, 'Dave'),
  (3, 'Nop'),
  (4, 'Myhra');

--DIMENSION
CREATE TABLE pay (
  paymentid INT PRIMARY key,
  paymenttype TEXT
);

INSERT INTO pay values
  (1, 'credit card'),
  (2, 'QR'),
  (3, 'cash');

--FACT
CREATE TABLE orders (
  paymentid INT,
  order_date TEXT,
  id INT,
  productid INT,
  amount INT
);

INSERT INTO orders values
  (1, '2022-08-27', 2, 1, 3),
  (1, '2022-08-27', 2, 4, 1),
  (1, '2022-08-26', 4, 1, 4),
  (1, '2022-08-26', 4, 3, 3),
  (2, '2022-08-26', 2, 2, 1),
  (3, '2022-08-26', 3, 2, 2),
  (2, '2022-08-25', 2, 3, 1),
  (2, '2022-08-25', 2, 1, 2),
  (1, '2022-08-23', 2, 1, 4),
  (2, '2022-08-18', 2, 1, 1),
  (1, '2022-08-15', 2, 4, 2),
  (3, '2022-08-15', 1, 4, 2),
  (3, '2022-08-14', 3, 1, 2)
  ;

-- sqlite command
.mode markdown
.header on


-- topspender 
WITH sale AS
    (SELECT
      c.customer_name,
      o.amount * s.price AS total,
      o.order_date
    FROM customers AS c
    JOIN orders AS o ON o.id = c.id
    JOIN beers AS b ON o.productid = b.productid
    JOIN stocks AS s ON b.productid = s.productid
    )
SELECT
  customer_name,
  MIN(order_date) AS firstvisit,
  MAX(order_date) AS lastvisit,
  SUM (total)
FROM sale
GROUP BY customer_name
ORDER BY SUM (total) DESC;

-- customer segment
SELECT
  customer_name,
  sub.n_visit AS n_visit,
   CASE WHEN sub.n_visit > 5 THEN 'regular'
        WHEN sub.n_visit = 1 THEN 'first-timer'
        ELSE 'customer'
   END as segment
  FROM (SELECT
    id,
    order_date,
    amount,
    COUNT(DISTINCT order_date) AS n_visit
    FROM orders
    GROUP BY id
    )AS sub
JOIN customers ON customers.id = sub.id
ORDER BY n_visit DESC;

-- stock / revenue
SELECT
  b.beertype,
  b.beer_name,
  s.servingtype,
  SUM(o.amount) AS sold,
  SUM(o.amount) * s.price AS revenue,
  s.amount-SUM(o.amount) AS stockleft
FROM beers AS b
JOIN orders AS o ON b.productid = o.productid
JOIN stocks as s ON o.productid = s.productid
GROUP BY beer_name
ORDER BY stockleft;

-- top payment medthod
SELECT
  SUM(sub.paid) AS sum,
  sub.paymenttype
  FROM (
  SELECT
  o.order_date || '-' || o.id AS code,
  o.amount * s.price AS paid,
  pay.paymenttype
  FROM orders as o
  JOIN stocks as s ON o.productid = s.productid
  JOIN pay ON pay.paymentid = o.paymentid)
AS sub
GROUP BY sub.paymenttype
ORDER BY sum DESC;
