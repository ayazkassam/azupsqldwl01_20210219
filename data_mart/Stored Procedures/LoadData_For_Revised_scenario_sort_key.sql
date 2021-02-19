CREATE PROC [data_mart].[LoadData_For_Revised_scenario_sort_key] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_scenario_sort_key]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_scenario_sort_key];
  ELSE
  	CREATE TABLE [dbo].[Revised_scenario_sort_key]
  	  (
  		[scenario_sort_key] NVARCHAR(1000),
  		[scenario_sort_key_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_scenario_sort_key] 
    (
      [scenario_sort_key],
  	  [scenario_sort_key_Revised]
    )
    SELECT
      [scenario_sort_key],
  	  [scenario_sort_key]
    FROM 
      [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels] D
    GROUP BY
      [scenario_sort_key]  
  
  IF OBJECT_ID('tempdb..#Revised_scenario_sort_key') IS NULL 
    CREATE TABLE #Revised_scenario_sort_key
  	(
  		RN INT,
  		[scenario_sort_key] NVARCHAR(1000),
  		[scenario_sort_key_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_scenario_sort_key

  INSERT INTO #Revised_scenario_sort_key
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [scenario_sort_key],UPPER(STRING)) rn,
	  D.scenario_sort_key,
	  D.scenario_sort_key [scenario_sort_key_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_scenario_sort_key] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[scenario_sort_key] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @scenario_sort_key NVARCHAR(1000) = '',
    @scenario_sort_key_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_scenario_sort_key
  SELECT @MinRow = MIN(rn) FROM #Revised_scenario_sort_key
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @scenario_sort_key = scenario_sort_key FROM #Revised_scenario_sort_key WHERE rn = @MinRow
	  SELECT @scenario_sort_key_Revised = scenario_sort_key_Revised FROM #Revised_scenario_sort_key WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_scenario_sort_key WHERE rn = @MinRow
	  
	  IF @scenario_sort_key_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @scenario_sort_key_Revised = REPLACE([scenario_sort_key_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_scenario_sort_key
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_scenario_sort_key
	      SET [scenario_sort_key_Revised] = @scenario_sort_key_Revised
	      WHERE [scenario_sort_key] = @scenario_sort_key
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_scenario_sort_key_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_scenario_sort_key_DISTINCT	 
  
  CREATE TABLE #Revised_scenario_sort_key_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [scenario_sort_key],
      [scenario_sort_key_Revised]
    FROM
      #Revised_scenario_sort_key 
    GROUP BY
      [scenario_sort_key],
      [scenario_sort_key_Revised]    

  UPDATE [dbo].[Revised_scenario_sort_key]
  SET [dbo].[Revised_scenario_sort_key].[scenario_sort_key_Revised] = DR.scenario_sort_key_Revised
  FROM #Revised_scenario_sort_key_DISTINCT  DR
  WHERE [dbo].[Revised_scenario_sort_key].scenario_sort_key = DR.scenario_sort_key

  SELECT 1
END