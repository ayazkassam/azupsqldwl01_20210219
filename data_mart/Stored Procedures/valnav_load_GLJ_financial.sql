﻿CREATE PROC [data_mart].[valnav_load_GLJ_financial] AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY	

		/*drop indexes*/
		--stage.dbo.DeleteAllIndexes_On_Table 't_fact_valnav_financial_glj'
	
		/*-- Delete existing glj financial facts (if any) before inserting new ones*/
		begin transaction
			DELETE from [data_mart].t_fact_valnav_financial_glj
			WHERE scenario_key IN (	SELECT DISTINCT variable_value
									FROM [stage].t_ctrl_valnav_etl_variables
									WHERE VARIABLE_NAME IN ('GLJ_RESERVES_CUBE_SCENARIO','RESERVES_ANALYSIS_SCENARIO'))
		commit transaction

		/*-- Insert Financial records*/
		begin transaction

			INSERT INTO [data_mart].t_fact_valnav_financial_glj
			SELECT entity_key,
				activity_date_key,
				account_key,
				reserve_category_key,
				scenario_key,
				gross_net_key,
				normalized_time_key,
				sum(cad) cad,
				sum(cad)/1000 k_cad,
				scenario_type,
				CURRENT_TIMESTAMP last_update_date
			FROM [stage].v_fact_source_valnav_financial_GLJReserves
			GROUP BY entity_key,activity_date_key,account_key,reserve_category_key,scenario_key
				,gross_net_key,normalized_time_key,scenario_type
			
			--SET @rowcnt = @@ROWCOUNT

		commit transaction

		/*recreate indexes*/
		--stage.dbo.CreateIndexes_On_Table 't_fact_valnav_financial_glj' 
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