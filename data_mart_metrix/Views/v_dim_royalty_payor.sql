CREATE VIEW [data_mart_metrix].[v_dim_royalty_payor]
AS select Owner_ID royalty_payor_id
	, Owner_Name royalty_payor_name
	-- Does not work so removed , Owner_Province royalty_payor_province
	, case when isnumeric(Owner_ID) = 1 then cast(Owner_ID as int) end as PayorsortKey
from [data_mart_metrix].[t_dim_owner]
union all
select '-1', 'Unknown',  -1;