CREATE FUNCTION fn_count_employees_by_town(town_name VARCHAR(20)) 

RETURNS INT
LANGUAGE plpgsql
AS 

$$
DECLARE count_of_employees INT;

BEGIN

SELECT 
COUNT (employee_id) INTO count_of_employees
FROM employees AS e 
JOIN addresses AS a 
ON e.address_id = a.address_id
JOIN towns AS t 
ON a.town_id = t.town_id
WHERE t.name = town_name;

RETURN count_of_employees;

END;
$$


CREATE PROCEDURE sp_increase_salaries(department_name VARCHAR(40))
LANGUAGE plpgsql
AS
$$

BEGIN

UPDATE employees 
SET salary = salary *1.05
WHERE department_id = (
    SELECT department_id 
    FROM departments 
    WHERE name = department_name);

END;
$$


CREATE PROCEDURE sp_increase_salary_by_id(id INT)
LANGUAGE plpgsql
AS
$$
BEGIN
IF (SELECT COUNT(employee_id) FROM employees WHERE employee_id = id) = 0 THEN
ROLLBACK;
ELSE
UPDATE employees 
SET salary = salary *1.05
WHERE employee_id = id;
END IF;
COMMIT;
END;
$$




CREATE TABLE deleted_employees(
employee_id SERIAL PRIMARY KEY,
first_name VARCHAR(20),
last_name VARCHAR(20),
middle_name VARCHAR(20),
job_title VARCHAR(50),
department_id INT,
salary NUMERIC(19,4)
);

CREATE FUNCTION trigger_fn_on_employee_delete()
RETURNS TRIGGER
LANGUAGE plpgsql
AS 
$$
BEGIN
INSERT INTO deleted_employees (first_name,last_name, middle_name,job_title,department_id,salary)
VALUES
(OLD.first_name,OLD.last_name,OLD.middle_name, OLD.job_title,OLD.department_id,OLD.salary);
RETURN NULL;
END;
$$;


CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW
EXECUTE FUNCTION
trigger_fn_on_employee_delete();