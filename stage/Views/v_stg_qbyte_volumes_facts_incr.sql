CREATE VIEW [stage].[v_stg_qbyte_volumes_facts_incr]
AS SELECT entity_key,
	   --accounting_month_key,
	   activity_month_key,
	   --
	   sum(gas_grs_metric_volume) gas_grs_metric_volume,
	   sum(oil_grs_metric_volume) oil_grs_metric_volume,
	   sum(ethane_grs_metric_volume) ethane_grs_metric_volume,
	   sum(propane_grs_metric_volume) propane_grs_metric_volume,
	   sum(butane_grs_metric_volume) butane_grs_metric_volume,
	   sum(pentane_grs_metric_volume) pentane_grs_metric_volume,
	   sum(cond_grs_metric_volume) cond_grs_metric_volume,
	   --
	   sum(gas_grs_imperial_volume) gas_grs_imperial_volume,
	   sum(oil_grs_imperial_volume) oil_grs_imperial_volume,
	   sum(ethane_grs_imperial_volume) ethane_grs_imperial_volume,
	   sum(propane_grs_imperial_volume) propane_grs_imperial_volume,
	   sum(butane_grs_imperial_volume) butane_grs_imperial_volume,
	   sum(pentane_grs_imperial_volume) pentane_grs_imperial_volume,
	   sum(cond_grs_imperial_volume) cond_grs_imperial_volume,
	   --
	   sum(gas_grs_boe_volume) gas_grs_boe_volume,
	   sum(oil_grs_boe_volume) oil_grs_boe_volume,
	   sum(ethane_grs_boe_volume) ethane_grs_boe_volume,
	   sum(propane_grs_boe_volume) propane_grs_boe_volume,
	   sum(butane_grs_boe_volume) butane_grs_boe_volume,
	   sum(pentane_grs_boe_volume) pentane_grs_boe_volume,
	   sum(cond_grs_boe_volume) cond_grs_boe_volume,
	   --
	   sum(gas_grs_mcfe_volume) gas_grs_mcfe_volume,
	   sum(oil_grs_mcfe_volume) oil_grs_mcfe_volume,
	   sum(ethane_grs_mcfe_volume) ethane_grs_mcfe_volume,
	   sum(propane_grs_mcfe_volume) propane_grs_mcfe_volume,
	   sum(butane_grs_mcfe_volume) butane_grs_mcfe_volume,
	   sum(pentane_grs_mcfe_volume) pentane_grs_mcfe_volume,
	   sum(cond_grs_mcfe_volume) cond_grs_mcfe_volume,
	   --
	   --
	   sum(gas_tgrs_metric_volume) gas_tgrs_metric_volume,
	   sum(oil_tgrs_metric_volume) oil_tgrs_metric_volume,
	   sum(ethane_tgrs_metric_volume) ethane_tgrs_metric_volume,
	   sum(propane_tgrs_metric_volume) propane_tgrs_metric_volume,
	   sum(butane_tgrs_metric_volume) butane_tgrs_metric_volume,
	   sum(pentane_tgrs_metric_volume) pentane_tgrs_metric_volume,
	   sum(cond_tgrs_metric_volume) cond_tgrs_metric_volume,
	   --
	   sum(gas_tgrs_imperial_volume) gas_tgrs_imperial_volume,
	   sum(oil_tgrs_imperial_volume) oil_tgrs_imperial_volume,
	   sum(ethane_tgrs_imperial_volume) ethane_tgrs_imperial_volume,
	   sum(propane_tgrs_imperial_volume) propane_tgrs_imperial_volume,
	   sum(butane_tgrs_imperial_volume) butane_tgrs_imperial_volume,
	   sum(pentane_tgrs_imperial_volume) pentane_tgrs_imperial_volume,
	   sum(cond_tgrs_imperial_volume) cond_tgrs_imperial_volume,
	   --
	   sum(gas_tgrs_boe_volume) gas_tgrs_boe_volume,
	   sum(oil_tgrs_boe_volume) oil_tgrs_boe_volume,
	   sum(ethane_tgrs_boe_volume) ethane_tgrs_boe_volume,
	   sum(propane_tgrs_boe_volume) propane_tgrs_boe_volume,
	   sum(butane_tgrs_boe_volume) butane_tgrs_boe_volume,
	   sum(pentane_tgrs_boe_volume) pentane_tgrs_boe_volume,
	   sum(cond_tgrs_boe_volume) cond_tgrs_boe_volume,
	   --
	   sum(gas_tgrs_mcfe_volume) gas_tgrs_mcfe_volume,
	   sum(oil_tgrs_mcfe_volume) oil_tgrs_mcfe_volume,
	   sum(ethane_tgrs_mcfe_volume) ehtane_tgrs_mcfe_volume,
	   sum(propane_tgrs_mcfe_volume) propane_tgrs_mcfe_volume,
	   sum(butane_tgrs_mcfe_volume) butane_tgrs_mcfe_volume,
	   sum(pentane_tgrs_mcfe_volume) pentane_tgrs_mcfe_volume,
	   sum(cond_tgrs_mcfe_volume) cond_tgrs_mcfe_volume,
	    --
	   --
	   sum(gas_net_metric_volume) gas_net_metric_volume,
	   sum(oil_net_metric_volume) oil_net_metric_volume,
	   sum(ethane_net_metric_volume) ethane_net_metric_volume,
	   sum(propane_net_metric_volume) propane_net_metric_volume,
	   sum(butane_net_metric_volume) butane_net_metric_volume,
	   sum(pentane_net_metric_volume) pentane_net_metric_volume,
	   sum(cond_net_metric_volume) cond_net_metric_volume,
	   --
	   sum(gas_net_imperial_volume) gas_net_imperial_volume,
	   sum(oil_net_imperial_volume) oil_net_imperial_volume,
	   sum(ethane_net_imperial_volume) ethane_net_imperial_volume,
	   sum(propane_net_imperial_volume) propane_net_imperial_volume,
	   sum(butane_net_imperial_volume) butane_net_imperial_volume,
	   sum(pentane_net_imperial_volume) pentane_net_imperial_volume,
	   sum(cond_net_imperial_volume) cond_net_imperial_volume,
	   --
	   sum(gas_net_boe_volume) gas_net_boe_volume,
	   sum(oil_net_boe_volume) oil_net_boe_volume,
	   sum(ethane_net_boe_volume) ethane_net_boe_volume,
	   sum(propane_net_boe_volume) propane_net_boe_volume,
	   sum(butane_net_boe_volume) butane_net_boe_volume,
	   sum(pentane_net_boe_volume) pentane_net_boe_volume,
	   sum(cond_net_boe_volume) cond_net_boe_volume,
	   --
	   sum(gas_net_mcfe_volume) gas_net_mcfe_volume,
	   sum(oil_net_mcfe_volume) oil_net_mcfe_volume,
	   sum(ethane_net_mcfe_volume) ethane_net_mcfe_volume,
	   sum(propane_net_mcfe_volume) propane_net_mcfe_volume,
	   sum(butane_net_mcfe_volume) butane_net_mcfe_volume,
	   sum(pentane_net_mcfe_volume) pentane_net_mcfe_volume,
	   sum(cond_net_mcfe_volume) cond_net_mcfe_volume
