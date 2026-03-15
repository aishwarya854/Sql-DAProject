
--- Window Function as group by function except they dont roll up into 1 row like row no. , rank, dense rank

SELECT gender, AVG(salary) avg_salary  # normal query is usually
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;

SELECT dem.first_name, dem.last_name, gender,salary, 
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_total    # rolling total adding subsequent rows as in dcf model
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- complex
SELECT dem.employee_id, dem.first_name, dem.last_name, gender,salary, 
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.employee_id, dem.first_name, dem.last_name, gender,salary, 
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) rank_num,                 # skip the rank after getting no
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) dense_rank_num      # dont skip even when 2 peple get same rank no duplicates
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
-- CTEs - Common table expression allow u to define subquery block that u can reference within the main query may not make perfect sense its like within query, rename it and standardized it, better formatted than actual query
-- CTE are unique as we are gonna only use it immediately after creating it 
-- CTE are not stored or save in memory its just aiveyhi used to not used or we doing doing anything by this code just a regular query
-- CTE cant be reuse 

WITH CTE_Example AS
(
SELECT gender,
AVG(salary) AS avg_sal,
MAX(salary) AS max_sal, 
MIN(salary) AS min_sal, 
COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *                 # or SELECT AVG(avg_sal) can be used to find avg salary
FROM CTE_Example
;

WITH CTE_Example (Gender, AVG_SAL, MAX_SAL, MIN_SAL, COUNT_SAL) AS     # use to overwrite column names
(
SELECT gender,AVG(salary) AS avg_sal,MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *                 
FROM CTE_Example
;

SELECT AVG(avg_sal)
FROM (SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) example_subquery
; # both the queries gives same result but is not preferred much

-- Multiple/ Complex CTE

WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date 
FROM employee_demographics 
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS 
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *                
FROM CTE_Example ex1
JOIN CTE_Example2 ex2
	ON ex1.employee_id = ex2.employee_id
;


-- Temporary Tables - are the tables that are only visible during the session that they r created in 
-- used to store intermediate result for complex queries somewhat like CTE, also used to manipulate data before making it permanent

-- Method 1
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favourite_movie varchar(100) 
);
SELECT * 
FROM temp_table;    # table can be use multiple times

INSERT INTO temp_table
VALUES('Aishwarya','Raut','Sarvaam Maya'),
('Ankit','Raut','Hwarang');

SELECT * 
FROM temp_table;

SELECT *
 FROM employee_salary;

CREATE TEMPORARY TABLE  salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT * 
FROM salary_over_50k;

-- Store procedures  are way to save ur SQL code to reuse it over n over n use it to execute code that u wrote within procedure
-- storing complex queries and simplifying repetitive code & enhancing performance overall

-- very very simple query example
CREATE PROCEDURE large_salary() 
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salary(); 
-- Combo query
CREATE PROCEDURE large_salary2() 
SELECT *
FROM employee_salary
WHERE salary >= 50000;
SELECT *
FROM employee_salary
WHERE salary >= 20000;
CALL large_salary2(); 


CREATE PROCEDURE large_salary2() 
SELECT *
FROM employee_salary
WHERE salary >= 50000;
SELECT *
FROM employee_salary
WHERE salary >= 20000;
CALL large_salary(); 


CREATE PROCEDURE large_salary2() 
SELECT *
FROM employee_salary
WHERE salary >= 50000;
SELECT *
FROM employee_salary
WHERE salary >= 20000;
CALL large_salary2(); 

DELIMITER $$
CREATE PROCEDURE large_salary3()  # Use DELIMITERs like $$ or //. BEST practise
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 20000;
END $$
DELIMITER ;
CALL large_salary3();

-- PARAMETERs are the vaiables that are passed as an input into store procedure, they allow it to accept an input value into it.

DELIMITER $$
CREATE PROCEDURE large_salary4(p_employee_id INT)  #p stands for parameter can also be written as employee_id_param
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = p_employee_id
    ;
END $$
DELIMITER ;
CALL large_salary4(1);

-- TRIGGERs N EVENTs
-- TRIGGER - write it when data is updated into the salary and also into employee_demographics.
-- (In some sql db like microsoft sql server have functions like BATCH TRIGGERS / TABLE LEVEL TRIGGERS that will trigger once for all data inserted)

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

DELIMITER $$   # this data is stored in Table > employee_salary> triggers folder. --not into stored procedures
CREATE TRIGGER employee_data
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;     # this data does nothing, cant change, not alter / drop

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Edward', 'Cullen', 'Twilight CEO', 10000000, NULL);

-- EVENTs ~ trigger; trigger occurs when events takes place whereas events takes place when it is scheduled. so this ismore of scheduled automater rrather than the trigger.
-- important when importing data - to pull data from specific file path on schedule
-- build reports that r exported to a file on schedule- daily/ weekly/ monthly/ yearly, helpful for Automation in general 

SELECT * 
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retiree
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
DELETE
FROM employee_demographics
WHERE age >= 60
;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';