CREATE VIEW [dbo].[v_fact_valnav_reserves]
AS select entity_key
	, case	when activity_date_key < ed.start_year then -1
			when activity_date_key > ed.end_year then -1 else activity_date_key end activity_date_key
	, account_key
	, reserve_category_key
	, scenario_key
	, gross_net_key
	, normalized_time_key
	, reserve_realized_date_key
	, imperial_volume
	, boe_volume
	, metric_volume
	, mcfe_volume
	, case when activity_date_key between ed.start_year and ed.end_year then number_of_days else null end number_of_days 
	, case when scenario_key like vv.variable_value + '%' then 'I' else etl_status end etl_status
from (
	SELECT pf.entity_key,
		CASE WHEN activity_date_key IS NULL or activity_date_key = '-1' THEN -1
			ELSE CAST(CONCAT(SUBSTRING(CAST(activity_date_key AS VARCHAR(10)),1,6)
				, DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime)))) AS INT) END activity_date_key,
		account_key,
		reserve_category_key,
		scenario_key,
		gross_net_key,
		normalized_time_key,
		CASE WHEN e.reserve_realized_date IS NULL or e.reserve_realized_date = '0' or e.reserve_realized_date = '-1' THEN '-1'
			ELSE convert(int,convert(varchar(8),convert(date,e.reserve_realized_date),112)) END reserve_realized_date_key,
		imperial_volume,
		boe_volume,
		metric_volume,
		mcfe_volume,
		CASE WHEN activity_date_key IS NULL or activity_date_key = '-1'  THEN CAST(NULL AS VARCHAR(10))
			ELSE DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime))) END number_of_days
		, etl_status
	FROM [data_mart].[t_fact_valnav_reserves] pf
	LEFT OUTER JOIN (
		SELECT entity_key, reserve_realized_date
		FROM [data_mart].t_dim_entity
		WHERE is_valnav=1
	) e ON pf.entity_key = e.entity_key
	--
	
	union all
	--
	/*--GLJ BOOKED RESERVES*/
	SELECT pf.entity_key,
		CASE WHEN activity_date_key IS NULL or activity_date_key = '-1' THEN -1
			ELSE CAST(CONCAT(SUBSTRING(CAST(activity_date_key AS VARCHAR(10)),1,6)
				, DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime)))) AS INT) END activity_date_key,
		account_key,
		reserve_category_key,
		scenario_key,
		gross_net_key,
		normalized_time_key,
		CASE WHEN e.reserve_realized_date IS NULL THEN '-1'
			ELSE convert(int,convert(varchar(8),convert(date,e.reserve_realized_date),112)) END reserve_realized_date_key,
		imperial_volume,
		boe_volume,
		metric_volume,
		mcfe_volume,
		CASE WHEN activity_date_key IS NULL or activity_date_key = '-1'  THEN CAST(NULL AS VARCHAR(10))
			ELSE DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime))) END number_of_days
		, case when scenario_key like 'working%' then 'I' else 'A' end as  etl_status
	FROM [data_mart].[t_fact_valnav_reserves_glj] pf
	LEFT OUTER JOIN (
		SELECT entity_key, reserve_realized_date
		FROM [data_mart].t_dim_entity
		WHERE is_valnav=1
	) e ON pf.entity_key = e.entity_key
		/*include only booked reserves requires for valnav cube*/
	where exists (	select 1 
				from stage.t_ctrl_valnav_etl_variables c
					where c.variable_name = 'GLJ_RESERVES_CUBE_SCENARIO'
					and c.variable_value = 'Working Budget Incremental' /* This filter added on March 20, 2018 after Gillian\Peter meeting */
					and c.variable_value = scenario_key)
) sq
/*clean up invalid activity dates*/
, (		select min(int_value) as start_year
			, max(int_value) as end_year
		from [stage].t_ctrl_valnav_etl_variables
		where variable_name in ('valnav_activity_date_start','valnav_activity_date_end')
) ed
/*set current approved budget etl_status to I to include in incremantal processing*/
, (	select variable_value
	from stage.t_ctrl_valnav_etl_variables ct 
	where variable_name = 'VALNAV_CURRENT_APPROVED_BUDGET'
) vv;