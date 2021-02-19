CREATE VIEW [dbo].[v_fact_VNReserves_production]
AS SELECT pf.entity_key,
		CASE WHEN activity_date_key IS NULL or activity_date_key = -1 THEN -1
			ELSE CAST(CONCAT(SUBSTRING(CAST(activity_date_key AS VARCHAR(10)),1,6), 
					DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime)))) AS INT) END activity_date_key,
		account_key,
		reserve_category_key,
		scenario_key,
		gross_net_key,
		normalized_time_key,
		CASE WHEN e.reserve_realized_date IS NULL THEN '-1'
			ELSE CAST(CAST(YEAR(CAST(e.reserve_realized_date AS datetime)) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(CAST(e.reserve_realized_date AS datetime)) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(CAST(e.reserve_realized_date AS datetime)) AS VARCHAR),2) AS INT) END reserve_realized_date_key,
		imperial_volume,
		boe_volume,
		metric_volume,
		mcfe_volume,
		CASE WHEN activity_date_key IS NULL or activity_date_key = -1 THEN CAST(NULL AS VARCHAR(10))
			ELSE DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime))) END number_of_days
	FROM [data_mart].[t_fact_valnav_production_glj] pf
	LEFT OUTER JOIN (
				SELECT entity_key, reserve_realized_date
				FROM [data_mart].t_dim_entity
				WHERE is_valnav=1
	) e ON pf.entity_key = e.entity_key
	 where exists (	select 1 
					from stage.t_ctrl_valnav_etl_variables c
					where c.variable_name = 'RESERVES_ANALYSIS_SCENARIO'
					and c.variable_value = scenario_key);