CREATE VIEW [data_mart_metrix].[v_dim_product]
AS select product_code
	, product_description
	, product_group
	, product_sort_order sort_key
	, product_group_sort group_sort_key
from [data_mart_metrix].[t_dim_product]
union all
select '-1'
	, 'Unknown'
	, 'Unknown'
	, '0'
	,'0';