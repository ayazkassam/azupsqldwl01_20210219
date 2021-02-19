CREATE VIEW [dbo].[v_dim_valnav_normalized_month]
AS SELECT
 [normalized_time_key]
      ,[day_number]
      ,[day_name]
      ,[week_number]
      ,[week_name]
      ,[month_name]
  FROM [data_mart].[t_dim_valnav_normalized_time];