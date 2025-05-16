CREATE TABLE employees(
id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
hire_date DATE,
department_id INT
);

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE salaries(
employee_id INT,
salary INT,
from_date DATE,
to_date DATE,
FOREIGN KEY(employee_id) REFERENCES employees(id)
);

CREATE TABLE projects(
id INT PRIMARY KEY,
name VARCHAR(50),
start_date DATE,
end_date DATE
);

CREATE TABLE employee_projects(
employee_id INT,
project_id INT,
role VARCHAR(50),
allocation_percent INT,
FOREIGN KEY(employee_id) REFERENCES employees(id),
FOREIGN KEY(project_id) REFERENCES projects(id)
);


INSERT INTO employees (id, first_name, last_name, hire_date, department_id) VALUES
(1, 'Alice', 'Johnson', '2015-06-23', 2),
(2, 'Bob', 'Smith', '2018-03-15', 1),
(3, 'Charlie', 'Lee', '2020-11-01', 2),
(4, 'Diana', 'Garcia', '2017-01-10', 3),
(5, 'Ethan', 'Brown', '2022-08-12', 4);

INSERT INTO departments (id, department_name) VALUES
(1, 'Human Resources'),
(2, 'Engineering'),
(3, 'Marketing'),
(4, 'Finance');

INSERT INTO salaries (employee_id, salary, from_date, to_date) VALUES
(1, 80000, '2020-01-01', '2023-01-01'),
(1, 90000, '2023-01-02', '9999-12-31'),
(2, 60000, '2018-03-15', '9999-12-31'),
(3, 70000, '2020-11-01', '9999-12-31'),
(4, 75000, '2017-01-10', '2022-01-10'),
(4, 85000, '2022-01-11', '9999-12-31'),
(5, 72000, '2022-08-12', '9999-12-31');

INSERT INTO projects (id, name, start_date, end_date) VALUES
(1, 'Website Redesign', '2022-01-01', '2022-06-30'),
(2, 'Mobile App Launch', '2021-05-15', '2022-05-15'),
(3, 'Internal Audit', '2023-02-01', '2023-04-30'),
(4, 'Marketing Campaign', '2023-08-01', '2023-12-31');

INSERT INTO employee_projects (employee_id, project_id, role, allocation_percent) VALUES
(1, 1, 'Developer', 50),
(1, 2, 'Lead Developer', 50),
(2, 3, 'Analyst', 100),
(3, 1, 'Tester', 100),
(4, 4, 'Coordinator', 75),
(5, 4, 'Graphic Designer', 25);

SELECT * FROM employees
SELECT * FROM departments
SELECT * FROM salaries
SELECT * FROM projects
SELECT * FROM employee_projects

--Get the full names of employees hired after 2020.
SELECT first_name || ' ' || last_name AS full_name
FROM employees
WHERE 'hire_date' > '2020-01-01'

--List departments in alphabetical order.
SELECT department_name FROM departments
ORDER BY department_name ASC


-- Find the number of employees in each department.
SELECT d.department_name, COUNT(e.id) AS Total_Employee
FROM departments d
LEFT JOIN employees e 
ON d.id = e.department_id
GROUP BY d.department_name;

-- Show each employee’s name and their current salary (i.e. where to_date = '9999-12-31').
SELECT e.first_name || ' ' || e.last_name AS Employee_name, s.salary
FROM employees e
LEFT JOIN salaries s
ON e.id = s.employee_id
WHERE s.to_date = '9999-12-31'
ORDER BY s.salary ASC;

-- Get the hire date and department name of employee Charlie Lee.
SELECT e.hire_date, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.id
WHERE first_name = 'Charlie' AND last_name = 'Lee';

-- List employees working in the Engineering department.
SELECT e.first_name, e.last_name 
FROM employees e
JOIN departments d
ON e.department_id = d.id
WHERE d.department_name = 'Engineering'

-- Show employee names and their roles in any project.
SELECT e.first_name ||' '|| e.last_name AS Employee_Name, p.role 
FROM employees e
JOIN employee_projects p
ON e.id = p.employee_id

-- Get all projects that started in 2023.
SELECT name FROM projects
WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31'

-- Show all employees who have a salary greater than 75,000.
SELECT e.first_name ||' '|| e.last_name AS Employee_Name, SUM(s.salary) FROM employees e
JOIN salaries s
ON e.id = s.employee_id
WHERE s.salary > 75000
GROUP BY Employee_Name;

