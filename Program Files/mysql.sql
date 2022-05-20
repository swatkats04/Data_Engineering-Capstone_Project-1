#login into Mysql shell using your username and password
mysql -u anabig11424 -p

#use the database anabig11424 for table creation
USE anabig11424;
#show all the available database
SHOW databases;
#show all the available tables in the specified database
SHOW tables; 

#dropping the existing tables incase they have similar table names and schema  
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

#creating the table schemas for our data
CREATE TABLE departments (dept_no VARCHAR(20),dept_name VARCHAR(20));
CREATE TABLE dept_emp (emp_no VARCHAR(20),dept_no VARCHAR(20));
CREATE TABLE dept_manager (dept_no VARCHAR(20), emp_no VARCHAR(20));
CREATE TABLE employees (emp_no VARCHAR(20),emp_title_id VARCHAR(20),birth_date VARCHAR(20),first_name VARCHAR(20),last_name VARCHAR(20),sex VARCHAR(20),hire_date VARCHAR(20),no_of_projects VARCHAR(20),Last_performance_rating VARCHAR(20),left_ VARCHAR(20),last_date VARCHAR(20));
CREATE TABLE salaries (emp_no VARCHAR(20),salary VARCHAR(20));
CREATE TABLE titles (title_id VARCHAR(20),title VARCHAR(20));

#loading the data from ftp to the Mysql tables
LOAD DATA LOCAL INFILE '/home/anabig11424/Data/departments.csv' INTO TABLE departments FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ignore 1 rows;
LOAD DATA LOCAL INFILE '/home/anabig11424/Data/dept_emp.csv' INTO TABLE dept_emp FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ignore 1 rows;
LOAD DATA LOCAL INFILE '/home/anabig11424/Data/dept_manager.csv' INTO TABLE dept_manager FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ignore 1 rows;
LOAD DATA LOCAL INFILE '/home/anabig11424/Data/employees.csv' INTO TABLE employees FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ignore 1 rows;
LOAD DATA LOCAL INFILE '/home/anabig11424/Data/salaries.csv' INTO TABLE salaries FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ignore 1 rows;
LOAD DATA LOCAL INFILE '/home/anabig11424/Data/titles.csv' INTO TABLE titles FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' ignore 1 rows;

#selecting few records from each table to check if the data was loaded into the table successfully
select * from departments limit 5;
select * from dept_emp limit 5;
select * from dept_manager limit 5;
select * from employees limit 5;
select * from salaries limit 5;
select * from titles limit 5;

