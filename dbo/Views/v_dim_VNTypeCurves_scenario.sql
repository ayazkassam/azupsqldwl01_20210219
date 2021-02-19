CREATE VIEW [dbo].[v_dim_VNTypeCurves_scenario]
AS with cte as (
	SELECT c.[scenario_key]
		, p.scenario_key scenario_parent_key
		, c.scenario_description
		, c.scenario_cube_name
		, c.unary_operator
		, c.scenario_formula
		, c.scenario_formula_property
		, case	when c.scenario_key = 'Type Curves' then 'A7_TC'
				when p.scenario_key = 'Type Curves' then 'A7_TC' + '_' + substring(replace(c.scenario_key,'$',''),1,50)
			else substring(replace(p.scenario_key,'$',''),1,50) + '_' + substring(c.scenario_sort_key,1,4) end scenario_sort_key
	FROM [data_mart].[t_dim_scenario_typecurves] as c
	left join [data_mart].[t_dim_scenario_typecurves] as p ON c.scenario_parent_key = p.scenario_key
	WHERE c.scenario_cube_name='Valnav'
)

select *
from cte

union all

select 'D_' + s.scenario_key
	, case when scenario_parent_key = 'Type Curves' then 'Default Type Curves' else 'D_' + scenario_parent_key end as scenario_parent_key
	, scenario_description
	, scenario_cube_name
	, unary_operator
	, '([Scenario].[Scenario Hierarchy].&[' + s.scenario_key + '])' as scenario_formula
	, scenario_formula_property
	, replace(scenario_sort_key,'A7_TC','A5_tc') scenario_sort_key
from cte s 
join stage.t_stg_type_curves_current_scenario c 
	on (s.scenario_key = c.scenario_key or s.scenario_parent_key = c.scenario_key)
where c.is_current_scenario = 'Y'

union all

select 'Default Type Curves' as scenario_key
	, null as scenario_parent_key
	, 'Default Type Curves' as scenario_description
	, 'Valnav' as scenario_cube_name
	, '+' unary_operator
	, null as scenario_formula
	, null scenario_formula_property
	, 'A5_TC' as scenario_sort_key;