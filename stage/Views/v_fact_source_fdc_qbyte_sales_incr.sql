CREATE VIEW [stage].[v_fact_source_fdc_qbyte_sales_incr]
AS SELECT entity_key site_id,
	   entity_key,
       activity_month_key activity_date_key,
	   gross_net_key,
	   'Sales_Actual' scenario_key,
	   'QBYTE' data_type,
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
	   cond_metric_volume,
	   cond_imperial_volume,
	   cond_boe_volume,
	   cond_mcfe_volume,
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
	   isnull(ethane_metric_volume,0) + isnull(propane_metric_volume,0) + isnull(butane_metric_volume,0) + isnull(pentane_metric_volume,0) + isnull(cond_metric_volume,0) total_ngl_metric_volume,
	   isnull(ethane_imperial_volume,0) + isnull(propane_imperial_volume,0) + isnull(butane_imperial_volume,0) + isnull(pentane_imperial_volume,0) + isnull(cond_imperial_volume,0) total_ngl_imperial_volume,
	   isnull(ethane_boe_volume,0) + isnull(propane_boe_volume,0) + isnull(butane_boe_volume,0) + isnull(pentane_boe_volume,0) + isnull(cond_boe_volume,0) total_ngl_boe_volume,
	   isnull(ethane_mcfe_volume,0) + isnull(propane_mcfe_volume,0) + isnull(butane_mcfe_volume,0) + isnull(pentane_mcfe_volume,0) + isnull(cond_mcfe_volume,0) total_ngl_mcfe_volume,
	   -- 
	   isnull(oil_metric_volume,0) + isnull(cond_metric_volume,0) + isnull(ethane_metric_volume,0) + isnull(propane_metric_volume,0) + isnull(butane_metric_volume,0) + isnull(pentane_metric_volume,0) total_liquid_metric_volume,
	   isnull(oil_imperial_volume,0) + isnull(cond_imperial_volume,0) + isnull(ethane_imperial_volume,0) + isnull(propane_imperial_volume,0) + isnull(butane_imperial_volume,0) + isnull(pentane_imperial_volume,0) total_liquid_imperial_volume,
	   isnull(oil_boe_volume,0) + isnull(cond_boe_volume,0) + isnull(ethane_boe_volume,0) + isnull(propane_boe_volume,0) + isnull(butane_boe_volume,0) + isnull(pentane_boe_volume,0) total_liquid_boe_volume,
	   isnull(oil_mcfe_volume,0) + isnull(cond_mcfe_volume,0) + isnull(ethane_mcfe_volume,0) + isnull(propane_mcfe_volume,0) + isnull(butane_mcfe_volume,0) + isnull(pentane_mcfe_volume,0) total_liquid_mcfe_volume,
	   --
	   isnull(gas_boe_volume,0) + isnull(oil_boe_volume,0) + isnull(cond_boe_volume,0) + isnull(ethane_boe_volume,0) + isnull(propane_boe_volume,0) + isnull(butane_boe_volume,0) + isnull(pentane_boe_volume,0) total_boe_volume
