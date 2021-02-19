CREATE VIEW [dbo].[v_dim_uwi_corporate_hierarchy]
AS SELECT entity_key
		, cost_centre
		, CASE WHEN [cost_centre_name] is null THEN cost_centre else [cost_centre_name] END as [cost_centre_name]
		, CASE WHEN [corp_name] = 'CORP HIER' THEN 'Bonavista Corporate Hierarchy' else [corp_name] END as [corp_name]
		, [region]
		, [region_name]
		, [region_code]
		, [district]
		, [district_name]
		, [district_code]
		, [area]
		, [area_name]
		, [area_code]
		, [facility]
		, [facility_name]
		, [facility_code]
		, [cc_type]
		, [budget_group]
		, [budget_year_group]

		, [budget_year]
		, [op_nonop]
		, [origin]
		, [origin_group]
		, [province]
		, [create_date]
		, [spud_date]
		, [rig_release_date]
		, [on_production_date]
		, last_production_date
		, [acquired_from]
		, [current_reserves_property]
		, [disposition_package]
		, [disposition_type]
		, [disposition_area]
		, [disposition_facility]
		, [disposed_flag]
		, [focus_area_flag]
		, [primary_product]
		, [cgu]
		, [working_interest_pct]
		, [year_end_reserves_property]
		, [unit_cc_num]
		, [unit_cc_name]
		, [survey_system_code]
		, [meridian]
		, [range]
		, [township]
		, [section]
		, [tax_pools]
		, [cc_term_date]
		, [gas_shrinkage_factor]
		, [ngl_yield_factor]
		, [bottom_hole_latitude]
		, [bottom_hole_longitude]
		, [license_no]
		, [zone_play]
		, [surface_latitude]
		, [surface_longitude]
		, [tvd_depth]
		, [total_depth]
		, [surf_location]
		, [formatted_uwi]
		, entity_name
		, pvunit_short_name
		, [cc_type_code]
		, routename
		, flownet_name
		, valnav_budget_year
		, valnav_budget_quarter
		, sales_disposition_point
		, inline_test_date
		, on_prod_data_source
		, on_prod_date_accumap
		, Meter_Station
		, de_risk  
		,[current_licensee]
      ,[original_licensee]
      ,[operator]
      ,[mode]
	  ,[schematic_typical]
	  ,plant
	  ,keyera_inlet
	FROM [data_mart].[t_dim_entity]
	WHERE is_uwi=1 or is_cc_dim = 1

	UNION ALL

	/*-- UWI / Entities in Valnav Only but not in Volumes cube...need to be part of as data from Valnav have these UWIs*/
	SELECT vnav.entity_key,
		isnull(vnav.cost_centre,'-1') cost_centre,
		cc.cost_centre_name,
		CASE WHEN vnav.cost_centre IS NULL THEN '-1' ELSE 'Bonavista Corporate Hierarchy' END corp_name,
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
		cc.budget_group,
		cc.budget_year_group,
		cc.budget_year,
		cc.op_nonop,
		cc.origin,
		cc.origin_group,
		cc.province,
		cc.create_date,
		cc.spud_date,
		cc.rig_release_date,
		cc.on_production_date,
		cc.last_production_date,
		cc.acquired_from,
		cc.current_reserves_property,
		cc.disposition_package,
		cc.disposition_type,
		cc.disposition_area,
		cc.disposition_facility,
		cc.disposed_flag,
		cc.focus_area_flag,
		cc.primary_product,
		cc.cgu,
		cc.working_interest_pct,
		cc.year_end_reserves_property,
		cc.unit_cc_num,
		cc.unit_cc_name,
		cc.survey_system_code,
		cc.meridian,
		cc.range,
		cc.township,
		cc.section,
		cc.tax_pools,
		cc.cc_term_date,
		cc.gas_shrinkage_factor,
		cc.ngl_yield_factor,
		cc.bottom_hole_latitude,
		cc.bottom_hole_longitude,
		cc.license_no,
		cc.zone_play,
		cc.surface_latitude,
		cc.surface_longitude,
		cc.tvd_depth,
		cc.total_depth,
		cc.surf_location,
		cc.formatted_uwi,
		cc.entity_name,
		cc.pvunit_short_name,
		[cc_type_code] , 
		routename, 
		flownet_name, 
		vby.valnav_budget_year, 
		vqt.valnav_budget_quarter,
		sales_disposition_point
		, cc.inline_test_date
		, cc.on_prod_data_source
		, cc.on_prod_date_accumap
		, vqm.Meter_Station
		, vdr.de_risk
		  , null [current_licensee]
      , null [original_licensee]
      , null [operator]
      , null [mode]
	   , null [schematic_typical]
	  , plt.plant
	  , kyi.keyera_inlet
	from (
	SELECT DISTINCT uwi entity_key,
		FIRST_VALUE(cost_centre) OVER (PARTITION BY uwi ORDER BY cost_centre desc) cost_centre
	FROM [data_mart].t_dim_entity
	WHERE is_valnav=1
	AND LEN(entity_key) > 6
	AND uwi in (
				/*-- Find uwis in Valnav but not in FDC/Volumes cube Entity Dim*/
				SELECT DISTINCT uwi
				FROM (	SELECT DISTINCT entity_key uwi
						FROM [stage].t_fact_source_fdc_valnav_volumes
						UNION ALL
						SELECT DISTINCT entity_key uwi
						FROM [stage].t_fact_source_fdc_valnav_volumes_daily
						UNION ALL
						SELECT DISTINCT entity_key uwi
						FROM [stage].t_fact_source_fdc_valnav_glj_volumes
						EXCEPT
						SELECT distinct entity_key uwi
						FROM [data_mart].t_dim_entity
						WHERE is_uwi=1) s) 
	) vnav
	LEFT OUTER JOIN (
			SELECT  *
			FROM [data_mart].t_dim_entity
			WHERE is_cc_dim = 1
	) cc ON vnav.cost_centre = cc.cost_centre
	LEFT OUTER JOIN (
		select distinct entity_name uwi,
			first_value(valnav_budget_year) over (partition by entity_name order by entity_name) valnav_budget_year
		from [stage].[v_dim_source_entity_valnav_entities]
		WHERE valnav_budget_year is not null
	) vby ON vnav.entity_key = vby.uwi
	LEFT OUTER JOIN (
		SELECT distinct entity_name uwi,
			first_value(budget_quarter) over (partition by entity_name order by entity_name) valnav_budget_quarter
		FROM [stage].[v_dim_source_entity_valnav_entities]
		WHERE budget_quarter is not null
	) vqt ON vnav.entity_key = vqt.uwi
	LEFT OUTER JOIN (
		SELECT distinct entity_name uwi,
			first_value(Meter_Station) over (partition by entity_name order by entity_name) Meter_Station
		FROM [stage].[v_dim_source_entity_valnav_entities]
		WHERE Meter_Station is not null
	) vqm ON vnav.entity_key = vqm.uwi
	LEFT OUTER JOIN (
		SELECT distinct entity_name uwi,
			first_value(de_risk) over (partition by entity_name order by entity_name) de_risk
		FROM [stage].[v_dim_source_entity_valnav_entities]
		WHERE de_risk is not null
	) vdr ON vnav.entity_key = vdr.uwi

	LEFT OUTER JOIN (
		SELECT distinct entity_name uwi,
			first_value(plant) over (partition by entity_name order by entity_name) plant
		FROM [stage].[v_dim_source_entity_valnav_entities]
		WHERE plant is not null
	) plt ON vnav.entity_key = plt.uwi

	
	LEFT OUTER JOIN (
		SELECT distinct entity_name uwi,
			first_value(keyera_inlet) over (partition by entity_name order by entity_name) keyera_inlet
		FROM [stage].[v_dim_source_entity_valnav_entities]
		WHERE keyera_inlet is not null
	) kyi ON vnav.entity_key = kyi.uwi;