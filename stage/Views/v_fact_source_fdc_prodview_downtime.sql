CREATE VIEW [stage].[v_fact_source_fdc_prodview_downtime]
AS with downtime_source
as (
	SELECT site_id
		, compida uwi
		, dttm activity_date
		, CASE WHEN dttm IS NULL THEN -1 ELSE convert(int,convert(varchar(8),dttm,112)) END activity_date_key
		, cc_num
		, scenario_key
		, codedowntm1 scenario
		, vollostgas gas_metric_volume
		, vollostgas * isnull(cf.gas_si_to_imp_conv_factor,1) gas_imperial_volume
		, vollostgas * isnull(cf.gas_boe_thermal,1) gas_boe_volume
		, vollostgas * isnull(cf.gas_si_to_imp_conv_factor,1) * isnull(cf.gas_mcfe6_thermal,1) gas_mcfe_volume
		, oil_lost_volume oil_metric_volume
		, oil_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) oil_imperial_volume
		, oil_lost_volume * isnull(cf.liquid_boe_thermal,1) oil_boe_volume
		, oil_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,1) oil_mcfe_volume
		, ethane_lost_volume  ethane_metric_volume
		, ethane_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) ethane_imperial_volume
		, ethane_lost_volume * isnull(cf.liquid_boe_thermal,1) ethane_boe_volume
		, ethane_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,1) ethane_mcfe_volume
		, propane_lost_volume  propane_metric_volume
		, propane_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) propane_imperial_volume
		, propane_lost_volume * isnull(cf.liquid_boe_thermal,1) propane_boe_volume
		, propane_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,1) propane_mcfe_volume
		, butane_lost_volume  butane_metric_volume
		, butane_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) butane_imperial_volume
		, butane_lost_volume * isnull(cf.liquid_boe_thermal,1) butane_boe_volume
		, butane_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,1) butane_mcfe_volume
		, pentane_lost_volume  pentane_metric_volume
		, pentane_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) pentane_imperial_volume
		, pentane_lost_volume * isnull(cf.liquid_boe_thermal,1) pentane_boe_volume
		, pentane_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,1) pentane_mcfe_volume
		, condensate_lost_volume condensate_metric_volume
		, condensate_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) condensate_imperial_volume
		, condensate_lost_volume * isnull(cf.liquid_boe_thermal,1) condensate_boe_volume
		, condensate_lost_volume * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,1) condensate_mcfe_volume
		, (isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0) + isnull(condensate_lost_volume,0))  total_ngl_metric_volume
		, (isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0) + isnull(condensate_lost_volume,0)) * isnull(cf.liquid_si_to_imp_conv_factor,1) total_ngl_imperial_volume
		, (isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0) + isnull(condensate_lost_volume,0)) * isnull(cf.liquid_boe_thermal,1) total_ngl_boe_volume
		, (isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0) + isnull(condensate_lost_volume,0)) * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6) total_ngl_mcfe_volume
		, isnull(oil_lost_volume,0) + isnull(condensate_lost_volume,0) + isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0) total_liquid_metric_volume
		, (isnull(oil_lost_volume,0) + (isnull(condensate_lost_volume,0) + isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0)) * isnull(cf.liquid_si_to_imp_conv_factor,1)) total_liquid_imperial_volume
		, (isnull(oil_lost_volume,0) + (isnull(condensate_lost_volume,0) + isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0)) * isnull(cf.liquid_si_to_imp_conv_factor,1)) total_liquid_boe_volume
		, (isnull(oil_lost_volume,0) + (isnull(condensate_lost_volume,0) + isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0)) * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6)) total_liquid_mcfe_volume
		, (isnull(vollostgas,0) * isnull(cf.gas_boe_thermal,1)) + (isnull(oil_lost_volume,0) + (isnull(condensate_lost_volume,0) + isnull(ethane_lost_volume,0) + isnull(propane_lost_volume,0) + isnull(butane_lost_volume,0) + isnull(pentane_lost_volume,0)) * isnull(cf.liquid_si_to_imp_conv_factor,1)) total_boe_volume
		, vollostwater water_metric_volume
		, vollostwater * isnull(cf.liquid_si_to_imp_conv_factor,1) water_imperial_volume
		, vollostwater * isnull(cf.liquid_boe_thermal,1) water_boe_volume
		, vollostwater * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6) water_mcfe_volume
		, hours_on
		, hours_down
	FROM (
		SELECT CASE WHEN UPPER (dtm.typmigrationsource) LIKE '%PVR%' THEN pvr.company_id + '.' + pvr.battery_id + '.' + pvr.well_id 
				ELSE CASE WHEN dtm.keymigrationsource IS NULL THEN dtm.compida ELSE dtm.keymigrationsource END END site_id
			, dtm.compida
			, dtm.dttm
			, dtm.cc_num
			, dtm.codedowntm1
			, CASE WHEN dtm.codedowntm1 IS NULL THEN '-1' ELSE dtm.codedowntm1 END scenario_key
			, dtm.vollostgas
			, CASE WHEN UPPER (isnull (ptf.typfluidprod, 'OIL')) LIKE '%OIL%' THEN dtm.vollosthcliq ELSE CAST (NULL AS FLOAT) END   oil_lost_volume
			, CASE WHEN isnull (psy.c2_yield, 0) = 0 THEN NULL ELSE dtm.vollostgas * isnull (cf.gas_si_to_imp_conv_factor, 1) * ( isnull (psy.c2_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END AS ethane_lost_volume
			, CASE WHEN isnull (psy.c3_yield, 0) = 0 THEN NULL ELSE dtm.vollostgas * isnull (cf.gas_si_to_imp_conv_factor, 1) * ( isnull (psy.c3_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END AS propane_lost_volume
			, CASE WHEN isnull (psy.c4_yield, 0) = 0 THEN NULL ELSE dtm.vollostgas * isnull (cf.gas_si_to_imp_conv_factor, 1) * ( isnull (psy.c4_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END AS butane_lost_volume
			, CASE WHEN isnull (psy.c5_yield, 0) = 0 THEN NULL ELSE dtm.vollostgas * isnull (cf.gas_si_to_imp_conv_factor, 1) * ( isnull (psy.c5_yield, 0)) / 1000 / isnull (cf.liquid_si_to_imp_conv_factor, 1) END  AS pentane_lost_volume
			, CASE WHEN UPPER (ptf.typfluidprod) LIKE '%COND%' THEN dtm.vollosthcliq ELSE CAST (NULL AS FLOAT) END condensate_lost_volume
			, dtm.vollostwater
			, dtm.hours_on
			, dtm.hours_down
		FROM (
				SELECT ISNULL(date_value,cast('2012-01-01' as date)) cutoff_date
				FROM [stage].[t_ctrl_etl_variables]
				WHERE variable_name='PRODVIEW_INCREMENTAL_CUTOFF_DATE'
		) cd
		, [stage].t_ctrl_qbyte_conversion_factors cf
		, (	
			SELECT *
			FROM [stage].[t_prodview_downtime_hours_volumes] p
			WHERE not exists (	select keymigrationsource 
								from stage.t_ctrl_prodview_duplicates x 
								where x.keymigrationsource = p.keymigrationsource
								and created_date = (select max(created_date) from stage.t_ctrl_prodview_duplicates))
		) dtm
		LEFT OUTER JOIN [stage].[t_prodview_typfluidprod] ptf
			ON dtm.keymigrationsource = ptf.keymigrationsource
			AND dtm.compida	= ptf.compida
			AND (dtm.dttm >= ptf.dttm and dtm.dttm <= ptf.ettm)
		LEFT OUTER JOIN [stage].[t_prodview_shrink_yield_rates] psy
			ON dtm.idflownet = psy.idflownet
			AND dtm.keymigrationsource = psy.keymigrationsource
			AND dtm.compida = psy.compida
			AND  dtm.dttm >= psy.dttmstart 
			AND  dtm.dttm <= psy.dttmend
		LEFT OUTER JOIN [stage].[t_pvr_twell] pvr ON dtm.keymigrationsource = pvr.well_id
		WHERE dtm.dttm > = cd.cutoff_date
	) SD
	, [stage].t_ctrl_qbyte_conversion_factors cf
)
, gross_downtime
as (
	SELECT site_id,
		uwi,
		cc_num,
		activity_date,
		activity_date_key,
		'DOWNTIME' data_type,
		scenario_key,
		1 gross_net_key,
		gas_metric_volume,
		gas_imperial_volume,
		gas_boe_volume,
		gas_mcfe_volume,
		oil_metric_volume,
		oil_imperial_volume,
		oil_boe_volume,
		oil_mcfe_volume,
		ethane_metric_volume,
		ethane_imperial_volume,
		ethane_boe_volume,
		ethane_mcfe_volume,
		propane_metric_volume,
		propane_imperial_volume,
		propane_boe_volume,
		propane_mcfe_volume,
		butane_metric_volume,
		butane_imperial_volume,
		butane_boe_volume,
		butane_mcfe_volume,
		pentane_metric_volume,
		pentane_imperial_volume,
		pentane_boe_volume,
		pentane_mcfe_volume,
		condensate_metric_volume,
		condensate_imperial_volume,
		condensate_boe_volume,
		condensate_mcfe_volume,
		total_ngl_metric_volume,
		total_ngl_imperial_volume,
		total_ngl_boe_volume,
		total_ngl_mcfe_volume,
		total_liquid_metric_volume,
		total_liquid_imperial_volume,
		total_liquid_boe_volume,
		total_liquid_mcfe_volume,
		total_boe_volume,
		water_metric_volume,
		water_imperial_volume,
		water_boe_volume,
		water_mcfe_volume,
		hours_on,
		hours_down
	FROM downtime_source
)

select site_id,
	uwi,
	cc_num,
	activity_date,
	activity_date_key,
	data_type,
	scenario_key,
	gross_net_key,
	gas_metric_volume,
	gas_imperial_volume,
	gas_boe_volume,
	gas_mcfe_volume,
	oil_metric_volume,
	oil_imperial_volume,
	oil_boe_volume,
	oil_mcfe_volume,
	ethane_metric_volume,
	ethane_imperial_volume,
	ethane_boe_volume,
	ethane_mcfe_volume,
	propane_metric_volume,
	propane_imperial_volume,
	propane_boe_volume,
	propane_mcfe_volume,
	butane_metric_volume,
	butane_imperial_volume,
	butane_boe_volume,
	butane_mcfe_volume,
	pentane_metric_volume,
	pentane_imperial_volume,
	pentane_boe_volume,
	pentane_mcfe_volume,
	condensate_metric_volume,
	condensate_imperial_volume,
	condensate_boe_volume,
	condensate_mcfe_volume,
	total_ngl_metric_volume,
	total_ngl_imperial_volume,
	total_ngl_boe_volume,
	total_ngl_mcfe_volume,
	total_liquid_metric_volume,
	total_liquid_imperial_volume,
	total_liquid_boe_volume,
	total_liquid_mcfe_volume,
	total_boe_volume,
	water_metric_volume,
	water_imperial_volume,
	water_boe_volume,
	water_mcfe_volume,
	hours_on,
	hours_down
from gross_downtime
--
UNION ALL
--
select site_id,
	gd.uwi,
	gd.cc_num,
	activity_date,
	activity_date_key,
	data_type,
	scenario_key,
	2 gross_net_key,
	gas_metric_volume * (isnull(wi.working_interest,100) / 100) gas_metric_volume,
	gas_imperial_volume * (isnull(wi.working_interest,100) / 100) gas_imperial_volume,
	gas_boe_volume * (isnull(wi.working_interest,100) / 100) gas_boe_volume,
	gas_mcfe_volume * (isnull(wi.working_interest,100) / 100) gas_mcfe_volume,
	oil_metric_volume * (isnull(wi.working_interest,100) / 100) oil_metric_volume,
	oil_imperial_volume * (isnull(wi.working_interest,100) / 100) oil_imperial_volume,
	oil_boe_volume * (isnull(wi.working_interest,100) / 100) oil_boe_volume,
	oil_mcfe_volume * (isnull(wi.working_interest,100) / 100) oil_mcfe_volume,
	ethane_metric_volume * (isnull(wi.working_interest,100) / 100) ethane_metric_volume,
	ethane_imperial_volume * (isnull(wi.working_interest,100) / 100) ethane_imperial_volume,
	ethane_boe_volume * (isnull(wi.working_interest,100) / 100) ethane_boe_volume,
	ethane_mcfe_volume * (isnull(wi.working_interest,100) / 100) ethane_mcfe_volume,
	propane_metric_volume * (isnull(wi.working_interest,100) / 100) propane_metric_volume,
	propane_imperial_volume * (isnull(wi.working_interest,100) / 100) propane_imperial_volume,
	propane_boe_volume * (isnull(wi.working_interest,100) / 100) propane_boe_volume,
	propane_mcfe_volume * (isnull(wi.working_interest,100) / 100) propane_mcfe_volume,
	butane_metric_volume * (isnull(wi.working_interest,100) / 100) butane_metric_volume,
	butane_imperial_volume * (isnull(wi.working_interest,100) / 100) butane_imperial_volume,
	butane_boe_volume * (isnull(wi.working_interest,100) / 100) butane_boe_volume,
	butane_mcfe_volume * (isnull(wi.working_interest,100) / 100) butane_mcfe_volume,
	pentane_metric_volume * (isnull(wi.working_interest,100) / 100) pentane_metric_volume,
	pentane_imperial_volume * (isnull(wi.working_interest,100) / 100) pentane_imperial_volume,
	pentane_boe_volume * (isnull(wi.working_interest,100) / 100) pentane_boe_volume,
	pentane_mcfe_volume * (isnull(wi.working_interest,100) / 100) pentane_mcfe_volume,
	condensate_metric_volume * (isnull(wi.working_interest,100) / 100) condensate_metric_volume,
	condensate_imperial_volume * (isnull(wi.working_interest,100) / 100) condensate_imperial_volume,
	condensate_boe_volume * (isnull(wi.working_interest,100) / 100) condensate_boe_volume,
	condensate_mcfe_volume * (isnull(wi.working_interest,100) / 100) condensate_mcfe_volume,
	total_ngl_metric_volume * (isnull(wi.working_interest,100) / 100) total_ngl_metric_volume,
	total_ngl_imperial_volume * (isnull(wi.working_interest,100) / 100) total_ngl_imperial_volume,
	total_ngl_boe_volume * (isnull(wi.working_interest,100) / 100) total_ngl_boe_volume,
	total_ngl_mcfe_volume * (isnull(wi.working_interest,100) / 100) total_ngl_mcfe_volume,
	total_liquid_metric_volume * (isnull(wi.working_interest,100) / 100) total_liquid_metric_volume,
	total_liquid_imperial_volume * (isnull(wi.working_interest,100) / 100) total_liquid_imperial_volume,
	total_liquid_boe_volume * (isnull(wi.working_interest,100) / 100) total_liquid_boe_volume,
	total_liquid_mcfe_volume * (isnull(wi.working_interest,100) / 100) total_liquid_mcfe_volume,
	total_boe_volume * (isnull(wi.working_interest,100) / 100) total_boe_volume,
	water_metric_volume * (isnull(wi.working_interest,100) / 100) water_metric_volume,
	water_imperial_volume * (isnull(wi.working_interest,100) / 100) water_imperial_volume,
	water_boe_volume * (isnull(wi.working_interest,100) / 100) water_boe_volume,
	water_mcfe_volume * (isnull(wi.working_interest,100) / 100) water_mcfe_volume,
	hours_on,
	hours_down
from gross_downtime gd
JOIN (
	SELECT *
	FROM [data_mart].t_dim_entity 
	WHERE is_cc_dim=1
	AND	unit_cc_num IS NULL
) ent ON gd.cc_num = ent.cost_centre
JOIN [stage].[t_cc_num_working_interest] wi 
	ON gd.cc_num = wi.cc_num
	AND (gd.activity_date >= wi.effective_date 
	AND gd.activity_date < wi.termination_date);