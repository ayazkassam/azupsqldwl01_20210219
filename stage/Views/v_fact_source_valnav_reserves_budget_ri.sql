CREATE VIEW [stage].[v_fact_source_valnav_reserves_budget_ri]
AS SELECT entity_id,
	formatted_id,
	uwi,
	reserve_category_id,
	accounts,
	scenario_type,
	scenario,
	booked_date,
	sum(ri_volume_imp) ri_volume_imp,
	sum(ri_volume_met) ri_volume_met,
	sum(ri_volume_boe) ri_volume_boe,
	sum(ri_volume_mcfe) ri_volume_mcfe
FROM ( /*-- Sales volume from Budget*/
	SELECT e.object_id entity_id,
		ISNULL (rrd.date_value, CAST (rbd.reserve_book_date AS datetime)) AS booked_date,
		CASE WHEN sign_flip_flag = 'Y' THEN rbp.ri_volume * -1 ELSE rbp.ri_volume END AS ri_volume_imp, 
		CASE WHEN sign_flip_flag = 'Y' THEN (rbp.ri_volume / vp.si_to_imp_conv_factor) * -1 ELSE rbp.ri_volume / vp.si_to_imp_conv_factor END AS ri_volume_met,
		CASE WHEN sign_flip_flag = 'Y' THEN (rbp.ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal * -1 ELSE (rbp.ri_volume / vp.si_to_imp_conv_factor) * vp.boe_thermal END AS ri_volume_boe,
		CASE WHEN sign_flip_flag = 'Y' THEN rbp.ri_volume * ISNULL (vp.mcfe6_thermal, 1) * -1 ELSE rbp.ri_volume * ISNULL (vp.mcfe6_thermal, 1) END AS ri_volume_mcfe,
		e.formatted_id,
		RTRIM(LTRIM (e.unique_id)) AS uwi,
		cast(rl.reserve_category_id as varchar(50)) AS reserve_category_id,
		'Res_' + cl.long_name AS accounts,
		'Budget' AS scenario_type,
		vev2.cube_child_member AS scenario
	FROM (
			SELECT variable_value AS reserve_book_date
			FROM stage.t_ctrl_valnav_etl_variables
			WHERE variable_name = 'RESERVE_BOOK_DATE'
	) rbd
	, stage_valnav.t_budget_RESULTS_BTAX_PRODUCT rbp
	LEFT OUTER JOIN stage_valnav.t_budget_RESULTS_LOOKUP rl ON rbp.result_id = rl.result_id
	LEFT OUTER JOIN stage_valnav.t_budget_ENTITY e ON rl.entity_id = e.object_id
	INNER JOIN (
			SELECT variable_value
			FROM stage.t_ctrl_valnav_etl_variables
			WHERE variable_name = 'RESERVE_CATEGORY_ID'
	) vev ON rl.reserve_category_id = vev.variable_value
	INNER JOIN (
			SELECT fsp.object_id, fsp.long_name
			FROM stage_valnav.t_budget_CODE_LOOKUP cl
			join stage_valnav.t_budget_FISC_RESERVES_PRODUCT fsp on cl.LONG_NAME = fsp.LONG_NAME
			WHERE code_type = 'RESERVES_PRODUCT_TYPE'
	) cl ON rbp.product_id = cl.object_id
	INNER JOIN (
			SELECT fsp.plan_id, fs.*
			FROM stage_valnav.t_budget_FISC_SCENARIO fs
			LEFT OUTER JOIN stage_valnav.t_budget_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
			WHERE fs.name = '<Current Options>'
	) sn ON rl.scenario_id = sn.object_id
	LEFT OUTER JOIN [stage].t_ctrl_valnav_products vp ON cl.long_name = vp.accounts /*rbp.product_id = vp.product_id*/
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
	AND vp.product_id <> 10 /*-- exclude Water*/
	AND isnull (UPPER (LTRIM(RTRIM(vn.nra))), 'Y') <> 'NRA'
) SD
WHERE isnull(ri_volume_boe,0) <> 0
GROUP BY entity_id,formatted_id,uwi,reserve_category_id,accounts,scenario_type,scenario,booked_date;