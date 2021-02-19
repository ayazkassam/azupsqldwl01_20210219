CREATE VIEW [stage_valnav].[v_budget_result_id]
AS SELECT DISTINCT rl.result_id
FROM stage_valnav.t_budget_results_lookup rl 
     JOIN stage_valnav.t_budget_entity e ON rl.entity_id = e.object_id
INNER JOIN (
		SELECT variable_value
		FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
		WHERE variable_name = 'RESERVE_CATEGORY_ID'
) vev ON rl.reserve_category_id = vev.variable_value

INNER JOIN (
		SELECT fsp.plan_id, fs.*
		FROM stage_valnav.t_budget_fisc_scenario fs
		LEFT OUTER JOIN stage_valnav.t_budget_fisc_scenario_params fsp ON (fs.object_id = fsp.parent_id)
		WHERE fs.name = '<Current Options>'
) sn ON rl.scenario_id = sn.object_id
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
) vev2 on rl.entity_id = vev2.parent_id;