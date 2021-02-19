CREATE VIEW [data_mart_metrix].[v_dim_purchaser]
AS select cast(purchaser_id as varchar(50)) purchaser_id
	, purchaser_name
	, purchaser_grouping
	, case when isnumeric(purchaser_id) = 1 then cast(purchaser_id as int) end as SortKey
from [data_mart_metrix].[t_dim_purchaser]
union all
select cast('-1' as varchar(50)) purchaser_id
	, 'Unknown' purchaser_name
	, 'UN' purchaser_grouping
	, -1;