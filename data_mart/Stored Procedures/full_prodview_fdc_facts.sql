CREATE PROC [data_mart].[full_prodview_fdc_facts] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


BEGIN TRY	

    -- Merge Raw and Sales Prodview Volumes
	
	--BEGIN TRANSACTION		
	
    IF OBJECT_ID('tempdb..#full_prodview_fdc_facts_MERGE') IS NOT NULL
      DROP TABLE #full_prodview_fdc_facts_MERGE	 

    CREATE TABLE #full_prodview_fdc_facts_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS	
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
	      src.bsw--,
	     -- current_timestamp last_update_date
        FROM [stage].[t_fact_source_fdc_prodview] as src
      	LEFT JOIN [data_mart].t_fact_fdc as trg   
      	  ON trg.site_id				= src.site_id AND
             trg.activity_date_key		= src.activity_date_key AND
	         trg.gross_net_key			= src.gross_net_key AND
	         trg.data_type				= src.data_type
        WHERE
		  trg.site_id IS NULL AND			
		  trg.activity_date_key	IS NULL AND
		  trg.gross_net_key IS NULL AND	 	
		  trg.data_type	IS NULL	

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
	      src.bsw
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
             FROM [stage].[t_fact_source_fdc_prodview] as src
      	     INNER JOIN [data_mart].t_fact_fdc as trg   
      	       ON trg.site_id				= src.site_id AND
                  trg.activity_date_key		= src.activity_date_key AND
	              trg.gross_net_key			= src.gross_net_key AND
	              trg.data_type				= src.data_type

             EXCEPT

	         SELECT
               trg.site_id,
               trg.entity_key,
	           trg.activity_date_key,
	           trg.scenario_key,
	           trg.data_type,
	           trg.gross_net_key,
	           trg.gas_metric_volume,
	           trg.gas_imperial_volume,
	           trg.gas_boe_volume,
	           trg.gas_mcfe_volume,
	           trg.oil_metric_volume,
	           trg.oil_imperial_volume,
	           trg.oil_boe_volume,
	           trg.oil_mcfe_volume,
	           trg.ethane_metric_volume,
	           trg.ethane_imperial_volume,
	           trg.ethane_boe_volume,
	           trg.ethane_mcfe_volume,
	           trg.propane_metric_volume,
	           trg.propane_imperial_volume,
	           trg.propane_boe_volume,
	           trg.propane_mcfe_volume,
	           trg.butane_metric_volume,
	           trg.butane_imperial_volume,
	           trg.butane_boe_volume,
	           trg.butane_mcfe_volume,
	           trg.pentane_metric_volume,
	           trg.pentane_imperial_volume,
	           trg.pentane_boe_volume,
	           trg.pentane_mcfe_volume,
	           trg.condensate_metric_volume,
	           trg.condensate_imperial_volume,
	           trg.condensate_boe_volume,
	           trg.condensate_mcfe_volume,
	           trg.total_ngl_metric_volume,
	           trg.total_ngl_imperial_volume,
	           trg.total_ngl_boe_volume,
	           trg.total_ngl_mcfe_volume,
	           trg.total_liquid_metric_volume,
	           trg.total_liquid_imperial_volume,
	           trg.total_liquid_boe_volume,
	           trg.total_liquid_mcfe_volume,
	           trg.total_boe_volume,
	           trg.water_metric_volume,
	           trg.water_imperial_volume,
	           trg.water_boe_volume,
	           trg.water_mcfe_volume,
	           trg.hours_on,
	           trg.hours_down,
	           trg.casing_pressure,
	           trg.tubing_pressure,
	           trg.joints_to_fluid,
	           trg.bsw
             FROM
               [data_mart].t_fact_fdc as trg 
		  ) src		  

	
	INSERT INTO [data_mart].[t_fact_fdc]
	  (
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
	     last_update_date	    
	  )
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
	    src.bsw,
	    current_timestamp last_update_date
      FROM
	    #full_prodview_fdc_facts_MERGE src
      WHERE
	    Flag = 'NEW'

	UPDATE [data_mart].[t_fact_fdc]
	SET
	    [data_mart].[t_fact_fdc].scenario_key						 = UPD.scenario_key,
	    [data_mart].[t_fact_fdc].entity_key						 = UPD.entity_key,
	    [data_mart].[t_fact_fdc].gas_metric_volume              = UPD.gas_metric_volume,
	    [data_mart].[t_fact_fdc].gas_imperial_volume              = UPD.gas_imperial_volume,
	    [data_mart].[t_fact_fdc].gas_boe_volume              = UPD.gas_boe_volume,
	    [data_mart].[t_fact_fdc].gas_mcfe_volume              = UPD.gas_mcfe_volume,
	    [data_mart].[t_fact_fdc].oil_metric_volume              = UPD.oil_metric_volume,
	    [data_mart].[t_fact_fdc].oil_imperial_volume              = UPD.oil_imperial_volume,
		[data_mart].[t_fact_fdc].oil_boe_volume              = UPD.oil_boe_volume,
		[data_mart].[t_fact_fdc].oil_mcfe_volume              = UPD.oil_mcfe_volume,
		[data_mart].[t_fact_fdc].ethane_metric_volume              = UPD.ethane_metric_volume,
		[data_mart].[t_fact_fdc].ethane_imperial_volume              = UPD.ethane_imperial_volume,
		[data_mart].[t_fact_fdc].ethane_boe_volume              = UPD.ethane_boe_volume,
		[data_mart].[t_fact_fdc].ethane_mcfe_volume              = UPD.ethane_mcfe_volume,
		[data_mart].[t_fact_fdc].propane_metric_volume              = UPD.propane_metric_volume,
		[data_mart].[t_fact_fdc].propane_imperial_volume              = UPD.propane_imperial_volume,
		[data_mart].[t_fact_fdc].propane_boe_volume              = UPD.propane_boe_volume,
		[data_mart].[t_fact_fdc].propane_mcfe_volume              = UPD.propane_mcfe_volume,
		[data_mart].[t_fact_fdc].butane_metric_volume              = UPD.butane_metric_volume,
		[data_mart].[t_fact_fdc].butane_imperial_volume              = UPD.butane_imperial_volume,
		[data_mart].[t_fact_fdc].butane_boe_volume              = UPD.butane_boe_volume,
		[data_mart].[t_fact_fdc].butane_mcfe_volume              = UPD.butane_mcfe_volume,
		[data_mart].[t_fact_fdc].pentane_metric_volume              = UPD.pentane_metric_volume,
		[data_mart].[t_fact_fdc].pentane_imperial_volume              = UPD.pentane_imperial_volume,
		[data_mart].[t_fact_fdc].pentane_boe_volume              = UPD.pentane_boe_volume,
		[data_mart].[t_fact_fdc].pentane_mcfe_volume              = UPD.pentane_mcfe_volume,
		[data_mart].[t_fact_fdc].condensate_metric_volume              = UPD.condensate_metric_volume,
		[data_mart].[t_fact_fdc].condensate_imperial_volume              = UPD.condensate_imperial_volume,
		[data_mart].[t_fact_fdc].condensate_boe_volume              = UPD.condensate_boe_volume,
		[data_mart].[t_fact_fdc].condensate_mcfe_volume              = UPD.condensate_mcfe_volume,
		[data_mart].[t_fact_fdc].total_ngl_metric_volume              = UPD.total_ngl_metric_volume,
		[data_mart].[t_fact_fdc].total_ngl_imperial_volume              = UPD.total_ngl_imperial_volume,
		[data_mart].[t_fact_fdc].total_ngl_boe_volume              = UPD.total_ngl_boe_volume,
		[data_mart].[t_fact_fdc].total_ngl_mcfe_volume              = UPD.total_ngl_mcfe_volume,
		[data_mart].[t_fact_fdc].total_liquid_metric_volume              = UPD.total_liquid_metric_volume,
		[data_mart].[t_fact_fdc].total_liquid_imperial_volume              = UPD.total_liquid_imperial_volume,
		[data_mart].[t_fact_fdc].total_liquid_boe_volume              = UPD.total_liquid_boe_volume,
		[data_mart].[t_fact_fdc].total_liquid_mcfe_volume              = UPD.total_liquid_mcfe_volume,
		[data_mart].[t_fact_fdc].total_boe_volume              = UPD.total_boe_volume,
		[data_mart].[t_fact_fdc].water_metric_volume              = UPD.water_metric_volume,
		[data_mart].[t_fact_fdc].water_imperial_volume              = UPD.water_imperial_volume,
		[data_mart].[t_fact_fdc].water_boe_volume              = UPD.water_boe_volume,
		[data_mart].[t_fact_fdc].water_mcfe_volume              = UPD.water_mcfe_volume,
		[data_mart].[t_fact_fdc].hours_on              = UPD.hours_on,
		[data_mart].[t_fact_fdc].hours_down              = UPD.hours_down,
		[data_mart].[t_fact_fdc].casing_pressure              = UPD.casing_pressure,
		[data_mart].[t_fact_fdc].tubing_pressure              = UPD.tubing_pressure,
		[data_mart].[t_fact_fdc].joints_to_fluid			   = UPD.joints_to_fluid,
		[data_mart].[t_fact_fdc].bsw						   = UPD.bsw,
	    [data_mart].[t_fact_fdc].last_update_date		      = current_timestamp
    FROM
	  #full_prodview_fdc_facts_MERGE UPD
	WHERE
      [data_mart].[t_fact_fdc].site_id			 = UPD.site_id AND
      [data_mart].[t_fact_fdc].activity_date_key = UPD.activity_date_key AND
	  [data_mart].[t_fact_fdc].gross_net_key	 = UPD.gross_net_key AND
	  [data_mart].[t_fact_fdc].data_type		 = UPD.data_type AND
	  UPD.Flag = 'UPDATE'
      --
	--SET @rowcnt = @@ROWCOUNT
	
    --COMMIT TRANSACTION

	-- Merge Injection Volumes

	--BEGIN TRANSACTION
    IF OBJECT_ID('tempdb..#full_prodview_fdc_facts_MERGE') IS NOT NULL
      DROP TABLE #full_prodview_fdc_facts_MERGE	 

    CREATE TABLE #full_prodview_fdc_facts_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS	
	    SELECT
	      'NEW' Flag,
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
        FROM [stage].[v_fact_source_fdc_prodview_injection] as src
      	LEFT JOIN [data_mart].[t_fact_fdc] as trg
      	  ON trg.site_id				= src.site_id AND
             trg.activity_date_key		= src.activity_date_key AND
	         trg.gross_net_key			= src.gross_net_key AND
	         trg.data_type				= src.data_type
        WHERE
		  trg.site_id IS NULL AND			
		  trg.activity_date_key	IS NULL AND
		  trg.gross_net_key	IS NULL AND	
		  trg.data_type	IS NULL	
		  
        UNION ALL

	    SELECT
	      'UPDATE' Flag,
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
             FROM [stage].[v_fact_source_fdc_prodview_injection] as src
      	     INNER JOIN [data_mart].[t_fact_fdc] as trg
      	       ON trg.site_id				= src.site_id AND
                  trg.activity_date_key		= src.activity_date_key AND
	              trg.gross_net_key			= src.gross_net_key AND
	              trg.data_type				= src.data_type

             EXCEPT

	         SELECT
               trg.site_id,
               trg.entity_key,
	           trg.activity_date_key,
	           trg.scenario_key,
	           trg.data_type,
	           trg.gross_net_key,
	           trg.injected_produced_water,
	           trg.injected_source_water,
	           trg.injected_gas_C02,
	           trg.injected_pressure_kpag
             FROM
               [data_mart].t_fact_fdc as trg 
		  ) src	

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
        src.site_id,
        src.entity_key,
	    src.activity_date_key,
	    src.scenario_key,
	    src.data_type,
	    src.gross_net_key,
	    src.injected_produced_water,
	    src.injected_source_water,
	    src.injected_gas_C02,
	    src.injected_pressure_kpag,
	    current_timestamp last_update_date
      FROM
	    #full_prodview_fdc_facts_MERGE src
      WHERE
	    Flag = 'NEW'

	UPDATE [data_mart].[t_fact_fdc]
	SET
	  [data_mart].[t_fact_fdc].scenario_key				  = UPD.scenario_key,
	  [data_mart].[t_fact_fdc].entity_key				  = UPD.entity_key,
	  [data_mart].[t_fact_fdc].injected_produced_water	  = UPD.injected_produced_water,
	  [data_mart].[t_fact_fdc].injected_source_water	  = UPD.injected_source_water,
	  [data_mart].[t_fact_fdc].injected_gas_C02			  = UPD.injected_gas_c02,
	  [data_mart].[t_fact_fdc].injected_pressure_kpag	  = UPD.injected_pressure_kpag,
	  [data_mart].[t_fact_fdc].last_update_date		      = current_timestamp
    FROM
	  #full_prodview_fdc_facts_MERGE UPD
	WHERE
      [data_mart].[t_fact_fdc].site_id			 = UPD.site_id AND
      [data_mart].[t_fact_fdc].activity_date_key = UPD.activity_date_key AND
	  [data_mart].[t_fact_fdc].gross_net_key	 = UPD.gross_net_key AND
	  [data_mart].[t_fact_fdc].data_type		 = UPD.data_type AND
	  UPD.Flag = 'UPDATE'
	--SET @rowcnt = @rowcnt + @@ROWCOUNT

	--COMMIT TRANSACTION
    -- Update injection_src_water values for select ProdView transactions, corresponding to WSL cost centres

	--BEGIN TRANSACTION

    IF OBJECT_ID('tempdb..#t_fact_fdc_UPDATE') IS NOT NULL
      DROP TABLE #t_fact_fdc_UPDATE	 

    CREATE TABLE #t_fact_fdc_UPDATE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS
	    SELECT 
		  fdc.injected_source_water,
		  fdc.water_metric_volume,
		  fdc.water_imperial_volume,
		  fdc.water_boe_volume,
		  fdc.water_mcfe_volume
	    FROM [data_mart].t_dim_entity cc
		INNER JOIN [data_mart].t_fact_fdc fdc
		  ON fdc.entity_key = cc.entity_key
	    WHERE 
	      cc.is_uwi = 1 AND 
		  cc.cc_type_code = 'WSL'

	UPDATE [data_mart].t_fact_fdc
	SET [data_mart].t_fact_fdc.injected_source_water = UPD.water_metric_volume,
		[data_mart].t_fact_fdc.water_metric_volume = 0,
		[data_mart].t_fact_fdc.water_imperial_volume = 0,
		[data_mart].t_fact_fdc.water_boe_volume = 0,
		[data_mart].t_fact_fdc.water_mcfe_volume = 0
	FROM #t_fact_fdc_UPDATE UPD
	WHERE 
	  [data_mart].t_fact_fdc.data_type IN ('PRODUCTION','SALES_EST') AND
	  [data_mart].t_fact_fdc.scenario_key IN ('Production_PV','Sales_Est_PV') AND
	  ISNULL([data_mart].t_fact_fdc.water_boe_volume,0) <> 0;

	--COMMIT TRANSACTION
	SELECT 1
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

 -- RETURN @@ERROR

END