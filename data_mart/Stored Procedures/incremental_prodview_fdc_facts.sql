CREATE PROC [data_mart].[incremental_prodview_fdc_facts] AS
BEGIN
	/*-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.*/
	SET NOCOUNT ON;
BEGIN TRY	


	

    IF OBJECT_ID('tempdb..#incremental_prodview_fdc_facts_MERGE') IS NOT NULL
        DROP TABLE #incremental_prodview_fdc_facts_MERGE	 
    
	CREATE TABLE #incremental_prodview_fdc_facts_MERGE(
			[Flag] varchar(10),
			[site_id] [varchar](100) NULL,
			[entity_key] [varchar](500) NULL,
			[activity_date_key] [int] NULL,
			[scenario_key] [varchar](1000) NOT NULL,
			[data_type] [varchar](100) NULL,
			[gross_net_key] [int] NOT NULL,
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
			[hours_on] [numeric](18, 4) NULL,
			[hours_down] [numeric](19, 4) NULL,
			[casing_pressure] [float] NULL,
			[tubing_pressure] [float] NULL,
			[last_update_date] [datetime] NOT NULL,
			[injected_produced_water] [float] NULL,
			[injected_source_water] [float] NULL,
			[injected_pressure_kpag] [float] NULL,
			[bsw] [float] NULL,
			[joints_to_fluid] [float] NULL,
			[strokes_per_minute] [float] NULL,
			[injected_gas_C02] [float] NULL
		) 


   /*-- Merge Incremental Raw and Sales Prodview Volumes*/
  BEGIN TRANSACTION		
	INSERT INTO #incremental_prodview_fdc_facts_MERGE
		( Flag,
		  site_id,
		  entity_key,
		  activity_date_key,
		  scenario_key,
		  data_type,
		  gross_net_key,
		  gas_metric_volume,
		  gas_imperial_volume,
		  gas_boe_volume,
		  gas_mcfe_volume,
		  oil_metric_volume,
		  oil_imperial_volume,
		  oil_boe_volume,
		  oil_mcfe_volume,
		  ethane_metric_volume,
		  ethane_imperial_volume,
		  ethane_boe_volume,
		  ethane_mcfe_volume,
		  propane_metric_volume,
		  propane_imperial_volume,
		  propane_boe_volume,
		  propane_mcfe_volume,
		  butane_metric_volume,
		  butane_imperial_volume,
		  butane_boe_volume,
		  butane_mcfe_volume,
		  pentane_metric_volume,
		  pentane_imperial_volume,
		  pentane_boe_volume,
		  pentane_mcfe_volume,
		  condensate_metric_volume,
		  condensate_imperial_volume,
		  condensate_boe_volume,
		  condensate_mcfe_volume,
		  total_ngl_metric_volume,
		  total_ngl_imperial_volume,
		  total_ngl_boe_volume,
		  total_ngl_mcfe_volume,
		  total_liquid_metric_volume,
		  total_liquid_imperial_volume,
		  total_liquid_boe_volume,
		  total_liquid_mcfe_volume,
		  total_boe_volume,
		  water_metric_volume,
		  water_imperial_volume,
		  water_boe_volume,
		  water_mcfe_volume,
		  hours_on,
		  hours_down,
		  casing_pressure,
		  tubing_pressure,
		  joints_to_fluid,
		  bsw,
		  last_update_date)
        SELECT
	      'NEW' Flag,
		  src.site_id,
		  src.uwi entity_key,
		  src.activity_date_key,
		  src.scenario_key,
		  src.data_type,
		  src.gross_net_key,
		  src.gas_metric_volume,
		  src.gas_imperial_volume,
		  src.gas_boe_volume,
		  src.gas_mcfe_volume,
		  src.oil_metric_volume,
		  src.oil_imperial_volume,
		  src.oil_boe_volume,
		  src.oil_mcfe_volume,
		  src.ethane_metric_volume,
		  src.ethane_imperial_volume,
		  src.ethane_boe_volume,
		  src.ethane_mcfe_volume,
		  src.propane_metric_volume,
		  src.propane_imperial_volume,
		  src.propane_boe_volume,
		  src.propane_mcfe_volume,
		  src.butane_metric_volume,
		  src.butane_imperial_volume,
		  src.butane_boe_volume,
		  src.butane_mcfe_volume,
		  src.pentane_metric_volume,
		  src.pentane_imperial_volume,
		  src.pentane_boe_volume,
		  src.pentane_mcfe_volume,
		  src.condensate_metric_volume,
		  src.condensate_imperial_volume,
		  src.condensate_boe_volume,
		  src.condensate_mcfe_volume,
		  src.total_ngl_metric_volume,
		  src.total_ngl_imperial_volume,
		  src.total_ngl_boe_volume,
		  src.total_ngl_mcfe_volume,
		  src.total_liquid_metric_volume,
		  src.total_liquid_imperial_volume,
		  src.total_liquid_boe_volume,
		  src.total_liquid_mcfe_volume,
		  src.total_boe_volume,
		  src.water_metric_volume,
		  src.water_imperial_volume,
		  src.water_boe_volume,
		  src.water_mcfe_volume,
		  src.hours_on,
		  src.hours_down,
		  src.casing_pressure,
		  src.tubing_pressure,
		  src.joints_to_fluid,
		  src.bsw,
		  current_timestamp last_update_date
        FROM [stage].[t_fact_source_fdc_prodview_incr] as src
		LEFT JOIN [data_mart].t_fact_fdc as trg
		  ON trg.site_id = src.site_id AND
		     trg.activity_date_key = src.activity_date_key AND
		     trg.gross_net_key = src.gross_net_key AND
		     trg.data_type = src.data_type
        WHERE
		  trg.site_id IS NULL AND
		  trg.activity_date_key IS NULL AND
		  trg.gross_net_key IS NULL AND
		  trg.data_type IS NULL

        UNION ALL

	    SELECT
		  'UPDATE' Flag,
		  src.site_id,
		  src.entity_key,
		  src.activity_date_key,
		  src.scenario_key,
		  src.data_type,
		  src.gross_net_key,
		  src.gas_metric_volume,
		  src.gas_imperial_volume,
		  src.gas_boe_volume,
		  src.gas_mcfe_volume,
		  src.oil_metric_volume,
		  src.oil_imperial_volume,
		  src.oil_boe_volume,
		  src.oil_mcfe_volume,
		  src.ethane_metric_volume,
		  src.ethane_imperial_volume,
		  src.ethane_boe_volume,
		  src.ethane_mcfe_volume,
		  src.propane_metric_volume,
		  src.propane_imperial_volume,
		  src.propane_boe_volume,
		  src.propane_mcfe_volume,
		  src.butane_metric_volume,
		  src.butane_imperial_volume,
		  src.butane_boe_volume,
		  src.butane_mcfe_volume,
		  src.pentane_metric_volume,
		  src.pentane_imperial_volume,
		  src.pentane_boe_volume,
		  src.pentane_mcfe_volume,
		  src.condensate_metric_volume,
		  src.condensate_imperial_volume,
		  src.condensate_boe_volume,
		  src.condensate_mcfe_volume,
		  src.total_ngl_metric_volume,
		  src.total_ngl_imperial_volume,
		  src.total_ngl_boe_volume,
		  src.total_ngl_mcfe_volume,
		  src.total_liquid_metric_volume,
		  src.total_liquid_imperial_volume,
		  src.total_liquid_boe_volume,
		  src.total_liquid_mcfe_volume,
		  src.total_boe_volume,
		  src.water_metric_volume,
		  src.water_imperial_volume,
		  src.water_boe_volume,
		  src.water_mcfe_volume,
		  src.hours_on,
		  src.hours_down,
		  src.casing_pressure,
		  src.tubing_pressure,
		  src.joints_to_fluid,
		  src.bsw,
		  current_timestamp last_update_date	     
	    FROM
	    (
		   SELECT
		     src.site_id,
		     src.uwi entity_key,
		     src.activity_date_key,
		     src.scenario_key,
		     src.data_type,
		     src.gross_net_key,
		     src.gas_metric_volume,
		     src.gas_imperial_volume,
		     src.gas_boe_volume,
		     src.gas_mcfe_volume,
		     src.oil_metric_volume,
		     src.oil_imperial_volume,
		     src.oil_boe_volume,
		     src.oil_mcfe_volume,
		     src.ethane_metric_volume,
		     src.ethane_imperial_volume,
		     src.ethane_boe_volume,
		     src.ethane_mcfe_volume,
		     src.propane_metric_volume,
		     src.propane_imperial_volume,
		     src.propane_boe_volume,
		     src.propane_mcfe_volume,
		     src.butane_metric_volume,
		     src.butane_imperial_volume,
		     src.butane_boe_volume,
		     src.butane_mcfe_volume,
		     src.pentane_metric_volume,
		     src.pentane_imperial_volume,
		     src.pentane_boe_volume,
		     src.pentane_mcfe_volume,
		     src.condensate_metric_volume,
		     src.condensate_imperial_volume,
		     src.condensate_boe_volume,
		     src.condensate_mcfe_volume,
		     src.total_ngl_metric_volume,
		     src.total_ngl_imperial_volume,
		     src.total_ngl_boe_volume,
		     src.total_ngl_mcfe_volume,
		     src.total_liquid_metric_volume,
		     src.total_liquid_imperial_volume,
		     src.total_liquid_boe_volume,
		     src.total_liquid_mcfe_volume,
		     src.total_boe_volume,
		     src.water_metric_volume,
		     src.water_imperial_volume,
		     src.water_boe_volume,
		     src.water_mcfe_volume,
		     src.hours_on,
		     src.hours_down,
		     src.casing_pressure,
		     src.tubing_pressure,
		     src.joints_to_fluid,
		     src.bsw
           FROM [stage].[t_fact_source_fdc_prodview_incr] as src
		   INNER JOIN [data_mart].t_fact_fdc as trg
		     ON trg.site_id = src.site_id AND
		        trg.activity_date_key = src.activity_date_key AND
		        trg.gross_net_key = src.gross_net_key AND
		        trg.data_type = src.data_type

           EXCEPT

		   SELECT
		     src.site_id,
		     src.entity_key,
		     src.activity_date_key,
		     src.scenario_key,
		     src.data_type,
		     src.gross_net_key,
		     src.gas_metric_volume,
		     src.gas_imperial_volume,
		     src.gas_boe_volume,
		     src.gas_mcfe_volume,
		     src.oil_metric_volume,
		     src.oil_imperial_volume,
		     src.oil_boe_volume,
		     src.oil_mcfe_volume,
		     src.ethane_metric_volume,
		     src.ethane_imperial_volume,
		     src.ethane_boe_volume,
		     src.ethane_mcfe_volume,
		     src.propane_metric_volume,
		     src.propane_imperial_volume,
		     src.propane_boe_volume,
		     src.propane_mcfe_volume,
		     src.butane_metric_volume,
		     src.butane_imperial_volume,
		     src.butane_boe_volume,
		     src.butane_mcfe_volume,
		     src.pentane_metric_volume,
		     src.pentane_imperial_volume,
		     src.pentane_boe_volume,
		     src.pentane_mcfe_volume,
		     src.condensate_metric_volume,
		     src.condensate_imperial_volume,
		     src.condensate_boe_volume,
		     src.condensate_mcfe_volume,
		     src.total_ngl_metric_volume,
		     src.total_ngl_imperial_volume,
		     src.total_ngl_boe_volume,
		     src.total_ngl_mcfe_volume,
		     src.total_liquid_metric_volume,
		     src.total_liquid_imperial_volume,
		     src.total_liquid_boe_volume,
		     src.total_liquid_mcfe_volume,
		     src.total_boe_volume,
		     src.water_metric_volume,
		     src.water_imperial_volume,
		     src.water_boe_volume,
		     src.water_mcfe_volume,
		     src.hours_on,
		     src.hours_down,
		     src.casing_pressure,
		     src.tubing_pressure,
		     src.joints_to_fluid,
		     src.bsw
           FROM [data_mart].t_fact_fdc as src
	    ) src

		UPDATE [data_mart].t_fact_fdc
		SET
			[data_mart].t_fact_fdc.scenario_key							= src.scenario_key,
			[data_mart].t_fact_fdc.entity_key							= src.entity_key,
			[data_mart].t_fact_fdc.gas_metric_volume						= src.gas_metric_volume,
			[data_mart].t_fact_fdc.gas_imperial_volume			        = src.gas_imperial_volume,
			[data_mart].t_fact_fdc.gas_boe_volume						= src.gas_boe_volume,
			[data_mart].t_fact_fdc.gas_mcfe_volume						= src.gas_mcfe_volume,
			[data_mart].t_fact_fdc.oil_metric_volume						= src.oil_metric_volume,
			[data_mart].t_fact_fdc.oil_imperial_volume					= src.oil_imperial_volume,
			[data_mart].t_fact_fdc.oil_boe_volume						= src.oil_boe_volume,
			[data_mart].t_fact_fdc.oil_mcfe_volume						= src.oil_mcfe_volume,
			[data_mart].t_fact_fdc.ethane_metric_volume					= src.ethane_metric_volume,
			[data_mart].t_fact_fdc.ethane_imperial_volume				= src.ethane_imperial_volume,
			[data_mart].t_fact_fdc.ethane_boe_volume						= src.ethane_boe_volume,
			[data_mart].t_fact_fdc.ethane_mcfe_volume					= src.ethane_mcfe_volume,
			[data_mart].t_fact_fdc.propane_metric_volume					= src.propane_metric_volume,
			[data_mart].t_fact_fdc.propane_imperial_volume				= src.propane_imperial_volume,
			[data_mart].t_fact_fdc.propane_boe_volume					= src.propane_boe_volume,
			[data_mart].t_fact_fdc.propane_mcfe_volume					= src.propane_mcfe_volume,
			[data_mart].t_fact_fdc.butane_metric_volume					= src.butane_metric_volume,
			[data_mart].t_fact_fdc.butane_imperial_volume				= src.butane_imperial_volume,
			[data_mart].t_fact_fdc.butane_boe_volume						= src.butane_boe_volume,
			[data_mart].t_fact_fdc.butane_mcfe_volume					= src.butane_mcfe_volume,
			[data_mart].t_fact_fdc.pentane_metric_volume					= src.pentane_metric_volume,
			[data_mart].t_fact_fdc.pentane_imperial_volume				= src.pentane_imperial_volume,
			[data_mart].t_fact_fdc.pentane_boe_volume					= src.pentane_boe_volume,
			[data_mart].t_fact_fdc.pentane_mcfe_volume					= src.pentane_mcfe_volume,
			[data_mart].t_fact_fdc.condensate_metric_volume              = src.condensate_metric_volume,
			[data_mart].t_fact_fdc.condensate_imperial_volume			= src.condensate_imperial_volume,
			[data_mart].t_fact_fdc.condensate_boe_volume					= src.condensate_boe_volume,
			[data_mart].t_fact_fdc.condensate_mcfe_volume				= src.condensate_mcfe_volume,
			[data_mart].t_fact_fdc.total_ngl_metric_volume				= src.total_ngl_metric_volume,
			[data_mart].t_fact_fdc.total_ngl_imperial_volume				= src.total_ngl_imperial_volume,
			[data_mart].t_fact_fdc.total_ngl_boe_volume					= src.total_ngl_boe_volume,
			[data_mart].t_fact_fdc.total_ngl_mcfe_volume					= src.total_ngl_mcfe_volume,
			[data_mart].t_fact_fdc.total_liquid_metric_volume			= src.total_liquid_metric_volume,
			[data_mart].t_fact_fdc.total_liquid_imperial_volume			= src.total_liquid_imperial_volume,
			[data_mart].t_fact_fdc.total_liquid_boe_volume				= src.total_liquid_boe_volume,
			[data_mart].t_fact_fdc.total_liquid_mcfe_volume				= src.total_liquid_mcfe_volume,
			[data_mart].t_fact_fdc.total_boe_volume						= src.total_boe_volume,
			[data_mart].t_fact_fdc.water_metric_volume					= src.water_metric_volume,
			[data_mart].t_fact_fdc.water_imperial_volume					= src.water_imperial_volume,
			[data_mart].t_fact_fdc.water_boe_volume						= src.water_boe_volume,
			[data_mart].t_fact_fdc.water_mcfe_volume						= src.water_mcfe_volume,
			[data_mart].t_fact_fdc.hours_on								= src.hours_on,
			[data_mart].t_fact_fdc.hours_down							= src.hours_down,
			[data_mart].t_fact_fdc.casing_pressure						= src.casing_pressure,
			[data_mart].t_fact_fdc.tubing_pressure						= src.tubing_pressure,
			[data_mart].t_fact_fdc.joints_to_fluid						= src.joints_to_fluid,
			[data_mart].t_fact_fdc.bsw									= src.bsw,
			[data_mart].t_fact_fdc.last_update_date						= current_timestamp
		FROM
			#incremental_prodview_fdc_facts_MERGE src
		WHERE
			[data_mart].t_fact_fdc.site_id = src.site_id
			AND [data_mart].t_fact_fdc.activity_date_key = src.activity_date_key
			AND [data_mart].t_fact_fdc.gross_net_key = src.gross_net_key
			AND [data_mart].t_fact_fdc.data_type = src.data_type
			AND src.Flag = 'UPDATE'	

		
			
		INSERT INTO [data_mart].[t_fact_fdc]
				   ([site_id]
				   ,[entity_key]
				   ,[activity_date_key]
				   ,[scenario_key]
				   ,[data_type]
				   ,[gross_net_key]
				   ,[gas_metric_volume]
				   ,[gas_imperial_volume]
				   ,[gas_boe_volume]
				   ,[gas_mcfe_volume]
				   ,[oil_metric_volume]
				   ,[oil_imperial_volume]
				   ,[oil_boe_volume]
				   ,[oil_mcfe_volume]
				   ,[ethane_metric_volume]
				   ,[ethane_imperial_volume]
				   ,[ethane_boe_volume]
				   ,[ethane_mcfe_volume]
				   ,[propane_metric_volume]
				   ,[propane_imperial_volume]
				   ,[propane_boe_volume]
				   ,[propane_mcfe_volume]
				   ,[butane_metric_volume]
				   ,[butane_imperial_volume]
				   ,[butane_boe_volume]
				   ,[butane_mcfe_volume]
				   ,[pentane_metric_volume]
				   ,[pentane_imperial_volume]
				   ,[pentane_boe_volume]
				   ,[pentane_mcfe_volume]
				   ,[condensate_metric_volume]
				   ,[condensate_imperial_volume]
				   ,[condensate_boe_volume]
				   ,[condensate_mcfe_volume]
				   ,[total_ngl_metric_volume]
				   ,[total_ngl_imperial_volume]
				   ,[total_ngl_boe_volume]
				   ,[total_ngl_mcfe_volume]
				   ,[total_liquid_metric_volume]
				   ,[total_liquid_imperial_volume]
				   ,[total_liquid_boe_volume]
				   ,[total_liquid_mcfe_volume]
				   ,[total_boe_volume]
				   ,[water_metric_volume]
				   ,[water_imperial_volume]
				   ,[water_boe_volume]
				   ,[water_mcfe_volume]
				   ,[hours_on]
				   ,[hours_down]
				   ,[casing_pressure]
				   ,[tubing_pressure]
				   ,[last_update_date]
				   ,[injected_produced_water]
				   ,[injected_source_water]
				   ,[injected_pressure_kpag]
				   ,[bsw]
				   ,[joints_to_fluid]
				   ,[strokes_per_minute]
				   ,[injected_gas_C02])
		SELECT
					[site_id]
				   ,[entity_key]
				   ,[activity_date_key]
				   ,[scenario_key]
				   ,[data_type]
				   ,[gross_net_key]
				   ,[gas_metric_volume]
				   ,[gas_imperial_volume]
				   ,[gas_boe_volume]
				   ,[gas_mcfe_volume]
				   ,[oil_metric_volume]
				   ,[oil_imperial_volume]
				   ,[oil_boe_volume]
				   ,[oil_mcfe_volume]
				   ,[ethane_metric_volume]
				   ,[ethane_imperial_volume]
				   ,[ethane_boe_volume]
				   ,[ethane_mcfe_volume]
				   ,[propane_metric_volume]
				   ,[propane_imperial_volume]
				   ,[propane_boe_volume]
				   ,[propane_mcfe_volume]
				   ,[butane_metric_volume]
				   ,[butane_imperial_volume]
				   ,[butane_boe_volume]
				   ,[butane_mcfe_volume]
				   ,[pentane_metric_volume]
				   ,[pentane_imperial_volume]
				   ,[pentane_boe_volume]
				   ,[pentane_mcfe_volume]
				   ,[condensate_metric_volume]
				   ,[condensate_imperial_volume]
				   ,[condensate_boe_volume]
				   ,[condensate_mcfe_volume]
				   ,[total_ngl_metric_volume]
				   ,[total_ngl_imperial_volume]
				   ,[total_ngl_boe_volume]
				   ,[total_ngl_mcfe_volume]
				   ,[total_liquid_metric_volume]
				   ,[total_liquid_imperial_volume]
				   ,[total_liquid_boe_volume]
				   ,[total_liquid_mcfe_volume]
				   ,[total_boe_volume]
				   ,[water_metric_volume]
				   ,[water_imperial_volume]
				   ,[water_boe_volume]
				   ,[water_mcfe_volume]
				   ,[hours_on]
				   ,[hours_down]
				   ,[casing_pressure]
				   ,[tubing_pressure]
				   ,[last_update_date]
				   ,[injected_produced_water]
				   ,[injected_source_water]
				   ,[injected_pressure_kpag]
				   ,[bsw]
				   ,[joints_to_fluid]
				   ,[strokes_per_minute]
				   ,[injected_gas_C02]
		FROM
			#incremental_prodview_fdc_facts_MERGE src
		WHERE
			src.Flag = 'NEW'	

	
    COMMIT TRANSACTION

	truncate table #incremental_prodview_fdc_facts_MERGE

	/*-- Merge Incremental Injection Volumes*/

	BEGIN TRANSACTION
		INSERT INTO #incremental_prodview_fdc_facts_MERGE
			(
				Flag,
				site_id,
				entity_key,
				activity_date_key,
				scenario_key,
				data_type,
				gross_net_key,
				injected_produced_water,
				injected_source_water,
				injected_gas_C02,
				injected_pressure_kpag,
				last_update_date
			)
			SELECT
			  'NEW' Flag,
				src.site_id,
				src.entity_key,
				src.activity_date_key,
				src.scenario_key,
				src.data_type,
				src.gross_net_key,
				src.injected_prod_water,
				src.injected_src_water,
				src.injected_gas_C02,
				src.injected_pressure_kpag,
				current_timestamp last_update_date
			FROM stage.v_fact_source_fdc_prodview_injection_incr as src
			LEFT JOIN [data_mart].t_fact_fdc as trg
			  ON trg.site_id = src.site_id AND
				 trg.activity_date_key = src.activity_date_key AND
				 trg.gross_net_key = src.gross_net_key AND
				 trg.data_type = src.data_type
			WHERE
			  trg.site_id IS NULL AND
			  trg.activity_date_key IS NULL AND
			  trg.gross_net_key IS NULL AND
			  trg.data_type IS NULL

			UNION ALL

			SELECT
				'UPDATE' Flag,
				site_id,
				entity_key,
				activity_date_key,
				scenario_key,
				data_type,
				gross_net_key,
				injected_produced_water,
				injected_source_water,
				injected_gas_C02,
				injected_pressure_kpag,
				current_timestamp last_update_date	     
			FROM
			(
			   SELECT
				 src.site_id,
				 src.entity_key,
				 src.activity_date_key,
				 src.scenario_key,
				 src.data_type,
				 src.gross_net_key,
				 src.injected_prod_water injected_produced_water,
				 src.injected_src_water injected_source_water,
				 src.injected_gas_C02,
				 src.injected_pressure_kpag
			   FROM [stage].[v_fact_source_fdc_prodview_injection_incr] as src
			   INNER JOIN [data_mart].t_fact_fdc as trg
				 ON trg.site_id = src.site_id AND
					trg.activity_date_key = src.activity_date_key AND
					trg.gross_net_key = src.gross_net_key AND
					trg.data_type = src.data_type

			   EXCEPT

			   SELECT
					src.site_id,
					src.entity_key,
					src.activity_date_key,
					src.scenario_key,
					src.data_type,
					src.gross_net_key,
					src.injected_produced_water,
					src.injected_source_water,
					src.injected_gas_C02,
					src.injected_pressure_kpag
			   FROM [data_mart].t_fact_fdc as src
			) src

			UPDATE [data_mart].t_fact_fdc
			SET
				[data_mart].t_fact_fdc.scenario_key					= src.scenario_key,
				[data_mart].t_fact_fdc.entity_key					= src.entity_key,
				[data_mart].t_fact_fdc.injected_produced_water		= src.injected_produced_water,
				[data_mart].t_fact_fdc.injected_source_water		= src.injected_source_water,
				[data_mart].t_fact_fdc.injected_gas_C02				= src.injected_gas_c02,
				[data_mart].t_fact_fdc.injected_pressure_kpag		= src.injected_pressure_kpag,
				[data_mart].t_fact_fdc.last_update_date				= current_timestamp

			FROM
				#incremental_prodview_fdc_facts_MERGE src
			WHERE
				[data_mart].t_fact_fdc.site_id = src.site_id
				AND [data_mart].t_fact_fdc.activity_date_key = src.activity_date_key
				AND [data_mart].t_fact_fdc.gross_net_key = src.gross_net_key
				AND [data_mart].t_fact_fdc.data_type = src.data_type
				AND src.Flag = 'UPDATE'	

			INSERT INTO [data_mart].[t_fact_fdc]
			( 
				site_id,
				entity_key,
				activity_date_key,
				scenario_key,
				data_type,
				gross_net_key,
				injected_produced_water,
				injected_source_water,
				injected_gas_C02,
				injected_pressure_kpag,
				last_update_date
			)
			SELECT
				site_id,
				entity_key,
				activity_date_key,
				scenario_key,
				data_type,
				gross_net_key,
				injected_produced_water,
				injected_source_water,
				injected_gas_C02,
				injected_pressure_kpag,
				current_timestamp
			FROM
				#incremental_prodview_fdc_facts_MERGE src
			WHERE
				src.Flag = 'NEW'	


		--SET @rowcnt = @rowcnt + @@ROWCOUNT

	COMMIT TRANSACTION 

