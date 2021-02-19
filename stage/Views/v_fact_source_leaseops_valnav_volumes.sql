CREATE VIEW [stage].[v_fact_source_leaseops_valnav_volumes]
AS SELECT entity_key,
	account_key,
	activity_date_key accounting_month_key,
	activity_date_key,
	gross_net_key,
	vendor_key,
	scenario_key,
	ISNULL(spud_date_key,-2) spud_date_key,
	ISNULL(rig_release_date_key,-2) rig_release_date_key,
	ISNULL(on_prod_date_key,-2) on_prod_date_key,
	ISNULL(cc_create_date_key,-2) cc_create_date_key,
	ISNULL(cc_term_date_key,-2) cc_term_date_key,
	sum(metric_volume) metric_volume,
	sum(imperial_volume) imperial_volume,
	sum(boe_volume) boe_volume,
	sum(mcfe_volume) mcfe_volume
FROM (
	SELECT isnull(ve.cost_centre,'-1') entity_key
		, convert(varchar(20),isnull(acc.qbyte_major_minor,'-1')) account_key
		, CASE WHEN vp.activity_date_key IS NULL or vp.activity_date_key = -1 THEN -1 
			ELSE convert(int,convert(varchar(8),eomonth(convert(date,convert(varchar,vp.activity_date_key))),112)) END activity_date_key
		, CASE WHEN vp.gross_net_key = 'GRS' THEN 1 ELSE 2 END gross_net_key
		, '-1' vendor_key
		, sc.cube_child_member scenario_key
		, vc.spud_date spud_date_key
		, vc.rig_release_date rig_release_date_key
		, vc.on_production_date on_prod_date_key
		, vc.cc_create_date cc_create_date_key 
		, vc.cc_term_date cc_term_date_key
		, vp.metric_volume
		, vp.imperial_volume
		, vp.boe_volume
		, vp.mcfe_volume
	FROM [data_mart].t_fact_valnav_production vp
	INNER JOIN (
		SELECT v1.variable_value
			, v1.cube_child_member
				/*add logic to vary the years based on scenario type*/
			, case when v2.VARIABLE_VALUE is not null then opex_start_date else start_date end as start_date
			, case when v2.VARIABLE_VALUE is not null then opex_end_date else end_date end as end_date
		FROM [stage].[t_ctrl_valnav_etl_variables] v1
		left outer join (
				select VARIABLE_VALUE
				from [stage].t_ctrl_etl_variables 
				where VARIABLE_NAME in ('OPEX_BUDGET_SCENARIOS')
		) v2 on v1.cube_child_member = v2.VARIABLE_VALUE
		join (
			select cast(variable_value +'0101' as int) start_date
				, cast(cast(variable_value + 2 as varchar(4))+'1231' as int) end_date
			FROM [stage].[t_ctrl_valnav_etl_variables]
			WHERE variable_name = 'LEASEOPS_CURRENT_BUDGET_YEAR'
		) d on 1=1
		join (
			select cast(variable_value +'0101' as int) opex_start_date
				, cast(cast(variable_value + 4 as varchar(4))+'1231' as int) opex_end_date
			from [stage].t_ctrl_etl_variables 
			where VARIABLE_NAME in ('OPEX_BUDGET_START_YEAR')
		) d2 on 1=1
		WHERE v1.variable_name = 'LEASEOPS_DATA_SCENARIO'
		AND v1.variable_value IS NOT NULL
	) sc 
		ON vp.scenario_key = sc.variable_value
		AND vp.activity_date_key >= sc.start_date 
		AND vp.activity_date_key <= sc.end_date
	INNER JOIN (
			SELECT account_id
				, convert(varchar(20),qbyte_major_minor) qbyte_major_minor
			FROM [stage].t_ctrl_special_accounts
			WHERE is_valnav=1
			AND upper(parent_id) in ('OIL','GAS','LIQUIDS')
			AND qbyte_major_minor IS NOT NULL
	) acc ON vp.account_key = acc.account_id
	LEFT OUTER JOIN (
			/*-- join to entity using entity/guid to get cc*/
			SELECT entity_key, cost_centre
			FROM [data_mart].t_dim_entity
			WHERE is_valnav=1
	) ve ON vp.entity_key = ve.entity_key
	LEFT OUTER JOIN (
			/*-- join to entity using cc so to get cc based attributes*/
			SELECT entity_key
				, cost_centre
				, uwi
				, CAST(op_nonop AS NVARCHAR(10)) AS op_nonop
				, CAST(budget_group AS NVARCHAR(200)) AS budget_group
				, CASE WHEN ISDATE(create_date) = 0 THEN NULL 
					ELSE convert(int,convert(varchar(8),convert(date,e.create_date),112)) END AS cc_create_date
				, case when convert(date,e.on_production_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.on_production_date),112)) end on_production_date
				, case when convert(date,e.rig_release_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.rig_release_date),112)) end rig_release_date
				, case when convert(date,e.spud_date)< md.minDate then null
					else convert(int,convert(varchar(8),convert(date,e.spud_date),112)) end spud_date
				, CASE WHEN ISDATE(cc_term_date) = 0 THEN NULL 
					ELSE convert(int,convert(varchar(8),convert(date,e.cc_term_date),112)) end as cc_term_date
			FROM [data_mart].[t_dim_entity] e
			, (	select min(full_date) minDate from data_mart.dim_date) md
			WHERE is_cc_dim = 1
	) vc ON ve.cost_centre = vc.entity_key
	WHERE vp.reserve_category_key='1311'
) sd
GROUP BY entity_key, account_key, activity_date_key, gross_net_key, vendor_key, scenario_key
	, spud_date_key, rig_release_date_key, on_prod_date_key, cc_create_date_key, cc_term_date_key;