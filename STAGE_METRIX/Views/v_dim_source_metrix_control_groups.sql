CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_control_groups]
AS select coalesce(c.CONTROL_GROUP_ID, g.id) CONTROL_GROUP_ID
	, coalesce(c.Control_Group_Name, g.id) Control_Group_Name
	, c.Control_Group_Region
	, c.PA_Responsible_User_ID
	, u.USER_NAME Control_Group_PA_Responsible_User
from [STAGE_METRIX_METRIX].CONTROL_GROUPS g
full outer join (
		select distinct CONTROL_GROUP_ID
			, first_value(NAME) over (partition by CONTROL_GROUP_ID order by production_date desc) as Control_Group_Name
			, first_value(REGION_ID) over (partition by CONTROL_GROUP_ID order by production_date desc) as Control_Group_Region
			, first_value(PA_RESPONSIBLE_USER_ID) over (partition by CONTROL_GROUP_ID order by production_date desc) as PA_Responsible_User_ID
		from [STAGE_METRIX_METRIX].[CONTROL_GROUP_MASTERS]
) c on g.ID = c.CONTROL_GROUP_ID
left outer join [STAGE_METRIX_METRIX].USER_ACCOUNTS u on u.USER_ID = c.PA_Responsible_User_ID;