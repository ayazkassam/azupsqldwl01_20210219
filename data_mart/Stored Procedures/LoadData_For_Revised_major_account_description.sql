CREATE PROC [data_mart].[LoadData_For_Revised_major_account_description] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_major_account_description]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_major_account_description];
  ELSE
  	CREATE TABLE [dbo].[Revised_major_account_description]
  	  (
  		[major_account_description] NVARCHAR(1000),
  		[major_account_description_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_major_account_description] 
    (
      [major_account_description],
  	  [major_account_description_Revised]
    )
    SELECT
      [major_account_description],
  	  [major_account_description]
    FROM 
      [stage].[v_qbyte_account_hierarchy_source] D
    GROUP BY
      [major_account_description]  

    UNION

    SELECT
      [major_account_description],
  	  [major_account_description]
    FROM 
      [stage].[t_qbyte_account_hierarchy_source_finance] D
    GROUP BY
      [major_account_description] 

  IF OBJECT_ID('tempdb..#Revised_major_account_description') IS NULL 
    CREATE TABLE #Revised_major_account_description
  	(
  		RN INT,
  		[major_account_description] NVARCHAR(1000),
  		[major_account_description_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_major_account_description

  INSERT INTO #Revised_major_account_description
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [major_account_description],UPPER(STRING)) rn,
	  D.major_account_description,
	  D.major_account_description [major_account_description_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_major_account_description] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[major_account_description] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @major_account_description NVARCHAR(1000) = '',
    @major_account_description_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_major_account_description
  SELECT @MinRow = MIN(rn) FROM #Revised_major_account_description
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @major_account_description = major_account_description FROM #Revised_major_account_description WHERE rn = @MinRow
	  SELECT @major_account_description_Revised = major_account_description_Revised FROM #Revised_major_account_description WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_major_account_description WHERE rn = @MinRow
	  
	  IF @major_account_description_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @major_account_description_Revised = REPLACE([major_account_description_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_major_account_description
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_major_account_description
	      SET [major_account_description_Revised] = @major_account_description_Revised
	      WHERE [major_account_description] = @major_account_description
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_major_account_description_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_major_account_description_DISTINCT	 
  
  CREATE TABLE #Revised_major_account_description_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [major_account_description],
      [major_account_description_Revised]
    FROM
      #Revised_major_account_description 
    GROUP BY
      [major_account_description],
      [major_account_description_Revised]    

  UPDATE [dbo].[Revised_major_account_description]
  SET [dbo].[Revised_major_account_description].[major_account_description_Revised] = DR.major_account_description_Revised
  FROM #Revised_major_account_description_DISTINCT  DR
  WHERE [dbo].[Revised_major_account_description].major_account_description = DR.major_account_description

  SELECT 1
END