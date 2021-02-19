CREATE VIEW [stage].[v_fact_source_valnav_production_typecurves]
AS SELECT e.object_id entity_guid,
	rbp.step_date,
	vp.product_id,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.gross_volume * -1 ELSE rbp.gross_volume END AS gross_volume_imp,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.gross_volume / vp.si_to_imp_conv_factor) * -1 
		ELSE rbp.gross_volume / vp.si_to_imp_conv_factor END AS gross_volume_met,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 
		ELSE (rbp.gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS gross_volume_boe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.gross_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 
		ELSE rbp.gross_volume * ISNULL (vp.mcfe6_thermal, 1) END AS gross_volume_mcfe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.wi_volume * -1 ELSE rbp.wi_volume END AS wi_volume_imp,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.wi_volume / vp.si_to_imp_conv_factor) * -1 
		ELSE rbp.wi_volume / vp.si_to_imp_conv_factor END AS wi_volume_met,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 
		ELSE (rbp.wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS wi_volume_boe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.wi_volume * ISNULL (vp.mcfe6_thermal, 1) * -1	
		ELSE rbp.wi_volume * ISNULL (vp.mcfe6_thermal, 1) END AS wi_volume_mcfe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.ri_volume * -1 ELSE rbp.ri_volume END AS ri_volume_imp,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.ri_volume / vp.si_to_imp_conv_factor) * -1 
		ELSE rbp.ri_volume / vp.si_to_imp_conv_factor END AS ri_volume_met,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 
		ELSE (rbp.ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS ri_volume_boe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.ri_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 
		ELSE rbp.ri_volume * ISNULL (vp.mcfe6_thermal, 1) END AS ri_volume_mcfe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.fi_volume * -1 ELSE rbp.fi_volume END AS fi_volume_imp,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.fi_volume / vp.si_to_imp_conv_factor) * -1 
		ELSE rbp.fi_volume / vp.si_to_imp_conv_factor END AS fi_volume_met,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.fi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 
		ELSE (rbp.fi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS fi_volume_boe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.fi_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 
		ELSE rbp.fi_volume * ISNULL (vp.mcfe6_thermal, 1) END AS fi_volume_mcfe,
	e.formatted_id,
	RTRIM (LTRIM(e.unique_id)) uwi,
	vevrc.cube_child_member AS reserve_category_id,
	CASE WHEN vp.product_id = 2 THEN 'Sales' + cl.long_name ELSE cl.long_name END AS accounts,
	'Type Curve' AS scenario_type, 
	vevby.cube_child_member AS scenario,
	vp.si_to_imp_conv_factor,
	vp.boe_thermal,
	vp.mcfe6_thermal,
	od.onstream_date,
	CAST(CASE WHEN od.onstream_date IS NULL THEN -1 
		ELSE CASE WHEN (datediff(day,od.onstream_date,rbp.step_date)+1 <=  pdo.production_days_on_cutoff AND datediff(day,od.onstream_date,rbp.step_date)+1 >= 0) 
		THEN datediff(day,od.onstream_date,rbp.step_date)+1 ELSE -1 END END AS varchar(5)) normalized_time_key 
FROM (
	SELECT year(cast(variable_value as datetime)) first_year
	FROM [stage].t_ctrl_valnav_etl_variables
	WHERE variable_name='VALNAV_ACTIVITY_DATE_START'
) trs
, (
	SELECT year(cast(variable_value as datetime)) last_year
	FROM [stage].t_ctrl_valnav_etl_variables
	WHERE variable_name='VALNAV_ACTIVITY_DATE_END'
	) tre
, (
	SELECT int_value as production_days_on_cutoff
	FROM [stage].[t_ctrl_valnav_etl_variables]
	WHERE variable_name = 'PRODUCTION_DAYS_ON_CUTOFF'
) pdo
, stage_valnav.t_typecurves_RESULTS_BTAX_PRODUCT rbp
LEFT OUTER JOIN stage_valnav.t_typecurves_RESULTS_LOOKUP rl ON rbp.result_id = rl.result_id
LEFT OUTER JOIN stage_valnav.t_typecurves_ENTITY e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value, cube_child_member
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_RESERVE_CATEGORY_ID'
) vevrc ON rl.reserve_category_id = vevrc.variable_value
INNER JOIN (
		SELECT fsp.object_id, fsp.long_name
		FROM stage_valnav.t_typecurves_CODE_LOOKUP cl
		join stage_valnav.t_typecurves_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
		WHERE code_type = 'RESERVES_PRODUCT_TYPE'
) cl ON rbp.product_id = cl.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.OBJECT_ID
		FROM stage_valnav.t_typecurves_FISC_SCENARIO fs
		LEFT OUTER JOIN stage_valnav.t_typecurves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
