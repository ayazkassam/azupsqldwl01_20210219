CREATE PROC [data_mart].[LoadData_For_Revised_Hierarchy_Path] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_Hierarchy_Path]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_Hierarchy_Path];
  ELSE
  	CREATE TABLE [dbo].[Revised_Hierarchy_Path]
  	  (
  		[Hierarchy_Path] NVARCHAR(1000),
  		[Hierarchy_Path_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_Hierarchy_Path] 
    (
      [Hierarchy_Path],
  	  [Hierarchy_Path_Revised]
    )
    SELECT
      [Hierarchy_Path],
  	  [Hierarchy_Path]
    FROM 
      [stage].[v_qbyte_account_hierarchy_source] D
    GROUP BY
      [Hierarchy_Path]  

    UNION --ALL

    SELECT
      [Hierarchy_Path_desc],
  	  [Hierarchy_Path_desc]
    FROM 
      [stage].[t_qbyte_account_hierarchy_source_finance] DF
    GROUP BY
      [Hierarchy_Path_desc]  

    UNION --ALL

    SELECT
      [Hierarchy_Path_desc],
  	  [Hierarchy_Path_desc]
    FROM 
      [stage].[t_ctrl_special_accounts] DF
    GROUP BY
      [Hierarchy_Path_desc] 

	 UNION --ALL

    SELECT
      [Hierarchy_Path],
  	  [Hierarchy_Path]
    FROM 
      [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels] DSS
    GROUP BY
      [Hierarchy_Path] 

  IF OBJECT_ID('tempdb..#Revised_Hierarchy_Path') IS NULL 
    CREATE TABLE #Revised_Hierarchy_Path
  	(
  		RN INT,
  		[Hierarchy_Path] NVARCHAR(1000),
  		[Hierarchy_Path_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_Hierarchy_Path

  INSERT INTO #Revised_Hierarchy_Path
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [Hierarchy_Path],UPPER(STRING)) rn,
	  D.Hierarchy_Path,
	  D.Hierarchy_Path [Hierarchy_Path_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_Hierarchy_Path] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[Hierarchy_Path] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @Hierarchy_Path NVARCHAR(1000) = '',
    @Hierarchy_Path_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_Hierarchy_Path
  SELECT @MinRow = MIN(rn) FROM #Revised_Hierarchy_Path
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @Hierarchy_Path = Hierarchy_Path FROM #Revised_Hierarchy_Path WHERE rn = @MinRow
	  SELECT @Hierarchy_Path_Revised = Hierarchy_Path_Revised FROM #Revised_Hierarchy_Path WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_Hierarchy_Path WHERE rn = @MinRow
	  
	  IF @Hierarchy_Path_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @Hierarchy_Path_Revised = REPLACE([Hierarchy_Path_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_Hierarchy_Path
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_Hierarchy_Path
	      SET [Hierarchy_Path_Revised] = @Hierarchy_Path_Revised
	      WHERE [Hierarchy_Path] = @Hierarchy_Path
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_Hierarchy_Path_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_Hierarchy_Path_DISTINCT	 
  
  CREATE TABLE #Revised_Hierarchy_Path_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [Hierarchy_Path],
      [Hierarchy_Path_Revised]
    FROM
      #Revised_Hierarchy_Path 
    GROUP BY
      [Hierarchy_Path],
      [Hierarchy_Path_Revised]
    

  UPDATE [dbo].[Revised_Hierarchy_Path]
  SET [dbo].[Revised_Hierarchy_Path].[Hierarchy_Path_Revised] = DR.Hierarchy_Path_Revised
  FROM #Revised_Hierarchy_Path_DISTINCT  DR
  WHERE [dbo].[Revised_Hierarchy_Path].Hierarchy_Path = DR.Hierarchy_Path

  SELECT 1
END