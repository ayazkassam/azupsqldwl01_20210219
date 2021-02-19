CREATE VIEW [data_mart_metrix].[v_dim_revenue_entity] AS SELECT cost_centre, cost_centre_name
		, corp, corp_name, uwi
		, region, region_name, region_code
		, district, district_name, district_code
		, area, area_name, area_code
		, facility, facility_name, facility_code
		, cc_type, cc_type_code
		, spud_date, rig_release_date, on_production_date, create_date, cc_term_date
		, cgu, current_reserves_property, year_end_reserves_property, disposition_package
		, acquired_from
	FROM [data_mart].t_dim_entity 
	WHERE is_cc_dim='1'
	union all
	select '-1' cost_centre
		, 'Other Receipts' cost_centre_name
		, 'CORP HIER'	as corp
		, 'Bonavista Corporate Hierarchy' as corp_name
		, null as UWI
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
		, null  as acquired_from;