CREATE VIEW [stage].[v_fact_source_fdc_valnav_glj_production_volumes]
AS SELECT entity_key site_id,
	entity_key,
	activity_date_key,
	scenario_key,
	'VALNAV-GLJ' data_type,
	gross_net_key,
	gas_metric_volume, gas_imperial_volume, gas_boe_volume, gas_mcfe_volume,
	oil_metric_volume, oil_imperial_volume, oil_boe_volume, oil_mcfe_volume,
	condensate_metric_volume, condensate_imperial_volume, condensate_boe_volume, condensate_mcfe_volume,
	ethane_metric_volume, ethane_imperial_volume, ethane_boe_volume, ethane_mcfe_volume,
	propane_metric_volume, propane_imperial_volume, propane_boe_volume, propane_mcfe_volume,
	butane_metric_volume, butane_imperial_volume, butane_boe_volume, butane_mcfe_volume, 
	pentane_metric_volume, pentane_imperial_volume, pentane_boe_volume, pentane_mcfe_volume,
	--
	isnull(ethane_metric_volume,0) + isnull(propane_metric_volume,0) + isnull(butane_metric_volume,0) + isnull(pentane_metric_volume,0) + isnull(condensate_metric_volume,0) total_ngl_metric_volume,
	isnull(ethane_imperial_volume,0) + isnull(propane_imperial_volume,0) + isnull(butane_imperial_volume,0) + isnull(pentane_imperial_volume,0) + isnull(condensate_imperial_volume,0) total_ngl_imperial_volume,
	isnull(ethane_boe_volume,0) + isnull(propane_boe_volume,0) + isnull(butane_boe_volume,0) + isnull(pentane_boe_volume,0) + isnull(condensate_boe_volume,0) total_ngl_boe_volume,
	isnull(ethane_mcfe_volume,0) + isnull(propane_mcfe_volume,0) + isnull(butane_mcfe_volume,0) + isnull(pentane_mcfe_volume,0) + isnull(condensate_mcfe_volume,0) total_ngl_mcfe_volume,
	-- 
	isnull(oil_metric_volume,0) + isnull(condensate_metric_volume,0) + isnull(ethane_metric_volume,0) + isnull(propane_metric_volume,0) + isnull(butane_metric_volume,0) + isnull(pentane_metric_volume,0) total_liquid_metric_volume,
	isnull(oil_imperial_volume,0) + isnull(condensate_imperial_volume,0) + isnull(ethane_imperial_volume,0) + isnull(propane_imperial_volume,0) + isnull(butane_imperial_volume,0) + isnull(pentane_imperial_volume,0) total_liquid_imperial_volume,
	isnull(oil_boe_volume,0) + isnull(condensate_boe_volume,0) + isnull(ethane_boe_volume,0) + isnull(propane_boe_volume,0) + isnull(butane_boe_volume,0) + isnull(pentane_boe_volume,0) total_liquid_boe_volume,
	isnull(oil_mcfe_volume,0) + isnull(condensate_mcfe_volume,0) + isnull(ethane_mcfe_volume,0) + isnull(propane_mcfe_volume,0) + isnull(butane_mcfe_volume,0) + isnull(pentane_mcfe_volume,0) total_liquid_mcfe_volume,
	--
	isnull(gas_boe_volume,0) + isnull(oil_boe_volume,0) + isnull(condensate_boe_volume,0) + isnull(ethane_boe_volume,0) + isnull(propane_boe_volume,0) + isnull(butane_boe_volume,0) + isnull(pentane_boe_volume,0) total_boe_volume,
	--
	water_metric_volume,
	water_imperial_volume,
	water_boe_volume,
	water_mcfe_volume
