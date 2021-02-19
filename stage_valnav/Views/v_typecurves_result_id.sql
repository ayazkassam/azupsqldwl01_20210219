CREATE VIEW [stage_valnav].[v_typecurves_result_id]
AS SELECT DISTINCT rl.result_id
FROM stage_valnav.t_typecurves_results_lookup rl 
     JOIN stage_valnav.t_typecurves_entity e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value

INNER JOIN (
		SELECT fsp.plan_id, fs.*
		FROM stage_valnav.t_typecurves_fisc_scenario fs
		LEFT OUTER JOIN stage_valnav.t_typecurves_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
		WHERE upper(name)='BUDGET YEAR'
) cfd ON rl.entity_id = cfd.parent_id
INNER JOIN (
		SELECT variable_value, cube_child_member, sign_flip_flag
		FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'TYPE_CURVES_BUDGET_YEAR'
) vevby ON  ltrim(rtrim(cfd.string_value)) = vevby.variable_value;