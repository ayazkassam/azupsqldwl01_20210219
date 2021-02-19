CREATE VIEW [STAGE_METRIX].[v_metrix_unit_wells]
AS select u.Unit_ID
	, u.Unit_Name
	, u.Unit_Province
	, u.Unit_Govt_Code
	, u.Unit_Cost_Centre_Code
	, u.well_id
	, w.Well_Facility_id
from (
/*Well Units*/
select u.id as Unit_ID
	, u.PROVINCE as Unit_Province
	, coalesce(m.Unit_Name, u.id) as Unit_Name
	, m.Unit_Govt_Code
	, m.Unit_Cost_Centre_Code
	, w.WELL_ID
from [STAGE_METRIX_METRIX].units u
left outer join (
		select distinct UNIT_ID
			, first_value(name) over (partition by unit_id order by production_date desc) as Unit_Name
			, first_value(GOVERNMENT_CODE) over (partition by unit_id order by production_date desc) as Unit_Govt_Code
			, first_value(COST_CENTRE_CODE) over (partition by unit_id order by production_date desc) as Unit_Cost_Centre_Code
		from [STAGE_METRIX_METRIX].UNIT_MASTERS 
) m on u.id = m.UNIT_ID
join (
	select distinct UNIT_ID, WELL_ID
	from [STAGE_METRIX_METRIX].UNIT_WELLS
) w on u.ID = w.UNIT_ID
) u
left outer join data_mart_metrix.t_dim_well w on u.WELL_ID = w.Well_Tract_ID;