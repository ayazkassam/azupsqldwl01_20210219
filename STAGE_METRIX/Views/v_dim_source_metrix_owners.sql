CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_owners]
AS select om.owner_id
	, om.owner_name
	, om.owner_province
	, og.owner_govt_code
from (
	select distinct owner_id
		, first_value(name) over (partition by owner_id order by production_date desc) owner_name,
		JIBLINK_PROVINCE_CODE owner_province
	from [STAGE_METRIX_METRIX].[owner_masters] 
) om
left outer join (
	select distinct owner_id
		--, first_value(province) over (partition by owner_id order by production_date desc) owner_province
		, first_value(code) over (partition by owner_id order by production_date desc) owner_govt_code
	from [STAGE_METRIX_METRIX].[owner_governments] 
) og on om.owner_id = og.owner_id;