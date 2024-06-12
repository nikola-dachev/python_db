CREATE TABLE towns (
    id SERIAL PRIMARY KEY,
    name VARCHAR(45) NOT NULL
);


CREATE TABLE stadiums(
    id SERIAL PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    capacity INT NOT NULL CHECK(capacity>0),
    town_id INT NOT NULL REFERENCES towns ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE teams(
    id SERIAL PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base INT NOT NULL DEFAULT 0 CHECK(fan_base >=0),
    stadium_id INT NOT NULL REFERENCES stadiums ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE coaches (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK(salary>=0),
    coach_level INT NOT NULL DEFAULT 0 CHECK(coach_level>=0)
);


CREATE TABLE skills_data(
    id SERIAL PRIMARY KEY,
    dribbling INT DEFAULT 0 CHECK(dribbling>=0),
    pace INT DEFAULT 0 CHECK(pace >=0),
    passing INT DEFAULT 0 CHECK(passing>=0),
    shooting INT DEFAULT 0 CHECK(shooting>=0),
    speed INT DEFAULT 0 CHECK(speed>=0),
    strength INT DEFAULT 0 CHECK(strength>=0)
);


CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INT NOT NULL DEFAULT 0 CHECK(age>=0),
    position CHAR(1) NOT NULL,
    salary NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK(salary>=0),
    hire_date TIMESTAMP,
    skills_data_id INT NOT NULL REFERENCES skills_data ON DELETE CASCADE ON UPDATE CASCADE,
    team_id INT REFERENCES teams ON DELETE CASCADE ON UPDATE CASCADE 
);


CREATE TABLE players_coaches(
    player_id INT REFERENCES players ON DELETE CASCADE ON UPDATE CASCADE,
    coach_id INT REFERENCES coaches ON DELETE CASCADE ON UPDATE CASCADE 
);



INSERT INTO coaches(first_name, last_name, salary,coach_level)
SELECT first_name, last_name,salary*2,length(first_name)
FROM players 
WHERE hire_date <'2013-12-13 07:18:46';


UPDATE coaches 
SET salary = salary*coach_level
WHERE first_name LIKE 'C%' AND  id IN (
    SELECT DISTINCT coach_id
    FROM players_coaches
    WHERE coach_id IS NOT NULL
);


DELETE FROM players
WHERE hire_date <'2013-12-13 07:18:46';


DELETE FROM players_coaches
WHERE player_id IN (
                    SELECT id FROM players
                    WHERE hire_date <'2013-12-13 07:18:46');



SELECT 
CONCAT(first_name, ' ', last_name) AS full_name,
age,
hire_date
FROM players 
WHERE first_name LIKE 'M%'
ORDER BY age DESC, full_name;



SELECT 
p.id,
CONCAT(p.first_name, ' ', p.last_name) AS full_name,
p.age,
p.position,
p.salary,
sd.pace,
sd.shooting
FROM players AS p
JOIN skills_data AS sd 
ON p.skills_data_id = sd.id
WHERE position = 'A' AND team_id IS NULL AND sd.pace+sd.shooting >130;


SELECT 
t.id AS team_id,
t.name AS team_name,
COUNT(p.id) AS player_count,
t.fan_base AS fan_base
FROM teams AS t 
LEFT JOIN players AS p 
ON t.id = p.team_id
WHERE t.fan_base >30000
GROUP BY t.id, t.name,t.fan_base
ORDER BY player_count DESC, fan_base DESC;



SELECT 
CONCAT(c.first_name, ' ', c.last_name) AS coach_full_name,
CONCAT(p.first_name, ' ', p.last_name) AS player_full_name,
t.name AS team_name,
sd.passing,
sd.shooting,
sd.speed
FROM coaches AS c 
JOIN players_coaches AS pc 
ON c.id = pc.coach_id
JOIN players As p
ON p.id = pc.player_id
JOIN skills_data AS sd
ON p.skills_data_id = sd.id
JOIN teams AS t 
ON t.id = p.team_id
ORDER BY coach_full_name, player_full_name DESC;


CREATE FUNCTION fn_stadium_team_name(stadium_name VARCHAR(30)) 
RETURNS TABLE(teams_name VARCHAR(50))
LANGUAGE plpgsql
AS 
$$
BEGIN
RETURN QUERY
            SELECT t.name
            FROM stadiums AS s 
            JOIN teams AS t 
            ON t.stadium_id = s.id 
            WHERE s.name = stadium_name
            ORDER BY t.name;

END;
$$


CREATE PROCEDURE sp_players_team_name(
                                        IN player_name VARCHAR(50),
                                        OUT team_name VARCHAR(45))
LANGUAGE plpgsql
AS 
$$
BEGIN
    SELECT
    COALESCE(t.name, 'The player currently has no team') INTO team_name
    FROM players AS p 
    LEFT JOIN teams AS t 
    ON p.team_id = t.id 
    WHERE CONCAT_WS(' ', p.first_name, p.last_name) = player_name;
END 
$$ 



CREATE PROCEDURE sp_players_team_name(
                                        IN player_name VARCHAR(50),
                                        OUT team_name VARCHAR(45))
LANGUAGE plpgsql
AS 
$$
BEGIN
    SELECT
    CASE 
        WHEN t.name IS NULL THEN 'The player currently has no team'
        ELSE t.name
    END INTO team_name
    FROM players AS p 
    LEFT JOIN teams AS t 
    ON p.team_id = t.id 
    WHERE CONCAT_WS(' ', p.first_name, p.last_name) = player_name;
END 
$$ 




