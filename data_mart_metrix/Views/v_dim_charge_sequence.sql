CREATE VIEW [data_mart_metrix].[v_dim_charge_sequence]
AS select distinct charge_sequence_number
from [data_mart_metrix].t_fact_metrix_fees;