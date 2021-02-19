CREATE VIEW [data_mart_metrix].[v_dim_well]
AS select Well_Tract_Sys_ID
	, Well_Tract_ID
	, Well_Tract_Type_Code
	, Well_Tract_Type
	, Well_Tract_Province
	, Well_Tract_Name
	, Cost_Centre_Code
	, Unique_Identifier
	, UWI
	, Formatted_UWI
	, Production_Status
	, Primary_Product
	, Well_Facility_id
	, Well_PA_Responsible_User_ID
	, Well_PA_Responsible_User
	, cost_centre_name
	, isnull(corp,'CORP HIER') corp
	, isnull(corp_name,'Bonavista Corporate Hierarchy') corp_name
	, isnull(region			, 'Unknown'			) as region	
	, isnull(region_name	, 'Unknown Region'	) as region_name	
	, isnull(region_code	, 'Unknown'			) as region_code	
	, isnull(district		, 'Unknown'			) as district	
	, isnull(district_name	, 'Unknown District') as district_name	
	, isnull(district_code	, 'Unknown'			) as district_code	
	, isnull(area			, 'Unknown'			) as area	
	, isnull(area_name		, 'Unknown Area'	) as area_name	
	, isnull(area_code		, 'Unknown'			) as area_code	
	, isnull(facility		, 'Unknown'			) as facility	
	, isnull(facility_name	, 'Unknown Facility') as facility_name	
	, isnull(facility_code	, 'Unknown'			) as facility_code	
	, cc_type
	, cc_type_code
	, Report_Liquid_as_Condensate
	, Unit_ID
	, Unit_Name
	, Unit_Province
	, Unit_Govt_Code
	, Unit_Cost_Centre_Code
	, spud_date
	, rig_release_date
	, on_production_date
	, create_date
	, cc_term_date
	, cgu
	, current_reserves_property
	, year_end_reserves_property
	, [disposition_package]
	, [Royalty_Entity_ID]
	, [Oil_Royalty_Entity_ID]
	, [Reserve_Code]
	, crown_royalty_percent
	, freehold_royalty_percent
	, federal_percent
	, acquired_from
from [data_mart_metrix].[t_dim_well]
union all
select -1
	, 'Other Receipts' as Well_Tract_ID
 	, 'D' as Well_Tract_Type_Code
	, 'Default Source' as Well_Tract_Type
	, null as Well_Tract_Province
	, 'Other Receipts' Well_Tract_Name
	, null	as Cost_Centre_Code
	, null	as Unique_Identifier
	, null	as UWI
	, null	as Formatted_UWI
	, null	as Production_Status
	, null	as Primary_Product
	, null	as Well_Facility_id
	, null	as Well_PA_Responsible_User_ID
	, null	as Well_PA_Responsible_User
	, null	as cost_centre_name
	, 'CORP HIER'	as corp
	, 'Bonavista Corporate Hierarchy' as corp_name
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
	, null  as Report_Liquid_as_Condensate
	, null  as Unit_ID
	, null  as Unit_Name
	, null  as Unit_Province
	, null  as Unit_Govt_Code
	, null  as Unit_Cost_Centre_Code
	, null  as spud_date
	, null  as rig_release_date
	, null  as on_production_date
	, null  as create_date
	, null  as cc_term_date
	, null  as cgu
	, null  as current_reserves_property
	, null  as year_end_reserves_property
	, null	as [disposition_package]
	, null	as [Royalty_Entity_ID]
	, null	as [Oil_Royalty_Entity_ID]
	, null	as [Reserve_Code]
	, null	as crown_royalty_percent
	, null	as freehold_royalty_percent
	, null	as federal_percent
	, null as acquired_from;