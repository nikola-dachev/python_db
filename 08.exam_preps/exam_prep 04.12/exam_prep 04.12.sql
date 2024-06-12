CREATE TABLE countries(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE customers(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) CHECK(gender IN ('M', 'F')),
    age INT NOT NULL CHECK(age>0),
    phone_number CHAR(10) NOT NULL,
    country_id INT NOT NULL REFERENCES countries ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE products(
    id SERIAL PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    description VARCHAR(250),
    recipe TEXT, 
    price NUMERIC(10,2) NOT NULL CHECK(price >0)
);

CREATE TABLE feedbacks(
    id SERIAL PRIMARY KEY,
    description VARCHAR(255),
    rate NUMERIC(4,2) CHECK(rate BETWEEN 0 AND 10),
    product_id INT NOT NULL REFERENCES products ON DELETE CASCADE ON UPDATE CASCADE,
    customer_id INT NOT NULL REFERENCES customers ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE distributors(
    id SERIAL PRIMARY KEY,
    name VARCHAR(25) UNIQUE NOT NULL,
    address VARCHAR(30) NOT NULL,
    summary VARCHAR(200) NOT NULL,
    country_id INT NOT NULL REFERENCES countries ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE ingredients(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(200),
    country_id INT NOT NULL REFERENCES countries ON DELETE CASCADE ON UPDATE CASCADE,
    distributor_id INT NOT NULL REFERENCES distributors ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE products_ingredients(
    product_id INT REFERENCES products ON DELETE CASCADE ON UPDATE CASCADE,
    ingredient_id INT REFERENCES ingredients ON DELETE CASCADE ON UPDATE CASCADE
    
);


CREATE TABLE gift_recipients(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL, 
    country_id INT NOT NULL,
    gift_sent BOOLEAN DEFAULT False
);

INSERT INTO gift_recipients(name, country_id, gift_sent)
SELECT CONCAT(first_name, ' ', last_name ) AS name,
country_id AS country_id,
CASE 
WHEN country_id IN( 7, 8, 14, 17, 26) THEN True
    ELSE False
    END AS gift_sent
FROM customers;


UPDATE products 
SET price = price * 1.1
WHERE id IN (SELECT product_id 
            FROM feedbacks 
            WHERE rate>8);


DELETE FROM distributors
WHERE name LIKE 'L%';


DELETE FROM ingredients 
WHERE distributor_id IN 
                    (SELECT id 
                    FROM distributors
                    WHERE name LIKE 'L%');


DELETE FROM products_ingredients
WHERE ingredient_id IN (SELECT id 
                    FROM distributors 
                    WHERE name LIKE 'L%');



SELECT 
name,
recipe,
price 
FROM products
WHERE price > 10 AND price<20
ORDER BY price DESC;



SELECT 
f.product_id,
f.rate,
f.description,
f.customer_id,
c.age,
c.gender
FROM feedbacks AS f 
JOIN customers AS c 
ON f.customer_id = c.id
WHERE f.rate <5.0 AND (c.gender = 'F' AND c.age >30)
ORDER BY product_id DESC;


SELECT 
p.name,
ROUND(AVG(p.price), 2) AS average_price,
COUNT(f.id) AS total_feedbacks 
FROM products AS p 
JOIN feedbacks AS f 
ON f.product_id = p.id
WHERE p.price >15
GROUP BY p.name
HAVING COUNT(f.id) >1
ORDER BY total_feedbacks, average_price DESC;


SELECT 
i.name AS ingredient_name,
p.name AS product_name,
d.name AS distributor_name
FROM ingredients AS i 
JOIN distributors AS d 
ON d.id = i.distributor_id
JOIN products_ingredients AS pi 
ON i.id = pi.ingredient_id
JOIN products AS p 
ON p.id = pi.product_id 
WHERE i.name ILIKE '%mustard%' AND d.country_id = 16
ORDER BY p.name;



SELECT
d.name AS distributor_name,
i.name AS ingredient_name,
p.name AS product_name,
AVG(f.rate) AS average_rate
FROM distributors AS d 
JOIN ingredients AS i 
ON i.distributor_id = d.id
JOIN products_ingredients AS pi 
ON i.id = pi.ingredient_id
JOIN products AS p  
ON pi.product_id = p.id
JOIN feedbacks AS f 
ON f.product_id = p.id
GROUP BY d.name, i.name,p.name 
HAVING AVG(f.rate) BETWEEN 5 AND 8
ORDER BY d.name, i.name,p.name;



CREATE FUNCTION fn_feedbacks_for_product(product_name VARCHAR(25))
RETURNS TABLE(customer_id INT, customer_name VARCHAR(75), feedback_description VARCHAR(255), feedback_rate NUMERIC(4,2))
AS 
$$
BEGIN
RETURN QUERY 
            SELECT 
            f.customer_id AS customer_id,
            c.first_name AS customer_name,
            f.description AS feedback_description,
            f.rate AS feedback_rate
            FROM customers AS c 
            JOIN feedbacks AS f 
            ON f.customer_id = c.id
            JOIN products AS p 
            ON p.id = f.product_id
            WHERE p.name = product_name
            ORDER BY c.id;
END;
$$
LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE sp_customer_country_name(
    IN customer_full_name VARCHAR(50),
    OUT country_name VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT 
        c."name"
    INTO 
        country_name
    FROM 
        customers AS cust
    LEFT JOIN 
        countries AS c 
        ON cust.country_id = c."id"
    WHERE 
        CONCAT_WS(' ', cust.first_name, cust.last_name) = customer_full_name;
END;
$$;
