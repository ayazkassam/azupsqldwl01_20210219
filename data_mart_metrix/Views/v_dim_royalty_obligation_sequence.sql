CREATE VIEW [data_mart_metrix].[v_dim_royalty_obligation_sequence]
AS select royalty_obligation_sequence
	, cast(royalty_obligation_sequence as int) as sort_key
from [data_mart_metrix].[t_dim_royalty_obligation_sequence];