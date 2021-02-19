CREATE PROC [data_mart].[full_prodview_downtime_facts] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


BEGIN TRY	
	IF OBJECT_ID('tempdb..#t_fact_source_fdc_prodview_downtime_MERGE') IS NOT NULL
		  DROP TABLE #t_fact_source_fdc_prodview_downtime_MERGE	
	CREATE TABLE #t_fact_source_fdc_prodview_downtime_MERGE
	(
		[Flag] varchar(10),
		[site_id] varchar(100),
		activity_date_key int,
		gross_net_key int,
		scenario_key varchar(100),
		[data_type] [varchar](8) NOT NULL,
		[entity_key] [varchar](50) NULL,
		[gas_metric_volume] [float] NULL,
		[gas_imperial_volume] [float] NULL,
		[gas_boe_volume] [float] NULL,
		[gas_mcfe_volume] [float] NULL,
		[oil_metric_volume] [float] NULL,
		[oil_imperial_volume] [float] NULL,
		[oil_boe_volume] [float] NULL,
		[oil_mcfe_volume] [float] NULL,
		[ethane_metric_volume] [float] NULL,
		[ethane_imperial_volume] [float] NULL,
		[ethane_boe_volume] [float] NULL,
		[ethane_mcfe_volume] [float] NULL,
		[propane_metric_volume] [float] NULL,
		[propane_imperial_volume] [float] NULL,
		[propane_boe_volume] [float] NULL,
		[propane_mcfe_volume] [float] NULL,
		[butane_metric_volume] [float] NULL,
		[butane_imperial_volume] [float] NULL,
		[butane_boe_volume] [float] NULL,
		[butane_mcfe_volume] [float] NULL,
		[pentane_metric_volume] [float] NULL,
		[pentane_imperial_volume] [float] NULL,
		[pentane_boe_volume] [float] NULL,
		[pentane_mcfe_volume] [float] NULL,
		[condensate_metric_volume] [float] NULL,
		[condensate_imperial_volume] [float] NULL,
		[condensate_boe_volume] [float] NULL,
		[condensate_mcfe_volume] [float] NULL,
		[total_ngl_metric_volume] [float] NULL,
		[total_ngl_imperial_volume] [float] NULL,
		[total_ngl_boe_volume] [float] NULL,
		[total_ngl_mcfe_volume] [float] NULL,
		[total_liquid_metric_volume] [float] NULL,
		[total_liquid_imperial_volume] [float] NULL,
		[total_liquid_boe_volume] [float] NULL,
		[total_liquid_mcfe_volume] [float] NULL,
		[total_boe_volume] [float] NULL,
		[water_metric_volume] [float] NULL,
		[water_imperial_volume] [float] NULL,
		[water_boe_volume] [float] NULL,
		[water_mcfe_volume] [float] NULL,
		[hours_on] [float] NULL,
		[hours_down] [float] NULL
	)
	WITH
	(
		DISTRIBUTION = ROUND_ROBIN,
		CLUSTERED COLUMNSTORE INDEX
	)

    -- Merge Prodview Downtime Volumes
	
	BEGIN TRANSACTION		
	
	INSERT INTO #t_fact_source_fdc_prodview_downtime_MERGE
	(
		[Flag], site_id, activity_date_key,gross_net_key, scenario_key,
		[data_type], [entity_key], [gas_metric_volume], [gas_imperial_volume], [gas_boe_volume], [gas_mcfe_volume], [oil_metric_volume],
		[oil_imperial_volume], [oil_boe_volume], [oil_mcfe_volume], [ethane_metric_volume], [ethane_imperial_volume], [ethane_boe_volume], 
		[ethane_mcfe_volume], [propane_metric_volume], [propane_imperial_volume], [propane_boe_volume], [propane_mcfe_volume], 
		[butane_metric_volume], [butane_imperial_volume], [butane_boe_volume], [butane_mcfe_volume], [pentane_metric_volume], 
		[pentane_imperial_volume], [pentane_boe_volume], [pentane_mcfe_volume], [condensate_metric_volume], [condensate_imperial_volume], 
		[condensate_boe_volume], [condensate_mcfe_volume], [total_ngl_metric_volume], [total_ngl_imperial_volume], [total_ngl_boe_volume], 
		[total_ngl_mcfe_volume], [total_liquid_metric_volume], [total_liquid_imperial_volume], [total_liquid_boe_volume], 
		[total_liquid_mcfe_volume], [total_boe_volume], [water_metric_volume], [water_imperial_volume], [water_boe_volume], 
		[water_mcfe_volume], [hours_on], [hours_down]
	)
	SELECT
		 CASE WHEN 
					facts.site_id is null 
					AND facts.activity_date_key is null 
					AND facts.gross_net_key is null 
					AND facts.scenario_key is null 
				THEN 'NEW'
			ELSE 'UPDATE'
		 END [Flag],  
		src.site_id, src.activity_date_key, src.gross_net_key, src.scenario_key,
	    src.[data_type], uwi [entity_key], src.[gas_metric_volume], src.[gas_imperial_volume], src.[gas_boe_volume], src.[gas_mcfe_volume], src.[oil_metric_volume],
		src.[oil_imperial_volume], src.[oil_boe_volume], src.[oil_mcfe_volume], src.[ethane_metric_volume], src.[ethane_imperial_volume], src.[ethane_boe_volume], 
		src.[ethane_mcfe_volume], src.[propane_metric_volume], src.[propane_imperial_volume], src.[propane_boe_volume], src.[propane_mcfe_volume], 
		src.[butane_metric_volume], src.[butane_imperial_volume], src.[butane_boe_volume], src.[butane_mcfe_volume], src.[pentane_metric_volume], 
		src.[pentane_imperial_volume], src.[pentane_boe_volume], src.[pentane_mcfe_volume], src.[condensate_metric_volume], src.[condensate_imperial_volume], 
		src.[condensate_boe_volume], src.[condensate_mcfe_volume], src.[total_ngl_metric_volume], src.[total_ngl_imperial_volume], src.[total_ngl_boe_volume], 
		src.[total_ngl_mcfe_volume], src.[total_liquid_metric_volume], src.[total_liquid_imperial_volume], src.[total_liquid_boe_volume], 
		src.[total_liquid_mcfe_volume], src.[total_boe_volume], src.[water_metric_volume], src.[water_imperial_volume], src.[water_boe_volume], 
		src.[water_mcfe_volume], src.[hours_on], src.[hours_down]
	FROM
		[stage].[v_fact_source_fdc_prodview_downtime] as src
		LEFT JOIN [data_mart].[t_fact_fdc] facts
		ON      (  facts.site_id			= src.site_id
          AND	   facts.activity_date_key		= src.activity_date_key
	      AND  facts.gross_net_key			= src.gross_net_key
	      AND      facts.scenario_key		= src.scenario_key)
	
	UPDATE [data_mart].[t_fact_fdc]
	SET
	    [data_mart].[t_fact_fdc].data_type				= src.data_type,
	    [data_mart].[t_fact_fdc].entity_key			= src.entity_key,
	    [data_mart].[t_fact_fdc].gas_metric_volume              	= src.gas_metric_volume,
	    [data_mart].[t_fact_fdc].gas_imperial_volume              	= src.gas_imperial_volume,
	    [data_mart].[t_fact_fdc].gas_boe_volume              	= src.gas_boe_volume,
	    [data_mart].[t_fact_fdc].gas_mcfe_volume              	= src.gas_mcfe_volume,
	    [data_mart].[t_fact_fdc].oil_metric_volume              	= src.oil_metric_volume,
	    [data_mart].[t_fact_fdc].oil_imperial_volume              	= src.oil_imperial_volume,
		[data_mart].[t_fact_fdc].oil_boe_volume              	= src.oil_boe_volume,
		[data_mart].[t_fact_fdc].oil_mcfe_volume              	= src.oil_mcfe_volume,
		[data_mart].[t_fact_fdc].ethane_metric_volume              = src.ethane_metric_volume,
		[data_mart].[t_fact_fdc].ethane_imperial_volume            = src.ethane_imperial_volume,
		[data_mart].[t_fact_fdc].ethane_boe_volume              	= src.ethane_boe_volume,
		[data_mart].[t_fact_fdc].ethane_mcfe_volume              	= src.ethane_mcfe_volume,
		[data_mart].[t_fact_fdc].propane_metric_volume             = src.propane_metric_volume,
		[data_mart].[t_fact_fdc].propane_imperial_volume           = src.propane_imperial_volume,
		[data_mart].[t_fact_fdc].propane_boe_volume              	= src.propane_boe_volume,
		[data_mart].[t_fact_fdc].propane_mcfe_volume              	= src.propane_mcfe_volume,
		[data_mart].[t_fact_fdc].butane_metric_volume              = src.butane_metric_volume,
		[data_mart].[t_fact_fdc].butane_imperial_volume            = src.butane_imperial_volume,
		[data_mart].[t_fact_fdc].butane_boe_volume              	= src.butane_boe_volume,
		[data_mart].[t_fact_fdc].butane_mcfe_volume              	= src.butane_mcfe_volume,
		[data_mart].[t_fact_fdc].pentane_metric_volume             = src.pentane_metric_volume,
		[data_mart].[t_fact_fdc].pentane_imperial_volume           = src.pentane_imperial_volume,
		[data_mart].[t_fact_fdc].pentane_boe_volume              	= src.pentane_boe_volume,
		[data_mart].[t_fact_fdc].pentane_mcfe_volume              	= src.pentane_mcfe_volume,
		[data_mart].[t_fact_fdc].condensate_metric_volume          = src.condensate_metric_volume,
		[data_mart].[t_fact_fdc].condensate_imperial_volume        = src.condensate_imperial_volume,
		[data_mart].[t_fact_fdc].condensate_boe_volume             = src.condensate_boe_volume,
		[data_mart].[t_fact_fdc].condensate_mcfe_volume            = src.condensate_mcfe_volume,
		[data_mart].[t_fact_fdc].total_ngl_metric_volume           = src.total_ngl_metric_volume,
		[data_mart].[t_fact_fdc].total_ngl_imperial_volume         = src.total_ngl_imperial_volume,
		[data_mart].[t_fact_fdc].total_ngl_boe_volume              = src.total_ngl_boe_volume,
		[data_mart].[t_fact_fdc].total_ngl_mcfe_volume             = src.total_ngl_mcfe_volume,
		[data_mart].[t_fact_fdc].total_liquid_metric_volume        = src.total_liquid_metric_volume,
		[data_mart].[t_fact_fdc].total_liquid_imperial_volume      = src.total_liquid_imperial_volume,
		[data_mart].[t_fact_fdc].total_liquid_boe_volume           = src.total_liquid_boe_volume,
		[data_mart].[t_fact_fdc].total_liquid_mcfe_volume          = src.total_liquid_mcfe_volume,
		[data_mart].[t_fact_fdc].total_boe_volume              	= src.total_boe_volume,
		[data_mart].[t_fact_fdc].water_metric_volume              	= src.water_metric_volume,
		[data_mart].[t_fact_fdc].water_imperial_volume             = src.water_imperial_volume,
		[data_mart].[t_fact_fdc].water_boe_volume              	= src.water_boe_volume,
		[data_mart].[t_fact_fdc].water_mcfe_volume              	= src.water_mcfe_volume,
		[data_mart].[t_fact_fdc].hours_on              		= src.hours_on,
		[data_mart].[t_fact_fdc].hours_down              		= src.hours_down,
		[data_mart].[t_fact_fdc].last_update_date		      	= current_timestamp
	FROM
		#t_fact_source_fdc_prodview_downtime_MERGE src
	WHERE
		 [data_mart].[t_fact_fdc].site_id			= src.site_id
         AND [data_mart].[t_fact_fdc].activity_date_key		= src.activity_date_key
	     AND [data_mart].[t_fact_fdc].gross_net_key			= src.gross_net_key
	     AND [data_mart].[t_fact_fdc].scenario_key		= src.scenario_key
		AND src.Flag='UPDATE'

	INSERT INTO  [data_mart].[t_fact_fdc]
	(
	    site_id, activity_date_key,gross_net_key, scenario_key,
		[data_type], [entity_key], [gas_metric_volume], [gas_imperial_volume], [gas_boe_volume], [gas_mcfe_volume], [oil_metric_volume],
		[oil_imperial_volume], [oil_boe_volume], [oil_mcfe_volume], [ethane_metric_volume], [ethane_imperial_volume], [ethane_boe_volume], 
		[ethane_mcfe_volume], [propane_metric_volume], [propane_imperial_volume], [propane_boe_volume], [propane_mcfe_volume], 
		[butane_metric_volume], [butane_imperial_volume], [butane_boe_volume], [butane_mcfe_volume], [pentane_metric_volume], 
		[pentane_imperial_volume], [pentane_boe_volume], [pentane_mcfe_volume], [condensate_metric_volume], [condensate_imperial_volume], 
		[condensate_boe_volume], [condensate_mcfe_volume], [total_ngl_metric_volume], [total_ngl_imperial_volume], [total_ngl_boe_volume], 
		[total_ngl_mcfe_volume], [total_liquid_metric_volume], [total_liquid_imperial_volume], [total_liquid_boe_volume], 
		[total_liquid_mcfe_volume], [total_boe_volume], [water_metric_volume], [water_imperial_volume], [water_boe_volume], 
		[water_mcfe_volume], [hours_on], [hours_down], last_update_date
	)
	SELECT
		site_id, activity_date_key,gross_net_key, scenario_key,
		[data_type], [entity_key], [gas_metric_volume], [gas_imperial_volume], [gas_boe_volume], [gas_mcfe_volume], [oil_metric_volume],
		[oil_imperial_volume], [oil_boe_volume], [oil_mcfe_volume], [ethane_metric_volume], [ethane_imperial_volume], [ethane_boe_volume], 
		[ethane_mcfe_volume], [propane_metric_volume], [propane_imperial_volume], [propane_boe_volume], [propane_mcfe_volume], 
		[butane_metric_volume], [butane_imperial_volume], [butane_boe_volume], [butane_mcfe_volume], [pentane_metric_volume], 
		[pentane_imperial_volume], [pentane_boe_volume], [pentane_mcfe_volume], [condensate_metric_volume], [condensate_imperial_volume], 
		[condensate_boe_volume], [condensate_mcfe_volume], [total_ngl_metric_volume], [total_ngl_imperial_volume], [total_ngl_boe_volume], 
		[total_ngl_mcfe_volume], [total_liquid_metric_volume], [total_liquid_imperial_volume], [total_liquid_boe_volume], 
		[total_liquid_mcfe_volume], [total_boe_volume], [water_metric_volume], [water_imperial_volume], [water_boe_volume], 
		[water_mcfe_volume], [hours_on], [hours_down], current_timestamp
	FROM
		#t_fact_source_fdc_prodview_downtime_MERGE
	WHERE Flag='NEW'

	DECLARE @INSERTED INT = (SELECT COUNT(*) from #t_fact_source_fdc_prodview_downtime_MERGE as src  WHERE src.Flag = 'NEW')
	DECLARE @UPDATED INT = (SELECT COUNT(*) from #t_fact_source_fdc_prodview_downtime_MERGE as src WHERE src.Flag = 'UPDATE')
	SELECT @INSERTED AS INSERTED, @UPDATED AS UPDATED

    COMMIT TRANSACTION

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

  --RETURN @@ERROR

END