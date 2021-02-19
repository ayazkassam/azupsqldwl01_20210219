CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_charge_type]
AS select code as charge_type
	, description charge_type_description
	, code + ' (' + description + ')' as charge_type_name
	, short_description charge_type_short
	, specific_type_code charge_type_specific_code
	, active_value	is_active
from [STAGE_METRIX_METRIX].[charge_types];