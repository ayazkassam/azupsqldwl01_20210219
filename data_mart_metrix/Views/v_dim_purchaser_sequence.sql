CREATE VIEW [data_mart_metrix].[v_dim_purchaser_sequence]
AS select purchaser_sequence
	, cast(purchaser_sequence as int) as sort_key
from [data_mart_metrix].[t_dim_purchaser_sequence];