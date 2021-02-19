CREATE VIEW [dbo].[v_dim_valnav_current_prior_budget_scenario_source]
AS select DISTINCT [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_cube_name
	, replace(scenario_key, source_replace_text, dest_replace_text) scenario_key
	, CASE WHEN replace([dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_parent_key, source_replace_text, dest_replace_text) = [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_parent_key THEN null
			ELSE replace([dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_parent_key, source_replace_text, dest_replace_text) END scenario_parent_key
	, replace(scenario_key, source_replace_text, dest_replace_text) scenario_description
	, '+' unary_operator
	, case when notleaf.scenario_parent_key is null 
		then '([Scenario].[Scenario Hierarchy].&[' + scenario_key + '])' else null end as scenario_formula
	, cast (null as varchar(500)) scenario_formula_property
	, CASE WHEN [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_cube_name = 'Volumes'
			THEN CASE WHEN dest_replace_text like 'Current%' THEN '0350.' ELSE '0360.' END 
			ELSE CASE WHEN dest_replace_text like 'Current%' THEN '0200.' ELSE '0300.' END
		END + scenario_sort_key  scenario_sort_key
	, case when notleaf.scenario_parent_key is not null then 0 else 1 end as isleaf
from [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source]
left join ( select distinct scenario_cube_name, scenario_parent_key 
			from [data_mart].[t_dim_scenario]
	) notleaf on [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_cube_name = notleaf.scenario_cube_name and [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_key = notleaf.scenario_parent_key

-- 
UNION ALL
--
SELECT [scenario_cube_name]
      ,[scenario_key]
      ,[scenario_parent_key]
      ,[scenario_description]
      ,[unary_operator]
      ,[scenario_formula]
      ,[scenario_formula_property]
      ,[scenario_sort_key]
      ,[isleaf]
  FROM [data_mart].[t_leaseops_current_prior_scenario];