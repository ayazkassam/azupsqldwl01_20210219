CREATE VIEW [stage].[v_dim_source_scenario_finance]
AS select scenario_key
	, scenario_parent_key
	, scenario_description
	, scenario_cube_name
	, unary_operator
	, scenario_formula
	, scenario_formula_property
	, scenario_level_01
	, coalesce(scenario_level_02, scenario_level_01) as scenario_level_02
	, coalesce(scenario_level_03, scenario_level_02, scenario_level_01) as scenario_level_03
	, coalesce(scenario_level_04, scenario_level_03, scenario_level_02, scenario_level_01) as scenario_level_04
	, coalesce(scenario_level_05, scenario_level_04, scenario_level_03, scenario_level_02, scenario_level_01) as scenario_level_05
	, scenario_level_01_sort_key
	, coalesce(scenario_level_02_sort_key, scenario_level_01_sort_key) as scenario_level_02_sort_key
	, coalesce(scenario_level_03_sort_key, scenario_level_02_sort_key, scenario_level_01_sort_key) as scenario_level_03_sort_key
	, coalesce(scenario_level_04_sort_key, scenario_level_03_sort_key, scenario_level_02_sort_key, scenario_level_01_sort_key) as scenario_level_04_sort_key
	, coalesce(scenario_level_05_sort_key, scenario_level_04_sort_key, scenario_level_03_sort_key, scenario_level_02_sort_key, scenario_level_01_sort_key) as scenario_level_05_sort_key
	, hierarchy_type
from (
	select scenario_key
		, scenario_parent_key
		, scenario_description
		, scenario_cube_name
		, unary_operator
		, scenario_formula
		, scenario_formula_property
		,src.[Hierarchy_Path]
		,src.scenario_sort_key
		,PHP.account_level_01 scenario_level_01
		,PHP.account_level_02 scenario_level_02
		,PHP.account_level_03 scenario_level_03
		,PHP.account_level_04 scenario_level_04
		,PHP.account_level_05 scenario_level_05
		
		,PSSP.account_level_01_scenario_sort_key scenario_level_01_sort_key
		,PSSP.account_level_02_scenario_sort_key scenario_level_02_sort_key
		,PSSP.account_level_03_scenario_sort_key scenario_level_03_sort_key
		,PSSP.account_level_04_scenario_sort_key scenario_level_04_sort_key
		,PSSP.account_level_05_scenario_sort_key scenario_level_05_sort_key
		, hierarchy_type
	from [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels] src
		LEFT JOIN [dbo].[Parse_Hierarchy_Path] PHP
			    ON PHP.[Hierarchy_Path] = src.[Hierarchy_Path] 
	    LEFT JOIN [dbo].[Parse_scenario_sort_key] PSSP
			    ON PSSP.scenario_sort_key = src.scenario_sort_key ) sq
where scenario_parent_key is not null or scenario_formula is not null;