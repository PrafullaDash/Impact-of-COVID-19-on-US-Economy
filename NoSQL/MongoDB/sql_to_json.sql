SELECT 
    JSON_OBJECT('covid19_time_series_us_id',
            covid19_time_series_us_id,
            'date_id',
            date_id,
            'confirmed_cases',
            confirmed_cases)
FROM
    depa_final_project.covid19_time_series_us;




SELECT 
    JSON_OBJECT('date_id',
            date_id,
            'date',
            depa_final_project.calendar.date,
            'timestamp',
            depa_final_project.calendar.timestamp,
            'weekend',
            weekend,
            'day_of_week',
            day_of_week,
            'month',
            depa_final_project.calendar.month,
            'monthday',
            monthday,
            'year',
            depa_final_project.calendar.year)
FROM
    depa_final_project.calendar;
    
    

SELECT 
    JSON_OBJECT('employment_industry_id',
            employment_industry_id,
            'date_id',
            date_id,
            'industry_id',
            industry_id,
            'persons_employed',
            persons_employed,
            'change_prev_month_percent',
            change_prev_month_percent,
            'change_prev_month_number',
            change_prev_month_number)
FROM
    depa_final_project.employment_industry;
    
    
SELECT 
    JSON_OBJECT('employment_private_sector_id',
            employment_private_sector_id,
            'date_id',
            date_id,
            'sector_id',
            sector_id,
            'persons_employed',
            persons_employed,
            'change_prev_month_percent',
            change_prev_month_percent,
            'change_prev_month_number',
            change_prev_month_number)
FROM
    depa_final_project.employment_private_sector;
    
    
    
select JSON_OBJECT('industry_id',industry_id,'naics_code',naics_code,'industry_title',industry_title,
                   'create_date',create_date,'last_modified_date',last_modified_date,'is_active',is_active)
                   
                   from depa_final_project.industry;
                   
	
select JSON_OBJECT('organization_id',organization_id,'industry_id',industry_id,'code',depa_final_project.organization.code,
                   'name',depa_final_project.organization.name)
                   
                   from depa_final_project.organization;
                   
                   

select JSON_OBJECT('organization_stock_data_id',organization_stock_data_id,'organization_id',organization_id,
'date_id',date_id,
                   'open',depa_final_project.organization_stock_data.open,
                   'high',high,'low',low,'close',depa_final_project.organization_stock_data.close,
                   'adj_close',adj_close,'volume',volume)
                   
                   from depa_final_project.organization_stock_data;
                   
                   
                   
                   
select JSON_OBJECT('retail_industry_id',retail_industry_id,'naics_code',naics_code,
'industry_title',industry_title,
                   'create_date',create_date,
                   'last_modified_Date',last_modified_Date,'is_active',is_active)
                   
                   from depa_final_project.retail_breakdown_naics_code;
                   
                   
                   
                   
select JSON_OBJECT('retail_seasonal_adjusted_id',retail_seasonal_adjusted_id,'date_id',date_id,
'retail_industry_id',retail_industry_id,
                   'sales',sales,
                   'inventory',inventory)
                   
                   from depa_final_project.retail_data_seasonal_adjusted;
                   
                   
                   
                   
                   
select JSON_OBJECT('sector_id',sector_id,'sector_name',sector_name)
                   
                   from depa_final_project.sector;
                   
                   
                   
                   
SELECT 
    JSON_OBJECT('stock_data_id',
            stock_data_id,
            'date_id',
            date_id,
            'open',
            depa_final_project.sp500_stock_data.open,
            'high',
            high,
            'low',
            low,
            'close',
            depa_final_project.sp500_stock_data.close,
            'adj_close',adj_close,'volume',volume)
FROM
    depa_final_project.sp500_stock_data;