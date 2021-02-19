CREATE PROC [stage].[load_fact_source_qbyte_working_interest] AS
BEGIN
	SET NOCOUNT ON;

	truncate table [stage].[t_fact_source_qbyte_working_interest];

	DECLARE
	  @start_date INT = (	
	                      SELECT int_value AS start_date
				          FROM [stage].[t_ctrl_etl_variables]
				          WHERE variable_name = 'CAPITAL_ACTIVITY_DATE_START'
		                ),
	  @end_date INT = (		
	                    SELECT int_value AS end_date
				        FROM [stage].[t_ctrl_etl_variables]
				        WHERE variable_name = 'CAPITAL_ACTIVITY_DATE_END'
		              )

     IF OBJECT_ID('tempdb..#cte_WI') IS NOT NULL
       DROP TABLE #cte_WI	 

     CREATE TABLE #cte_WI WITH (DISTRIBUTION = ROUND_ROBIN)
       AS
	--with cte_WI as(
		select distinct c.cc_num
			, first_value(c.working_interest) over (partition by cc_num, d.date_key order by effective_date desc) working_interest
			, d.date_key accounting_period
		from 
		  (
			select distinct cc_num
				, first_value(working_interest) over (partition by cc_num, eomonth(effective_date) order by effective_date desc)/100 working_interest
				, eomonth(first_value(effective_date) over (partition by cc_num, eomonth(effective_date) order by effective_date desc)) effective_date
				, eomonth(first_value(termination_date) over (partition by cc_num, eomonth(effective_date) order by effective_date desc)) termination_date
			from [stage].[iv_cc_num_working_interest] p

		  ) c
		join [data_mart].[dim_date] d 
			on d.full_Date >= c.effective_date
			and d.full_Date <= c.termination_date
			and d.last_Day_of_Calendar_month_flag = 'y'
		--, 
		--  (	SELECT int_value AS start_date
		--		FROM [stage].[t_ctrl_etl_variables]
		--		WHERE variable_name = 'CAPITAL_ACTIVITY_DATE_START'
		--  ) sd 
		--, 
		--  (		SELECT int_value AS end_date
		--		FROM [stage].[t_ctrl_etl_variables]
		--		WHERE variable_name = 'CAPITAL_ACTIVITY_DATE_END'

		--  ) ed 
		where 
		  d.date_key >= @start_date AND --sd.start_date and 
		  d.date_key <= @end_date--ed.end_date
	--)

	insert into [stage].[t_fact_source_qbyte_working_interest]
	select 'Working Interest' as Account
		, accounting_period
		, accounting_period as activity_period
		, cc.cc_num as entity_key
		, convert(int,convert(varchar(8),convert(date,e.create_date),112)) create_date
		, case when convert(date,e.on_production_date)< md.minDate then null
			else convert(int,convert(varchar(8),convert(date,e.on_production_date),112)) end on_production_date
		, convert(int,convert(varchar(8),convert(date,e.last_production_date),112)) last_production_date
		, case when convert(date,e.rig_release_date)< md.minDate then null
			else convert(int,convert(varchar(8),convert(date,e.rig_release_date),112)) end rig_release_date
		, case when convert(date,e.spud_date)< md.minDate then null
			else convert(int,convert(varchar(8),convert(date,e.spud_date),112)) end spud_date
		, convert(int,convert(varchar(8),convert(date,e.cc_term_date),112)) cc_term_date
		, 'WI' as Scenario
		, e.op_nonop
		, e.budget_group
		, cc.working_interest
	from #cte_WI cc
	left outer join [data_mart].[t_dim_entity] e on cc.cc_num = e.entity_key
	, (	select min(full_date) minDate from [data_mart].[dim_date]) md

	DECLARE @rowcnt INT
	EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	
	SELECT @rowcnt INSERTED
END