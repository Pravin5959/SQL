-- Question 57
-- The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
-- +----+-------+--------+--------------+
-- | 1  | Joe   | 70000  | 1            |
-- | 2  | Jim   | 90000  | 1            |
-- | 3  | Henry | 80000  | 2            |
-- | 4  | Sam   | 60000  | 2            |
-- | 5  | Max   | 90000  | 1            |
-- +----+-------+--------+--------------+
-- The Department table holds all departments of the company.

-- +----+----------+
-- | Id | Name     |
-- +----+----------+
-- | 1  | IT       |
-- | 2  | Sales    |
-- +----+----------+
-- Write a SQL query to find employees who have the highest salary in each of the departments. 
-- For the above tables, your SQL query should return the following rows (order of rows does not matter).

-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Jim      | 90000  |
-- | Sales      | Henry    | 80000  |
-- +------------+----------+--------+
-- Explanation:

-- Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.
-- Explanation:
-- Step1 : As departmentId is available in the Employee table we can just apply window fucntion to calculate the highest salary
-- Step2 : Once we have calculated the window function we just have to join the table with the Department to get the result

WITH employee_extn AS (SELECT Name,
			      Salary,
			      DepartmentId,
			      DENSE_RANK() OVER(PARTITION BY DepartmentId ORDER BY Salary DESC) AS rnk
		       FROM Employee)

SELECT d.Name AS Department,
       e.Name AS Employee,
       e.Salary
FROM Department d
INNER JOIN employee_extn e
ON d.Id = e.DepartmentId
WHERE e.rnk = 1;
