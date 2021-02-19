CREATE PROC [stage].[merge_incr_vouchers] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	
  --BEGIN TRANSACTION

    IF OBJECT_ID('tempdb..#t_qbyte_vouchers_MERGE') IS NOT NULL
      DROP TABLE #t_qbyte_vouchers_MERGE	 

    CREATE TABLE #t_qbyte_vouchers_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS	
	    SELECT
	      'NEW' Flag,
		  src.[VOUCHER_ID],
          src.[VOUCHER_NUM],
		  src.[VOUCHER_TYPE_CODE],
		  src.[ORG_ID],
		  src.[ACCT_PER_DATE],
		  src.[CURR_CODE],
		  src.[SRC_CODE],
		  src.[VOUCHER_STAT_CODE],
		  src.[CREATE_DATE],
		  src.[CREATE_USER],
		  src.[CTRL_AMT],
		  src.[CTRL_VOL],
		  src.[GL_POSTING_DATE],
		  src.[CURR_CONV_DATE],
		  src.[SRC_MODULE_ID],
		  src.[VOUCHER_REM],
		  src.[GL_POST_USER],
		  src.[LAST_UPDATE_DATE],
		  src.[LAST_UPDATE_USER],
		  src.[VOUCHER_REVERSAL_ID],
		  src.[JIB_RUN_NUM]
        FROM
          [stage].[t_qbyte_vouchers_incr] as src
        LEFT JOIN [stage].[t_qbyte_vouchers] as trg
          ON trg.voucher_id = src.voucher_id
        WHERE
		  trg.voucher_id IS NULL

        UNION ALL

	    SELECT
	      'UPDATE' Flag,
		  src.[VOUCHER_ID],
          src.[VOUCHER_NUM],
		  src.[VOUCHER_TYPE_CODE],
		  src.[ORG_ID],
		  src.[ACCT_PER_DATE],
		  src.[CURR_CODE],
		  src.[SRC_CODE],
		  src.[VOUCHER_STAT_CODE],
		  src.[CREATE_DATE],
		  src.[CREATE_USER],
		  src.[CTRL_AMT],
		  src.[CTRL_VOL],
		  src.[GL_POSTING_DATE],
		  src.[CURR_CONV_DATE],
		  src.[SRC_MODULE_ID],
		  src.[VOUCHER_REM],
		  src.[GL_POST_USER],
		  src.[LAST_UPDATE_DATE],
		  src.[LAST_UPDATE_USER],
		  src.[VOUCHER_REVERSAL_ID],
		  src.[JIB_RUN_NUM]
        FROM
		  (
	         SELECT
		       src.[VOUCHER_ID],
               src.[VOUCHER_NUM],
		       src.[VOUCHER_TYPE_CODE],
		       src.[ORG_ID],
		       src.[ACCT_PER_DATE],
		       src.[CURR_CODE],
		       src.[SRC_CODE],
		       src.[VOUCHER_STAT_CODE],
		       src.[CREATE_DATE],
		       src.[CREATE_USER],
		       src.[CTRL_AMT],
		       src.[CTRL_VOL],
		       src.[GL_POSTING_DATE],
		       src.[CURR_CONV_DATE],
		       src.[SRC_MODULE_ID],
		       src.[VOUCHER_REM],
		       src.[GL_POST_USER],
		       src.[LAST_UPDATE_DATE],
		       src.[LAST_UPDATE_USER],
		       src.[VOUCHER_REVERSAL_ID],
		       src.[JIB_RUN_NUM]
             FROM
               [stage].[t_qbyte_vouchers_incr] as src
             INNER JOIN [stage].[t_qbyte_vouchers] as trg
               ON trg.voucher_id = src.voucher_id

             EXCEPT

	         SELECT
		       trg.[VOUCHER_ID],
               trg.[VOUCHER_NUM],
		       trg.[VOUCHER_TYPE_CODE],
		       trg.[ORG_ID],
		       trg.[ACCT_PER_DATE],
		       trg.[CURR_CODE],
		       trg.[SRC_CODE],
		       trg.[VOUCHER_STAT_CODE],
		       trg.[CREATE_DATE],
		       trg.[CREATE_USER],
		       trg.[CTRL_AMT],
		       trg.[CTRL_VOL],
		       trg.[GL_POSTING_DATE],
		       trg.[CURR_CONV_DATE],
		       trg.[SRC_MODULE_ID],
		       trg.[VOUCHER_REM],
		       trg.[GL_POST_USER],
		       trg.[LAST_UPDATE_DATE],
		       trg.[LAST_UPDATE_USER],
		       trg.[VOUCHER_REVERSAL_ID],
		       trg.[JIB_RUN_NUM]
             FROM
               [stage].[t_qbyte_vouchers] as trg
		  ) src

	INSERT INTO [stage].[t_qbyte_vouchers]
	  (
		[VOUCHER_ID],
        [VOUCHER_NUM],
		[VOUCHER_TYPE_CODE],
		[ORG_ID],
		[ACCT_PER_DATE],
		[CURR_CODE],
		[SRC_CODE],
		[VOUCHER_STAT_CODE],
		[CREATE_DATE],
		[CREATE_USER],
		[CTRL_AMT],
		[CTRL_VOL],
		[GL_POSTING_DATE],
		[CURR_CONV_DATE],
		[SRC_MODULE_ID],
		[VOUCHER_REM],
		[GL_POST_USER],
		[LAST_UPDATE_DATE],
		[LAST_UPDATE_USER],
		[VOUCHER_REVERSAL_ID],
		[JIB_RUN_NUM]	    
	  )
	  SELECT
		src.[VOUCHER_ID],
        src.[VOUCHER_NUM],
		src.[VOUCHER_TYPE_CODE],
		src.[ORG_ID],
		src.[ACCT_PER_DATE],
		src.[CURR_CODE],
		src.[SRC_CODE],
		src.[VOUCHER_STAT_CODE],
		src.[CREATE_DATE],
		src.[CREATE_USER],
		src.[CTRL_AMT],
		src.[CTRL_VOL],
		src.[GL_POSTING_DATE],
		src.[CURR_CONV_DATE],
		src.[SRC_MODULE_ID],
		src.[VOUCHER_REM],
		src.[GL_POST_USER],
		src.[LAST_UPDATE_DATE],
		src.[LAST_UPDATE_USER],
		src.[VOUCHER_REVERSAL_ID],
		src.[JIB_RUN_NUM]
      FROM
	    #t_qbyte_vouchers_MERGE src
      WHERE
	    Flag = 'NEW'

	------ ROW_COUNT
	--DECLARE  @rowcnt INT
	--EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	UPDATE [stage].[t_qbyte_vouchers]
	SET
		[stage].[t_qbyte_vouchers].[VOUCHER_NUM]               =  UPD.[VOUCHER_NUM],
		[stage].[t_qbyte_vouchers].[VOUCHER_TYPE_CODE]         =  UPD.[VOUCHER_TYPE_CODE],
		[stage].[t_qbyte_vouchers].[ORG_ID]                    =  UPD.[ORG_ID],
		[stage].[t_qbyte_vouchers].[ACCT_PER_DATE]             =  UPD.[ACCT_PER_DATE],
		[stage].[t_qbyte_vouchers].[CURR_CODE]                 =  UPD.[CURR_CODE],
		[stage].[t_qbyte_vouchers].[SRC_CODE]                  =  UPD.[SRC_CODE],
		[stage].[t_qbyte_vouchers].[VOUCHER_STAT_CODE]         =  UPD.[VOUCHER_STAT_CODE],
		[stage].[t_qbyte_vouchers].[CREATE_DATE]               =  UPD.[CREATE_DATE],
		[stage].[t_qbyte_vouchers].[CREATE_USER]               =  UPD.[CREATE_USER],
		[stage].[t_qbyte_vouchers].[CTRL_AMT]                  =  UPD.[CTRL_AMT],
		[stage].[t_qbyte_vouchers].[CTRL_VOL]                  =  UPD.[CTRL_VOL],
		[stage].[t_qbyte_vouchers].[GL_POSTING_DATE]           =  UPD.[GL_POSTING_DATE],
		[stage].[t_qbyte_vouchers].[CURR_CONV_DATE]            =  UPD.[CURR_CONV_DATE],
		[stage].[t_qbyte_vouchers].[SRC_MODULE_ID]             =  UPD.[SRC_MODULE_ID],
		[stage].[t_qbyte_vouchers].[VOUCHER_REM]               =  UPD.[VOUCHER_REM],
		[stage].[t_qbyte_vouchers].[GL_POST_USER]              =  UPD.[GL_POST_USER],
		[stage].[t_qbyte_vouchers].[LAST_UPDATE_DATE]          =  UPD.[LAST_UPDATE_DATE],
		[stage].[t_qbyte_vouchers].[LAST_UPDATE_USER]          =  UPD.[LAST_UPDATE_USER],
		[stage].[t_qbyte_vouchers].[VOUCHER_REVERSAL_ID]       =  UPD.[VOUCHER_REVERSAL_ID],
		[stage].[t_qbyte_vouchers].[JIB_RUN_NUM]               =  UPD.[JIB_RUN_NUM]
    FROM
	  #t_qbyte_vouchers_MERGE UPD
	WHERE
	  [stage].[t_qbyte_vouchers].voucher_id = UPD.voucher_id
	
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
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)     

  END CATCH

  --RETURN @@ERROR

END