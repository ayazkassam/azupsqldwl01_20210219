CREATE VIEW [stage].[v_fact_source_valnav_reserves_GLJreserves] AS SELECT e.object_id AS entity_guid,
		ISNULL (rrd.date_value, CAST (rbd.reserve_book_date AS datetime)) AS booked_date,
		vp.product_id,

		rsp.TECH_REM_GROSS_VOLUME gross_volume_imp,		
		rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor AS gross_volume_met,
		(rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor) * vp.boe_thermal AS gross_volume_boe,
		rsp.TECH_REM_GROSS_VOLUME * isnull (vp.mcfe6_thermal, 1) AS gross_volume_mcfe,

		rsp.tech_rem_wi_volume wi_volume_imp,
		rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor AS wi_volume_met,
		(rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS wi_volume_boe,
		rsp.tech_rem_wi_volume * isnull(vp.mcfe6_thermal, 1) AS wi_volume_mcfe,

		rsp.tech_rem_ri_volume ri_volume_imp,
		rsp.tech_rem_ri_volume / vp.si_to_imp_conv_factor AS ri_volume_met,
		(rsp.tech_rem_ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS ri_volume_boe,
		rsp.tech_rem_ri_volume * isnull(vp.mcfe6_thermal, 1) AS ri_volume_mcfe,

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
		'Booked_Res_' + cl.long_name AS accounts,
		'GLJ Reserves' AS scenario_type,
		vev2.variable_value AS scenario,
		vp.si_to_imp_conv_factor,
		vp.boe_thermal,
		vp.mcfe6_thermal
	FROM (	SELECT variable_value AS reserve_book_date
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'RESERVE_BOOK_DATE'
	) rbd
	, (	SELECT variable_value
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'GLJ_RESERVES_CUBE_SCENARIO_VOLUMES'
		AND isnull (sign_flip_flag, 'N') <> 'Y'
	) vev2
/*	, stage_valnav.t_reserves_dbo.RESULTS_SUMMARY_PRODUCT rsp */

	, (SELECT  result_id,
        product_id,
		sum(gross_volume) tech_rem_gross_volume,
		sum(wi_volume)  tech_rem_wi_volume,
		sum(ri_volume)  tech_rem_ri_volume

       FROM stage_valnav.t_reserves_RESULTS_BTAX_PRODUCT 
       GROUP BY result_id, product_id
	) rsp


	LEFT OUTER JOIN stage_valnav.t_reserves_RESULTS_LOOKUP rl ON rsp.result_id = rl.result_id 
	LEFT OUTER JOIN stage_valnav.t_reserves_ENTITY e ON rl.entity_id = e.object_id
	INNER JOIN (
			SELECT fsp.object_id, fsp.long_name
			FROM stage_valnav.t_typecurves_CODE_LOOKUP cl
			join stage_valnav.t_typecurves_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
			WHERE code_type = 'RESERVES_PRODUCT_TYPE'
	) cl ON rsp.product_id = cl.object_id
	INNER JOIN (
			SELECT fsp.plan_id, fs.OBJECT_ID
			FROM stage_valnav.t_reserves_FISC_SCENARIO fs
			LEFT OUTER JOIN stage_valnav.t_reserves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
			WHERE fs.name = '<Current Options>'
	) sn ON rl.scenario_id = sn.object_id
	INNER JOIN (
			SELECT *
			FROM [stage].t_ctrl_valnav_products
			WHERE product_id <> 10
	)  vp ON cl.long_name = vp.accounts
	INNER JOIN (
			SELECT name, parent_id, string_value
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE name='text 1' and string_value in ('Total Properties') --('BNP Evaluated Properties','GLJ Evaluated Properties')
	) cfd ON rl.entity_id = cfd.parent_id
	INNER JOIN (
			SELECT variable_value, cube_child_member
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
	) vev ON rl.reserve_category_id = vev.cube_child_member
	LEFT OUTER JOIN (
			SELECT parent_id, date_value
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE ltrim(rtrim(name))='Reserves Realized Date'
	) rrd ON rl.entity_id = rrd.parent_id
	WHERE rl.plan_definition_id = 0
	and e.OBJECT_ID is not null

	union all

	/*reserves analysis*/
	SELECT e.object_id AS entity_guid,
		ISNULL(rrd.date_value, CAST (rbd.reserve_book_date AS datetime)) AS booked_date,
		vp.product_id,

		rsp.TECH_REM_GROSS_VOLUME gross_volume_imp,		
		rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor AS gross_volume_met,
		(rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor) * vp.boe_thermal AS gross_volume_boe,
		rsp.TECH_REM_GROSS_VOLUME * isnull (vp.mcfe6_thermal, 1) AS gross_volume_mcfe,

		rsp.tech_rem_wi_volume   wi_volume_imp,
		rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor AS wi_volume_met,
		(rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS wi_volume_boe,
		rsp.tech_rem_wi_volume * isnull(vp.mcfe6_thermal, 1) AS wi_volume_mcfe,

		rsp.tech_rem_ri_volume   ri_volume_imp,
		rsp.tech_rem_ri_volume / vp.si_to_imp_conv_factor AS ri_volume_met,
		(rsp.tech_rem_ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS ri_volume_boe,
		rsp.tech_rem_ri_volume * isnull(vp.mcfe6_thermal, 1) AS ri_volume_mcfe,

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
		'GLJ Reserves' AS scenario_type,
		vev2.variable_value AS scenario,
		vp.si_to_imp_conv_factor,
		vp.boe_thermal,
		vp.mcfe6_thermal
	FROM (
		SELECT variable_value AS reserve_book_date
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVE_BOOK_DATE'
	) rbd
	, (
		SELECT variable_value, cube_child_member
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVES_ANALYSIS_SCENARIO'
		AND isnull (sign_flip_flag, 'N') <> 'Y'
	) vev2

/*	, stage_valnav.t_reserves_dbo.RESULTS_SUMMARY_PRODUCT rsp */

	, (SELECT  result_id,
        product_id,
		sum(gross_volume) tech_rem_gross_volume,
		sum(wi_volume)  tech_rem_wi_volume,
		sum(ri_volume)  tech_rem_ri_volume

       FROM stage_valnav.t_reserves_RESULTS_BTAX_PRODUCT 
       GROUP BY result_id, product_id
	  ) rsp

	LEFT OUTER JOIN stage_valnav.t_reserves_RESULTS_LOOKUP rl ON rsp.result_id = rl.result_id
	LEFT OUTER JOIN stage_valnav.t_reserves_ENTITY e ON rl.entity_id = e.object_id
	INNER JOIN (
			SELECT fsp.object_id, fsp.long_name
			FROM stage_valnav.t_typecurves_CODE_LOOKUP cl
			join stage_valnav.t_typecurves_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
			WHERE code_type = 'RESERVES_PRODUCT_TYPE'
	) cl ON rsp.product_id = cl.object_id
	INNER JOIN (
			SELECT fsp.plan_id, fs.OBJECT_ID
			FROM stage_valnav.t_reserves_FISC_SCENARIO fs
			LEFT OUTER JOIN stage_valnav.t_reserves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
			WHERE fs.name = '<Current Options>'
	) sn ON rl.scenario_id = sn.object_id
	INNER JOIN (
			SELECT * 
			FROM [stage].t_ctrl_valnav_products
			WHERE product_id <> 10
	) vp ON cl.long_name = vp.accounts
	INNER JOIN (
			SELECT parent_id, string_value
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE name='text 1' and string_value in ('Total Properties') --('BNP Evaluated Properties','GLJ Evaluated Properties')
	) cfd ON rl.entity_id = cfd.parent_id
	INNER JOIN (
			SELECT variable_value, cube_child_member
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
	) vev ON rl.reserve_category_id = vev.cube_child_member

	LEFT OUTER JOIN (
			SELECT *
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE ltrim(rtrim(name))='Reserves Realized Date'
	) rrd ON rl.entity_id = rrd.parent_id
	WHERE rl.plan_definition_id = 0

--
UNION ALL
--
-- RAW GAS VOLUMES
--

	/*reserves analysis*/
	SELECT e.object_id AS entity_guid,
		ISNULL(rrd.date_value, CAST (rbd.reserve_book_date AS datetime)) AS booked_date,
		vp.product_id,

		rsp.TECH_REM_GROSS_VOLUME gross_volume_imp,		
		rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor AS gross_volume_met,
		(rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor) * vp.boe_thermal AS gross_volume_boe,
		rsp.TECH_REM_GROSS_VOLUME * isnull (vp.mcfe6_thermal, 1) AS gross_volume_mcfe,

		rsp.tech_rem_wi_volume wi_volume_imp,
		rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor AS wi_volume_met,
		(rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS wi_volume_boe,
		rsp.tech_rem_wi_volume * isnull(vp.mcfe6_thermal, 1) AS wi_volume_mcfe,

		rsp.tech_rem_ri_volume ri_volume_imp,
		rsp.tech_rem_ri_volume / vp.si_to_imp_conv_factor AS ri_volume_met,
		(rsp.tech_rem_ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS ri_volume_boe,
		rsp.tech_rem_ri_volume * isnull(vp.mcfe6_thermal, 1) AS ri_volume_mcfe,

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
		'GLJ Reserves' AS scenario_type,
		vev2.variable_value AS scenario,
		vp.si_to_imp_conv_factor,
		vp.boe_thermal,
		vp.mcfe6_thermal
	FROM (
		SELECT variable_value AS reserve_book_date
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVE_BOOK_DATE'
	) rbd
	, (
		SELECT variable_value, cube_child_member
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVES_ANALYSIS_SCENARIO'
		AND isnull (sign_flip_flag, 'N') <> 'Y'
	) vev2

/*	, stage_valnav.t_reserves_dbo.RESULTS_SUMMARY_PRODUCT rsp */

	, (SELECT  result_id,
        product_id,
		sum(raw_gross_volume) tech_rem_gross_volume,
		sum(raw_wi_volume)  tech_rem_wi_volume,
		sum(raw_ri_volume)  tech_rem_ri_volume

       FROM stage_valnav.t_reserves_RESULTS_BTAX_PRODUCT 
       GROUP BY result_id, product_id
	  ) rsp

	LEFT OUTER JOIN stage_valnav.t_reserves_RESULTS_LOOKUP rl ON rsp.result_id = rl.result_id
	LEFT OUTER JOIN stage_valnav.t_reserves_ENTITY e ON rl.entity_id = e.object_id
	INNER JOIN (
			SELECT fsp.object_id, fsp.long_name
			FROM stage_valnav.t_typecurves_CODE_LOOKUP cl
			join stage_valnav.t_typecurves_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
			WHERE code_type = 'RESERVES_PRODUCT_TYPE'
	) cl ON rsp.product_id = cl.object_id
	INNER JOIN (
			SELECT fsp.plan_id, fs.OBJECT_ID
			FROM stage_valnav.t_reserves_FISC_SCENARIO fs
			LEFT OUTER JOIN stage_valnav.t_reserves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
			WHERE fs.name = '<Current Options>'
	) sn ON rl.scenario_id = sn.object_id
	INNER JOIN (
			SELECT * 
			FROM [stage].t_ctrl_valnav_products
			WHERE product_id <> 10
	) vp ON cl.long_name = vp.accounts
	INNER JOIN (
			SELECT parent_id, string_value
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE name='text 1' and string_value in ('Total Properties') --('BNP Evaluated Properties','GLJ Evaluated Properties')
	) cfd ON rl.entity_id = cfd.parent_id
	INNER JOIN (
			SELECT variable_value, cube_child_member
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
	) vev ON rl.reserve_category_id = vev.cube_child_member

	LEFT OUTER JOIN (
			SELECT *
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE ltrim(rtrim(name))='Reserves Realized Date'
	) rrd ON rl.entity_id = rrd.parent_id
	WHERE rl.plan_definition_id = 0
	AND vp.product_id IN (2, 17)--> GAS, LIQUID

--
   UNION ALL
-- 

	/*working budget incremental*/
	/* This scenario data goes to Valnav cube */

	SELECT e.object_id AS entity_guid,
		ISNULL (rrd.date_value, CAST (rbd.reserve_book_date AS datetime)) AS booked_date,
		vp.product_id,

		rsp.TECH_REM_GROSS_VOLUME gross_volume_imp,		
		rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor AS gross_volume_met,
		(rsp.TECH_REM_GROSS_VOLUME / vp.si_to_imp_conv_factor) * vp.boe_thermal AS gross_volume_boe,
		rsp.TECH_REM_GROSS_VOLUME * isnull (vp.mcfe6_thermal, 1) AS gross_volume_mcfe,

		rsp.tech_rem_wi_volume wi_volume_imp,
		rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor AS wi_volume_met,
		(rsp.tech_rem_wi_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS wi_volume_boe,
		rsp.tech_rem_wi_volume * isnull(vp.mcfe6_thermal, 1) AS wi_volume_mcfe,

		rsp.tech_rem_ri_volume   ri_volume_imp,
		rsp.tech_rem_ri_volume / vp.si_to_imp_conv_factor AS ri_volume_met,
		(rsp.tech_rem_ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal AS ri_volume_boe,
		rsp.tech_rem_ri_volume * isnull(vp.mcfe6_thermal, 1) AS ri_volume_mcfe,

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
		'Booked_Res_Raw' + cl.long_name AS accounts,
		'GLJ Reserves' AS scenario_type,
		vev2.variable_value AS scenario,
		vp.si_to_imp_conv_factor,
		vp.boe_thermal,
		vp.mcfe6_thermal
	FROM (	SELECT variable_value AS reserve_book_date
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'RESERVE_BOOK_DATE'
	) rbd
	, (	SELECT variable_value
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'GLJ_RESERVES_CUBE_SCENARIO_VOLUMES'
		AND isnull (sign_flip_flag, 'N') <> 'Y'
	) vev2
/*	, stage_valnav.t_reserves_dbo.RESULTS_SUMMARY_PRODUCT rsp */

	, (SELECT  result_id,
        product_id,
		sum(raw_gross_volume) tech_rem_gross_volume,
		sum(raw_wi_volume)  tech_rem_wi_volume,
		sum(raw_ri_volume)  tech_rem_ri_volume

       FROM stage_valnav.t_reserves_RESULTS_BTAX_PRODUCT 
       GROUP BY result_id, product_id
	) rsp


	LEFT OUTER JOIN stage_valnav.t_reserves_RESULTS_LOOKUP rl ON rsp.result_id = rl.result_id 
	LEFT OUTER JOIN stage_valnav.t_reserves_ENTITY e ON rl.entity_id = e.object_id
	INNER JOIN (
			SELECT fsp.object_id, fsp.long_name
			FROM stage_valnav.t_typecurves_CODE_LOOKUP cl
			join stage_valnav.t_typecurves_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
			WHERE code_type = 'RESERVES_PRODUCT_TYPE'
	) cl ON rsp.product_id = cl.object_id
	INNER JOIN (
			SELECT fsp.plan_id, fs.OBJECT_ID
			FROM stage_valnav.t_reserves_FISC_SCENARIO fs
			LEFT OUTER JOIN stage_valnav.t_reserves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
			WHERE fs.name = '<Current Options>'
	) sn ON rl.scenario_id = sn.object_id
	INNER JOIN (
			SELECT *
			FROM [stage].t_ctrl_valnav_products
			WHERE product_id <> 10
	)  vp ON cl.long_name = vp.accounts
	INNER JOIN (
			SELECT name, parent_id, string_value
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE name='text 1' and string_value in ('total Properties') --('BNP Evaluated Properties','GLJ Evaluated Properties')
	) cfd ON rl.entity_id = cfd.parent_id
	INNER JOIN (
			SELECT variable_value, cube_child_member
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
	) vev ON rl.reserve_category_id = vev.cube_child_member
	LEFT OUTER JOIN (
			SELECT parent_id, date_value
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE ltrim(rtrim(name))='Reserves Realized Date'
	) rrd ON rl.entity_id = rrd.parent_id
	WHERE rl.plan_definition_id = 0
	and e.OBJECT_ID is not null
	AND vp.product_id IN (2, 17);