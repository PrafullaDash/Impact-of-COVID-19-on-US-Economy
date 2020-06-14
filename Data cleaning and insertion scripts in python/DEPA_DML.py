#!/usr/bin/env python
# coding: utf-8

# # Python DML Script to insert data into DEPA_Final_Project database

# In[1]:


#pip install  yahoofinancials 


# In[1]:


import json
import requests
import csv
import numpy as np
import pandas as pd
import datetime as dt
import warnings
warnings.filterwarnings("ignore")
import pymysql


# In[2]:


def connection():

    # Open database connection
     connection = pymysql.connect("104.198.192.82","root","Pr@X1nX1@$r1","depa_final_project" )
   # connection = pymysql.connect("localhost","root","rootroot","depa_final_project" )
     return connection


# In[3]:


connection = connection()


# In[6]:


def qry(sql):

    df = pd.read_sql(sql, connection)

    return df


# In[7]:


from dateutil.parser import parse
from datetime import date

today = date.today()
today_date = parse(str(today)).strftime('%Y-%m-%d')


# In[8]:


numbers_small_sql = "INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);"
cursor = connection.cursor()
cursor.execute(numbers_small_sql)
connection.commit()
cursor.close()


# In[9]:


numbers_sql = "INSERT INTO numbers                     SELECT                     thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number                     FROM                     numbers_small thousands,                     numbers_small hundreds,                     numbers_small tens,                     numbers_small ones                     LIMIT 1000000;"

cursor = connection.cursor()
cursor.execute(numbers_sql)
connection.commit()
cursor.close()


# In[10]:


calendar_sql = "INSERT INTO calendar (date_id, date)                SELECT                number,                DATE_ADD('2010-01-01',                INTERVAL number DAY)                FROM                numbers                WHERE                DATE_ADD('2010-01-01',                INTERVAL number DAY) BETWEEN '2010-01-01' AND '2020-06-12'                ORDER BY number;"

cursor = connection.cursor()
cursor.execute(calendar_sql)
connection.commit()
cursor.close()


# In[11]:


sql_updates = "SET SQL_SAFE_UPDATES = 0;"
calendar_sql = "UPDATE calendar                 SET                 timestamp = UNIX_TIMESTAMP(date),                 day_of_week = DATE_FORMAT(date, '%W'),                 weekend = IF(DATE_FORMAT(date, '%W') IN ('Saturday' , 'Sunday'),                 'Weekend',                 'Weekday'),                  month = DATE_FORMAT(date, '%M'),                  year = DATE_FORMAT(date, '%Y'),                  monthday = DATE_FORMAT(date, '%d');"

cursor = connection.cursor()
cursor.execute(sql_updates)
cursor.execute(calendar_sql)
connection.commit()
cursor.close()


# In[4]:


sector = pd.read_excel('../data/sector_data.xlsx')
employment_private_sector = pd.read_excel('../data/employment_private_sector_data.xlsx')
industry = pd.read_excel('../data/industry_data.xlsx')
employment_industry = pd.read_excel('../data/employment_industry_data.xlsx')
industry_organization = pd.read_excel('../data/industry_organization.xlsx')
retail_industry_code = pd.read_excel('../data/Retail_NAICS_Code.xlsx')
retail_data_seasonal_adjusted = pd.read_excel('../data/retail_data_seasonal_adjusted.xlsx')
stock_data = pd.read_csv('../data/stock_data.csv')
covid19_data = pd.read_csv('../data/covid19_time_series_data.csv')
covid19_us = pd.read_csv('../data/covid19_us_data.csv')


# ## Insert into sector table

# In[13]:


# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in sector.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in sector.iterrows():
    sql = "INSERT INTO `sector` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# ## inserting rows - industry table

# In[14]:



industry['create_date'] = today_date
industry['last_modified_date'] = today_date
industry['naics_code'] = industry['naics_code'].astype(str)

# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in industry.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in industry.iterrows():
    sql = "INSERT INTO `industry` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# ## Employment industry data transformation
# 

# In[15]:


