CREATE PROC [data_mart].[build_dim_account_hierarchy] @complete_rebuild_flag [varchar](1) AS
BEGIN
  SET NOCOUNT ON;

  IF @complete_rebuild_flag IS NULL OR @complete_rebuild_flag = ''
    SET @complete_rebuild_flag = 'N'

  BEGIN TRY

    IF @complete_rebuild_flag = 'Y'
        
      BEGIN
	   -- BEGIN TRANSACTION	    
             --ALTER SEQUENCE [dim_qbyte_account_seq]
             --      RESTART WITH 1
             --      INCREMENT BY 1
             --      MINVALUE 0
             --      MAXVALUE 100000
             --      NO CYCLE
             --      NO CACHE
             
             TRUNCATE TABLE [data_mart].[t_dim_account_hierarchy];
	    
      --  COMMIT TRANSACTION
      END

     --BEGIN TRANSACTION 
	
	 
	 
      IF OBJECT_ID('tempdb..#t_dim_account_hierarchy_MERGE') IS NOT NULL
        DROP TABLE #t_dim_account_hierarchy_MERGE	 

      CREATE TABLE #t_dim_account_hierarchy_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
		  SELECT
		    'NEW' Flag,
             src.[account_key],
             src.[account_id],
             src.[parent_id],
             src.[account_desc],
             src.[gl_account],
             src.[gl_account_description],
             src.[account_level_01],
             src.[account_level_02],
             src.[account_level_03],
             src.[account_level_04],
             src.[account_level_05],
             src.[major_account],
             src.[minor_account],
             src.[major_account_description],
             src.[major_class_code],
             src.[class_code_description],
             src.[product_code],
             src.[si_to_imp_conv_factor],
             src.[boe_thermal],
             src.[mcfe6_thermal],
             src.[product_description],
             src.[account_group],
             src.[display_sequence_number],
             src.[gross_or_net_code],
             src.[unary_operator],
             src.[account_level_01_sort_key],
             src.[account_level_02_sort_key],
             src.[account_level_03_sort_key],
             src.[account_level_04_sort_key],
             src.[account_level_05_sort_key],
             src.[is_leaseops],
             src.[is_capital],
             src.[is_volumes],
             src.[is_valnav],
             src.[zero_level],
             src.[Hierarchy_Path],
             src.[source]
          FROM [stage].[t_build_dim_account_hierarchy] as src
	      LEFT JOIN [data_mart].[t_dim_account_hierarchy] as trg
	        ON trg.account_id = src.account_id AND
	           trg.[account_group] = src.[account_group] 
          WHERE
		    trg.account_id IS NULL AND
			trg.[account_group] IS NULL

          UNION ALL

		  SELECT
		    'UPDATE' Flag,
             NULL [account_key],
             src.[account_id],
             src.[parent_id],
             src.[account_desc],
             src.[gl_account],
             src.[gl_account_description],
             src.[account_level_01],
             src.[account_level_02],
             src.[account_level_03],
             src.[account_level_04],
             src.[account_level_05],
             src.[major_account],
             src.[minor_account],
             src.[major_account_description],
             src.[major_class_code],
             src.[class_code_description],
             src.[product_code],
             src.[si_to_imp_conv_factor],
             src.[boe_thermal],
             src.[mcfe6_thermal],
             src.[product_description],
             src.[account_group],
             src.[display_sequence_number],
             src.[gross_or_net_code],
             src.[unary_operator],
             src.[account_level_01_sort_key],
             src.[account_level_02_sort_key],
             src.[account_level_03_sort_key],
             src.[account_level_04_sort_key],
             src.[account_level_05_sort_key],
             src.[is_leaseops],
             src.[is_capital],
             src.[is_volumes],
             src.[is_valnav],
             src.[zero_level],
             src.[Hierarchy_Path],
             src.[source]
          FROM 
		    (
		       SELECT
                  src.[account_id],
                  src.[parent_id],
                  src.[account_desc],
                  src.[gl_account],
                  src.[gl_account_description],
                  src.[account_level_01],
                  src.[account_level_02],
                  src.[account_level_03],
                  src.[account_level_04],
                  src.[account_level_05],
                  src.[major_account],
                  src.[minor_account],
                  src.[major_account_description],
                  src.[major_class_code],
                  src.[class_code_description],
                  src.[product_code],
                  src.[si_to_imp_conv_factor],
                  src.[boe_thermal],
                  src.[mcfe6_thermal],
                  src.[product_description],
                  src.[account_group],
                  src.[display_sequence_number],
                  src.[gross_or_net_code],
                  src.[unary_operator],
                  src.[account_level_01_sort_key],
                  src.[account_level_02_sort_key],
                  src.[account_level_03_sort_key],
                  src.[account_level_04_sort_key],
                  src.[account_level_05_sort_key],
                  src.[is_leaseops],
                  src.[is_capital],
                  src.[is_volumes],
                  src.[is_valnav],
                  src.[zero_level],
                  src.[Hierarchy_Path],
                  src.[source]
               FROM [stage].[t_build_dim_account_hierarchy] as src
	           INNER JOIN [data_mart].[t_dim_account_hierarchy] as trg
	             ON trg.account_id = src.account_id AND
	                trg.[account_group] = src.[account_group] 

               EXCEPT

		       SELECT
                  trg.[account_id],
                  trg.[parent_id],
                  trg.[account_desc],
                  trg.[gl_account],
                  trg.[gl_account_description],
                  trg.[account_level_01],
                  trg.[account_level_02],
                  trg.[account_level_03],
                  trg.[account_level_04],
                  trg.[account_level_05],
                  trg.[major_account],
                  trg.[minor_account],
                  trg.[major_account_description],
                  trg.[major_class_code],
                  trg.[class_code_description],
                  trg.[product_code],
                  trg.[si_to_imp_conv_factor],
                  trg.[boe_thermal],
                  trg.[mcfe6_thermal],
                  trg.[product_description],
                  trg.[account_group],
                  trg.[display_sequence_number],
                  trg.[gross_or_net_code],
                  trg.[unary_operator],
                  trg.[account_level_01_sort_key],
                  trg.[account_level_02_sort_key],
                  trg.[account_level_03_sort_key],
                  trg.[account_level_04_sort_key],
                  trg.[account_level_05_sort_key],
                  trg.[is_leaseops],
                  trg.[is_capital],
                  trg.[is_volumes],
                  trg.[is_valnav],
                  trg.[zero_level],
                  trg.[Hierarchy_Path],
                  trg.[source]
               FROM
			     [data_mart].[t_dim_account_hierarchy] as trg
			) src

    INSERT INTO [data_mart].[t_dim_account_hierarchy]
	  (
         [account_key],
         [account_id],
         [parent_id],
         [account_desc],
         [gl_account],
         [gl_account_description],
         [account_level_01],
         [account_level_02],
         [account_level_03],
         [account_level_04],
         [account_level_05],
         [major_account],
         [minor_account],
         [major_account_description],
         [major_class_code],
         [class_code_description],
         [product_code],
         [si_to_imp_conv_factor],
         [boe_thermal],
         [mcfe6_thermal],
         [product_description],
         [account_group],
         [display_sequence_number],
         [gross_or_net_code],
         [unary_operator],
         [account_level_01_sort_key],
         [account_level_02_sort_key],
         [account_level_03_sort_key],
         [account_level_04_sort_key],
         [account_level_05_sort_key],
         [is_leaseops],
         [is_capital],
         [is_volumes],
         [is_valnav],
         [zero_level],
         [Hierarchy_Path],
         [source]
	  )
	  SELECT
	    src.[account_key],
        src.[account_id],
        src.[parent_id],
        src.[account_desc],
        src.[gl_account],
        src.[gl_account_description],
        src.[account_level_01],
        src.[account_level_02],
        src.[account_level_03],
        src.[account_level_04],
        src.[account_level_05],
        src.[major_account],
        src.[minor_account],
        src.[major_account_description],
        src.[major_class_code],
        src.[class_code_description],
        src.[product_code],
        src.[si_to_imp_conv_factor],
        src.[boe_thermal],
        src.[mcfe6_thermal],
        src.[product_description],
        src.[account_group],
        src.[display_sequence_number],
        src.[gross_or_net_code],
        src.[unary_operator],
        src.[account_level_01_sort_key],
        src.[account_level_02_sort_key],
        src.[account_level_03_sort_key],
        src.[account_level_04_sort_key],
        src.[account_level_05_sort_key],
        src.[is_leaseops],
        src.[is_capital],
        src.[is_volumes],
        src.[is_valnav],
        src.[zero_level],
        src.[Hierarchy_Path],
        'QBYTE'--src.[source]
	  FROM
        #t_dim_account_hierarchy_MERGE src	    
	  WHERE
	    Flag = 'NEW'

	  ------ ROW_COUNT
	  DECLARE  @rowcnt INT
	  EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	  UPDATE [data_mart].[t_dim_account_hierarchy]
      SET
        [data_mart].[t_dim_account_hierarchy].[account_desc]              = UPD.[account_desc],
        [data_mart].[t_dim_account_hierarchy].[parent_id]                 = UPD.[parent_id],
        [data_mart].[t_dim_account_hierarchy].[gl_account]                = UPD.[gl_account],
        [data_mart].[t_dim_account_hierarchy].[gl_account_description]    = UPD.[gl_account_description],
        [data_mart].[t_dim_account_hierarchy].[account_level_01]          = UPD.[account_level_01],
        [data_mart].[t_dim_account_hierarchy].[account_level_02]          = UPD.[account_level_02],
        [data_mart].[t_dim_account_hierarchy].[account_level_03]          = UPD.[account_level_03],
        [data_mart].[t_dim_account_hierarchy].[account_level_04]          = UPD.[account_level_04],
        [data_mart].[t_dim_account_hierarchy].[account_level_05]          = UPD.[account_level_05],
        [data_mart].[t_dim_account_hierarchy].[major_account]             = UPD.[major_account],
        [data_mart].[t_dim_account_hierarchy].[minor_account]             = UPD.[minor_account],
        [data_mart].[t_dim_account_hierarchy].[major_account_description] = UPD.[major_account_description],
        [data_mart].[t_dim_account_hierarchy].[major_class_code]          = UPD.[major_class_code],
        [data_mart].[t_dim_account_hierarchy].[class_code_description]    = UPD.[class_code_description],
        [data_mart].[t_dim_account_hierarchy].[product_code]              = UPD.[product_code],
        [data_mart].[t_dim_account_hierarchy].[si_to_imp_conv_factor]     = UPD.[si_to_imp_conv_factor],
        [data_mart].[t_dim_account_hierarchy].[boe_thermal]               = UPD.[boe_thermal],
        [data_mart].[t_dim_account_hierarchy].[mcfe6_thermal]             = UPD.[mcfe6_thermal],
        [data_mart].[t_dim_account_hierarchy].[product_description]       = UPD.[product_description],
        [data_mart].[t_dim_account_hierarchy].[account_group]             = UPD.[account_group],
        [data_mart].[t_dim_account_hierarchy].[display_sequence_number]   = UPD.[display_sequence_number],
        [data_mart].[t_dim_account_hierarchy].[gross_or_net_code]         = UPD.[gross_or_net_code],
        [data_mart].[t_dim_account_hierarchy].[unary_operator]            = UPD.[unary_operator],
        [data_mart].[t_dim_account_hierarchy].[account_level_01_sort_key] = UPD.[account_level_01_sort_key],
        [data_mart].[t_dim_account_hierarchy].[account_level_02_sort_key] = UPD.[account_level_02_sort_key],
        [data_mart].[t_dim_account_hierarchy].[account_level_03_sort_key] = UPD.[account_level_03_sort_key],
        [data_mart].[t_dim_account_hierarchy].[account_level_04_sort_key] = UPD.[account_level_04_sort_key],
        [data_mart].[t_dim_account_hierarchy].[account_level_05_sort_key] = UPD.[account_level_05_sort_key],
        [data_mart].[t_dim_account_hierarchy].[is_leaseops]               = UPD.[is_leaseops],
        [data_mart].[t_dim_account_hierarchy].[is_capital]                = UPD.[is_capital],
        [data_mart].[t_dim_account_hierarchy].[is_volumes]                = UPD.[is_volumes],
        [data_mart].[t_dim_account_hierarchy].[is_valnav]                 = UPD.[is_valnav],
        [data_mart].[t_dim_account_hierarchy].[zero_level]                = UPD.[zero_level],
        [data_mart].[t_dim_account_hierarchy].[Hierarchy_Path]            = UPD.[Hierarchy_Path],
        [data_mart].[t_dim_account_hierarchy].[source]                    = UPD.[source]
      FROM #t_dim_account_hierarchy_MERGE UPD
      WHERE 
        [data_mart].[t_dim_account_hierarchy].account_id = UPD.account_id AND
	    [data_mart].[t_dim_account_hierarchy].[account_group] = UPD.[account_group] AND
	    UPD.Flag = 'UPDATE'	

      SELECT @rowcnt INSERTED
  
    -- COMMIT TRANSACTION

     --BEGIN TRANSACTION
       IF OBJECT_ID('tempdb..#t_dim_account_hierarchy_UPDATE') IS NOT NULL
        DROP TABLE #t_dim_account_hierarchy_UPDATE	 

       CREATE TABLE #t_dim_account_hierarchy_UPDATE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
		   SELECT 
		    account_id,
            account_key
          FROM
            [data_mart].[t_dim_account_hierarchy] 
          GROUP BY
		    account_id,
    	    account_key
	   
	   
       UPDATE [data_mart].[t_dim_account_hierarchy] 
       SET
         parent_key = ac.account_key
       FROM
         #t_dim_account_hierarchy_UPDATE ac
	   WHERE
         ac.account_id = [data_mart].[t_dim_account_hierarchy].parent_id;

     --COMMIT TRANSACTION


     IF @complete_rebuild_flag = 'Y'
         BEGIN

           --  BEGIN TRANSACTION

             INSERT INTO [data_mart].[t_dim_account_hierarchy]
                ([account_key],
                 [account_id],
                 [account_desc],
                 [account_level_01],
                 [account_level_02],
                 [account_level_03],
                 [account_level_04],
                 [account_level_05],
                 [account_level_01_sort_key],
                 [account_level_02_sort_key],
                 [account_level_03_sort_key],
                 [account_level_04_sort_key],
                 [account_level_05_sort_key],
                 [unary_operator],
                 [zero_level],
                 [is_leaseops],
                 [is_capital],
                 [source]
                )
             VALUES
                (-2,
                 'Missing',
                 'Missing',
                 'Missing',
                 'Missing',
                 'Missing',
                 'Missing',
                 'Missing',
                 'X8888',
                 'X8888',
                 'X8888',
                 'X8888',
                 'X8888',
                 '+',
                 1,
                 1,
                 1,
                 'PROGRAM GENERATED');

             INSERT INTO [data_mart].[t_dim_account_hierarchy]
                ([account_key],
                 [account_id],
                 [account_desc],
                 [account_level_01],
                 [account_level_02],
                 [account_level_03],
                 [account_level_04],
                 [account_level_05],
                 [account_level_01_sort_key],
                 [account_level_02_sort_key],
                 [account_level_03_sort_key],
                 [account_level_04_sort_key],
                 [account_level_05_sort_key],
                 [unary_operator],
                 [zero_level],
                 [is_leaseops],
                 [is_capital],
                 [source]
                )
             VALUES
                (-1,
                 'Unknown',
                 'Unknown',
                 'Unknown',
                 'Unknown',
                 'Unknown',
                 'Unknown',
                 'Unknown',
                 'X9999',
                 'X9999',
                 'X9999',
                 'X9999',
                 'X9999',
                 '+',
                 1,
                 1,
                 1,
                 'PROGRAM GENERATED');

            -- COMMIT TRANSACTION

         END

 END TRY
 
 BEGIN CATCH
        
       -- Grab error information from SQL functions
          DECLARE @ErrorSeverity INT           = ERROR_SEVERITY(),
                  @ErrorNumber INT             = ERROR_NUMBER(),
                  @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(),
                  @ErrorState INT              = ERROR_STATE(),
                 -- @ErrorLine INT               = ERROR_LINE(),
                  @ErrorProc nvarchar(200)     = ERROR_PROCEDURE()
                    
          -- If the error renders the transaction as uncommittable or we have open transactions, rollback
          --IF @@TRANCOUNT > 0
          --BEGIN
          --   ROLLBACK TRANSACTION
          --END

          RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

  END CATCH
 -- RETURN @@ERROR
END