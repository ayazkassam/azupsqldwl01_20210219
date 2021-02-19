﻿CREATE PROC [Stage].[merge_incr_line_items] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	
	BEGIN TRANSACTION
	
	delete
	from
		stage.[t_qbyte_line_items]
		where
			li_id in (select  li_id from stage.[t_qbyte_line_items_incr]	trg)
 
    insert into stage.[t_qbyte_line_items]
	(
		VOUCHER_ID, CREATE_DATE, CREATE_USER, LAST_UPDATE_DATE, LAST_UPDATE_USER, 
			LI_ID, LI_ORIGIN_CODE, MAJOR_ACCT, MINOR_ACCT, LI_AMT, GL_SUB_CODE, 
			AFE_ITEM_NUM, DEST_ORG_ID, LI_TYPE_CODE, REPORTING_CURR_AMT, GST_AMT,
			GST_FACTOR, ORG_REP_CURR_AMT, ORG_REP_CURR_TRANSLATION_RATE, ORG_REP_CURR_GROSS_UP_AMT, 
			LI_VOL, TRANSLATION_RATE, ACTVY_PER_DATE, ALLOC_DATE, BILLED_DATE, 
			AFE_NUM, CONTINUITY_CODE, CASH_TX_ID, CC_NUM, SRC_INVC_ID, 
			RESULT_INVC_ID, ORIGINAL_LI_ID, SRC_AGR_ID, SRC_AGR_TYPE_CODE, 
			GOVERN_AGR_ID, GOVERN_AGR_TYPE_CODE, GROSS_UP_AMT, GROSS_UP_VOL, 
			LI_REM, ET_ID, REPORTING_CURR_GROSS_UP_AMT, LI_AS_ENTERED_VOL, 
			ALLOC_LI_ID, PRE_TAX_AMT, REPORTING_CURR_GST_AMT, LI_ENERGY_AMOUNT, 
			WAREHOUSE_HANDLING_FLAG, GROSS_UP_ENERGY_VAL, JIB_REVERSED_FLAG, 
			DISCOUNT_AMT, MISCELLANEOUS_INCOME_CATEGORY, PO_DISTRIBUTION_ID, POTR_ID, 
			GOVERN_AGR_OVERRIDE_FLAG, ALLOCATION_REVERSED_FLAG	
	)
	SELECT 
			VOUCHER_ID, CREATE_DATE, CREATE_USER, LAST_UPDATE_DATE, LAST_UPDATE_USER, 
			LI_ID, LI_ORIGIN_CODE, MAJOR_ACCT, MINOR_ACCT, LI_AMT, GL_SUB_CODE, 
			AFE_ITEM_NUM, DEST_ORG_ID, LI_TYPE_CODE, REPORTING_CURR_AMT, GST_AMT,
			GST_FACTOR, ORG_REP_CURR_AMT, ORG_REP_CURR_TRANSLATION_RATE, ORG_REP_CURR_GROSS_UP_AMT, 
			LI_VOL, TRANSLATION_RATE, ACTVY_PER_DATE, ALLOC_DATE, BILLED_DATE, 
			AFE_NUM, CONTINUITY_CODE, CASH_TX_ID, CC_NUM, SRC_INVC_ID, 
			RESULT_INVC_ID, ORIGINAL_LI_ID, SRC_AGR_ID, SRC_AGR_TYPE_CODE, 
			GOVERN_AGR_ID, GOVERN_AGR_TYPE_CODE, GROSS_UP_AMT, GROSS_UP_VOL, 
			LI_REM, ET_ID, REPORTING_CURR_GROSS_UP_AMT, LI_AS_ENTERED_VOL, 
			ALLOC_LI_ID, PRE_TAX_AMT, REPORTING_CURR_GST_AMT, LI_ENERGY_AMOUNT, 
			WAREHOUSE_HANDLING_FLAG, GROSS_UP_ENERGY_VAL, JIB_REVERSED_FLAG, 
			DISCOUNT_AMT, MISCELLANEOUS_INCOME_CATEGORY, PO_DISTRIBUTION_ID, POTR_ID, 
			GOVERN_AGR_OVERRIDE_FLAG, ALLOCATION_REVERSED_FLAG	
	FROM
			stage.[t_qbyte_line_items_incr]
							
	SELECT COUNT(*) INSERTED FROM stage.[t_qbyte_line_items_incr]

    COMMIT TRANSACTION

        
   
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

END