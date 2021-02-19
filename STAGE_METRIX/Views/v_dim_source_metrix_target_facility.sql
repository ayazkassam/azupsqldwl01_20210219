CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_target_facility]
AS select coalesce(m.Target_Facility_ID, d.id) as Target_Facility_ID
	, coalesce(m.Target_Facility_Name, d.id) as Target_Facility_Name
	, m.Target_Facility_Government_Code 
	, d.Province as Target_Facility_Province
	, m.Target_Facility_Operator_ID
	, o.Owner_Name as Target_Facility_Operator_Name
	, m.Target_Facility_registry_entity_type
	, 'D' as [ENTITY_TYPE_CODE]
	, 'Delivery System' [Entity_Type]
	, left(coalesce(m.Target_Facility_ID, d.id),11) as Facility_Code
from [STAGE_METRIX_METRIX].[DELIVERY_SYSTEMS] d
left outer join (
	select distinct DELIVERY_SYSTEM_ID as Target_Facility_ID
		, first_value(name) over (partition by DELIVERY_SYSTEM_ID order by Production_date desc) as Target_Facility_Name
		, first_value(REGISTRY_ENTITY_TYPE) over (partition by DELIVERY_SYSTEM_ID order by Production_date desc) as Target_Facility_registry_entity_type
		, first_value(REGISTRY_GOVERNMENT_CODE) over (partition by DELIVERY_SYSTEM_ID order by Production_date desc) as Target_Facility_Government_Code
		, first_value(FACILITY_OPERATOR_ID) over (partition by DELIVERY_SYSTEM_ID order by Production_date desc) as Target_Facility_Operator_ID
	from [STAGE_METRIX_METRIX].[DELIVERY_SYSTEM_MASTERS]
) m on m.Target_Facility_ID = d.ID
left outer join [STAGE_METRIX].v_dim_source_metrix_owners o on m.Target_Facility_Operator_ID = o.Owner_ID;