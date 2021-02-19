CREATE VIEW [stage_ihs].[v_dim_normalized_time]
AS SELECT
       [normalized_time_key]
      ,[day_number]
      ,[day_name]
      ,[week_number]
      ,[week_name]
      ,[month_name]
	  ,day_name2
  FROM data_mart.[t_dim_normalized_time];