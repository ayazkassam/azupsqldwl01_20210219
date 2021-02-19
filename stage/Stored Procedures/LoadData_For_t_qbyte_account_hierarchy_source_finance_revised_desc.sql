CREATE PROC [stage].[LoadData_For_t_qbyte_account_hierarchy_source_finance_revised_desc] AS
BEGIN
  
  TRUNCATE TABLE [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc];
  

  INSERT INTO [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc]
	SELECT 
	ROW_NUMBER() OVER(ORDER BY child_id) row_id,
	stage.InitCap([child_id]) child_id,
	stage.InitCap([child_alias]) child_alias ,
	stage.InitCap([parent_alias]) parent_alias,
	gl_account,
	stage.InitCap(gl_account_description) gl_account_description,
	stage.InitCap(major_account_description) major_account_description,
	stage.InitCap(class_code_description) class_code_description,
	stage.InitCap(Hierarchy_Path_desc) hierarchy_path_desc,
	stage.InitCap(child_alias) child_alias_revised ,
	stage.InitCap(parent_alias) parent_alias_revised,
	stage.InitCap(gl_account_description) gl_account_description_revised,
	stage.InitCap(major_account_description) major_account_description_revised,
	stage.InitCap(class_code_description) class_code_description_revised,
	stage.InitCap(Hierarchy_Path_desc) hierarchy_path_desc_revised
	
	FROM [stage].[t_qbyte_account_hierarchy_source_finance]
	--WHERE child_id='1000_010'
	;  


  IF OBJECT_ID('tempdb..#text_exceptions') IS NULL 
    CREATE TABLE #text_exceptions
  	(
  		RN INT,
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #text_exceptions;

  INSERT INTO #text_exceptions
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY UPPER(STRING)) rn,
      rtrim(ltrim(RS.STRING)) string,
	  rtrim(ltrim(RS.REPLACEMENT_STRING)) replacement_string
	FROM [stage].[t_ctrl_dim_desc_text_excptions] RS
	WHERE RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' 
		-- and STRING in ('Cibc',' And ','"b"')
		 ;

DECLARE 
/*
    @child_alias NVARCHAR(1000) = '',
    @child_alias_Revised NVARCHAR(1000) = '',
	@parent_alias NVARCHAR(1000) = '',
	@parent_alias_Revised NVARCHAR(1000) = '',
	@gl_account_description NVARCHAR(1000) = '',
	@gl_account_description_Revised NVARCHAR(1000) = '',
	@major_account_description NVARCHAR(1000) = '',
	@major_account_description_Revised NVARCHAR(1000) = '',
	@class_code_description NVARCHAR(1000) = '',
	@class_code_description_Revised NVARCHAR(1000) = '',
    @Hierarchy_Path_desc NVARCHAR(1000) = '',
	@Hierarchy_Path_desc_Revised NVARCHAR(1000) = '',

*/
	@replacement_string NVARCHAR(1000) = '',
    @AcctMinRow INT = 1,
    @AcctMaxRow INT,
    @String VARCHAR (100) = '' ,

	@TxtMinRow INT = 1,
    @TxtMaxRow INT

  --SELECT @AcctMaxRow = MAX(row_id) FROM [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc]

  SELECT @TxtMaxRow = MAX(rn) FROM #text_exceptions
 

		
		WHILE @TxtMinRow <= @TxtMaxRow
		 BEGIN
		        SELECT @String = String FROM #text_exceptions WHERE rn = @TxtMinRow
				SELECT @replacement_string = Replacement_String FROM #text_exceptions WHERE rn = @TxtMinRow

				update [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc] 
				set child_alias_revised = replace(child_alias_revised COLLATE Latin1_General_BIN, @String, @replacement_string)
                
				update [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc] 
				set parent_alias_revised = replace(parent_alias_revised COLLATE Latin1_General_BIN, @String, @replacement_string)

				update [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc] 
				set gl_account_description_revised = replace(gl_account_description_revised COLLATE Latin1_General_BIN, @String, @replacement_string)

				update [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc] 
				set major_account_description_revised = replace(major_account_description_revised COLLATE Latin1_General_BIN, @String, @replacement_string)

				update [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc] 
				set class_code_description_revised = replace(class_code_description_revised COLLATE Latin1_General_BIN, @String, @replacement_string)

				update [stage].[t_qbyte_account_hierarchy_source_finance_revised_desc] 
				set hierarchy_path_desc_revised = replace(hierarchy_path_desc_revised COLLATE Latin1_General_BIN, @String, @replacement_string)


			   SET @TxtMinRow = @TxtMinRow + 1

		 END

	
END