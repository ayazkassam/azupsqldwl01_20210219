CREATE VIEW [stage].[v_fact_source_fdc_ihs_incr]
AS with ihs_source
as
(
SELECT iv.uwi site_id,
	   uwi,
	   dttm activity_date,
	   CAST(CAST(YEAR(dttm) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(dttm) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(dttm) AS VARCHAR),2) AS INT) activity_date_key,
	   cc_num,
	   'Accumap' scenario_key,
	   gas gas_metric_volume,
	   gas * isnull(cf.gas_si_to_imp_conv_factor,1) gas_imperial_volume,
	   gas * isnull(cf.gas_boe_thermal,1) gas_boe_volume,
	   gas * isnull(cf.gas_si_to_imp_conv_factor,1) * isnull(cf.gas_mcfe6_thermal,1) gas_mcfe_volume,
	   --
	   oil oil_metric_volume,
	   oil * isnull(cf.liquid_si_to_imp_conv_factor,1) oil_imperial_volume,
	   oil * isnull(cf.liquid_boe_thermal,1) oil_boe_volume,
	   oil * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6) oil_mcfe_volume,
	   --
	   cond condensate_metric_volume,
	   cond * isnull(cf.liquid_si_to_imp_conv_factor,1) condensate_imperial_volume,
	   cond * isnull(cf.liquid_boe_thermal,1) condensate_boe_volume,
	   cond * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6) condensate_mcfe_volume,
	   --
	   water water_metric_volume,
	   water * isnull(cf.liquid_si_to_imp_conv_factor,1) water_imperial_volume,
	   water * isnull(cf.liquid_boe_thermal,1) water_boe_volume,
	   water * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6) water_mcfe_volume,
	   --
	   (isnull(cond,0) * isnull(cf.liquid_boe_thermal,1))
	   + (isnull(oil,0) * isnull(cf.liquid_boe_thermal,1))
	   + (isnull(gas,0) * isnull(cf.gas_boe_thermal,1)) total_boe_volume,
	   ppm.hours hours_on
FROM   [stage].t_ctrl_qbyte_conversion_factors cf,
      (SELECT iv.*, eomonth(convert(date, concat(month,' ',year))) as dttm
      FROM stage.t_stg_ihs_volumes_incr iv) iv
      

	   left outer join

   (SELECT pden_id,
	       hours,
	       eomonth(prod_date) prod_date2
     FROM [stage].[t_ihs_pden_production_month] 
	 )ppm

    on iv.uwi = ppm.pden_id
    and iv.dttm = ppm.prod_date2
),
ihs_gross_facts
as
(
SELECT site_id,
	   uwi,
	   cc_num,
	   activity_date,
	   activity_date_key,
	   'IHS' data_type,
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
	   condensate_metric_volume,
	   condensate_imperial_volume,
	   condensate_boe_volume,
	   condensate_mcfe_volume,
	   condensate_metric_volume total_ngl_metric_volume,
	   condensate_imperial_volume total_ngl_imperial_volume,
	   condensate_boe_volume total_ngl_boe_volume,
	   condensate_mcfe_volume total_ngl_mcfe_volume,
	   isnull(oil_metric_volume,0) + isnull(condensate_metric_volume,0)  total_liquid_metric_volume,
	   isnull(oil_imperial_volume,0) + isnull(condensate_imperial_volume,0)  total_liquid_imperial_volume,
	   isnull(oil_boe_volume,0) + isnull(condensate_boe_volume,0) total_liquid_boe_volume,
	   isnull(oil_mcfe_volume,0) + isnull(condensate_mcfe_volume,0)  total_liquid_mcfe_volume,
	    --
	   total_boe_volume,
	   --
	   water_metric_volume,
	   water_imperial_volume,
	   water_boe_volume,
	   water_mcfe_volume,
	   hours_on
FROM ihs_source	
) 
-- Final Query
-- GROSS
SELECT site_id,
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
	   hours_on
FROM ihs_gross_facts
--
UNION ALL
--
--NET
SELECT site_id,
	   uwi,
	   ihs.cc_num,
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
	   hours_on
FROM ihs_gross_facts ihs
     JOIN [stage].[t_cc_num_working_interest] wi
     ON     ihs.cc_num = wi.cc_num
   AND (ihs.activity_date >= wi.effective_date AND ihs.activity_date < wi.termination_date);