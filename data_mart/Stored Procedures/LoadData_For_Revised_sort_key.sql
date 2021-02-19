CREATE PROC [data_mart].[LoadData_For_Revised_sort_key] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_sort_key]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_sort_key];
  ELSE
  	CREATE TABLE [dbo].[Revised_sort_key]
  	  (
  		[sort_key] NVARCHAR(1000),
  		[sort_key_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_sort_key] 
    (
      [sort_key],
  	  [sort_key_Revised]
    )
    SELECT
      [sort_key],
  	  [sort_key]
    FROM 
      [stage].[v_qbyte_account_hierarchy_source] D
    GROUP BY
      [sort_key]  

    UNION --ALL

    SELECT
      [sort_key],
  	  [sort_key]
    FROM 
      [stage].[t_qbyte_account_hierarchy_source_finance] DF
    GROUP BY
      [sort_key]  
  
  
  IF OBJECT_ID('tempdb..#Revised_sort_key') IS NULL 
    CREATE TABLE #Revised_sort_key
  	(
  		RN INT,
  		[sort_key] NVARCHAR(1000),
  		[sort_key_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_sort_key

  INSERT INTO #Revised_sort_key
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [sort_key],UPPER(STRING)) rn,
	  D.sort_key,
	  D.sort_key [sort_key_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_sort_key] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[sort_key] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @sort_key NVARCHAR(1000) = '',
    @sort_key_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_sort_key
  SELECT @MinRow = MIN(rn) FROM #Revised_sort_key
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @sort_key = sort_key FROM #Revised_sort_key WHERE rn = @MinRow
	  SELECT @sort_key_Revised = sort_key_Revised FROM #Revised_sort_key WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_sort_key WHERE rn = @MinRow
	  
	  IF @sort_key_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @sort_key_Revised = REPLACE([sort_key_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_sort_key
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_sort_key
	      SET [sort_key_Revised] = @sort_key_Revised
	      WHERE [sort_key] = @sort_key
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_sort_key_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_sort_key_DISTINCT	 
  
  CREATE TABLE #Revised_sort_key_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [sort_key],
      [sort_key_Revised]
    FROM
      #Revised_sort_key 
    GROUP BY
      [sort_key],
      [sort_key_Revised]    

  UPDATE [dbo].[Revised_sort_key]
  SET [dbo].[Revised_sort_key].[sort_key_Revised] = DR.sort_key_Revised
  FROM #Revised_sort_key_DISTINCT  DR
  WHERE [dbo].[Revised_sort_key].sort_key = DR.sort_key

  SELECT 1
END