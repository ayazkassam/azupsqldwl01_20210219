CREATE PROC [data_mart].[full_ihs_fdc_facts] AS
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
	WHERE data_type = 'IHS';
	
	--COMMIT TRANSACTION	
	
	--BEGIN TRANSACTION	

   IF OBJECT_ID('tempdb..#t_fact_fdc_MERGE') IS NOT NULL
      DROP TABLE #t_fact_fdc_MERGE	 

    CREATE TABLE #t_fact_fdc_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS	
	    SELECT
	      'NEW' Flag,
		  src.site_id,
          src.uwi entity_key,
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
	      src.hours_on
        FROM [stage].[v_fact_source_fdc_ihs_full] as src
      	LEFT JOIN [data_mart].[t_fact_fdc] as trg   
      	  ON trg.site_id				= src.site_id AND
             trg.activity_date_key		= src.activity_date_key AND
	         trg.gross_net_key			= src.gross_net_key AND
	         trg.scenario_key			= src.scenario_key
        WHERE
		  trg.site_id IS NULL AND			
		  trg.activity_date_key IS NULL AND	
		  trg.gross_net_key	IS NULL AND	
		  trg.scenario_key IS NULL	

        UNION ALL

	    SELECT
	      'UPDATE' Flag,
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
	      src.hours_on
        FROM
		  (
	         SELECT
			   src.site_id,
               src.uwi entity_key,
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
	           src.hours_on
             FROM [stage].[v_fact_source_fdc_ihs_full] as src
      	     INNER JOIN [data_mart].[t_fact_fdc] as trg   
      	       ON trg.site_id				= src.site_id AND
                  trg.activity_date_key		= src.activity_date_key AND
	              trg.gross_net_key			= src.gross_net_key AND
	              trg.scenario_key			= src.scenario_key

             EXCEPT

	         SELECT
			   trg.site_id,
               trg.entity_key,
	           trg.activity_date_key,
	           trg.scenario_key,
	           trg.data_type,
	           trg.gross_net_key,
	           trg.gas_metric_volume,
	           trg.gas_imperial_volume,
	           trg.gas_boe_volume,
	           trg.gas_mcfe_volume,
	           trg.oil_metric_volume,
	           trg.oil_imperial_volume,
	           trg.oil_boe_volume,
	           trg.oil_mcfe_volume,
	           trg.condensate_metric_volume,
	           trg.condensate_imperial_volume,
	           trg.condensate_boe_volume,
	           trg.condensate_mcfe_volume,
	           trg.total_ngl_metric_volume,
	           trg.total_ngl_imperial_volume,
	           trg.total_ngl_boe_volume,
	           trg.total_ngl_mcfe_volume,
	           trg.total_liquid_metric_volume,
	           trg.total_liquid_imperial_volume,
	           trg.total_liquid_boe_volume,
	           trg.total_liquid_mcfe_volume,
	           trg.total_boe_volume,
	           trg.water_metric_volume,
	           trg.water_imperial_volume,
	           trg.water_boe_volume,
	           trg.water_mcfe_volume,
	           trg.hours_on
             FROM
               [data_mart].[t_fact_fdc] as trg
		  ) src

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
	     total_ngl_metric_volume,
	     total_ngl_imperial_volume,
	     total_ngl_boe_volume,
	     total_ngl_mcfe_volume,
	     total_liquid_metric_volume,
	     total_liquid_imperial_volume,
	     total_liquid_boe_volume,
	     total_liquid_mcfe_volume,
	     total_boe_volume,
	     water_metric_volume,
	     water_imperial_volume,
	     water_boe_volume,
	     water_mcfe_volume,
	     hours_on,
	     last_update_date	    
	  )
	  SELECT
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
	    src.hours_on,
		current_timestamp
      FROM
	    #t_fact_fdc_MERGE src
      WHERE
	    Flag = 'NEW'
	
	UPDATE [data_mart].[t_fact_fdc]
	SET
	  [data_mart].[t_fact_fdc].data_type						 = UPD.data_type,
	  [data_mart].[t_fact_fdc].entity_key						 = UPD.entity_key,
	  [data_mart].[t_fact_fdc].gas_metric_volume              = UPD.gas_metric_volume,
	  [data_mart].[t_fact_fdc].gas_imperial_volume              = UPD.gas_imperial_volume,
	  [data_mart].[t_fact_fdc].gas_boe_volume              = UPD.gas_boe_volume,
	  [data_mart].[t_fact_fdc].gas_mcfe_volume              = UPD.gas_mcfe_volume,
	  [data_mart].[t_fact_fdc].oil_metric_volume              = UPD.oil_metric_volume,
	  [data_mart].[t_fact_fdc].oil_imperial_volume              = UPD.oil_imperial_volume,
	  [data_mart].[t_fact_fdc].oil_boe_volume              = UPD.oil_boe_volume,
	  [data_mart].[t_fact_fdc].oil_mcfe_volume              = UPD.oil_mcfe_volume,
	  [data_mart].[t_fact_fdc].condensate_metric_volume              = UPD.condensate_metric_volume,
	  [data_mart].[t_fact_fdc].condensate_imperial_volume              = UPD.condensate_imperial_volume,
	  [data_mart].[t_fact_fdc].condensate_boe_volume              = UPD.condensate_boe_volume,
	  [data_mart].[t_fact_fdc].condensate_mcfe_volume              = UPD.condensate_mcfe_volume,
	  [data_mart].[t_fact_fdc].total_ngl_metric_volume		      = UPD.total_ngl_metric_volume,
	  [data_mart].[t_fact_fdc].total_ngl_imperial_volume			  = UPD.total_ngl_imperial_volume,
	  [data_mart].[t_fact_fdc].total_ngl_boe_volume				  = UPD.total_ngl_boe_volume,
	  [data_mart].[t_fact_fdc].total_ngl_mcfe_volume				  = UPD.total_ngl_mcfe_volume,
	  [data_mart].[t_fact_fdc].total_liquid_metric_volume              = UPD.total_liquid_metric_volume,
	  [data_mart].[t_fact_fdc].total_liquid_imperial_volume              = UPD.total_liquid_imperial_volume,
	  [data_mart].[t_fact_fdc].total_liquid_boe_volume              = UPD.total_liquid_boe_volume,
	  [data_mart].[t_fact_fdc].total_liquid_mcfe_volume              = UPD.total_liquid_mcfe_volume,
	  [data_mart].[t_fact_fdc].total_boe_volume              = UPD.total_boe_volume,
	  [data_mart].[t_fact_fdc].water_metric_volume              = UPD.water_metric_volume,
	  [data_mart].[t_fact_fdc].water_imperial_volume              = UPD.water_imperial_volume,
	  [data_mart].[t_fact_fdc].water_boe_volume              = UPD.water_boe_volume,
	  [data_mart].[t_fact_fdc].water_mcfe_volume              = UPD.water_mcfe_volume,
	  [data_mart].[t_fact_fdc].hours_on		= UPD.hours_on,
	  [data_mart].[t_fact_fdc].last_update_date		      = current_timestamp
    FROM
	  #t_fact_fdc_MERGE UPD
    WHERE
      [data_mart].[t_fact_fdc].site_id				= UPD.site_id AND
      [data_mart].[t_fact_fdc].activity_date_key		= UPD.activity_date_key AND
	  [data_mart].[t_fact_fdc].gross_net_key			= UPD.gross_net_key AND
	  [data_mart].[t_fact_fdc].scenario_key			= UPD.scenario_key AND	
	  Flag = 'UPDATE'
      --	
      --
	--SET @rowcnt = @@ROWCOUNT

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