FROM (
	SELECT entity_key,
		activity_date_key,
		scenario_key,
		gross_net_key,
		sum(gas_metric_volume) gas_metric_volume,
		sum(gas_imperial_volume) gas_imperial_volume,
		sum(gas_boe_volume) gas_boe_volume,
		sum(gas_mcfe_volume) gas_mcfe_volume,
		sum(oil_metric_volume) oil_metric_volume,
		sum(oil_imperial_volume) oil_imperial_volume,
		sum(oil_boe_volume) oil_boe_volume,
		sum(oil_mcfe_volume) oil_mcfe_volume,
		sum(condensate_metric_volume) condensate_metric_volume,
		sum(condensate_imperial_volume) condensate_imperial_volume,
		sum(condensate_boe_volume) condensate_boe_volume,
		sum(condensate_mcfe_volume) condensate_mcfe_volume,
		sum(ethane_metric_volume) ethane_metric_volume,
		sum(ethane_imperial_volume) ethane_imperial_volume,
		sum(ethane_boe_volume) ethane_boe_volume,
		sum(ethane_mcfe_volume) ethane_mcfe_volume,
		sum(propane_metric_volume) propane_metric_volume,
		sum(propane_imperial_volume) propane_imperial_volume,
		sum(propane_boe_volume) propane_boe_volume,
		sum(propane_mcfe_volume) propane_mcfe_volume,
		sum(butane_metric_volume) butane_metric_volume,
		sum(butane_imperial_volume) butane_imperial_volume,
		sum(butane_boe_volume) butane_boe_volume,
		sum(butane_mcfe_volume) butane_mcfe_volume,
		sum(pentane_metric_volume) pentane_metric_volume,
		sum(pentane_imperial_volume) pentane_imperial_volume,
		sum(pentane_boe_volume) pentane_boe_volume,
		sum(pentane_mcfe_volume) pentane_mcfe_volume,
		sum(water_metric_volume) water_metric_volume,
		sum(water_imperial_volume) water_imperial_volume,
		sum(water_boe_volume) water_boe_volume,
		sum(water_mcfe_volume) water_mcfe_volume
	FROM (
			/*--SD  Monthly Data -- Working Budget -- Current Budget Year Varable + 2  (see UNION ALL below for other scenarios) */
		SELECT uwi entity_key,
		        CASE WHEN activity_date_key IS NULL or activity_date_key = -1 THEN -1 
				ELSE CAST(CONCAT(SUBSTRING(CAST(activity_date_key AS VARCHAR(10)),1,6)
					, DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime)))) AS INT) END activity_date_key,
			TEXT1 scenario_key,
			CASE WHEN gross_net_key = 'GRS' THEN 1 ELSE 2 END gross_net_key,
			CASE WHEN account_key  IN ('SalesGas','Solution Gas') THEN metric_volume ELSE NULL END gas_metric_volume,
			CASE WHEN account_key IN ('SalesGas','Solution Gas') THEN imperial_volume ELSE NULL END gas_imperial_volume,
			CASE WHEN account_key IN ('SalesGas','Solution Gas') THEN boe_volume ELSE NULL END gas_boe_volume,
			CASE WHEN account_key IN ('SalesGas','Solution Gas') THEN mcfe_volume ELSE NULL END gas_mcfe_volume,
			CASE WHEN  account_key IN ('Light and Medium Oil','Heavy Oil') THEN metric_volume ELSE NULL END oil_metric_volume,
			CASE WHEN  account_key IN ('Light and Medium Oil','Heavy Oil') THEN imperial_volume ELSE NULL END oil_imperial_volume,
			CASE WHEN  account_key IN ('Light and Medium Oil','Heavy Oil') THEN boe_volume ELSE NULL END oil_boe_volume, 
			CASE WHEN  account_key IN ('Light and Medium Oil','Heavy Oil') THEN mcfe_volume ELSE NULL END oil_mcfe_volume, 
			CASE WHEN account_key = 'Ethane' THEN metric_volume ELSE NULL END ethane_metric_volume, 
			CASE WHEN account_key ='Ethane' THEN imperial_volume ELSE NULL END ethane_imperial_volume, 
			CASE WHEN account_key ='Ethane' THEN boe_volume ELSE NULL END ethane_boe_volume,
			CASE WHEN account_key ='Ethane' THEN mcfe_volume ELSE NULL END ethane_mcfe_volume,
			CASE WHEN account_key  IN ('Propane','Natural Gas Liquids') THEN metric_volume ELSE NULL END propane_metric_volume,
			CASE WHEN account_key IN ('Propane','Natural Gas Liquids') THEN imperial_volume ELSE NULL END propane_imperial_volume, 
			CASE WHEN account_key IN ('Propane','Natural Gas Liquids') THEN boe_volume ELSE NULL END propane_boe_volume, 
			CASE WHEN account_key IN ('Propane','Natural Gas Liquids') THEN mcfe_volume ELSE NULL END propane_mcfe_volume,
			CASE WHEN account_key ='Butane' THEN metric_volume ELSE NULL END butane_metric_volume,
			CASE WHEN account_key ='Butane' THEN imperial_volume ELSE NULL END butane_imperial_volume, 
			CASE WHEN account_key ='Butane' THEN boe_volume ELSE NULL END butane_boe_volume, 
			CASE WHEN account_key ='Butane' THEN mcfe_volume ELSE NULL END butane_mcfe_volume,
			CASE WHEN account_key ='Pentane Plus' THEN metric_volume ELSE NULL END pentane_metric_volume,
			CASE WHEN account_key ='Pentane Plus' THEN imperial_volume ELSE NULL END pentane_imperial_volume,
			CASE WHEN account_key ='Pentane Plus' THEN boe_volume ELSE NULL END pentane_boe_volume, 
			CASE WHEN account_key ='Pentane Plus' THEN mcfe_volume ELSE NULL END pentane_mcfe_volume, 
			CASE WHEN account_key ='Condensates' THEN metric_volume ELSE NULL END condensate_metric_volume, 
			CASE WHEN account_key ='Condensates' THEN imperial_volume ELSE NULL END condensate_imperial_volume,
			CASE WHEN account_key ='Condensates' THEN boe_volume ELSE NULL END condensate_boe_volume,
			CASE WHEN account_key ='Condensates' THEN mcfe_volume ELSE NULL END condensate_mcfe_volume,
			CASE WHEN account_key ='Water' THEN metric_volume ELSE NULL END water_metric_volume,
			CASE WHEN account_key ='Water' THEN imperial_volume ELSE NULL END water_imperial_volume, 
			CASE WHEN account_key ='Water' THEN boe_volume ELSE NULL END water_boe_volume,
			CASE WHEN account_key ='Water' THEN mcfe_volume ELSE NULL END water_mcfe_volume
		FROM (
			/* ssp Monthly Data -- Working Budget scenario --> Current Budget Year Varable + 2  (see UNION ALL below for other scenarios) */
			SELECT e.uwi, sc.TEXT1, vp.*
			FROM (	SELECT CAST(variable_value +'0101' AS INT) start_date,
						CAST(CAST(variable_value + 1 AS VARCHAR(4))+'1231' AS INT) end_date
					FROM [stage].[t_ctrl_valnav_etl_variables]
					WHERE variable_name = 'CURRENT_BUDGET_YEAR'
			) tp
			, (	SELECT vp.*
				FROM [data_mart].t_fact_valnav_production_glj vp
				WHERE vp.reserve_category_key='1311'
				AND isnull(vp.boe_volume,0) <> 0
			) vp
			INNER JOIN (
					SELECT *
					FROM [stage].[t_ctrl_valnav_etl_variables]
					WHERE variable_name = 'RESERVES_ANALYSIS_SCENARIO'
					AND variable_value IS NOT NULL
					
			) sc ON vp.scenario_key = sc.variable_value
			INNER JOIN (
					SELECT *
					FROM [stage].[t_ctrl_valnav_etl_variables]
					WHERE variable_name = 'VOLUMES_VALNAV_ACCOUNT'
					AND variable_value IS NOT NULL
			) va ON vp.account_key = va.variable_value
			LEFT OUTER JOIN (
					SELECT DISTINCT entity_key, uwi
					FROM [data_mart].t_dim_entity
					WHERE is_valnav=1
			) e ON vp.entity_key = e.entity_key
			WHERE vp.activity_date_key BETWEEN tp.start_date AND tp.end_date

		) ssp
	) SD
	GROUP BY entity_key, activity_date_key, scenario_key, gross_net_key
) SS;