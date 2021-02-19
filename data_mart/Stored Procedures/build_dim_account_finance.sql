CREATE PROC [data_mart].[build_dim_account_finance] @complete_rebuild_flag [varchar](1) AS
BEGIN

  SET NOCOUNT ON;
  IF @complete_rebuild_flag IS NULL OR @complete_rebuild_flag = ''
    SET @complete_rebuild_flag = 'N'

  BEGIN TRY

     IF @complete_rebuild_flag = 'Y'
        
         BEGIN

            -- BEGIN TRANSACTION
                  
                  TRUNCATE TABLE [data_mart].[t_dim_account_finance];

            -- COMMIT TRANSACTION

         END

    -- BEGIN TRANSACTION      
	 
      IF OBJECT_ID('tempdb..#t_dim_account_finance_MERGE') IS NOT NULL
        DROP TABLE #t_dim_account_finance_MERGE	 

      CREATE TABLE #t_dim_account_finance_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
		  SELECT
		    'NEW' Flag
			, src.[account_id]
			, src.[account_description]
			, src.[gl_account]
			, src.[gl_account_description]
			, src.[major_account]
			, src.[minor_account]
			, src.[major_account_description]
			, src.[major_class_code]
			, src.[class_code_description]
			, src.[unary_operator]
			, src.[account_formula]
			, src.[account_formula_property]
			, src.[account_level_01_formula]
			, src.[account_level_01_formula_property]
			, src.[account_level_02_formula]
			, src.[account_level_02_formula_property]
			, src.[account_level_03_formula]
			, src.[account_level_03_formula_property]
			, src.[account_level_04_formula]
			, src.[account_level_04_formula_property]
			, src.[account_level_05_formula]
			, src.[account_level_05_formula_property]
			, src.[account_level_06_formula]
			, src.[account_level_06_formula_property]
			, src.[account_level_07_formula]
			, src.[account_level_07_formula_property]
			, src.[account_level_08_formula]
			, src.[account_level_08_formula_property]
			, src.[account_level_09_formula]
			, src.[account_level_09_formula_property]
			, src.[account_level_10_formula]
			, src.[account_level_10_formula_property]
			, src.[account_level_01_desc]
			, src.[account_level_02_desc]
			, src.[account_level_03_desc]
			, src.[account_level_04_desc]
			, src.[account_level_05_desc]
			, src.[account_level_06_desc]
			, src.[account_level_07_desc]
			, src.[account_level_08_desc]
			, src.[account_level_09_desc]
			, src.[account_level_10_desc]
			, src.[account_level_01_sort_key]
			, src.[account_level_02_sort_key]
			, src.[account_level_03_sort_key]
			, src.[account_level_04_sort_key]
			, src.[account_level_05_sort_key]
			, src.[account_level_06_sort_key]
			, src.[account_level_07_sort_key]
			, src.[account_level_08_sort_key]
			, src.[account_level_09_sort_key]
			, src.[account_level_10_sort_key]
			, src.[dep_account_id]
			, src.[dep_account_description]
			, src.[dep_level_01_desc]
			, src.[dep_level_02_desc]
			, src.[dep_level_03_desc]
			, src.[dep_level_04_desc]
			, src.[dep_level_05_desc]
			, src.[dep_level_01_sort_key]
			, src.[dep_level_02_sort_key]
			, src.[dep_level_03_sort_key]
			, src.[dep_level_04_sort_key]
			, src.[dep_level_05_sort_key]
			, src.[taxop_account_id]
			, src.[taxop_account_description]
			, src.[taxop_level_01_desc]
			, src.[taxop_level_02_desc]
			, src.[taxop_level_03_desc]
			, src.[taxop_level_04_desc]
			, src.[taxop_level_05_desc]
			, src.[taxop_level_01_sort_key]
			, src.[taxop_level_02_sort_key]
			, src.[taxop_level_03_sort_key]
			, src.[taxop_level_04_sort_key]
			, src.[taxop_level_05_sort_key]
			, src.[gcart_account_id]
			, src.[gcart_account_description]
			, src.[gcart_level_01_desc]
			, src.[gcart_level_02_desc]
			, src.[gcart_level_03_desc]
			, src.[gcart_level_04_desc]
			, src.[gcart_level_05_desc]
			, src.[gcart_level_01_sort_key]
			, src.[gcart_level_02_sort_key]
			, src.[gcart_level_03_sort_key]
			, src.[gcart_level_04_sort_key]
			, src.[gcart_level_05_sort_key]
			, src.[estma_account_id]
			, src.[estma_account_description]
			, src.[estma_level_01_desc]
			, src.[estma_level_02_desc]
			, src.[estma_level_03_desc]
			, src.[estma_level_04_desc]
			, src.[estma_level_05_desc]
			, src.[estma_level_01_sort_key]
			, src.[estma_level_02_sort_key]
			, src.[estma_level_03_sort_key]
			, src.[estma_level_04_sort_key]
			, src.[estma_level_05_sort_key]
          FROM
		    [stage].[t_build_dim_account_finance] as src
          LEFT JOIN  [data_mart].[t_dim_account_finance] as trg
		    ON trg.account_id = src.account_id 
	      WHERE
		    trg.account_id IS NULL 

          UNION ALL

		  SELECT
		    'UPDATE' Flag
			, src.[account_id]
			, src.[account_description]
			, src.[gl_account]
			, src.[gl_account_description]
			, src.[major_account]
			, src.[minor_account]
			, src.[major_account_description]
			, src.[major_class_code]
			, src.[class_code_description]
			, src.[unary_operator]
			, src.[account_formula]
			, src.[account_formula_property]
			, src.[account_level_01_formula]
			, src.[account_level_01_formula_property]
			, src.[account_level_02_formula]
			, src.[account_level_02_formula_property]
			, src.[account_level_03_formula]
			, src.[account_level_03_formula_property]
			, src.[account_level_04_formula]
			, src.[account_level_04_formula_property]
			, src.[account_level_05_formula]
			, src.[account_level_05_formula_property]
			, src.[account_level_06_formula]
			, src.[account_level_06_formula_property]
			, src.[account_level_07_formula]
			, src.[account_level_07_formula_property]
			, src.[account_level_08_formula]
			, src.[account_level_08_formula_property]
			, src.[account_level_09_formula]
			, src.[account_level_09_formula_property]
			, src.[account_level_10_formula]
			, src.[account_level_10_formula_property]
			, src.[account_level_01_desc]
			, src.[account_level_02_desc]
			, src.[account_level_03_desc]
			, src.[account_level_04_desc]
			, src.[account_level_05_desc]
			, src.[account_level_06_desc]
			, src.[account_level_07_desc]
			, src.[account_level_08_desc]
			, src.[account_level_09_desc]
			, src.[account_level_10_desc]
			, src.[account_level_01_sort_key]
			, src.[account_level_02_sort_key]
			, src.[account_level_03_sort_key]
			, src.[account_level_04_sort_key]
			, src.[account_level_05_sort_key]
			, src.[account_level_06_sort_key]
			, src.[account_level_07_sort_key]
			, src.[account_level_08_sort_key]
			, src.[account_level_09_sort_key]
			, src.[account_level_10_sort_key]
			, src.[dep_account_id]
			, src.[dep_account_description]
			, src.[dep_level_01_desc]
			, src.[dep_level_02_desc]
			, src.[dep_level_03_desc]
			, src.[dep_level_04_desc]
			, src.[dep_level_05_desc]
			, src.[dep_level_01_sort_key]
			, src.[dep_level_02_sort_key]
			, src.[dep_level_03_sort_key]
			, src.[dep_level_04_sort_key]
			, src.[dep_level_05_sort_key]
			, src.[taxop_account_id]
			, src.[taxop_account_description]
			, src.[taxop_level_01_desc]
			, src.[taxop_level_02_desc]
			, src.[taxop_level_03_desc]
			, src.[taxop_level_04_desc]
			, src.[taxop_level_05_desc]
			, src.[taxop_level_01_sort_key]
			, src.[taxop_level_02_sort_key]
			, src.[taxop_level_03_sort_key]
			, src.[taxop_level_04_sort_key]
			, src.[taxop_level_05_sort_key]
			, src.[gcart_account_id]
			, src.[gcart_account_description]
			, src.[gcart_level_01_desc]
			, src.[gcart_level_02_desc]
			, src.[gcart_level_03_desc]
			, src.[gcart_level_04_desc]
			, src.[gcart_level_05_desc]
			, src.[gcart_level_01_sort_key]
			, src.[gcart_level_02_sort_key]
			, src.[gcart_level_03_sort_key]
			, src.[gcart_level_04_sort_key]
			, src.[gcart_level_05_sort_key]
			, src.[estma_account_id]
			, src.[estma_account_description]
			, src.[estma_level_01_desc]
			, src.[estma_level_02_desc]
			, src.[estma_level_03_desc]
			, src.[estma_level_04_desc]
			, src.[estma_level_05_desc]
			, src.[estma_level_01_sort_key]
			, src.[estma_level_02_sort_key]
			, src.[estma_level_03_sort_key]
			, src.[estma_level_04_sort_key]
			, src.[estma_level_05_sort_key]

          FROM
		    (
		       SELECT
			     			  src.[account_id]
							, src.[account_description]
							, src.[gl_account]
							, src.[gl_account_description]
							, src.[major_account]
							, src.[minor_account]
							, src.[major_account_description]
							, src.[major_class_code]
							, src.[class_code_description]
							, src.[unary_operator]
							, src.[account_formula]
							, src.[account_formula_property]
							, src.[account_level_01_formula]
							, src.[account_level_01_formula_property]
							, src.[account_level_02_formula]
							, src.[account_level_02_formula_property]
							, src.[account_level_03_formula]
							, src.[account_level_03_formula_property]
							, src.[account_level_04_formula]
							, src.[account_level_04_formula_property]
							, src.[account_level_05_formula]
							, src.[account_level_05_formula_property]
							, src.[account_level_06_formula]
							, src.[account_level_06_formula_property]
							, src.[account_level_07_formula]
							, src.[account_level_07_formula_property]
							, src.[account_level_08_formula]
							, src.[account_level_08_formula_property]
							, src.[account_level_09_formula]
							, src.[account_level_09_formula_property]
							, src.[account_level_10_formula]
							, src.[account_level_10_formula_property]
							, src.[account_level_01_desc]
							, src.[account_level_02_desc]
							, src.[account_level_03_desc]
							, src.[account_level_04_desc]
							, src.[account_level_05_desc]
							, src.[account_level_06_desc]
							, src.[account_level_07_desc]
							, src.[account_level_08_desc]
							, src.[account_level_09_desc]
							, src.[account_level_10_desc]
							, src.[account_level_01_sort_key]
							, src.[account_level_02_sort_key]
							, src.[account_level_03_sort_key]
							, src.[account_level_04_sort_key]
							, src.[account_level_05_sort_key]
							, src.[account_level_06_sort_key]
							, src.[account_level_07_sort_key]
							, src.[account_level_08_sort_key]
							, src.[account_level_09_sort_key]
							, src.[account_level_10_sort_key]
							, src.[dep_account_id]
							, src.[dep_account_description]
							, src.[dep_level_01_desc]
							, src.[dep_level_02_desc]
							, src.[dep_level_03_desc]
							, src.[dep_level_04_desc]
							, src.[dep_level_05_desc]
							, src.[dep_level_01_sort_key]
							, src.[dep_level_02_sort_key]
							, src.[dep_level_03_sort_key]
							, src.[dep_level_04_sort_key]
							, src.[dep_level_05_sort_key]
							, src.[taxop_account_id]
							, src.[taxop_account_description]
							, src.[taxop_level_01_desc]
							, src.[taxop_level_02_desc]
							, src.[taxop_level_03_desc]
							, src.[taxop_level_04_desc]
							, src.[taxop_level_05_desc]
							, src.[taxop_level_01_sort_key]
							, src.[taxop_level_02_sort_key]
							, src.[taxop_level_03_sort_key]
							, src.[taxop_level_04_sort_key]
							, src.[taxop_level_05_sort_key]
							, src.[gcart_account_id]
							, src.[gcart_account_description]
							, src.[gcart_level_01_desc]
							, src.[gcart_level_02_desc]
							, src.[gcart_level_03_desc]
							, src.[gcart_level_04_desc]
							, src.[gcart_level_05_desc]
							, src.[gcart_level_01_sort_key]
							, src.[gcart_level_02_sort_key]
							, src.[gcart_level_03_sort_key]
							, src.[gcart_level_04_sort_key]
							, src.[gcart_level_05_sort_key]
							, src.[estma_account_id]
							, src.[estma_account_description]
							, src.[estma_level_01_desc]
							, src.[estma_level_02_desc]
							, src.[estma_level_03_desc]
							, src.[estma_level_04_desc]
							, src.[estma_level_05_desc]
							, src.[estma_level_01_sort_key]
							, src.[estma_level_02_sort_key]
							, src.[estma_level_03_sort_key]
							, src.[estma_level_04_sort_key]
							, src.[estma_level_05_sort_key]

               FROM
		         [stage].[t_build_dim_account_finance] as src
               INNER JOIN  [data_mart].[t_dim_account_finance] as trg
		         ON trg.account_id = src.account_id 

               EXCEPT

		       SELECT
			       trg.[account_id]
			     , trg.[account_description]
			     , trg.[gl_account]
			     , trg.[gl_account_description]
			     , trg.[major_account]
			     , trg.[minor_account]
			     , trg.[major_account_description]
			     , trg.[major_class_code]
			     , trg.[class_code_description]
			     , trg.[unary_operator]
			     , trg.[account_formula]
			     , trg.[account_formula_property]
			     , trg.[account_level_01_formula]
			     , trg.[account_level_01_formula_property]
			     , trg.[account_level_02_formula]
			     , trg.[account_level_02_formula_property]
			     , trg.[account_level_03_formula]
			     , trg.[account_level_03_formula_property]
			     , trg.[account_level_04_formula]
			     , trg.[account_level_04_formula_property]
			     , trg.[account_level_05_formula]
			     , trg.[account_level_05_formula_property]
			     , trg.[account_level_06_formula]
			     , trg.[account_level_06_formula_property]
			     , trg.[account_level_07_formula]
			     , trg.[account_level_07_formula_property]
			     , trg.[account_level_08_formula]
			     , trg.[account_level_08_formula_property]
			     , trg.[account_level_09_formula]
			     , trg.[account_level_09_formula_property]
			     , trg.[account_level_10_formula]
			     , trg.[account_level_10_formula_property]
			     , trg.[account_level_01_desc]
			     , trg.[account_level_02_desc]
			     , trg.[account_level_03_desc]
			     , trg.[account_level_04_desc]
			     , trg.[account_level_05_desc]
			     , trg.[account_level_06_desc]
			     , trg.[account_level_07_desc]
			     , trg.[account_level_08_desc]
			     , trg.[account_level_09_desc]
			     , trg.[account_level_10_desc]
			     , trg.[account_level_01_sort_key]
			     , trg.[account_level_02_sort_key]
			     , trg.[account_level_03_sort_key]
			     , trg.[account_level_04_sort_key]
			     , trg.[account_level_05_sort_key]
			     , trg.[account_level_06_sort_key]
			     , trg.[account_level_07_sort_key]
			     , trg.[account_level_08_sort_key]
			     , trg.[account_level_09_sort_key]
			     , trg.[account_level_10_sort_key]
			     , trg.[dep_account_id]
			     , trg.[dep_account_description]
			     , trg.[dep_level_01_desc]
			     , trg.[dep_level_02_desc]
			     , trg.[dep_level_03_desc]
			     , trg.[dep_level_04_desc]
			     , trg.[dep_level_05_desc]
			     , trg.[dep_level_01_sort_key]
			     , trg.[dep_level_02_sort_key]
			     , trg.[dep_level_03_sort_key]
			     , trg.[dep_level_04_sort_key]
			     , trg.[dep_level_05_sort_key]
			     , trg.[taxop_account_id]
			     , trg.[taxop_account_description]
			     , trg.[taxop_level_01_desc]
			     , trg.[taxop_level_02_desc]
			     , trg.[taxop_level_03_desc]
			     , trg.[taxop_level_04_desc]
			     , trg.[taxop_level_05_desc]
			     , trg.[taxop_level_01_sort_key]
			     , trg.[taxop_level_02_sort_key]
			     , trg.[taxop_level_03_sort_key]
			     , trg.[taxop_level_04_sort_key]
			     , trg.[taxop_level_05_sort_key]	
			     , trg.[gcart_account_id]
			     , trg.[gcart_account_description]
			     , trg.[gcart_level_01_desc]
			     , trg.[gcart_level_02_desc]
			     , trg.[gcart_level_03_desc]
			     , trg.[gcart_level_04_desc]
			     , trg.[gcart_level_05_desc]
			     , trg.[gcart_level_01_sort_key]
			     , trg.[gcart_level_02_sort_key]
			     , trg.[gcart_level_03_sort_key]
			     , trg.[gcart_level_04_sort_key]
			     , trg.[gcart_level_05_sort_key]
			     , trg.[estma_account_id]
			     , trg.[estma_account_description]
			     , trg.[estma_level_01_desc]
			     , trg.[estma_level_02_desc]
			     , trg.[estma_level_03_desc]
			     , trg.[estma_level_04_desc]
			     , trg.[estma_level_05_desc]
			     , trg.[estma_level_01_sort_key]
			     , trg.[estma_level_02_sort_key]
			     , trg.[estma_level_03_sort_key]
			     , trg.[estma_level_04_sort_key]
			     , trg.[estma_level_05_sort_key]
               FROM
		         [data_mart].[t_dim_account_finance] as trg
			) src

    INSERT INTO [data_mart].[t_dim_account_finance]
	  (
         [account_id]
        ,[account_description]
        ,[gl_account]
        ,[gl_account_description]
        ,[major_account]
        ,[minor_account]
        ,[major_account_description]
        ,[major_class_code]
        ,[class_code_description]
        ,[unary_operator]
        ,[account_formula]
        ,[account_formula_property]
        ,[account_level_01_formula]
        ,[account_level_01_formula_property]
        ,[account_level_02_formula]
        ,[account_level_02_formula_property]
        ,[account_level_03_formula]
        ,[account_level_03_formula_property]
        ,[account_level_04_formula]
        ,[account_level_04_formula_property]
        ,[account_level_05_formula]
        ,[account_level_05_formula_property]
        ,[account_level_06_formula]
        ,[account_level_06_formula_property]
        ,[account_level_07_formula]
        ,[account_level_07_formula_property]
        ,[account_level_08_formula]
        ,[account_level_08_formula_property]
        ,[account_level_09_formula]
        ,[account_level_09_formula_property]
        ,[account_level_10_formula]
        ,[account_level_10_formula_property]
        ,[account_level_01_desc]
        ,[account_level_02_desc]
        ,[account_level_03_desc]
        ,[account_level_04_desc]
        ,[account_level_05_desc]
        ,[account_level_06_desc]
        ,[account_level_07_desc]
        ,[account_level_08_desc]
        ,[account_level_09_desc]
        ,[account_level_10_desc]
        ,[account_level_01_sort_key]
        ,[account_level_02_sort_key]
        ,[account_level_03_sort_key]
        ,[account_level_04_sort_key]
        ,[account_level_05_sort_key]
        ,[account_level_06_sort_key]
        ,[account_level_07_sort_key]
        ,[account_level_08_sort_key]
        ,[account_level_09_sort_key]
        ,[account_level_10_sort_key]
        ,[dep_account_id]
        ,[dep_account_description]
        ,[dep_level_01_desc]
        ,[dep_level_02_desc]
        ,[dep_level_03_desc]
        ,[dep_level_04_desc]
        ,[dep_level_05_desc]
        ,[dep_level_01_sort_key]
        ,[dep_level_02_sort_key]
        ,[dep_level_03_sort_key]
        ,[dep_level_04_sort_key]
        ,[dep_level_05_sort_key]
        ,[taxop_account_id]
        ,[taxop_account_description]
        ,[taxop_level_01_desc]
        ,[taxop_level_02_desc]
        ,[taxop_level_03_desc]
        ,[taxop_level_04_desc]
        ,[taxop_level_05_desc]
        ,[taxop_level_01_sort_key]
        ,[taxop_level_02_sort_key]
        ,[taxop_level_03_sort_key]
        ,[taxop_level_04_sort_key]
        ,[taxop_level_05_sort_key]
        ,[gcart_account_id]
        ,[gcart_account_description]
        ,[gcart_level_01_desc]
        ,[gcart_level_02_desc]
        ,[gcart_level_03_desc]
        ,[gcart_level_04_desc]
        ,[gcart_level_05_desc]
        ,[gcart_level_01_sort_key]
        ,[gcart_level_02_sort_key]
        ,[gcart_level_03_sort_key]
        ,[gcart_level_04_sort_key]
        ,[gcart_level_05_sort_key]
        ,[estma_account_id]
        ,[estma_account_description]
        ,[estma_level_01_desc]
        ,[estma_level_02_desc]
        ,[estma_level_03_desc]
        ,[estma_level_04_desc]
        ,[estma_level_05_desc]
        ,[estma_level_01_sort_key]
        ,[estma_level_02_sort_key]
        ,[estma_level_03_sort_key]
        ,[estma_level_04_sort_key]
        ,[estma_level_05_sort_key]
	  )
	  SELECT
		  src.[account_id]
		, src.[account_description]
		, src.[gl_account]
		, src.[gl_account_description]
		, src.[major_account]
		, src.[minor_account]
		, src.[major_account_description]
		, src.[major_class_code]
		, src.[class_code_description]
		, src.[unary_operator]
		, src.[account_formula]
		, src.[account_formula_property]
		, src.[account_level_01_formula]
		, src.[account_level_01_formula_property]
		, src.[account_level_02_formula]
		, src.[account_level_02_formula_property]
		, src.[account_level_03_formula]
		, src.[account_level_03_formula_property]
		, src.[account_level_04_formula]
		, src.[account_level_04_formula_property]
		, src.[account_level_05_formula]
		, src.[account_level_05_formula_property]
		, src.[account_level_06_formula]
		, src.[account_level_06_formula_property]
		, src.[account_level_07_formula]
		, src.[account_level_07_formula_property]
		, src.[account_level_08_formula]
		, src.[account_level_08_formula_property]
		, src.[account_level_09_formula]
		, src.[account_level_09_formula_property]
		, src.[account_level_10_formula]
		, src.[account_level_10_formula_property]
		, src.[account_level_01_desc]
		, src.[account_level_02_desc]
		, src.[account_level_03_desc]
		, src.[account_level_04_desc]
		, src.[account_level_05_desc]
		, src.[account_level_06_desc]
		, src.[account_level_07_desc]
		, src.[account_level_08_desc]
		, src.[account_level_09_desc]
		, src.[account_level_10_desc]
		, src.[account_level_01_sort_key]
		, src.[account_level_02_sort_key]
		, src.[account_level_03_sort_key]
		, src.[account_level_04_sort_key]
		, src.[account_level_05_sort_key]
		, src.[account_level_06_sort_key]
		, src.[account_level_07_sort_key]
		, src.[account_level_08_sort_key]
		, src.[account_level_09_sort_key]
		, src.[account_level_10_sort_key]
		, src.[dep_account_id]
		, src.[dep_account_description]
		, src.[dep_level_01_desc]
		, src.[dep_level_02_desc]
		, src.[dep_level_03_desc]
		, src.[dep_level_04_desc]
		, src.[dep_level_05_desc]
		, src.[dep_level_01_sort_key]
		, src.[dep_level_02_sort_key]
		, src.[dep_level_03_sort_key]
		, src.[dep_level_04_sort_key]
		, src.[dep_level_05_sort_key]
		, src.[taxop_account_id]
		, src.[taxop_account_description]
		, src.[taxop_level_01_desc]
		, src.[taxop_level_02_desc]
		, src.[taxop_level_03_desc]
		, src.[taxop_level_04_desc]
		, src.[taxop_level_05_desc]
		, src.[taxop_level_01_sort_key]
		, src.[taxop_level_02_sort_key]
		, src.[taxop_level_03_sort_key]
		, src.[taxop_level_04_sort_key]
		, src.[taxop_level_05_sort_key]
		, src.[gcart_account_id]
		, src.[gcart_account_description]
		, src.[gcart_level_01_desc]
		, src.[gcart_level_02_desc]
		, src.[gcart_level_03_desc]
		, src.[gcart_level_04_desc]
		, src.[gcart_level_05_desc]
		, src.[gcart_level_01_sort_key]
		, src.[gcart_level_02_sort_key]
		, src.[gcart_level_03_sort_key]
		, src.[gcart_level_04_sort_key]
		, src.[gcart_level_05_sort_key]
		, src.[estma_account_id]
		, src.[estma_account_description]
		, src.[estma_level_01_desc]
		, src.[estma_level_02_desc]
		, src.[estma_level_03_desc]
		, src.[estma_level_04_desc]
		, src.[estma_level_05_desc]
		, src.[estma_level_01_sort_key]
		, src.[estma_level_02_sort_key]
		, src.[estma_level_03_sort_key]
		, src.[estma_level_04_sort_key]
		, src.[estma_level_05_sort_key]
	  FROM
	    #t_dim_account_finance_MERGE src
	  WHERE
	    Flag = 'NEW'

	  ------ ROW_COUNT
	  DECLARE  @rowcnt INT
	  EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	  UPDATE [data_mart].[t_dim_account_finance]
      SET
          [data_mart].[t_dim_account_finance].[account_id]							        = UPD.[account_id]
		, [data_mart].[t_dim_account_finance].[account_description]					    	= UPD.[account_description]
		, [data_mart].[t_dim_account_finance].[gl_account]									= UPD.[gl_account]
		, [data_mart].[t_dim_account_finance].[gl_account_description]						= UPD.[gl_account_description]
		, [data_mart].[t_dim_account_finance].[major_account]								= UPD.[major_account]
		, [data_mart].[t_dim_account_finance].[minor_account]								= UPD.[minor_account]
		, [data_mart].[t_dim_account_finance].[major_account_description]					= UPD.[major_account_description]
		, [data_mart].[t_dim_account_finance].[major_class_code]							= UPD.[major_class_code]
		, [data_mart].[t_dim_account_finance].[class_code_description]						= UPD.[class_code_description]
		, [data_mart].[t_dim_account_finance].[unary_operator]								= UPD.[unary_operator]
		, [data_mart].[t_dim_account_finance].[account_formula]								= UPD.[account_formula]
		, [data_mart].[t_dim_account_finance].[account_formula_property]					= UPD.[account_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_01_formula]					= UPD.[account_level_01_formula]
		, [data_mart].[t_dim_account_finance].[account_level_01_formula_property]			= UPD.[account_level_01_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_02_formula]					= UPD.[account_level_02_formula]
		, [data_mart].[t_dim_account_finance].[account_level_02_formula_property]			= UPD.[account_level_02_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_03_formula]					= UPD.[account_level_03_formula]
		, [data_mart].[t_dim_account_finance].[account_level_03_formula_property]			= UPD.[account_level_03_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_04_formula]					= UPD.[account_level_04_formula]
		, [data_mart].[t_dim_account_finance].[account_level_04_formula_property]			= UPD.[account_level_04_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_05_formula]					= UPD.[account_level_05_formula]
		, [data_mart].[t_dim_account_finance].[account_level_05_formula_property]			= UPD.[account_level_05_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_06_formula]					= UPD.[account_level_06_formula]
		, [data_mart].[t_dim_account_finance].[account_level_06_formula_property]			= UPD.[account_level_06_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_07_formula]					= UPD.[account_level_07_formula]
		, [data_mart].[t_dim_account_finance].[account_level_07_formula_property]			= UPD.[account_level_07_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_08_formula]					= UPD.[account_level_08_formula]
		, [data_mart].[t_dim_account_finance].[account_level_08_formula_property]			= UPD.[account_level_08_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_09_formula]					= UPD.[account_level_09_formula]
		, [data_mart].[t_dim_account_finance].[account_level_09_formula_property]			= UPD.[account_level_09_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_10_formula]					= UPD.[account_level_10_formula]
		, [data_mart].[t_dim_account_finance].[account_level_10_formula_property]			= UPD.[account_level_10_formula_property]
		, [data_mart].[t_dim_account_finance].[account_level_01_desc]						= UPD.[account_level_01_desc]
		, [data_mart].[t_dim_account_finance].[account_level_02_desc]						= UPD.[account_level_02_desc]
		, [data_mart].[t_dim_account_finance].[account_level_03_desc]						= UPD.[account_level_03_desc]
		, [data_mart].[t_dim_account_finance].[account_level_04_desc]						= UPD.[account_level_04_desc]
		, [data_mart].[t_dim_account_finance].[account_level_05_desc]						= UPD.[account_level_05_desc]
		, [data_mart].[t_dim_account_finance].[account_level_06_desc]						= UPD.[account_level_06_desc]
		, [data_mart].[t_dim_account_finance].[account_level_07_desc]						= UPD.[account_level_07_desc]
		, [data_mart].[t_dim_account_finance].[account_level_08_desc]						= UPD.[account_level_08_desc]
		, [data_mart].[t_dim_account_finance].[account_level_09_desc]						= UPD.[account_level_09_desc]
		, [data_mart].[t_dim_account_finance].[account_level_10_desc]						= UPD.[account_level_10_desc]
		, [data_mart].[t_dim_account_finance].[account_level_01_sort_key]					= UPD.[account_level_01_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_02_sort_key]					= UPD.[account_level_02_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_03_sort_key]					= UPD.[account_level_03_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_04_sort_key]					= UPD.[account_level_04_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_05_sort_key]					= UPD.[account_level_05_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_06_sort_key]					= UPD.[account_level_06_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_07_sort_key]					= UPD.[account_level_07_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_08_sort_key]					= UPD.[account_level_08_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_09_sort_key]					= UPD.[account_level_09_sort_key]
		, [data_mart].[t_dim_account_finance].[account_level_10_sort_key]					= UPD.[account_level_10_sort_key]
		, [data_mart].[t_dim_account_finance].[dep_account_id]								= UPD.[dep_account_id]
		, [data_mart].[t_dim_account_finance].[dep_account_description]						= UPD.[dep_account_description]
		, [data_mart].[t_dim_account_finance].[dep_level_01_desc]							= UPD.[dep_level_01_desc]
		, [data_mart].[t_dim_account_finance].[dep_level_02_desc]							= UPD.[dep_level_02_desc]
		, [data_mart].[t_dim_account_finance].[dep_level_03_desc]							= UPD.[dep_level_03_desc]
		, [data_mart].[t_dim_account_finance].[dep_level_04_desc]							= UPD.[dep_level_04_desc]
		, [data_mart].[t_dim_account_finance].[dep_level_05_desc]							= UPD.[dep_level_05_desc]
		, [data_mart].[t_dim_account_finance].[dep_level_01_sort_key]						= UPD.[dep_level_01_sort_key]
		, [data_mart].[t_dim_account_finance].[dep_level_02_sort_key]						= UPD.[dep_level_02_sort_key]
		, [data_mart].[t_dim_account_finance].[dep_level_03_sort_key]						= UPD.[dep_level_03_sort_key]
		, [data_mart].[t_dim_account_finance].[dep_level_04_sort_key]						= UPD.[dep_level_04_sort_key]
		, [data_mart].[t_dim_account_finance].[dep_level_05_sort_key]						= UPD.[dep_level_05_sort_key]
		, [data_mart].[t_dim_account_finance].[taxop_account_id]							= UPD.[taxop_account_id]
		, [data_mart].[t_dim_account_finance].[taxop_account_description]					= UPD.[taxop_account_description]
		, [data_mart].[t_dim_account_finance].[taxop_level_01_desc]							= UPD.[taxop_level_01_desc]
		, [data_mart].[t_dim_account_finance].[taxop_level_02_desc]							= UPD.[taxop_level_02_desc]
		, [data_mart].[t_dim_account_finance].[taxop_level_03_desc]							= UPD.[taxop_level_03_desc]
		, [data_mart].[t_dim_account_finance].[taxop_level_04_desc]							= UPD.[taxop_level_04_desc]
		, [data_mart].[t_dim_account_finance].[taxop_level_05_desc]							= UPD.[taxop_level_05_desc]
		, [data_mart].[t_dim_account_finance].[taxop_level_01_sort_key]						= UPD.[taxop_level_01_sort_key]
		, [data_mart].[t_dim_account_finance].[taxop_level_02_sort_key]						= UPD.[taxop_level_02_sort_key]
		, [data_mart].[t_dim_account_finance].[taxop_level_03_sort_key]						= UPD.[taxop_level_03_sort_key]
		, [data_mart].[t_dim_account_finance].[taxop_level_04_sort_key]						= UPD.[taxop_level_04_sort_key]
		, [data_mart].[t_dim_account_finance].[taxop_level_05_sort_key]						= UPD.[taxop_level_05_sort_key]
		, [data_mart].[t_dim_account_finance].[gcart_account_id]							= UPD.[gcart_account_id]
		, [data_mart].[t_dim_account_finance].[gcart_account_description]					= UPD.[gcart_account_description]
		, [data_mart].[t_dim_account_finance].[gcart_level_01_desc]							= UPD.[gcart_level_01_desc]
		, [data_mart].[t_dim_account_finance].[gcart_level_02_desc]							= UPD.[gcart_level_02_desc]
		, [data_mart].[t_dim_account_finance].[gcart_level_03_desc]							= UPD.[gcart_level_03_desc]
		, [data_mart].[t_dim_account_finance].[gcart_level_04_desc]							= UPD.[gcart_level_04_desc]
		, [data_mart].[t_dim_account_finance].[gcart_level_05_desc]							= UPD.[gcart_level_05_desc]
		, [data_mart].[t_dim_account_finance].[gcart_level_01_sort_key]						= UPD.[gcart_level_01_sort_key]
		, [data_mart].[t_dim_account_finance].[gcart_level_02_sort_key]						= UPD.[gcart_level_02_sort_key]
		, [data_mart].[t_dim_account_finance].[gcart_level_03_sort_key]						= UPD.[gcart_level_03_sort_key]
		, [data_mart].[t_dim_account_finance].[gcart_level_04_sort_key]						= UPD.[gcart_level_04_sort_key]
		, [data_mart].[t_dim_account_finance].[gcart_level_05_sort_key]						= UPD.[gcart_level_05_sort_key]
		, [data_mart].[t_dim_account_finance].[estma_account_id]							= UPD.[estma_account_id]
		, [data_mart].[t_dim_account_finance].[estma_account_description]					= UPD.[estma_account_description]
		, [data_mart].[t_dim_account_finance].[estma_level_01_desc]							= UPD.[estma_level_01_desc]
		, [data_mart].[t_dim_account_finance].[estma_level_02_desc]							= UPD.[estma_level_02_desc]
		, [data_mart].[t_dim_account_finance].[estma_level_03_desc]							= UPD.[estma_level_03_desc]
		, [data_mart].[t_dim_account_finance].[estma_level_04_desc]							= UPD.[estma_level_04_desc]
		, [data_mart].[t_dim_account_finance].[estma_level_05_desc]							= UPD.[estma_level_05_desc]
		, [data_mart].[t_dim_account_finance].[estma_level_01_sort_key]						= UPD.[estma_level_01_sort_key]
		, [data_mart].[t_dim_account_finance].[estma_level_02_sort_key]						= UPD.[estma_level_02_sort_key]
		, [data_mart].[t_dim_account_finance].[estma_level_03_sort_key]						= UPD.[estma_level_03_sort_key]
		, [data_mart].[t_dim_account_finance].[estma_level_04_sort_key]						= UPD.[estma_level_04_sort_key]
		, [data_mart].[t_dim_account_finance].[estma_level_05_sort_key]						= UPD.[estma_level_05_sort_key]

      FROM #t_dim_account_finance_MERGE UPD
      WHERE 
        [data_mart].[t_dim_account_finance].account_id = UPD.account_id AND
	    UPD.Flag = 'UPDATE'	

      SELECT @rowcnt INSERTED
 
    -- COMMIT TRANSACTION
 
     IF @complete_rebuild_flag = 'Y'
         BEGIN

           --  BEGIN TRANSACTION

             INSERT INTO [data_mart].[t_dim_account_finance]
                (	  account_id				
					, account_description		
					, account_level_01_desc			
					, account_level_02_desc			
					, account_level_03_desc			
					, account_level_04_desc			
					, account_level_05_desc			
					, account_level_06_desc			
					, account_level_07_desc			
					, account_level_08_desc			
					, account_level_09_desc			
					, account_level_10_desc		
					, [dep_level_01_desc]					
					, [dep_level_02_desc]					
					, [dep_level_03_desc]					
				    , [dep_level_04_desc]					
				    , [dep_level_05_desc]	
					, [taxop_level_01_desc]					
					, [taxop_level_02_desc]					
					, [taxop_level_03_desc]					
					, [taxop_level_04_desc]					
					, [taxop_level_05_desc]	
					, [gcart_level_01_desc]					
					, [gcart_level_02_desc]					
					, [gcart_level_03_desc]					
				    , [gcart_level_04_desc]					
				    , [gcart_level_05_desc]	
					, [estma_level_01_desc]					
					, [estma_level_02_desc]					
					, [estma_level_03_desc]					
					, [estma_level_04_desc]					
					, [estma_level_05_desc]				
                    )
             VALUES
                (  '-2'				
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
					, 'Missing'	
	);

             INSERT INTO [data_mart].[t_dim_account_finance]
                 (	  account_id				
					, account_description		
					, account_level_01_desc			
					, account_level_02_desc			
					, account_level_03_desc			
					, account_level_04_desc			
					, account_level_05_desc			
					, account_level_06_desc			
					, account_level_07_desc			
					, account_level_08_desc			
					, account_level_09_desc			
					, account_level_10_desc		
					, [dep_level_01_desc]					
					, [dep_level_02_desc]					
					, [dep_level_03_desc]					
				    , [dep_level_04_desc]					
				    , [dep_level_05_desc]	
					, [taxop_level_01_desc]					
					, [taxop_level_02_desc]					
					, [taxop_level_03_desc]					
					, [taxop_level_04_desc]					
					, [taxop_level_05_desc]
					, [gcart_level_01_desc]					
					, [gcart_level_02_desc]					
					, [gcart_level_03_desc]					
				    , [gcart_level_04_desc]					
				    , [gcart_level_05_desc]	
					, [estma_level_01_desc]					
					, [estma_level_02_desc]					
					, [estma_level_03_desc]					
					, [estma_level_04_desc]					
					, [estma_level_05_desc]								
                )
             VALUES
                (  '-1'				
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					, 'Unknown'	
					);

            -- COMMIT TRANSACTION

         END

 END TRY
 
 BEGIN CATCH
        
       -- Grab error information from SQL functions
          DECLARE @ErrorSeverity INT           = ERROR_SEVERITY(),
                  @ErrorNumber INT             = ERROR_NUMBER(),
                  @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(),
                  @ErrorState INT              = ERROR_STATE(),
               --   @ErrorLine INT               = ERROR_LINE(),
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