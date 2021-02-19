CREATE PROC [data_mart].[incremental_t_fact_leaseops_opex_accruals] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  BEGIN TRY	
	
    --BEGIN TRANSACTION		
  
      IF OBJECT_ID('tempdb..#t_fact_leaseops_opex_accruals_MERGE') IS NOT NULL
        DROP TABLE #t_fact_leaseops_opex_accruals_MERGE	 

      CREATE TABLE #t_fact_leaseops_opex_accruals_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
        SELECT
	      'NEW' Flag,
	      src.[entity_key],
	      src.[account_key],
	      src.[accounting_month_key],
	      src.[activity_month_key],
	      src.[gross_net_key],
	      src.[vendor_key],
	      src.[scenario_key],
	      src.[cad]
        FROM
		  [stage].[v_fact_source_leaseops_opex_accruals] src
        LEFT JOIN [data_mart].[t_fact_leaseops_opex_accruals] as trg
		  ON trg.scenario_key			= src.scenario_key AND
	         trg.entity_key				= src.entity_key AND
	         trg.accounting_month_key	= src.accounting_month_key AND
	         trg.activity_month_key	    = src.activity_month_key AND
	         ISNULL(trg.account_key, -1)	= ISNULL(src.account_key, -1) AND
	         trg.gross_net_key			= src.gross_net_key AND
	         trg.vendor_key				= src.vendor_key
        WHERE
		  trg.scenario_key IS NULL AND			
		  trg.entity_key IS NULL AND				
		  trg.accounting_month_key IS NULL AND	
		  trg.activity_month_key IS NULL AND	    
		  trg.account_key IS NULL AND			
		  trg.gross_net_key IS NULL	AND	
		  trg.vendor_key IS NULL	
		  
        UNION ALL

	    SELECT
		  'UPDATE' Flag,
	      src.[entity_key],
	      src.[account_key],
	      src.[accounting_month_key],
	      src.[activity_month_key],
	      src.[gross_net_key],
	      src.[vendor_key],
	      src.[scenario_key],
	      src.[cad]
        FROM
		  (
             SELECT
	           src.[entity_key],
	           src.[account_key],
	           src.[accounting_month_key],
	           src.[activity_month_key],
	           src.[gross_net_key],
	           src.[vendor_key],
	           src.[scenario_key],
	           src.[cad]
             FROM
		       [stage].[v_fact_source_leaseops_opex_accruals] src
             INNER JOIN [data_mart].[t_fact_leaseops_opex_accruals] as trg
		       ON trg.scenario_key			= src.scenario_key AND
	              trg.entity_key				= src.entity_key AND
	              trg.accounting_month_key	= src.accounting_month_key AND
	              trg.activity_month_key	    = src.activity_month_key AND
	              trg.account_key			= src.account_key AND
	              trg.gross_net_key			= src.gross_net_key AND
	              trg.vendor_key				= src.vendor_key

             EXCEPT

             SELECT
	           trg.[entity_key],
	           trg.[account_key],
	           trg.[accounting_month_key],
	           trg.[activity_month_key],
	           trg.[gross_net_key],
	           trg.[vendor_key],
	           trg.[scenario_key],
	           trg.[cad]
             FROM
		       [data_mart].[t_fact_leaseops_opex_accruals] as trg
		  ) src

      INSERT INTO [data_mart].[t_fact_leaseops_opex_accruals]
	    (
	       [entity_key],
	       [account_key],
	       [accounting_month_key],
	       [activity_month_key],
	       [gross_net_key],
	       [vendor_key],
	       [scenario_key],
	       [cad]
		)
        SELECT
	      src.[entity_key],
	      src.[account_key],
	      src.[accounting_month_key],
	      src.[activity_month_key],
	      src.[gross_net_key],
	      src.[vendor_key],
	      src.[scenario_key],
	      src.[cad]
        FROM
		  #t_fact_leaseops_opex_accruals_MERGE src
        WHERE
		  Flag = 'NEW'
	

	  ------ ROW_COUNT
	  DECLARE  @rowcnt INT
	  EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

      UPDATE [data_mart].[t_fact_leaseops_opex_accruals]
      SET
	    [data_mart].[t_fact_leaseops_opex_accruals].cad =  UPD.cad
      FROM #t_fact_leaseops_opex_accruals_MERGE UPD
      WHERE 
        [data_mart].[t_fact_leaseops_opex_accruals].scenario_key			= UPD.scenario_key AND
	    [data_mart].[t_fact_leaseops_opex_accruals].entity_key				= UPD.entity_key AND
	    [data_mart].[t_fact_leaseops_opex_accruals].accounting_month_key	= UPD.accounting_month_key AND
	    [data_mart].[t_fact_leaseops_opex_accruals].activity_month_key	    = UPD.activity_month_key AND
	    [data_mart].[t_fact_leaseops_opex_accruals].account_key			    = UPD.account_key AND
	    [data_mart].[t_fact_leaseops_opex_accruals].gross_net_key			= UPD.gross_net_key AND
	    [data_mart].[t_fact_leaseops_opex_accruals].vendor_key				= UPD.vendor_key AND
	    UPD.Flag = 'UPDATE'	

	--SET @rowcnt = @@ROWCOUNT

    SELECT @rowcnt INSERTED
   -- COMMIT TRANSACTION
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