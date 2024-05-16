CREATE VIEW view_river_info AS
SELECT 
CONCAT('The river', ' ', river_name, ' ', 'flows into the', ' ', outflow, ' ', 'and is', ' ', "length", ' ', 'kilometers long.') AS "River Information"
FROM rivers
ORDER BY river_name;


CREATE VIEW view_continents_countries_currencies_details AS 
SELECT 
CONCAT(con.continent_name, ': ', con.continent_code) AS continent_details,
CONCAT(cou.country_name, ' - ', cou.capital, ' - ', cou.area_in_sq_km, ' - ', 'km2') AS country_information,
CONCAT(cur.description, ' ',  '(', cur.currency_code, ')') AS currencies
FROM continents AS con
JOIN countries AS cou
ON con.continent_code = cou.continent_code
JOIN currencies AS cur
ON cur.currency_code = cou.currency_code
ORDER BY country_information, currencies;


ALTER TABLE countries 
ADD COLUMN capital_code CHAR(2);

UPDATE countries 
SET capital_code = SUBSTRING(capital FROM 1 FOR 2);


SELECT 
*
FROM countries ;


SELECT 
SUBSTRING(description,5) AS substring
FROM currencies;


SELECT 
SUBSTRING("River Information", '([0-9]{1,4})') AS river_length
FROM view_river_info;


SELECT 
REPLACE(mountain_range, 'a', '@') AS replace_a,
REPLACE (mountain_range, 'A', '$') AS replace_A
FROM mountains;


SELECT 
capital,
TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS translated_name
FROM countries;


SELECT 
continent_name, 
LTRIM(continent_name) AS trim
FROM continents;

SELECT 
continent_name, 
RTRIM(continent_name) AS trim
FROM continents;


SELECT 
LTRIM(peak_name, 'M') AS left_trim,
RTRIM(peak_name, 'm') AS right_trim
FROM peaks;


SELECT 
CONCAT(m.mountain_range, ' ', p.peak_name) AS mountain_information,
LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS characters_length,
BIT_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS bits_of_a_tring
FROM mountains AS m 
JOIN peaks AS p 
ON p.mountain_id = m.id;


SELECT 
population,
LENGTH(CAST(population AS VARCHAR)) AS length
FROM countries;



SELECT peak_name,
LEFT(peak_name,4) AS positive_left,
LEFT(peak_name,-4) AS negative_left
FROM peaks;


SELECT peak_name,
RIGHT(peak_name,4) AS positive_right,
RIGHT(peak_name, -4) AS negative_right
FROM peaks;


UPDATE countries
SET iso_code = UPPER(LEFT(country_name,3))
WHERE iso_code IS NULL;


UPDATE countries
SET country_code = REVERSE(LOWER(country_code));


SELECT 
CONCAT(elevation,' ', REPEAT('-',3), REPEAT('>',2) ,' ', peak_name) AS "Elevation --->> Peak Name"
FROM peaks
WHERE elevation >= 4884;


CREATE TABLE bookings_calculation AS 
SELECT booked_for 
FROM bookings
WHERE apartment_id = 93;


ALTER TABLE bookings_calculation
ADD COLUMN multiplication NUMERIC,
ADD COLUMN modulo NUMERIC;


UPDATE bookings_calculation
SET multiplication = booked_for * 50,
modulo = booked_for % 50;


SELECT booked_for,
multiplication,
modulo
FROM bookings_calculation;


SELECT latitude,
ROUND(latitude, 2),
TRUNC(latitude,2)
FROM apartments; 


SELECT longitude,
ABS(longitude)
FROM apartments;


SELECT 
EXTRACT(YEAR FROM booked_at),
EXTRACT(MONTH FROM booked_at),
EXTRACT(DAY FROM booked_at),
EXTRACT(HOUR FROM booked_at),
EXTRACT(MINUTE FROM booked_at),
CEILING(EXTRACT(SECOND FROM booked_at))
FROM bookings;


SELECT companion_full_name, 
email
FROM users
WHERE companion_full_name ILIKE '%aNd%'
AND email NOT LIKE '%@gmail';



SELECT LEFT(first_name,2) AS initials,
COUNT(id) AS user_count
FROM users 
GROUP BY LEFT(first_name,2)
ORDER BY user_count DESC, initials;


SELECT 
SUM(booked_for) AS total_value
FROM bookings 
WHERE apartment_id = 90;


SELECT 
AVG(multiplication) AS avarage_value
FROM bookings_calculation;