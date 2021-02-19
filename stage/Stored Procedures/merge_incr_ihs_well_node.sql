CREATE PROC [stage].[merge_incr_ihs_well_node] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	

	-- Merge Cost Centres from [stage].[dbo].[v_dim_source_entity_cost_centre_hierarchy]
    IF OBJECT_ID('tempdb..#t_ihs_well_node_MERGE') IS NOT NULL
        DROP TABLE #t_ihs_well_node_MERGE
	CREATE TABLE #t_ihs_well_node_MERGE (
			[Flag]				        VARCHAR(10),
			[NODE_ID]			        [varchar](20) NOT NULL,
			[ACTIVE_IND]				[varchar](1) NULL,
			[COORDINATE_QUALITY]	    [varchar](20) NULL,
			[COORD_SYSTEM_ID]			[varchar](20) NULL,
			[EFFECTIVE_DATE]			[datetime] NULL,
			[EXPIRY_DATE]				[datetime] NULL,
			[LATITUDE]					[numeric](12, 7) NULL,
			[LEGAL_SURVEY_TYPE]			[varchar](20) NULL,
			[LOCATION_QUALITY]			[varchar](20) NULL,
			[LOCATION_TYPE]				[varchar](20) NULL,
			[LONGITUDE]					[numeric](12, 7) NULL,
			[NODE_NUMERIC_ID]			[numeric](12, 0) NULL,
			[NODE_POSITION]				[varchar](20) NULL,
			[ORIGINAL_OBS_NO]			[numeric](8, 0) NULL,
			[ORIGINAL_XY_UOM]			[varchar](20) NULL,
			[PLATFORM_ID]				[varchar](20) NULL,
			[PLATFORM_SF_TYPE]			[varchar](24) NULL,
			[PPDM_GUID]					[varchar](38) NULL,
			[PREFERRED_IND]				[varchar](1) NULL,
			[REMARK]					[varchar](2000) NULL,
			[SELECTED_OBS_NO]			[numeric](8, 0) NULL,
			[SOURCE]					[varchar](20) NULL,
			[UWI]						[varchar](20) NULL,
			[ROW_CHANGED_BY]			[varchar](30) NULL,
			[ROW_CHANGED_DATE]			[datetime] NULL,
			[ROW_CREATED_BY]			[varchar](30) NULL,
			[ROW_CREATED_DATE]			[datetime] NULL,
			[ROW_QUALITY]				[varchar](20) NULL
			)
		WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

	BEGIN TRANSACTION
	
		INSERT INTO #t_ihs_well_node_MERGE
			   ([Flag]
			   ,[NODE_ID]			
			   ,[ACTIVE_IND]		
			   ,[COORDINATE_QUALITY]
			   ,[COORD_SYSTEM_ID]	
			   ,[EFFECTIVE_DATE]	
			   ,[EXPIRY_DATE]		
			   ,[LATITUDE]			
			   ,[LEGAL_SURVEY_TYPE]	
			   ,[LOCATION_QUALITY]	
			   ,[LOCATION_TYPE]		
			   ,[LONGITUDE]			
			   ,[NODE_NUMERIC_ID]	
			   ,[NODE_POSITION]		
			   ,[ORIGINAL_OBS_NO]	
			   ,[ORIGINAL_XY_UOM]	
			   ,[PLATFORM_ID]		
			   ,[PLATFORM_SF_TYPE]	
			   ,[PPDM_GUID]			
			   ,[PREFERRED_IND]		
			   ,[REMARK]			
			   ,[SELECTED_OBS_NO]	
			   ,[SOURCE]			
			   ,[UWI]				
			   ,[ROW_CHANGED_BY]	
			   ,[ROW_CHANGED_DATE]	
			   ,[ROW_CREATED_BY]	
			   ,[ROW_CREATED_DATE]	
			   ,[ROW_QUALITY])
		SELECT
			'INSERT'
			,src.[NODE_ID]			
			,src.[ACTIVE_IND]		
			,src.[COORDINATE_QUALITY]
			,src.[COORD_SYSTEM_ID]	
			,src.[EFFECTIVE_DATE]	
			,src.[EXPIRY_DATE]		
			,src.[LATITUDE]			
			,src.[LEGAL_SURVEY_TYPE]	
			,src.[LOCATION_QUALITY]	
			,src.[LOCATION_TYPE]		
			,src.[LONGITUDE]			
			,src.[NODE_NUMERIC_ID]	
			,src.[NODE_POSITION]		
			,src.[ORIGINAL_OBS_NO]	
			,src.[ORIGINAL_XY_UOM]	
			,src.[PLATFORM_ID]		
			,src.[PLATFORM_SF_TYPE]	
			,src.[PPDM_GUID]			
			,src.[PREFERRED_IND]		
			,src.[REMARK]			
			,src.[SELECTED_OBS_NO]	
			,src.[SOURCE]			
			,src.[UWI]				
			,src.[ROW_CHANGED_BY]	
			,src.[ROW_CHANGED_DATE]	
			,src.[ROW_CREATED_BY]	
			,src.[ROW_CREATED_DATE]	
			,src.[ROW_QUALITY]
		FROM
			[stage].[t_ihs_well_node_incr] as src
			LEFT JOIN [stage].[t_ihs_well_node] as trg
		 ON      (trg.node_id	= src.node_id  )
		WHERE trg.node_id IS NULL
			 
		UNION ALL
		
		SELECT
			'UPDATE' Flag
			,src.[NODE_ID]			
			,src.[ACTIVE_IND]		
			,src.[COORDINATE_QUALITY]
			,src.[COORD_SYSTEM_ID]	
			,src.[EFFECTIVE_DATE]	
			,src.[EXPIRY_DATE]		
			,src.[LATITUDE]			
			,src.[LEGAL_SURVEY_TYPE]	
			,src.[LOCATION_QUALITY]	
			,src.[LOCATION_TYPE]		
			,src.[LONGITUDE]			
			,src.[NODE_NUMERIC_ID]	
			,src.[NODE_POSITION]		
			,src.[ORIGINAL_OBS_NO]	
			,src.[ORIGINAL_XY_UOM]	
			,src.[PLATFORM_ID]		
			,src.[PLATFORM_SF_TYPE]	
			,src.[PPDM_GUID]			
			,src.[PREFERRED_IND]		
			,src.[REMARK]			
			,src.[SELECTED_OBS_NO]	
			,src.[SOURCE]			
			,src.[UWI]				
			,src.[ROW_CHANGED_BY]	
			,src.[ROW_CHANGED_DATE]	
			,src.[ROW_CREATED_BY]	
			,src.[ROW_CREATED_DATE]	
			,src.[ROW_QUALITY]
		FROM
		(
			SELECT
				 src.[NODE_ID]			
				,src.[ACTIVE_IND]		
				,src.[COORDINATE_QUALITY]
				,src.[COORD_SYSTEM_ID]	
				,src.[EFFECTIVE_DATE]	
				,src.[EXPIRY_DATE]		
				,src.[LATITUDE]			
				,src.[LEGAL_SURVEY_TYPE]	
				,src.[LOCATION_QUALITY]	
				,src.[LOCATION_TYPE]		
				,src.[LONGITUDE]			
				,src.[NODE_NUMERIC_ID]	
				,src.[NODE_POSITION]		
				,src.[ORIGINAL_OBS_NO]	
				,src.[ORIGINAL_XY_UOM]	
				,src.[PLATFORM_ID]		
				,src.[PLATFORM_SF_TYPE]	
				,src.[PPDM_GUID]			
				,src.[PREFERRED_IND]		
				,src.[REMARK]			
				,src.[SELECTED_OBS_NO]	
				,src.[SOURCE]			
				,src.[UWI]				
				,src.[ROW_CHANGED_BY]	
				,src.[ROW_CHANGED_DATE]	
				,src.[ROW_CREATED_BY]	
				,src.[ROW_CREATED_DATE]	
				,src.[ROW_QUALITY]
			FROM
				[stage].[t_ihs_well_node_incr] as src
				INNER JOIN [stage].[t_ihs_well_node] as trg
			 ON      (trg.node_id	= src.node_id)
			 EXCEPT
			 SELECT
				 src.[NODE_ID]			
				,src.[ACTIVE_IND]		
				,src.[COORDINATE_QUALITY]
				,src.[COORD_SYSTEM_ID]	
				,src.[EFFECTIVE_DATE]	
				,src.[EXPIRY_DATE]		
				,src.[LATITUDE]			
				,src.[LEGAL_SURVEY_TYPE]	
				,src.[LOCATION_QUALITY]	
				,src.[LOCATION_TYPE]		
				,src.[LONGITUDE]			
				,src.[NODE_NUMERIC_ID]	
				,src.[NODE_POSITION]		
				,src.[ORIGINAL_OBS_NO]	
				,src.[ORIGINAL_XY_UOM]	
				,src.[PLATFORM_ID]		
				,src.[PLATFORM_SF_TYPE]	
				,src.[PPDM_GUID]			
				,src.[PREFERRED_IND]		
				,src.[REMARK]			
				,src.[SELECTED_OBS_NO]	
				,src.[SOURCE]			
				,src.[UWI]				
				,src.[ROW_CHANGED_BY]	
				,src.[ROW_CHANGED_DATE]	
				,src.[ROW_CREATED_BY]	
				,src.[ROW_CREATED_DATE]	
				,src.[ROW_QUALITY]
			FROM
				[stage].[t_ihs_well_node] as src

		) src

	INSERT INTO [stage].[t_ihs_well_node]
			   (
			    [NODE_ID]			
			   ,[ACTIVE_IND]		
			   ,[COORDINATE_QUALITY]
			   ,[COORD_SYSTEM_ID]	
			   ,[EFFECTIVE_DATE]	
			   ,[EXPIRY_DATE]		
			   ,[LATITUDE]			
			   ,[LEGAL_SURVEY_TYPE]	
			   ,[LOCATION_QUALITY]	
			   ,[LOCATION_TYPE]		
			   ,[LONGITUDE]			
			   ,[NODE_NUMERIC_ID]	
			   ,[NODE_POSITION]		
			   ,[ORIGINAL_OBS_NO]	
			   ,[ORIGINAL_XY_UOM]	
			   ,[PLATFORM_ID]		
			   ,[PLATFORM_SF_TYPE]	
			   ,[PPDM_GUID]			
			   ,[PREFERRED_IND]		
			   ,[REMARK]			
			   ,[SELECTED_OBS_NO]	
			   ,[SOURCE]			
			   ,[UWI]				
			   ,[ROW_CHANGED_BY]	
			   ,[ROW_CHANGED_DATE]	
			   ,[ROW_CREATED_BY]	
			   ,[ROW_CREATED_DATE]	
			   ,[ROW_QUALITY])
		SELECT
			 src.[NODE_ID]			
			,src.[ACTIVE_IND]		
			,src.[COORDINATE_QUALITY]
			,src.[COORD_SYSTEM_ID]	
			,src.[EFFECTIVE_DATE]	
			,src.[EXPIRY_DATE]		
			,src.[LATITUDE]			
			,src.[LEGAL_SURVEY_TYPE]	
			,src.[LOCATION_QUALITY]	
			,src.[LOCATION_TYPE]		
			,src.[LONGITUDE]			
			,src.[NODE_NUMERIC_ID]	
			,src.[NODE_POSITION]		
			,src.[ORIGINAL_OBS_NO]	
			,src.[ORIGINAL_XY_UOM]	
			,src.[PLATFORM_ID]		
			,src.[PLATFORM_SF_TYPE]	
			,src.[PPDM_GUID]			
			,src.[PREFERRED_IND]		
			,src.[REMARK]			
			,src.[SELECTED_OBS_NO]	
			,src.[SOURCE]			
			,src.[UWI]				
			,src.[ROW_CHANGED_BY]	
			,src.[ROW_CHANGED_DATE]	
			,src.[ROW_CREATED_BY]	
			,src.[ROW_CREATED_DATE]	
			,src.[ROW_QUALITY]
		FROM
			#t_ihs_well_node_MERGE as src
		WHERE Flag='INSERT'

		UPDATE [stage].[t_ihs_well_node]
		SET
			[stage].[t_ihs_well_node].[ACTIVE_IND]				 =   src.[ACTIVE_IND],		
			[stage].[t_ihs_well_node].[COORDINATE_QUALITY]       =   src.[COORDINATE_QUALITY],
			[stage].[t_ihs_well_node].[COORD_SYSTEM_ID]	         =   src.[COORD_SYSTEM_ID],	
			[stage].[t_ihs_well_node].[EFFECTIVE_DATE]	         =   src.[EFFECTIVE_DATE],	
			[stage].[t_ihs_well_node].[EXPIRY_DATE]		         =   src.[EXPIRY_DATE],		
			[stage].[t_ihs_well_node].[LATITUDE]			     =   src.[LATITUDE],			
			[stage].[t_ihs_well_node].[LEGAL_SURVEY_TYPE]	     =   src.[LEGAL_SURVEY_TYPE],	
			[stage].[t_ihs_well_node].[LOCATION_QUALITY]	     =   src.[LOCATION_QUALITY],	
			[stage].[t_ihs_well_node].[LOCATION_TYPE]		     =   src.[LOCATION_TYPE],		
			[stage].[t_ihs_well_node].[LONGITUDE]			     =   src.[LONGITUDE],			
			[stage].[t_ihs_well_node].[NODE_NUMERIC_ID]	         =   src.[NODE_NUMERIC_ID],	
			[stage].[t_ihs_well_node].[NODE_POSITION]		     =   src.[NODE_POSITION],		
			[stage].[t_ihs_well_node].[ORIGINAL_OBS_NO]	         =   src.[ORIGINAL_OBS_NO],	
			[stage].[t_ihs_well_node].[ORIGINAL_XY_UOM]	         =   src.[ORIGINAL_XY_UOM],	
			[stage].[t_ihs_well_node].[PLATFORM_ID]		         =   src.[PLATFORM_ID],		
			[stage].[t_ihs_well_node].[PLATFORM_SF_TYPE]	     =   src.[PLATFORM_SF_TYPE],	
			[stage].[t_ihs_well_node].[PPDM_GUID]			     =   src.[PPDM_GUID],			
			[stage].[t_ihs_well_node].[PREFERRED_IND]		     =   src.[PREFERRED_IND],		
			[stage].[t_ihs_well_node].[REMARK]			         =   src.[REMARK],			
			[stage].[t_ihs_well_node].[SELECTED_OBS_NO]	         =   src.[SELECTED_OBS_NO],	
			[stage].[t_ihs_well_node].[SOURCE]			         =   src.[SOURCE],			
			[stage].[t_ihs_well_node].[UWI]				         =   src.[UWI],				
			[stage].[t_ihs_well_node].[ROW_CHANGED_BY]	         =   src.[ROW_CHANGED_BY],	
			[stage].[t_ihs_well_node].[ROW_CHANGED_DATE]	     =   src.[ROW_CHANGED_DATE],	
			[stage].[t_ihs_well_node].[ROW_CREATED_BY]	         =   src.[ROW_CREATED_BY],	
			[stage].[t_ihs_well_node].[ROW_CREATED_DATE]	     =   src.[ROW_CREATED_DATE],	
			[stage].[t_ihs_well_node].[ROW_QUALITY]              =   src.[ROW_QUALITY]
		
		FROM #t_ihs_well_node_MERGE as src
		WHERE   ([stage].[t_ihs_well_node].node_id = src.node_id)
		AND Flag='UPDATE'



	DECLARE @INSERTED INT = (SELECT COUNT(0) FROM #t_ihs_well_node_MERGE WHERE Flag='INSERT')
	DECLARE @UPDATED INT = (SELECT COUNT(0) FROM #t_ihs_well_node_MERGE WHERE Flag='UPDATE')
	SELECT @INSERTED INSERTED, @UPDATED UPDATED
    COMMIT TRANSACTION

        
   
 END TRY
 
 BEGIN CATCH
        
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
--				,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		-- If the error renders the transaction as uncommittable or we have open transactions, rollback
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)


      

  END CATCH

--  RETURN @@ERROR

END