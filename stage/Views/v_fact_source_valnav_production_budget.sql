CREATE VIEW [stage].[v_fact_source_valnav_production_budget]
AS SELECT e.object_id entity_id,
	rbp.step_date,
	vp.product_id,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.gross_volume * -1 ELSE rbp.gross_volume END AS gross_volume_imp,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.gross_volume / vp.si_to_imp_conv_factor) * -1 
		ELSE rbp.gross_volume / vp.si_to_imp_conv_factor END AS gross_volume_met,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 ELSE (rbp.gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS gross_volume_boe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.gross_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 ELSE rbp.gross_volume * ISNULL (vp.mcfe6_thermal, 1) END AS gross_volume_mcfe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.wi_volume * -1 ELSE rbp.wi_volume END AS wi_volume_imp,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.wi_volume / vp.si_to_imp_conv_factor) * -1 ELSE rbp.wi_volume / vp.si_to_imp_conv_factor END AS wi_volume_met,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 ELSE (rbp.wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS wi_volume_boe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.wi_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 ELSE rbp.wi_volume * ISNULL (vp.mcfe6_thermal, 1) END AS wi_volume_mcfe, 
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.ri_volume * -1 ELSE rbp.ri_volume END AS ri_volume_imp,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.ri_volume / vp.si_to_imp_conv_factor) * -1 ELSE rbp.ri_volume / vp.si_to_imp_conv_factor END AS ri_volume_met,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 ELSE (rbp.ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS ri_volume_boe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.ri_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 ELSE rbp.ri_volume * ISNULL (vp.mcfe6_thermal, 1) END AS ri_volume_mcfe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.fi_volume * -1 ELSE rbp.fi_volume END AS fi_volume_imp, 
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.fi_volume / vp.si_to_imp_conv_factor) * -1 ELSE rbp.fi_volume / vp.si_to_imp_conv_factor END AS fi_volume_met,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.fi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 ELSE (rbp.fi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS fi_volume_boe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.fi_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 ELSE rbp.fi_volume * ISNULL (vp.mcfe6_thermal, 1) END AS fi_volume_mcfe,
	e.formatted_id,
	RTRIM(LTRIM (e.unique_id)) AS uwi,
	cast(rl.reserve_category_id as varchar(50)) AS reserve_category_id,
	CASE WHEN vp.product_id = 2 THEN 'Sales' + cl.long_name ELSE cl.long_name END AS accounts,
	'Budget' AS scenario_type,
	vev2.cube_child_member AS scenario,
	vp.si_to_imp_conv_factor,
	vp.boe_thermal,
	vp.mcfe6_thermal,
	od.onstream_date,
	CAST(CASE WHEN od.onstream_date IS NULL THEN -1 
		ELSE CASE WHEN (datediff(day,od.onstream_date,rbp.step_date)+1 <=  pdo.production_days_on_cutoff
			AND datediff(day,od.onstream_date,rbp.step_date)+1 >= 0) THEN datediff(day,od.onstream_date,rbp.step_date)+1 ELSE -1 END END AS varchar(5)) normalized_time_key
FROM (
	SELECT year(cast(variable_value as datetime)) first_year
	FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name='VALNAV_ACTIVITY_DATE_START'
) trs
, (
	SELECT year(cast(variable_value as datetime)) last_year
	FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name='VALNAV_ACTIVITY_DATE_END'
) tre
, (
	SELECT int_value as production_days_on_cutoff
	FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name = 'PRODUCTION_DAYS_ON_CUTOFF'
) pdo
, stage_valnav.t_budget_results_btax_product rbp
LEFT OUTER JOIN stage_valnav.t_budget_results_lookup rl ON rbp.result_id = rl.result_id
LEFT OUTER JOIN stage_valnav.t_budget_entity e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value
INNER JOIN (
		SELECT fsp.object_id, fsp.long_name
		FROM stage_valnav.t_budget_code_lookup cl
		join stage_valnav.t_budget_fisc_reserves_product fsp on cl.LONG_NAME = fsp.LONG_NAME
		WHERE code_type = 'RESERVES_PRODUCT_TYPE'
) cl ON rbp.product_id = cl.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.*
		FROM stage_valnav.t_budget_fisc_scenario fs
		LEFT OUTER JOIN stage_valnav.t_budget_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
LEFT OUTER JOIN [stage].t_ctrl_valnav_products vp ON cl.long_name = vp.accounts

inner join (
		select cfd.parent_id
			, ltrim(rtrim(cfd.string_value)) as variable_value
			, cfd.cube_child_member
			, cfd.sign_flip_flag
		from (
				select c.*
					, v.cube_child_member, v.sign_flip_flag
					, row_number() over (	partition by parent_id 
											order by case ltrim(rtrim(c.name)) 
													when 'Budget Year' then 3 
													when 'DISTRICT' then 2 
													when 'CAPITAL GROUP' then 1 end) rnk
				FROM [stage].t_stg_valnav_budget_ent_custom_field_def c
				join [stage].t_ctrl_valnav_etl_variables v on ltrim(rtrim(c.string_value)) = v.variable_value
				WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT', 'CAPITAL GROUP')
				and v.variable_name = 'BUDGET_BUDGET_YEAR'
		) cfd 
		where rnk = 1	
) vev2 on rl.entity_id = vev2.parent_id

LEFT OUTER JOIN (
		SELECT object_id, first_step_date onstream_date
		FROM [stage].t_valnav_onstream_date_budget
) od ON rl.entity_id = od.object_id
WHERE rl.plan_definition_id = 0
AND  year(rbp.step_date) BETWEEN trs.first_year AND tre.last_year


UNION ALL
--
/*-- Raw Gas*/
SELECT e.object_id entity_id,
	rbp.step_date,
	vp.product_id,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.raw_gross_volume * -1 ELSE rbp.raw_gross_volume END AS gross_volume_imp,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.raw_gross_volume / vp.si_to_imp_conv_factor) * -1 ELSE rbp.raw_gross_volume / vp.si_to_imp_conv_factor END AS gross_volume_met,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.raw_gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 ELSE (rbp.raw_gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS gross_volume_boe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.raw_gross_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 ELSE rbp.raw_gross_volume * ISNULL (vp.mcfe6_thermal, 1) END AS gross_volume_mcfe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.raw_wi_volume * -1 ELSE rbp.raw_wi_volume END AS wi_volume_imp,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.raw_wi_volume / vp.si_to_imp_conv_factor) * -1 ELSE rbp.raw_wi_volume / vp.si_to_imp_conv_factor END AS wi_volume_met,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.raw_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 ELSE (rbp.raw_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS wi_volume_boe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.raw_wi_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 ELSE rbp.raw_wi_volume * ISNULL (vp.mcfe6_thermal, 1) END AS wi_volume_mcfe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.raw_ri_volume * -1 ELSE rbp.raw_ri_volume END AS ri_volume_imp,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.raw_ri_volume / vp.si_to_imp_conv_factor) * -1 ELSE rbp.raw_ri_volume / vp.si_to_imp_conv_factor END AS ri_volume_met,
	CASE WHEN sign_flip_flag = 'Y' THEN (rbp.raw_ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 ELSE (rbp.raw_ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS ri_volume_boe,
	CASE WHEN sign_flip_flag = 'Y' THEN rbp.raw_ri_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 ELSE rbp.raw_ri_volume * ISNULL (vp.mcfe6_thermal, 1) END AS ri_volume_mcfe, 
	NULL AS fi_volume_imp,
	NULL AS fi_volume_met,
	NULL AS fi_volume_boe,
	NULL AS fi_volume_mcfe,
	e.formatted_id,
	RTRIM(LTRIM (e.unique_id)) AS uwi,
	cast(rl.reserve_category_id as varchar(50)) AS reserve_category_id,
	'Raw' + cl.long_name AS accounts,
	'Budget' AS scenario_type,
	vev2.cube_child_member AS scenario,
	vp.si_to_imp_conv_factor,
	vp.boe_thermal,
	vp.mcfe6_thermal,
	od.onstream_date,
	CAST(CASE WHEN od.onstream_date IS NULL THEN -1 ELSE CASE
		WHEN (datediff(day,od.onstream_date,rbp.step_date)+1 <=  pdo.production_days_on_cutoff
		AND datediff(day,od.onstream_date,rbp.step_date)+1 >= 0) THEN  datediff(day,od.onstream_date,rbp.step_date)+1 ELSE -1 END END AS varchar(5)) normalized_time_key
FROM (
	SELECT year(cast(variable_value as datetime)) first_year
	FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name='VALNAV_ACTIVITY_DATE_START'
) trs
, (
	SELECT year(cast(variable_value as datetime)) last_year
	FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name='VALNAV_ACTIVITY_DATE_END'
) tre
, (
	SELECT int_value as production_days_on_cutoff
	FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name = 'PRODUCTION_DAYS_ON_CUTOFF'
) pdo
, stage_valnav.t_budget_results_btax_product rbp
LEFT OUTER JOIN stage_valnav.t_budget_results_lookup rl ON rbp.result_id = rl.result_id
LEFT OUTER JOIN stage_valnav.t_budget_entity e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value
INNER JOIN (
		SELECT fsp.object_id, fsp.long_name
		FROM stage_valnav.t_budget_code_lookup cl
		join stage_valnav.t_budget_fisc_reserves_product fsp on cl.LONG_NAME = fsp.LONG_NAME
		WHERE code_type = 'RESERVES_PRODUCT_TYPE'
) cl ON rbp.product_id = cl.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.*
		FROM stage_valnav.t_budget_fisc_scenario fs
		LEFT OUTER JOIN stage_valnav.t_budget_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
LEFT OUTER JOIN [stage].t_ctrl_valnav_products vp on cl.long_name = vp.accounts
inner join (
		select cfd.parent_id
			, ltrim(rtrim(cfd.string_value)) as variable_value
			, cfd.cube_child_member
			, cfd.sign_flip_flag
		from (
				select c.*
					, v.cube_child_member, v.sign_flip_flag
					, row_number() over (	partition by parent_id 
											order by case ltrim(rtrim(c.name)) 
													when 'Budget Year' then 3 
													when 'DISTRICT' then 2 
													when 'CAPITAL GROUP' then 1 end) rnk
				FROM [stage].t_stg_valnav_budget_ent_custom_field_def c
				join [stage].t_ctrl_valnav_etl_variables v on ltrim(rtrim(c.string_value)) = v.variable_value
				WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT', 'CAPITAL GROUP')
				and v.variable_name = 'BUDGET_BUDGET_YEAR'
		) cfd 
		where rnk = 1	
) vev2 on rl.entity_id = vev2.parent_id
LEFT OUTER JOIN (
		SELECT object_id, first_step_date onstream_date
		FROM [stage].t_valnav_onstream_date_budget
) od ON rl.entity_id = od.object_id
WHERE rl.plan_definition_id = 0
AND vp.product_id IN (2,17)  --> Gas , Solution Gas Product ID
AND year(rbp.step_date) BETWEEN trs.first_year AND tre.last_year;