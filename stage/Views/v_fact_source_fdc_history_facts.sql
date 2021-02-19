CREATE VIEW [stage].[v_fact_source_fdc_history_facts]
AS SELECT site_id,
	   CASE WHEN rtrim(ltrim(cc_hierarchy)) IS NULL 
	        THEN '-1'
			WHEN UPPER(rtrim(ltrim(cc_hierarchy))) like '%CC_NOT_REQUIRED%'
			THEN '-2'
			ELSE rtrim(ltrim(cc_hierarchy))
		END entity_key,
	   CASE WHEN  actvy_date IS NULL THEN -1
			       ELSE  CAST(CAST(YEAR(actvy_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(actvy_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(actvy_date) AS VARCHAR),2) AS INT)
	   END activity_date_key,
	   /*CASE scenario
			WHEN 'Production_FV' THEN 53
			WHEN 'Production_PVR' THEN 55
			WHEN 'Production_ANGLE' THEN 57
			WHEN 'Production_TALISMAN' THEN 59
			WHEN 'FVW_Production' THEN 61
			WHEN 'Sales_Est_ANGLE' THEN 58
			WHEN 'Sales_Est_FV' THEN 54
			WHEN 'Sales_Est_PVR' THEN 56
			WHEN 'Sales_Est_TALISMAN' THEN 60
			ELSE -1
	   END scenario_key,
	   */
	   scenario scenario_key,
	   CASE WHEN grs_net IS NULL THEN -1
	        WHEN upper(grs_net) = 'GRS' THEN 1
			ELSE 2
	   END gross_net_key,
	   upper(data_type) data_type,
	   gas_met_vol_dly gas_metric_volume,
	   gas_imp_vol_dly gas_imperial_volume,
	   gas_boe_vol_dly gas_boe_volume,
	   gas_mcfe_vol_dly gas_mcfe_volume,
	   oil_met_vol_dly oil_metric_volume,
	   oil_imp_vol_dly oil_imperial_volume,
	   oil_boe_vol_dly oil_boe_volume,
	   oil_mcfe_vol_dly * 6 oil_mcfe_volume,
	null [ethane_metric_volume],
	null [ethane_imperial_volume],
	null [ethane_boe_volume] ,
	null [ethane_mcfe_volume] ,
	NGL_MET_VOL_DLY [propane_metric_volume] ,
	NGL_IMP_VOL_DLY [propane_imperial_volume] ,
	NGL_BOE_VOL_DLY [propane_boe_volume] ,
	NGL_MCFE_VOL_DLY  * 6 [propane_mcfe_volume] ,
	null [butane_metric_volume] ,
	null [butane_imperial_volume] ,
	null [butane_boe_volume] ,
	null [butane_mcfe_volume] ,
	null [pentane_metric_volume] ,
	null [pentane_imperial_volume] ,
	null [pentane_boe_volume] ,
	null [pentane_mcfe_volume] ,
	CONDENSATE_MET_VOL_DLY condensate_metric_volume,
	CONDENSATE_IMP_VOL_DLY condensate_imperial_volume,
	CONDENSATE_BOE_VOL_DLY condensate_boe_volume,
	CONDENSATE_MCFE_VOL_DLY * 6 condensate_mcfe_volume,
	isnull(NGL_MET_VOL_DLY,0) + isnull(CONDENSATE_MET_VOL_DLY,0) total_ngl_metric_volume,
	isnull(NGL_IMP_VOL_DLY,0) + isnull(CONDENSATE_IMP_VOL_DLY,0) total_ngl_imperial_volume,
	isnull(NGL_BOE_VOL_DLY,0) + isnull(CONDENSATE_BOE_VOL_DLY,0) total_ngl_boe_volume,
	(isnull(NGL_MCFE_VOL_DLY,0) + isnull(CONDENSATE_MCFE_VOL_DLY,0)) * 6 total_ngl_mcfe_volume,
	isnull(oil_met_vol_dly,0) + isnull(NGL_MET_VOL_DLY,0) + isnull(CONDENSATE_MET_VOL_DLY,0) total_liquid_metric_volume,
	isnull(oil_imp_vol_dly,0) + isnull(ngl_imp_vol_dly,0)+  isnull(CONDENSATE_IMP_VOL_DLY,0) total_liquid_imperial_volume,
	isnull(oil_boe_vol_dly,0) + isnull(ngl_boe_vol_dly,0) + isnull(CONDENSATE_BOE_VOL_DLY,0)total_liquid_boe_volume,
	(isnull(oil_mcfe_vol_dly,0) + isnull(ngl_mcfe_vol_dly,0) + isnull(CONDENSATE_MCFE_VOL_DLY,0)) * 6 total_liquid_mcfe_volume,
	TOTAL_BOE_VOL_DLY total_boe_volume,
	WATER_MET_VOL_DLY water_metric_volume,
	WATER_IMP_VOL_DLY water_imperial_volume,
	WATER_BOE_VOL_DLY water_boe_volume,
	WATER_MCFE_VOL_DLY * 6 water_mcfe_volume,
	hours_on,
	hours_down,
	casing_pressure,
	tubing_pressure,
	injected_src_water,
	injected_prod_water,
	current_timestamp last_update_date
FROM [stage].[t_fdc_history_data]
WHERE site_type IN (1,5,6,7);