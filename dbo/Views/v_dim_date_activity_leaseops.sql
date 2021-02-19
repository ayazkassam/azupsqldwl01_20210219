CREATE VIEW [dbo].[v_dim_date_activity_leaseops]
AS SELECT DISTINCT
	   max(date_key) over (partition by calendar_month_name) date_key,
       max(full_date) over (partition by calendar_month_name) full_date,
	   calendar_month_name,
	   calendar_quarter_name,
	   calendar_year_name,
	   number_of_days
FROM
(
SELECT [date_key]
      ,LEFT(CONVERT(VARCHAR, [full_date], 120), 10) as [full_Date]
      ,[day_of_month]
      ,[day_of_month_dd]
      ,[day_of_month_with_suffix]
      ,[day_of_week_name]
      ,[day_of_week_name_short]
      ,[day_of_week_number]
      ,[day_of_Week_in_month]
      ,[day_of_Year_number]
      ,[week_of_year_number]
      ,[week_of_year_number_dd]
      ,[week_of_month_number]
      ,[week_start_date_full]
      ,[week_start_date_dd_mon_yyyy]
      ,[calendar_month_number]
       ,substring(LEFT(CONVERT(VARCHAR, [full_date], 120), 10),1,4) + ' - ' + substring(LEFT(CONVERT(VARCHAR, [full_date], 120), 10),6,2) as [calendar_month_name]
      ,[calendar_month_name_short]
      ,[weekDay_flag]
      ,[first_Day_of_Calendar_month_flag]
      ,[last_Day_of_Calendar_month_flag]
      ,[calendar_quarter_number]
      ,[calendar_quarter_name]
      ,[calendar_quarter_name_short]
       ,substring(LEFT(CONVERT(VARCHAR, [full_date], 120), 10),1,4) as calendar_year_number
      ,'Activity ' + convert(char(8), [calendar_year_number]) as calendar_year_name
      ,[days_since_20000101]
      ,[weeks_since_20000101]
      ,[months_since_20000101]
      ,[quarters_since_20000101]
      ,[years_since_20000101]
      ,[holiday_flag]
      ,[holiday_description]
	  ,count(date_key) over (partition by substring(LEFT(CONVERT(VARCHAR, [full_date], 120), 10),1,4) + ' - ' + substring(LEFT(CONVERT(VARCHAR, [full_date], 120), 10),6,2)) number_of_days	 
  FROM  [data_mart].[dim_date] 
  WHERE date_key
  BETWEEN
      (SELECT int_value start_year
		FROM [stage].t_ctrl_etl_variables
		WHERE variable_name='LEASEOPS_ACTIVITY_DATE_START'
	   ) 
   AND
	(SELECT int_value end_year
	FROM [stage].t_ctrl_etl_variables
	WHERE variable_name='LEASEOPS_ACTIVITY_DATE_END')
 ) d1
 --
 UNION ALL
 --
 SELECT DISTINCT
	   date_key,
       full_date,
	   calendar_month_name,
	   calendar_quarter_name,
	   calendar_year_name,
	   number_of_days
FROM
(
 SELECT [date_key]
      ,LEFT(CONVERT(VARCHAR, [full_date], 120), 10) as [full_Date]
      ,[day_of_month]
      ,[day_of_month_dd]
      ,[day_of_month_with_suffix]
      ,[day_of_week_name]
      ,[day_of_week_name_short]
      ,[day_of_week_number]
      ,[day_of_Week_in_month]
      ,[day_of_Year_number]
      ,[week_of_year_number]
      ,[week_of_year_number_dd]
      ,[week_of_month_number]
      ,[week_start_date_full]
      ,[week_start_date_dd_mon_yyyy]
      ,[calendar_month_number]
      ,[calendar_month_name] + [calendar_year_name] as [calendar_month_name]
      ,[calendar_month_name_short]
      ,[weekDay_flag]
      ,[first_Day_of_Calendar_month_flag]
      ,[last_Day_of_Calendar_month_flag]
      ,[calendar_quarter_number]
      ,[calendar_quarter_name]
      ,[calendar_quarter_name_short]
       ,substring(LEFT(CONVERT(VARCHAR, [full_date], 120), 10),1,4) as calendar_year_number
      ,'Activity ' + calendar_month_name_short calendar_year_name
      ,[days_since_20000101]
      ,[weeks_since_20000101]
      ,[months_since_20000101]
      ,[quarters_since_20000101]
      ,[years_since_20000101]
      ,[holiday_flag]
      ,[holiday_description]
	  ,1 as number_of_days
  FROM  [data_mart].[dim_date] 
  WHERE date_key in (-1,-2,9999)
  ) d2;