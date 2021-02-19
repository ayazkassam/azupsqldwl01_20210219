CREATE VIEW [data_mart_metrix].[v_dim_sales_type]
AS select op_non_op, sales_type_code, sales_type, sales_type_sort_key
from [data_mart_metrix].[t_dim_sales_type]
where is_sales = 1
union all
select 'Unknown'
	, '-1'
	, 'Unknown'
	, 0;