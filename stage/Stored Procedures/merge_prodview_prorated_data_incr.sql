CREATE PROC [stage].[merge_prodview_prorated_data_incr] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	
	IF OBJECT_ID('tempdb..#t_prodview_proration_data_incr_MERGE') IS NOT NULL
      DROP TABLE #t_prodview_proration_data_incr_MERGE
	CREATE TABLE #t_prodview_proration_data_incr_MERGE(
				[Flag] varchar(10),
				[UWI] [nvarchar](50) NULL,
				[COSTCENTER] [nvarchar](50) NULL,
				[FDC] [nvarchar](50) NULL,
				[TDATE] [date] NULL,
				[GAS] [float] NULL,
				[HCLIQ] [float] NULL,
				[WATER] [float] NULL
	)

	BEGIN TRANSACTION
	
	INSERT INTO #t_prodview_proration_data_incr_MERGE
			   ([Flag]
			   ,[UWI]
			   ,[COSTCENTER]
			   ,[FDC]
			   ,[TDATE]
			   ,[GAS]
			   ,[HCLIQ]
			   ,[WATER]
			   )
    SELECT		
		'INSERT' Flag		
		,src.[UWI]
		,src.[COSTCENTER]
		,src.[FDC]
		,src.dttm
		,src.prorated_gas
		,src.prorated_oil
		,src.prorated_water
	FROM
		[stage].v_prodview_proration_data_incr as src
		LEFT JOIN [stage].[t_prodview_proration_data] as trg
		ON      (trg.uwi			= src.uwi
	      AND  trg.tdate   = src.dttm
	          )
	WHERE trg.uwi IS NULL and trg.tdate IS NULL
	UNION ALL
	 SELECT		
		'UPDATE' Flag		
		,[UWI]
		,[COSTCENTER]
		,[FDC]
		,[TDATE]
		,[GAS]
		,[HCLIQ]
		,[WATER]
	FROM
	(
		SELECT		
			src.[UWI]
			,src.[COSTCENTER]
			,src.[FDC]
			,src.dttm [TDATE]
			,src.prorated_gas [GAS]
			,src.prorated_oil [HCLIQ]
			,src.prorated_water [WATER]
		FROM
			[stage].v_prodview_proration_data_incr as src
			JOIN [stage].[t_prodview_proration_data] as trg
			ON      (trg.uwi			= src.uwi
				AND  trg.tdate   = src.dttm
					)
		EXCEPT
		SELECT		
			trg.[UWI]
			,trg.[COSTCENTER]
			,trg.[FDC]
			,[TDATE]
			,[GAS]
			,[HCLIQ]
			,[WATER]
		FROM
			[stage].v_prodview_proration_data_incr as src
			JOIN [stage].[t_prodview_proration_data] as trg
			ON      (trg.uwi			= src.uwi
				AND  trg.tdate   = src.dttm
					)
	) t
		
	
	INSERT INTO [stage].[t_prodview_proration_data]
			   ([UWI]
			   ,[COSTCENTER]
			   ,[FDC]
			   ,[TDATE]
			   ,[GAS]
			   ,[HCLIQ]
			   ,[WATER]
			   ,[LAST_UPDATE_DATE])
    SELECT
		[UWI]
		,[COSTCENTER]
		,[FDC]
		,[TDATE]
		,[GAS]
		,[HCLIQ]
		,[WATER]
		,current_timestamp
	FROM
		#t_prodview_proration_data_incr_MERGE
	WHERE Flag = 'INSERT'

	UPDATE	[stage].[t_prodview_proration_data]
	SET
		[stage].[t_prodview_proration_data].[UWI] = src.[UWI],
		[stage].[t_prodview_proration_data].[COSTCENTER] = src.[COSTCENTER],
		[stage].[t_prodview_proration_data].[FDC] = src.[FDC],
		[stage].[t_prodview_proration_data].[TDATE] = src.[TDATE],
		[stage].[t_prodview_proration_data].[GAS] = src.[GAS],
		[stage].[t_prodview_proration_data].[HCLIQ] = src.[HCLIQ],
		[stage].[t_prodview_proration_data].[WATER] = src.[WATER],
		[stage].[t_prodview_proration_data].[LAST_UPDATE_DATE] =current_timestamp
	FROM
		#t_prodview_proration_data_incr_MERGE src
	WHERE      ([stage].[t_prodview_proration_data].uwi			= src.uwi
	      AND  [stage].[t_prodview_proration_data].tdate   = src.tdate
	          )
	DECLARE @INSERTED NUMERIC(10,0) = 
			(SELECT COUNT(0) 
			 FROM 
					#t_prodview_proration_data_incr_MERGE 
			 WHERE FLAG = 'INSERT')
	
	DECLARE @UPDATED NUMERIC(10,0) = 
			(SELECT COUNT(0) 
			 FROM 
					#t_prodview_proration_data_incr_MERGE 
			 WHERE FLAG = 'UPDATE')
	
      --	
      --
	--SET @rowcnt = @@ROWCOUNT

	SELECT @INSERTED INSERTED, @UPDATED UPDATED

    COMMIT TRANSACTION

        
   
 END TRY
 
 BEGIN CATCH
        
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
			--	,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		-- If the error renders the transaction as uncommittable or we have open transactions, rollback
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)


      

  END CATCH

 -- RETURN @@ERROR

END