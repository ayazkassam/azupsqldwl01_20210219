CREATE VIEW [dbo].[v_CTE_v_dim_source_scenario_finance_dim_scenario]
AS SELECT [scenario_key],
		scenario_parent_key,
		scenario_description,
		scenario_cube_name,
		unary_operator,
		scenario_formula,
		scenario_formula_property,
		scenario_sort_key,
		case when scenario_parent_key = 'Actuals' or scenario_key = 'Actuals' then 'Posted'
			 when scenario_key = 'Powervision' then 'Powervision'
			 else 'Budgets' end as hierarchy_type
	FROM data_mart.[t_dim_scenario]
	WHERE scenario_cube_name = 'Finance'

	union all

	/*add "scenario" for working interest measure*/
	select 'WI', 'Actuals', 'WI', 'Finance', '+', null, null, '9997', 'Posted'


	--
	UNION ALL
	--
	--Finance Approved Budgets
	SELECT [scenario_key],
		scenario_parent_key,
		scenario_description,
		scenario_cube_name,
		unary_operator,
		scenario_formula,
		scenario_formula_property,
		scenario_sort_key,
		'Budgets' as hierarchy_type
	FROM dbo.v_dim_valnav_current_prior_budget_scenario_source
	WHERE scenario_cube_name='Finance'
	--
	UNION ALL
	--
	--Powervision
	SELECT DISTINCT substring(document,1,3) scenario_key,
		'Powervision' scenario_parent_key,
		substring(document,1,3) scenario_description,
		'Finance' scenario_cube_name,
		'+' unary_operator,
		null scenario_formula,
		null scenario_formula_property,
		'105_' + substring(document,1,3) scenario_sort_key,
		'Powervision' as hierarchy_type
	FROM [stage].v_fact_source_powervision
	--
	UNION ALL
	--
	--Qbyte Posted Acutals
	SELECT voucher_type_code scenario_key,
		CASE WHEN voucher_type_code = 'ACCRU' THEN 'ACR' ELSE 'ACT' END scenario_parent_key,
		[stage].InitCap(voucher_type_desc) scenario_description,
		'Finance' scenario_cube_name,
		'+' unary_operator,
		null scenario_formula,
		null scenario_formula_property,
		'0100.001_' + voucher_type_code scenario_sort_key,
		'Posted' as hierarchy_type
	FROM [stage].t_qbyte_voucher_types
	--  
	UNION ALL
	--
	--Qbyte Unposted Actuals
	SELECT 'U_' + voucher_type_code scenario_key,
		'Unposted' scenario_parent_key,
		'Unposted ' + [stage].InitCap(voucher_type_desc) scenario_description,
		'Finance' scenario_cube_name,
		'+' unary_operator,
		null scenario_formula,
		null scenario_formula_property,
		'0200.001_U_' + voucher_type_code scenario_sort_key
		, 'Unposted' as hierarchy_type
	FROM [stage].t_qbyte_voucher_types;