#!/usr/bin/env python
# coding: utf-8

# ## Machine Learning (Model Building part)

# In[2]:


#importing the necessary libraries and packages
from pyspark.sql import SparkSession
import pandas as pd
from pyspark.sql import functions as F
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pyspark.sql.types import *
from pyspark.sql.functions import *  
from pyspark.ml.classification import RandomForestClassifier
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.evaluation import MulticlassClassificationEvaluator, BinaryClassificationEvaluator

from pyspark.ml import Pipeline

import warnings
warnings.simplefilter(action='ignore')

#Encoding all categorical features
from pyspark.ml.feature import  StringIndexer, VectorAssembler, VectorIndexer


# In[4]:


#creating a spark context object
spark = (SparkSession.builder.appName("sachin_ml")        .config("hive.metastore.uris","thrift://ip-10-1-2-24.ap-south-1.compute.internal:9083")        .enableHiveSupport().getOrCreate())
spark


# In[6]:


#using the 'sachinlabs' database and displaying the tables presnt in he database via spark sql
spark.sql("use sachinlabs").show()
spark.sql("show tables").show()


# In[13]:

#viewing few records of the employees table
employees1 = spark.sql("select * from employees").show()
employees1


# In[ ]:





# In[15]:

#joining the tables together with necessary fields for data modeling
emp_data = spark.sql("select t1.dept_name,t2.dept_no,t3.birth_date,t3.emp_no,t3.emp_title_id,t3.first_name,t3.hire_date,t3.last_date,t3.last_name,t3.last_performance_rating,t3.left,t3.no_of_projects,t3.sex,t4.salary,t5.title from  departments t1 inner join  dept_emp t2 on t1.dept_no = t2.dept_no inner join employees t3 on t2.emp_no = t3.emp_no inner join salaries t4 on t4.emp_no = t3.emp_no inner join titles t5 on t5.title_id = t3.emp_title_id")


# In[16]:

#viewing the combined table
emp_data.show(5)


# In[17]:

#listing out the columns of the combined table
emp_data.columns


# In[18]:

#preparing the data 
final_data = emp_data
for col in emp_data.columns:
 final_data = emp_data.withColumnRenamed(col,col.replace(" ", "_"))


# In[19]:

#viewing the data
final_data.show()


# In[20]:

#creating a view of the data
final_data.createTempView("final_ml")


# In[21]:

#adding columns
spark.sql('select distinct left from final_ml').show()

final_data = final_data.withColumn("no_of_projects", final_data.no_of_projects.cast('int'))
final_data  = final_data.withColumn("salary", final_data.no_of_projects.cast('int'))
final_data  = final_data.withColumn("left", final_data.left.cast('int'))


# In[22]:

#viewing the schema
final_data.printSchema()


# In[23]:

#continuous features
continuous_features = [
 'no_of_projects',
 'salary']


# In[24]:


final_data.show()


# In[25]:

#categorical features
categorical_features = ['dept_name',
 'last_performance_rating',
 'sex',
 'title']


# In[26]:

#dependent variable
y = ['left']


# In[27]:


# create object of StringIndexer class and specify input and output column
SI_dept_name = StringIndexer(inputCol='dept_name',outputCol='dept_name_Index')
SI_last_performance_rating = StringIndexer(inputCol='last_performance_rating',outputCol='last_performance_rating_Index')
SI_sex = StringIndexer(inputCol='sex',outputCol='sex_Index')
SI_title = StringIndexer(inputCol='title',outputCol='title_Index')


# In[28]:


# transform the data
final_data = SI_dept_name.fit(final_data).transform(final_data)
final_data = SI_last_performance_rating.fit(final_data).transform(final_data)
final_data = SI_sex.fit(final_data).transform(final_data)
final_data = SI_title.fit(final_data).transform(final_data)


# In[31]:


final_data.show()


# In[32]:


#Vector assembler
assesmble=VectorAssembler(inputCols=['no_of_projects',
 'salary',
 'dept_name_Index',
 'last_performance_rating_Index',
 'sex_Index',
 'title_Index'],outputCol='features')


# In[33]:

#assembling the final data
final_data1 = assesmble.transform(final_data)

final_data1.show()


# In[34]:

#train test split
df = final_data1.select('features','left')

df.printSchema()

(train, test) = df.randomSplit([.7,.3])

train.show(2)


# In[ ]:


#  RandomForestClassifier

rf = RandomForestClassifier(labelCol='left', 
                            featuresCol='features',
                            maxDepth=5)

model = rf.fit(train)

rf_predictions = model.transform(test)


# In[ ]:

#Evaluation of the model
multi_evaluator = MulticlassClassificationEvaluator(labelCol = 'left', metricName = 'accuracy')

print('Random Forest classifier Accuracy:', multi_evaluator.evaluate(rf_predictions))


# In[37]:


#pipeline creation
continuous_features


# In[38]:


categorical_features


# In[39]:


# Vector Assembler
inputCols=['no_of_projects',
 'salary',
 'dept_name_Index',
 'last_performance_rating_Index',
 'sex_Index',
 'title_Index']


# In[40]:


# String Indexer
indexer =   [StringIndexer(inputCol=c, outputCol="{}_Index".format(c) ) for c in categorical_features]


# In[41]:


# Vector Assembler
assembler = VectorAssembler(inputCols = inputCols, outputCol = "features")


# In[42]:


# ML Model
rfm = RandomForestClassifier(featuresCol="features",
                              labelCol="label",
                              numTrees=50,
                              maxDepth=5,
                              featureSubsetStrategy='onethird')


# In[43]:


#creating the pipeline
pipeline1 = Pipeline( stages= [indexer, assembler, rfm])

