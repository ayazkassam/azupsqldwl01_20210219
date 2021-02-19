CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_royalty_obligation_sequence]
AS select distinct cast(ROYALTY_OBLIGATION_ID as varchar(10)) royalty_obligation_sequence
from [STAGE_METRIX_METRIX].ROYALTY_OBLIGATIONS;