CREATE PROC [stage].[merge_prodview_prorated_data] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	truncate table stage.t_stg_prodview_proration_data

	INSERT INTO stage.t_stg_prodview_proration_data
	SELECT *
	FROM  [stage].v_prodview_proration_data;


	IF OBJECT_ID('tempdb..#t_prodview_proration_data_MERGE') IS NOT NULL
		  DROP TABLE #t_prodview_proration_data_MERGE	
	CREATE TABLE #t_prodview_proration_data_MERGE
	(
		[Flag] varchar(10),
		[UWI] [nvarchar](50) NULL,
		[COSTCENTER] [nvarchar](50) NULL,
		[FDC] [nvarchar](50) NULL,
		[TDATE] [date] NULL,
		[GAS] [float] NULL,
		[HCLIQ] [float] NULL,
		[WATER] [float] NULL,
		[LAST_UPDATE_DATE] [date] NULL
	)


	BEGIN TRANSACTION
		BEGIN TRY	

		INSERT INTO #t_prodview_proration_data_MERGE
		(
			[Flag],
			[UWI], 
			[COSTCENTER], 
			[FDC], 
			[TDATE], 
			[GAS], 
			[HCLIQ],
			[WATER], 
			[LAST_UPDATE_DATE]
		)
		SELECT 
			CASE WHEN trg.uwi IS NULL and trg.tdate IS NULL THEN 'NEW'
				 ELSE 'UPDATE'
			END Flag,
			src.[UWI], 
			src.[COSTCENTER], 
			src.[FDC], 
			src.dttm as [TDATE], 
			src.prorated_gas as [GAS], 
			src.prorated_oil as [HCLIQ], 
			src.prorated_water as [WATER], 
			current_timestamp [LAST_UPDATE_DATE]
		FROM stage.t_stg_prodview_proration_data as src
		  LEFT JOIN    [stage].[t_prodview_proration_data] as trg 
		  ON      (trg.uwi			= src.uwi
			  AND  trg.tdate   = src.dttm
				  )
		UPDATE [stage].[t_prodview_proration_data]
		SET 
			[stage].[t_prodview_proration_data].[costcenter]        = src.[costcenter],
			[stage].[t_prodview_proration_data].[fdc]			    = src.[fdc],
			[stage].[t_prodview_proration_data].[gas]               = src.[gas],
			[stage].[t_prodview_proration_data].[hcliq]             = src.[hcliq],
			[stage].[t_prodview_proration_data].[water]             = src.[water],
			[stage].[t_prodview_proration_data].[last_update_date]  = src.[LAST_UPDATE_DATE]
		FROM
			#t_prodview_proration_data_MERGE src
		WHERE
			[stage].[t_prodview_proration_data].uwi			= src.uwi
			 AND  [stage].[t_prodview_proration_data].tdate   = src.[TDATE]
			 AND src.Flag='UPDATE'

		INSERT INTO [stage].[t_prodview_proration_data]
		(
			[UWI], 
			[COSTCENTER], 
			[FDC], 
			[TDATE], 
			[GAS], 
			[HCLIQ], 
			[WATER], 
			[LAST_UPDATE_DATE]
		)
		SELECT
			[UWI], 
			[COSTCENTER], 
			[FDC], 
			[TDATE], 
			[GAS], 
			[HCLIQ], 
			[WATER], 
			[LAST_UPDATE_DATE]
		FROM
			#t_prodview_proration_data_MERGE src
		WHERE src.Flag = 'NEW'
	
		DECLARE @INSERTED INT = (SELECT COUNT(*) from #t_prodview_proration_data_MERGE as src  WHERE src.Flag = 'NEW')
		DECLARE @UPDATED INT = (SELECT COUNT(*) from #t_prodview_proration_data_MERGE as src WHERE src.Flag = 'UPDATE')
		SELECT @INSERTED AS INSERTED, @UPDATED AS UPDATED

    

        
   
 END TRY
 
 BEGIN CATCH
		-- If the error renders the transaction as uncommittable or we have open transactions, rollback
	 
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
				--,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
	    IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END 
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)


      

  END CATCH
	IF @@TRANCOUNT > 0
		BEGIN
			COMMIT TRANSACTION
		END 	

END