CREATE VIEW [stage_valnav].[v_basedecline_result_id]
AS SELECT DISTINCT rl.result_id
FROM stage_valnav.t_basedecline_results_lookup rl 
     JOIN stage_valnav.t_basedecline_entity e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'BASE_DECLINE_RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value

INNER JOIN (
		SELECT fsp.plan_id, fs.*
		FROM stage_valnav.t_basedecline_fisc_scenario fs
		LEFT OUTER JOIN stage_valnav.t_basedecline_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_base_decline_ent_custom_field_def
		WHERE upper(name) IN ('EVAL GROUP')
) cfd ON rl.entity_id = cfd.parent_id
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_base_decline_ent_custom_field_def
		WHERE upper(name)='BASE GROUP'
) cfb ON rl.entity_id = cfb.parent_id
INNER JOIN (
		SELECT variable_value, cube_child_member, sign_flip_flag
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'BASE_DECLINE_EVAL_GROUP'
) vev2 ON  ltrim(rtrim(cfd.string_value)) = vev2.variable_value
INNER JOIN (
		SELECT variable_value, cube_child_member, sign_flip_flag
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'BASE_DECLINE_BASE_GROUP'
) vevb ON  ltrim(rtrim(cfb.string_value)) = vevb.variable_value;