FROM 
(SELECT   fg.entity_key, 
		 --fg.accounting_month_key,
		 fg.activity_month_key,
		 -------------------------------------
		 -- Grs
		 -------------------------------------
		 -- gross metric
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'GAS' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END gas_grs_metric_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'OIL' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END oil_grs_metric_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END ethane_grs_metric_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END propane_grs_metric_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END butane_grs_metric_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END pentane_grs_metric_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'COND' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END cond_grs_metric_volume,
		 --
		 -- gross imp
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'GAS' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END gas_grs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'OIL' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END oil_grs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END ethane_grs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END propane_grs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END butane_grs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END pentane_grs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'COND' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END cond_grs_imperial_volume,
		 --
		 -- grs boe
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'GAS' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END gas_grs_boe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'OIL' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END oil_grs_boe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END ethane_grs_boe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END propane_grs_boe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END butane_grs_boe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END pentane_grs_boe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'COND' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END cond_grs_boe_volume,
		 --
		 -- grs mcfe
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'GAS' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END gas_grs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'OIL' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END oil_grs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END ethane_grs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END propane_grs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END butane_grs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END pentane_grs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 1
		      THEN CASE WHEN target_account = 'COND' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END cond_grs_mcfe_volume,
		 --
		 -------------------------------------
		 -- Net
		 -------------------------------------
		 -- net metric
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'GAS' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END gas_net_metric_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'OIL' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END oil_net_metric_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END ethane_net_metric_volume,
		  CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END propane_net_metric_volume,
		  CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END butane_net_metric_volume,
		  CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END pentane_net_metric_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'COND' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END cond_net_metric_volume,
		 --
		 -- net imp
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'GAS' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END gas_net_imperial_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'OIL' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END oil_net_imperial_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END ethane_net_imperial_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END propane_net_imperial_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END butane_net_imperial_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END pentane_net_imperial_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'COND' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END cond_net_imperial_volume,
		 --
		 -- net boe
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'GAS' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END gas_net_boe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'OIL' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END oil_net_boe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END ethane_net_boe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END propane_net_boe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END butane_net_boe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END pentane_net_boe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'COND' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END cond_net_boe_volume,
		 --
		 -- net mcfe
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'GAS' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END gas_net_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'OIL' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END oil_net_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END ethane_net_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END propane_net_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END butane_net_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END pentane_net_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 2
		      THEN CASE WHEN target_account = 'COND' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END cond_net_mcfe_volume,
		 --
		 -------------------------------------
		 -- true grs
		 -------------------------------------
		 -- true grs metric
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'GAS' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END gas_tgrs_metric_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'OIL' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END oil_tgrs_metric_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END ethane_tgrs_metric_volume,
		  CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END propane_tgrs_metric_volume,
		  CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END butane_tgrs_metric_volume,
		  CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END pentane_tgrs_metric_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'COND' THEN fg.metric_volume ELSE NULL END
			  ELSE NULL
		 END cond_tgrs_metric_volume,
		 --
		 -- true grs imp
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'GAS' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END gas_tgrs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'OIL' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END oil_tgrs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END ethane_tgrs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END propane_tgrs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END butane_tgrs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END pentane_tgrs_imperial_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'COND' THEN fg.imperial_volume ELSE NULL END
			  ELSE NULL
		 END cond_tgrs_imperial_volume,
		 --
		 -- true grs boe
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'GAS' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END gas_tgrs_boe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'OIL' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END oil_tgrs_boe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END ethane_tgrs_boe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END propane_tgrs_boe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END butane_tgrs_boe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END pentane_tgrs_boe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'COND' THEN fg.boe_volume ELSE NULL END
			  ELSE NULL
		 END cond_tgrs_boe_volume,
		 --
		 -- true grs mcfe
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'GAS' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END gas_tgrs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'OIL' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END oil_tgrs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'ETHANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END ethane_tgrs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'PROPANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END propane_tgrs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'BUTANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END butane_tgrs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'PENTANE' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END pentane_tgrs_mcfe_volume,
		 CASE WHEN fg.gross_net_key = 3
		      THEN CASE WHEN target_account = 'COND' THEN fg.mcfe_volume ELSE NULL END
			  ELSE NULL
		 END cond_tgrs_mcfe_volume
  FROM 
    (SELECT *
	FROM [stage].[v_fact_source_qbyte_incr]
	WHERE gross_net_key<>4
	) fg 
      INNER JOIN (SELECT DISTINCT
                         account,
                         target_account
                    FROM [stage].[t_ctrl_accounts_xref]
                   WHERE     target_app = 'VOLUMES'
                         AND source_app = 'STG_QBYTE'
                         AND is_active = 'Y') pr
    ON cast(fg.account_key as varchar(20)) = pr.account
  WHERE is_volumes = 1
  AND  boe_volume is not null
  AND gross_net_key in (1,2,3) -- grs, net, true grs
  ) SD
GROUP BY entity_key,
	   --accounting_month_key,
	   activity_month_key;