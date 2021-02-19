CREATE VIEW [stage].[v_fact_source_valnav_lateral_length_budget]
AS select e.OBJECT_ID as entity_key
	, isnull(convert(int,convert(varchar(8),dd.first_drill_date,112)),-1) as activity_date_key
	, 'Lateral Length' as account_key
	, rc.rescat as reserve_category_key
	, cev.cube_child_member as scenario_key
	, '-1' as normalized_time_key
	, gn.grs_net as gross_net_key
	, cast('Budget' as varchar (10)) as scenario_type
	, case gn.grs_net
		when 'GRS' then coalesce(rs.LATERAL_LENGTH, cfd.value) / coalesce(wi.tract_record_count, 1)
		when 'WI' then coalesce(rs.LATERAL_LENGTH, cfd.value) * coalesce(wi.tract_working_interest, ed.working_interest_pct,1.00)
		end as cad
from (select 'GRS' as grs_net union all select 'WI') gn
, (select 2311 as rescat union all select 1311 as rescat) rc
, stage_valnav.t_budget_entity e
/*find the scenarios*/
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
) cev on e.object_id = cev.parent_id
/*first source of lateral length*/
LEFT OUTER JOIN (
		SELECT ep.object_id
			, ep.parent_id
			, convert(float,LATERAL_LENGTH) * .3048 as LATERAL_LENGTH
		FROM stage_valnav.t_budget_ent_plan ep
		join stage_valnav.t_budget_ent_shared_plan_data pd on ep.parent_id = pd.parent_id AND ep.plan_definition_id =  pd.plan_definition_id
		where ep.plan_definition_id = 0
		and LATERAL_LENGTH is not null
) rs ON e.object_id = rs.parent_id
/*second source of lateral length*/
left outer join (
		select parent_id
			, ltrim(rtrim(name)) name
			, convert(float,numeric_value) value
		from stage.t_stg_valnav_budget_ent_custom_field_def
		where name = 'lateral length (m)'
) cfd on e.OBJECT_ID = cfd.parent_id
/*determine the Capital Type*/
left outer join (
		select parent_id, name, string_value as capital_type
		from [stage].t_stg_valnav_budget_ent_custom_field_def
		where ltrim(rtrim(name)) = 'capital type'
) ct on e.object_id = ct.parent_id
/*--first drill date*/
left outer join (
		select e.object_id as entity_key,
			min(rcd.step_date) first_drill_date
		from (
				select *
				from stage_valnav.t_budget_results_cost_detail rcd
				where (isnull(rcd.success_gross_value,0) + isnull(rcd.success_interest_value,0) 
					+ isnull(rcd.failure_gross_value,0) + isnull(rcd.failure_interest_value,0)) <> 0
		) rcd
		left outer join stage_valnav.t_budget_results_lookup rl on rcd.result_id = rl.result_id
		left outer join	stage_valnav.t_budget_entity e on rl.entity_id = e.object_id
		inner join (
				select variable_value
				from stage.t_ctrl_valnav_etl_variables
				where variable_name = 'reserve_category_id'
		) vev on rl.reserve_category_id = vev.variable_value
		inner join (
				select object_id, name
				from stage_valnav.t_budget_fisc_cap_cost
		) cl on rcd.cost_definition_id = cl.object_id
		inner join (
				select fsp.plan_id, fs.*
				from stage_valnav.t_budget_fisc_scenario fs
				left outer join stage_valnav.t_budget_fisc_scenario_params fsp on (fs.object_id = fsp.parent_id)
				where fs.name = '<current options>'
		) sn on rl.scenario_id = sn.object_id
		inner join (
				select *
				from [stage].t_stg_valnav_budget_ent_custom_field_def
				where name in ('budget year', 'district','capital group')
		) cfd on rl.entity_id = cfd.parent_id
		where rl.plan_definition_id = 0
		and cl.name in ('drilling (cee)','drilling (cde)')
		group by e.object_id
) dd on e.object_id = dd.entity_key
/*valnav working interest*/
left outer join (
		select entity_object_id
			, effective_date
			, next_effective_date
			, tract_working_interest
			, count(working_interest) over (partition by entity_object_id, effective_date, next_effective_date) as tract_record_count
		from [stage].v_valnav_uwi_working_interest
) wi  on e.object_id = wi.entity_object_id
and (dd.first_drill_date >= wi.effective_date and dd.first_drill_date < wi.next_effective_date)
/*entity working interest*/
inner join (
		select entity_key, working_interest_pct/100 as working_interest_pct
		from [data_mart].t_dim_entity
		where is_valnav=1
) ed
ON e.object_id = ed.entity_key
where coalesce(rs.lateral_length, cfd.value) is not null
and ct.capital_type = 'Drilling';