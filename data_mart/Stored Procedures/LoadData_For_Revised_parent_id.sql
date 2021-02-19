CREATE PROC [data_mart].[LoadData_For_Revised_parent_id] AS
BEGIN
  
  IF OBJECT_ID('[dbo].[Revised_parent_id]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Revised_parent_id];
  ELSE
  	CREATE TABLE [dbo].[Revised_parent_id]
  	  (
  		[parent_id] NVARCHAR(1000),
  		[parent_id_Revised] NVARCHAR(1000)
  	  )
  
  INSERT INTO [dbo].[Revised_parent_id] 
    (
      [parent_id],
  	  [parent_id_Revised]
    )
    SELECT
      [parent_id],
  	  [parent_id]
    FROM 
      [stage].[v_qbyte_account_hierarchy_source] D
    GROUP BY
      [parent_id]  

    UNION

    SELECT
      [parent_id],
  	  [parent_id]
    FROM 
      [stage].[t_qbyte_account_hierarchy_source_finance] D
    GROUP BY
      [parent_id] 
  
  IF OBJECT_ID('tempdb..#Revised_parent_id') IS NULL 
    CREATE TABLE #Revised_parent_id
  	(
  		RN INT,
  		[parent_id] NVARCHAR(1000),
  		[parent_id_Revised] NVARCHAR(1000),
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #Revised_parent_id

  INSERT INTO #Revised_parent_id
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY [parent_id],UPPER(STRING)) rn,
	  D.parent_id,
	  D.parent_id [parent_id_Revised],
      RS.STRING,
	  RS.REPLACEMENT_STRING
	FROM [dbo].[Revised_parent_id] D
	INNER JOIN [stage].[t_ctrl_dim_desc_text_excptions] RS
	  ON RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'ALL' AND
	     D.[parent_id] COLLATE Latin1_General_BIN like '%' + String + '%'		 

  DECLARE 
    @parent_id NVARCHAR(1000) = '',
    @parent_id_Revised NVARCHAR(1000) = '',
    @MinRow INT = 1,
    @MaxRow INT,
    @String VARCHAR (100) = '' 

  SELECT @MaxRow = MAX(rn) FROM #Revised_parent_id
  SELECT @MinRow = MIN(rn) FROM #Revised_parent_id
  
  WHILE @MinRow <= @MaxRow
	BEGIN
	
	  SELECT @parent_id = parent_id FROM #Revised_parent_id WHERE rn = @MinRow
	  SELECT @parent_id_Revised = parent_id_Revised FROM #Revised_parent_id WHERE rn = @MinRow
	  SELECT @String = String FROM #Revised_parent_id WHERE rn = @MinRow
	  
	  IF @parent_id_Revised LIKE '%' + @String + '%'
	    BEGIN
	      SELECT 
	        @parent_id_Revised = REPLACE([parent_id_Revised] COLLATE Latin1_General_BIN, String, Replacement_String)
	      FROM #Revised_parent_id
	      WHERE RN = @MinRow            
	  
	      UPDATE #Revised_parent_id
	      SET [parent_id_Revised] = @parent_id_Revised
	      WHERE [parent_id] = @parent_id
	  
          END
	  
	  SET @MinRow = @MinRow + 1

	END

  IF OBJECT_ID('tempdb..#Revised_parent_id_DISTINCT') IS NOT NULL
    DROP TABLE #Revised_parent_id_DISTINCT	 
  
  CREATE TABLE #Revised_parent_id_DISTINCT WITH (DISTRIBUTION = ROUND_ROBIN)
    AS  
    SELECT 
      [parent_id],
      [parent_id_Revised]
    FROM
      #Revised_parent_id 
    GROUP BY
      [parent_id],
      [parent_id_Revised]    

  UPDATE [dbo].[Revised_parent_id]
  SET [dbo].[Revised_parent_id].[parent_id_Revised] = DR.parent_id_Revised
  FROM #Revised_parent_id_DISTINCT  DR
  WHERE [dbo].[Revised_parent_id].parent_id = DR.parent_id

  SELECT 1
END