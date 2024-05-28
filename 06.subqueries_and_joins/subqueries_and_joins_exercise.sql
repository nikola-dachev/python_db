SELECT 
CONCAT(a.address,' ', a.address_2) AS apartment_address,
b.booked_for AS nights
FROM apartments AS a 
JOIN bookings AS b 
ON a.booking_id = b.booking_id
ORDER BY a.apartment_id;



SELECT 
a.name,
a.country,
DATE(b.booked_at)
FROM apartments AS a
LEFT JOIN bookings AS b 
ON a.booking_id = b.booking_id
LIMIT 10;


SELECT 
b.booking_id,
DATE(b.starts_at),
b.apartment_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM bookings AS b 
RIGHT JOIN customers AS c 
ON b.customer_id = c.customer_id
ORDER BY customer_name
LIMIT 10;


SELECT 
b.booking_id,
a.name AS apartment_owner,
a.apartment_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM bookings AS b 
FULL JOIN apartments AS a 
ON b.booking_id = a.booking_id
FULL JOIN customers AS c 
ON b.customer_id = c.customer_id
ORDER BY b.booking_id, a.name, customer_name;


SELECT b.booking_id,
b.apartment_id,
c.companion_full_name
FROM bookings AS b 
JOIN customers AS c 
ON b.customer_id = c.customer_id
WHERE b.apartment_id IS NULL;


SELECT b.apartment_id,
b.booked_for, 
c.first_name, 
c.country
FROM bookings AS b 
JOIN customers AS c 
ON c.customer_id = b.customer_id
WHERE c.job_type = 'Lead';


SELECT 
COUNT (booking_id)
FROM bookings
WHERE customer_id IN (
    SELECT customer_id FROM customers WHERE last_name = 'Hahn' 
);

SELECT COUNT(b.booking_id)
FROM bookings AS b 
JOIN customers AS c 
ON b.customer_id = c.customer_id
WHERE c.last_name = 'Hahn';


SELECT 
a.name, 
SUM(b.booked_for)
FROM apartments AS a 
JOIN bookings AS b 
ON a.apartment_id = b.apartment_id
GROUP BY a.name
ORDER BY a.name;


SELECT 
a.country, 
COUNT(b.booking_id) AS booking_count
FROM apartments AS a 
JOIN bookings AS b 
ON a.apartment_id = b.apartment_id 
WHERE b.booked_at >= '2021-05-18 07:52:09.904+03' AND b.booked_at <'2021-09-17 19:48:02.147+03' 
GROUP BY a.country
ORDER BY booking_count DESC;


SELECT 
mc.country_code, 
m.mountain_range, 
p.peak_name,
p.elevation
FROM mountains AS m 
JOIN mountains_countries AS mc
ON m.id = mc.mountain_id
JOIN peaks AS p 
ON m.id = p.mountain_id
WHERE p.elevation >2835 AND mc.country_code = 'BG'
ORDER BY p.elevation DESC;


SELECT 
mc.country_code,
COUNT(DISTINCT(m.mountain_range)) AS mountain_range_count
FROM mountains AS m 
JOIN mountains_countries AS mc 
ON m.id = mc.mountain_id
WHERE mc.country_code IN ('US', 'RU', 'BG')
GROUP BY mc.country_code
ORDER BY mountain_range_count DESC;


SELECT 
c.country_name, 
r.river_name
FROM countries AS c 
LEFT JOIN countries_rivers AS cr 
ON c.country_code = cr.country_code
LEFT JOIN rivers AS r 
ON r.id = cr.river_id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;


SELECT MIN(avg_area) AS min_average_area
FROM 
    (SELECT 
    AVG(area_in_sq_km) AS avg_area,
    continent_code
    FROM countries
    GROUP BY continent_code) AS average_area


SELECT COUNT(*) AS countries_without_mountains
FROM countries AS c 
LEFT JOIN mountains_countries AS mc 
ON c.country_code = mc.country_code
WHERE mc.mountain_id IS NULL;


CREATE TABLE monasteries(
    id SERIAL PRIMARY KEY,
    monastery_name VARCHAR(255),
    country_code CHAR(2)
);

INSERT INTO monasteries(monastery_name, country_code)
VALUES
('Rila Monastery "St. Ivan of Rila"', 'BG'),
  ('Bachkovo Monastery "Virgin Mary"', 'BG'),
  ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
  ('Kopan Monastery', 'NP'),
  ('Thrangu Tashi Yangtse Monastery', 'NP'),
  ('Shechen Tennyi Dargyeling Monastery', 'NP'),
  ('Benchen Monastery', 'NP'),
  ('Southern Shaolin Monastery', 'CN'),
  ('Dabei Monastery', 'CN'),
  ('Wa Sau Toi', 'CN'),
  ('Lhunshigyia Monastery', 'CN'),
  ('Rakya Monastery', 'CN'),
  ('Monasteries of Meteora', 'GR'),
  ('The Holy Monastery of Stavronikita', 'GR'),
  ('Taung Kalat Monastery', 'MM'),
  ('Pa-Auk Forest Monastery', 'MM'),
  ('Taktsang Palphug Monastery', 'BT'),
  ('Sümela Monastery', 'TR');



ALTER TABLE countries 
ADD COLUMN three_rivers BOOLEAN DEFAULT false;


UPDATE countries 
SET three_rivers = true 
WHERE country_name IN (
    SELECT country_name FROM 
    (SELECT 
    c.country_name,
    COUNT(cr.river_id)
    FROM countries AS c 
    JOIN countries_rivers AS cr 
    ON c.country_code = cr.country_code
    GROUP BY c.country_name
    HAVING COUNT(cr.river_id) >3) AS  subquery
);


SELECT m.monastery_name,
c.country_name
FROM monasteries AS m 
JOIN countries AS c 
ON m.country_code = c.country_code
WHERE c.three_rivers = true
ORDER BY monastery_name