FROM
(
SELECT entity_key,
       activity_month_key,
	   1 gross_net_key,
	   --
	   CASE WHEN isnull(gas_grs_metric_volume,0) <> isnull(gas_tgrs_metric_volume,0)
		    THEN gas_tgrs_metric_volume
			ELSE gas_grs_metric_volume
	   END gas_metric_volume,
	   CASE WHEN isnull(gas_grs_imperial_volume,0) <> isnull(gas_tgrs_imperial_volume,0)
		    THEN gas_tgrs_imperial_volume
			ELSE gas_grs_imperial_volume
	   END gas_imperial_volume,
	   CASE WHEN isnull(gas_grs_boe_volume,0) <> isnull(gas_tgrs_boe_volume,0)
		    THEN gas_tgrs_boe_volume
			ELSE gas_grs_boe_volume
	   END gas_boe_volume,
	   CASE WHEN isnull(gas_grs_mcfe_volume,0) <> isnull(gas_tgrs_mcfe_volume,0)
		    THEN gas_tgrs_mcfe_volume
			ELSE gas_grs_mcfe_volume
	   END gas_mcfe_volume,
	   --
	   CASE WHEN isnull(oil_grs_metric_volume,0) <> isnull(oil_tgrs_metric_volume,0)
		    THEN oil_tgrs_metric_volume
			ELSE oil_grs_metric_volume
	   END oil_metric_volume,
	   CASE WHEN isnull(oil_grs_imperial_volume,0) <> isnull(oil_tgrs_imperial_volume,0)
		    THEN oil_tgrs_imperial_volume
			ELSE oil_grs_imperial_volume
	   END oil_imperial_volume,
	   CASE WHEN isnull(oil_grs_boe_volume,0) <> isnull(oil_tgrs_boe_volume,0)
		    THEN oil_tgrs_boe_volume
			ELSE oil_grs_boe_volume
	   END oil_boe_volume,
	   CASE WHEN isnull(oil_grs_mcfe_volume,0) <> isnull(oil_tgrs_mcfe_volume,0)
		    THEN oil_tgrs_mcfe_volume
			ELSE oil_grs_mcfe_volume
	   END oil_mcfe_volume,
	   --
	   CASE WHEN isnull(cond_grs_metric_volume,0) <> isnull(cond_tgrs_metric_volume,0)
		    THEN cond_tgrs_metric_volume
			ELSE cond_grs_metric_volume
	   END cond_metric_volume,
	   CASE WHEN isnull(cond_grs_imperial_volume,0) <> isnull(cond_tgrs_imperial_volume,0)
		    THEN cond_tgrs_imperial_volume
			ELSE cond_grs_imperial_volume
	   END cond_imperial_volume,
	   CASE WHEN isnull(cond_grs_boe_volume,0) <> isnull(cond_tgrs_boe_volume,0)
		    THEN cond_tgrs_boe_volume
			ELSE cond_grs_boe_volume
	   END cond_boe_volume,
	   CASE WHEN isnull(cond_grs_mcfe_volume,0) <> isnull(cond_tgrs_mcfe_volume,0)
		    THEN cond_tgrs_mcfe_volume
			ELSE cond_grs_mcfe_volume
	   END cond_mcfe_volume,
	   --
	   CASE WHEN isnull(ethane_grs_metric_volume,0) <> isnull(ethane_tgrs_metric_volume,0)
		    THEN ethane_tgrs_metric_volume
			ELSE ethane_grs_metric_volume
	   END ethane_metric_volume,
	   CASE WHEN isnull(ethane_grs_imperial_volume,0) <> isnull(ethane_tgrs_imperial_volume,0)
		    THEN ethane_tgrs_imperial_volume
			ELSE ethane_grs_imperial_volume
	   END ethane_imperial_volume,
	   CASE WHEN isnull(ethane_grs_boe_volume,0) <> isnull(ethane_tgrs_boe_volume,0)
		    THEN ethane_tgrs_boe_volume
			ELSE ethane_grs_boe_volume
	   END ethane_boe_volume,
	   CASE WHEN isnull(ethane_grs_mcfe_volume,0) <> isnull(ethane_tgrs_mcfe_volume,0)
		    THEN ethane_tgrs_mcfe_volume
			ELSE ethane_grs_mcfe_volume
	   END ethane_mcfe_volume,
	   --
	   CASE WHEN isnull(propane_grs_metric_volume,0) <> isnull(propane_tgrs_metric_volume,0)
		    THEN propane_tgrs_metric_volume
			ELSE propane_grs_metric_volume
	   END propane_metric_volume,
	   CASE WHEN isnull(propane_grs_imperial_volume,0) <> isnull(propane_tgrs_imperial_volume,0)
		    THEN propane_tgrs_imperial_volume
			ELSE propane_grs_imperial_volume
	   END propane_imperial_volume,
	   CASE WHEN isnull(propane_grs_boe_volume,0) <> isnull(propane_tgrs_boe_volume,0)
		    THEN propane_tgrs_boe_volume
			ELSE propane_grs_boe_volume
	   END propane_boe_volume,
	   CASE WHEN isnull(propane_grs_mcfe_volume,0) <> isnull(propane_tgrs_mcfe_volume,0)
		    THEN propane_tgrs_mcfe_volume
			ELSE propane_grs_mcfe_volume
	   END propane_mcfe_volume,
	   --
	   CASE WHEN isnull(butane_grs_metric_volume,0) <> isnull(butane_tgrs_metric_volume,0)
		    THEN butane_tgrs_metric_volume
			ELSE butane_grs_metric_volume
	   END butane_metric_volume,
	   CASE WHEN isnull(butane_grs_imperial_volume,0) <> isnull(butane_tgrs_imperial_volume,0)
		    THEN butane_tgrs_imperial_volume
			ELSE butane_grs_imperial_volume
	   END butane_imperial_volume,
	   CASE WHEN isnull(butane_grs_boe_volume,0) <> isnull(butane_tgrs_boe_volume,0)
		    THEN butane_tgrs_boe_volume
			ELSE butane_grs_boe_volume
	   END butane_boe_volume,
	   CASE WHEN isnull(butane_grs_mcfe_volume,0) <> isnull(butane_tgrs_mcfe_volume,0)
		    THEN butane_tgrs_mcfe_volume
			ELSE butane_grs_mcfe_volume
	   END butane_mcfe_volume,
	   --
	   CASE WHEN isnull(pentane_grs_metric_volume,0) <> isnull(pentane_tgrs_metric_volume,0)
		    THEN pentane_tgrs_metric_volume
			ELSE pentane_grs_metric_volume
	   END pentane_metric_volume,
	   CASE WHEN isnull(pentane_grs_imperial_volume,0) <> isnull(pentane_tgrs_imperial_volume,0)
		    THEN pentane_tgrs_imperial_volume
			ELSE pentane_grs_imperial_volume
	   END pentane_imperial_volume,
	   CASE WHEN isnull(pentane_grs_boe_volume,0) <> isnull(pentane_tgrs_boe_volume,0)
		    THEN pentane_tgrs_boe_volume
			ELSE pentane_grs_boe_volume
	   END pentane_boe_volume,
	   CASE WHEN isnull(pentane_grs_mcfe_volume,0) <> isnull(pentane_tgrs_mcfe_volume,0)
		    THEN pentane_tgrs_mcfe_volume
			ELSE pentane_grs_mcfe_volume
	   END pentane_mcfe_volume

FROM [stage].t_stg_qbyte_volumes_facts_incr
--
UNION ALL
--
SELECT entity_key,
       activity_month_key,
	   2 gross_net_key,
	   --
	   gas_net_metric_volume gas_metric_volume,
	   gas_net_imperial_volume gas_imperial_volume,
	   gas_net_boe_volume gas_boe_volume,
	   gas_net_mcfe_volume gas_mcfe_volume,
	   --
	   oil_net_metric_volume oil_metric_volume,
	   oil_net_imperial_volume oil_imperial_volume,
	   oil_net_boe_volume oil_boe_volume,
	   oil_net_mcfe_volume oil_mcfe_volume,
	   --
	   cond_net_metric_volume cond_metric_volume,
	   cond_net_imperial_volume cond_imperial_volume,
	   cond_net_boe_volume cond_boe_volume,
	   cond_net_mcfe_volume cond_mcfe_volume,
	   --
	   ethane_net_metric_volume ethane_metric_volume,
	   ethane_net_imperial_volume ethane_imperial_volume,
	   ethane_net_boe_volume ethane_boe_volume,
	   ethane_net_mcfe_volume ethane_mcfe_volume,
	   --
	   propane_net_metric_volume propane_metric_volume,
	   propane_net_imperial_volume propane_imperial_volume,
	   propane_net_boe_volume propane_boe_volume,
	   propane_net_mcfe_volume propane_mcfe_volume,
	   --
	   butane_net_metric_volume butane_metric_volume,
	   butane_net_imperial_volume butane_imperial_volume,
	   butane_net_boe_volume butane_boe_volume,
	   butane_net_mcfe_volume butane_mcfe_volume,
	   --
	   pentane_net_metric_volume pentane_metric_volume,
	   pentane_net_imperial_volume pentane_imperial_volume,
	   pentane_net_boe_volume pentane_boe_volume,
	   pentane_net_mcfe_volume pentane_mcfe_volume
	   --

	   /*ngl_net_metric_volume total_ngl_metric_volume,
	   ngl_net_imperial_volume total_ngl_imperial_volume,
	   ngl_net_boe_volume  total_ngl_boe_volume,
	   ngl_net_mcfe_volume total_ngl_mcfe_volume
	   */
	   --
FROM [stage].t_stg_qbyte_volumes_facts_incr
) sd;