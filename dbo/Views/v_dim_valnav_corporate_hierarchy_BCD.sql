CREATE VIEW [dbo].[v_dim_valnav_corporate_hierarchy_BCD]
AS SELECT e.entity_key
		, e.entity_name
		, formatted_uwi
		, isnull(cost_centre, 'Unknown Cost Centre') cost_centre
		, isnull(e.cost_centre_name, 'Unknown Cost Centre') cost_centre_name 
		, e.unit_cc_num
		, e.unit_cc_name
		, isnull(e.facility, 'Unknown Facility') facility
		, isnull(e.facility_name, 'Unknown Facility') facility_name
		, e.facility_code
		, isnull(e.area, 'Unknown Area') area
		, isnull(e.area_name, 'Unknown Area') area_name
		, e.area_code
		, isnull(e.district, 'Unknown District') district
		, isnull(e.district_name, 'Unknown District') district_name
		, e.district_code
		, isnull(region, 'Unknown Region') region
		, isnull(e.region_name, 'Unknown Region') region_name
		, e.region_code
		, isnull(e.corp, 'CORP HIER') corp
		, isnull(e.corp_name,'Bonavista Corporate Hierarchy') corp_name
		, e.province
		, zone_play
		, well_direction
		, e.op_nonop
		, capital_type
		, CAST (e.budget_year AS VARCHAR(10)) budget_year
		, valnav_budget_year
		, budget_quarter
		, de_risk
		, nra
		, reserve_realized_date
		,  e.[spud_date]
		, e.[rig_release_date]
		, drill_days
		, capital_group
		, depth_gci
		, chance_of_success
		, e.working_interest_pct
		, royalty_income_interest
		, CASE WHEN bd_flag.entity_key IS NULL THEN 'N' ELSE 'Y' END base_decline_flag
		, e.primary_product
		, e.on_production_date
		, e.last_production_date
		, e.year_end_reserves_property
		, e.current_reserves_property
		, e.cgu
		, e.budget_group
		, e.cc_type
		, e.cc_type_code
		, e.budget_year_group
		, e.focus_area_flag
		, e.origin
		, e.origin_group
		, e.tax_pools
		, e.acquired_from
		, e.disposed_flag
		, e.disposition_area
		, e.disposition_facility
		, e.disposition_package
		, e.disposition_type
		, e.cc_num_working_interest_pct
		, e.lateral_length
		, e.segment_start_date
		, e.[survey_system_code]
		, e.[meridian]
		, e.[range]
		, e.[township]
		, e.section
		, e.completion_type
		, e.total_proppant_placed
		, e.c_star
		, e.production_category
		, e.incentive_type
		, e.Meter_Station
		, e.type_curve_kpi
		, e.royalty_type
		, replace(e.first_prod_month,' 00:00:00','') first_prod_month
		, coalesce(e.group1,'No') group01
		, coalesce(e.group2,'No') group02
		, coalesce(e.group3,'No') group03
		, coalesce(e.group4,'No') group04
		, coalesce(e.group5,'No') group05
		, coalesce(e.group6,'No') group06
		, coalesce(e.group7,'No') group07
		, coalesce(e.group8,'No') group08
		, coalesce(e.group9,'No') group09
		, coalesce(e.group10,'No') group10
	 FROM [data_mart].t_dim_entity e
	 LEFT OUTER JOIN (  
 			SELECT entity_key
				, COUNT (activity_date_key) cnt_date_key
			FROM (
				SELECT DISTINCT entity_key
					, vp.activity_date_key
				FROM [data_mart].t_fact_valnav_production vp
				, (
					SELECT cast(budget_year +'0101' as int) bud_year1_jan
						, cast(cast((budget_year + 1) as varchar(4)) + '0101' as int) bud_year2_jan
					FROM (
						SELECT isnull (variable_value, year(CURRENT_TIMESTAMP)) budget_year
						FROM [stage].t_ctrl_valnav_etl_variables
						WHERE variable_name = 'CURRENT_BUDGET_YEAR_BD_FLAG'
					) ct
				) c
				WHERE vp.gross_net_key = 'GRS'
				AND vp.scenario_type = 'BASE_DECLINE'
				AND (vp.activity_date_key = c.bud_year1_jan OR vp.activity_date_key = c.bud_year2_jan)
				AND isnull(boe_volume, 0) <> 0
			) sd
			GROUP BY entity_key
			HAVING COUNT(activity_date_key) = 2
	) bd_flag ON e.entity_key = bd_flag.entity_key
	WHERE e.is_valnav=1;