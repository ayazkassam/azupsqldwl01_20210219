﻿CREATE VIEW [dbo].[v_dim_date_spud]
AS SELECT [date_key]
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
      , convert(char(8), [calendar_year_number]) as calendar_year_number
	  , convert(char(8), [calendar_year_number]) as calendar_year_name
      ,[days_since_20000101]
      ,[weeks_since_20000101]
      ,[months_since_20000101]
      ,[quarters_since_20000101]
      ,[years_since_20000101]
      ,[holiday_flag]
      ,[holiday_description]
  FROM [data_mart].[dim_date]
  -- WHERE calendar_year_number
  --<=
  --    (SELECT int_value start_year
		--FROM [stage].[t_ctrl_etl_variables]
		--WHERE variable_name='RIG_SPUD_ON_PROD_DATE_END_YEAR'
	 --  ) 
--
UNION ALL
--
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
      ,convert(char(8), [calendar_year_number]) as calendar_year_number
	   ,'Spud ' + convert(char(8), [calendar_year_number]) as calendar_year_name
      ,[days_since_20000101]
      ,[weeks_since_20000101]
      ,[months_since_20000101]
      ,[quarters_since_20000101]
      ,[years_since_20000101]
      ,[holiday_flag]
      ,[holiday_description]
  FROM [data_mart].[dim_date]
  WHERE date_key in (-1,-2);