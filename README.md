# Employee-Management-Company-Schema-sql

# 📊 SQL Practice Project — Employee Management Database

This project contains a small relational database and a comprehensive set of SQL practice questions ranging from beginner to advanced level. It is designed to simulate a realistic company HR system with employees, departments, salaries, projects, and project assignments.

---

## Database Schema

```text
+------------------+        +-------------------+
|   departments    |        |     employees     |
+------------------+        +-------------------+
| id (PK)          |◄───────┤ department_id     |
| department_name  |        | id (PK)           |
+------------------+        | first_name        |
                            | last_name         |
                            | hire_date         |
                            +-------------------+

+------------------+        +-------------------+
|     salaries     |        |     projects      |
+------------------+        +-------------------+
| employee_id (FK) |        | id (PK)           |
| salary           |        | project_name      |
| from_date        |        | start_date        |
| to_date          |        | end_date          |
+------------------+        +-------------------+

+-----------------------------+
|      employee_projects      |
+-----------------------------+
| employee_id (FK)            |
| project_id (FK)             |
| role                        |
| allocation_percent          |
+-----------------------------+
