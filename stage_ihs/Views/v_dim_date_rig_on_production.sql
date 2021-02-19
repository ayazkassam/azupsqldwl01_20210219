CREATE VIEW [stage_ihs].[v_dim_date_rig_on_production]
AS SELECT [date_key]
	,LEFT(CONVERT(VARCHAR, [full_date], 120), 10) as [full_Date]
	,[calendar_month_number]
	,substring(LEFT(CONVERT(VARCHAR, [full_date], 120), 10),1,4) + ' - ' + substring(LEFT(CONVERT(VARCHAR, [full_date], 120), 10),6,2) as [calendar_month_name]
	,[calendar_quarter_number]
	,[calendar_quarter_name]
	,convert(char(8), [calendar_year_number]) as calendar_year_number
	,convert(char(8), [calendar_year_number]) as calendar_year_name
  FROM data_mart.[dim_date]
   WHERE calendar_year_number <= 
      (SELECT int_value start_year
		FROM stage.t_ctrl_etl_variables
		WHERE variable_name='RIG_SPUD_ON_PROD_DATE_END_YEAR'
	   ) 
--
UNION ALL
--
SELECT [date_key]
      ,LEFT(CONVERT(VARCHAR, [full_date], 120), 10) as [full_Date]
      ,[calendar_month_number]
      ,[calendar_month_name] + [calendar_year_name] as [calendar_month_name]      
      ,[calendar_quarter_number]
      ,[calendar_quarter_name]
      , convert(char(8), [calendar_year_number]) as calendar_year_number
	  , convert(char(8), [calendar_year_number]) as calendar_year_name
  FROM data_mart.[dim_date]
   WHERE date_key in (-1,-2);