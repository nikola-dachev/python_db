CREATE TABLE mountains(
    id SERIAL PRIMARY KEY, 
    name VARCHAR(50)
);

CREATE TABLE peaks(
    id SERIAL PRIMARY KEY, 
    name VARCHAR(50),
    mountain_id INT,
    CONSTRAINT fk_peaks_mountains
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
);


SELECT 
v.driver_id,
v.vehicle_type,
CONCAT(c.first_name, ' ', c.last_name) AS driver_name
FROM vehicles AS v 
JOIN campers AS c 
ON c.id = v.driver_id;


SELECT 
r.start_point,
r.end_point,
r.leader_id,
CONCAT(c.first_name, ' ', c.last_name) AS leader_name
FROM routes AS r 
JOIN campers AS c
ON r.leader_id = c.id;


CREATE TABLE mountains(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);


CREATE TABLE peaks(
    id SERIAL PRIMARY KEY, 
    name VARCHAR(50),
    mountain_id INT,
    CONSTRAINT fk_mountain_id
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
    ON DELETE CASCADE 
);