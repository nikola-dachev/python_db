
SELECT department_id,
COUNT(id)
FROM employees
GROUP BY department_id
ORDER BY department_id;


SELECT department_id,
COUNT(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;


SELECT department_id,
SUM(salary) AS total_salaries
FROM employees
GROUP BY department_id
ORDER BY department_id;


SELECT department_id,
MAX(salary) AS max_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;


SELECT department_id, 
MIN(salary) AS min_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;



SELECT department_id,
AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;


SELECT department_id,
SUM(salary) AS "Total Salary"
FROM employees
GROUP BY department_id
HAVING SUM(salary) < 4200
ORDER BY department_id;


SELECT id,
first_name,
last_name,
ROUND(salary,2),
department_id,
CASE 
WHEN department_id = 1 THEN 'Management'
WHEN department_id = 2 THEN 'Kitchen Staff'
WHEN department_id = 3 THEN 'Service Staff'
ELSE 'Other'
END AS department_name
FROM employees 
ORDER BY id;