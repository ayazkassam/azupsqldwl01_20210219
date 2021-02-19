CREATE VIEW [stage].[v_fact_source_valnav_reserve_adds_calculation]
AS select *
from (
	SELECT vr.entity_key,
		vr.activity_date_key,
		vr.adds_accounts account_key,
		vr.reserve_category_key,
		vr.scenario_key,
		vr.gross_net_key,
		vr.normalized_time_key,
		vr.imperial_volume	- ISNULL(br.imperial_volume, 0)	imperial_volume,
		vr.boe_volume		- ISNULL(br.boe_volume, 0)		boe_volume,
		vr.metric_volume	- ISNULL(br.metric_volume, 0)	metric_volume,
		vr.mcfe_volume		- ISNULL(br.mcfe_volume, 0)		mcfe_volume,
		'Budget' scenario_type,
		CURRENT_TIMESTAMP last_update_date
	FROM (
		SELECT vr.entity_key
			, e.cost_centre
			, replace(cast(eomonth(cast(cast(activity_date_key as varchar) as date)) as varchar),'-','')  activity_date_key
			, left(activity_date_key,4) as activity_year
			, xr.cube_dimension booked_accounts
			, xr.cube_child_member adds_accounts
			, reserve_category_key
			, gross_net_key
			, scenario_key
			, normalized_time_key
			, SUM (imperial_volume) imperial_volume
			, SUM (boe_volume) boe_volume
			, SUM (metric_volume) metric_volume
			, SUM (mcfe_volume) mcfe_volume
		FROM [data_mart].t_fact_valnav_reserves vr
		join (
			SELECT variable_value
				, cube_dimension
				, cube_child_member
			FROM [stage].t_ctrl_valnav_etl_variables
			WHERE variable_name = 'RESERVE_ADDS_CALC_XREF'
			and text1 = 'XLS'
		) xr on vr.account_key= xr.variable_value
		left outer join data_mart.t_dim_entity e on vr.entity_key = e.entity_key 
		where scenario_key IN ('Budget 2014','Budget 2015')
		and e.is_valnav = 1
		GROUP BY vr.entity_key, e.cost_centre, activity_date_key, xr.cube_dimension, xr.cube_child_member, reserve_category_key, gross_net_key, scenario_key, normalized_time_key
	) vr
	LEFT OUTER JOIN (
		/*pull pre-booked reserves by cost centre*/
		SELECT e.cost_centre
			, reserve_category_key
			, gross_net_key
			, normalized_time_key
			, account_key
			, left(activity_date_key,4) as activity_year
			, sum(imperial_volume) imperial_volume
			, sum(boe_volume)	   boe_volume
			, sum(metric_volume)   metric_volume
			, sum(mcfe_volume)	   mcfe_volume
		FROM [data_mart].t_fact_valnav_reserves_xls br
		left outer join data_mart.t_dim_entity e on br.entity_key = e.entity_key
		where e.is_valnav = 1
		and scenario_key = 'Working Budget Incremental'
		group by e.cost_centre, br.reserve_category_key, br.gross_net_key, br.normalized_time_key, br.account_key, left(br.activity_date_key,4)
	) br ON vr.cost_centre = br.cost_centre		/*change to join on cost centre instead of entity_key to align reserves adds to the Valnav Entity instead of the glj/xls entity*/
		AND vr.reserve_category_key = br.reserve_category_key
		AND vr.gross_net_key = br.gross_net_key
		AND vr.normalized_time_key = br.normalized_time_key
		AND vr.booked_accounts = br.account_key
		AND vr.activity_year = br.activity_year

	union all

	SELECT vr.entity_key,
		vr.activity_date_key,
		vr.adds_accounts account_key,
		vr.reserve_category_key,
		vr.scenario_key,
		vr.gross_net_key,
		vr.normalized_time_key,
		vr.imperial_volume	- ISNULL(br.imperial_volume, 0)	imperial_volume,
		vr.boe_volume		- ISNULL(br.boe_volume, 0)		boe_volume,
		vr.metric_volume	- ISNULL(br.metric_volume, 0)	metric_volume,
		vr.mcfe_volume		- ISNULL(br.mcfe_volume, 0)		mcfe_volume,
		'Budget' scenario_type,
		CURRENT_TIMESTAMP last_update_date
	FROM (
		SELECT vr.entity_key
			, e.cost_centre
			, replace(cast(eomonth(cast(cast(activity_date_key as varchar) as date)) as varchar),'-','')  activity_date_key
			, left(activity_date_key,4) as activity_year
			, xr.cube_dimension booked_accounts
			, xr.cube_child_member adds_accounts
			, reserve_category_key
			, gross_net_key
			, scenario_key
			, normalized_time_key
			, SUM (imperial_volume) imperial_volume
			, SUM (boe_volume) boe_volume
			, SUM (metric_volume) metric_volume
			, SUM (mcfe_volume) mcfe_volume
		FROM [data_mart].t_fact_valnav_reserves vr
		join (
			SELECT variable_value
				, cube_dimension
				, cube_child_member
			FROM [stage].t_ctrl_valnav_etl_variables
			WHERE variable_name = 'RESERVE_ADDS_CALC_XREF'
			and text1 = 'GLJ'
		) xr on vr.account_key= xr.variable_value
		left outer join data_mart.t_dim_entity e on vr.entity_key = e.entity_key 
		where scenario_key IN ('Budget 2018')
		and e.is_valnav = 1
		GROUP BY vr.entity_key, e.cost_centre, activity_date_key, xr.cube_dimension, xr.cube_child_member, reserve_category_key, gross_net_key, scenario_key, normalized_time_key
	) vr
	LEFT OUTER JOIN (
		/*pull pre-booked reserves by cost centre*/
		SELECT e.cost_centre
			, reserve_category_key
			, gross_net_key
			, normalized_time_key
			, account_key
			, left(activity_date_key,4) as activity_year
			, sum(imperial_volume) imperial_volume
			, sum(boe_volume)	   boe_volume
			, sum(metric_volume)   metric_volume
			, sum(mcfe_volume)	   mcfe_volume
		FROM [data_mart].t_fact_valnav_reserves_glj br
		left outer join data_mart.t_dim_entity e on br.entity_key = e.entity_key
		where e.is_valnav = 1
		and scenario_key = 'Working Budget Incremental'
		group by e.cost_centre, br.reserve_category_key, br.gross_net_key, br.normalized_time_key, br.account_key, left(br.activity_date_key,4)
	) br ON vr.cost_centre = br.cost_centre		/*change to join on cost centre instead of entity_key to align reserves adds to the Valnav Entity instead of the glj/xls entity*/
		AND vr.reserve_category_key = br.reserve_category_key
		AND vr.gross_net_key = br.gross_net_key
		AND vr.normalized_time_key = br.normalized_time_key
		AND vr.booked_accounts = br.account_key
		AND vr.activity_year = br.activity_year
) sq;