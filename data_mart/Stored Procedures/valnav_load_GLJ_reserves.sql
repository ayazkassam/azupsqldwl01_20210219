CREATE PROC [data_mart].[valnav_load_GLJ_reserves] AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY	

		/*drop indexes*/
		--stage.dbo.DeleteAllIndexes_On_Table 't_fact_valnav_reserves_glj'

		begin transaction
			DELETE from [data_mart].t_fact_valnav_reserves_glj
			WHERE scenario_key IN (	SELECT DISTINCT variable_value
									FROM [stage].t_ctrl_valnav_etl_variables
									WHERE VARIABLE_NAME IN ('GLJ_RESERVES_CUBE_SCENARIO_VOLUMES','RESERVES_ANALYSIS_SCENARIO'))
		commit transaction

		/*-- Insert GLJ (booked) reserves*/
		begin transaction
			INSERT INTO [data_mart].t_fact_valnav_reserves_glj
			SELECT entity_key,
				activity_date_key,
				account_key,
				reserve_category_key,
				scenario_key,
				gross_net_key,
				normalized_time_key,
				sum(imperial_volume) imperial_volume,
				sum(boe_volume) boe_volume,
				sum(metric_volume) metric_volume,
				sum(mcfe_volume) mcfe_volume,
				scenario_type,
				CURRENT_TIMESTAMP last_update_date
			FROM [stage].v_fact_source_valnav_reserves_GLJReserves_final
			GROUP BY entity_key,activity_date_key,account_key,reserve_category_key,scenario_key,gross_net_key,normalized_time_key,scenario_type

		--	SET @rowcnt = @@ROWCOUNT

		commit transaction

		/*recreate indexes*/
		--stage.dbo.CreateIndexes_On_Table 't_fact_valnav_reserves_glj' 

       SELECT 1
	END TRY

 	BEGIN CATCH
		/*-- Grab error information from SQL functions*/
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
			,@ErrorNumber INT	= ERROR_NUMBER()
			,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
			,@ErrorState INT = ERROR_STATE()
			--,@ErrorLine  INT = ERROR_LINE()
			,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		/*-- If the error renders the transaction as uncommittable or we have open transactions, rollback*/
		--IF @@TRANCOUNT > 0
		--	BEGIN
		--		ROLLBACK TRANSACTION
		--	END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)
	END CATCH

	--RETURN @@ERROR

END