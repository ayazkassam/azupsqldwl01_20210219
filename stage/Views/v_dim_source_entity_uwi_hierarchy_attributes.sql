CREATE VIEW [stage].[v_dim_source_entity_uwi_hierarchy_attributes]
AS SELECT ums.uwi,
	CAST(ihs.well_name AS VARCHAR(1000)) AS well_name,
	ums.cc_num cost_centre,
	cc.cost_centre_name,
	cc.corp,
	'Bonavista Corporate Hierarchy' corp_name,
	cc.region,
	cc.region_name,
	cc.region_code,
	cc.district,
	cc.district_name,
	cc.district_code,
	cc.area,
	cc.area_name,
	cc.area_code,
	cc.facility,
	cc.facility_name,
	cc.facility_code,
	cc.cc_type,
	cc.cc_type_code,
	cc.budget_group,
	cc.budget_year,
	cc.op_nonop,
	cc.origin,
	CASE WHEN ihs.province_state IS NULL THEN 'UNKNOWN PROVINCE' ELSE ihs.province_state END AS province,
	cc.create_date,
	cc.cc_term_date,
	CAST(try_convert(Date,ihs.spud_date) AS VARCHAR(50)) spud_date,
	CAST(try_convert(date,ihs.rig_release) AS VARCHAR(50)) rig_release_date,
	CAST(try_convert(date,os.on_prod_date) AS VARCHAR(50)) on_production_date,
	CAST(try_convert(Date,ihs.on_production_date) AS VARCHAR(50)) on_prod_date_accumap,
	CAST(try_convert(Date,ihs.last_production_date) AS VARCHAR(50)) last_production_date,
	cc.acquired_from,
	cc.current_reserves_property,
	cc.disposition_package,
	cc.disposition_type,
	cc.disposition_area,
	cc.disposition_facility,
	cc.disposed_flag,
	cc.focus_area_flag,
	CASE WHEN ihs.primary_product IS NULL OR UPPER (LTRIM(RTRIM (ihs.primary_product))) = 'NONE' 
		THEN 'UNKNOWN PRIMARY PRODUCT' ELSE ihs.primary_product END AS primary_product,
	cc.cgu,
	CAST(cc.working_interest_pct AS numeric(38,11)) working_interest_pct,
	cc.year_end_reserves_property,
	cc.unit_cc_num,
	cc.unit_cc_name,
	cc.survey_system_code,
	cc.meridian,
	cc.range,
	cc.township,
	cc.section,
	cc.tax_pools,
	CAST(CASE WHEN ihs.strat_unit_id IS NULL THEN 'UNKNOWN STRAT UNIT ID' ELSE ihs.strat_unit_id END AS VARCHAR(50)) AS strat_unit_id, 
	CAST(CASE WHEN ihs.crstatus_desc IS NULL THEN  'UNKNOWN CRSTATUS DESC' ELSE ihs.crstatus_desc END AS VARCHAR(100)) AS crstatus_desc,
	CAST(CASE WHEN ihs.license_no IS NULL THEN 'UNKNOWN LICENSE NO.' ELSE ihs.license_no END AS VARCHAR(50))  license_no, 
	CAST(CASE WHEN ihs.surf_location IS NULL THEN 'UNKNOWN SURF LOCATION' ELSE ihs.surf_location END AS VARCHAR(50)) AS surf_location,
	CAST(ihs.tvd_depth AS NUMERIC(10,2)) AS tvd_depth ,
	CAST(ihs.total_depth AS NUMERIC(10,2)) AS total_depth,
	CAST(CASE WHEN ihs.zone_desc IS NULL THEN 'UNKNOWN ZONE DESC' ELSE ihs.zone_desc END AS VARCHAR(100)) AS zone_desc,
	CAST(CASE WHEN ihs.deviation_flag IS NULL THEN 'UNKNOWN DEVIATION FLAG' ELSE ihs.deviation_flag END AS VARCHAR(100)) AS deviation_flag,
	CAST(CASE WHEN ihs.LOCATION IS NULL THEN 'UNKNOWN UWI' ELSE ihs.LOCATION END  AS VARCHAR(100)) AS formatted_uwi,
	CAST(CASE WHEN ihs.well_name IS NULL THEN 'Unknown Well Name' ELSE ihs.well_name END AS VARCHAR(100)) AS ihs_well_name,
	CAST(ihs.bottom_hole_latitude AS NUMERIC(12,7)) AS bottom_hole_latitude,
	CAST(ihs.bottom_hole_longitude AS NUMERIC(12,7)) AS bottom_hole_longitude,
	CAST(ihs.surface_latitude AS NUMERIC(12,7)) AS surface_latitude,
	CAST(ihs.surface_longitude AS NUMERIC(12,7)) AS surface_longitude ,
	CAST(pv.gas_shrinkage_factor AS NUMERIC(12,2)) AS gas_shrinkage_factor,
	CAST(pv.ngl_yield_factor AS NUMERIC(12,2)) AS ngl_yield_factor,
	CAST(ISNULL (pv.pvunit_completion_name,'UNKNOWN PRODVIEW COMPLETION NAME') AS VARCHAR(100)) AS pvunit_completion_name,
	CAST(ISNULL (pv.pvunit_name, 'UNKNOWN PRODVIEW UNIT NAME') AS VARCHAR(100)) AS pvunit_name,
	CAST(ISNULL (pv.pvunit_short_name, 'UNKNOWN PRODVIEW UNIT SHORT NAME') AS VARCHAR(100)) AS pvunit_short_name,
	CAST(ums.data_source AS VARCHAR(50)) AS entity_source,
	cc.budget_year_group,
	cc.origin_group,
	/* NOTE: Valnav attributes: look for live/current first then historic ones */
	COALESCE(vbc.zone_play, vby.zone_play) zone_play,
	pv.routename,
	pv.flownet_name,
	COALESCE(vbc.valnav_budget_year, vby.valnav_budget_year) valnav_budget_year ,
	COALESCE(vbc.valnav_budget_quarter, vby.valnav_budget_quarter) valnav_budget_quarter,
	pv.sales_disposition_point, 
	CAST(try_convert(Date,pv.engineering_inline_test_date) AS VARCHAR(50)) inline_test_date,
	os.Data_Source as on_prod_data_source,
	cc.qbyte_license,
	cc.surface_location,
	cc.Sask_Resource_Surcharge,
	COALESCE(vbc.meter_station, vby.meter_station) meter_station,
	COALESCE(vbc.de_risk, vby.de_risk) de_risk,
	ihs.current_licensee,
	ihs.original_licensee,
	ihs.operator,
	ihs.mode,
	pv.schematic_typical,
	vbc.plant,
	vbc.keyera_inlet
