CREATE VIEW [stage].[v_fact_source_valnav_capital_typecurves] AS SELECT e.object_id AS entity_key,
	rcd.step_date,
	CASE WHEN  step_date IS NULL THEN -1 ELSE convert(int,convert(varchar(8),rcd.step_date,112)) END activity_date_key,
	rcd.success_gross_value,
	rcd.success_interest_value,
	rcd.failure_gross_value,
	rcd.failure_interest_value,
	rl.reserve_category_id,
	cl.name AS accounts,
	vev2.cube_child_member AS scenario,
	CAST(CASE WHEN vna.account_id IS NULL OR datediff(MONTH,onstream_date, step_date)+1 >= mp.max_on_prod_days THEN '-1' 
		ELSE CASE WHEN od.onstream_date IS NULL OR datediff(MONTH,onstream_date, step_date)+1 <= 0 THEN '-1' 
			ELSE  CONCAT(RIGHT(CONCAT('0',datediff(MONTH,onstream_date, step_date)+1),2),'.01') END END AS VARCHAR(5))  AS normalized_time_key,
	'Type Curve' AS scenario_type
FROM  (
	SELECT variable_value AS max_on_prod_days
	FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS'
) mp
, [stage_valnav].t_typecurves_results_cost_detail rcd
LEFT OUTER JOIN  [stage_valnav].t_typecurves_results_lookup rl ON rcd.result_id = rl.result_id
LEFT OUTER JOIN	[stage_valnav].t_typecurves_entity e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value
INNER JOIN (
		select a.OBJECT_ID
			, a.NAME
			, case when NAME = 'Net Fixed Other Revenue' then 'Y' end sign_flip
		from [stage_valnav].t_budget_fisc_op_cost a
		union all		
		select a.OBJECT_ID
			, a.NAME
			, null sign_flip
		from [stage_valnav].t_budget_fisc_cap_cost a
) cl ON rcd.COST_DEFINITION_ID = cl.OBJECT_ID
INNER JOIN (
		SELECT fsp.plan_id, fs.object_id
		FROM [stage_valnav].t_typecurves_fisc_scenario fs
		LEFT OUTER JOIN [stage_valnav].t_typecurves_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
		WHERE name='Budget Year'
) cfd ON rl.entity_id = cfd.parent_id
INNER JOIN (
		SELECT variable_value, cube_child_member, sign_flip_flag
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_BUDGET_YEAR'
) vev2 ON  ltrim(rtrim(cfd.string_value)) = vev2.variable_value
		LEFT OUTER JOIN (
		SELECT object_id, first_step_date onstream_date
		FROM [stage].t_valnav_onstream_date_typecurves
) od ON e.object_id = od.object_id
LEFT OUTER JOIN [stage].v_valnav_netback_accounts vna ON cl.name = vna.account_id
WHERE rl.plan_definition_id = 0
AND year(rcd.step_date) BETWEEN  (
	SELECT year(cast(variable_value as datetime)) first_year
	FROM [stage].t_ctrl_valnav_etl_variables
	WHERE variable_name='VALNAV_ACTIVITY_DATE_START'
)  AND (
	SELECT  year(cast(variable_value as datetime)) last_year
	FROM [stage].t_ctrl_valnav_etl_variables
	WHERE variable_name='VALNAV_ACTIVITY_DATE_END'
);