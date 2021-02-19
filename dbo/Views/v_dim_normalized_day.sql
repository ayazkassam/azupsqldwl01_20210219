CREATE VIEW [dbo].[v_dim_normalized_day]
AS select distinct convert(int,case when day_name2 in ('Unknown','Missing') then normalized_time_key
				else replace(day_name2,'Day ','') end) Day_Key
	, day_name2
from [data_mart].t_dim_normalized_time;