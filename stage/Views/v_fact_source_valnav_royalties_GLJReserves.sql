CREATE VIEW [stage].[v_fact_source_valnav_royalties_GLJReserves]
AS SELECT e.object_id AS entity_key,
	CASE WHEN  rr.step_date IS NULL THEN -1 ELSE convert(int,convert(varchar(8),rr.step_date,112)) END activity_date_key,
	rl.reserve_category_id,
	vev2.variable_value AS scenario,
	'WI' as grs_net,
	'Custom Royalty' as accounts,
	CAST ('GLJ Reserves' AS VARCHAR (10)) AS scenario_type,
	CAST(CASE WHEN od.onstream_date IS NULL  OR datediff(MONTH,od.onstream_date, rr.step_date)+1 >= mp.max_on_prod_days THEN '-1' 
		ELSE CASE WHEN od.onstream_date IS NULL OR datediff(MONTH,od.onstream_date, rr.step_date)+1 <= 0 THEN '-1' 
			ELSE  CONCAT(RIGHT(CONCAT('0',datediff(MONTH,od.onstream_date, rr.step_date)+1),2),'.01') END END AS VARCHAR(5)) AS normalized_time_key, 
	rr.royalty as cad,
	rr.royalty/1000 as k_cad
FROM (
	SELECT variable_value AS max_on_prod_days
	FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS'
) mp
, (
	SELECT variable_value, cube_child_member, sign_flip_flag
	FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
	WHERE variable_name = 'RESERVES_ANALYSIS_SCENARIO'
	AND ISNULL (sign_flip_flag, 'N') <> 'Y'
) vev2
, (
	SELECT *
	FROM stage_valnav.t_reserves_RESULTS_REGIME
	WHERE royalty <> 0
) rr
LEFT OUTER JOIN stage_valnav.t_reserves_RESULTS_LOOKUP rl ON  rr.result_id = rl.result_id
LEFT OUTER JOIN	stage_valnav.t_reserves_ENTITY e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT fsp.plan_id, fs.object_id
		FROM stage_valnav.t_reserves_FISC_SCENARIO fs
		LEFT OUTER JOIN stage_valnav.t_reserves_FISC_SCENARIO_PARAMS fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
INNER JOIN (
		SELECT variable_value, cube_child_member
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
) vev ON rl.reserve_category_id = vev.cube_child_member
INNER JOIN (
		SELECT parent_id, string_value
		FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
		WHERE name='text 1' and string_value in ('BNP Evaluated Properties','GLJ Evaluated Properties')
) cfd ON rl.entity_id = cfd.parent_id
LEFT OUTER JOIN (
		SELECT object_id, first_step_date onstream_date
		FROM [stage].t_valnav_onstream_date_reserves
) od ON rl.entity_id = od.object_id
WHERE rl.plan_definition_id = 0;