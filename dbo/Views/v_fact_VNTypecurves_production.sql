﻿CREATE VIEW [dbo].[v_fact_VNTypecurves_production]
AS select entity_key
	, case	when activity_date_key < ed.start_year then -1
			when activity_date_key > ed.end_year then -1 else activity_date_key end activity_date_key
	, account_key
	, reserve_category_key
	, scenario_key
	, gross_net_key
	, normalized_time_key
	, case when normalized_time_key = '-1' then '-1' 
			else convert(int,left(normalized_time_key,2)) end as normalized_month_key
	, case when normalized_time_key = '-1' then '-1' 
			else case when convert(int,left(normalized_time_key,2)) = '01' then convert(int,right(normalized_time_key,2))
					else ((convert(int,left(normalized_time_key,2))-1)*31) + convert(int,right(normalized_time_key,2))
		end end as normalized_day_key 

	, reserve_realized_date_key
	, imperial_volume
	, boe_volume
	, metric_volume
	, mcfe_volume
	, case when activity_date_key between ed.start_year and ed.end_year then number_of_days else null end number_of_days 
from (
	SELECT pf.entity_key,
		CASE WHEN activity_date_key IS NULL or activity_date_key = '-1' or activity_date_key = '0' THEN -1
			ELSE convert(int,convert(varchar(8),eomonth(convert(date,convert(varchar(8),activity_date_key))),112)) END activity_date_key,
		account_key,
		reserve_category_key,
		scenario_key,
		gross_net_key,
		normalized_time_key,
		CASE WHEN e.reserve_realized_date IS NULL THEN '-1' ELSE e.reserve_realized_date END reserve_realized_date_key,
		imperial_volume,
		boe_volume,
		metric_volume,
		mcfe_volume,
		CASE WHEN activity_date_key IS NULL or activity_date_key = '-1' or activity_date_key = '0' THEN CAST(NULL AS VARCHAR(10))
			ELSE DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime))) END number_of_days
	FROM [data_mart].[t_fact_valnav_production_typecurves] pf
	LEFT OUTER JOIN (
                SELECT entity_key 
					, CASE WHEN reserve_realized_date IS NULL OR reserve_realized_date = '0' THEN -1 ELSE
					convert(int,convert(varchar(8),convert(date,reserve_realized_date),112)) END reserve_realized_date
				FROM [data_mart].t_dim_entity
				WHERE is_valnav=1
	) e ON pf.entity_key = e.entity_key
		/*exclude default scenario which is brought in from the daily table*/
	where scenario_key not in (	select scenario_key
								from [data_mart].[t_dim_scenario_typecurves]
								where scenario_parent_key in (
													select scenario_key
													from stage.t_stg_type_curves_current_scenario 
													where is_current_scenario = 'Y'))

	union all

	SELECT pf.entity_key,
		CASE WHEN activity_date_key IS NULL or activity_date_key = '-1' THEN -1
			ELSE convert(int,convert(varchar(8),eomonth(convert(date,convert(varchar(8),activity_date_key))),112)) END activity_date_key,
		account_key,
		reserve_category_key,
		scenario_key,
		gross_net_key,
		normalized_time_key,
		CASE WHEN e.reserve_realized_date IS NULL THEN '-1' ELSE e.reserve_realized_date END reserve_realized_date_key,
		imperial_volume,
		boe_volume,
		metric_volume,
		mcfe_volume,
		CASE WHEN activity_date_key IS NULL or activity_date_key = '-1' THEN CAST(NULL AS VARCHAR(10))
			ELSE DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime))) END number_of_days
	FROM [data_mart].t_fact_valnav_production_typecurves_daily pf
	LEFT OUTER JOIN (
                SELECT entity_key 
					, CASE WHEN reserve_realized_date IS NULL OR reserve_realized_date = '0' THEN -1 ELSE
					convert(int,convert(varchar(8),convert(date,reserve_realized_date),112)) END reserve_realized_date
				FROM [data_mart].t_dim_entity
				WHERE is_valnav=1
	) e ON pf.entity_key = e.entity_key
) sq
/*clean up invalid activity dates*/
, (		select min(int_value) as start_year
			, max(int_value) as end_year
		from [stage].t_ctrl_valnav_etl_variables
		where variable_name in ('valnav_activity_date_start','valnav_activity_date_end')
) ed;