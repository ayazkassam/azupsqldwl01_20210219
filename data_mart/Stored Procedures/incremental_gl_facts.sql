CREATE PROC [data_mart].[incremental_gl_facts] AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  BEGIN TRY	
	
	--BEGIN TRANSACTION	
    IF OBJECT_ID('tempdb..#t_fact_gl_MERGE') IS NOT NULL
      DROP TABLE #t_fact_gl_MERGE	 

    CREATE TABLE #t_fact_gl_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS	
	    SELECT
	      'NEW' Flag,	
	      s.[li_id],
	      s.[voucher_id],
	      s.[entity_key],
	      s.[afe_key],
	      s.[account_key],
	      s.[accounting_month_key],
	      s.[activity_month_key],
	      s.[organization_key],
	      s.[gross_net_key],
	      s.[vendor_key],
	      s.[scenario_key],
	      s.[cad],
	      s.[usd],
	      s.[metric_volume],
	      s.[imperial_volume],
	      s.[boe_volume],
	      s.[mcfe_volume],
	      s.[qb_cad],
	      s.[qb_metric_volume],
	      s.[qb_imperial_volume],
	      s.[qb_boe_volume],
	      s.[qb_mcfe_volume],
	      s.[cad_fixed],
	      s.[cad_variable],
	      s.[cad_econ_fixed],
	      s.[cad_econ_variable_gas],
	      s.[cad_econ_variable_oil],
	      s.[is_leaseops],
	      s.[is_capital],
	      s.[is_volumes],
	      s.[is_valnav],
	      s.[is_finance]
		FROM 
		  [stage].[v_fact_source_qbyte_incr] s
	    LEFT JOIN [data_mart].[t_fact_gl] t
	      ON t.li_id = s.li_id AND
		     t.gross_net_key = s.gross_net_key
        WHERE
	      t.li_id IS NULL AND
		  t.gross_net_key IS NULL

        UNION ALL

		SELECT
	      'UPDATE' Flag,	
	      s.[li_id],
	      s.[voucher_id],
	      s.[entity_key],
	      s.[afe_key],
	      s.[account_key],
	      s.[accounting_month_key],
	      s.[activity_month_key],
	      s.[organization_key],
	      s.[gross_net_key],
	      s.[vendor_key],
	      s.[scenario_key],
	      s.[cad],
	      s.[usd],
	      s.[metric_volume],
	      s.[imperial_volume],
	      s.[boe_volume],
	      s.[mcfe_volume],
	      s.[qb_cad],
	      s.[qb_metric_volume],
	      s.[qb_imperial_volume],
	      s.[qb_boe_volume],
	      s.[qb_mcfe_volume],
	      s.[cad_fixed],
	      s.[cad_variable],
	      s.[cad_econ_fixed],
	      s.[cad_econ_variable_gas],
	      s.[cad_econ_variable_oil],
	      s.[is_leaseops],
	      s.[is_capital],
	      s.[is_volumes],
	      s.[is_valnav],
	      s.[is_finance]
        FROM
		  (
		    SELECT
	          s.[li_id],
	          s.[voucher_id],
	          s.[entity_key],
	          s.[afe_key],
	          s.[account_key],
	          s.[accounting_month_key],
	          s.[activity_month_key],
	          s.[organization_key],
	          s.[gross_net_key],
	          s.[vendor_key],
	          s.[scenario_key],
	          s.[cad],
	          s.[usd],
	          s.[metric_volume],
	          s.[imperial_volume],
	          s.[boe_volume],
	          s.[mcfe_volume],
	          s.[qb_cad],
	          s.[qb_metric_volume],
	          s.[qb_imperial_volume],
	          s.[qb_boe_volume],
	          s.[qb_mcfe_volume],
	          s.[cad_fixed],
	          s.[cad_variable],
	          s.[cad_econ_fixed],
	          s.[cad_econ_variable_gas],
	          s.[cad_econ_variable_oil],
	          s.[is_leaseops],
	          s.[is_capital],
	          s.[is_volumes],
	          s.[is_valnav],
	          s.[is_finance]
		    FROM 
		      [stage].[v_fact_source_qbyte_incr] s
	        INNER JOIN [data_mart].[t_fact_gl] t
	          ON t.li_id = s.li_id AND
		         t.gross_net_key = s.gross_net_key

            EXCEPT

	        SELECT
	          t.[li_id],
	          t.[voucher_id],
	          t.[entity_key],
	          t.[afe_key],
	          t.[account_key],
	          t.[accounting_month_key],
	          t.[activity_month_key],
	          t.[organization_key],
	          t.[gross_net_key],
	          t.[vendor_key],
	          t.[scenario_key],
	          t.[cad],
	          t.[usd],
	          t.[metric_volume],
	          t.[imperial_volume],
	          t.[boe_volume],
	          t.[mcfe_volume],
	          t.[qb_cad],
	          t.[qb_metric_volume],
	          t.[qb_imperial_volume],
	          t.[qb_boe_volume],
	          t.[qb_mcfe_volume],
	          t.[cad_fixed],
	          t.[cad_variable],
	          t.[cad_econ_fixed],
	          t.[cad_econ_variable_gas],
	          t.[cad_econ_variable_oil],
	          t.[is_leaseops],
	          t.[is_capital],
	          t.[is_volumes],
	          t.[is_valnav],
	          t.[is_finance]
		    FROM 
		      [data_mart].[t_fact_gl] t
		  ) s

    INSERT INTO [data_mart].[t_fact_gl]
	  (
         [li_id],
	     [voucher_id],
	     [entity_key],
	     [afe_key],
	     [account_key],
	     [accounting_month_key],
	     [activity_month_key],
	     [organization_key],
	     [gross_net_key],
	     [vendor_key],
	     [scenario_key],
	     [cad],
	     [usd],
	     [metric_volume],
	     [imperial_volume],
	     [boe_volume],
	     [mcfe_volume],
	     [qb_cad],
	     [qb_metric_volume],
	     [qb_imperial_volume],
	     [qb_boe_volume],
	     [qb_mcfe_volume],
	     [cad_fixed],
	     [cad_variable],
	     [cad_econ_fixed],
	     [cad_econ_variable_gas],
	     [cad_econ_variable_oil],
	     [is_leaseops],
	     [is_capital],
	     [is_volumes],
	     [is_valnav],
	     [is_finance]
	  )
	  SELECT
        [li_id],
	    [voucher_id],
	    [entity_key],
	    [afe_key],
	    [account_key],
	    [accounting_month_key],
	    [activity_month_key],
	    [organization_key],
	    [gross_net_key],
	    [vendor_key],
	    [scenario_key],
	    [cad],
	    [usd],
	    [metric_volume],
	    [imperial_volume],
	    [boe_volume],
	    [mcfe_volume],
	    [qb_cad],
	    [qb_metric_volume],
	    [qb_imperial_volume],
	    [qb_boe_volume],
	    [qb_mcfe_volume],
	    [cad_fixed],
	    [cad_variable],
	    [cad_econ_fixed],
	    [cad_econ_variable_gas],
	    [cad_econ_variable_oil],
	    [is_leaseops],
	    [is_capital],
	    [is_volumes],
	    [is_valnav],
	    [is_finance]
	  FROM
	    #t_fact_gl_MERGE
      WHERE
	    Flag = 'NEW'

	------ ROW_COUNT
	DECLARE  @rowcnt INT
	EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	UPDATE [data_mart].[t_fact_gl]
	SET
	  [data_mart].[t_fact_gl].scenario_key					=  UPD.scenario_key,
	  [data_mart].[t_fact_gl].cad							=  UPD.cad,
	  [data_mart].[t_fact_gl].usd							=  UPD.usd,
	  [data_mart].[t_fact_gl].metric_volume					=  UPD.metric_volume,
	  [data_mart].[t_fact_gl].imperial_volume				=  UPD.imperial_volume,
	  [data_mart].[t_fact_gl].boe_volume					=  UPD.boe_volume,
	  [data_mart].[t_fact_gl].mcfe_volume					=  UPD.mcfe_volume,
	  [data_mart].[t_fact_gl].qb_cad						=  UPD.qb_cad,
	  [data_mart].[t_fact_gl].qb_metric_volume				=  UPD.qb_metric_volume,
	  [data_mart].[t_fact_gl].qb_imperial_volume			=  UPD.qb_imperial_volume,
	  [data_mart].[t_fact_gl].qb_boe_volume					=  UPD.qb_boe_volume,
	  [data_mart].[t_fact_gl].qb_mcfe_volume				=  UPD.qb_mcfe_volume,
	  [data_mart].[t_fact_gl].cad_fixed						=  UPD.cad_fixed,
	  [data_mart].[t_fact_gl].cad_variable					=  UPD.cad_variable,
	  [data_mart].[t_fact_gl].cad_econ_fixed				=  UPD.cad_econ_fixed,
	  [data_mart].[t_fact_gl].cad_econ_variable_gas			=  UPD.cad_econ_variable_gas,
	  [data_mart].[t_fact_gl].cad_econ_variable_oil			=  UPD.cad_econ_variable_oil,
	  [data_mart].[t_fact_gl].is_leaseops					=  UPD.is_leaseops,
	  [data_mart].[t_fact_gl].is_capital					=  UPD.is_capital,
	  [data_mart].[t_fact_gl].is_volumes					=  UPD.is_volumes,
	  [data_mart].[t_fact_gl].is_valnav						=  UPD.is_valnav,
	  [data_mart].[t_fact_gl].is_finance					=  UPD.is_finance
    FROM #t_fact_gl_MERGE UPD
    WHERE 
      [data_mart].[t_fact_gl].li_id = UPD.li_id AND
	  [data_mart].[t_fact_gl].gross_net_key = UPD.gross_net_key	AND  
	  UPD.Flag = 'UPDATE'	

      SELECT @rowcnt INSERTED

  --  COMMIT TRANSACTION

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