CREATE PROC [data_mart].[LoadData_For_Revised_class_code_description] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_class_code_description]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_class_code_description];
  ELSE
  	CREATE TABLE [dbo].[Revised_class_code_description]
  	  (
  		[class_code_description] NVARCHAR(1000),
  		[class_code_description_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_class_code_description] 
    (
      [class_code_description],
  	  [class_code_description_Revised]
    )
    SELECT
      [class_code_description],
  	  [class_code_description]
    FROM 
       [data_mart].[t_dim_account_finance] D
    GROUP BY
      [class_code_description]  


  IF OBJECT_ID('tempdb..#Revised_class_code_description') IS NULL 
    CREATE TABLE #Revised_class_code_description
  	(
  		RN INT,
  		[class_code_description] NVARCHAR(1000),
  		[class_code_description_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_class_code_description

  INSERT INTO #Revised_class_code_description
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [class_code_description],UPPER(STRING)) rn,
	  D.class_code_description,
	  D.class_code_description [class_code_description_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_class_code_description] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[class_code_description] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @class_code_description NVARCHAR(1000) = '',
    @class_code_description_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_class_code_description
  SELECT @MinRow = MIN(rn) FROM #Revised_class_code_description
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @class_code_description = class_code_description FROM #Revised_class_code_description WHERE rn = @MinRow
	  SELECT @class_code_description_Revised = class_code_description_Revised FROM #Revised_class_code_description WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_class_code_description WHERE rn = @MinRow
	  
	  IF @class_code_description_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @class_code_description_Revised = REPLACE([class_code_description_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_class_code_description
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_class_code_description
	      SET [class_code_description_Revised] = @class_code_description_Revised
	      WHERE [class_code_description] = @class_code_description
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_class_code_description_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_class_code_description_DISTINCT	 
  
  CREATE TABLE #Revised_class_code_description_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [class_code_description],
      [class_code_description_Revised]
    FROM
      #Revised_class_code_description 
    GROUP BY
      [class_code_description],
      [class_code_description_Revised]    

  UPDATE [dbo].[Revised_class_code_description]
  SET [dbo].[Revised_class_code_description].[class_code_description_Revised] = DR.class_code_description_Revised
  FROM #Revised_class_code_description_DISTINCT  DR
  WHERE [dbo].[Revised_class_code_description].class_code_description = DR.class_code_description

  SELECT 1
END