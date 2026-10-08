
-- ============================================
-- DBMS LAB - EXPERIMENT 4
-- ============================================
-- Aim: Demonstrate SQL Joins, Subqueries,
-- EXISTS, INTERSECT/EXCEPT simulations,
-- and EXPLAIN execution plan analysis.
--
-- Prerequisite: Run Experiment 3 first.
-- Database: enterprise_db
-- ============================================

USE enterprise_db;

-- ============================================
-- QUERY 1: INNER JOIN
-- Employee names with department and location
-- ============================================

SELECT e.emp_id, e.emp_name,
       d.dept_name, d.location
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.emp_name;


-- ============================================
-- QUERY 2: LEFT JOIN
-- Show all employees with project details
-- ============================================

SELECT e.emp_name,
       d.dept_name,
       p.project_name
FROM Employee e
LEFT JOIN Department d
ON e.dept_id = d.dept_id
LEFT JOIN Employee_Project ep
ON e.emp_id = ep.emp_id
LEFT JOIN Project p
ON ep.project_id = p.project_id
ORDER BY e.emp_id;


-- ============================================
-- QUERY 3: SELF JOIN
-- Compare employees from the same department
-- ============================================

SELECT a.emp_name AS employee_a,
       b.emp_name AS employee_b,
       d.dept_name
FROM Employee a
JOIN Employee b
ON a.dept_id = b.dept_id
AND a.emp_id < b.emp_id
JOIN Department d
ON a.dept_id = d.dept_id
ORDER BY d.dept_name, employee_a;


-- ============================================
-- QUERY 4: MULTI-TABLE JOIN
-- Employee, Department and Project details
-- ============================================

SELECT e.emp_name,
       d.dept_name,
       p.project_name,
       ep.hours_worked
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id
JOIN Employee_Project ep
ON e.emp_id = ep.emp_id
JOIN Project p
ON ep.project_id = p.project_id
WHERE ep.hours_worked >= 120
ORDER BY ep.hours_worked DESC;


-- ============================================
-- QUERY 5: CORRELATED SUBQUERY
-- Employees earning above department average
-- ============================================

SELECT e.emp_name,
       e.dept_id,
       e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(x.salary)
    FROM Employee x
    WHERE x.dept_id = e.dept_id
)
ORDER BY e.salary DESC;


-- ============================================
-- QUERY 6: EXISTS
-- Departments with salary above 85000
-- ============================================

SELECT d.dept_id, d.dept_name
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.dept_id = d.dept_id
    AND e.salary > 85000
)
ORDER BY d.dept_id;


-- ============================================
-- QUERY 7: SIMULATED INTERSECT
-- Employees working on projects and belonging
-- to departments with average salary > 75000
-- ============================================

SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project ep
    WHERE ep.emp_id = e.emp_id
)
AND e.dept_id IN (
    SELECT dept_id
    FROM Employee
    GROUP BY dept_id
    HAVING AVG(salary) > 75000
)
ORDER BY e.emp_id;


-- ============================================
-- QUERY 8: SIMULATED EXCEPT
-- Employees not assigned to Predictive AI
-- ============================================

SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE NOT EXISTS (
    SELECT 1
    FROM Employee_Project ep
    JOIN Project p
    ON ep.project_id = p.project_id
    WHERE ep.emp_id = e.emp_id
    AND p.project_name = 'Predictive AI'
)
ORDER BY e.emp_id;


-- ============================================
-- QUERY 9: EXPLAIN MULTI-TABLE JOIN
-- Analyze execution plan for project workload
-- ============================================

EXPLAIN
SELECT e.emp_name, d.dept_name,
       p.project_name, ep.hours_worked
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id
JOIN Employee_Project ep
ON e.emp_id = ep.emp_id
JOIN Project p
ON ep.project_id = p.project_id
WHERE ep.hours_worked >= 120
ORDER BY ep.hours_worked DESC;


-- ============================================
-- QUERY 10: EXPLAIN CORRELATED SUBQUERY
-- Analyze salary comparison query execution
-- ============================================

EXPLAIN
SELECT e.emp_name, e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(x.salary)
    FROM Employee x
    WHERE x.dept_id = e.dept_id
);

-- ============================================
-- END OF EXPERIMENT 4
-- ============================================
