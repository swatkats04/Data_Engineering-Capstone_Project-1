# Data_Engineering-Capstone_Project-1
An end to end data engineering project on employee data which includes performing tasks such as Data modeling, Data Engineering  and Data Analysis.

## Objective
To create a Data pipeline using various Big data technologies which include the Hadoop ecosystem, SparkSql, Hive, Impala, etc to analyze and come up with a solution to the organization needs. To perform Exploratory Data Analysis on the given data to come up with patterns and meaningful insights. With the help of Machine Learning model to analyze the employee retention rate of the organization.


## Data description

The dataset consists of six csv files and are uploaded in the [`Data`](/Data/) folder.  The files are namely :

1. titles.csv - This file contains different job titles with respect to the employees.
2. employees.csv - Contains all data related to individual employee, such as employee id, name, age, sex, date of hiring, etc.
3. salaries.csv - Employee salary.
4. departments.csv - List of various departments in the company.
5. dept_manager.csv - Talks about which employee manages which department.
6. dept_emp.csv - The department to which each employee belongs.


## Technology Stack

- MySQL
- Linux Commands
- Sqoop
- HDFS
- Hive
- Impala
- SparkSQL
- SparkML


## Overview

The data is initially present in the form csv, then imports the CSVs into a SQL database, and then analyze the data. The three phases include
- Data Modeling
- Data Engineering
- Data Analysis   

### Data Modeling

Looking at the CSVs data and build an ERD of the tables. The 'ER Diagram' folder contains the ER diagram and the schema code to build it.

### Data Engineering

- Using the information given to create a table schema for each of the six CSV files. Specify the data types, primary keys, foreign keys, and other constraints.
- Imports each CSV file into the corresponding SQL table.

### Data Analysis

After completing the database , do the required analysis and open the 'Program Files' and run the hive.hql to do the anlysis.


### File Execution
1. mysql.sql file
2. sqoop file
3. hive.hql
4. spark_ml
