CREATE VIEW [stage_valnav].[v_reserves_result_id] AS SELECT DISTINCT rl.result_id
FROM stage_valnav.t_reserves_results_lookup rl 
     JOIN stage_valnav.t_reserves_entity e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value, cube_child_member
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'GLJ_RESERVES_RESERVE_CATEGORY'
) vev ON rl.reserve_category_id = vev.cube_child_member

INNER JOIN (
		SELECT fsp.plan_id, fs.*
		FROM stage_valnav.t_reserves_fisc_scenario fs
		LEFT OUTER JOIN stage_valnav.t_reserves_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
INNER JOIN (
		SELECT *
		FROM [stage].t_stg_valnav_reserves_ent_custom_field_def
		WHERE name = 'text 1' and string_value in ('Total Properties') 
) cfd ON rl.entity_id = cfd.parent_id;