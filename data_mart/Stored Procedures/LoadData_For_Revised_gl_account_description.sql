CREATE PROC [data_mart].[LoadData_For_Revised_gl_account_description] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_gl_account_description]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_gl_account_description];
  ELSE
  	CREATE TABLE [dbo].[Revised_gl_account_description]
  	  (
  		[gl_account_description] NVARCHAR(1000),
  		[gl_account_description_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_gl_account_description] 
    (
      [gl_account_description],
  	  [gl_account_description_Revised]
    )
    SELECT
      [gl_account_description],
  	  [gl_account_description]
    FROM 
      [stage].[v_qbyte_account_hierarchy_source] D
    GROUP BY
      [gl_account_description] 

    UNION

    SELECT
      [gl_account_description],
  	  [gl_account_description]
    FROM 
      [stage].[t_qbyte_account_hierarchy_source_finance] D
    GROUP BY
      [gl_account_description] 	  
 
     UNION

    SELECT
      [gl_account_description],
  	  [gl_account_description]
    FROM 
      [data_mart].[t_dim_account_finance] D
    GROUP BY
      [gl_account_description] 	

  IF OBJECT_ID('tempdb..#Revised_gl_account_description') IS NULL 
    CREATE TABLE #Revised_gl_account_description
  	(
  		RN INT,
  		[gl_account_description] NVARCHAR(1000),
  		[gl_account_description_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_gl_account_description

  INSERT INTO #Revised_gl_account_description
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [gl_account_description],UPPER(STRING)) rn,
	  D.gl_account_description,
	  D.gl_account_description [gl_account_description_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_gl_account_description] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[gl_account_description] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @gl_account_description NVARCHAR(1000) = '',
    @gl_account_description_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_gl_account_description
  SELECT @MinRow = MIN(rn) FROM #Revised_gl_account_description
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @gl_account_description = gl_account_description FROM #Revised_gl_account_description WHERE rn = @MinRow
	  SELECT @gl_account_description_Revised = gl_account_description_Revised FROM #Revised_gl_account_description WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_gl_account_description WHERE rn = @MinRow
	  
	  IF @gl_account_description_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @gl_account_description_Revised = REPLACE([gl_account_description_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_gl_account_description
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_gl_account_description
	      SET [gl_account_description_Revised] = @gl_account_description_Revised
	      WHERE [gl_account_description] = @gl_account_description
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_gl_account_description_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_gl_account_description_DISTINCT	 
  
  CREATE TABLE #Revised_gl_account_description_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [gl_account_description],
      [gl_account_description_Revised]
    FROM
      #Revised_gl_account_description 
    GROUP BY
      [gl_account_description],
      [gl_account_description_Revised]    

  UPDATE [dbo].[Revised_gl_account_description]
  SET [dbo].[Revised_gl_account_description].[gl_account_description_Revised] = DR.gl_account_description_Revised
  FROM #Revised_gl_account_description_DISTINCT  DR
  WHERE [dbo].[Revised_gl_account_description].gl_account_description = DR.gl_account_description

  SELECT 1
END