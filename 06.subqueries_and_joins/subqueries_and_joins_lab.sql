SELECT 
t.town_id,
t.name AS town_name,
a.address_text
FROM towns AS t 
JOIN addresses AS a 
ON t.town_id = a.town_id
WHERE  t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY t.town_id, a.address_id;



SELECT 
e.employee_id,
CONCAT(e.first_name, ' ', e.last_name) AS full_name,
d.department_id,
d.name AS department_name
FROM departments AS d
LEFT JOIN employees AS e 
ON d.manager_id = e.employee_id
ORDER BY e.employee_id
LIMIT 5;


SELECT 
e.employee_id, 
CONCAT(e.first_name, ' ', e.last_name) AS full_name,  
p.project_id, 
p.name AS project_name 
FROM employees AS e 
JOIN employees_projects AS ep 
ON e.employee_id = ep.employee_id
JOIN projects AS p
ON p.project_id = ep.project_id
WHERE p.project_id = 1;


SELECT COUNT(employee_id)
FROM employees 
WHERE salary > 
        (SELECT AVG(salary)
         FROM employees);