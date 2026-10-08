
-- DBMS LAB - EXPERIMENT 3
-- Aim: Employee-Department-Project Database
-- Topics: Selection, Projection, Aggregate Functions,
-- GROUP BY, HAVING, CASE, ORDER BY

CREATE DATABASE enterprise_db;
USE enterprise_db;

-- 1. CREATE TABLES

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(80) NOT NULL,
    budget DECIMAL(12,2)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(60) NOT NULL,
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Employee_Project (
    emp_id INT,
    project_id INT,
    hours_worked INT,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

-- 2. INSERT DEPARTMENTS

INSERT INTO Department VALUES
(1,'Research & Development','Tower A'),
(2,'Sales','Tower B'),
(3,'Finance','Tower C'),
(4,'Customer Support','Tower D'),
(5,'Operations','Tower E');

-- 3. INSERT PROJECTS

INSERT INTO Project VALUES
(201,'Smart Inventory',1750000),
(202,'FinTech Portal',2400000),
(203,'CRM Revamp',1350000),
(204,'Cloud Security',2800000),
(205,'Predictive AI',3100000),
(206,'Logistics Suite',1900000),
(207,'HR Automation',1100000),
(208,'Mobile Commerce',1600000);

-- 4. INSERT 30 EMPLOYEES

INSERT INTO Employee VALUES
(1,'Vihaan Sharma',1,91000,'2022-01-14'),
(2,'Myra Kapoor',1,83000,'2023-05-21'),
(3,'Reyansh Mehta',1,97000,'2021-07-09'),
(4,'Kiara Nair',1,76000,'2024-01-18'),
(5,'Atharv Joshi',1,88000,'2022-11-27'),
(6,'Anvi Rao',1,72000,'2024-06-03'),
(7,'Dhruv Bhatia',2,69000,'2023-02-12'),
(8,'Navya Iyer',2,75000,'2022-08-17'),
(9,'Ayaan Sethi',2,62000,'2024-03-06'),
(10,'Tara Malhotra',2,81000,'2021-10-24'),
(11,'Rudra Shah',2,73000,'2023-09-15'),
(12,'Ishani Arora',2,66000,'2024-05-02'),
(13,'Samar Jain',3,94000,'2021-03-11'),
(14,'Aarohi Sen',3,87000,'2022-06-29'),
(15,'Yuvan Khanna',3,99000,'2020-12-18'),
(16,'Avika Das',3,78000,'2023-04-07'),
(17,'Parth Sood',3,85000,'2022-09-13'),
(18,'Mahi Kapoor',3,71000,'2024-02-26'),
(19,'Aadvik Roy',4,64000,'2023-01-31'),
(20,'Zoya Khan',4,70000,'2022-07-16'),
(21,'Laksh Verma',4,59000,'2024-04-12'),
(22,'Sia Gupta',4,68000,'2023-11-08'),
(23,'Rishaan Bose',4,76000,'2021-05-19'),
(24,'Amaira Singh',4,61000,'2024-07-22'),
(25,'Arnav Pillai',5,82000,'2022-02-04'),
(26,'Vanya Dutta',5,74000,'2023-06-18'),
(27,'Kiaan Yadav',5,93000,'2021-09-25'),
(28,'Ira Mukherjee',5,67000,'2024-01-30'),
(29,'Kabir Chawla',5,89000,'2022-12-05'),
(30,'Rhea Thomas',5,78000,'2023-08-14');

-- 5. ASSIGN EMPLOYEES TO PROJECTS

INSERT INTO Employee_Project VALUES
(1,205,145),(2,201,110),(3,205,160),
(4,203,90),(5,204,125),(6,207,80),
(7,202,105),(8,208,115),(9,203,75),
(10,202,135),(11,206,100),(12,207,70),
(13,204,150),(14,205,130),(15,202,165),
(16,208,95),(17,201,120),(18,206,85),
(19,203,105),(20,207,90),(21,208,65),
(22,203,100),(23,206,140),(24,207,75),
(25,201,130),(26,206,95),(27,204,155),
(28,208,80),(29,205,145),(30,201,105);

-- QUERY 1: SELECTION

SELECT emp_id, emp_name, salary, hire_date
FROM Employee
WHERE hire_date >= '2023-01-01'
AND salary > 75000
ORDER BY hire_date;

-- QUERY 2: PROJECTION

SELECT emp_name, salary, dept_id
FROM Employee
ORDER BY emp_name;

-- QUERY 3: AGGREGATE FUNCTIONS + GROUP BY

SELECT dept_id,
COUNT(emp_id) AS staff_count,
SUM(salary) AS payroll,
ROUND(AVG(salary),2) AS mean_salary,
MAX(salary) AS highest_salary
FROM Employee
GROUP BY dept_id
ORDER BY payroll DESC;

-- QUERY 4: HAVING CLAUSE

SELECT dept_id,
COUNT(*) AS staff_count,
SUM(salary) AS payroll
FROM Employee
GROUP BY dept_id
HAVING SUM(salary) > 430000
ORDER BY payroll DESC;

-- QUERY 5: CASE EXPRESSION

SELECT emp_name, salary,
CASE
    WHEN salary >= 90000 THEN 'Executive'
    WHEN salary >= 75000 THEN 'Professional'
    ELSE 'Associate'
END AS salary_level
FROM Employee
ORDER BY salary DESC, emp_name;

-- QUERY 6: PROJECT-WISE WORKLOAD

SELECT p.project_name,
COUNT(ep.emp_id) AS assigned_employees,
SUM(ep.hours_worked) AS total_hours,
ROUND(AVG(ep.hours_worked),2) AS avg_hours
FROM Project p
LEFT JOIN Employee_Project ep
ON p.project_id = ep.project_id
GROUP BY p.project_id, p.project_name
ORDER BY total_hours DESC;

-- QUERY 7: EMPLOYEES WORKING MORE THAN 120 HOURS

SELECT e.emp_name, p.project_name, ep.hours_worked
FROM Employee e
JOIN Employee_Project ep
ON e.emp_id = ep.emp_id
JOIN Project p
ON ep.project_id = p.project_id
WHERE ep.hours_worked > 120
ORDER BY ep.hours_worked DESC;

-- VERIFY THE DATABASE

SELECT * FROM Department;
SELECT * FROM Employee;
SELECT * FROM Project;
