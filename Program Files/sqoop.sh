#remove the existing data from hdfs incase the below tables were created in the past
hdfs dfs -rm -r /user/anabig11424/hive/warehouse/departments
hdfs dfs -rm -r /user/anabig11424/hive/warehouse/dept_emp
hdfs dfs -rm -r /user/anabig11424/hive/warehouse/dept_manager
hdfs dfs -rm -r /user/anabig11424/hive/warehouse/employees
hdfs dfs -rm -r /user/anabig11424/hive/warehouse/salaries
hdfs dfs -rm -r /user/anabig11424/hive/warehouse/titles

#removing the pre-exising warehouse directory from hdfs(hive)
hdfs dfs -rm -r /user/anabig11424/hive/warehouse

###sqoop job to transfer the data from MySQL to hdfs
#display the list of databases in MySql using sqoop command
sqoop list-databases --connect jdbc:mysql://ip-10-1-1-204.ap-south-1.compute.internal:3306 --username anabig11424 --password Bigdata123
#display the list of tables in the database in  mysql using sqoop command
sqoop list-tables --connect jdbc:mysql://ip-10-1-1-204.ap-south-1.compute.internal:3306/anabig11424 --username anabig11424 --password Bigdata123
#to import all tables into hdfs(warehouse) as avrodatafile format using sqoop command
sqoop import-all-tables --connect jdbc:mysql://ip-10-1-1-204.ap-south-1.compute.internal:3306/anabig11424 --username anabig11424 --password Bigdata123 --compression-codec=snappy --as-avrodatafile --warehouse-dir=/user/anabig11424/hive/warehouse --driver com.mysql.jdbc.Driver --m 1
#to import all tables into hdfs(warehouse1) as parquetfile format using sqoop command
sqoop import-all-tables --connect jdbc:mysql://ip-10-1-1-204.ap-south-1.compute.internal:3306/anabig11424 --username anabig11424 --password Bigdata123 --compression-codec=snappy --as-parquetfile --warehouse-dir=/user/anabig11424/hive/warehouse1 --driver com.mysql.jdbc.Driver --m 1

#check whether the data is moved to HDFS or not
hdfs dfs -ls /user/anabig11424/hive/warehouse

#check whether the avro files are created or not
ls -l /home/anabig11424/*.avsc

#create folder(schema1) in hdfs
hadoop fs -mkdir /user/anabig11424/schema1  

#load data from local to hdfs
hadoop fs -put /home/anabig11424/departments.avsc /user/anabig11424/schema1/departments.avsc
hadoop fs -put /home/anabig11424/dept_manager.avsc /user/anabig11424/schema1/dept_manager.avsc
hadoop fs -put /home/anabig11424/employees.avsc /user/anabig11424/schema1/employees.avsc
hadoop fs -put /home/anabig11424/salaries.avsc /user/anabig11424/schema1/salaries.avsc
hadoop fs -put /home/anabig11424/titles.avsc /user/anabig11424/schema1/titles.avsc
hadoop fs -put /home/anabig11424/dept_emp.avsc /user/anabig11424/schema1/dept_emp.avsc

#checking if the avro files are loaded in schema1 of hdfs
hdfs dfs -ls /user/anabig11424/schema1


