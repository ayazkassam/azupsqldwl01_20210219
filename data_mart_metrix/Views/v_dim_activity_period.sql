CREATE VIEW [data_mart_metrix].[v_dim_activity_period]
AS select distinct date_key
		, convert(date,full_date) full_date
		, substring(convert(varchar(6),full_date,112),1,4) + ' - ' + substring(convert(varchar(6),full_date,112),5,2) calendar_month_name
		, calendar_quarter_name
		, 'Activity ' + convert(char(8),calendar_year_number) as calendar_year_name
		, 1 as number_of_days
	from data_mart_metrix.[t_dim_date] d
	join (
		select min(int_value) as start_year
			, max(int_value) as end_year
		from [stage_metrix].t_ctrl_metrix_etl_variables 
		where variable_name in ('metrix_activity_date_start_year','metrix_activity_date_end_year')
	) s  on d.calendar_year_number >= s.start_year and d.calendar_year_number <= s.end_year
	union all
	select distinct date_key
		, convert(date,full_date) full_date
		, substring(convert(varchar(6),full_date,112),1,4) + ' - ' + substring(convert(varchar(6),full_date,112),5,2) calendar_month_name
		, calendar_quarter_name
		, 'Activity ' + convert(char(8),calendar_year_number) as calendar_year_name
		, 1 as number_of_days
	from data_mart_metrix.[t_dim_date] 
	where date_key in (-1,-2);