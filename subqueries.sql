use practice; 
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id VARCHAR(10),
    salary INT
);
INSERT INTO Employee (emp_id, name, department_id, salary)
VALUES
(101, 'Abhishek', 'D01', 82000),
(102, 'Shubham', 'D01', 58000),
(103, 'Priya', 'D02', 67000),
(104, 'Rohit', 'D02', 64000),
(105, 'Neha', 'D03', 72000),
(106, 'Aman', 'D03', 55000),
(107, 'Ravi', 'D04', 60000),
(108, 'Sneha', 'D04', 75000),
(109, 'Kiran', 'D05', 70000),
(110, 'Tanuja', 'D05', 65000);
CREATE TABLE Department (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);
INSERT INTO Department (department_id, department_name, location)
VALUES
('D01', 'Sales', 'Mumbai'),
('D02', 'Marketing', 'Delhi'),
('D03', 'Finance', 'Pune'),
('D04', 'HR', 'Bengaluru'),
('D05', 'IT', 'Hyderabad');
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount INT,
    sale_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);
INSERT INTO Sales (sale_id, emp_id, sale_amount, sale_date)
VALUES
(201, 101, 4500, '2025-01-05'),
(202, 102, 7800, '2025-01-10'),
(203, 103, 6700, '2025-01-14'),
(204, 104, 12000, '2025-01-20'),
(205, 105, 9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107, 3200, '2025-02-09'),
(208, 108, 5100, '2025-02-15'),
(209, 109, 3900, '2025-02-20'),
(210, 110, 7200, '2025-03-01');
select * from Employee;
select * from Department;
select * from Sales;

# Basic Level
# 1.Retrieve the names of employees who earn more than the average salary of all employees.
select name, salary from Employee where salary > (select avg(salary) as Average_Salary from Employee);
# 2.Find the employees who belong to the department with the highest average salary.
select name, department_id from Employee where department_id=
(select department_id from employee group by department_id 
order by avg(salary) desc limit 1
);
#3.List all employees who have made at least one sale.
select emp_id,name from employee     
where emp_id in 
(select emp_id from Sales);
#4. Find the employee with the highest sale amount.
select e.name ,s.sale_amount from Employee e join sales s on e.emp_id = s.emp_id 
where s.sale_amount = (select max(sale_amount) from sales); 
#5. Retrieve the names of employees whose salaries are higher than Shubham’s salary. 
select name , salary from Employee where salary >(select salary from Employee where name ="Shubham");

#Intermediate

#1. Find employees who work in the same department as Abhishek.
select name from Employee where department_id = (select department_id from Employee where name ="Abhishek") and name != "Abhishek";

#2. List departments that have at least one employee earning more than ₹60,000.
select department_name from Department where department_id in(select department_id from Employee 
where salary > 60000);
select department_name from Department where exists (select department_id from Employee 
where Department.department_id = Employee.department_id and salary > 60000);

#3. Find the department name of the employee who made the highest sale.
select department_name from Department where department_id=(select department_id from Employee  where emp_id=
(select emp_id from Sales order by sale_amount desc limit 1));

select d.department_name from employee e 
join department d on e.department_id = d.department_id 
join sales s on e.emp_id = s.emp_id
where s.sale_amount = (select max(sale_amount) from Sales);

#4 Retrieve employees who have made sales greater than the average sale amount.
select name from Employee 
where emp_id in (select emp_id from Sales where sale_amount> (select avg(sale_amount) from Sales));

#5 Find the total sales made by employees who earn more than the average salary.
select sum(sale_amount)as Total_Sales from Sales 
where emp_id in (select emp_id from Employee where salary> (select avg(salary)from Employee));

#advance

#1.Find employees who have not made any sales.
select name from Employee where emp_id not in (select emp_id from Sales );
#2.List departments where the average salary is above ₹55,000.
select department_name from Department 
where department_id in (select department_id from Employee group by  department_id having avg(salary)>55000);
#3.Retrieve department names where the total sales exceed ₹10,000.
select department_name from Department  where department_id in
(select e.department_id from Employee e join Sales s on e.emp_id = s.emp_id
group by e.department_id having sum(s.sale_amount)>10000);
#4. Find the employee who has made the second-highest sale.
select name from Employee 
where emp_id=(select emp_id from Sales 
where sale_amount =(select max(sale_amount) from Sales
where amount < (
            SELECT MAX(sale_amount)
            FROM sales)));
#5.Retrieve the names of employees whose salary is greater than the highest sale amount recorded.
select name from Employee 
where salary > (select max(sale_amount) from Sales ) ;
