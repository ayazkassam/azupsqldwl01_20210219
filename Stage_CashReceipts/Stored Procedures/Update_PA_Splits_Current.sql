CREATE PROC [Stage_CashReceipts].[Update_PA_Splits_Current] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


BEGIN TRY	

   --BEGIN TRANSACTION			

			
			/* delete based on current prodmonth + acctmonth + Owner */

			DELETE 
			FROM  [Stage_CashReceipts].[PA_Splits_Current]
			WHERE [ProdMonth] + [AcctMonth] + [Owner] IN ( 
			                                               SELECT DISTINCT [ProdMonth] + [AcctMonth] + [Owner]
														   FROM [Stage_CashReceipts].[stage_pa_splits]
														 )
			

	--COMMIT TRANSACTION
	

	--BEGIN TRANSACTION

		INSERT INTO [Stage_CashReceipts].[PA_Splits_Current]
		SELECT	[ARContract],
				[ProdMonth],
				[AcctMonth],
				[ControlGroup],
				[PA],
				[Volume],
				[Energy],
				[Revenue],
				[Owner],
				CURRENT_TIMESTAMP [last_update_date]
		FROM [Stage_CashReceipts].[stage_pa_splits]
	
      --	
      --
	--SET @rowcnt = @@ROWCOUNT

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

  --RETURN @@ERROR

END