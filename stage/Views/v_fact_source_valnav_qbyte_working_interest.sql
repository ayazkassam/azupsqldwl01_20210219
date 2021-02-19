CREATE VIEW [stage].[v_fact_source_valnav_qbyte_working_interest]
AS select ed.entity_key
	, wi.activity_period activity_date_key
	, wi.account account_key
	, rc.rescat as reserve_category_key
	, cev.cube_child_member as scenario_key
	, '-1' as normalized_time_key
	, gn.grs_net as gross_net_key
	, cast('Budget' as varchar (10)) as scenario_type
	, wi.working_interest
from [stage].t_fact_source_qbyte_working_interest wi		
join (
		select distinct entity_key, cost_centre
		from [data_mart].t_dim_entity
		where is_valnav=1
		and nullif(cost_centre,'no match') is not null 
) ed on wi.entity_key = ed.cost_centre
join [stage_valnav].t_budget_entity e on ed.entity_key = e.OBJECT_ID
join (
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
join (select 'GRS' as grs_net union all select 'WI') gn on 1=1
join (select 2311 as rescat union all select 1311 as rescat) rc on 1=1;