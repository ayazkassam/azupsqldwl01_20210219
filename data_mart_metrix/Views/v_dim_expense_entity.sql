CREATE VIEW [data_mart_metrix].[v_dim_expense_entity] AS select *
from (
	select Well_Tract_ID as entity_key
		, Well_Tract_Name as entity_name
		, Well_Tract_Type_Code as entity_type_code
		, Well_Tract_Type as entity_type_desc
		, Cost_Centre_Code
		, cost_centre_name
	from data_mart_metrix.t_dim_well
	where Cost_Centre_Code is not null

	union all

	select distinct u.Unit_ID
		, u.Unit_Name
		, 'U'
		, 'Unit'
		, u.Unit_Cost_Centre_Code
		, e.cost_centre_name
	from data_mart_metrix.t_dim_well u
	left outer join data_mart_metrix.t_dim_entity e on e.cost_centre = u.Unit_Cost_Centre_Code
	where u.Unit_Cost_Centre_Code is not null

	union all

	select distinct f.facility_id
		, f.facility_name
		, f.facility_type_code
		, f.facility_type_desc
		, f.facility_cost_centre_code
		, e.cost_centre_name
	from data_mart_metrix.t_dim_facility f
	left outer join data_mart_metrix.t_dim_entity e on e.cost_centre = f.facility_cost_centre_code
	where f.facility_cost_centre_code is not null
) f
left outer join (
		SELECT cost_centre
			, corp, corp_name, uwi, formatted_uwi
			, region, region_name, region_code
			, district, district_name, district_code
			, area, area_name, area_code
			, facility, facility_name, facility_code
			, cc_type, cc_type_code
			, spud_date, rig_release_date, on_production_date, create_date, cc_term_date
			, cgu, current_reserves_property, year_end_reserves_property, disposition_package
			, acquired_from
		FROM data_mart.t_dim_entity 
		WHERE is_cc_dim='1'
) e ON f.cost_centre_code = e.cost_centre



	union all

	select '-1' entity_key
		, 'Other Receipts' entity_name
		, null as entity_type_code
		, null as entity_type_desc
		, null as Cost_Centre_Code
		, null as cost_centre_name
		, '-1' cost_centre
		, 'CORP HIER'	as corp
		, 'Bonavista Corporate Hierarchy' as corp_name
		, null as UWI, null as formatted_uwi
		, 'Unknown'	as region
		, 'Unknown Region'	as region_name
		, 'Unknown'	as region_code
		, 'Unknown'	as district
		, 'Unknown District'	as district_name
		, 'Unknown'	as district_code
		, 'Unknown'	as area
		, 'Unknown Area'	as area_name
		, 'Unknown'	as area_code
		, 'Unknown'	as facility
		, 'Unknown Facility'	as facility_name
		, 'Unknown'	as facility_code
		, null	as cc_type
		, null	as cc_type_code
		, null  as spud_date
		, null  as rig_release_date
		, null  as on_production_date
		, null  as create_date
		, null  as cc_term_date
		, null  as cgu
		, null  as current_reserves_property
		, null  as year_end_reserves_property
		, null	as [disposition_package]
		, null	as acquired_from;