employment_industry['persons_employed'] = round(employment_industry['persons_employed'],3)
employment_industry['change_prev_month_number'] = round(employment_industry['change_prev_month_number'],3)
employment_industry['persons_employed']=employment_industry['persons_employed']*1000
employment_industry['change_prev_month_number']=employment_industry['change_prev_month_number']*1000
employment_industry['change_prev_month_number'] = employment_industry['change_prev_month_number'].astype(int)
employment_industry['persons_employed'] = employment_industry['persons_employed'].astype(int)
employment_industry['change_prev_month_percent'] = round(employment_industry['change_prev_month_percent'],2)


# In[16]:


# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in employment_industry.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in employment_industry.iterrows():
    sql = "INSERT INTO `employment_industry` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# In[17]:


# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in industry_organization.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in industry_organization.iterrows():
    sql = "INSERT INTO `organization` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()


# In[19]:


sql= "SELECT * from organization;"
df =qry(sql)


# In[20]:


from yahoofinancials import YahooFinancials
stock_codes=list(df.code)
yahoo_financials_stocks= YahooFinancials(stock_codes)
daily_stock_prices= (yahoo_financials_stocks.get_historical_price_data('2019-01-01', '2020-05-29', 'daily'))
#daily_stock_prices


# In[21]:


ticker_codes = daily_stock_prices.keys()


for code in ticker_codes:
    #print(code)
    prices_list = daily_stock_prices.get(code).get('prices')
    for price in prices_list:
        cursor = connection.cursor()
        date_sql = "SELECT date_id from calendar where date='"+price.get('formatted_date')+"';"
        date_obj = qry(date_sql)  
        date_obj = date_obj['date_id'][0]
        #print(date_obj)
        organization_sql = "SELECT organization_id,code from organization where code='"+code+"';"
        organization = qry(organization_sql) 
        organization = organization['organization_id'][0]
        #print(organization)
       
        sql = "insert into organization_stock_data (`organization_id`,`date_id`,`open`,`high`,              `low`,`close`,`adj_close`,`volume`) values(             "+str(organization)+","+str(date_obj)+","+str(price.get('open'))+","+str(price.get('high'))+","+str(price.get('low'))+","+str(price.get('close'))+","+str(price.get('adjclose'))+","+str(price.get('volume'))+");"
      
        #print(sql)
        cursor.execute(sql)
        connection.commit()
        cursor.close()


         

    
   


# In[22]:


retail_industry_code.rename(columns = {'industry_code':'naics_code','industry_name':'industry_title'}, inplace = True)
retail_industry_code['create_date'] = today_date
retail_industry_code['last_modified_date'] = today_date
retail_industry_code['is_active'] = 'Y'


# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in retail_industry_code.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in retail_industry_code.iterrows():
    sql = "INSERT INTO `retail_breakdown_naics_code` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# In[5]:


retail_data_seasonal_adjusted = retail_data_seasonal_adjusted.where((pd.notnull(retail_data_seasonal_adjusted)), None)
# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in retail_data_seasonal_adjusted.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in retail_data_seasonal_adjusted.iterrows():
    sql = "INSERT INTO `retail_data_seasonal_adjusted` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# In[24]:


# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in employment_private_sector.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in employment_private_sector.iterrows():
    sql = "INSERT INTO `employment_private_sector` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# In[25]:


# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in stock_data.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in stock_data.iterrows():
    sql = "INSERT INTO `sp500_stock_data` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# ### Inserting data in covid19_time_series_us 

# In[26]:


# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in covid19_data.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in covid19_data.iterrows():
    sql = "INSERT INTO `covid19_time_series_us` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# ### Insert data in covi19_us table

# In[ ]:


# create cursor
cursor = connection.cursor()

# creating column list for insertion
cols = "`,`".join([str(i) for i in covid19_us.columns.tolist()])

# Insert DataFrame records one by one.
for i,row in covid19_us.iterrows():
    sql = "INSERT INTO `covid19_us` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
    cursor.execute(sql, tuple(row))

# commit to save changes
connection.commit()
cursor.close()


# In[6]:


connection.close()


# In[87]:





# In[ ]:




