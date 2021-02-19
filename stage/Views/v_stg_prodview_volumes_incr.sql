CREATE VIEW [Stage].[v_stg_prodview_volumes_incr]
AS SELECT sd.site_id
	, sd.compida uwi
	, sd.dttm activity_date
	, CASE WHEN sd.dttm IS NULL THEN -1 ELSE  cast(convert(varchar(8), sd.dttm, 112) as int) END activity_date_key
	, sd.cc_num
	--------------------
	/*-- Raw Volumes Section*/
	--------------------
	, sd.gasrawprod gas_metric_volume
	, sd.gasrawprod * isnull(sd.gas_si_to_imp_conv_factor,1) gas_imperial_volume
	, sd.gasrawprod * isnull(sd.gas_boe_thermal,1) gas_boe_volume
	, sd.gasrawprod * isnull(sd.gas_si_to_imp_conv_factor,1) * isnull(sd.gas_mcfe6_thermal,1) gas_mcfe_volume
			
	, sd.oil_metric_volume
	, sd.oil_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) oil_imperial_volume
	, sd.oil_metric_volume * isnull(sd.liquid_boe_thermal,1) oil_boe_volume
	, sd.oil_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) oil_mcfe_volume
			
	, null ethane_metric_volume
	, null ethane_imperial_volume
	, null ethane_boe_volume
	, null ethane_mcfe_volume
			
	, null propane_metric_volume
	, null propane_imperial_volume
	, null propane_boe_volume
	, null propane_mcfe_volume
			
	, null butane_metric_volume
	, null butane_imperial_volume
	, null butane_boe_volume
	, null butane_mcfe_volume
			
	, null pentane_metric_volume
	, null pentane_imperial_volume
	, null pentane_boe_volume
	, null pentane_mcfe_volume
			
	, sd.condensate_metric_volume
	, sd.condensate_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) condensate_imperial_volume
	, sd.condensate_metric_volume * isnull(sd.liquid_boe_thermal,1) condensate_boe_volume
	, sd.condensate_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) condensate_mcfe_volume
			
	, sd.condensate_metric_volume total_ngl_metric_volume
	, sd.condensate_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) total_ngl_imperial_volume
	, sd.condensate_metric_volume * isnull(sd.liquid_boe_thermal,1) total_ngl_boe_volume
	, sd.condensate_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) total_ngl_mcfe_volume
			
	, isnull(sd.oil_metric_volume,0) + isnull(sd.condensate_metric_volume,0) total_liquid_metric_volume
	, (isnull(sd.oil_metric_volume,0) * isnull(sd.liquid_boe_thermal,1)) + (isnull(sd.condensate_metric_volume,0) * isnull(sd.liquid_si_to_imp_conv_factor,1)) total_liquid_imperial_volume
	, (isnull(sd.oil_metric_volume,0) * isnull(sd.liquid_boe_thermal,1)) + (isnull(sd.condensate_metric_volume,0) * isnull(sd.liquid_boe_thermal,1)) total_liquid_boe_volume
	, (isnull(sd.oil_metric_volume,0) * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6)) + (isnull(sd.condensate_metric_volume,0) * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6)) total_liquid_mcfe_volume
			
	, (isnull(sd.condensate_metric_volume,0) * isnull(sd.liquid_boe_thermal,1)) + (isnull(sd.oil_metric_volume,0) * isnull(sd.liquid_boe_thermal,1)) + (isnull(sd.gasrawprod,0) * isnull(sd.gas_boe_thermal,1)) total_boe_volume
			
	, sd.water_metric_volume
	, sd.water_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) water_imperial_volume
	, sd.water_metric_volume * isnull(sd.liquid_boe_thermal,1) water_boe_volume
	, sd.water_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) water_mcfe_volume
	--------------------
	/*-- Sales Volumes Section*/
	--------------------
	, sd.gassales gas_sales_metric_volume
	, sd.gassales * isnull(sd.gas_si_to_imp_conv_factor,1) gas_sales_imperial_volume
	, sd.gassales * isnull(sd.gas_boe_thermal,1) gas_sales_boe_volume
	, sd.gassales * isnull(sd.gas_si_to_imp_conv_factor,1) * isnull(sd.gas_mcfe6_thermal,1) gas_sales_mcfe_volume
			
	, sd.estimated_oil_sales oil_sales_metric_volume
	, sd.estimated_oil_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) oil_sales_imperial_volume
	, sd.estimated_oil_sales * isnull(sd.liquid_boe_thermal,1) oil_sales_boe_volume
	, sd.estimated_oil_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) oil_sales_mcfe_volume
			
	, sd.ethane_sales  ethane_sales_metric_volume
	, sd.ethane_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) ethane_sales_imperial_volume
	, sd.ethane_sales * isnull(sd.liquid_boe_thermal,1) ethane_sales_boe_volume
	, sd.ethane_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) ethane_sales_mcfe_volume
			
	, sd.propane_sales  propane_sales_metric_volume
	, sd.propane_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) propane_sales_imperial_volume
	, sd.propane_sales * isnull(sd.liquid_boe_thermal,1) propane_sales_boe_volume
	, sd.propane_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) propane_sales_mcfe_volume
			
	, sd.butane_sales  butane_sales_metric_volume
	, sd.butane_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) butane_sales_imperial_volume
	, sd.butane_sales * isnull(sd.liquid_boe_thermal,1) butane_sales_boe_volume
	, sd.butane_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) butane_sales_mcfe_volume
			
	, sd.pentane_sales  pentane_sales_metric_volume
	, sd.pentane_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) pentane_sales_imperial_volume
	, sd.pentane_sales * isnull(sd.liquid_boe_thermal,1) pentane_sales_boe_volume
	, sd.pentane_sales * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) pentane_sales_mcfe_volume
			
	, sd.condensate_sales_metric_volume
	, sd.condensate_sales_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) condensate_sales_imperial_volume
	, sd.condensate_sales_metric_volume * isnull(sd.liquid_boe_thermal,1) condensate_sales_boe_volume
	, sd.condensate_sales_metric_volume * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) condensate_sales_mcfe_volume
			
	, (isnull(sd.ethane_sales,0) + isnull(sd.propane_sales,0) + isnull(sd.butane_sales,0) + isnull(sd.pentane_sales,0) + isnull(sd.condensate_sales_metric_volume,0) )  total_ngl_sales_metric_volume
	, (isnull(sd.ethane_sales,0) + isnull(sd.propane_sales,0) + isnull(sd.butane_sales,0) + isnull(sd.pentane_sales,0) + isnull(sd.condensate_sales_metric_volume,0) ) * isnull(sd.liquid_si_to_imp_conv_factor,1) total_ngl_sales_imperial_volume
	, (isnull(sd.ethane_sales,0) + isnull(sd.propane_sales,0) + isnull(sd.butane_sales,0) + isnull(sd.pentane_sales,0) + isnull(sd.condensate_sales_metric_volume,0) ) * isnull(sd.liquid_boe_thermal,1) total_ngl_sales_boe_volume
	, (isnull(sd.ethane_sales,0) + isnull(sd.propane_sales,0) + isnull(sd.butane_sales,0) + isnull(sd.pentane_sales,0) + isnull(sd.condensate_sales_metric_volume,0) ) * isnull(sd.liquid_si_to_imp_conv_factor,1) * isnull(sd.liquid_mcfe6_thermal,6) total_ngl_sales_mcfe_volume
			
	, sd.hours_on
	, sd.hours_down
	, sd.tubing_pressure
	, sd.casing_pressure
	, sd.joints_to_fluid
	, sd.bsw
from (
	SELECT 
		CASE WHEN prv.typmigrationsource = 'pvr' THEN prv.pvr_site_id
			ELSE CASE WHEN prv.keymigrationsource IS NULL THEN prv.compida
					ELSE prv.keymigrationsource END
				END site_id
		, prv.compida
		, prv.dttm
		, prv.cc_num
		, prv.volprodgathgas gasrawprod
		, CASE	WHEN ppd.gas IS NOT NULL THEN ppd.gas * isnull(psy.gas_shrinkage, 1)
				WHEN prv.keymigrationsource IS NOT NULL
					AND isnull (prv.gassalesestimate, 0) <> 0
					AND  (isnull (prv.facilityidd, 'ALLOCATED')) = 'ALLOCATED'
					THEN prv.gassalesestimate
				ELSE prv.volprodgathgas * isnull (psy.gas_shrinkage, 1) END  AS gassales
		, CASE WHEN  (isnull (ptf.typfluidprod, 'OIL')) LIKE '%OIL%' THEN prv.volprodgathhcliq
			ELSE CAST (NULL AS FLOAT) END   oil_metric_volume
		, CASE WHEN  (ptf.typfluidprod) LIKE '%OIL%' 
			THEN CASE	WHEN isnull(prv.volnewprodallochcliq, 0) <> 0 THEN prv.volnewprodallochcliq
						WHEN isnull (prv.volnewprodallochcliq, 0) = 0
							AND isnull (prv.volremainrecovhcliq, 0) <> 0
							THEN 0 ELSE prv.volprodgathhcliq END
			ELSE CAST (NULL AS FLOAT) END   AS estimated_oil_sales
		, CASE WHEN ppd.gas IS NOT NULL 
			THEN CASE WHEN   isnull (psy.c2_yield, 0) = 0 THEN   NULL
					ELSE ppd.gas * isnull (cf.gas_si_to_imp_conv_factor, 1)
						* ( isnull (psy.c2_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END
			ELSE CASE WHEN   isnull (psy.c2_yield, 0) = 0 THEN NULL 
					ELSE prv.volprodgathgas * isnull (cf.gas_si_to_imp_conv_factor, 1)
						* (  isnull(psy.c2_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END
			END  AS ethane_sales
		, CASE WHEN ppd.gas IS NOT NULL 
			THEN CASE WHEN isnull (psy.c3_yield, 0) = 0 THEN NULL
					ELSE ppd.gas * isnull (cf.gas_si_to_imp_conv_factor, 1) 
						* ( isnull (psy.c3_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END
			ELSE CASE WHEN isnull (psy.c3_yield, 0) = 0 THEN NULL
					ELSE prv.volprodgathgas * isnull (cf.gas_si_to_imp_conv_factor, 1)
						* (  isnull(psy.c3_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END
			END  AS propane_sales
		,  CASE WHEN ppd.gas IS NOT NULL
				THEN CASE WHEN isnull (psy.c4_yield, 0) = 0 THEN NULL
					ELSE ppd.gas * isnull (cf.gas_si_to_imp_conv_factor, 1)
						* ( isnull (psy.c4_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END
				ELSE CASE WHEN   isnull (psy.c4_yield, 0) = 0 THEN   NULL 
					ELSE prv.volprodgathgas * isnull (cf.gas_si_to_imp_conv_factor, 1)
						* (  isnull(psy.c4_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END
			END  AS butane_sales
		, CASE WHEN ppd.gas IS NOT NULL 
				THEN CASE WHEN isnull (psy.c5_yield, 0) = 0 THEN NULL
					ELSE ppd.gas * isnull (cf.gas_si_to_imp_conv_factor, 1)
						* ( isnull (psy.c5_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END
				ELSE CASE WHEN isnull (psy.c5_yield, 0) = 0 THEN NULL
					ELSE prv.volprodgathgas * isnull (cf.gas_si_to_imp_conv_factor, 1) 
						* (  isnull(psy.c5_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END
			END  AS pentane_sales
		, CASE WHEN  (ptf.typfluidprod) LIKE '%COND%' THEN prv.volprodgathhcliq
			ELSE CAST (NULL AS FLOAT) END condensate_metric_volume
		, CASE WHEN isnull(psy.condy_yield,0) = 0 THEN null
			ELSE CASE WHEN ppd.gas IS NOT NULL THEN ppd.gas ELSE prv.volprodgathgas END 
				* isnull(cf.gas_si_to_imp_conv_factor,1) * psy.condy_yield  
				/ 1000 / isnull(cf.liquid_si_to_imp_conv_factor,1) END condensate_sales_metric_volume
		, prv.volprodgathwater water_metric_volume
		, prv.volnewprodallocwater water_sales_metric_volume
		, prv.hours_on
		, 24 - isnull(prv.hours_on,0) hours_down
		, prv.prestub tubing_pressure
		, prv.prescas casing_pressure
		, cf.*
		, jtf.joints_to_fluid
		, bsw.bsw
	from 

/*
	(
		select p.*
			, w.company_id + '.' + w.battery_id + '.' + w.well_id as pvr_site_id
		from [stage].[t_prodview_raw_volumes] p
		left outer join [stage].[t_pvr_twell] w on p.keymigrationsource = w.well_id and p.typmigrationsource = 'pvr'
		where p.dttm >= (	select isnull(date_value,cast('2012-01-01' as date)) cutoff_date
							from [stage].[t_ctrl_etl_variables]
							where variable_name='PRODVIEW_INCREMENTAL_CUTOFF_DATE')
		and not exists (	select distinct keymigrationsource 
							from stage.t_ctrl_prodview_duplicates x 
							where x.keymigrationsource = p.keymigrationsource
							and created_date = (select max(created_date) from stage.t_ctrl_prodview_duplicates))
	) prv

*/
(
		select p.*
			, w.company_id + '.' + w.battery_id + '.' + w.well_id as pvr_site_id
		from [stage].[t_prodview_allocated_volumes_incr] p
		left outer join [stage].[t_pvr_twell] w on p.keymigrationsource = w.well_id and p.typmigrationsource = 'pvr'
		where p.dttm >= (	select isnull(date_value,cast('2012-01-01' as date)) cutoff_date
							from [stage].[t_ctrl_etl_variables]
							where variable_name='PRODVIEW_INCREMENTAL_CUTOFF_DATE')
		and not exists (	select distinct keymigrationsource 
							from stage.t_ctrl_prodview_duplicates x 
							where x.keymigrationsource = p.keymigrationsource
							and created_date = (select max(created_date) from stage.t_ctrl_prodview_duplicates))
	) prv

	left outer join [stage].[t_prodview_bsw] bsw		
		on prv.keymigrationsource = bsw.keymigrationsource
		and prv.compida	= bsw.compida
		and prv.dttm >= bsw.calc_dttm_start 
		and prv.dttm <= bsw.calc_dttm_end	

	left outer join [stage].[t_prodview_joints_to_fluid] jtf  
		on prv.keymigrationsource = jtf.keymigrationsource
		and prv.compida	= jtf.compida
		and prv.dttm >= jtf.calc_dttm_start 
		and prv.dttm <= jtf.calc_dttm_end  
/*
	left outer join [stage].[t_prodview_allocated_volumes] pav
	on prv.keymigrationsource = pav.keymigrationsource
		and prv.compida = pav.compida
		and prv.dttm = pav.dttm  
*/
	left outer join [stage].[t_prodview_typfluidprod] ptf
		ON prv.keymigrationsource = ptf.keymigrationsource
		AND prv.compida	= ptf.compida
		AND prv.dttm >= ptf.dttm 
		and prv.dttm <= ptf.ettm  

	left outer join [stage].[t_prodview_shrink_yield_rates] psy
		on prv.idflownet = psy.idflownet
		and prv.keymigrationsource = psy.keymigrationsource
		and prv.compida = psy.compida
		and prv.dttm >= psy.dttmstart 
		and prv.dttm <= psy.dttmend  

	left outer join [stage].[t_prodview_proration_data] ppd
		on prv.completionname = ppd.uwi 
		and prv.dttm = ppd.tdate 
	join [stage].t_ctrl_qbyte_conversion_factors cf on 1=1
) sd

/* Introduced this filter on Oct 2, 2019 after discussing with Des and Steven as data related on NOTREQ cc_nums should be excluded */
where sd.cc_num not like 'no%req%';