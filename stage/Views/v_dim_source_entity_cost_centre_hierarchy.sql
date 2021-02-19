﻿CREATE VIEW [stage].[v_dim_source_entity_cost_centre_hierarchy]
AS SELECT [corp]
      ,[corp_name]
      ,[region]
      ,[region_name]
      ,[district]
      ,[district_name]
      ,[area]
      ,[area_name]
      ,[facility]
      ,[facility_name]
      ,[cost_centre_id]
      ,stage.fn_Revised_Member_Text(stage.InitCap(cost_centre_name),'CC') cost_centre_name
      ,[unit_cc_num]
      ,[unit_cc_name]
      ,[working_interest_pct]
      ,[op_nonop]
      ,[budget_group]
      ,[budget_year]
      ,[origin]
      ,[acquired_from]
      ,[disposed_flag]
      ,[primary_product]
      ,[cc_type]
      ,[cc_type_code]
      ,[province]
      ,[create_date]
      ,[cc_term_date]
      ,[cgu]
      ,[current_reserves_property]
      ,[year_end_reserves_property]
      ,[focus_area_flag]
      ,[disposition_package]
      ,[disposition_type]
      ,[disposition_area]
      ,[disposition_facility]
      ,[spud_date]
      ,[rig_release_date]
      ,[on_production_date]
      ,[survey_system_code]
      ,[uwi]
      ,[uwi_desc]
      ,[meridian]
      ,[range]
      ,[township]
      ,[section]
      ,[tax_pools]
      ,[entity_source]
      ,[region_code]
      ,[district_code]
      ,[area_code]
      ,[facility_code]
      ,[budget_year_group]
      ,[origin_group]
      ,[zone_play]
	  ,gca_fcc
	  ,metrix_control_group,
	  valnav_budget_year,
	  valnav_budget_quarter,
	  last_production_date,
	  sales_disposition_point,
	  license_no,
	  on_prod_date_accumap, 
	  on_prod_data_source,
	  qbyte_license,
	  surface_location,
	  Sask_Resource_Surcharge,
	  meter_station,
	  group1,
	  group2,
	  group3,
	  group4,
	  group5,
	  group6,
	  group7,
	  group8,
	  group9,
	  group10,
	  plant,
	  keyera_inlet
FROM [stage].t_cost_centre_hierarchy cc;