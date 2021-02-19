CREATE VIEW [dbo].[v_dim_VNReserves_scenario]
AS SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [data_mart].[t_dim_scenario]
  WHERE scenario_cube_name='VNReserves';