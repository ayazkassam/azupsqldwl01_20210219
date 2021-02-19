CREATE VIEW [stage].[v_fact_source_valnav_reserves_typecurves]
AS SELECT e.object_id AS entity_guid,
	ISNULL(rrd.date_value, CAST (rbd.reserve_book_date AS datetime)) AS booked_date,
	vp.product_id,
	rsp.TECH_REM_GROSS_VOLUME tech_gross_volume,
	rsp.tech_rem_wi_volume tech_wi_volume,
	rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor AS gross_volume_met,
	(rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor) * vp.boe_thermal AS gross_volume_boe,
	rsp.TECH_REM_GROSS_VOLUME * isnull (vp.mcfe6_thermal, 1) AS gross_volume_mcfe,
	rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor AS wi_volume_met,
	(rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS wi_volume_boe,
	rsp.tech_rem_wi_volume * isnull(vp.mcfe6_thermal, 1) AS wi_volume_mcfe,

	/*
	rsp.tech_gross_volume,
	rsp.tech_wi_volume,
	rsp.tech_gross_volume / vp.si_to_imp_conv_factor AS gross_volume_met,
	(rsp.tech_gross_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS gross_volume_boe,
	rsp.tech_gross_volume * isnull (vp.mcfe6_thermal, 1) AS gross_volume_mcfe,
	rsp.tech_wi_volume / vp.si_to_imp_conv_factor AS wi_volume_met,
	(rsp.tech_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS wi_volume_boe,
	rsp.tech_wi_volume * isnull(vp.mcfe6_thermal, 1) AS wi_volume_mcfe,
	*/
	rl.entity_id,
	e.formatted_id,
	RTRIM(LTRIM (e.unique_id)) uwi,
	rl.reserve_category_id,
	'Res_' + cl.long_name AS accounts,
	'Type Curve' AS scenario_type,
	vev2.cube_child_member AS scenario,
	vp.si_to_imp_conv_factor,
	vp.boe_thermal,
	vp.mcfe6_thermal
FROM (
	SELECT variable_value AS reserve_book_date
	FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name = 'RESERVE_BOOK_DATE'
) rbd
, stage_valnav.t_typecurves_RESULTS_SUMMARY_PRODUCT rsp
LEFT OUTER JOIN stage_valnav.t_typecurves_RESULTS_LOOKUP rl ON rsp.result_id = rl.result_id
LEFT OUTER JOIN stage_valnav.t_typecurves_ENTITY e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT fsp.object_id, fsp.long_name
		FROM stage_valnav.t_typecurves_CODE_LOOKUP cl
		join stage_valnav.t_typecurves_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
		WHERE code_type = 'RESERVES_PRODUCT_TYPE'
) cl ON rsp.product_id = cl.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.OBJECT_ID
		FROM stage_valnav.t_typecurves_FISC_SCENARIO fs
		LEFT OUTER JOIN stage_valnav.t_typecurves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
INNER JOIN (
		SELECT * 
		FROM [stage].t_ctrl_valnav_products
		WHERE product_id <> 10
) vp ON cl.long_name = vp.accounts
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
		WHERE name='Budget Year'
) cfd ON rl.entity_id = cfd.parent_id
INNER JOIN (
		SELECT variable_value
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value
INNER JOIN (
		SELECT variable_value, cube_child_member
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_BUDGET_YEAR'
		AND isnull (sign_flip_flag, 'N') <> 'Y'
) vev2 ON  ltrim(rtrim(cfd.string_value)) = vev2.variable_value
LEFT OUTER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
		WHERE ltrim(rtrim(name))='Reserves Realized Date'
) rrd ON rl.entity_id = rrd.parent_id
LEFT OUTER JOIN (
		SELECT parent_id, name, string_value AS nra
		FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
		WHERE UPPER (RTRIM (LTRIM(NAME))) = 'NRA'
) vn ON rl.entity_id = vn.parent_id
WHERE rl.plan_definition_id = 0
AND isnull (UPPER (LTRIM(RTRIM(vn.nra))), 'Y') <> 'NRA';