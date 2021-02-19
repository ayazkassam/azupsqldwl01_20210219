CREATE PROC [data_mart].[LoadData_For_Revised_child_id] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_child_id]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_child_id];
  ELSE
  	CREATE TABLE [dbo].[Revised_child_id]
  	  (
  		[child_id] NVARCHAR(1000),
  		[child_id_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_child_id] 
    (
      [child_id],
  	  [child_id_Revised]
    )
    SELECT
      [child_id],
  	  [child_id]
    FROM 
      [stage].[v_qbyte_account_hierarchy_source] D
    GROUP BY
      [child_id]  

    UNION

    SELECT
      [child_id],
  	  [child_id]
    FROM 
      [stage].[t_qbyte_account_hierarchy_source_finance] D
    GROUP BY
      [child_id]  
  
  IF OBJECT_ID('tempdb..#Revised_child_id') IS NULL 
    CREATE TABLE #Revised_child_id
  	(
  		RN INT,
  		[child_id] NVARCHAR(1000),
  		[child_id_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_child_id

  INSERT INTO #Revised_child_id
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [child_id],UPPER(STRING)) rn,
	  D.child_id,
	  D.child_id [child_id_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_child_id] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[child_id] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @child_id NVARCHAR(1000) = '',
    @child_id_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_child_id
  SELECT @MinRow = MIN(rn) FROM #Revised_child_id
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @child_id = child_id FROM #Revised_child_id WHERE rn = @MinRow
	  SELECT @child_id_Revised = child_id_Revised FROM #Revised_child_id WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_child_id WHERE rn = @MinRow
	  
	  IF @child_id_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @child_id_Revised = REPLACE([child_id_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_child_id
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_child_id
	      SET [child_id_Revised] = @child_id_Revised
	      WHERE [child_id] = @child_id
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_child_id_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_child_id_DISTINCT	 
  
  CREATE TABLE #Revised_child_id_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [child_id],
      [child_id_Revised]
    FROM
      #Revised_child_id 
    GROUP BY
      [child_id],
      [child_id_Revised]    

  UPDATE [dbo].[Revised_child_id]
  SET [dbo].[Revised_child_id].[child_id_Revised] = DR.child_id_Revised
  FROM #Revised_child_id_DISTINCT  DR
  WHERE [dbo].[Revised_child_id].child_id = DR.child_id

  SELECT 1
END