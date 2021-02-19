CREATE VIEW [dbo].[v_dim_valnav_scenario_BCD] AS SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [dbo].[CTE_v_dim_valnav_scenario_BCD_wbud]
 --
 UNION ALL
 -- current and prior members
 SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [dbo].v_dim_valnav_current_prior_budget_scenario_source
  WHERE scenario_cube_name='Valnav'
  --
  UNION ALL
  -- current and prior "real" / referenced members
  SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [dbo].[CTE_v_dim_valnav_scenario_BCD_cur_prior]
  --
  UNION ALL
  -- variances
  SELECT [scenario_key],
       scenario_parent_key,
	   scenario_description,
	   scenario_cube_name,
	   unary_operator,
	   scenario_formula,
	   scenario_formula_property,
	   scenario_sort_key
  FROM [dbo].[CTE_v_dim_valnav_scenario_BCD_var];