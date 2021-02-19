CREATE VIEW [stage].[v_fact_source_valnav_reserves_budget]
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
	'Budget' AS scenario_type,
	vev2.cube_child_member AS scenario,
	vp.si_to_imp_conv_factor,
	vp.boe_thermal,
	vp.mcfe6_thermal

FROM (
	SELECT variable_value AS reserve_book_date
	FROM stage.t_ctrl_valnav_etl_variables
	WHERE variable_name = 'RESERVE_BOOK_DATE'
) rbd
--, [BNPBUDGETSCOPY].RESULTS_SUMMARY_PRODUCT rsp
, (SELECT  result_id,
        product_id,
		sum(gross_volume) tech_rem_gross_volume,
		sum(wi_volume)  tech_rem_wi_volume,
		sum(ri_volume)  tech_rem_ri_volume

       FROM stage_valnav.t_budget_RESULTS_BTAX_PRODUCT  
       GROUP BY result_id, product_id
	) rsp

LEFT OUTER JOIN stage_valnav.t_budget_RESULTS_LOOKUP rl ON rsp.result_id = rl.result_id
LEFT OUTER JOIN stage_valnav.t_budget_ENTITY e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT fsp.object_id, fsp.long_name
		FROM stage_valnav.t_budget_CODE_LOOKUP cl
		join stage_valnav.t_budget_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
		WHERE code_type = 'RESERVES_PRODUCT_TYPE'
) cl ON rsp.product_id = cl.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.*
		FROM stage_valnav.t_budget_FISC_SCENARIO fs
		LEFT OUTER JOIN stage_valnav.t_budget_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
INNER JOIN (
		SELECT * 
		FROM [stage].t_ctrl_valnav_products
		WHERE product_id <> 10
) vp ON cl.long_name = vp.accounts

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
				and isnull (v.sign_flip_flag, 'N') <> 'Y'
		) cfd 
		where rnk = 1	
) vev2 on rl.entity_id = vev2.parent_id

INNER JOIN (
		SELECT variable_value
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value

LEFT OUTER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_budget_ent_custom_field_def
		WHERE ltrim(rtrim(name))='Reserves Realized Date'
) rrd ON rl.entity_id = rrd.parent_id
LEFT OUTER JOIN (
		SELECT parent_id, name, string_value AS nra
		FROM [stage].t_stg_valnav_budget_ent_custom_field_def
		WHERE UPPER (RTRIM (LTRIM(NAME))) = 'NRA'
) vn ON rl.entity_id = vn.parent_id
WHERE rl.plan_definition_id = 0
AND isnull (UPPER (LTRIM(RTRIM(vn.nra))), 'Y') <> 'NRA'
--
UNION ALL
--
-- RAw RESERVES
SELECT e.object_id AS entity_guid,
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
	'RawRes_' + cl.long_name AS accounts,
	'Budget' AS scenario_type,
	vev2.cube_child_member AS scenario,
	vp.si_to_imp_conv_factor,
	vp.boe_thermal,
	vp.mcfe6_thermal

FROM (
	SELECT variable_value AS reserve_book_date
	FROM stage.t_ctrl_valnav_etl_variables
	WHERE variable_name = 'RESERVE_BOOK_DATE'
) rbd
--, [BNPBUDGETSCOPY].RESULTS_SUMMARY_PRODUCT rsp
, (SELECT  result_id,
        product_id,
		sum(raw_gross_volume) tech_rem_gross_volume,
		sum(raw_wi_volume)  tech_rem_wi_volume,
		sum(raw_ri_volume)  tech_rem_ri_volume

       FROM stage_valnav.t_budget_RESULTS_BTAX_PRODUCT 
       GROUP BY result_id, product_id
	) rsp

LEFT OUTER JOIN stage_valnav.t_budget_RESULTS_LOOKUP rl ON rsp.result_id = rl.result_id
LEFT OUTER JOIN stage_valnav.t_budget_ENTITY e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT fsp.object_id, fsp.long_name
		FROM stage_valnav.t_budget_CODE_LOOKUP cl
		join stage_valnav.t_budget_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
		WHERE code_type = 'RESERVES_PRODUCT_TYPE'
) cl ON rsp.product_id = cl.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.*
		FROM stage_valnav.t_budget_FISC_SCENARIO fs
		LEFT OUTER JOIN stage_valnav.t_budget_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
INNER JOIN (
		SELECT * 
		FROM [stage].t_ctrl_valnav_products
		WHERE product_id IN (2, 17)--> GAS, LIQUID
) vp ON cl.long_name = vp.accounts

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
				and isnull (v.sign_flip_flag, 'N') <> 'Y'
		) cfd 
		where rnk = 1	
) vev2 on rl.entity_id = vev2.parent_id

INNER JOIN (
		SELECT variable_value
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value

LEFT OUTER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_budget_ent_custom_field_def
		WHERE ltrim(rtrim(name))='Reserves Realized Date'
) rrd ON rl.entity_id = rrd.parent_id
LEFT OUTER JOIN (
		SELECT parent_id, name, string_value AS nra
		FROM [stage].t_stg_valnav_budget_ent_custom_field_def
		WHERE UPPER (RTRIM (LTRIM(NAME))) = 'NRA'
) vn ON rl.entity_id = vn.parent_id
WHERE rl.plan_definition_id = 0
AND isnull (UPPER (LTRIM(RTRIM(vn.nra))), 'Y') <> 'NRA';