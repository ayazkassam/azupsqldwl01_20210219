CREATE PROC [data_mart].[build_dim_vendor] @complete_rebuild_flag [varchar](1) AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
  SET NOCOUNT ON;
  BEGIN TRY	
    IF @complete_rebuild_flag IS NULL OR @complete_rebuild_flag = ''
      SET @complete_rebuild_flag = 'N'

	IF @complete_rebuild_flag = 'Y'	   
	    BEGIN

		 -- BEGIN TRANSACTION

			truncate table [data_mart].[t_dim_vendor];

		 -- COMMIT TRANSACTION

		END


	--BEGIN TRANSACTION	
	
      IF OBJECT_ID('tempdb..#t_dim_vendor_MERGE') IS NOT NULL
        DROP TABLE #t_dim_vendor_MERGE	 

      CREATE TABLE #t_dim_vendor_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
        SELECT
	      'NEW' Flag,
		  src.[vendor_key],
		  src.[vendor_name],
		  src.[parent_id],
		  src.[vendor_alpha_group],
		  src.[ba_type_code],
		  src.[payment_code],
		  src.[encana_ba_number],
		  src.[ba_credit_status],
		  src.[govt_entity],
		  src.[govt_parent],
		  src.[aboriginal],
		  src.[hold_date],
		  src.[ap_credit_days],
		  src.[ar_credit_days],
		  src.[inactive_date]
	    FROM
	      [stage].[v_qbyte_vendors] src
        LEFT JOIN [data_mart].[t_dim_vendor] trg
	      ON trg.vendor_key = src.vendor_key
        WHERE
	      trg.vendor_key IS NULL

        UNION ALL

	    SELECT
		  'UPDATE' Flag,
		  src.[vendor_key],
		  src.[vendor_name],
		  src.[parent_id],
		  src.[vendor_alpha_group],
		  src.[ba_type_code],
		  src.[payment_code],
		  src.[encana_ba_number],
		  src.[ba_credit_status],
		  src.[govt_entity],
		  src.[govt_parent],
		  src.[aboriginal],
		  src.[hold_date],
		  src.[ap_credit_days],
		  src.[ar_credit_days],
		  src.[inactive_date]	     
	    FROM
	    (
		   SELECT
			 'UPDATE' Flag,
			 src.[vendor_key],
			 src.[vendor_name],
			 src.[parent_id],
			 src.[vendor_alpha_group],
			 src.[ba_type_code],
			 src.[payment_code],
			 src.[encana_ba_number],
			 src.[ba_credit_status],
			 src.[govt_entity],
			 src.[govt_parent],
			 src.[aboriginal],
			 src.[hold_date],
			 src.[ap_credit_days],
			 src.[ar_credit_days],
			 src.[inactive_date]
		   FROM
			 [stage].[v_qbyte_vendors] src
		   INNER JOIN [data_mart].[t_dim_vendor] trg
			 ON trg.vendor_key = src.vendor_key

           EXCEPT

		   SELECT
			 'UPDATE' Flag,
			 src.[vendor_key],
			 src.[vendor_id] [vendor_name],
			 src.[parent_id],
			 src.[vendor_grouping] [vendor_alpha_group],
			 src.[ba_type_code],
			 src.[payment_code],
			 src.[encana_ba_number],
			 src.[ba_credit_status],
			 src.[govt_entity],
			 src.[govt_parent],
			 src.[aboriginal],
			 src.[hold_date],
			 src.[ap_credit_days],
			 src.[ar_credit_days],
			 src.[inactive_date]
		   FROM
			 [data_mart].[t_dim_vendor] src
	    ) src

      INSERT INTO [data_mart].[t_dim_vendor]
	    (
	      [vendor_key],
	      [vendor_id],
	      [parent_id],
	      [vendor_grouping],
	      [ba_type_code],
	      [payment_code],
	      [encana_ba_number],
	      [ba_credit_status],
	      [govt_entity],
	      [govt_parent],
	      [aboriginal],
	      [hold_date],
	      [ap_credit_days],
	      [ar_credit_days],
	      [inactive_date]	    
	    )
        SELECT
	  	  src.[vendor_key],
	  	  src.[vendor_name],
	  	  src.[parent_id],
	  	  src.[vendor_alpha_group],
	  	  src.[ba_type_code],
	  	  src.[payment_code],
	  	  src.[encana_ba_number],
	  	  src.[ba_credit_status],
	  	  src.[govt_entity],
	  	  src.[govt_parent],
	  	  src.[aboriginal],
	  	  src.[hold_date],
	  	  src.[ap_credit_days],
	  	  src.[ar_credit_days],
	  	  src.[inactive_date]
        FROM
	      #t_dim_vendor_MERGE src
        WHERE
	      Flag = 'New'
	  
	  ------ ROW_COUNT
	  DECLARE  @rowcnt INT
	  EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

      UPDATE [data_mart].[t_dim_vendor]
      SET
		[data_mart].[t_dim_vendor].[vendor_key]        =  UPD.[vendor_key],
		[data_mart].[t_dim_vendor].[vendor_id]         =  UPD.[vendor_name],
		[data_mart].[t_dim_vendor].[parent_id]         =  UPD.[parent_id],
		[data_mart].[t_dim_vendor].[vendor_grouping]   =  UPD.[vendor_alpha_group],
		[data_mart].[t_dim_vendor].[ba_type_code]	   =  UPD.[ba_type_code],
		[data_mart].[t_dim_vendor].[payment_code]      =  UPD.[payment_code],
		[data_mart].[t_dim_vendor].[encana_ba_number]  =  UPD.[encana_ba_number],
		[data_mart].[t_dim_vendor].[ba_credit_status]  =  UPD.[ba_credit_status],
		[data_mart].[t_dim_vendor].[govt_entity]	   =  UPD.[govt_entity],
		[data_mart].[t_dim_vendor].[govt_parent]	   =  UPD.[govt_parent],
		[data_mart].[t_dim_vendor].[aboriginal]		   =  UPD.[aboriginal],
		[data_mart].[t_dim_vendor].[hold_date]		   =  UPD.[hold_date],
		[data_mart].[t_dim_vendor].[ap_credit_days]	   =  UPD.[ap_credit_days],
		[data_mart].[t_dim_vendor].[ar_credit_days]	   =  UPD.[ar_credit_days],
		[data_mart].[t_dim_vendor].[inactive_date]	   =  UPD.[inactive_date]
      FROM #t_dim_vendor_MERGE UPD
      WHERE 
        [data_mart].[t_dim_vendor].vendor_key = UPD.vendor_key AND
	    UPD.Flag = 'UPDATE'		
	
   -- COMMIT TRANSACTION

	IF @complete_rebuild_flag = 'Y'
	    BEGIN

		  --BEGIN TRANSACTION

		   INSERT INTO [data_mart].[t_dim_vendor]
           ([vendor_key],
			[vendor_id],
			[vendor_grouping]
          )
		 VALUES
           (-2
           ,'Missing'
           ,'Missing');

			INSERT INTO [data_mart].[t_dim_vendor]
			([vendor_key],
			 [vendor_id],
			 [vendor_grouping]
          )
			VALUES
           (-1
           ,'Unknown'
           ,'Unknown');

		 --  COMMIT TRANSACTION

		  END       
   
   SELECT @rowcnt INSERTED
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