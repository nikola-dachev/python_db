CREATE TABLE products(
    product_name VARCHAR(100)
);

INSERT INTO products(product_name)
VALUES('Broccoli'),('Shampoo'),('Toothpaste'),('Candy');


ALTER TABLE products
ADD COLUMN id SERIAL PRIMARY KEY;


ALTER TABLE products
DROP CONSTRAINT products_pkey;


CREATE TABLE passports(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 100 INCREMENT BY 1),
    nationality VARCHAR(50)
);


INSERT INTO passports(nationality)
VALUES('N34FG21B'), ('K65LO4R7'), ('ZE657QP2' );


CREATE TABLE people(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    salary DECIMAL(10,2),
    passport_id INT REFERENCES passports
);


INSERT INTO people(first_name, salary, passport_id)
VALUES ('Roberto', 43300.0000, 101),
('Tom', 56100.0000, 102),
('Yana', 60200.0000, 100);



CREATE TABLE manufacturers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE models(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 1000 INCREMENT BY 1),
    model_name VARCHAR(50),
    manufacturer_id INT REFERENCES manufacturers
);


CREATE TABLE production_years(
    id SERIAL PRIMARY KEY,
    established_on DATE,
    manufacturer_id INT REFERENCES manufacturers
);

INSERT INTO manufacturers(name)
VALUES('BMW'), ('Tesla'),('Lada');

INSERT INTO models(model_name, manufacturer_id)
VALUES('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3);

INSERT INTO production_years(established_on, manufacturer_id)
VALUES('1916-03-01',1),
('2003-01-01',2),
('1966-05-01',3);



CREATE TABLE customers(
    id SERIAL PRIMARY KEY,
    name VARCHAR(40),
    date DATE
);


CREATE TABLE photos(
    id SERIAL PRIMARY KEY,
    url VARCHAR(100),
    place VARCHAR(100),
    customer_id INT REFERENCES customers
);

INSERT INTO customers(name, date)
VALUES ('Bella', '2022-03-25'),
('Philip', '2022-07-05');

INSERT INTO photos(url, place, customer_id)
VALUES('bella_1111.com', 'National Theatre', 1),
('bella_1112.com', 'Largo', 1),
('bella_1113.com', 'The View Restaurant', 1),
('philip_1121.com', 'Old Town', 2),
('philip_1122.com', 'Rowing Canal', 2),
('philip_1123.com', 'Roman Theater', 2);



CREATE TABLE students(
    id SERIAL PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE exams(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 101 INCREMENT BY 1),
    exam_name VARCHAR(100)
);

CREATE TABLE study_halls(
    id SERIAL PRIMARY KEY,
    study_hall_name VARCHAR(100),
    exam_id INT REFERENCES exams
);

CREATE TABLE students_exams(
    student_id INT REFERENCES students,
    exam_id INT REFERENCES exams,
    PRIMARY KEY(student_id, exam_id)
);


INSERT INTO students(student_name)
VALUES('Mila'),('Toni'),('Ron');

INSERT INTO exams(exam_name)
VALUES('Python Advanced'),('Python OOP'),('PostgreSQL');

INSERT INTO study_halls(study_hall_name, exam_id)
VALUES
('Open Source Hall',102),
('Inspiration Hall',101),
('Creative Hall',103),
('Masterclass Hall',103),
('Information Security Hall',103);


INSERT INTO students_exams(student_id, exam_id)
VALUES(1,101),(1,102),(2,101),(3,103),(2,102),(2,103);



CREATE TABLE item_types(
    id SERIAL PRIMARY KEY, 
    item_type_name VARCHAR(50)
);


CREATE TABLE items(
    id SERIAL PRIMARY KEY,
    item_name VARCHAR(50),
    item_type_id INT REFERENCES item_types
);

CREATE TABLE cities(
    id SERIAL PRIMARY KEY,
    city_name VARCHAR(50)
);

CREATE TABLE customers(
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    birthday DATE,
    city_id INT REFERENCES cities
);

CREATE TABLE orders(
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers
);

CREATE TABLE order_items(
    order_id INT REFERENCES orders,
    item_id INT REFERENCES items,
    PRIMARY KEY(order_id, item_id)
);


ALTER TABLE countries
ADD CONSTRAINT fk_countries_continents FOREIGN KEY(continent_code) REFERENCES continents (continent_code) ON DELETE CASCADE;

ALTER TABLE countries
ADD CONSTRAINT fk_countries_currencies FOREIGN KEY(currency_code) REFERENCES currencies(currency_code) ON DELETE CASCADE;


ALTER TABLE countries_rivers
ADD CONSTRAINT fk_countries_rivers_rivers
FOREIGN KEY (river_id)
REFERENCES rivers(id)
ON UPDATE CASCADE,

ADD CONSTRAINT fk_countries_rivers_countries
FOREIGN KEY (country_code)
REFERENCES countries(country_code)
ON UPDATE CASCADE;


CREATE TABLE customers(
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE contacts(
    id SERIAL PRIMARY KEY,
    contact_name VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(50),
    customer_id INT REFERENCES customers 
    ON DELETE SET NULL 
    ON UPDATE CASCADE
);

INSERT INTO customers(customer_name)
VALUES('BlueBird Inc'), ('Dolphin LLC');

INSERT INTO contacts(contact_name, phone, email, customer_id)
VALUES('John Doe', '(408)-111-1234', 'john.doe@bluebird.dev', 1),
('Jane Doe', '(408)-111-1235', 'jane.doe@bluebird.dev',1),
('David Wright', '(408)-222-1234', 'david.wright@dolphin.dev', 2);


DELETE FROM customers 
WHERE id = 1;



SELECT 
m.mountain_range,
p.peak_name,
p.elevation
FROM mountains AS m 
JOIN peaks AS p
ON m.id = p.mountain_id
WHERE m.mountain_range = 'Rila'
ORDER BY p.elevation DESC;



SELECT COUNT(*)
FROM countries AS c 
LEFT JOIN countries_rivers AS cr 
ON c.country_code = cr.country_code
WHERE cr.river_id IS NULL;
