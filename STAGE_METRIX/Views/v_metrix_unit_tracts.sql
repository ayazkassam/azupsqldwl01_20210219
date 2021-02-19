CREATE VIEW [STAGE_METRIX].[v_metrix_unit_tracts]
AS select u.id as Unit_ID
	, u.PROVINCE as Unit_Province
	, coalesce(m.Unit_Name, u.id) as Unit_Name
	, m.Unit_Govt_Code
	, m.Unit_Cost_Centre_Code
	, t.TRACT_ID
	, t.Production_Percent
	, t.Crown_Percent
	, t.Federal_Percent
from [STAGE_METRIX_METRIX].units u
left outer join (
		select distinct UNIT_ID
			, first_value(name) over (partition by unit_id order by production_date desc) as Unit_Name
			, first_value(GOVERNMENT_CODE) over (partition by unit_id order by production_date desc) as Unit_Govt_Code
			, first_value(COST_CENTRE_CODE) over (partition by unit_id order by production_date desc) as Unit_Cost_Centre_Code
		from [STAGE_METRIX_METRIX].UNIT_MASTERS 
) m on u.id = m.UNIT_ID
join (
	select distinct UNIT_ID
		, TRACT_ID
		, first_value(PRODUCTION_PERCENT) over (partition by unit_id order by production_date desc) as Production_Percent
		, first_value(CROWN_PERCENT) over (partition by unit_id order by production_date desc) as Crown_Percent
		, first_value(FEDERAL_PERCENT) over (partition by unit_id order by production_date desc) as Federal_Percent
	from [STAGE_METRIX_METRIX].UNIT_TRACTS 
) t on u.ID = t.UNIT_ID;