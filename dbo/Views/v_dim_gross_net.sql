CREATE VIEW [dbo].[v_dim_gross_net]
AS SELECT [gross_net_key]
      ,[gross_net_id]
      ,[gross_net_alias]
      ,[gross_net_property]
      ,[sort_key]
  FROM [data_mart].[t_dim_gross_net];