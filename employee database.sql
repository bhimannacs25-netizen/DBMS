USE newdatabase;

CREATE TABLE departments (
    dept_number INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL
);


CREATE TABLE employees (
    emp_number INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    manager_number INT,
    dept_number INT NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_number) REFERENCES departments (dept_number),
    CONSTRAINT fk_emp_manager FOREIGN KEY (manager_number) REFERENCES employees (emp_number),
    CONSTRAINT chk_positive_salary CHECK (salary >= 0),
    CONSTRAINT chk_not_own_manager CHECK (emp_number <> manager_number)
);


CREATE TABLE projects (
    project_number INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);


CREATE TABLE project_assignments (
    emp_number INT,
    project_number INT,
    job_role VARCHAR(50) NOT NULL,
    
    PRIMARY KEY (emp_number, project_number),
    CONSTRAINT fk_assign_emp FOREIGN KEY (emp_number) REFERENCES employees (emp_number),
    CONSTRAINT fk_assign_project FOREIGN KEY (project_number) REFERENCES projects (project_number)
);


CREATE TABLE incentive_payments (
    incentive_id INT PRIMARY KEY,
    emp_number INT NOT NULL,
    incentive_date DATE NOT NULL,
    incentive_amount DECIMAL(10, 2) NOT NULL,
    
    CONSTRAINT fk_incentive_emp FOREIGN KEY (emp_number) REFERENCES employees (emp_number),
    CONSTRAINT chk_positive_incentive CHECK (incentive_amount >= 0)
);



INSERT INTO departments (dept_number, dept_name, location) VALUES
(10, 'Engineering', 'Bengaluru'),
(20, 'Human Resources', 'Hyderabad'),
(30, 'Sales & Marketing', 'Mysuru'),
(40, 'Finance', 'Bengaluru'),
(50, 'Research & Development', 'Chennai'),
(60, 'Operations', 'Mumbai');


INSERT INTO employees (emp_number, emp_name, manager_number, dept_number, hire_date, salary) VALUES
(1001, 'Rahul Sharma', NULL, 10, '2020-01-15', 150000.00), -- Top Level Manager
(1002, 'Priya Patel', 1001, 10, '2021-03-22', 95000.00),
(1003, 'Amit Verma', 1001, 20, '2022-06-01', 80000.00),
(1004, 'Sneha Rao', 1002, 30, '2023-01-10', 75000.00),
(1005, 'Vikram Singh', 1003, 40, '2024-05-18', 88000.00),
(1006, 'Kavitha Reddy', 1001, 10, '2025-02-01', 92000.00);


INSERT INTO projects (project_number, project_name, location) VALUES
(501, 'Cloud Migration', 'Bengaluru'),
(502, 'HR Portal Upgrade', 'Hyderabad'),
(503, 'Retail Expansion', 'Mysuru'),
(504, 'Fintech Core Engine', 'Bengaluru'),
(505, 'AI Sandbox Platform', 'Chennai'),
(506, 'Supply Chain Logistics', 'Delhi');


INSERT INTO project_assignments (emp_number, project_number, job_role) VALUES
(1001, 501, 'Lead Architect'),
(1002, 501, 'Backend Developer'),
(1003, 502, 'HR Specialist'),
(1004, 503, 'Marketing Lead'),
(1005, 504, 'Data Analyst'),
(1006, 505, 'ML Engineer');


INSERT INTO incentive_payments (incentive_id, emp_number, incentive_date, incentive_amount) VALUES
(9001, 1001, '2024-12-25', 15000.00),
(9002, 1003, '2025-01-05', 8000.00),
(9003, 1004, '2025-03-15', 5000.00),
(9004, 1005, '2025-06-20', 7000.00),
(9005, 1001, '2025-12-25', 20000.00),
(9006, 1003, '2026-01-10', 9000.00);



SELECT DISTINCT emp_number 
FROM project_assignments pa
JOIN projects p ON pa.project_number = p.project_number
WHERE p.location IN ('Bengaluru', 'Hyderabad', 'Mysuru');


SELECT emp_number 
FROM employees
WHERE emp_number NOT IN (SELECT emp_number FROM incentive_payments);


SELECT 
    e.emp_name, 
    e.emp_number, 
    d.dept_name, 
    pa.job_role, 
    d.location AS department_location, 
    p.location AS project_location
FROM employees e
JOIN departments d ON e.dept_number = d.dept_number
JOIN project_assignments pa ON e.emp_number = pa.emp_number
JOIN projects p ON pa.project_number = p.project_number
WHERE d.location = p.location;



SELECT 
    m.emp_name AS manager_name, 
    COUNT(e.emp_number) AS total_direct_reports
FROM employees e
JOIN employees m ON e.manager_number = m.emp_number
GROUP BY m.emp_number, m.emp_name
HAVING COUNT(e.emp_number) = (
    SELECT MAX(report_count) 
    FROM (
        SELECT COUNT(*) AS report_count 
        FROM employees 
        WHERE manager_number IS NOT NULL 
        GROUP BY manager_number
    ) sub
);


SELECT 
    m.emp_number AS manager_id,
    m.emp_name AS manager_name, 
    m.salary AS manager_salary,
    ROUND(AVG(e.salary), 2) AS average_team_salary
FROM employees e
JOIN employees m ON e.manager_number = m.emp_number
GROUP BY m.emp_number, m.emp_name, m.salary
HAVING m.salary > AVG(e.salary);


SELECT 
    d.dept_name,
    e.emp_number AS top_manager_id,
    e.emp_name AS top_manager_name
FROM employees e
JOIN departments d ON e.dept_number = d.dept_number
WHERE e.manager_number IS NULL;


WITH ranked_incentives AS (
    SELECT 
        emp_number,
        incentive_amount,
        DENSE_RANK() OVER (ORDER BY incentive_amount DESC) as incentive_rank
    FROM incentive_payments
    WHERE incentive_date >= '2019-02-01' AND incentive_date <= '2019-02-28'
)
SELECT 
    e.*, 
    ri.incentive_amount,
    ri.incentive_rank
FROM employees e
JOIN ranked_incentives ri ON e.emp_number = ri.emp_number
WHERE ri.incentive_rank = 2;


SELECT 
    e.emp_number AS employee_id,
    e.emp_name AS employee_name,
    m.emp_name AS manager_name,
    d.dept_name AS shared_department
FROM employees e
JOIN employees m ON e.manager_number = m.emp_number
JOIN departments d ON e.dept_number = d.dept_number
WHERE e.dept_number = m.dept_number;
