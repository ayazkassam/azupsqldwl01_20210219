CREATE VIEW [dbo].[v_dim_valnav_reserve_category]
AS SELECT 
      [reserve_category_id]
	  ,parent_id
      ,[reserve_category_alias]
      ,[unary_operator]
      ,[sort_key]
  FROM [data_mart].[t_dim_valnav_reserve_category];