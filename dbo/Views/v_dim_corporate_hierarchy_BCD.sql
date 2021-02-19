CREATE VIEW [dbo].[v_dim_corporate_hierarchy_BCD]
AS SELECT entity_key
	  ,[cost_centre_name]
      ,CASE WHEN [corp_name] = 'CORP HIER' THEN 'Bonavista Corporate Hierarchy' else [corp_name] END as [corp_name]
      ,[region]
      ,[region_name]
	   ,[region_code]
      ,[district]
      ,[district_name]
	  ,[district_code]
      ,[area]
      ,[area_name]
	   ,[area_code]
      ,[facility]
      ,[facility_name]
      ,[facility_code]
      ,[cc_type]
      ,[budget_group]
      ,[budget_year]
      ,[budget_year_group]
      ,[origin_group]
      ,[op_nonop]
      ,[origin]
      ,[province]
      ,[create_date]
      ,[spud_date]
      ,[rig_release_date]
      ,[on_production_date]
	  ,last_production_date
      ,[acquired_from]
      ,[current_reserves_property]
      ,[disposition_package]
      ,[disposition_type]
      ,[disposition_area]
      ,[disposition_facility]
      ,[disposed_flag]
      ,[focus_area_flag]
      ,[primary_product]
      ,[cgu]
      ,[working_interest_pct]
      ,[year_end_reserves_property]
      ,[unit_cc_num]
      ,[unit_cc_name]
      ,[survey_system_code]
      ,[meridian]
      ,[range]
      ,[township]
      ,[section]
	  ,[tax_pools]
	  ,[cc_term_date]
	  ,[gas_shrinkage_factor]
	  ,[ngl_yield_factor]
	   ,[bottom_hole_latitude]
      ,[bottom_hole_longitude]
	  ,[license_no]
	  ,[zone_play]
	   ,[surface_latitude]
      ,[surface_longitude]
	  ,[tvd_depth]
      ,[total_depth]
	   ,[surf_location]
	   ,[formatted_uwi],
	   [cc_type_code],
	   uwi,
	   gca_fcc,
	   metrix_control_group,
	   uwi_desc
	   , valnav_budget_year
	   , valnav_budget_quarter
	   , on_prod_data_source
	   , on_prod_date_accumap
	   , qbyte_license
	   , surface_location as qbyte_surface_location
	   , sask_resource_surcharge
	   	, coalesce(group1,'No') group01
		, coalesce(group2,'No') group02
		, coalesce(group3,'No') group03
		, coalesce(group4,'No') group04
		, coalesce(group5,'No') group05
		, coalesce(group6,'No') group06
		, coalesce(group7,'No') group07
		, coalesce(group8,'No') group08
		, coalesce(group9,'No') group09
		, coalesce(group10,'No') group10
		, Meter_Station
  FROM [data_mart].[t_dim_entity]
  WHERE is_cc_dim=1;