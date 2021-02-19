CREATE VIEW [stage].[v_fact_source_fdc_valnav_volumes_daily]
AS SELECT entity_key site_id,
       entity_key,
	   /*
	   CASE WHEN activity_date_key IS NULL or activity_date_key = -1 THEN -1
	     ELSE
	   CAST(
	       CONCAT(
				SUBSTRING(CAST(activity_date_key AS VARCHAR(10)),1,6), 
				 DAY(EOMONTH(cast(cast(activity_date_key as varchar(10)) as datetime)))
				 )
			AS INT)

	   END activity_date_key,
	   */
	   activity_date_key,
	   scenario_key,
	   'VALNAV-DAILY' data_type,
	   gross_net_key,

	   --
	   gas_metric_volume,
	   gas_imperial_volume,
	   gas_boe_volume,
	   gas_mcfe_volume,
	   --
	   oil_metric_volume,
	   oil_imperial_volume,
	   oil_boe_volume,
	   oil_mcfe_volume,
	   --
	   condensate_metric_volume,
	   condensate_imperial_volume,
	   condensate_boe_volume,
	   condensate_mcfe_volume,
	   --
	   ethane_metric_volume,
	   ethane_imperial_volume,
	   ethane_boe_volume,
	   ethane_mcfe_volume,
	   --
	   propane_metric_volume,
	   propane_imperial_volume,
	   propane_boe_volume,
	   propane_mcfe_volume,
	   --
	   butane_metric_volume,
	   butane_imperial_volume,
	   butane_boe_volume,
	   butane_mcfe_volume,
	   --
	   pentane_metric_volume,
	   pentane_imperial_volume,
	   pentane_boe_volume,
	   pentane_mcfe_volume,
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
FROM
(
SELECT entity_key,
	   activity_date_key,
	   scenario_key,
	   gross_net_key,
	   sum(gas_metric_volume) gas_metric_volume,
	   sum(gas_imperial_volume) gas_imperial_volume,
	   sum(gas_boe_volume) gas_boe_volume,
	   sum(gas_mcfe_volume) gas_mcfe_volume,
	   --
	   sum(oil_metric_volume) oil_metric_volume,
	   sum(oil_imperial_volume) oil_imperial_volume,
	   sum(oil_boe_volume) oil_boe_volume,
	   sum(oil_mcfe_volume) oil_mcfe_volume,
	   --
	   sum(condensate_metric_volume) condensate_metric_volume,
	   sum(condensate_imperial_volume) condensate_imperial_volume,
	   sum(condensate_boe_volume) condensate_boe_volume,
	   sum(condensate_mcfe_volume) condensate_mcfe_volume,
	   --
	   sum(ethane_metric_volume) ethane_metric_volume,
	   sum(ethane_imperial_volume) ethane_imperial_volume,
	   sum(ethane_boe_volume) ethane_boe_volume,
	   sum(ethane_mcfe_volume) ethane_mcfe_volume,
	   --
	   sum(propane_metric_volume) propane_metric_volume,
	   sum(propane_imperial_volume) propane_imperial_volume,
	   sum(propane_boe_volume) propane_boe_volume,
	   sum(propane_mcfe_volume) propane_mcfe_volume,
	   --
	   sum(butane_metric_volume) butane_metric_volume,
	   sum(butane_imperial_volume) butane_imperial_volume,
	   sum(butane_boe_volume) butane_boe_volume,
	   sum(butane_mcfe_volume) butane_mcfe_volume,
	   --
	   sum(pentane_metric_volume) pentane_metric_volume,
	   sum(pentane_imperial_volume) pentane_imperial_volume,
	   sum(pentane_boe_volume) pentane_boe_volume,
	   sum(pentane_mcfe_volume) pentane_mcfe_volume,
	   --
	   sum(water_metric_volume) water_metric_volume,
	   sum(water_imperial_volume) water_imperial_volume,
	   sum(water_boe_volume) water_boe_volume,
	   sum(water_mcfe_volume) water_mcfe_volume
FROM
(
--SD
-- Daily Data for Current Approved Scenario Only
SELECT CASE WHEN vp.entity_key = '73d70a3d-cc63-41c6-9b1f-0d29e760a72f-Q2-2015'
            THEN '100081604106W500-2015 Q2'
			-- special case to make this uwi to go EA instead of West as it was reported that way to the Board.
			ELSE e.uwi
	   END  entity_key,
       CASE WHEN  time_period.dates IS NULL THEN -1
			       ELSE  CAST(CAST(YEAR(time_period.dates) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(time_period.dates) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(time_period.dates) AS VARCHAR),2) AS INT)
	   END activity_date_key,
	   --activity_date_key,
	   curr_scenario.cube_child_member scenario_key,
	  -- 'DAILY' period_type,
	   CASE WHEN vp.gross_net_key = 'GRS' THEN 1 ELSE 2 END gross_net_key,
	   CASE WHEN vp.account_key  IN ('SalesGas','Solution Gas')
		    THEN vp.metric_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END gas_metric_volume,
	   CASE WHEN vp.account_key IN ('SalesGas','Solution Gas')
		    THEN vp.imperial_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END gas_imperial_volume,
	   CASE WHEN vp.account_key IN ('SalesGas','Solution Gas')
		    THEN vp.boe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END gas_boe_volume,
	   CASE WHEN vp.account_key IN ('SalesGas','Solution Gas')
		    THEN vp.mcfe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END gas_mcfe_volume,
	   --
	   CASE WHEN  vp.account_key IN ('Light and Medium Oil','Heavy Oil')
	        THEN vp.metric_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END oil_metric_volume,
	   CASE WHEN  vp.account_key IN ('Light and Medium Oil','Heavy Oil')
	        THEN vp.imperial_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END oil_imperial_volume,
	   CASE WHEN  vp.account_key IN ('Light and Medium Oil','Heavy Oil')
	        THEN vp.boe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END oil_boe_volume,
	   CASE WHEN  vp.account_key IN ('Light and Medium Oil','Heavy Oil')
	        THEN vp.mcfe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END oil_mcfe_volume,
	   --
	   CASE WHEN  vp.account_key = 'Ethane'
	        THEN vp.metric_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END ethane_metric_volume,
	   CASE WHEN  vp.account_key ='Ethane'
	        THEN vp.imperial_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END ethane_imperial_volume,
	   CASE WHEN  vp.account_key ='Ethane'
	        THEN vp.boe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END ethane_boe_volume,
	   CASE WHEN  vp.account_key ='Ethane'
	        THEN vp.mcfe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END ethane_mcfe_volume,
	   --
	   CASE WHEN  vp.account_key  IN ('Propane','Natural Gas Liquids')
	        THEN vp.metric_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END propane_metric_volume,
	   CASE WHEN  vp.account_key IN ('Propane','Natural Gas Liquids')
	        THEN vp.imperial_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END propane_imperial_volume,
	   CASE WHEN  vp.account_key IN ('Propane','Natural Gas Liquids')
	        THEN vp.boe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END propane_boe_volume,
	   CASE WHEN  vp.account_key IN ('Propane','Natural Gas Liquids')
	        THEN vp.mcfe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END propane_mcfe_volume,
	   --
	   CASE WHEN  vp.account_key ='Butane'
	        THEN vp.metric_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END butane_metric_volume,
	   CASE WHEN  vp.account_key ='Butane'
	        THEN vp.imperial_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END butane_imperial_volume,
	   CASE WHEN  vp.account_key ='Butane'
	        THEN vp.boe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END butane_boe_volume,
	   CASE WHEN  vp.account_key ='Butane'
	        THEN vp.mcfe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END butane_mcfe_volume,
	   --
	   CASE WHEN  vp.account_key ='Pentane Plus'
	        THEN vp.metric_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END pentane_metric_volume,
	   CASE WHEN  vp.account_key ='Pentane Plus'
	        THEN vp.imperial_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END pentane_imperial_volume,
	   CASE WHEN  vp.account_key ='Pentane Plus'
	        THEN vp.boe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END pentane_boe_volume,
	   CASE WHEN  vp.account_key ='Pentane Plus'
	        THEN vp.mcfe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END pentane_mcfe_volume,
	   --
	   CASE WHEN  vp.account_key ='Condensates'
	        THEN vp.metric_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END condensate_metric_volume,
	   CASE WHEN  vp.account_key ='Condensates'
	        THEN vp.imperial_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END condensate_imperial_volume,
	   CASE WHEN  vp.account_key ='Condensates'
	        THEN vp.boe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END condensate_boe_volume,
	   CASE WHEN  vp.account_key ='Condensates'
	        THEN vp.mcfe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END condensate_mcfe_volume,
	   --
	   CASE WHEN  vp.account_key ='Water'
	        THEN vp.metric_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END water_metric_volume,
	   CASE WHEN  vp.account_key ='Water'
	        THEN vp.imperial_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END water_imperial_volume,
	   CASE WHEN  vp.account_key ='Water'
	        THEN vp.boe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END water_boe_volume,
	   CASE WHEN  vp.account_key ='Water'
	        THEN vp.mcfe_volume / day(EOMONTH(time_period.dates))
			ELSE NULL
	   END water_mcfe_volume--,
FROM (SELECT * 
     FROM 
	      (SELECT CAST(variable_value +'0101' AS INT) start_date,
                                               CAST(CAST(variable_value+1 AS VARCHAR(4))+'1231' AS INT) end_date
                                       FROM [stage].[t_ctrl_valnav_etl_variables]
                                      WHERE variable_name = 'CURRENT_BUDGET_YEAR_DAILY_DATA'
	       ) tp,
	      [data_mart].t_fact_valnav_production vp
	 WHERE reserve_category_key='1311'
	 AND isnull(vp.boe_volume,0)  <> 0
	-- AND vp.gross_net_key IN ('WI','FI','RI')
	 AND vp.activity_date_key BETWEEN tp.start_date AND tp.end_date
	 )  vp
	 --
     JOIN
	 (SELECT DISTINCT variable_value valnav_scenario, cube_child_member
		FROM [stage].[t_ctrl_valnav_etl_variables]
		 WHERE variable_name = 'VOLUMES_DATA_SCENARIO'
		AND variable_value IS NOT NULL
		AND variable_value LIKE 
		(
		SELECT DISTINCT '%'+variable_value+'%'
		FROM [stage].[t_ctrl_valnav_etl_variables]
		 WHERE variable_name = 'VALNAV_CURRENT_APPROVED_BUDGET'
		 )
	 ) curr_scenario
	ON vp.scenario_key = curr_scenario.valnav_scenario
	--
	JOIN
	(SELECT *
		FROM [stage].[t_ctrl_valnav_etl_variables]
		WHERE variable_name = 'VOLUMES_VALNAV_ACCOUNT'
		AND variable_value IS NOT NULL
	 ) va
    ON vp.account_key = va.variable_value
	--
	JOIN 
	  [stage].t_ctrl_volumes_valnav_time_period time_period
	ON SUBSTRING(CAST(vp. activity_date_key AS VARCHAR),1,6) = time_period.year_month
	LEFT OUTER JOIN
	(SELECT DISTINCT entity_key,
			uwi
	 FROM [data_mart].t_dim_entity
	 WHERE is_valnav=1
	 ) e
	ON vp.entity_key = e.entity_key
) SD
GROUP BY entity_key,
	   activity_date_key,
	   scenario_key,
	   gross_net_key
) SS;