CREATE PROC [data_mart].[valnav_load_typecurves_daily] AS
	SET NOCOUNT ON;

	BEGIN TRY	

   -- BEGIN TRANSACTION
		truncate table [data_mart].t_fact_valnav_production_typecurves_daily
	--COMMIT TRANSACTION

   -- BEGIN TRANSACTION

      IF OBJECT_ID('tempdb..#cte_Scenario') IS NOT NULL
        DROP TABLE #cte_Scenario	 
	  
      CREATE TABLE #cte_Scenario WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
		--;with cte_Scenario as (
				select scenario_key
				from [data_mart].[t_dim_scenario_typecurves]
				where scenario_parent_key in (
									select scenario_key
									from stage.t_stg_type_curves_current_scenario 
									where is_current_scenario = 'Y')
		--)

      IF OBJECT_ID('tempdb..#cte_dates') IS NOT NULL
        DROP TABLE #cte_dates	 
	  
      CREATE TABLE #cte_dates WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
		--, cte_dates as (
			select d.date_key
				, convert(int,convert(varchar(8),DATEADD(month, DATEDIFF(month, 0, convert(date,d.full_Date)), 0),112)) as JoinDate
				, day(eomonth(d.full_date)) DaysInMonth
				, day(d.full_date) as Day_of_Month
			from [data_mart].dim_date d
			join (
				SELECT max(case when variable_name = 'valnav_activity_date_start' then DATEADD(month, DATEDIFF(month, 0, convert(date,variable_value)), 0) end) AS StartDate
					, max(case when variable_name = 'valnav_activity_date_end' then eomonth(convert(date,variable_value)) end) AS EndDate
				FROM [stage].t_ctrl_valnav_etl_variables
				where variable_name in ('valnav_activity_date_start','valnav_activity_date_end')
			) a on d.full_Date between a.StartDate and a.EndDate
		--)

		insert into [data_mart].t_fact_valnav_production_typecurves_daily
		select f.entity_key
			, d.date_key
			, f.account_key
			, f.reserve_category_key
			, f.scenario_key
			, f.gross_net_key
			, case when f.normalized_time_key = '-1' then '-1'
				else left(f.normalized_time_key,3) + right(concat('0',convert(varchar(2), d.Day_of_Month)),2) end as NormalizedMonth
			, f.imperial_volume / DaysInMonth	 imperial_volume
			, f.boe_volume / DaysInMonth boe_volume
			, f.metric_volume / DaysInMonth metric_volume
			, f.mcfe_volume / DaysInMonth mcfe_volume
			, f.scenario_type
			, f.last_update_date
		from [data_mart].t_fact_valnav_production_typecurves f
		join #cte_Scenario s on f.scenario_key = s.scenario_key
		join #cte_dates d on f.activity_date_key = d.JoinDate

	  DECLARE  @rowcnt INT
	  EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	
	  SELECT @rowcnt INSERTED

	--COMMIT TRANSACTION
   
	END TRY
 
	BEGIN CATCH
        
		/*-- Grab error information from SQL functions*/
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
			, @ErrorNumber INT	= ERROR_NUMBER()
			, @ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
			, @ErrorState INT = ERROR_STATE()
			--, @ErrorLine  INT = ERROR_LINE()
			, @ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		/*-- If the error renders the transaction as uncommittable or we have open transactions, rollback*/
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

	END CATCH

	--RETURN @@ERROR