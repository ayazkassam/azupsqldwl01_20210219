CREATE VIEW [data_mart_metrix].[v_dim_target_facility]
AS select f.target_facility_id
	, f.target_facility_name
	, f.target_facility_government_code
	, f.target_facility_province
	, f.target_facility_operator_id
	, f.target_facility_operator_name
	, f.facility_type_code
	, f.facility_type_desc
	, f.facility_code
	, r.Facility_name as registry_facility_name
	, r.Operator_Name as registry_Operator_Name
from [data_mart_metrix].[t_dim_target_facility]  f
left outer join stage_metrix.t_stg_metrix_government_registry r on f.facility_code = r.[Facility_ID]
union all
select distinct f.facility_id
	, f.facility_name
	, f.facility_government_code
	, f.facility_province
	, f.facility_operator_id
	, f.facility_operator_name
	, f.facility_type_code
	, f.facility_type_desc
	, f.facility_code
	, r.Facility_name as registry_facility_name
	, r.Operator_Name as registry_Operator_Name
from [data_mart_metrix].[t_dim_facility] f
left outer join stage_metrix.t_stg_metrix_government_registry r on f.facility_code = r.[Facility_ID]
union all
select 'Unknown'
	, 'Unknown'
	, null
	, 'Unknown'
	, null
	, null
	, 'Unknown'
	, 'Unknown'
	, 'Unknown'
	, null
	, null;