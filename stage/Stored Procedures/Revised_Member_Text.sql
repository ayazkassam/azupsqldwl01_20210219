CREATE PROC [Stage].[Revised_Member_Text] @schema_name [varchar](128),@table_name [varchar](128),@column_name [varchar](128),@condition [varchar](500) AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY	
		IF len(isnull(@condition,'')) > 0
				SET @condition = ' AND ACC.'+@condition

		IF OBJECT_ID('tempdb..#accounts_for_revision') IS NOT NULL 
			DROP TABLE #accounts_for_revision
		CREATE TABLE #accounts_for_revision
		(
  			[account_level] VARCHAR(1000),
			[account_revised] VARCHAR(1000),
  			[STRING] VARCHAR(200),
  			[REPLACEMENT_STRING] VARCHAR(200),
			[RN] INT
		)

		IF OBJECT_ID('tempdb..#replacement_data') IS NOT NULL 
			DROP TABLE #replacement_data
		CREATE TABLE #replacement_data
		(
  			[STRING] VARCHAR(200),
  			[REPLACEMENT_STRING] VARCHAR(200),
			[IS_APPLIED] char(1) DEFAULT 0
		)

		INSERT INTO #replacement_data ([STRING], [REPLACEMENT_STRING])
		SELECT
				String,
				Replacement_String
			FROM
				[stage].[t_ctrl_dim_desc_text_excptions]
		WHERE
				Replacement_String IS NOT NULL
			AND Is_Active = 'Y'
			AND Cube_Name = 'ALL'

		DECLARE @rows_to_revise INT = 1,
				@sql varchar(max),
				@cur_rn INT = 1,
				@max_rn INT

		WHILE @rows_to_revise > 0
		BEGIN
			SET @sql = 'INSERT INTO #accounts_for_revision
							([account_level], [STRING], [REPLACEMENT_STRING], RN)
						select acc.' + @column_name + ', rs.string, rs.REPLACEMENT_STRING,
							ROW_NUMBER() OVER (ORDER BY UPPER(RS.STRING))
						from
							'+@schema_name+'.'+@table_name+'	acc
							join #replacement_data rs
									on acc.'+@column_name +'  COLLATE Latin1_General_BIN like ''%'' + String + ''%''	
							left join #accounts_for_revision rev
									on rev.[STRING] = rs.string
						where 
							rev.string is null
							and [IS_APPLIED] = 0 '
							+@condition+' 
			GROUP BY acc.'+@column_name+', rs.string, rs.REPLACEMENT_STRING'
			EXEC(@sql)
			SELECT @rows_to_revise = count(0) FROM #accounts_for_revision
			IF @rows_to_revise > 0
			BEGIN
				 SET @cur_rn = 1
				 SELECT @max_rn = MAX(rn) FROM #accounts_for_revision
				 WHILE @cur_rn <= @max_rn
				 BEGIN
					SET @sql =
					'UPDATE
						 '+@schema_name+'.'+@table_name+'
					SET
						 '+@schema_name+'.'+@table_name+'.' + @column_name +' = REPLACE('+@column_name+' COLLATE Latin1_General_BIN, REV.String, REV.Replacement_String)
					FROM
						#accounts_for_revision REV
					WHERE
						REV.[account_level] = '+@schema_name+'.'+@table_name+'.' + @column_name +'
						and rn = '+ cast(@cur_rn as varchar(12))
					EXEC(@sql)
					SET @cur_rn = @cur_rn + 1
				 END	
				-- should not apply already applied replacements
				UPDATE #replacement_data
				SET	
					[IS_APPLIED] = 1
				FROM
					#accounts_for_revision rev
				WHERE
					#replacement_data.string = rev.String
					and #replacement_data.Replacement_String = rev.Replacement_String

				TRUNCATE TABLE #accounts_for_revision	
			END	
		END
	 END TRY
  
  BEGIN CATCH
        
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
				--,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		-- If the error renders the transaction as uncommittable or we have open transactions, rollback
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)      

  END CATCH
END