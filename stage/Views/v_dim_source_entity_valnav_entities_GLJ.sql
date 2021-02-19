CREATE VIEW [stage].[v_dim_source_entity_valnav_entities_GLJ] AS select glj.entity_guid
	, glj.uwi as entity_name
	, glj.cc_num as cost_centre
	, cc.cost_centre_name
	, cc.unit_cc_num, cc.unit_cc_name
	, cc.corp, cc.corp_name
	, cc.facility, cc.facility_name, cc.facility_code
	, cc.area, cc.area_name, cc.area_code
	, cc.district, cc.district_name, cc.district_code
	, cc.region, cc.region_name, cc.region_code
	, cc.province
	, cc.op_nonop
	, cc.cgu
	, cc.budget_group
	, cc.disposition_package
	, cc.disposition_type
	, cc.disposition_area
	, cc.disposition_facility
	, cc.disposed_flag
	, cc.acquired_from
	, cc.bottom_hole_latitude
	, cc.bottom_hole_longitude
	, cc.budget_quarter
	, cc.budget_year
	, cc.budget_year_group
	, cc.capital_group
	, cc.capital_type
	, cc.cc_num_working_interest_pct
	, cc.cc_term_date
	, cc.cc_type
	, cc.cc_type_code
	, cc.chance_of_success
	, cc.create_date
	, cc.crstatus_desc
	, cc.current_reserves_property
	, cc.de_risk
	, cc.depth_gci
	, cc.deviation_flag
	, cc.drill_days
	, cc.flownet_name
	, cc.focus_area_flag
	, cc.gas_shrinkage_factor
	, 0 as is_uwi
	, cc.last_production_date
	, cc.license_no
	, cc.meridian
	, cc.ngl_yield_factor
	, cc.nra
	, cc.on_production_date
	, cc.origin
	, cc.origin_group
	, cc.primary_product
	, cc.pvunit_completion_name
	, cc.pvunit_name
	, cc.pvunit_short_name
	, cc.range
	, cc.reserve_realized_date
	, cc.rig_release_date
	, cc.royalty_income_interest
	, cc.section
	, cc.spud_date
	, cc.strat_unit_id
	, cc.surf_location
	, cc.surface_latitude
	, cc.surface_longitude
	, cc.survey_system_code
	, cc.tax_pools
	, cc.total_depth
	, cc.township
	, cc.tvd_depth
	, cc.uwi_desc
	, cc.valnav_budget_quarter
	, cc.valnav_budget_year
	, cc.well_direction
	, cc.working_interest_pct
	, cc.zone_desc
	, cc.zone_play
	, glj.ReservesProperty as year_end_reserves_property
	, glj.formatted_uwi
	, glj.uwi
from (
	select en.OBJECT_ID as entity_guid
		, en.UNIQUE_ID as uwi
		, en.FORMATTED_ID as formatted_uwi
		, cc.cc_num
		, p.ReservesProperty 
		, e.EvaluatedProperties
	FROM stage_valnav.t_reserves_ENTITY  en
	left outer join (
			SELECT parent_id, name, string_value AS cc_num
			FROM [stage].[t_stg_valnav_reserves_ent_custom_field_def]
			WHERE UPPER (RTRIM(LTRIM (NAME))) = 'COST CENTER CODE'
	) cc on en.object_id = cc.parent_id
	left outer join (
			SELECT parent_id, name, string_value AS ReservesProperty
			FROM [stage].[t_stg_valnav_reserves_ent_custom_field_def]
			WHERE UPPER (RTRIM(LTRIM (NAME))) = 'BNP Property Name'
	) p on en.object_id = p.parent_id
	join (
			SELECT parent_id, name, string_value AS EvaluatedProperties
			FROM [stage].[t_stg_valnav_reserves_ent_custom_field_def]
			WHERE UPPER (RTRIM(LTRIM (NAME))) = 'text 1' and string_value in ('Total Properties') --('BNP Evaluated Properties','GLJ Evaluated Properties')
	) e on en.OBJECT_ID = e.parent_id 
) glj
	/*pull in existing corp hierarchy details base on cc_num*/
left outer join (
		select *
		from [data_mart].t_dim_entity
		where is_cc_dim = 1 
		and cost_centre is not null
) cc on glj.cc_num = cc.cost_centre;