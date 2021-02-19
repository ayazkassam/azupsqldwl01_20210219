CREATE PROC [data_mart].[full_qbyte_fdc_facts] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @before_count as INT, @after_count as INT

BEGIN TRY	

    -- count rows before merge

	-- SELECT DISTINCT 
	--	@before_count=row_count
	--	FROM sys.dm_db_partition_stats
	--	WHERE object_id = OBJECT_ID('t_fact_fdc');

    -- Merge IHS Full Volumes
	
	DELETE 
	FROM [data_mart].[t_fact_fdc]
	WHERE data_type='QBYTE';

	
	--BEGIN TRANSACTION	
	IF OBJECT_ID('tempdb..#t_fact_fdc_MERGE') IS NOT NULL
      DROP TABLE #t_fact_fdc_MERGE	 

	CREATE TABLE #t_fact_gl_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS	
	    SELECT
			CASE WHEN facts.site_id is null
						AND	   facts.activity_date_key is null
						AND	   facts.gross_net_key is null
						AND    facts.scenario_key is null THEN 'NEW'
				ELSE 'UPDATE'
			END Flag,
			src.site_id,
			src.entity_key,
			src.activity_date_key,
			src.scenario_key,
			src.data_type,
			src.gross_net_key,
			src.gas_metric_volume,
			src.gas_imperial_volume,
			src.gas_boe_volume,
			src.gas_mcfe_volume,
			src.oil_metric_volume,
			src.oil_imperial_volume,
			src.oil_boe_volume,
			src.oil_mcfe_volume,
			src.cond_metric_volume,
			src.cond_imperial_volume,
			src.cond_boe_volume,
			src.cond_mcfe_volume,
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
			src.total_liquid_metric_volume,
			src.total_liquid_imperial_volume,
			src.total_liquid_boe_volume,
			src.total_liquid_mcfe_volume,
			src.total_ngl_metric_volume,
			src.total_ngl_imperial_volume,
			src.total_ngl_boe_volume,
			src.total_ngl_mcfe_volume,
			src.total_boe_volume,
			current_timestamp last_update_date
	FROM 
		[stage].[v_fact_source_fdc_qbyte_sales_full] src
		left join [data_mart].[t_fact_fdc] as facts
			  	ON      (  facts.site_id				= src.site_id
					AND	   facts.activity_date_key		= src.activity_date_key
					AND	   facts.gross_net_key			= src.gross_net_key
					AND    facts.scenario_key			= src.scenario_key) 
	
	INSERT INTO [data_mart].[t_fact_fdc]
	(
		 site_id,
       entity_key,
	   activity_date_key,
	   scenario_key,
	   data_type,
	   gross_net_key,
	   gas_metric_volume,
	   gas_imperial_volume,
	   gas_boe_volume,
	   gas_mcfe_volume,
	   oil_metric_volume,
	   oil_imperial_volume,
	   oil_boe_volume,
	   oil_mcfe_volume,
	   condensate_metric_volume,
	   condensate_imperial_volume,
	   condensate_boe_volume,
	   condensate_mcfe_volume,
	   ethane_metric_volume,
	   ethane_imperial_volume,
	   ethane_boe_volume,
	   ethane_mcfe_volume,
	   propane_metric_volume,
	   propane_imperial_volume,
	   propane_boe_volume,
	   propane_mcfe_volume,
	   butane_metric_volume,
	   butane_imperial_volume,
	   butane_boe_volume,
	   butane_mcfe_volume,
	   pentane_metric_volume,
	   pentane_imperial_volume,
	   pentane_boe_volume,
	   pentane_mcfe_volume,
	   total_liquid_metric_volume,
	   total_liquid_imperial_volume,
	   total_liquid_boe_volume,
	   total_liquid_mcfe_volume,
	   total_ngl_metric_volume,
	   total_ngl_imperial_volume,
	   total_ngl_boe_volume,
	   total_ngl_mcfe_volume,
	   total_boe_volume,
	   last_update_date
	)
	SELECT
		 site_id,
       entity_key,
	   activity_date_key,
	   scenario_key,
	   data_type,
	   gross_net_key,
	   gas_metric_volume,
	   gas_imperial_volume,
	   gas_boe_volume,
	   gas_mcfe_volume,
	   oil_metric_volume,
	   oil_imperial_volume,
	   oil_boe_volume,
	   oil_mcfe_volume,
	   cond_metric_volume,
	   cond_imperial_volume,
	   cond_boe_volume,
	   cond_mcfe_volume,
	   ethane_metric_volume,
	   ethane_imperial_volume,
	   ethane_boe_volume,
	   ethane_mcfe_volume,
	   propane_metric_volume,
	   propane_imperial_volume,
	   propane_boe_volume,
	   propane_mcfe_volume,
	   butane_metric_volume,
	   butane_imperial_volume,
	   butane_boe_volume,
	   butane_mcfe_volume,
	   pentane_metric_volume,
	   pentane_imperial_volume,
	   pentane_boe_volume,
	   pentane_mcfe_volume,
	   total_liquid_metric_volume,
	   total_liquid_imperial_volume,
	   total_liquid_boe_volume,
	   total_liquid_mcfe_volume,
	   total_ngl_metric_volume,
	   total_ngl_imperial_volume,
	   total_ngl_boe_volume,
	   total_ngl_mcfe_volume,
	   total_boe_volume,
	   last_update_date
	FROM #t_fact_gl_MERGE
	WHERE
		Flag = 'NEW'

	UPDATE [data_mart].[t_fact_fdc]
		SET
			[data_mart].[t_fact_fdc].data_type						 = src.data_type,
	        [data_mart].[t_fact_fdc].entity_key						 = src.entity_key,
	    	[data_mart].[t_fact_fdc].gas_metric_volume              = src.gas_metric_volume,
	    	[data_mart].[t_fact_fdc].gas_imperial_volume              = src.gas_imperial_volume,
	    	[data_mart].[t_fact_fdc].gas_boe_volume              = src.gas_boe_volume,
	    	[data_mart].[t_fact_fdc].gas_mcfe_volume              = src.gas_mcfe_volume,
	    	[data_mart].[t_fact_fdc].oil_metric_volume              = src.oil_metric_volume,
	    	[data_mart].[t_fact_fdc].oil_imperial_volume              = src.oil_imperial_volume,
			[data_mart].[t_fact_fdc].oil_boe_volume              = src.oil_boe_volume,
		    [data_mart].[t_fact_fdc].oil_mcfe_volume              = src.oil_mcfe_volume,
		    [data_mart].[t_fact_fdc].condensate_metric_volume              = src.cond_metric_volume,
		    [data_mart].[t_fact_fdc].condensate_imperial_volume              = src.cond_imperial_volume,
		    [data_mart].[t_fact_fdc].condensate_boe_volume              = src.cond_boe_volume,
		    [data_mart].[t_fact_fdc].condensate_mcfe_volume              = src.cond_mcfe_volume,
			[data_mart].[t_fact_fdc].ethane_metric_volume              = src.ethane_metric_volume,
		    [data_mart].[t_fact_fdc].ethane_imperial_volume              = src.ethane_imperial_volume,
		    [data_mart].[t_fact_fdc].ethane_boe_volume              = src.ethane_boe_volume,
		    [data_mart].[t_fact_fdc].ethane_mcfe_volume              = src.ethane_mcfe_volume,
			[data_mart].[t_fact_fdc].propane_metric_volume              = src.propane_metric_volume,
		    [data_mart].[t_fact_fdc].propane_imperial_volume              = src.propane_imperial_volume,
		    [data_mart].[t_fact_fdc].propane_boe_volume              = src.propane_boe_volume,
		    [data_mart].[t_fact_fdc].propane_mcfe_volume              = src.propane_mcfe_volume,
			[data_mart].[t_fact_fdc].butane_metric_volume              = src.butane_metric_volume,
		    [data_mart].[t_fact_fdc].butane_imperial_volume              = src.butane_imperial_volume,
		    [data_mart].[t_fact_fdc].butane_boe_volume              = src.butane_boe_volume,
		    [data_mart].[t_fact_fdc].butane_mcfe_volume              = src.butane_mcfe_volume,
			[data_mart].[t_fact_fdc].pentane_metric_volume              = src.pentane_metric_volume,
		    [data_mart].[t_fact_fdc].pentane_imperial_volume              = src.pentane_imperial_volume,
		    [data_mart].[t_fact_fdc].pentane_boe_volume              = src.pentane_boe_volume,
		    [data_mart].[t_fact_fdc].pentane_mcfe_volume              = src.pentane_mcfe_volume,
		    [data_mart].[t_fact_fdc].total_liquid_metric_volume              = src.total_liquid_metric_volume,
		    [data_mart].[t_fact_fdc].total_liquid_imperial_volume              = src.total_liquid_imperial_volume,
		    [data_mart].[t_fact_fdc].total_liquid_boe_volume              = src.total_liquid_boe_volume,
		    [data_mart].[t_fact_fdc].total_liquid_mcfe_volume              = src.total_liquid_mcfe_volume,
			[data_mart].[t_fact_fdc].total_ngl_metric_volume              = src.total_ngl_metric_volume,
		    [data_mart].[t_fact_fdc].total_ngl_imperial_volume              = src.total_ngl_imperial_volume,
		    [data_mart].[t_fact_fdc].total_ngl_boe_volume              = src.total_ngl_boe_volume,
		    [data_mart].[t_fact_fdc].total_ngl_mcfe_volume              = src.total_ngl_mcfe_volume,
		    [data_mart].[t_fact_fdc].total_boe_volume              = src.total_boe_volume,
		    [data_mart].[t_fact_fdc].last_update_date		      = src.last_update_date	
	FROM
		#t_fact_gl_MERGE src
	WHERE		   [data_mart].[t_fact_fdc].site_id				= src.site_id
          AND	   [data_mart].[t_fact_fdc].activity_date_key		= src.activity_date_key
	      AND	   [data_mart].[t_fact_fdc].gross_net_key			= src.gross_net_key
	      AND      [data_mart].[t_fact_fdc].scenario_key			= src.scenario_key
		  AND	   src.Flag = 'UPDATE'	

      --
	SELECT COUNT(*) FROM #t_fact_gl_MERGE


	--COMMIT TRANSACTION
	
	--BEGIN TRANSACTION

	

	 -- count rows AFTER merge
	 /*SELECT DISTINCT 
		@after_count=row_count
		FROM sys.dm_db_partition_stats
		WHERE object_id = OBJECT_ID('t_fact_fdc');
     */

	/* UPDATE [OLAPControl].[t_Run_Job_Log]
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
			--	,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		-- If the error renders the transaction as uncommittable or we have open transactions, rollback
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)


      

  END CATCH

  --RETURN @@ERROR

END