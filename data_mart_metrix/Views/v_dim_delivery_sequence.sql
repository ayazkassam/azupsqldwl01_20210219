CREATE VIEW [data_mart_metrix].[v_dim_delivery_sequence]
AS select delivery_sequence
	, cast(delivery_sequence as int) as sort_key
from [data_mart_metrix].[t_dim_delivery_sequence];