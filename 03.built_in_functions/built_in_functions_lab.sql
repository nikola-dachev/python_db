SELECT title
FROM books
WHERE title LIKE 'The%'
ORDER BY id


SELECT REPLACE(title, 'The', '***')
FROM books
WHERE title LIKE 'The%'
ORDER BY id;


SELECT id,
(side * height) /2 AS area
FROM triangles
ORDER BY id;


SELECT title,
ROUND(cost,3) as modified_price
FROM books
ORDER BY id;


SELECT first_name,
last_name,
date_part('year', born) AS year
FROM authors;



SELECT last_name AS "Last Name",
TO_CHAR(born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
FROM authors;


SELECT title
FROM books
WHERE title LIKE '%Harry Potter%'
ORDER BY id;