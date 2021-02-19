CREATE VIEW [data_mart_metrix].[v_dim_ar_contract]
AS SELECT [ar_contract]
       ,[sort_key]
  FROM [data_mart_metrix].[t_dim_ar_contract];