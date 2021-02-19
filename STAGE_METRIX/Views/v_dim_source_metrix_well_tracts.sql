CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_well_tracts] AS select wt.SYS_ID as Well_Tract_Sys_ID
	, wt.ENTITY_ID as Well_Tract_ID
 	, wt.ENTITY_TYPE_CODE as Well_Tract_Type_Code
	, case wt.ENTITY_TYPE_CODE when 'W' then 'Well' when 'T' then 'Tract' else 'Unknown' end as Well_Tract_Type
	, coalesce(w.PROVINCE,t.Province) as Well_Tract_Province
	, coalesce(m.Well_Tract_Name, wt.ENTITY_ID) Well_Tract_Name
	, m.Cost_Centre_Code
	, m.Unique_Identifier
	, m.UWI
	, m.Formatted_UWI
	, m.Production_Status
	, m.Primary_Product
	, m.Well_Facility_id
	, m.Well_PA_Responsible_User_ID
	, isnull(u.User_Name,'Unknown') as Well_PA_Responsible_User
	, e.cost_centre_name
	, e.corp
	, e.corp_name
	, e.region
	, e.region_name
	, e.region_code
	, e.district
	, e.district_name
	, e.district_code
	, e.area
	, e.area_name
	, e.area_code
	, e.facility
	, e.facility_name
	, e.facility_code
	, e.cc_type
	, e.cc_type_code
	, m.Report_Liquid_as_Condensate
	, ut.Unit_ID
	, ut.Unit_Name
	, ut.Unit_Province
	, ut.Unit_Govt_Code
	, ut.Unit_Cost_Centre_Code
	, e.spud_date
	, e.rig_release_date
	, e.on_production_date
	, e.create_date
	, e.cc_term_date
	, e.cgu
	, e.current_reserves_property
	, e.year_end_reserves_property
	, e.disposition_package
	, re.ROYALTY_ENTITY_ID as Royalty_Entity_ID
	, ro.ROYALTY_ENTITY_ID as Oil_Royalty_Entity_ID
	, ri.indian_reserve_id + ' - ' + ri.indian_reserve_name as Reserve_Code
	, m.crown_royalty_percent
	, m.freehold_royalty_percent
	, m.federal_percent
	, e.acquired_from
