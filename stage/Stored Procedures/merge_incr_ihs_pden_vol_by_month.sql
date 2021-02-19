CREATE PROC [stage].[merge_incr_ihs_pden_vol_by_month] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	

	-- Merge Cost Centres from [stage].[dbo].[v_dim_source_entity_cost_centre_hierarchy]
    IF OBJECT_ID('tempdb..#t_ihs_pden_vol_by_month_MERGE') IS NOT NULL
        DROP TABLE #t_ihs_pden_vol_by_month_MERGE
	CREATE TABLE #t_ihs_pden_vol_by_month_MERGE (
			[Flag]				 VARCHAR(10),
			[PDEN_ID]             VARCHAR (40)    NOT NULL,
			[PDEN_TYPE]           VARCHAR (24)    NOT NULL,
			[PDEN_SOURCE]         VARCHAR (20)    NOT NULL,
			[VOLUME_METHOD]       VARCHAR (20)    NOT NULL,
			[ACTIVITY_TYPE]       VARCHAR (20)    NOT NULL,
			[PRODUCT_TYPE]        VARCHAR (20)    NOT NULL,
			[YEAR]                NUMERIC (4)     NOT NULL,
			[AMENDMENT_SEQ_NO]    NUMERIC (8)     NOT NULL,
			[ACTIVE_IND]          VARCHAR (1)     NULL,
			[AMEND_REASON]        VARCHAR (20)    NULL,
			[APR_VOLUME]          NUMERIC (14, 4) NULL,
			[APR_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[AUG_VOLUME]          NUMERIC (14, 4) NULL,
			[AUG_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[CUM_VOLUME]          NUMERIC (16, 4) NULL,
			[DEC_VOLUME]          NUMERIC (14, 4) NULL,
			[DEC_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[EFFECTIVE_DATE]      DATETIME        NULL,
			[EXPIRY_DATE]         DATETIME        NULL,
			[FEB_VOLUME]          NUMERIC (14, 4) NULL,
			[FEB_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[JAN_VOLUME]          NUMERIC (14, 4) NULL,
			[JAN_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[JUL_VOLUME]          NUMERIC (14, 4) NULL,
			[JUL_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[JUN_VOLUME]          NUMERIC (14, 4) NULL,
			[JUN_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[MAR_VOLUME]          NUMERIC (14, 4) NULL,
			[MAR_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[MAY_VOLUME]          NUMERIC (14, 4) NULL,
			[MAY_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[NOV_VOLUME]          NUMERIC (14, 4) NULL,
			[NOV_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[OCT_VOLUME]          NUMERIC (14, 4) NULL,
			[OCT_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[POSTED_DATE]         DATETIME        NULL,
			[PPDM_GUID]           VARCHAR (38)    NULL,
			[REMARK]              VARCHAR (2000)  NULL,
			[SEP_VOLUME]          NUMERIC (14, 4) NULL,
			[SEP_VOLUME_QUAL]     NUMERIC (18)    NULL,
			[VOLUME_END_DATE]     DATETIME        NULL,
			[VOLUME_OUOM]         VARCHAR (20)    NULL,
			[VOLUME_QUALITY_OUOM] VARCHAR (20)    NULL,
			[VOLUME_START_DATE]   DATETIME        NULL,
			[VOLUME_UOM]          VARCHAR (20)    NULL,
			[YTD_VOLUME]          NUMERIC (14, 4) NULL,
			[ROW_CHANGED_BY]      VARCHAR (30)    NULL,
			[ROW_CHANGED_DATE]    DATETIME        NULL,
			[ROW_CREATED_BY]      VARCHAR (30)    NULL,
			[ROW_CREATED_DATE]    DATETIME        NULL,
			[ROW_QUALITY]         VARCHAR (20)    NULL,
			[PROVINCE_STATE]      VARCHAR (20)    NOT NULL,
			[POOL_ID]             VARCHAR (20)    NULL,
			[X_STRAT_UNIT_ID]     VARCHAR (20)    NULL,
			[TOP_STRAT_AGE]       NUMERIC (12)    NULL,
			[BASE_STRAT_AGE]      NUMERIC (12)    NULL,
			[STRAT_NAME_SET_ID]   VARCHAR (20)    NULL
			)
		WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

	BEGIN TRANSACTION
	
		INSERT INTO #t_ihs_pden_vol_by_month_MERGE
			   ([Flag]
			   ,[PDEN_ID]
			   ,[PDEN_TYPE]
			   ,[PDEN_SOURCE]
			   ,[VOLUME_METHOD]
			   ,[ACTIVITY_TYPE]
			   ,[PRODUCT_TYPE]
			   ,[YEAR]
			   ,[AMENDMENT_SEQ_NO]
			   ,[ACTIVE_IND]
			   ,[AMEND_REASON]
			   ,[APR_VOLUME]
			   ,[APR_VOLUME_QUAL]
			   ,[AUG_VOLUME]
			   ,[AUG_VOLUME_QUAL]
			   ,[CUM_VOLUME]
			   ,[DEC_VOLUME]
			   ,[DEC_VOLUME_QUAL]
			   ,[EFFECTIVE_DATE]
			   ,[EXPIRY_DATE]
			   ,[FEB_VOLUME]
			   ,[FEB_VOLUME_QUAL]
			   ,[JAN_VOLUME]
			   ,[JAN_VOLUME_QUAL]
			   ,[JUL_VOLUME]
			   ,[JUL_VOLUME_QUAL]
			   ,[JUN_VOLUME]
			   ,[JUN_VOLUME_QUAL]
			   ,[MAR_VOLUME]
			   ,[MAR_VOLUME_QUAL]
			   ,[MAY_VOLUME]
			   ,[MAY_VOLUME_QUAL]
			   ,[NOV_VOLUME]
			   ,[NOV_VOLUME_QUAL]
			   ,[OCT_VOLUME]
			   ,[OCT_VOLUME_QUAL]
			   ,[POSTED_DATE]
			   ,[PPDM_GUID]
			   ,[REMARK]
			   ,[SEP_VOLUME]
			   ,[SEP_VOLUME_QUAL]
			   ,[VOLUME_END_DATE]
			   ,[VOLUME_OUOM]
			   ,[VOLUME_QUALITY_OUOM]
			   ,[VOLUME_START_DATE]
			   ,[VOLUME_UOM]
			   ,[YTD_VOLUME]
			   ,[ROW_CHANGED_BY]
			   ,[ROW_CHANGED_DATE]
			   ,[ROW_CREATED_BY]
			   ,[ROW_CREATED_DATE]
			   ,[ROW_QUALITY]
			   ,[PROVINCE_STATE]
			   ,[POOL_ID]
			   ,[X_STRAT_UNIT_ID]
			   ,[TOP_STRAT_AGE]
			   ,[BASE_STRAT_AGE]
			   ,[STRAT_NAME_SET_ID])
		SELECT
			'INSERT'
			,src.[PDEN_ID]
			,src.[PDEN_TYPE]
			,src.[PDEN_SOURCE]
			,src.[VOLUME_METHOD]
			,src.[ACTIVITY_TYPE]
			,src.[PRODUCT_TYPE]
			,src.[YEAR]
			,src.[AMENDMENT_SEQ_NO]
			,src.[ACTIVE_IND]
			,src.[AMEND_REASON]
			,src.[APR_VOLUME]
			,src.[APR_VOLUME_QUAL]
			,src.[AUG_VOLUME]
			,src.[AUG_VOLUME_QUAL]
			,src.[CUM_VOLUME]
			,src.[DEC_VOLUME]
			,src.[DEC_VOLUME_QUAL]
			,src.[EFFECTIVE_DATE]
			,src.[EXPIRY_DATE]
			,src.[FEB_VOLUME]
			,src.[FEB_VOLUME_QUAL]
			,src.[JAN_VOLUME]
			,src.[JAN_VOLUME_QUAL]
			,src.[JUL_VOLUME]
			,src.[JUL_VOLUME_QUAL]
			,src.[JUN_VOLUME]
			,src.[JUN_VOLUME_QUAL]
			,src.[MAR_VOLUME]
			,src.[MAR_VOLUME_QUAL]
			,src.[MAY_VOLUME]
			,src.[MAY_VOLUME_QUAL]
			,src.[NOV_VOLUME]
			,src.[NOV_VOLUME_QUAL]
			,src.[OCT_VOLUME]
			,src.[OCT_VOLUME_QUAL]
			,src.[POSTED_DATE]
			,src.[PPDM_GUID]
			,src.[REMARK]
			,src.[SEP_VOLUME]
			,src.[SEP_VOLUME_QUAL]
			,src.[VOLUME_END_DATE]
			,src.[VOLUME_OUOM]
			,src.[VOLUME_QUALITY_OUOM]
			,src.[VOLUME_START_DATE]
			,src.[VOLUME_UOM]
			,src.[YTD_VOLUME]
			,src.[ROW_CHANGED_BY]
			,src.[ROW_CHANGED_DATE]
			,src.[ROW_CREATED_BY]
			,src.[ROW_CREATED_DATE]
			,src.[ROW_QUALITY]
			,src.[PROVINCE_STATE]
			,src.[POOL_ID]
			,src.[X_STRAT_UNIT_ID]
			,src.[TOP_STRAT_AGE]
			,src.[BASE_STRAT_AGE]
			,src.[STRAT_NAME_SET_ID]
		FROM
			[stage].[t_ihs_pden_vol_by_month_incr] as src
			LEFT JOIN [stage].[t_ihs_pden_vol_by_month] as trg
		 ON      (trg.pden_id			= src.pden_id
	       AND trg.year				= src.year
	       AND trg.activity_type	= src.activity_type
		   AND trg.product_type		= src.product_type
		   AND trg.amendment_seq_no = src.amendment_seq_no
		   )
		WHERE trg.year IS NULL
			  AND trg.activity_type IS NULL
			  AND trg.product_type IS NULL
			  AND trg.amendment_seq_no IS NULL
		UNION ALL
		
		SELECT
			'UPDATE' Flag
			,src.[PDEN_ID]
			,src.[PDEN_TYPE]
			,src.[PDEN_SOURCE]
			,src.[VOLUME_METHOD]
			,src.[ACTIVITY_TYPE]
			,src.[PRODUCT_TYPE]
			,src.[YEAR]
			,src.[AMENDMENT_SEQ_NO]
			,src.[ACTIVE_IND]
			,src.[AMEND_REASON]
			,src.[APR_VOLUME]
			,src.[APR_VOLUME_QUAL]
			,src.[AUG_VOLUME]
			,src.[AUG_VOLUME_QUAL]
			,src.[CUM_VOLUME]
			,src.[DEC_VOLUME]
			,src.[DEC_VOLUME_QUAL]
			,src.[EFFECTIVE_DATE]
			,src.[EXPIRY_DATE]
			,src.[FEB_VOLUME]
			,src.[FEB_VOLUME_QUAL]
			,src.[JAN_VOLUME]
			,src.[JAN_VOLUME_QUAL]
			,src.[JUL_VOLUME]
			,src.[JUL_VOLUME_QUAL]
			,src.[JUN_VOLUME]
			,src.[JUN_VOLUME_QUAL]
			,src.[MAR_VOLUME]
			,src.[MAR_VOLUME_QUAL]
			,src.[MAY_VOLUME]
			,src.[MAY_VOLUME_QUAL]
			,src.[NOV_VOLUME]
			,src.[NOV_VOLUME_QUAL]
			,src.[OCT_VOLUME]
			,src.[OCT_VOLUME_QUAL]
			,src.[POSTED_DATE]
			,src.[PPDM_GUID]
			,src.[REMARK]
			,src.[SEP_VOLUME]
			,src.[SEP_VOLUME_QUAL]
			,src.[VOLUME_END_DATE]
			,src.[VOLUME_OUOM]
			,src.[VOLUME_QUALITY_OUOM]
			,src.[VOLUME_START_DATE]
			,src.[VOLUME_UOM]
			,src.[YTD_VOLUME]
			,src.[ROW_CHANGED_BY]
			,src.[ROW_CHANGED_DATE]
			,src.[ROW_CREATED_BY]
			,src.[ROW_CREATED_DATE]
			,src.[ROW_QUALITY]
			,src.[PROVINCE_STATE]
			,src.[POOL_ID]
			,src.[X_STRAT_UNIT_ID]
			,src.[TOP_STRAT_AGE]
			,src.[BASE_STRAT_AGE]
			,src.[STRAT_NAME_SET_ID]
		FROM
		(
			SELECT
				src.[PDEN_ID]
				,src.[PDEN_TYPE]
				,src.[PDEN_SOURCE]
				,src.[VOLUME_METHOD]
				,src.[ACTIVITY_TYPE]
				,src.[PRODUCT_TYPE]
				,src.[YEAR]
				,src.[AMENDMENT_SEQ_NO]
				,src.[ACTIVE_IND]
				,src.[AMEND_REASON]
				,src.[APR_VOLUME]
				,src.[APR_VOLUME_QUAL]
				,src.[AUG_VOLUME]
				,src.[AUG_VOLUME_QUAL]
				,src.[CUM_VOLUME]
				,src.[DEC_VOLUME]
				,src.[DEC_VOLUME_QUAL]
				,src.[EFFECTIVE_DATE]
				,src.[EXPIRY_DATE]
				,src.[FEB_VOLUME]
				,src.[FEB_VOLUME_QUAL]
				,src.[JAN_VOLUME]
				,src.[JAN_VOLUME_QUAL]
				,src.[JUL_VOLUME]
				,src.[JUL_VOLUME_QUAL]
				,src.[JUN_VOLUME]
				,src.[JUN_VOLUME_QUAL]
				,src.[MAR_VOLUME]
				,src.[MAR_VOLUME_QUAL]
				,src.[MAY_VOLUME]
				,src.[MAY_VOLUME_QUAL]
				,src.[NOV_VOLUME]
				,src.[NOV_VOLUME_QUAL]
				,src.[OCT_VOLUME]
				,src.[OCT_VOLUME_QUAL]
				,src.[POSTED_DATE]
				,src.[PPDM_GUID]
				,src.[REMARK]
				,src.[SEP_VOLUME]
				,src.[SEP_VOLUME_QUAL]
				,src.[VOLUME_END_DATE]
				,src.[VOLUME_OUOM]
				,src.[VOLUME_QUALITY_OUOM]
				,src.[VOLUME_START_DATE]
				,src.[VOLUME_UOM]
				,src.[YTD_VOLUME]
				,src.[ROW_CHANGED_BY]
				,src.[ROW_CHANGED_DATE]
				,src.[ROW_CREATED_BY]
				,src.[ROW_CREATED_DATE]
				,src.[ROW_QUALITY]
				,src.[PROVINCE_STATE]
				,src.[POOL_ID]
				,src.[X_STRAT_UNIT_ID]
				,src.[TOP_STRAT_AGE]
				,src.[BASE_STRAT_AGE]
				,src.[STRAT_NAME_SET_ID]
			FROM
				[stage].[t_ihs_pden_vol_by_month_incr] as src
				INNER JOIN [stage].[t_ihs_pden_vol_by_month] as trg
			 ON      (trg.pden_id			= src.pden_id
			   AND trg.year				= src.year
			   AND trg.activity_type	= src.activity_type
			   AND trg.product_type		= src.product_type)
			 EXCEPT
			 SELECT
				src.[PDEN_ID]
				,src.[PDEN_TYPE]
				,src.[PDEN_SOURCE]
				,src.[VOLUME_METHOD]
				,src.[ACTIVITY_TYPE]
				,src.[PRODUCT_TYPE]
				,src.[YEAR]
				,src.[AMENDMENT_SEQ_NO]
				,src.[ACTIVE_IND]
				,src.[AMEND_REASON]
				,src.[APR_VOLUME]
				,src.[APR_VOLUME_QUAL]
				,src.[AUG_VOLUME]
				,src.[AUG_VOLUME_QUAL]
				,src.[CUM_VOLUME]
				,src.[DEC_VOLUME]
				,src.[DEC_VOLUME_QUAL]
				,src.[EFFECTIVE_DATE]
				,src.[EXPIRY_DATE]
				,src.[FEB_VOLUME]
				,src.[FEB_VOLUME_QUAL]
				,src.[JAN_VOLUME]
				,src.[JAN_VOLUME_QUAL]
				,src.[JUL_VOLUME]
				,src.[JUL_VOLUME_QUAL]
				,src.[JUN_VOLUME]
				,src.[JUN_VOLUME_QUAL]
				,src.[MAR_VOLUME]
				,src.[MAR_VOLUME_QUAL]
				,src.[MAY_VOLUME]
				,src.[MAY_VOLUME_QUAL]
				,src.[NOV_VOLUME]
				,src.[NOV_VOLUME_QUAL]
				,src.[OCT_VOLUME]
				,src.[OCT_VOLUME_QUAL]
				,src.[POSTED_DATE]
				,src.[PPDM_GUID]
				,src.[REMARK]
				,src.[SEP_VOLUME]
				,src.[SEP_VOLUME_QUAL]
				,src.[VOLUME_END_DATE]
				,src.[VOLUME_OUOM]
				,src.[VOLUME_QUALITY_OUOM]
				,src.[VOLUME_START_DATE]
				,src.[VOLUME_UOM]
				,src.[YTD_VOLUME]
				,src.[ROW_CHANGED_BY]
				,src.[ROW_CHANGED_DATE]
				,src.[ROW_CREATED_BY]
				,src.[ROW_CREATED_DATE]
				,src.[ROW_QUALITY]
				,src.[PROVINCE_STATE]
				,src.[POOL_ID]
				,src.[X_STRAT_UNIT_ID]
				,src.[TOP_STRAT_AGE]
				,src.[BASE_STRAT_AGE]
				,src.[STRAT_NAME_SET_ID]
			FROM
				[stage].[t_ihs_pden_vol_by_month] as src

		) src

	INSERT INTO [stage].[t_ihs_pden_vol_by_month]
			   (
			    [PDEN_ID]
			   ,[PDEN_TYPE]
			   ,[PDEN_SOURCE]
			   ,[VOLUME_METHOD]
			   ,[ACTIVITY_TYPE]
			   ,[PRODUCT_TYPE]
			   ,[YEAR]
			   ,[AMENDMENT_SEQ_NO]
			   ,[ACTIVE_IND]
			   ,[AMEND_REASON]
			   ,[APR_VOLUME]
			   ,[APR_VOLUME_QUAL]
			   ,[AUG_VOLUME]
			   ,[AUG_VOLUME_QUAL]
			   ,[CUM_VOLUME]
			   ,[DEC_VOLUME]
			   ,[DEC_VOLUME_QUAL]
			   ,[EFFECTIVE_DATE]
			   ,[EXPIRY_DATE]
			   ,[FEB_VOLUME]
			   ,[FEB_VOLUME_QUAL]
			   ,[JAN_VOLUME]
			   ,[JAN_VOLUME_QUAL]
			   ,[JUL_VOLUME]
			   ,[JUL_VOLUME_QUAL]
			   ,[JUN_VOLUME]
			   ,[JUN_VOLUME_QUAL]
			   ,[MAR_VOLUME]
			   ,[MAR_VOLUME_QUAL]
			   ,[MAY_VOLUME]
			   ,[MAY_VOLUME_QUAL]
			   ,[NOV_VOLUME]
			   ,[NOV_VOLUME_QUAL]
			   ,[OCT_VOLUME]
			   ,[OCT_VOLUME_QUAL]
			   ,[POSTED_DATE]
			   ,[PPDM_GUID]
			   ,[REMARK]
			   ,[SEP_VOLUME]
			   ,[SEP_VOLUME_QUAL]
			   ,[VOLUME_END_DATE]
			   ,[VOLUME_OUOM]
			   ,[VOLUME_QUALITY_OUOM]
			   ,[VOLUME_START_DATE]
			   ,[VOLUME_UOM]
			   ,[YTD_VOLUME]
			   ,[ROW_CHANGED_BY]
			   ,[ROW_CHANGED_DATE]
			   ,[ROW_CREATED_BY]
			   ,[ROW_CREATED_DATE]
			   ,[ROW_QUALITY]
			   ,[PROVINCE_STATE]
			   ,[POOL_ID]
			   ,[X_STRAT_UNIT_ID]
			   ,[TOP_STRAT_AGE]
			   ,[BASE_STRAT_AGE]
			   ,[STRAT_NAME_SET_ID])
		SELECT
			 src.[PDEN_ID]
			,src.[PDEN_TYPE]
			,src.[PDEN_SOURCE]
			,src.[VOLUME_METHOD]
			,src.[ACTIVITY_TYPE]
			,src.[PRODUCT_TYPE]
			,src.[YEAR]
			,src.[AMENDMENT_SEQ_NO]
			,src.[ACTIVE_IND]
			,src.[AMEND_REASON]
			,src.[APR_VOLUME]
			,src.[APR_VOLUME_QUAL]
			,src.[AUG_VOLUME]
			,src.[AUG_VOLUME_QUAL]
			,src.[CUM_VOLUME]
			,src.[DEC_VOLUME]
			,src.[DEC_VOLUME_QUAL]
			,src.[EFFECTIVE_DATE]
			,src.[EXPIRY_DATE]
			,src.[FEB_VOLUME]
			,src.[FEB_VOLUME_QUAL]
			,src.[JAN_VOLUME]
			,src.[JAN_VOLUME_QUAL]
			,src.[JUL_VOLUME]
			,src.[JUL_VOLUME_QUAL]
			,src.[JUN_VOLUME]
			,src.[JUN_VOLUME_QUAL]
			,src.[MAR_VOLUME]
			,src.[MAR_VOLUME_QUAL]
			,src.[MAY_VOLUME]
			,src.[MAY_VOLUME_QUAL]
			,src.[NOV_VOLUME]
			,src.[NOV_VOLUME_QUAL]
			,src.[OCT_VOLUME]
			,src.[OCT_VOLUME_QUAL]
			,src.[POSTED_DATE]
			,src.[PPDM_GUID]
			,src.[REMARK]
			,src.[SEP_VOLUME]
			,src.[SEP_VOLUME_QUAL]
			,src.[VOLUME_END_DATE]
			,src.[VOLUME_OUOM]
			,src.[VOLUME_QUALITY_OUOM]
			,src.[VOLUME_START_DATE]
			,src.[VOLUME_UOM]
			,src.[YTD_VOLUME]
			,src.[ROW_CHANGED_BY]
			,src.[ROW_CHANGED_DATE]
			,src.[ROW_CREATED_BY]
			,src.[ROW_CREATED_DATE]
			,src.[ROW_QUALITY]
			,src.[PROVINCE_STATE]
			,src.[POOL_ID]
			,src.[X_STRAT_UNIT_ID]
			,src.[TOP_STRAT_AGE]
			,src.[BASE_STRAT_AGE]
			,src.[STRAT_NAME_SET_ID]
		FROM
			#t_ihs_pden_vol_by_month_MERGE as src
		WHERE Flag='INSERT'
	
		UPDATE [stage].[t_ihs_pden_vol_by_month]
		SET
			[stage].[t_ihs_pden_vol_by_month].PDEN_TYPE				=   src.PDEN_TYPE,
			[stage].[t_ihs_pden_vol_by_month].PDEN_SOURCE             =   src.PDEN_SOURCE,
			[stage].[t_ihs_pden_vol_by_month].VOLUME_METHOD           =   src.VOLUME_METHOD,
			[stage].[t_ihs_pden_vol_by_month].ACTIVE_IND              =   src.ACTIVE_IND,
			[stage].[t_ihs_pden_vol_by_month].AMEND_REASON            =   src.AMEND_REASON,
			[stage].[t_ihs_pden_vol_by_month].APR_VOLUME              =   src.APR_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].APR_VOLUME_QUAL         =   src.APR_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].AUG_VOLUME              =   src.AUG_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].AUG_VOLUME_QUAL         =   src.AUG_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].CUM_VOLUME              =   src.CUM_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].DEC_VOLUME              =   src.DEC_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].DEC_VOLUME_QUAL         =   src.DEC_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].EFFECTIVE_DATE          =   src.EFFECTIVE_DATE,
			[stage].[t_ihs_pden_vol_by_month].EXPIRY_DATE             =   src.EXPIRY_DATE,
			[stage].[t_ihs_pden_vol_by_month].FEB_VOLUME              =   src.FEB_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].FEB_VOLUME_QUAL         =   src.FEB_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].JAN_VOLUME              =   src.JAN_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].JAN_VOLUME_QUAL         =   src.JAN_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].JUL_VOLUME              =   src.JUL_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].JUL_VOLUME_QUAL         =   src.JUL_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].JUN_VOLUME              =   src.JUN_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].JUN_VOLUME_QUAL         =   src.JUN_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].MAR_VOLUME              =   src.MAR_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].MAR_VOLUME_QUAL         =   src.MAR_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].MAY_VOLUME              =   src.MAY_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].MAY_VOLUME_QUAL         =   src.MAY_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].NOV_VOLUME              =   src.NOV_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].NOV_VOLUME_QUAL         =   src.NOV_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].OCT_VOLUME              =   src.OCT_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].OCT_VOLUME_QUAL         =   src.OCT_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].POSTED_DATE             =   src.POSTED_DATE,
			[stage].[t_ihs_pden_vol_by_month].PPDM_GUID               =   src.PPDM_GUID,
			[stage].[t_ihs_pden_vol_by_month].REMARK                  =   src.REMARK,
			[stage].[t_ihs_pden_vol_by_month].SEP_VOLUME              =   src.SEP_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].SEP_VOLUME_QUAL         =   src.SEP_VOLUME_QUAL,
			[stage].[t_ihs_pden_vol_by_month].VOLUME_END_DATE         =   src.VOLUME_END_DATE,
			[stage].[t_ihs_pden_vol_by_month].VOLUME_OUOM             =   src.VOLUME_OUOM,
			[stage].[t_ihs_pden_vol_by_month].VOLUME_QUALITY_OUOM     =   src.VOLUME_QUALITY_OUOM,
			[stage].[t_ihs_pden_vol_by_month].VOLUME_START_DATE       =   src.VOLUME_START_DATE,
			[stage].[t_ihs_pden_vol_by_month].VOLUME_UOM              =   src.VOLUME_UOM,
			[stage].[t_ihs_pden_vol_by_month].YTD_VOLUME              =   src.YTD_VOLUME,
			[stage].[t_ihs_pden_vol_by_month].ROW_CHANGED_BY          =   src.ROW_CHANGED_BY,
			[stage].[t_ihs_pden_vol_by_month].ROW_CHANGED_DATE        =   src.ROW_CHANGED_DATE,
			[stage].[t_ihs_pden_vol_by_month].ROW_CREATED_BY          =   src.ROW_CREATED_BY,
			[stage].[t_ihs_pden_vol_by_month].ROW_CREATED_DATE        =   src.ROW_CREATED_DATE,
			[stage].[t_ihs_pden_vol_by_month].ROW_QUALITY             =   src.ROW_QUALITY,
			[stage].[t_ihs_pden_vol_by_month].PROVINCE_STATE          =   src.PROVINCE_STATE,
			[stage].[t_ihs_pden_vol_by_month].POOL_ID                 =   src.POOL_ID,
			[stage].[t_ihs_pden_vol_by_month].X_STRAT_UNIT_ID         =   src.X_STRAT_UNIT_ID,
			[stage].[t_ihs_pden_vol_by_month].TOP_STRAT_AGE           =   src.TOP_STRAT_AGE,
			[stage].[t_ihs_pden_vol_by_month].BASE_STRAT_AGE          =   src.BASE_STRAT_AGE,
			[stage].[t_ihs_pden_vol_by_month].STRAT_NAME_SET_ID       =   src.STRAT_NAME_SET_ID
		FROM #t_ihs_pden_vol_by_month_MERGE as src
		WHERE   ([stage].[t_ihs_pden_vol_by_month].pden_id			= src.pden_id
	       AND [stage].[t_ihs_pden_vol_by_month].year				= src.year
	       AND [stage].[t_ihs_pden_vol_by_month].activity_type	= src.activity_type
		   AND [stage].[t_ihs_pden_vol_by_month].product_type		= src.product_type
		   AND [stage].[t_ihs_pden_vol_by_month].amendment_seq_no = src.amendment_seq_no
		   )
			AND Flag='UPDATE'

	DECLARE @INSERTED INT = (SELECT COUNT(0) FROM #t_ihs_pden_vol_by_month_MERGE WHERE Flag='INSERT')
	DECLARE @UPDATED INT = (SELECT COUNT(0) FROM #t_ihs_pden_vol_by_month_MERGE WHERE Flag='UPDATE')
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