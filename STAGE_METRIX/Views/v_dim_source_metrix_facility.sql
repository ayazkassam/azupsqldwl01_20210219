CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_facility]
AS select f.SYS_ID as Facility_Sys_ID
	, f.ENTITY_ID	
	, f.ENTITY_TYPE_CODE 
	, et.DESCRIPTION as Entity_Type
	, e.Province
	, e.Facility_ID
	, e.Facility_Name
	, e.Facility_Government_Code
	, e.Facility_Cost_Centre_Code
	, e.Facility_Production_Status
	, e.Facility_Operator_ID
	, o.Owner_Name as Facility_Operator_Name
	, e.Facility_PA_Responsible_User_ID
	, u.User_Name as Facility_PA_Responsible_User
	, left(f.ENTITY_ID,11) as Facility_Code
from [STAGE_METRIX_METRIX].[FACILITIES] f
/*use inner join to filter for only facilities that have production_dates*/
join (
	/*first vaule used to determine the current facilities based on the most recent production date */
	select bf.Facility_Sys_ID
		, bf.Province
		, coalesce(m.Facility_ID, bf.id) Facility_ID
		, coalesce(m.Facility_Name, bf.id) Facility_Name
		, m.Facility_Government_Code
		, m.Facility_Cost_Centre_Code
		, m.Facility_Production_Status
		, m.Facility_Operator_ID
		, m.Facility_PA_Responsible_User_ID
	from [STAGE_METRIX_METRIX].[BATTERY_FACILITIES] bf
	left outer join (		
		/*first vaule used to determine the current facilities based on the most recent production date */
		select distinct BATTERY_FACILITY_ID as Facility_ID
			, first_value(NAME) over (partition by BATTERY_FACILITY_ID order by Production_date desc)					as Facility_Name
			, first_value(GOVERNMENT_CODE) over (partition by BATTERY_FACILITY_ID order by Production_date desc)		as Facility_Government_Code
			, first_value(COST_CENTRE_CODE) over (partition by BATTERY_FACILITY_ID order by Production_date desc)		as Facility_Cost_Centre_Code
			, first_value(PRODUCTION_STATUS) over (partition by BATTERY_FACILITY_ID order by Production_date desc)		as Facility_Production_Status
			, first_value(BATTERY_OPERATOR_ID) over (partition by BATTERY_FACILITY_ID order by Production_date desc)	as Facility_Operator_ID
			, first_value(PA_RESPONSIBLE_USER_ID) over (partition by BATTERY_FACILITY_ID order by Production_date desc)	as Facility_PA_Responsible_User_ID
		from [STAGE_METRIX_METRIX].[BATTERY_MASTERS] bm
	) m on m.Facility_ID = bf.ID
	union all
	select g.Facility_Sys_ID
		, g.Province
		, coalesce(m.Facility_ID, g.id) Facility_ID
		, coalesce(m.Facility_Name, g.id) Facility_Name
		, m.Facility_Government_Code
		, m.Facility_Cost_Centre_Code
		, m.Facility_Production_Status
		, m.Facility_Operator_ID
		, m.Facility_PA_Responsible_User_ID
	from [STAGE_METRIX_METRIX].[GGS_FACILITIES] g
	left outer join (		
		/*first vaule used to determine the current facilities based on the most recent production date */
		select distinct GGS_FACILITY_ID as Facility_ID
			, first_value(name) over (partition by GGS_FACILITY_ID order by Production_date desc)					as Facility_Name
			, first_value(GOVERNMENT_CODE) over (partition by GGS_FACILITY_ID order by Production_date desc)		as Facility_Government_Code
			, first_value(COST_CENTRE_CODE) over (partition by GGS_FACILITY_ID order by Production_date desc)		as Facility_Cost_Centre_Code
			, first_value(PRODUCTION_STATUS) over (partition by GGS_FACILITY_ID order by Production_date desc)		as Facility_Production_Status
			, first_value(FACILITY_OPERATOR_ID) over (partition by GGS_FACILITY_ID order by Production_date desc)	as Facility_Operator_ID
			, first_value(PA_RESPONSIBLE_USER_ID) over (partition by GGS_FACILITY_ID order by Production_date desc)	as Facility_PA_Responsible_User_ID
		from [STAGE_METRIX_METRIX].[GGS_MASTERS]
	) m on m.Facility_ID = g.ID
	union all
	select i.Facility_Sys_id
		, i.Province
		, coalesce(m.Facility_ID, i.id) Facility_ID
		, coalesce(m.Facility_Name, i.id) Facility_Name
		, m.Facility_Government_Code
		, m.Facility_Cost_Centre_Code
		, m.Facility_Production_Status
		, m.Facility_Operator_ID
		, m.Facility_PA_Responsible_User_ID
	from [STAGE_METRIX_METRIX].[INJECTION_FACILITIES] i
	left outer join (		
		/*first vaule used to determine the current facilities based on the most recent production date */
		select distinct INJECTION_FACILITY_ID as Facility_ID
			, first_value(NAME) over (partition by INJECTION_FACILITY_ID order by Production_date desc) as Facility_Name
			, first_value(GOVERNMENT_CODE) over (partition by INJECTION_FACILITY_ID order by Production_date desc) as Facility_Government_Code
			, first_value(COST_CENTRE_CODE) over (partition by INJECTION_FACILITY_ID order by Production_date desc) as Facility_Cost_Centre_Code
			, first_value(PRODUCTION_STATUS) over (partition by INJECTION_FACILITY_ID order by Production_date desc) as Facility_Production_Status
			, first_value(FACILITY_OPERATOR_ID) over (partition by INJECTION_FACILITY_ID order by Production_date desc) as Facility_Operator_ID
			, first_value(PA_RESPONSIBLE_USER_ID) over (partition by INJECTION_FACILITY_ID order by Production_date desc)	as Facility_PA_Responsible_User_ID
		from [STAGE_METRIX_METRIX].[INJECTION_MASTERS] 
	) m on m.Facility_ID = i.ID
	union all
	select p.Facility_Sys_id
		, p.Province
		, coalesce(m.Facility_ID, p.id) Facility_ID
		, coalesce(m.Facility_Name, p.id) Facility_Name
		, m.Facility_Government_Code
		, m.Facility_Cost_Centre_Code
		, m.Facility_Production_Status
		, m.Facility_Operator_ID
		, m.Facility_PA_Responsible_User_ID
	from [STAGE_METRIX_METRIX].[PLANT_FACILITIES] p 
	left outer join (		
		/*first vaule used to determine the current facilities based on the most recent production date */
		select distinct PLANT_FACILITY_ID as Facility_ID
			, first_value(NAME) over (partition by PLANT_FACILITY_ID order by Production_date desc) as Facility_Name
			, first_value(GOVERNMENT_CODE) over (partition by PLANT_FACILITY_ID order by Production_date desc) as   Facility_Government_Code
			, first_value(COST_CENTRE_CODE) over (partition by PLANT_FACILITY_ID order by Production_date desc) as  Facility_Cost_Centre_Code
			, first_value(PRODUCTION_STATUS) over (partition by PLANT_FACILITY_ID order by Production_date desc) as Facility_Production_Status
			, first_value(FACILITY_OPERATOR_ID) over (partition by PLANT_FACILITY_ID order by Production_date desc) as Facility_Operator_ID
			, first_value(PA_RESPONSIBLE_USER_ID) over (partition by PLANT_FACILITY_ID order by Production_date desc)	as Facility_PA_Responsible_User_ID
		from [STAGE_METRIX_METRIX].[PLANT_MASTERS]
	) m on m.Facility_ID = p.ID
) e on f.SYS_ID = e.FACILITY_SYS_ID
left outer join [STAGE_METRIX].v_dim_source_metrix_owners o on e.Facility_Operator_ID = o.Owner_ID
left outer join [STAGE_METRIX_METRIX].USER_ACCOUNTS u on e.Facility_PA_Responsible_User_ID = u.user_id
left outer join [STAGE_METRIX_METRIX].ENTITY_TYPES et on f.ENTITY_TYPE_CODE = et.code;