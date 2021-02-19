CREATE VIEW [data_mart_metrix].[v_dim_source_facility]
AS select f.facility_sys_id
	, f.facility_id
	, f.facility_name
	, f.facility_type_code
	, f.facility_type_desc
	, f.facility_province
	, f.facility_government_code
	, f.facility_cost_centre_code
	, f.facility_production_status
	, f.facility_operator_id
	, f.facility_operator_name
	, f.facility_pa_responsible_user_id
	, f.facility_pa_responsible_user
	, f.facility_code
	, r.Facility_name as registry_facility_name
	, r.Operator_Name as registry_Operator_Name
from [data_mart_metrix].[t_dim_facility] f
left outer join stage_metrix.t_stg_metrix_government_registry r on f.facility_code = r.[Facility_ID]
union all
select -1
	, 'Unknown'
	, 'Unknown'
	, 'Unknown'
	, 'Unknown'
	, null
	, null
	, null
	, null
	, null
	, null
	, null
	, null
	, 'Unknown'
	, null
	, null;