#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import json
import requests
import csv
import numpy as np
import pandas as pd
import datetime as dt
import warnings
warnings.filterwarnings("ignore")
import pymysql


# In[ ]:


def connection():

    # Open database connection
     connection = pymysql.connect("104.198.192.82","root","Pr@X1nX1@$r1","depa_final_project_dw" )
     return connection


# In[ ]:


connection = connection()


# In[ ]:


def qry(sql):

    df = pd.read_sql(sql, connection)

    return df


# In[ ]:


calendar_sql = "INSERT INTO `depa_final_project_dw`.`dim_calendar`                ( `date_id`,                  `date`,                   `timestamp`,                  `weekend`,                  `day_of_week`,                   `month`,                  `month_day`,                   `year`)                   (SELECT * from depa_final_project.calendar);"

cursor = connection.cursor()
cursor.execute(calendar_sql)
connection.commit()
cursor.close()


# In[ ]:


organization_stock_sql = "INSERT INTO `depa_final_project_dw`.`dim_organization_stock`                (`organization_stock_id`,                  `date_id`,                  `organization_name`,                  `industry_title`,                   `adj_close`)                 (SELECT                   os.organization_stock_data_id, os.date_id,o.name,i.industry_title, os.adj_close                  FROM                   depa_final_project.organization_stock_data os,                   depa_final_project.organization o,                   depa_final_project.industry i                    WHERE                    os.organization_id = o.organization_id AND                     o.industry_id= i.industry_id);"

cursor = connection.cursor()
cursor.execute(organization_stock_sql)
connection.commit()
cursor.close()


# In[ ]:


employment_industry_sql = "INSERT INTO `depa_final_project_dw`.`dim_employment_industry`                (`employment_industry_id`,                  `date_id`,                  `industry_id`,                  `industry_title`,                   `persons_employed`,                   `change_prev_month_percent`,                   `change_prev_month_number`)                  (SELECT                   employment_industry_id, date_id,i.industry_id,i.industry_title, persons_employed,change_prev_month_percent,change_prev_month_number                  FROM                   depa_final_project.employment_industry ei,                   depa_final_project.industry i                    WHERE                    i.industry_id = ei.industry_id);"

cursor = connection.cursor()
cursor.execute(employment_industry_sql)
connection.commit()
cursor.close()


# In[ ]:


retail_sql = "INSERT INTO `depa_final_project_dw`.`dim_retail`             (`retail_seasonal_adjusted_id`,`date_id`,            `retail_industry_id`,             `retail_industry_title`,             `sales`,             `inventory`,            `inventory_sales_ratio`             )             (SELECT              rd.retail_seasonal_adjusted_id,              rd.date_id,              rd.retail_industry_id,              rb.industry_title,              rd.sales,              rd.inventory,             rd.`inventory_sales_ratio`\ 
            FROM `depa_final_project`.`retail_data_seasonal_adjusted` rd ,            `depa_final_project`.`retail_breakdown_naics_code` rb             WHERE rd.retail_industry_id = rb.retail_industry_id             );"

cursor = connection.cursor()
cursor.execute(employment_industry_sql)
connection.commit()
cursor.close()


# In[ ]:


sql= "Select * from dim_retail"
df = qry(sql)
df


# In[ ]:


# Insert the rows from SNP500_stock into dimensional table. 

cursor = connection.cursor()
sql_stock = '''
INSERT INTO depa_final_project_dw.dim_snp500_stock
(snp500_stock_id, 
date_id, 
open, 
high, 
low, 
close,
adj_close,
volume)
(SELECT 
stock_data_id, 
date_id, 
open, 
high, 
low, 
close,
adj_close,
volume
FROM depa_final_project.sp500_stock_data)
'''
cursor.execute(sql_stock)

connection.commit()
cursor.close()


# In[ ]:


connection.close()


# In[ ]:




