CREATE PROC [data_mart].[LoadData_For_Revised_child_alias] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_child_alias]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_child_alias];
  ELSE
  	CREATE TABLE [dbo].[Revised_child_alias]
  	  (
  		[child_alias] NVARCHAR(1000),
  		[child_alias_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_child_alias] 
    (
      [child_alias],
  	  [child_alias_Revised]
    )
    SELECT
      [child_alias],
  	  [child_alias]
    FROM 
      [stage].[v_qbyte_account_hierarchy_source] D
    GROUP BY
      [child_alias]  

    UNION

    SELECT
      [child_alias],
  	  [child_alias]
    FROM 
      [stage].[t_qbyte_account_hierarchy_source_finance] D
    GROUP BY
      [child_alias] 
  
  IF OBJECT_ID('tempdb..#Revised_child_alias') IS NULL 
    CREATE TABLE #Revised_child_alias
  	(
  		RN INT,
  		[child_alias] NVARCHAR(1000),
  		[child_alias_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_child_alias

  INSERT INTO #Revised_child_alias
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [child_alias],UPPER(STRING)) rn,
	  D.child_alias,
	  D.child_alias [child_alias_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_child_alias] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[child_alias] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @child_alias NVARCHAR(1000) = '',
    @child_alias_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '',
    @Replacement_String VARCHAR (100) = ''  

  SELECT @MaxRow = MAX(rn) FROM #Revised_child_alias
  SELECT @MinRow = MIN(rn) FROM #Revised_child_alias
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	

	  SELECT @child_alias = child_alias FROM #Revised_child_alias WHERE rn = @MinRow
	---  SELECT @child_alias_Revised = child_alias_Revised FROM #Revised_child_alias WHERE rn = @MinRow

	  SELECT @String = String FROM #Revised_child_alias WHERE rn = @MinRow
	  SELECT @Replacement_String = Replacement_String FROM #Revised_child_alias WHERE rn = @MinRow
	 -- IF @child_alias_Revised LIKE '%' + @String + '%'
	  --  BEGIN
	      --SELECT 
	      --  @child_alias_Revised = REPLACE([child_alias_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      --FROM #Revised_child_alias
	      --WHERE RN = @MinRow            
	  
	      --UPDATE #Revised_child_alias
	      --SET [child_alias_Revised] = @child_alias_Revised
	      --WHERE RN = @MinRow--[child_alias] = @child_alias

		   UPDATE [dbo].[Revised_child_alias]
           SET [child_alias_Revised] = REPLACE([child_alias_Revised] COLLATE Latin1_General_BIN, @String, @Replacement_String)
		   WHERE [child_alias] = @child_alias
	  
          --END
	  
	  SET @MinRow = @MinRow + 1

	END

  --IF OBJECT_ID('tempdb..#Revised_child_alias_DISTINCT') IS NOT NULL
  --  DROP TABLE #Revised_child_alias_DISTINCT	 
  
  --CREATE TABLE #Revised_child_alias_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
  --  AS  
  --  SELECT 
  --    [child_alias],
  --    [child_alias_Revised]
  --  FROM
  --    #Revised_child_alias 
  --  GROUP BY
  --    [child_alias],
  --    [child_alias_Revised]    

  --UPDATE [dbo].[Revised_child_alias]
  --SET [dbo].[Revised_child_alias].[child_alias_Revised] = DR.child_alias_Revised
  --FROM #Revised_child_alias_DISTINCT  DR
  --WHERE [dbo].[Revised_child_alias].child_alias = DR.child_alias

  SELECT 1
END