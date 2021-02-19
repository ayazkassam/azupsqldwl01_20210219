CREATE PROC [dbo].[spMerge_t_dim_account_capital] AS
BEGIN
  --WITH CTE
  --  AS
	 -- (
	 --SELECT * FROM sys.tables 
	 --WHERE name = '#t_dim_account_capital'
  IF OBJECT_ID('tempdb..#t_dim_account_capital') IS NULL
	CREATE TABLE #t_dim_account_capital
		(
		    [Flag] [varchar](10) NOT NULL,
			[account_id] [varchar](500) NULL,
			[parent_id] [varchar](500) NULL,
			[account_desc] [varchar](4204) NULL,
			[account_level_01] [varchar](500) NULL,
			[account_level_02] [varchar](500) NULL,
			[account_level_03] [varchar](500) NULL,
			[account_level_04] [varchar](500) NULL,
			[account_level_05] [varchar](500) NULL,
			[account_formula] [varchar](4000) NULL,
			[account_formula_property] [varchar](4000) NULL,
			[unary_operator] [varchar](10) NULL,
			[major_account] [varchar](100) NULL,
			[minor_account] [varchar](100) NULL,
			[gl_account] [varchar](201) NULL,
			[major_account_description] [varchar](4000) NULL,
			[major_class_code] [varchar](4000) NULL,
			[class_code_description] [varchar](4000) NULL,
			[product_code] [varchar](50) NULL,
			[source] [varchar](100) NULL,
			[sort_key] [varchar](500) NULL,
			[ID] [bigint] NULL,
			[LastUpdatedDtm] [datetime] NULL
		)

  INSERT INTO #t_dim_account_capital
    SELECT 
  	  CASE
  	  	WHEN Target.account_id IS NULL AND Target.parent_id IS NULL THEN 'NEW'
  	  	WHEN ((Target.account_id IS NOT NULL AND Target.parent_id IS NOT NULL) OR (Target.account_id IS NOT NULL AND Target.parent_id IS NULL))AND (ISNULL(Target.account_desc, '') <> ISNULL(Source.account_desc, '')) THEN 'UPDATE'
  	  ELSE
  	    'EXISTING'
  	  END Flag,	
  	  --Target.account_id,
  	  --Target.parent_id,
  	  --Source.*
        Source.[account_id],
  	  Source.[parent_id],
  	  Source.[account_desc],
  	  Source.[account_level_01],
  	  Source.[account_level_02],
  	  Source.[account_level_03],
  	  Source.[account_level_04],
  	  Source.[account_level_05],
  	  Source.[account_formula],
  	  Source.[account_formula_property],
  	  Source.[unary_operator],
  	  Source.[major_account],
  	  Source.[minor_account],
  	  Source.[gl_account],
  	  Source.[major_account_description],
  	  Source.[major_class_code],
  	  Source.[class_code_description],
  	  Source.[product_code],
  	  Source.[source],
  	  Source.[sort_key],
  	  Source.[ID],
  	  Source.[LastUpdatedDtm]
    FROM [dbo].[t_dim_account_capital_clean] Source
    LEFT JOIN [dbo].[t_dim_account_capital] Target
  	  ON Source.account_id = Target.account_id AND
  	     ISNULL(Source.parent_id, -1) = ISNULL(Target.parent_id, -1)

  INSERT INTO [dbo].[t_dim_account_capital]
    SELECT
      [account_id],
	  [parent_id],
	  [account_desc],
	  [account_level_01],
	  [account_level_02],
	  [account_level_03],
	  [account_level_04],
	  [account_level_05],
	  [account_formula],
	  [account_formula_property],
	  [unary_operator],
	  [major_account],
	  [minor_account],
	  [gl_account],
	  [major_account_description],
	  [major_class_code],
	  [class_code_description],
	  [product_code],
	  [source],
	  [sort_key],
	  [ID],
	  [LastUpdatedDtm]	  
	FROM
	  #t_dim_account_capital
    WHERE 
	  Flag = 'NEW'
	  
  UPDATE [dbo].[t_dim_account_capital]
  SET [dbo].[t_dim_account_capital].account_desc = UPD.account_desc
  FROM #t_dim_account_capital UPD
  WHERE 
    [dbo].[t_dim_account_capital].[account_id] = UPD.[account_id] AND
	ISNULL([dbo].[t_dim_account_capital].[parent_id], -1) = ISNULL(UPD.[parent_id], -1) AND
	UPD.Flag = 'UPDATE'
	  
  --UPDATE D
  --SET D.account_desc = UPD.account_desc
  --FROM 
  --  [dbo].[t_dim_account_capital] D
  --INNER JOIN #t_dim_account_capital UPD  
  --  ON D.[account_id] = UPD.[account_id] AND
	 --  D.[parent_id] = UPD.[parent_id] AND
	 --  UPD.Flag = 'UPDATED'

  IF OBJECT_ID('tempdb..#t_dim_account_capital') IS NOT NULL
	DROP TABLE #t_dim_account_capital
END