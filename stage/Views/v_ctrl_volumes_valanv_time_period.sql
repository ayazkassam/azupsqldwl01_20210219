CREATE VIEW [stage].[v_ctrl_volumes_valanv_time_period]
AS SELECT time_period.dates, time_period.year_month
FROM
(
SELECT dates, CAST(YEAR(dates) AS VARCHAR) + RIGHT(replicate('00',2) + CAST(MONTH(dates) AS VARCHAR),2) year_month
FROM
	(
	SELECT number , start_date2+ (number-1) dates
	FROM [stage].[v_ctrl_volumes_valanv_time_period_CTE],
     (SELECT CAST(variable_value +'0101' AS INT) start_date,
								CAST(variable_value +'0101' AS datetime) start_date2,
								CAST(CAST(variable_value+1 AS VARCHAR(4))+'1231' AS INT) end_date,
								CAST(CAST(variable_value+1 AS VARCHAR(4))+'1231' AS datetime) end_date2
						 FROM [stage].[t_ctrl_valnav_etl_variables]
					     WHERE variable_name = 'CURRENT_BUDGET_YEAR_DAILY_DATA'
	 ) s
	) SS
) time_period;