/*     -- Update injection_src_water values for select ProdView transactions, corresponding to WSL cost centres*/
	
	BEGIN TRANSACTION
		
		UPDATE [data_mart].t_fact_fdc
			SET [data_mart].t_fact_fdc.injected_source_water = [data_mart].t_fact_fdc.water_metric_volume,
				[data_mart].t_fact_fdc.water_metric_volume = 0,
				[data_mart].t_fact_fdc.water_imperial_volume = 0,
				[data_mart].t_fact_fdc.water_boe_volume = 0,
				[data_mart].t_fact_fdc.water_mcfe_volume = 0
 		FROM 
			[data_mart].t_dim_entity cc
		WHERE 
			[data_mart].t_fact_fdc.entity_key = cc.entity_key
			AND data_type IN ('PRODUCTION','SALES_EST')
			AND   scenario_key IN ('Production_PV','Sales_Est_PV')
			AND ISNULL([data_mart].t_fact_fdc.water_boe_volume,0) <> 0
			AND is_uwi=1
			AND cc_type_code='WSL';
	COMMIT TRANSACTION

	SELECT 1

 END TRY
 
 BEGIN CATCH
       /*-- Grab error information from SQL functions*/
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
			--	,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		/*-- If the error renders the transaction as uncommittable or we have open transactions, rollback*/
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)
  END CATCH

 -- RETURN @@ERROR

END