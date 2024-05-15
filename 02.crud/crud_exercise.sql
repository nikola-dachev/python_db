SELECT *
FROM cities 
ORDER BY id;

SELECT CONCAT(name, ' ', state) AS cities_information,
area AS area_km2
FROM cities;


SELECT DISTINCT name,
area AS area_km2
FROM cities
ORDER BY name DESC;


SELECT id, 
CONCAT(first_name, ' ', last_name) AS full_name,
job_title
FROM employees
ORDER BY first_name
LIMIT 50;


SELECT id AS id,
CONCAT(first_name, ' ', middle_name, ' ', last_name) AS full_name,
hire_date
FROM employees
ORDER BY hire_date
OFFSET 9;


SELECT id, 
CONCAT(number, ' ', street) AS address,
city_id
FROM addresses
WHERE id >=20;


SELECT CONCAT(number, ' ', street) AS address,
city_id
FROM addresses
WHERE city_id % 2= 0
ORDER BY city_id;



SELECT name,
start_date,
end_date
FROM projects
WHERE start_date >='2016-06-01 07:00:00' AND end_date < '2023-06-04 00:00:00'
ORDER BY start_date;


SELECT number,
street
FROM addresses
WHERE (id BETWEEN 50 AND 100) OR number <1000;


SELECT employee_id, project_id
FROM employees_projects
WHERE employee_id IN (200, 250) AND project_id NOT IN (50,100);


SELECT name, 
start_date 
FROM projects
WHERE name IN ('Mountain', 'Road', 'Touring')
LIMIT 20



SELECT CONCAT(first_name, ' ', last_name) AS full_name,
job_title,
salary
FROM employees
WHERE salary IN(12500, 14000, 23600, 25000)
ORDER BY salary DESC



SELECT id,
first_name,
last_name
FROM employees
WHERE middle_name IS NULL
LIMIT 3



INSERT INTO departments(department, manager_id)
VALUES 	('Finance', 3),
	('Information Services', 42),
	('Document Control', 90),
	('Quality Assurance', 274),
	('Facilities and Maintenance', 218),
	('Shipping and Receiving', 85),
	('Executive', 109);



CREATE TABLE company_chart AS 
SELECT  CONCAT(first_name, ' ', last_name) as full_name,
job_title,
department_id,
manager_id
FROM employees;


UPDATE projects
SET end_date = start_date + '5 months'
WHERE end_date IS NULL;


UPDATE employees
SET salary = salary + 1500,
job_title = CONCAT('Senior ',  job_title)
WHERE hire_date BETWEEN'1998-01-01' AND '2000-01-05';


DELETE FROM addresses 
WHERE city_id IN(5, 17, 20, 30);


CREATE VIEW view_company_chart AS 
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
job_title
FROM employees
WHERE manager_id = 184;


CREATE VIEW view_addresses AS
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name,
e.department_id ,
CONCAT(a.number, ' ', a.street) AS address
FROM employees AS e
JOIN addresses AS a 
ON e.address_id = a.id;


ALTER VIEW view_addresses RENAME TO view_employee_addresses_info;

DROP VIEW view_company_chart;


UPDATE projects
SET name = UPPER(name);


CREATE VIEW view_initials AS 
SELECT SUBSTRING (first_name FROM 1 FOR 2) AS initial, 
last_name
FROM employees
ORDER BY last_name;


SELECT name, 
start_date
FROM projects
WHERE name LIKE 'MOUNT%'
ORDER BY id