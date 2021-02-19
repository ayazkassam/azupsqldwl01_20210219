CREATE PROC [data_mart_metrix].[build_dim_ar_contract] AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

	--BEGIN TRANSACTION
		truncate table [data_mart_metrix].[t_dim_ar_contract]
	--COMMIT TRANSACTION

	BEGIN TRANSACTION
		
	INSERT INTO [data_mart_metrix].[t_dim_ar_contract]

    SELECT *
    FROM [stage_metrix].[v_dim_source_metrix_ar_contract]

	--SET @rowcnt = @@ROWCOUNT

	COMMIT TRANSACTION

	END TRY
 
	BEGIN CATCH
        
		/*-- Grab error information from SQL functions*/
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
			,@ErrorNumber INT	= ERROR_NUMBER()
			,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
			,@ErrorState INT = ERROR_STATE()
			--,@ErrorLine  INT = ERROR_LINE()
			,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		/*-- If the error renders the transaction as uncommittable or we have open transactions, rollback*/
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		--RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

	END CATCH

	--RETURN @@ERROR
END