FROM [stage].[t_cc_uwi_master_source] ums
LEFT OUTER JOIN [stage].[t_ihs_attributes] ihs ON ums.uwi = ihs.uwi
LEFT OUTER JOIN [stage].[t_prodview_attributes] pv ON ums.uwi = pv.uwi
/*-- Inner Join to bring only those uwi that have legit cc nums*/
INNER JOIN [stage].[t_cost_centre_hierarchy] cc ON ums.cc_num = cc.cost_centre_id
LEFT OUTER JOIN [stage].v_stg_on_prod_dates os ON ums.uwi = os.uwi
--LEFT OUTER JOIN (
--		SELECT distinct entity_name uwi,
--			first_value(zone_play) over (partition by entity_name order by entity_name) zone_play
--		FROM [stage].[dbo].[t_valnav_dim_hierarchy_source]
--		WHERE zone_play is not null
--) zp ON ums.uwi = zp.uwi
----
--LEFT OUTER JOIN (
--		select distinct entity_name uwi,
--			first_value(valnav_budget_year) over (partition by entity_name order by entity_name) valnav_budget_year
--		from [stage].[dbo].[v_dim_source_entity_valnav_entities]
--		WHERE valnav_budget_year is not null
--) vby ON ums.uwi = vby.uwi
----
--LEFT OUTER JOIN (
--		SELECT distinct entity_name uwi,
--			first_value(budget_quarter) over (partition by entity_name order by entity_name) budget_quarter
--		FROM [stage].[dbo].[v_dim_source_entity_valnav_entities]
--		WHERE budget_quarter is not null
--) vqt ON ums.uwi = vqt.uwi

LEFT OUTER JOIN (
    -- current and historic attributes
	select distinct entity_name uwi,
		FIRST_VALUE(valnav_budget_year) OVER (PARTITION BY entity_name order by valnav_budget_year desc) valnav_budget_year,
		FIRST_VALUE(valnav_budget_quarter) OVER (PARTITION BY entity_name order by valnav_budget_year desc) valnav_budget_quarter,
		first_value(zone_play) over (partition by entity_name order by uwi) zone_play,
		first_value(Meter_Station) over (partition by entity_name order by Meter_Station desc) Meter_Station,
		first_value(de_risk) over (partition by entity_name order by Meter_Station desc) de_risk
	from [data_mart].t_dim_entity
	where is_valnav=1
	--and coalesce(valnav_budget_year, valnav_budget_quarter,zone_play) is not null 
) vby ON ums.uwi = vby.uwi

LEFT OUTER JOIN (
-- current attributes
	select distinct entity_name uwi,
		FIRST_VALUE(valnav_budget_year) OVER (PARTITION BY entity_name order by valnav_budget_year desc) valnav_budget_year,
		FIRST_VALUE(budget_quarter) OVER (PARTITION BY entity_name order by valnav_budget_year desc) valnav_budget_quarter,
		first_value(zone_play) over (partition by entity_name order by uwi) zone_play,
		first_value(Meter_Station) over (partition by entity_name order by Meter_Station desc) Meter_Station,
		first_value(de_risk) over (partition by entity_name order by Meter_Station desc) de_risk,
		first_value(plant) over (partition by entity_name order by plant desc) plant,
		first_value(keyera_inlet) over (partition by entity_name order by keyera_inlet desc) keyera_inlet
	from [Stage].[t_dim_source_entity_valnav_entities]
	--and coalesce(valnav_budget_year, valnav_budget_quarter,zone_play) is not null 
) vbc ON ums.uwi = vbc.uwi;