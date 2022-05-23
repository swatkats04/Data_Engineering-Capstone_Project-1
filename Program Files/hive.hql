--loading the data into hive tables
CREATE EXTERNAL TABLE departments
STORED AS AVRO LOCATION 'hdfs:///user/anabig11424/hive/warehouse/departments'
TBLPROPERTIES ('avro.schema.url'='/user/anabig11424/departments.avsc');

drop table if exists dept_emp;
CREATE EXTERNAL TABLE dept_emp
STORED AS AVRO LOCATION 'hdfs:///user/anabig11424/hive/warehouse/dept_emp'
TBLPROPERTIES ('avro.schema.url'='/user/anabig11424/dept_emp.avsc');

drop table if exists dept_manager;
CREATE EXTERNAL TABLE dept_manager
STORED AS AVRO LOCATION 'hdfs:///user/anabig11424/hive/warehouse/dept_manager'
TBLPROPERTIES ('avro.schema.url'='/user/anabig11424/dept_manager.avsc');

drop table if exists employees;
CREATE EXTERNAL TABLE employees
STORED AS AVRO LOCATION 'hdfs:///user/anabig11424/hive/warehouse/employees'
TBLPROPERTIES ('avro.schema.url'='/user/anabig11424/employees.avsc');

drop table if exists salaries;
CREATE EXTERNAL TABLE salaries
STORED AS AVRO LOCATION 'hdfs:///user/anabig11424/hive/warehouse/salaries'
TBLPROPERTIES ('avro.schema.url'='/user/anabig11424/salaries.avsc');

drop table if exists titles;
CREATE EXTERNAL TABLE titles
STORED AS AVRO LOCATION 'hdfs:///user/anabig11424/hive/warehouse/titles'
TBLPROPERTIES ('avro.schema.url'='/user/anabig11424/titles.avsc');

--viewing few records from the departments table
select * from departments limit 5;

--viewing few records from the dept_emp table
select * from dept_emp limit 5;

--viewing few records from the dept_manager table
select * from dept_manager limit 5;

--viewing few records from the employees table
select * from employees limit 5;

--viewing few records from the salaries table
select * from salaries limit 5;

--viewing few records from the titles table
select * from titles limit 5;



--EDA--
--A list showing employee number, last name, first name, sex, and salary for each employee1.
select s.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees as e
inner join salaries as s
on s.emp_no = e.emp_no
order by s.emp_no;

--List employees who were hired in 1986
SELECT emp_no, first_name, last_name, hire_date 
FROM employees
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY hire_date;

select first_name,last_name,hire_date,date_format(from_unixtime(unix_timestamp(cast(hire_date as string),'MM/dd/yyyy')),'yyyy-MM-dd') as hire_date1
from employees where date_format(from_unixtime(unix_timestamp(cast(hire_date as string),'MM/dd/yyyy')),'yyyy') = '1986' ;

--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;


-- List the department of each employee with the following information:employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no;

-- List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT employees.first_name, employees.last_name, employees.sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name Like 'B%'

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT departments.dept_name, employees.last_name, employees.first_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';


--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' 
OR departments.dept_name = 'Development';

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
select last_name,count(last_name) as Frequency 
from employees 
group by last_name
order by frequency desc;

--Histogram to show the salary distribution among the employees
select t1.emp_no,t2.emp_no,last_name,first_name,sex,t2.salary
from employees t1 
inner join salaries t2 
on t1.emp_no=t2.emp_no  
limit 5 ;

--sns.distplot(spark.sql("select emp_no , sum(salary) from salaries group by emp_no ").toPandas(), norm_hist= True)
--plt.show()  
-->using pandas dataframe with spark.sql we can plot the histogram

--Bar graph to show the average salary per title with respect to designation
select t1.title, avg(t3.salary) as average_salary
from titles t1 
inner join employees t2 
on t1.title_id = t2.emp_title_id
inner join salaries t3 
on t2.emp_no=t3.emp_no  
group by t1.title ;

--sns.barplot(x='title' , y='avg(salary)', data = spark.sql("select t.title, avg(s.salary) from employees e inner join titles t on e.emp_title_id = t.title_id inner join salaries s on e.emp_no = s.emp_no group by t.title").toPandas() )
--plt.show()
-->using pandas dataframe with spark.sql we can plot the Barplot

--Average salary of employees based on gender.
select employees.sex as gender, avg(salaries.salary) as average_salary from employees 
join salaries 
on employees.emp_no = salaries.emp_no 
group by employees.sex;

--Number of employees according to desingnation.
SELECT titles.title, COUNT(employees.emp_no)  FROM titles 
JOIN employees 
ON titles.title_id = employees.emp_title_id 
GROUP BY(titles.title);

--Gender distribution of employees
SELECT sex as gender , COUNT(emp_no) FROM employees GROUP BY sex;

--Count of employees based on their performance rating.
SELECT Last_performance_rating , COUNT(emp_no) FROM employees  Group BY last_performance_rating;


--Highest paid employees in the organization.
select employees.first_name, employees.last_name, sum(salaries.salary)
from employees 
left join salaries 
on employees.emp_no = salaries.emp_no 
group by employees.first_name, employees.last_name 
order by sum(salaries.salary) desc;