LEFT OUTER JOIN [stage].t_ctrl_valnav_products vp ON cl.long_name = vp.accounts
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
		WHERE upper(name)='BUDGET YEAR'
) cfd ON rl.entity_id = cfd.parent_id
INNER JOIN (
		SELECT variable_value, cube_child_member, sign_flip_flag
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_BUDGET_YEAR'
) vevby ON  ltrim(rtrim(cfd.string_value)) = vevby.variable_value
LEFT OUTER JOIN (
		SELECT object_id, first_step_date onstream_date
		FROM [stage].t_valnav_onstream_date_typecurves
) od ON rl.entity_id = od.object_id
WHERE rl.plan_definition_id = 0
AND year(rbp.step_date) BETWEEN trs.first_year AND tre.last_year
---
UNION ALL
---
/*-- Type Curve RAW Gas*/
SELECT e.object_id AS entity_id,
	rbp.step_date,
	vp.product_id,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.raw_gross_volume * -1 ELSE rbp.raw_gross_volume END AS gross_volume_imp,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.raw_gross_volume / vp.si_to_imp_conv_factor) * -1 
		ELSE rbp.raw_gross_volume / vp.si_to_imp_conv_factor END AS gross_volume_met,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.raw_gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 
		ELSE (rbp.raw_gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS gross_volume_boe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.raw_gross_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 
		ELSE rbp.raw_gross_volume * ISNULL (vp.mcfe6_thermal, 1) END AS gross_volume_mcfe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.raw_wi_volume * -1 ELSE rbp.raw_wi_volume END AS wi_volume_imp,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.raw_wi_volume / vp.si_to_imp_conv_factor) * -1 
		ELSE rbp.raw_wi_volume / vp.si_to_imp_conv_factor END AS wi_volume_met,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.raw_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 
		ELSE (rbp.raw_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS wi_volume_boe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.raw_wi_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 
		ELSE rbp.raw_wi_volume * ISNULL (vp.mcfe6_thermal, 1) END AS wi_volume_mcfe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.raw_ri_volume * -1 ELSE rbp.raw_ri_volume END AS ri_volume_imp, 
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.raw_ri_volume / vp.si_to_imp_conv_factor) * -1 
		ELSE rbp.raw_ri_volume / vp.si_to_imp_conv_factor END AS ri_volume_met,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN (rbp.raw_ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 
		ELSE (rbp.raw_ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS ri_volume_boe,
	CASE WHEN vevby.sign_flip_flag = 'Y' THEN rbp.raw_ri_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 
		ELSE rbp.raw_ri_volume * ISNULL (vp.mcfe6_thermal, 1) END AS ri_volume_mcfe,
	NULL AS fi_volume_imp,
	NULL AS fi_volume_met,
	NULL AS fi_volume_boe,
	NULL AS fi_volume_mcfe,
	e.formatted_id,
	LTRIM(RTRIM(e.unique_id)) AS uwi,
	vevrc.cube_child_member AS reserve_category_id,
	'Raw' + cl.long_name AS accounts,
	'Type Curve' AS scenario_type,
	vevby.cube_child_member AS scenario,
	vp.si_to_imp_conv_factor,
	vp.boe_thermal,
	vp.mcfe6_thermal,
	od.onstream_date,
	CAST(CASE WHEN od.onstream_date IS NULL THEN -1 
		ELSE CASE WHEN (datediff(day,od.onstream_date,rbp.step_date)+1 <=  pdo.production_days_on_cutoff 
				AND datediff(day,od.onstream_date,rbp.step_date)+1 >= 0) 
			THEN datediff(day,od.onstream_date,rbp.step_date)+1 ELSE -1 END END AS varchar(5)) normalized_time_key
FROM (
	SELECT year(cast(variable_value as datetime)) first_year
	FROM [stage].t_ctrl_valnav_etl_variables
	WHERE variable_name='VALNAV_ACTIVITY_DATE_START'
) trs
, (
	SELECT year(cast(variable_value as datetime)) last_year
	FROM [stage].t_ctrl_valnav_etl_variables
	WHERE variable_name='VALNAV_ACTIVITY_DATE_END'
) tre
, (
	SELECT int_value as production_days_on_cutoff
	FROM [stage].[t_ctrl_valnav_etl_variables]
	WHERE variable_name = 'PRODUCTION_DAYS_ON_CUTOFF'
) pdo
, stage_valnav.t_typecurves_RESULTS_BTAX_PRODUCT rbp
LEFT OUTER JOIN stage_valnav.t_typecurves_RESULTS_LOOKUP rl ON rbp.result_id = rl.result_id
LEFT OUTER JOIN stage_valnav.t_typecurves_ENTITY e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value, cube_child_member
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_RESERVE_CATEGORY_ID'
) vevrc ON rl.reserve_category_id = vevrc.variable_value
INNER JOIN (
		SELECT fsp.object_id, fsp.long_name
		FROM stage_valnav.t_typecurves_CODE_LOOKUP cl
		join stage_valnav.t_typecurves_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
		WHERE code_type = 'RESERVES_PRODUCT_TYPE'
) cl ON rbp.product_id = cl.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.OBJECT_ID
		FROM stage_valnav.t_typecurves_FISC_SCENARIO fs
		LEFT OUTER JOIN stage_valnav.t_typecurves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
LEFT OUTER JOIN [stage].t_ctrl_valnav_products vp on cl.long_name = vp.accounts
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
		WHERE upper(name)='BUDGET YEAR'
) cfd ON rl.entity_id = cfd.parent_id
INNER JOIN (
		SELECT variable_value, cube_child_member, sign_flip_flag
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_BUDGET_YEAR'
) vevby ON  ltrim(rtrim(cfd.string_value)) = vevby.variable_value
LEFT OUTER JOIN (
		SELECT object_id, first_step_date onstream_date
		FROM [stage].t_valnav_onstream_date_typecurves
) od ON rl.entity_id = od.object_id
WHERE rl.plan_definition_id = 0
AND vp.product_id IN (2, 17)--> GAS, LIQUID
AND year(rbp.step_date) BETWEEN trs.first_year AND tre.last_year;