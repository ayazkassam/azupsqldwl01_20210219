CREATE VIEW [dbo].[v_dim_normalized_month]
AS select distinct 
	convert(int,case when month_name in ('Unknown','Missing') then normalized_time_key
				else right(month_name,2) end) Month_Key
	, month_name
from [data_mart].t_dim_normalized_time;