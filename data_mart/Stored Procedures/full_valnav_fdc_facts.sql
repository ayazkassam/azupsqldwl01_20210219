CREATE PROC [data_mart].[full_valnav_fdc_facts] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @before_count as INT, @after_count as INT

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
	WHERE data_type='VALNAV';
--	COMMIT TRANSACTION
	
	
	--BEGIN TRANSACTION	
	IF OBJECT_ID('tempdb..#t_fact_fdc_MERGE') IS NOT NULL
		DROP TABLE #t_fact_fdc_MERGE

	CREATE TABLE #t_fact_fdc_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
    AS
        SELECT 
		  CASE WHEN dst.entity_key is NULL THEN 'NEW' 
					 ELSE 'UPDATE'
				END Flag,
				 src.entity_key site_id,
				 src.gas_metric_volume,
				 src.gas_imperial_volume,
				 src.gas_boe_volume,
				 src.gas_mcfe_volume,
				 src.oil_metric_volume,
				 src.oil_imperial_volume,
				 src.oil_boe_volume,
				 src.oil_mcfe_volume,
				 src.ethane_metric_volume,
				 src.ethane_imperial_volume,
				 src.ethane_boe_volume,
				 src.ethane_mcfe_volume,
				 src.propane_metric_volume,
				 src.propane_imperial_volume,
				 src.propane_boe_volume,
				 src.propane_mcfe_volume,
				 src.butane_metric_volume,
				 src.butane_imperial_volume,
				 src.butane_boe_volume,
				 src.butane_mcfe_volume,
				 src.pentane_metric_volume,
				 src.pentane_imperial_volume,
				 src.pentane_boe_volume,
				 src.pentane_mcfe_volume,
				 src.condensate_metric_volume,
				 src.condensate_imperial_volume,
				 src.condensate_boe_volume,
				 src.condensate_mcfe_volume,
				 src.total_ngl_metric_volume,
				 src.total_ngl_imperial_volume,
				 src.total_ngl_boe_volume,
				 src.total_ngl_mcfe_volume,
				 src.total_liquid_metric_volume,
				 src.total_liquid_imperial_volume,
				 src.total_liquid_boe_volume,
				 src.total_liquid_mcfe_volume,
				 src.total_boe_volume,
				 src.water_metric_volume,
				 src.water_imperial_volume,
				 src.water_boe_volume,
				 src.water_mcfe_volume,
				 current_timestamp last_update_date,
				 src.activity_date_key,
				 src.gross_net_key,
				 src.data_type,
				 src.scenario_key
		FROM 
			[stage].[t_fact_source_fdc_valnav_volumes] src
			LEFT JOIN [data_mart].[t_fact_fdc] dst
				ON      (  dst.entity_key						= src.entity_key
						  AND	   dst.activity_date_key		= src.activity_date_key
						  AND	   dst.gross_net_key			= src.gross_net_key
						  AND      dst.data_type			    = src.data_type
						  AND      dst.scenario_key			= src.scenario_key)
		EXCEPT
		SELECT 
			'UPDATE' Flag,
			dst.site_id,
			dst.gas_metric_volume,               
			dst.gas_imperial_volume,               
			dst.gas_boe_volume,               
			dst.gas_mcfe_volume,               
			dst.oil_metric_volume,               
			dst.oil_imperial_volume,               
			dst.oil_boe_volume,               
			dst.oil_mcfe_volume,               
			dst.ethane_metric_volume,               
			dst.ethane_imperial_volume,               
			dst.ethane_boe_volume,               
			dst.ethane_mcfe_volume,               
			dst.propane_metric_volume,               
			dst.propane_imperial_volume,               
			dst.propane_boe_volume,               
			dst.propane_mcfe_volume,               
			dst.butane_metric_volume,               
			dst.butane_imperial_volume,               
			dst.butane_boe_volume,               
			dst.butane_mcfe_volume,               
			dst.pentane_metric_volume,               
			dst.pentane_imperial_volume,               
			dst.pentane_boe_volume,               
			dst.pentane_mcfe_volume,               
			dst.condensate_metric_volume,               
			dst.condensate_imperial_volume,               
			dst.condensate_boe_volume,               
			dst.condensate_mcfe_volume,               
			dst.total_ngl_metric_volume,               
			dst.total_ngl_imperial_volume,               
			dst.total_ngl_boe_volume,               
			dst.total_ngl_mcfe_volume,               
			dst.total_liquid_metric_volume,               
			dst.total_liquid_imperial_volume,               
			dst.total_liquid_boe_volume,               
			dst.total_liquid_mcfe_volume,               
			dst.total_boe_volume,               
			dst.water_metric_volume,               
			dst.water_imperial_volume,               
			dst.water_boe_volume,               
			dst.water_mcfe_volume,               
			dst.last_update_date,
			dst.activity_date_key,
			dst.gross_net_key,
			dst.data_type,
			dst.scenario_key

	FROM
			[data_mart].[t_fact_fdc] dst

	INSERT INTO [data_mart].[t_fact_fdc]
	(
		site_id, entity_key, gas_metric_volume, gas_imperial_volume, gas_boe_volume,gas_mcfe_volume, oil_metric_volume,               
		oil_imperial_volume,oil_boe_volume,oil_mcfe_volume,ethane_metric_volume,ethane_imperial_volume,
		ethane_boe_volume,ethane_mcfe_volume, propane_metric_volume,propane_imperial_volume,propane_boe_volume,
		propane_mcfe_volume,butane_metric_volume,butane_imperial_volume,butane_boe_volume,		butane_mcfe_volume,
		pentane_metric_volume,pentane_imperial_volume,pentane_boe_volume,pentane_mcfe_volume,
		condensate_metric_volume,condensate_imperial_volume,condensate_boe_volume,condensate_mcfe_volume,
		total_ngl_metric_volume,total_ngl_imperial_volume,total_ngl_boe_volume,total_ngl_mcfe_volume,
		total_liquid_metric_volume,total_liquid_imperial_volume,total_liquid_boe_volume,total_liquid_mcfe_volume,
		total_boe_volume,water_metric_volume,water_imperial_volume,water_boe_volume,water_mcfe_volume,last_update_date,
		activity_date_key,gross_net_key,data_type,scenario_key
	)
	SELECT
		site_id, site_id, gas_metric_volume, gas_imperial_volume, gas_boe_volume,gas_mcfe_volume, oil_metric_volume,               
		oil_imperial_volume,oil_boe_volume,oil_mcfe_volume,ethane_metric_volume,ethane_imperial_volume,
		ethane_boe_volume,ethane_mcfe_volume, propane_metric_volume,propane_imperial_volume,propane_boe_volume,
		propane_mcfe_volume,butane_metric_volume,butane_imperial_volume,butane_boe_volume,		butane_mcfe_volume,
		pentane_metric_volume,pentane_imperial_volume,pentane_boe_volume,pentane_mcfe_volume,
		condensate_metric_volume,condensate_imperial_volume,condensate_boe_volume,condensate_mcfe_volume,
		total_ngl_metric_volume,total_ngl_imperial_volume,total_ngl_boe_volume,total_ngl_mcfe_volume,
		total_liquid_metric_volume,total_liquid_imperial_volume,total_liquid_boe_volume,total_liquid_mcfe_volume,
		total_boe_volume,water_metric_volume,water_imperial_volume,water_boe_volume,water_mcfe_volume,last_update_date,
		activity_date_key,gross_net_key,data_type,scenario_key
	FROM
		#t_fact_fdc_MERGE
	WHERE FLAG='NEW'

	UPDATE	[data_mart].[t_fact_fdc]
	SET
	    [data_mart].[t_fact_fdc].gas_metric_volume				=     src.gas_metric_volume,
	    [data_mart].[t_fact_fdc].gas_imperial_volume			=     src.gas_imperial_volume,
	    [data_mart].[t_fact_fdc].gas_boe_volume          =     src.gas_boe_volume,
	    [data_mart].[t_fact_fdc].gas_mcfe_volume          =     src.gas_mcfe_volume,
	    [data_mart].[t_fact_fdc].oil_metric_volume          =     src.oil_metric_volume,
	    [data_mart].[t_fact_fdc].oil_imperial_volume          =     src.oil_imperial_volume,
		[data_mart].[t_fact_fdc].oil_boe_volume          =     src.oil_boe_volume,
		[data_mart].[t_fact_fdc].oil_mcfe_volume          =     src.oil_mcfe_volume,
		[data_mart].[t_fact_fdc].ethane_metric_volume          =     src.ethane_metric_volume,
		[data_mart].[t_fact_fdc].ethane_imperial_volume          =     src.ethane_imperial_volume,
		[data_mart].[t_fact_fdc].ethane_boe_volume          =     src.ethane_boe_volume,
		[data_mart].[t_fact_fdc].ethane_mcfe_volume          =     src.ethane_mcfe_volume,
		[data_mart].[t_fact_fdc].propane_metric_volume          =     src.propane_metric_volume,
		[data_mart].[t_fact_fdc].propane_imperial_volume          =     src.propane_imperial_volume,
		[data_mart].[t_fact_fdc].propane_boe_volume          =     src.propane_boe_volume,
		[data_mart].[t_fact_fdc].propane_mcfe_volume          =     src.propane_mcfe_volume,
		[data_mart].[t_fact_fdc].butane_metric_volume          =     src.butane_metric_volume,
		[data_mart].[t_fact_fdc].butane_imperial_volume          =     src.butane_imperial_volume,
		[data_mart].[t_fact_fdc].butane_boe_volume          =     src.butane_boe_volume,
		[data_mart].[t_fact_fdc].butane_mcfe_volume          =     src.butane_mcfe_volume,
		[data_mart].[t_fact_fdc].pentane_metric_volume          =     src.pentane_metric_volume,
		[data_mart].[t_fact_fdc].pentane_imperial_volume          =     src.pentane_imperial_volume,
		[data_mart].[t_fact_fdc].pentane_boe_volume          =     src.pentane_boe_volume,
		[data_mart].[t_fact_fdc].pentane_mcfe_volume          =     src.pentane_mcfe_volume,
		[data_mart].[t_fact_fdc].condensate_metric_volume          =     src.condensate_metric_volume,
		[data_mart].[t_fact_fdc].condensate_imperial_volume          =     src.condensate_imperial_volume,
		[data_mart].[t_fact_fdc].condensate_boe_volume          =     src.condensate_boe_volume,
		[data_mart].[t_fact_fdc].condensate_mcfe_volume          =     src.condensate_mcfe_volume,
		[data_mart].[t_fact_fdc].total_ngl_metric_volume          =     src.total_ngl_metric_volume,
		[data_mart].[t_fact_fdc].total_ngl_imperial_volume          =     src.total_ngl_imperial_volume,
		[data_mart].[t_fact_fdc].total_ngl_boe_volume          =     src.total_ngl_boe_volume,
		[data_mart].[t_fact_fdc].total_ngl_mcfe_volume          =     src.total_ngl_mcfe_volume,
		[data_mart].[t_fact_fdc].total_liquid_metric_volume          =     src.total_liquid_metric_volume,
		[data_mart].[t_fact_fdc].total_liquid_imperial_volume          =     src.total_liquid_imperial_volume,
		[data_mart].[t_fact_fdc].total_liquid_boe_volume          =     src.total_liquid_boe_volume,
		[data_mart].[t_fact_fdc].total_liquid_mcfe_volume          =     src.total_liquid_mcfe_volume,
		[data_mart].[t_fact_fdc].total_boe_volume          =     src.total_boe_volume,
		[data_mart].[t_fact_fdc].water_metric_volume          =     src.water_metric_volume,
		[data_mart].[t_fact_fdc].water_imperial_volume          =     src.water_imperial_volume,
		[data_mart].[t_fact_fdc].water_boe_volume          =     src.water_boe_volume,
		[data_mart].[t_fact_fdc].water_mcfe_volume          =     src.water_mcfe_volume,
		[data_mart].[t_fact_fdc].last_update_date		     = src.last_update_date
	FROM
		#t_fact_fdc_MERGE src
    WHERE      (  [data_mart].[t_fact_fdc].entity_key				= src.site_id
        AND	   [data_mart].[t_fact_fdc].activity_date_key		= src.activity_date_key
	    AND	   [data_mart].[t_fact_fdc].gross_net_key			= src.gross_net_key
		AND      [data_mart].[t_fact_fdc].data_type			    = src.data_type
	    AND      [data_mart].[t_fact_fdc].scenario_key			= src.scenario_key)
		AND FLAG = 'UPDATE'

	SELECT 1

	--COMMIT TRANSACTION
	
	--BEGIN TRANSACTION

	

	 -- count rows AFTER merge
	/* SELECT DISTINCT 
		@after_count=row_count
		FROM sys.dm_db_partition_stats
		WHERE object_id = OBJECT_ID('t_fact_fdc');
    */

	/* UPDATE [OLAPControl].[dbo].[t_Run_Job_Log]
	SET Inserted_count = ISNULL(@after_count - @before_count,0)
	WHERE RunID = @RunID --'996A578F-84DA-463A-AAFE-047118863BED' --@job_run_id
	;
	*/

	--COMMIT TRANSACTION

    --COMMIT TRANSACTION

	

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
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)


      

  END CATCH

 -- RETURN @@ERROR

END