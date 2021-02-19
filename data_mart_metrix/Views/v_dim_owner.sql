CREATE VIEW [data_mart_metrix].[v_dim_owner]
AS select Owner_ID
	, Owner_Name
	, Owner_Govt_Code
	, Owner_Province
	, case when isnumeric(Owner_ID) = 1 then cast(Owner_ID as int) end as sortKey
from [data_mart_metrix].[t_dim_owner]
union all
select '-1', 'Unknown', null, null, -1;