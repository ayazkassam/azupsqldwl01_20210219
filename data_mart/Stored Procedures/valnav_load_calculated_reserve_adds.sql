CREATE PROC [data_mart].[valnav_load_calculated_reserve_adds] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY	
    
	
	-- Delete existing records before inserting new ones
    BEGIN TRANSACTION

	   DELETE [data_mart].t_fact_valnav_reserves
       WHERE scenario_key IN
                (SELECT DISTINCT scenario_key FROM [stage].v_fact_source_valnav_reserve_adds_calculation)
             AND account_key IN
                    (SELECT DISTINCT account_key FROM [stage].v_fact_source_valnav_reserve_adds_calculation);
	COMMIT TRANSACTION

	--
	BEGIN TRANSACTION

	-- Insert New Transactions 
	   
	   INSERT INTO [data_mart].t_fact_valnav_reserves
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
			  current_timestamp as last_update_date,
			  'I' as ETL_Status
	   FROM [stage].v_fact_source_valnav_reserve_adds_calculation
	   GROUP BY entity_key,
			  activity_date_key,
			  account_key,
			  reserve_category_key,
			  scenario_key,
			  gross_net_key,
			  normalized_time_key,
			  scenario_type;
	
    --	

	--SET @rowcnt = @@ROWCOUNT

	COMMIT TRANSACTION
	 
    SELECT 1
 END TRY
 
 BEGIN CATCH
        
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
				--,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		-- If the error renders the transaction as uncommittable or we have open transactions, rollback
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

  END CATCH

 -- RETURN @@ERROR

END