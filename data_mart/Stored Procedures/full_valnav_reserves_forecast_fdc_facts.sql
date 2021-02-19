CREATE PROC [data_mart].[full_valnav_reserves_forecast_fdc_facts] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @before_count as INT, @after_count as INT

BEGIN TRY	

    -- count rows before merge

	/* SELECT DISTINCT 
		@before_count=row_count
		FROM sys.dm_db_partition_stats
		WHERE object_id = OBJECT_ID('t_fact_fdc');
	*/

    -- Merge IHS Full Volumes
	
	--BEGIN TRANSACTION		
	
	DELETE 
	FROM [data_mart].[t_fact_fdc]
	WHERE data_type='VALNAV-GLJ';
	
	--COMMIT TRANSACTION	
	
	--BEGIN TRANSACTION	


	INSERT INTO [data_mart].[t_fact_fdc]
	SELECT [site_id]
      ,[entity_key]
      ,[activity_date_key]
      ,[scenario_key]
      ,[data_type]
      ,[gross_net_key]
      ,[gas_metric_volume]
      ,[gas_imperial_volume]
      ,[gas_boe_volume]
      ,[gas_mcfe_volume]
      ,[oil_metric_volume]
      ,[oil_imperial_volume]
      ,[oil_boe_volume]
      ,[oil_mcfe_volume]
      ,[ethane_metric_volume]
      ,[ethane_imperial_volume]
      ,[ethane_boe_volume]
      ,[ethane_mcfe_volume]
      ,[propane_metric_volume]
      ,[propane_imperial_volume]
      ,[propane_boe_volume]
      ,[propane_mcfe_volume]
      ,[butane_metric_volume]
      ,[butane_imperial_volume]
      ,[butane_boe_volume]
      ,[butane_mcfe_volume]
      ,[pentane_metric_volume]
      ,[pentane_imperial_volume]
      ,[pentane_boe_volume]
      ,[pentane_mcfe_volume]
      ,[condensate_metric_volume]
      ,[condensate_imperial_volume]
      ,[condensate_boe_volume]
      ,[condensate_mcfe_volume]
      ,[total_ngl_metric_volume]
      ,[total_ngl_imperial_volume]
      ,[total_ngl_boe_volume]
      ,[total_ngl_mcfe_volume]
      ,[total_liquid_metric_volume]
      ,[total_liquid_imperial_volume]
      ,[total_liquid_boe_volume]
      ,[total_liquid_mcfe_volume]
      ,[total_boe_volume]
      ,[water_metric_volume]
      ,[water_imperial_volume]
      ,[water_boe_volume]
      ,[water_mcfe_volume]
      , null [hours_on]
      , null [hours_down]
      , null [casing_pressure]
      , null [tubing_pressure]
      ,current_timestamp [last_update_date]
      , null [injected_produced_water]
      , null [injected_source_water]
      , null [injected_pressure_kpag]
      , null [bsw]
      , null [joints_to_fluid]
      , null [strokes_per_minute]
      , null [injected_gas_C02]
	FROM [stage].[t_fact_source_fdc_valnav_glj_volumes];	


	--SET @rowcnt = @@ROWCOUNT

	--COMMIT TRANSACTION	
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
		--RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)     

  END CATCH

 -- RETURN @@ERROR

END