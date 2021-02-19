CREATE PROC [data_mart].[full_ap_ar_facts] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @before_count as INT, @after_count as INT

BEGIN TRY	

    
    -- Insert base ap ar transactions
	
	--BEGIN TRANSACTION		
	
	 TRUNCATE TABLE [data_mart].t_fact_ap_ar;

	--COMMIT TRANSACTION
	
	
	--BEGIN TRANSACTION	
	
	INSERT INTO [data_mart].t_fact_ap_ar
	SELECT 
	   [invc_type_code]
      ,[ba_id]
	  ,[invc_id]
      ,[invc_num]
      ,[invoice_date]
      ,[org_id]
      ,[accounting_month]
      ,[due_date]
	  ,[voucher_id]
      ,[voucher_type_code]
      ,[voucher_num]
      ,[li_type_code]
      ,[cad]
	  ,[invoice_amount]
  FROM [stage].[v_fact_source_ap_ar];
      --	
      --
	--SET @rowcnt = @@ROWCOUNT

	--COMMIT TRANSACTION
	

	------ Insert Open AP AR transactions

	----BEGIN TRANSACTION

	----   	 TRUNCATE TABLE [data_mart].dbo.t_fact_ap_ar_open;
		 

 ----   COMMIT TRANSACTION

	
	----BEGIN TRANSACTION	
	
	---- INSERT INTO [data_mart].dbo.t_fact_ap_ar_open
	---- SELECT 
	----   [invc_type_code]
 ----     ,[ba_id]
	----  ,[invc_id]
 ----     ,[invc_num]
 ----     ,[invoice_date]
 ----     ,[org_id]
 ----     ,[accounting_month]
 ----     ,[due_date]
	----  ,[voucher_id]
 ----     ,[voucher_type_code]
 ----     ,[voucher_num]
 ----     ,[cad_open]
 ----   FROM [stage].[dbo].[v_fact_source_ap_ar_open];
 ----     --	
 ----     --
	----SET @rowcnt = @@ROWCOUNT + @rowcnt

	----COMMIT TRANSACTION


 END TRY
 
 BEGIN CATCH
        
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
				--,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		---- If the error renders the transaction as uncommittable or we have open transactions, rollback
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)      

  END CATCH

  --RETURN @@ERROR

END