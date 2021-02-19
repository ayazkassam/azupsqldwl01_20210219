CREATE PROC [stage].[merge_incr_ihs_pden_production_month] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	
	--BEGIN TRANSACTION

    IF OBJECT_ID('tempdb..#t_ihs_pden_production_month_MERGE') IS NOT NULL
      DROP TABLE #t_ihs_pden_production_month_MERGE	 

    CREATE TABLE #t_ihs_pden_production_month_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS	
	    SELECT
	      'NEW' Flag,
			src.[PDEN_ID],
			src.[PDEN_TYPE],
			src.[SOURCE],
			src.[YEAR],
			src.[MONTH],
			src.[PROD_DATE],
			src.[HOURS],
			src.[GAS],
			src.[WATER],
			src.[OIL_BT],
			src.[COND],
			src.[CUM_GAS],
			src.[CUM_OIL_BT],
			src.[CUM_WATER],
			src.[CUM_COND],
			src.[CUM_HOURS],
			src.[TOTAL_FLUID],
			src.[GAS_CAL_DAY],
			src.[OIL_CAL_DAY],
			src.[WATER_CAL_DAY],
			src.[COND_CAL_DAY],
			src.[TOTAL_FLUID_CAL_DAY],
			src.[GAS_ACT_DAY],
			src.[OIL_ACT_DAY],
			src.[WATER_ACT_DAY],
			src.[COND_ACT_DAY],
			src.[TOTAL_FLUID_ACT_DAY],
			src.[GOR],
			src.[WGR],
			src.[WOR],
			src.[WCUT],
			src.[OCUT],
			src.[CCUT],
			src.[CGR],
			src.[GAS_FLUID_RATIO],
			src.[LAST_3_FLUID],
			src.[LAST_3_CCUT],
			src.[LAST_3_OCUT],
			src.[LAST_3_CGR],
			src.[PROVINCE_STATE],
			src.[ROW_CREATED_BY],
			src.[ROW_CREATED_DATE],
			src.[ROW_CHANGED_BY],
			src.[ROW_CHANGED_DATE],
			src.[LAST_PROCESS],
			src.[BRK_WATER],
			src.[SRC_WATER]
        FROM
          [stage].[t_ihs_pden_production_month_incr] as src
        LEFT JOIN [stage].[t_ihs_pden_production_month] as trg
          ON trg.pden_id = src.pden_id AND
		     trg.prod_date = src.prod_date
        WHERE
		  trg.pden_id IS NULL AND
		  trg.prod_date IS NULL

        UNION ALL

	    SELECT
	      'UPDATE' Flag,
			src.[PDEN_ID],
			src.[PDEN_TYPE],
			src.[SOURCE],
			src.[YEAR],
			src.[MONTH],
			src.[PROD_DATE],
			src.[HOURS],
			src.[GAS],
			src.[WATER],
			src.[OIL_BT],
			src.[COND],
			src.[CUM_GAS],
			src.[CUM_OIL_BT],
			src.[CUM_WATER],
			src.[CUM_COND],
			src.[CUM_HOURS],
			src.[TOTAL_FLUID],
			src.[GAS_CAL_DAY],
			src.[OIL_CAL_DAY],
			src.[WATER_CAL_DAY],
			src.[COND_CAL_DAY],
			src.[TOTAL_FLUID_CAL_DAY],
			src.[GAS_ACT_DAY],
			src.[OIL_ACT_DAY],
			src.[WATER_ACT_DAY],
			src.[COND_ACT_DAY],
			src.[TOTAL_FLUID_ACT_DAY],
			src.[GOR],
			src.[WGR],
			src.[WOR],
			src.[WCUT],
			src.[OCUT],
			src.[CCUT],
			src.[CGR],
			src.[GAS_FLUID_RATIO],
			src.[LAST_3_FLUID],
			src.[LAST_3_CCUT],
			src.[LAST_3_OCUT],
			src.[LAST_3_CGR],
			src.[PROVINCE_STATE],
			src.[ROW_CREATED_BY],
			src.[ROW_CREATED_DATE],
			src.[ROW_CHANGED_BY],
			src.[ROW_CHANGED_DATE],
			src.[LAST_PROCESS],
			src.[BRK_WATER],
			src.[SRC_WATER]
        FROM
		  (
	         SELECT
				src.[PDEN_ID],
				src.[PDEN_TYPE],
				src.[SOURCE],
				src.[YEAR],
				src.[MONTH],
				src.[PROD_DATE],
				src.[HOURS],
				src.[GAS],
				src.[WATER],
				src.[OIL_BT],
				src.[COND],
				src.[CUM_GAS],
				src.[CUM_OIL_BT],
				src.[CUM_WATER],
				src.[CUM_COND],
				src.[CUM_HOURS],
				src.[TOTAL_FLUID],
				src.[GAS_CAL_DAY],
				src.[OIL_CAL_DAY],
				src.[WATER_CAL_DAY],
				src.[COND_CAL_DAY],
				src.[TOTAL_FLUID_CAL_DAY],
				src.[GAS_ACT_DAY],
				src.[OIL_ACT_DAY],
				src.[WATER_ACT_DAY],
				src.[COND_ACT_DAY],
				src.[TOTAL_FLUID_ACT_DAY],
				src.[GOR],
				src.[WGR],
				src.[WOR],
				src.[WCUT],
				src.[OCUT],
				src.[CCUT],
				src.[CGR],
				src.[GAS_FLUID_RATIO],
				src.[LAST_3_FLUID],
				src.[LAST_3_CCUT],
				src.[LAST_3_OCUT],
				src.[LAST_3_CGR],
				src.[PROVINCE_STATE],
				src.[ROW_CREATED_BY],
				src.[ROW_CREATED_DATE],
				src.[ROW_CHANGED_BY],
				src.[ROW_CHANGED_DATE],
				src.[LAST_PROCESS],
				src.[BRK_WATER],
				src.[SRC_WATER]
			FROM
			  [stage].[t_ihs_pden_production_month_incr] as src
			INNER JOIN [stage].[t_ihs_pden_production_month] as trg
			  ON trg.pden_id = src.pden_id AND
				 trg.prod_date = src.prod_date

             EXCEPT

	         SELECT
				trg.[PDEN_ID],
				trg.[PDEN_TYPE],
				trg.[SOURCE],
				trg.[YEAR],
				trg.[MONTH],
				trg.[PROD_DATE],
				trg.[HOURS],
				trg.[GAS],
				trg.[WATER],
				trg.[OIL_BT],
				trg.[COND],
				trg.[CUM_GAS],
				trg.[CUM_OIL_BT],
				trg.[CUM_WATER],
				trg.[CUM_COND],
				trg.[CUM_HOURS],
				trg.[TOTAL_FLUID],
				trg.[GAS_CAL_DAY],
				trg.[OIL_CAL_DAY],
				trg.[WATER_CAL_DAY],
				trg.[COND_CAL_DAY],
				trg.[TOTAL_FLUID_CAL_DAY],
				trg.[GAS_ACT_DAY],
				trg.[OIL_ACT_DAY],
				trg.[WATER_ACT_DAY],
				trg.[COND_ACT_DAY],
				trg.[TOTAL_FLUID_ACT_DAY],
				trg.[GOR],
				trg.[WGR],
				trg.[WOR],
				trg.[WCUT],
				trg.[OCUT],
				trg.[CCUT],
				trg.[CGR],
				trg.[GAS_FLUID_RATIO],
				trg.[LAST_3_FLUID],
				trg.[LAST_3_CCUT],
				trg.[LAST_3_OCUT],
				trg.[LAST_3_CGR],
				trg.[PROVINCE_STATE],
				trg.[ROW_CREATED_BY],
				trg.[ROW_CREATED_DATE],
				trg.[ROW_CHANGED_BY],
				trg.[ROW_CHANGED_DATE],
				trg.[LAST_PROCESS],
				trg.[BRK_WATER],
				trg.[SRC_WATER]
             FROM
               [stage].[t_ihs_pden_production_month] as trg
		  ) src

	INSERT INTO [stage].[t_ihs_pden_production_month]
	  (
		[PDEN_ID],
		[PDEN_TYPE],
		[SOURCE],
		[YEAR],
		[MONTH],
		[PROD_DATE],
		[HOURS],
		[GAS],
		[WATER],
		[OIL_BT],
		[COND],
		[CUM_GAS],
		[CUM_OIL_BT],
		[CUM_WATER],
		[CUM_COND],
		[CUM_HOURS],
		[TOTAL_FLUID],
		[GAS_CAL_DAY],
		[OIL_CAL_DAY],
		[WATER_CAL_DAY],
		[COND_CAL_DAY],
		[TOTAL_FLUID_CAL_DAY],
		[GAS_ACT_DAY],
		[OIL_ACT_DAY],
		[WATER_ACT_DAY],
		[COND_ACT_DAY],
		[TOTAL_FLUID_ACT_DAY],
		[GOR],
		[WGR],
		[WOR],
		[WCUT],
		[OCUT],
		[CCUT],
		[CGR],
		[GAS_FLUID_RATIO],
		[LAST_3_FLUID],
		[LAST_3_CCUT],
		[LAST_3_OCUT],
		[LAST_3_CGR],
		[PROVINCE_STATE],
		[ROW_CREATED_BY],
		[ROW_CREATED_DATE],
		[ROW_CHANGED_BY],
		[ROW_CHANGED_DATE],
		[LAST_PROCESS],
		[BRK_WATER],
		[SRC_WATER]	    
	  )
	  SELECT
			src.[PDEN_ID],
			src.[PDEN_TYPE],
			src.[SOURCE],
			src.[YEAR],
			src.[MONTH],
			src.[PROD_DATE],
			src.[HOURS],
			src.[GAS],
			src.[WATER],
			src.[OIL_BT],
			src.[COND],
			src.[CUM_GAS],
			src.[CUM_OIL_BT],
			src.[CUM_WATER],
			src.[CUM_COND],
			src.[CUM_HOURS],
			src.[TOTAL_FLUID],
			src.[GAS_CAL_DAY],
			src.[OIL_CAL_DAY],
			src.[WATER_CAL_DAY],
			src.[COND_CAL_DAY],
			src.[TOTAL_FLUID_CAL_DAY],
			src.[GAS_ACT_DAY],
			src.[OIL_ACT_DAY],
			src.[WATER_ACT_DAY],
			src.[COND_ACT_DAY],
			src.[TOTAL_FLUID_ACT_DAY],
			src.[GOR],
			src.[WGR],
			src.[WOR],
			src.[WCUT],
			src.[OCUT],
			src.[CCUT],
			src.[CGR],
			src.[GAS_FLUID_RATIO],
			src.[LAST_3_FLUID],
			src.[LAST_3_CCUT],
			src.[LAST_3_OCUT],
			src.[LAST_3_CGR],
			src.[PROVINCE_STATE],
			src.[ROW_CREATED_BY],
			src.[ROW_CREATED_DATE],
			src.[ROW_CHANGED_BY],
			src.[ROW_CHANGED_DATE],
			src.[LAST_PROCESS],
			src.[BRK_WATER],
			src.[SRC_WATER]
      FROM
	    #t_ihs_pden_production_month_MERGE src
      WHERE
	    Flag = 'NEW'

	------ ROW_COUNT
	--DECLARE  @rowcnt INT
	--EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	UPDATE [stage].[t_ihs_pden_production_month]
	SET
	    [stage].[t_ihs_pden_production_month].[PDEN_TYPE]         =   UPD.[PDEN_TYPE],
		[stage].[t_ihs_pden_production_month].[SOURCE]			=   UPD.[SOURCE],
		[stage].[t_ihs_pden_production_month].[YEAR]				=   UPD.[YEAR],
		[stage].[t_ihs_pden_production_month].[MONTH]				=   UPD.[MONTH],
		[stage].[t_ihs_pden_production_month].[HOURS]				=   UPD.[HOURS],
		[stage].[t_ihs_pden_production_month].[GAS]				=   UPD.[GAS],
		[stage].[t_ihs_pden_production_month].[WATER]				=   UPD.[WATER],
		[stage].[t_ihs_pden_production_month].[OIL_BT]			=   UPD.[OIL_BT],
		[stage].[t_ihs_pden_production_month].[COND]				=   UPD.[COND],
		[stage].[t_ihs_pden_production_month].[CUM_GAS]			=   UPD.[CUM_GAS],
		[stage].[t_ihs_pden_production_month].[CUM_OIL_BT]        =   UPD.[CUM_OIL_BT],
		[stage].[t_ihs_pden_production_month].[CUM_WATER]         =   UPD.[CUM_WATER],
		[stage].[t_ihs_pden_production_month].[CUM_COND]			=   UPD.[CUM_COND],
		[stage].[t_ihs_pden_production_month].[CUM_HOURS]			=   UPD.[CUM_HOURS],
		[stage].[t_ihs_pden_production_month].[TOTAL_FLUID]       =   UPD.[TOTAL_FLUID],
		[stage].[t_ihs_pden_production_month].[GAS_CAL_DAY]       =   UPD.[GAS_CAL_DAY],
		[stage].[t_ihs_pden_production_month].[OIL_CAL_DAY]       =   UPD.[OIL_CAL_DAY],
		[stage].[t_ihs_pden_production_month].[WATER_CAL_DAY]         =   UPD.[WATER_CAL_DAY],
		[stage].[t_ihs_pden_production_month].[COND_CAL_DAY]         =   UPD.[COND_CAL_DAY],
		[stage].[t_ihs_pden_production_month].[TOTAL_FLUID_CAL_DAY]         =   UPD.[TOTAL_FLUID_CAL_DAY],
		[stage].[t_ihs_pden_production_month].[GAS_ACT_DAY]         =   UPD.[GAS_ACT_DAY],
		[stage].[t_ihs_pden_production_month].[OIL_ACT_DAY]         =   UPD.[OIL_ACT_DAY],
		[stage].[t_ihs_pden_production_month].[WATER_ACT_DAY]         =   UPD.[WATER_ACT_DAY],
		[stage].[t_ihs_pden_production_month].[COND_ACT_DAY]         =   UPD.[COND_ACT_DAY],
		[stage].[t_ihs_pden_production_month].[TOTAL_FLUID_ACT_DAY]         =   UPD.[TOTAL_FLUID_ACT_DAY],
		[stage].[t_ihs_pden_production_month].[GOR]         =   UPD.[GOR],
		[stage].[t_ihs_pden_production_month].[WGR]         =   UPD.[WGR],
		[stage].[t_ihs_pden_production_month].[WOR]         =   UPD.[WOR],
		[stage].[t_ihs_pden_production_month].[WCUT]         =   UPD.[WCUT],
		[stage].[t_ihs_pden_production_month].[OCUT]         =   UPD.[OCUT],
		[stage].[t_ihs_pden_production_month].[CCUT]         =   UPD.[CCUT],
		[stage].[t_ihs_pden_production_month].[CGR]         =   UPD.[CGR],
		[stage].[t_ihs_pden_production_month].[GAS_FLUID_RATIO]         =   UPD.[GAS_FLUID_RATIO],
		[stage].[t_ihs_pden_production_month].[LAST_3_FLUID]         =   UPD.[LAST_3_FLUID],
		[stage].[t_ihs_pden_production_month].[LAST_3_CCUT]         =   UPD.[LAST_3_CCUT],
		[stage].[t_ihs_pden_production_month].[LAST_3_OCUT]         =   UPD.[LAST_3_OCUT],
		[stage].[t_ihs_pden_production_month].[LAST_3_CGR]         =   UPD.[LAST_3_CGR],
		[stage].[t_ihs_pden_production_month].[PROVINCE_STATE]         =   UPD.[PROVINCE_STATE],
		[stage].[t_ihs_pden_production_month].[ROW_CREATED_BY]         =   UPD.[ROW_CREATED_BY],
		[stage].[t_ihs_pden_production_month].[ROW_CREATED_DATE]         =   UPD.[ROW_CREATED_DATE],
		[stage].[t_ihs_pden_production_month].[ROW_CHANGED_BY]         =   UPD.[ROW_CHANGED_BY],
		[stage].[t_ihs_pden_production_month].[ROW_CHANGED_DATE]         =   UPD.[ROW_CHANGED_DATE],
		[stage].[t_ihs_pden_production_month].[LAST_PROCESS]         =   UPD.[LAST_PROCESS],
		[stage].[t_ihs_pden_production_month].[BRK_WATER]         =   UPD.[BRK_WATER],
		[stage].[t_ihs_pden_production_month].[SRC_WATER]         =   UPD.[SRC_WATER]
    FROM
	  #t_ihs_pden_production_month_MERGE UPD
	WHERE
      [stage].[t_ihs_pden_production_month].pden_id = UPD.pden_id AND
	  [stage].[t_ihs_pden_production_month].prod_date = UPD.prod_date	
      --
	--SET @rowcnt = @@ROWCOUNT
	
   -- COMMIT TRANSACTION        
   
 END TRY
 
 BEGIN CATCH
        
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
				--,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		---- If the error renders the transaction as uncommittable or we have open transactions, rollback
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		--RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)     

  END CATCH

  --RETURN @@ERROR

END