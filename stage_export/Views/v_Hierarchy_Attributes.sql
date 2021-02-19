CREATE VIEW [stage_export].[v_Hierarchy_Attributes]
AS with cte_cats as (
	SELECT CAST (SUBSTRING (da.entity_key, 1, 14) AS VARCHAR (14)) wellbore,	  
		   cast (da.cost_centre_name as varchar(100)) as costcentrename,
		   CAST (da.entity_key AS VARCHAR (50)) uwi,
 		   CAST (da.cost_centre AS VARCHAR (100)) AS cost_center,
		   da.region_name,
		   da.district_name,
		   da.area_name,
		   da.facility_name,
		   da.cc_type,
		   da.budget_group,
		   da.budget_year,
		   da.op_nonop,
		   da.origin,
		   da.province,
		   da.create_date,
		   da.spud_date,
		   da.rig_release_date,
		   da.on_production_date,
		   da.acquired_from,
		   da.current_reserves_property,
		   da.disposition_package,
		   da.disposition_type,
		   da.disposition_area,
		   da.disposition_facility,
		   da.disposed_flag,
		   da.focus_area_flag,
		   da.primary_product,
		   da.cgu,
		   da.working_interest_pct,
		   da.year_end_reserves_property,
		   da.unit_cc_num,
		   da.unit_cc_name,
		   da.survey_system_code,
		   da.uwi_desc,
		   da.crstatus_desc,
		   da.license_no,
		   da.surf_location,
		   da.tvd_depth,
		   da.total_depth,
		   da.deviation_flag,
		   da.[formatted_uwi]
      ,da.[bottom_hole_latitude]
      ,da.[bottom_hole_longitude]
      ,da.[surface_latitude]
      ,da.[surface_longitude]
      ,da.[gas_shrinkage_factor]
      ,da.[ngl_yield_factor]
      ,da.[pvunit_completion_name]
      ,da.[pvunit_name]
      ,da.[pvunit_short_name]
      ,da.[entity_source]
      ,da.[is_cc_dim]
      ,da.[cc_term_date]
      ,da.[chance_of_success]
      ,da.[budget_quarter]
      ,da.[capital_group]
      ,da.[capital_type]
      ,da.[de_risk]
      ,da.[depth_gci]
      ,da.[drill_days]
      ,da.[nra]
      ,da.[reserve_realized_date]
      ,da.[royalty_income_interest]
      ,da.[well_direction]
      ,da.[zone_play]
      ,da.[is_valnav]
      ,da.[is_uwi]
      ,da.[region_code]
      ,da.[district_code]
      ,da.[area_code]
      ,da.[facility_code]
      ,da.[budget_year_group]
      ,da.[origin_group]
      ,da.[cc_type_code]
      ,da.[valnav_budget_year]
      ,da.[cc_num_working_interest_pct]
      ,da.[routename]
      ,da.[flownet_name]
      ,da.[lateral_length]
      ,da.[segment_start_date]
      ,da.[valnav_budget_quarter]
      ,da.[gca_fcc]
      ,da.[metrix_control_group]
      ,da.[sales_disposition_point]
      ,da.[last_production_date]
      ,da.[completion_type]
      ,da.[total_proppant_placed]
      ,da.[c_star]
      ,da.[production_category]
      ,da.[incentive_type]
      ,da.[Meter_Station]
      ,da.[on_prod_date_accumap]
      ,da.[on_prod_data_source]
      ,da.[inline_test_date]
      ,da.[type_curve_kpi]
      ,da.[royalty_type]
      ,da.[first_prod_month]
      ,da.[qbyte_license]
      ,da.[surface_location]
      ,da.[Sask_Resource_Surcharge]

	FROM (
			SELECT * --DISTINCT entity_key uwi
			  FROM [data_mart].t_dim_entity
			  WHERE is_uwi=1
			  AND entity_key > '0'
			  AND SUBSTRING(entity_key,1,1) <> 'W'
	) da
	INNER JOIN [stage].t_ihs_well_description wd
	   ON da.entity_key = wd.uwi
	INNER JOIN [stage].t_ihs_well iw2
	   ON da.entity_key = iw2.uwi
	LEFT OUTER JOIN [stage].t_ihs_pden pd
	   ON da.uwi = pd.pden_id
	LEFT OUTER JOIN [stage].t_ihs_r_well_profile_type wp
	   ON iw2.profile_type = wp.well_profile_type
)

