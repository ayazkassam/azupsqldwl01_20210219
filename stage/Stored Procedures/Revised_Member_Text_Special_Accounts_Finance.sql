CREATE PROC [Stage].[Revised_Member_Text_Special_Accounts_Finance] AS
BEGIN
 BEGIN TRY	
	SET NOCOUNT ON
	 IF OBJECT_ID('tempdb..#obj_data_to_update') IS NOT NULL 
			DROP TABLE #obj_data_to_update

	;WITH OBJ_DATA AS
	(
		SELECT 1 ID, 'stage'sch_name, 't_ctrl_special_accounts' tbl_name, 'account_level_' col_name_pref, 10 col_count
		UNION ALL
		SELECT 2 ID,'stage'sch_name, 't_ctrl_special_accounts' tbl_name, 'account_desc' col_name_pref,  0 col_count
	)
	SELECT * INTO #obj_data_to_update
	FROM
		OBJ_DATA

	DECLARE @max_id INT = (SELECT MAX(ID) FROM #obj_data_to_update),
			@cur_id INT = (SELECT MIN(ID) FROM #obj_data_to_update),
			@sch_name VARCHAR(128),
			@tbl_name VARCHAR(128),
			@col_name_pref VARCHAR(128),
			@col_count INT,
			@col_idx_max INT,
			@col_idx_cur INT,
			@str_num VARCHAR(2),
			@col_name VARCHAR(128),
			@sql VARCHAR(4000)
	WHILE @cur_id <= @max_id
	BEGIN
		SELECT
			@sch_name = sch_name,
			@tbl_name = tbl_name,
			@col_name_pref = col_name_pref,
			@col_count = col_count
		FROM
			#obj_data_to_update
		WHERE ID = @cur_id
		SET @col_idx_max = @col_count
		IF @col_count = 0 
			SET @col_idx_cur = 0
		ELSE
			SET @col_idx_cur = 1
		WHILE @col_idx_cur <= @col_idx_max
		BEGIN
			SET @col_name = @col_name_pref
			if @col_idx_cur>0
			BEGIN
				SELECT @str_num = cast(@col_idx_cur as varchar(2))
				IF LEN(@str_num) = 1 
					SET @str_num = '0' + @str_num
				SET @col_name = @col_name_pref+@str_num
			END
			SET @sql = 'UPDATE '+@sch_name+'.'+@tbl_name+' SET '+@col_name+'=stage.InitCap('+@col_name+')'
			PRINT 'Updating '+@sch_name+'.'+@tbl_name+'.'+@col_name
			EXEC (@sql)
			EXEC Stage.Revised_Member_Text 
						@schema_name=@sch_name,
						@table_name=@tbl_name,
						@column_name=@col_name,
						@condition='is_finance = 1'
			SET @col_idx_cur = @col_idx_cur + 1
		END
		SET @cur_id = @cur_id + 1
	END
	END TRY
  
  BEGIN CATCH
        
      THROW

  END CATCH
END