from [STAGE_METRIX_METRIX].[WELL_TRACTS] wt
left outer join [STAGE_METRIX_METRIX].[WELLS] w on wt.SYS_ID = w.WELL_TRACT_SYS_ID
left outer join [STAGE_METRIX_METRIX].[TRACTS] t on wt.SYS_ID = t.WELL_TRACT_SYS_ID
left outer join (
	/*first vaule used to determine the current well_tract based on the most recent production date */
	select distinct wm.WELL_ID as Well_Tract_ID
		, first_value(wm.COST_CENTRE_CODE) over (partition by wm.WELL_ID order by wm.production_date desc) as Cost_Centre_Code
		, first_value(wm.NAME) over (partition by wm.WELL_ID order by wm.production_date desc)  as Well_Tract_Name
		, first_value(wm.UNIQUE_WELL_IDENTIFIER) over (partition by wm.WELL_ID order by wm.production_date desc) as Unique_Identifier
		, replace(replace(first_value(wm.REPORTING_WELL_IDENTIFIER) over (partition by wm.WELL_ID order by wm.production_date desc),'/',''),'-','') as uwi
		, first_value(wm.REPORTING_WELL_IDENTIFIER) over (partition by wm.WELL_ID order by wm.production_date desc) formatted_uwi
		, first_value(wm.PRODUCTION_STATUS ) over (partition by wm.WELL_ID order by wm.production_date desc) as Production_Status
		, first_value(wm.FLUID_TYPE) over (partition by wm.WELL_ID order by wm.production_date desc) as Primary_Product
		--, max(wm.BATTERY_FACILITY_ID) over (partition by wm.WELL_ID order by wm.BATTERY_FACILITY_ID desc) as Well_Facility_id
		, first_value(wm.BATTERY_FACILITY_ID) over (partition by wm.WELL_ID order by wm.production_date desc) as Well_Facility_id
		, first_value(PA_RESPONSIBLE_USER_ID) over (partition by wm.WELL_ID order by wm.production_date desc) as Well_PA_Responsible_User_ID
		, first_value(REPORT_LIQUID_AS_CONDENSATE) over (partition by wm.WELL_ID order by wm.production_date desc) as Report_Liquid_as_Condensate
		, max(royalty_entity_sys_id) over (partition by wm.WELL_ID order by wm.royalty_entity_sys_id desc, royalty_entity_sys_id desc) royalty_entity_sys_id
		, max(oil_royalty_entity_sys_id) over (partition by wm.WELL_ID order by wm.oil_royalty_entity_sys_id desc) oil_royalty_entity_sys_id
		, wf.crown_royalty_percent
		, wf.freehold_royalty_percent
		, wf.federal_percent
	from [STAGE_METRIX_METRIX].[WELL_MASTERS] wm
	left outer join (
			select distinct WELL_ID
				, first_value(crown_royalty_percent) over (partition by well_id order by production_date desc) as crown_royalty_percent
				, first_value(freehold_royalty_percent) over (partition by well_id order by production_date desc) as freehold_royalty_percent
				, first_value(federal_percent) over (partition by well_id order by production_date desc) as federal_percent
			from [STAGE_METRIX_METRIX].WELL_FACTORS
	) wf on wm.WELL_ID = wf.WELL_ID
	union all 
	select distinct tm.TRACT_ID as Well_Tract_ID
		, first_value(tm.COST_CENTRE_CODE) over (partition by tm.TRACT_ID order by tm.production_date desc) as Cost_Centre_code
		, first_value(tm.NAME) over (partition by tm.TRACT_ID order by tm.production_date desc) as Well_Tract_Name
		, first_value(tm.LEGAL_PRESENTATION) over (partition by tm.TRACT_ID order by tm.production_date desc) as Unique_Identifier
		, null as uwi
		, null as formatted_uwi
		, null as PRODUCTION_STATUS 
		, null as Primary_Product
		, null as Well_Facility_id
		, null as Well_PA_Responsible_User_ID
		, null as Report_Liquid_as_Condensate
		, null as royalty_entity_sys_id
		, null as oil_royalty_entity_sys_id
		, null as crown_royalty_percent
		, null as freehold_royalty_percent
		, null as federal_percent
	from [STAGE_METRIX_METRIX].[TRACT_MASTERS] tm
) m on m.Well_Tract_ID = wt.ENTITY_ID
left outer join (
		select Unit_ID, Unit_Name, Unit_Province, Unit_Govt_Code, Unit_Cost_Centre_Code, Well_ID as well_tract_id
		from [STAGE_METRIX].[v_metrix_unit_wells]
		union all
		select Unit_ID, Unit_Name, Unit_Province, Unit_Govt_Code, Unit_Cost_Centre_Code, TRACT_ID as well_tract_id
		from [STAGE_METRIX].[v_metrix_unit_tracts]
) ut on wt.ENTITY_ID = ut.well_tract_id
left outer join [STAGE_METRIX_METRIX].USER_ACCOUNTS u on u.USER_ID = m.Well_PA_Responsible_User_ID
--
LEFT OUTER JOIN (
		SELECT cost_centre, cost_centre_name
			, corp, corp_name
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
) e ON m.Cost_Centre_Code = e.cost_centre
left outer join [STAGE_METRIX_METRIX].[INDIAN_ROYALTY_ENTITIES] re on m.royalty_entity_sys_id = re.SYS_ID
left outer join [STAGE_METRIX_METRIX].[INDIAN_ROYALTY_ENTITIES] ro on m.oil_royalty_entity_sys_id = ro.SYS_ID
left outer join (
		select distinct ir.ID as indian_reserve_id
			, name as indian_reserve_name
			, WELL_TRACT_SYS_ID as WELL_TRACT_SYS_ID
		from [STAGE_METRIX_METRIX].[INDIAN_RESERVES] ir
		left outer join [STAGE_METRIX_METRIX].[INDIAN_RESERVE_MASTERS] irm on ir.id = irm.INDIAN_RESERVE_ID
		left outer join [STAGE_METRIX_METRIX].[INDIAN_RESERVE_WELL_DETAILS] irw on irw.INDIAN_RESERVE_ID = irm.INDIAN_RESERVE_ID and irw.PRODUCTION_DATE = irm.PRODUCTION_DATE
		where WELL_TRACT_SYS_ID is not null
) ri on w.WELL_TRACT_SYS_ID = ri.WELL_TRACT_SYS_ID;