SELECT     DISTINCT  wellbore,
	       costcentrename,
	       uwi,
 	       cost_center,
	       region_name,
		   district_name,
		   area_name,
		   facility_name,
		   cc_type,
		   budget_group,
		   budget_year,
		   op_nonop,
		   origin,
		   province,
		   create_date,
		   spud_date,
		   rig_release_date,
		   on_production_date,
		   acquired_from,
		   current_reserves_property,
		   disposition_package,
		   disposition_type,
		   disposition_area,
		   disposition_facility,
		   disposed_flag,
		   focus_area_flag,
		   primary_product,
		   cgu,
		   working_interest_pct,
		   year_end_reserves_property,
		   unit_cc_num,
		   unit_cc_name,
		   survey_system_code,
		   uwi_desc,
		   crstatus_desc,
		   license_no,
		   surf_location,
		   tvd_depth,
		   total_depth,
		   deviation_flag,
		   [formatted_uwi]
      ,[bottom_hole_latitude]
      ,[bottom_hole_longitude]
      ,[surface_latitude]
      ,[surface_longitude]
      ,[gas_shrinkage_factor]
      ,[ngl_yield_factor]
      ,[pvunit_completion_name]
      ,[pvunit_name]
      ,[pvunit_short_name]
      ,[entity_source]
      ,[is_cc_dim]
      ,[cc_term_date]
      ,[chance_of_success]
      ,[budget_quarter]
      ,[capital_group]
      ,[capital_type]
      ,[de_risk]
      ,[depth_gci]
      ,[drill_days]
      ,[nra]
      ,[reserve_realized_date]
      ,[royalty_income_interest]
      ,[well_direction]
      ,[zone_play]
      ,[is_valnav]
      ,[is_uwi]
      ,[region_code]
      ,[district_code]
      ,[area_code]
      ,[facility_code]
      ,[budget_year_group]
      ,[origin_group]
      ,[cc_type_code]
      ,[valnav_budget_year]
      ,[cc_num_working_interest_pct]
      ,[routename]
      ,[flownet_name]
      ,[lateral_length]
      ,[segment_start_date]
      ,[valnav_budget_quarter]
      ,[gca_fcc]
      ,[metrix_control_group]
      ,[sales_disposition_point]
      ,[last_production_date]
      ,[completion_type]
      ,[total_proppant_placed]
      ,[c_star]
      ,[production_category]
      ,[incentive_type]
      ,[Meter_Station]
      ,[on_prod_date_accumap]
      ,[on_prod_data_source]
      ,[inline_test_date]
      ,[type_curve_kpi]
      ,[royalty_type]
      ,[first_prod_month]
      ,[qbyte_license]
      ,[surface_location]
      ,[Sask_Resource_Surcharge]
	  ,row_number() OVER(ORDER BY wellbore) row_id
FROM

(
select * from cte_cats
where uwi <> cost_center

UNION

SELECT *
FROM
(
select distinct cast(substring(uwi, 1, 14) as varchar(14)) wellbore
	  , cast(cost_centre_name as varchar(100)) as costcentrename
	  , cast(entity_key as varchar(50)) uwi
 	  , cast(cost_centre as varchar(100)) as cost_center
	  ,region_name,
		   district_name,
		   area_name,
		   facility_name,
		   cc_type,
		   budget_group,
		   budget_year,
		   op_nonop,
		   origin,
		   province,
		   create_date,
		   spud_date,
		   rig_release_date,
		   on_production_date,
		   acquired_from,
		   current_reserves_property,
		   disposition_package,
		   disposition_type,
		   disposition_area,
		   disposition_facility,
		   disposed_flag,
		   focus_area_flag,
		   primary_product,
		   cgu,
		   working_interest_pct,
		   year_end_reserves_property,
		   unit_cc_num,
		   unit_cc_name,
		   survey_system_code,
		   uwi_desc,
		   crstatus_desc,
		   license_no,
		   surf_location,
		   tvd_depth,
		   total_depth,
		   deviation_flag,
		   [formatted_uwi]
      ,[bottom_hole_latitude]
      ,[bottom_hole_longitude]
      ,[surface_latitude]
      ,[surface_longitude]
      ,[gas_shrinkage_factor]
      ,[ngl_yield_factor]
      ,[pvunit_completion_name]
      ,[pvunit_name]
      ,[pvunit_short_name]
      ,[entity_source]
      ,[is_cc_dim]
      ,[cc_term_date]
      ,[chance_of_success]
      ,[budget_quarter]
      ,[capital_group]
      ,[capital_type]
      ,[de_risk]
      ,[depth_gci]
      ,[drill_days]
      ,[nra]
      ,[reserve_realized_date]
      ,[royalty_income_interest]
      ,[well_direction]
      ,[zone_play]
      ,[is_valnav]
      ,[is_uwi]
      ,[region_code]
      ,[district_code]
      ,[area_code]
      ,[facility_code]
      ,[budget_year_group]
      ,[origin_group]
      ,[cc_type_code]
      ,[valnav_budget_year]
      ,[cc_num_working_interest_pct]
      ,[routename]
      ,[flownet_name]
      ,[lateral_length]
      ,[segment_start_date]
      ,[valnav_budget_quarter]
      ,[gca_fcc]
      ,[metrix_control_group]
      ,[sales_disposition_point]
      ,[last_production_date]
      ,[completion_type]
      ,[total_proppant_placed]
      ,[c_star]
      ,[production_category]
      ,[incentive_type]
      ,[Meter_Station]
      ,[on_prod_date_accumap]
      ,[on_prod_data_source]
      ,[inline_test_date]
      ,[type_curve_kpi]
      ,[royalty_type]
      ,[first_prod_month]
      ,[qbyte_license]
      ,[surface_location]
      ,[Sask_Resource_Surcharge]
from data_mart.t_dim_entity
where is_cc_dim=1
and entity_key not in (select distinct cost_center from cte_cats)
and entity_key not in ('-1','-2')
 ) S2
 where uwi <> cost_center

) S;