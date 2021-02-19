CREATE VIEW [data_mart_metrix].[v_dim_charge_type]
AS select *
from [data_mart_metrix].t_dim_charge_type
union all 
select '-1', 'Unknown', null, null, null, null;