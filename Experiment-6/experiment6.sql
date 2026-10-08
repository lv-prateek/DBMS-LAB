
-- ============================================
-- DBMS LAB - EXPERIMENT 6
-- Stored Procedures, Triggers & Audit Logging
-- MySQL 8.0+
-- ============================================

-- 1. CREATE DEPARTMENT TABLE

CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

-- 2. CREATE EMPLOYEE TABLE

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id)
        REFERENCES department(department_id)
);

-- 3. INSERT DEPARTMENTS

INSERT INTO department VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

-- 4. INSERT EMPLOYEES

INSERT INTO employee VALUES
(101, 'Amit', 1, 90000),
(102, 'Neha', 1, 65000),
(103, 'Rahul', 2, 60000),
(104, 'Priya', 3, 80000);

-- 5. CREATE SALARY AUDIT TABLE

CREATE TABLE salary_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 6. STORED PROCEDURE: TRANSFER EMPLOYEE
-- ============================================

DELIMITER //

CREATE PROCEDURE transfer_employee(
    IN emp_id INT,
    IN new_dept_id INT
)
BEGIN
    DECLARE employee_count INT DEFAULT 0;
    DECLARE department_count INT DEFAULT 0;

    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transfer failed. Transaction rolled back.'
            AS message;
    END;

    START TRANSACTION;

    -- Validate employee
    SELECT COUNT(*) INTO employee_count
    FROM employee
    WHERE employee_id = emp_id;

    IF employee_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;

    -- Validate department
    SELECT COUNT(*) INTO department_count
    FROM department
    WHERE department_id = new_dept_id;

    IF department_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';
    END IF;

    -- Transfer employee
    UPDATE employee
    SET department_id = new_dept_id
    WHERE employee_id = emp_id;

    COMMIT;

    SELECT 'Employee transferred successfully.'
        AS message;
END //

DELIMITER ;

-- ============================================
-- 7. TEST VALID EMPLOYEE TRANSFER
-- ============================================

CALL transfer_employee(102, 2);

SELECT * FROM employee
WHERE employee_id = 102;

-- ============================================
-- 8. TEST INVALID EMPLOYEE ID
-- ============================================

CALL transfer_employee(999, 2);

-- ============================================
-- 9. TEST INVALID DEPARTMENT ID
-- ============================================

CALL transfer_employee(102, 99);

-- ============================================
-- 10. SALARY VALIDATION BEFORE INSERT
-- ============================================

DELIMITER //

CREATE TRIGGER validate_salary_before_insert
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Salary must be greater than zero';
    END IF;
END //

DELIMITER ;

-- ============================================
-- 11. SALARY VALIDATION BEFORE UPDATE
-- ============================================

DELIMITER //

CREATE TRIGGER validate_salary_before_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Salary must be greater than zero';
    END IF;
END //

DELIMITER ;

-- ============================================
-- 12. SALARY AUDIT AFTER UPDATE
-- ============================================

DELIMITER //

CREATE TRIGGER salary_audit_after_update
AFTER UPDATE ON employee
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_audit
        (employee_id, old_salary, new_salary)
        VALUES
        (OLD.employee_id, OLD.salary, NEW.salary);
    END IF;
END //

DELIMITER ;

-- ============================================
-- 13. TEST INVALID SALARY UPDATE
-- Expected: SQL error from validation trigger
-- ============================================

UPDATE employee
SET salary = -5000
WHERE employee_id = 101;

-- ============================================
-- 14. TEST VALID SALARY UPDATE
-- ============================================

UPDATE employee
SET salary = 95000
WHERE employee_id = 101;

-- ============================================
-- 15. DISPLAY SALARY AUDIT RECORDS
-- ============================================

SELECT * FROM salary_audit;

-- ============================================
-- END OF EXPERIMENT 6
-- ============================================
