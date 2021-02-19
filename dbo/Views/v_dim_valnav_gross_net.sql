CREATE VIEW [dbo].[v_dim_valnav_gross_net]
AS SELECT 
      [gross_net_id]
	  ,parent_id
      ,[gross_net_alias]
      ,[unary_operator]
      ,[sort_key]
  FROM [data_mart].[t_dim_valnav_gross_net];