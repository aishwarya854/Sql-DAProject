SELECT *
FROM parks_and_recreation.employee_demographics;


SELECT first_name, 
last_name,
age,
age + 10
FROM parks_and_recreation.employee_demographics;
# BODMAS rule applicable

# To seen unique value DISTINCT funtion is used;
SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics;


-- WHERE Clause
SELECT * 
FROM employee_salary
WHERE first_name = 'leslie'
;
# salary filter
SELECT * 
FROM employee_salary
WHERE salary >= 50000
;

SELECT *
FROM employee_demographics
WHERE gender != 'male' 
;

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01' 
;

-- LOGICAL operator -- AND OR NOT
SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01' 
AND gender != 'male'
;
-- OR Statement
SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01' 
OR gender = 'Female'
;

SELECT *
FROM employee_demographics
WHERE (first_name = 'Tom' AND age = 36) OR (age > 40 AND gender = 'Male')
;

-- LIKE Statement
-- % - for anything that comes before or after /-- __ - put no. of alphabets/characters that comes like if Ann write it as A__

SELECT *
FROM employee_demographics
WHERE (first_name LIKE 'A___%' OR first_name LIKE '%er%')
;

-- GROUP BY Function
SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)         # Aggregate values
FROM employee_demographics
GROUP BY gender
;

-- ORDER BY
SELECT *
FROM employee_demographics
ORDER BY gender, age DESC          # can be represented as ORDER BY 5,4 means 5th gender column and 4th for age---not preferrable
;

-- HAVING VS WHERE 
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000      # HAVING is use to filter  aggregate funtion columns
;


-- Limit & Aliasing (how many rows u want in ur o/p, aliasing- change name of column)

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 4
;

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2,2
;
-- Aliasing
SELECT gender, AVG(age) AS avg_age     # even if AS is not written, will give us same result
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;

-- JOINS 
SELECT * 
FROM employee_demographics AS dem
JOIN employee_salary AS sal           # by default means INNER JOIN 
	ON dem.employee_id = sal.employee_id
;

SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
JOIN employee_salary AS sal           # by default means INNER JOIN 
	ON dem.employee_id = sal.employee_id
;

-- OUTER JOINS

SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal           # LEFT JOIN - similar for RIGHT JOIN
	ON dem.employee_id = sal.employee_id
;

-- SELF JOIN (joins to itself) for e.g to assign secret santa for christmas party

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS id,
emp2.first_name AS first_name,
emp2.last_name AS last_name
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

-- Joining multiple tables together

SELECT * 
FROM employee_demographics AS dem
JOIN employee_salary AS sal          
	ON dem.employee_id = sal.employee_id
JOIN parks_departments pd
	ON sal.dept_id = pd.department_id
;

-- UNIONS 

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
 FROM employee_salary;
 
 SELECT first_name, last_name, 'Old Man' Label     # to segregate old people to save money and identify high paying employee
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' Label    
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;
