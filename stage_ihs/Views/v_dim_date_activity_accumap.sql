CREATE VIEW [stage_ihs].[v_dim_date_activity_accumap]
AS select distinct date_key
		, convert(date,full_date) full_date
		, substring(convert(varchar(6),full_date,112),1,4) + ' - ' + substring(convert(varchar(6),full_date,112),5,2) calendar_month_name
		, calendar_quarter_name
		, 'Activity ' + convert(char(8),calendar_year_number) as calendar_year_name
		, 1 as number_of_days
	from  data_mart.[dim_date] d
	join (
		select min(int_value) as start_year
			, max(int_value) as end_year
		from stage.t_ctrl_etl_variables 
		where variable_name in ('volumes_activity_date_start_year','volumes_activity_date_end_year')
	) s  on d.calendar_year_number >= s.start_year and d.calendar_year_number <= s.end_year
	
	
	union all

	select distinct date_key
		, convert(date,full_date) full_date
		, substring(convert(varchar(6),full_date,112),1,4) + ' - ' + substring(convert(varchar(6),full_date,112),5,2) calendar_month_name
		, calendar_quarter_name
		, 'Activity ' + convert(char(8),calendar_year_number) as calendar_year_name
		, 1 as number_of_days
	from  data_mart.[dim_date] 
	where date_key in (-1,-2, 20061231);