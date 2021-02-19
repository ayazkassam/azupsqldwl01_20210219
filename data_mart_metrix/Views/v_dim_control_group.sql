CREATE VIEW [data_mart_metrix].[v_dim_control_group]
AS select isnull(control_group_id,'-1') control_group_id
	, isnull(control_group_name	  ,'Unknown') control_group_name
	, isnull(control_group_region ,'Unknown') control_group_region
	, pa_responsible_user_id
	, control_group_pa_responsible_user
from [data_mart_metrix].[t_dim_control_group]
union all
select '-1'
	, 'Unknown'
	, 'Unknown'
	, null
	, null;