SELECT DISTINCT e.first_name, e.last_name
FROM employees e
JOIN salaries s ON e.id = s.employee_id
WHERE s.salary > 75000;

-- List employees who have worked on more than 1 project.
SELECT e.first_name ||' '|| e.last_name AS Employees
FROM employee_projects p
JOIN employees e
ON p.employee_id  = e.id
GROUP BY e.first_name, e.last_name, p.employee_id
HAVING COUNT(DISTINCT p.project_id) > 1;

-- Get average salary for each department.
SELECT d.department_name, AVG(s.salary) AS Average_Salary
FROM employees e 
JOIN departments d ON e.department_id = d.id
JOIN salaries s ON e.id = s.employee_id
WHERE s.to_date = '9999-12-31'
GROUP BY d.department_name;

-- Find the total number of employees who never worked on any project.
SELECT count(*) AS Farigh
FROM employees e
LEFT JOIN employee_projects p ON e.id = p.employee_id
WHERE p.project_id IS NULL;

--List employees with no salary changes.
SELECT employee_id FROM salaries
GROUP BY employee_id
HAVING COUNT(DISTINCT salary) = 1;

-- Show project names along with the number of employees involved in each.
SELECT p.name, COUNT(e.employee_id) AS Nubmer_Employees
FROM projects p
LEFT JOIN employee_projects e 
ON p.id = e.employee_id
GROUP BY p.name

-- For each employee, show their full name and how many projects they worked on.
SELECT e.first_name ||' '|| e.last_name AS full_name, COUNT(p.project_id)
FROM employees e
JOIN employee_projects p
ON e.id = p.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY COUNT(p.project_id) ASC

SELECT e.first_name || ' ' || e.last_name AS full_name, COUNT(ep.project_id) AS project_count
FROM employees e
LEFT JOIN employee_projects ep ON e.id = ep.employee_id
GROUP BY e.id, full_name;

-- Get the highest salary in each department.
SELECT d.department_name, MAX(s.salary) AS Total
FROM employees e
JOIN salaries s ON e.id = s.employee_id
JOIN departments d ON e.department_id = d.id
WHERE to_date = '9999-12-31'
GROUP BY d.department_name

-- Show all employees whose name starts with ‘A’ or ends with ‘n’.
SELECT first_name, last_name
FROM employees
WHERE first_name Like 'A%' OR first_name Like '%n'

-- Find all roles in projects with allocation percent less than 50.

SELECT role, allocation_percent FROM employee_projects
WHERE allocation_percent < 50

-- List employees hired before 2018 and currently working on any project.
SELECT DISTINCT e.first_name ||' '|| e.last_name AS Name, ep.project_id
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
WHERE hire_date < '2018-01-01'


SELECT 
  e.first_name || ' ' || e.last_name AS Name,
  STRING_AGG(ep.project_id::text, ', ') AS project_ids
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
WHERE e.hire_date < '2018-01-01'
GROUP BY e.first_name, e.last_name;


-- Show departments with average salary greater than 75,000.
SELECT * FROM employees
SELECT * FROM departments
SELECT * FROM salaries
SELECT * FROM projects
SELECT * FROM employee_projects


SELECT d.department_name, AVG(s.salary) AS salary
FROM employees e
JOIN salaries s ON e.id = s.employee_id
JOIN departments d ON e.department_id = d.id
GROUP BY d.department_name, s.to_date
HAVING AVG(s.salary) > 75000 AND s.to_date >= '9999-01-01'

-- For each project, list the names of employees and their roles in that project.
SELECT p.project_name, e.first_name || ' ' || e.last_name AS employee_name, ep.role
FROM projects p
JOIN employee_projects ep ON p.id = ep.project_id
JOIN employees e ON ep.employee_id = e.id
ORDER BY p.project_name;

-- Find employees who have worked on a project during their first year of employment.
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
JOIN employee_projects ep ON e.id = ep.employee_id
JOIN projects p ON ep.project_id = p.id
WHERE p.start_date BETWEEN e.hire_date AND e.hire_date + INTERVAL '1 year';


-- Show all salary changes for employees in the Marketing department.
SELECT e.first_name, e.last_name, s.salary, s.from_date, s.to_date
FROM employees e
JOIN salaries s ON e.id = s.employee_id
JOIN departments d ON e.department_id = d.id
WHERE d.department_name = 'Marketing'
ORDER BY e.id, s.from_date;























