CREATE PROC [data_mart].[LoadData_For_t_ctrl_Revised_account_description] AS
BEGIN
  
  TRUNCATE TABLE [stage].[t_ctrl_Revised_account_description];
  

  INSERT INTO [stage].[t_ctrl_Revised_account_description]
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [account_description],UPPER(account_id)) row_id,
	  account_id,
	  account_description,
	  null [account_description_Revised]
	FROM [data_mart].[t_dim_account_finance];  


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
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [stage].[t_ctrl_dim_desc_text_excptions] RS
	WHERE RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' ;

DECLARE 
    @account_description NVARCHAR(1000) = '',
    @account_description_Revised NVARCHAR(1000) = '',
    @AcctMinRow INT = 1,
    @AcctMaxRow INT,
    @String VARCHAR (100) = '' ,

	@TxtMinRow INT = 1,
    @TxtMaxRow INT

  SELECT @AcctMaxRow = MAX(row_id) FROM [stage].[t_ctrl_Revised_account_description]

  SELECT @TxtMaxRow = MAX(rn) FROM #text_exceptions
  
  WHILE @AcctMinRow <= @AcctMaxRow
	BEGIN
	
	  SELECT @account_description = account_description FROM [stage].[t_ctrl_Revised_account_description] WHERE row_id = @AcctMinRow
	--  SELECT @account_description_Revised = account_description_Revised FROM #Revised_account_description WHERE rn = @MinRow
	--  SELECT @String = String FROM #Revised_account_description WHERE rn = @MinRow
	    
		SET @TxtMinRow = 1
		WHILE @TxtMinRow <= @TxtMaxRow
		 BEGIN
		        SELECT @String = String FROM #text_exceptions WHERE rn = @TxtMinRow
				IF @account_description LIKE '%' + @String + '%'
				    BEGIN
				   --   SELECT 
				   --     @account_description_Revised = REPLACE(@account_description COLLATE Latin1_General_BIN, String, Replacement_String)
				   --   FROM #text_exceptions
				   --   WHERE string = @String
					  ----rn = @TxtMinRow
					  				  
				   --   UPDATE [stage].[t_ctrl_Revised_account_description]
				   --   SET [account_description_Revised] = @account_description_Revised
				   --   WHERE row_id = @AcctMinRow

					  break;
					  -- goto next account
				  
				    END

			   SET @TxtMinRow = @TxtMinRow + 1

		 END

	  SET @AcctMinRow = @AcctMinRow + 1

	END
	
END