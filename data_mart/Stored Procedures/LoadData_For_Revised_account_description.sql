CREATE PROC [data_mart].[LoadData_For_Revised_account_description] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_account_description]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_account_description];
  ELSE
  	CREATE TABLE [dbo].[Revised_account_description]
  	  (
  		[account_description] NVARCHAR(1000),
  		[account_description_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_account_description] 
    (
      [account_description],
  	  [account_description_Revised]
    )
    SELECT
      account_desc,
  	  account_desc
    FROM 
      stage.t_ctrl_special_accounts D
    GROUP BY
      account_desc 

  IF OBJECT_ID('tempdb..#Revised_account_description') IS NULL 
    CREATE TABLE #Revised_account_description
  	(
  		RN INT,
  		[account_description] NVARCHAR(1000),
  		[account_description_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_account_description

  INSERT INTO #Revised_account_description
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [account_description],UPPER(STRING)) rn,
	  D.account_description,
	  D.account_description [account_description_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_account_description] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[account_description] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @account_description NVARCHAR(1000) = '',
    @account_description_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_account_description
  SELECT @MinRow = MIN(rn) FROM #Revised_account_description
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @account_description = account_description FROM #Revised_account_description WHERE rn = @MinRow
	  SELECT @account_description_Revised = account_description_Revised FROM #Revised_account_description WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_account_description WHERE rn = @MinRow
	  
	  IF @account_description_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @account_description_Revised = REPLACE([account_description_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_account_description
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_account_description
	      SET [account_description_Revised] = @account_description_Revised
	      WHERE [account_description] = @account_description
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_account_description_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_account_description_DISTINCT	 
  
  CREATE TABLE #Revised_account_description_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [account_description],
      [account_description_Revised]
    FROM
      #Revised_account_description 
    GROUP BY
      [account_description],
      [account_description_Revised]    

  UPDATE [dbo].[Revised_account_description]
  SET [dbo].[Revised_account_description].[account_description_Revised] = DR.account_description_Revised
  FROM #Revised_account_description_DISTINCT  DR
  WHERE [dbo].[Revised_account_description].account_description = DR.account_description

  SELECT 1
END