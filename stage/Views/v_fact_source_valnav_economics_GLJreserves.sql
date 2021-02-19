CREATE VIEW [stage].[v_fact_source_valnav_economics_GLJreserves] AS SELECT DISTINCT e.object_id AS entity_guid,
		CASE WHEN rbd.reserve_book_date IS NULL 
			THEN CASE WHEN rsum.forecast_start > rsum.production_start THEN rsum.forecast_start  
					ELSE rsum.production_start END 
			ELSE  rbd.reserve_book_date  END AS actvy_date,

		/*CAST(NULL AS float) AS wi_revenue,
		CAST(NULL AS float) AS ri_revenue,*/
		CAST(NULL AS float) AS roy_adj_total,
		CAST(NULL AS float) AS net_op_income,
		CAST(NULL AS float)  AS OpVariable,
		CAST(NULL AS float)  AS OpFixed,

		CAST(ROUND(btax_net_revenue, 12) AS float) AS btax_net_revenue,
		CAST(ROUND(btax_npv1, 12) AS float) AS btax_npv1,
		CAST(ROUND(btax_npv2, 12) AS float) AS btax_npv2,
		CAST(ROUND(btax_npv3, 12) AS float) AS btax_npv3,
		CAST(ROUND(btax_npv4, 12) AS float) AS btax_npv4,
		CAST(ROUND(btax_npv5, 12) AS float) AS btax_npv5,

		CAST(ROUND((rsum.btax_payout * 12), 1) AS float) AS btax_payout_months,
		CAST(ROUND((rsum.btax_ror * 100), 1) AS float) AS btax_ror,
		CAST(rsum.btax_profit_ratio AS float) AS btax_profit_ratio,
		CAST(NULL AS float) cap_wi_abandonment_salvage,

		rl.entity_id,
		e.formatted_id,
		RTRIM(LTRIM (e.unique_id)) AS uwi,
		rl.reserve_category_id,
		'GLJ Reserves' AS scenario_type,
		vev2.variable_value AS scenario,
		1 as section
	FROM (		
			SELECT variable_value AS reserve_book_date
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'RESERVE_BOOK_DATE'
	) rbd
	, (	SELECT variable_value, cube_child_member, sign_flip_flag
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'GLJ_RESERVES_CUBE_SCENARIO_VOLUMES'
	) vev2
	, stage_valnav.t_reserves_results_summary rsum
	LEFT OUTER JOIN  stage_valnav.t_reserves_results_lookup rl ON rsum.result_id = rl.result_id
	LEFT OUTER JOIN stage_valnav.t_reserves_entity e ON rl.entity_id = e.object_id
	INNER JOIN (
			SELECT variable_value, cube_child_member
			FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
	) vev ON rl.reserve_category_id = vev.cube_child_member
	INNER JOIN (
			SELECT fsp.plan_id, fs.OBJECT_ID
			FROM stage_valnav.t_reserves_fisc_scenario fs
			LEFT OUTER JOIN stage_valnav.t_reserves_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
			WHERE fs.name = '<Current Options>'
	) sn ON rl.scenario_id = sn.object_id
	INNER JOIN (
				SELECT parent_id, string_value
				FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
				WHERE name='text 1' and string_value in ('Total Properties') --('BNP Evaluated Properties','GLJ Evaluated Properties')
	) cfd ON rl.entity_id = cfd.parent_id
	WHERE (CASE WHEN rsum.forecast_start > rsum.production_start THEN rsum.forecast_start  ELSE  rsum.production_start END) IS NOT NULL
	AND rl.plan_definition_id = 0
	AND e.entity_type <> 6 /* Exclude Common Termination type entities */

	union all

	/*Reserves Analysis*/
	/*-- Economics data*/
 	SELECT e.object_id AS entity_guid,
		rb.step_date actvy_date,
		/*--rb.wi_revenue,
		--rbp.ri_revenue,*/
		rb.roy_adj_total,
		rb.net_op_income,
		CAST(NULL AS float) AS OpVariable,
		CAST(NULL AS float) AS OpFixed,

		CAST(NULL AS float) AS btax_net_revenue,
		CAST(NULL AS float) AS btax_npv1,
		CAST(NULL AS float) AS btax_npv2,
		CAST(NULL AS float) AS btax_npv3,
		CAST(NULL AS float) AS btax_npv4,
		CAST(NULL AS float) AS btax_npv5,

		NULL AS btax_payout_months,
		NULL AS btax_ror,
		NULL AS btax_profit_ratio,
		rsc.cap_wi_abandonment_salvage,

		rl.entity_id,
		e.formatted_id,
		RTRIM(LTRIM(e.unique_id)) AS uwi,
		rl.reserve_category_id,
		'GLJ Reserves' AS scenario_type,
		vev2.variable_value AS scenario,
		2 as section
	FROM (	SELECT variable_value, cube_child_member, sign_flip_flag
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVES_ANALYSIS_SCENARIO'
		AND ISNULL (sign_flip_flag, 'N') <> 'Y'
	) vev2
	, stage_valnav.t_reserves_results_btax rb
	LEFT OUTER JOIN  stage_valnav.t_reserves_results_lookup rl ON rb.result_id = rl.result_id
	LEFT OUTER JOIN (
			SELECT result_id, step_date, SUM(ri_revenue) AS ri_revenue
			FROM stage_valnav.t_reserves_results_btax_product
			GROUP BY result_id, step_date
			HAVING SUM(ri_revenue) <> 0
	) rbp ON rb.result_id = rbp.result_id AND rb.step_date = rbp.step_date
	LEFT OUTER JOIN (  
			SELECT result_id,
				step_date,
				sum(cap_wi_abandonment+cap_wi_salvage) as cap_wi_abandonment_salvage
			FROM stage_valnav.t_reserves_results_cost
			GROUP BY result_id, step_date
			HAVING SUM (op_wi_wi_variable) + SUM (op_wi_wi_fixed)  + sum(cap_wi_abandonment) +sum(cap_wi_salvage) <> 0
	) rsc ON rb.result_id = rsc.result_id AND rb.step_date = rsc.step_date
	LEFT OUTER JOIN stage_valnav.t_reserves_entity e ON rl.entity_id = e.object_id
	INNER JOIN (
			SELECT fsp.plan_id, fs.object_id
			FROM stage_valnav.t_reserves_fisc_scenario fs
			LEFT OUTER JOIN stage_valnav.t_reserves_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
			WHERE fs.name = '<Current Options>'
	) sn ON rl.scenario_id = sn.object_id
	INNER JOIN (
			SELECT parent_id, string_value
			FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
			WHERE name='text 1' and string_value in ('Total Properties') --('BNP Evaluated Properties','GLJ Evaluated Properties')
	) cfd ON rl.entity_id = cfd.parent_id
	INNER JOIN (
			SELECT variable_value, cube_child_member
			FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
	) vev ON rl.reserve_category_id = vev.cube_child_member
	WHERE rl.plan_definition_id = 0
	AND e.entity_type <> 6 /* Exclude Common Termination type entities */

	union all

	/*-- Results summary metrics*/
	SELECT DISTINCT e.object_id AS entity_guid,
		CASE WHEN rbd.reserve_book_date IS NULL 
			THEN CASE WHEN rsum.forecast_start > rsum.production_start THEN rsum.forecast_start  
					ELSE rsum.production_start END 
			ELSE  rbd.reserve_book_date  END AS actvy_date,
		/*--CAST(NULL AS float) AS wi_revenue,
		--CAST(NULL AS float) AS ri_revenue,*/
		CAST(NULL AS float) AS roy_adj_total,
		CAST(NULL AS float) AS net_op_income,
		CAST(NULL AS float)  AS OpVariable,
		CAST(NULL AS float)  AS OpFixed,

		CAST(ROUND (btax_net_revenue, 12) AS float) AS btax_net_revenue,
		CAST(ROUND (btax_npv1, 12) AS float) AS btax_npv1,
		CAST(ROUND (btax_npv2, 12) AS float) AS btax_npv2,
		CAST(ROUND (btax_npv3, 12) AS float) AS btax_npv3,
		CAST(ROUND (btax_npv4, 12) AS float) AS btax_npv4,
		CAST(ROUND (btax_npv5, 12) AS float) AS btax_npv5,

		CAST(ROUND((rsum.btax_payout * 12), 1) AS float) AS btax_payout_months,
		CAST(ROUND((rsum.btax_ror * 100), 1) AS float) AS btax_ror,
		CAST(rsum.btax_profit_ratio AS float) AS btax_profit_ratio,
		CAST(NULL AS float) cap_wi_abandonment_salvage,

		rl.entity_id,
		e.formatted_id,
		RTRIM(LTRIM (e.unique_id)) AS uwi,
		rl.reserve_category_id,
		'GLJ Reserves' AS scenario_type,
		vev2.variable_value AS scenario,
		2 as section
	FROM (
			SELECT variable_value, cube_child_member, sign_flip_flag
			FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'RESERVES_ANALYSIS_SCENARIO'
			AND ISNULL (sign_flip_flag, 'N') <> 'Y'
	) vev2
	, (		
			SELECT variable_value AS reserve_book_date
			FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'RESERVE_BOOK_DATE'
	) rbd
	, stage_valnav.t_reserves_results_summary rsum
	LEFT OUTER JOIN  stage_valnav.t_reserves_results_lookup rl ON rsum.result_id = rl.result_id
	LEFT OUTER JOIN stage_valnav.t_reserves_entity e ON rl.entity_id = e.object_id
	INNER JOIN (
			SELECT variable_value, cube_child_member
			FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
	) vev ON rl.reserve_category_id = vev.cube_child_member
	INNER JOIN (
			SELECT fsp.plan_id, fs.OBJECT_ID
			FROM stage_valnav.t_reserves_fisc_scenario fs
			LEFT OUTER JOIN stage_valnav.t_reserves_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
			WHERE fs.name = '<Current Options>'
	) sn ON rl.scenario_id = sn.object_id
	INNER JOIN (
				SELECT parent_id, string_value
				FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
				WHERE name='text 1' and string_value in ('Total Properties') --('BNP Evaluated Properties','GLJ Evaluated Properties')
	) cfd ON rl.entity_id = cfd.parent_id
	WHERE (CASE WHEN rsum.forecast_start > rsum.production_start THEN rsum.forecast_start  ELSE  rsum.production_start END) IS NOT NULL
	AND rl.plan_definition_id = 0
	AND e.entity_type <> 6;