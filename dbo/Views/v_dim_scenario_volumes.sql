CREATE VIEW [dbo].[v_dim_scenario_volumes] AS SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [data_mart].[t_dim_scenario]
  WHERE scenario_cube_name='Volumes'
  UNION ALL
 --
 SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [dbo].v_dim_valnav_current_prior_budget_scenario_source
  WHERE scenario_cube_name='Volumes';