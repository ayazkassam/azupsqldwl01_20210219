CREATE PROC [stage].[load_fact_source_fdc_prodview] AS

	SET NOCOUNT ON;

	BEGIN TRY

	--BEGIN TRANSACTION

	truncate table [stage].t_fact_source_fdc_prodview
	insert into [stage].t_fact_source_fdc_prodview
	SELECT site_id,
		   uwi,
		   cc_num,
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
		   bsw
	FROM [stage].t_stg_prodview_volumes_final

	--SET @rowcnt = @@ROWCOUNT

	/*-- NET>> for cc's with no unit cc nums*/
	insert into [stage].t_fact_source_fdc_prodview
	SELECT site_id,
		   pgf.uwi,
		   pgf.cc_num,
		   activity_date_key,
		   scenario_key,
		   data_type,
		   2 gross_net_key,
		   gas_metric_volume * (isnull(wi.working_interest,100) / 100) gas_metric_volume,
		   gas_imperial_volume * (isnull(wi.working_interest,100) / 100) gas_imperial_volume,
		   gas_boe_volume * (isnull(wi.working_interest,100) / 100) gas_boe_volume,
		   gas_mcfe_volume * (isnull(wi.working_interest,100) / 100) gas_mcfe_volume,
		   oil_metric_volume * (isnull(wi.working_interest,100) / 100) oil_metric_volume,
		   oil_imperial_volume * (isnull(wi.working_interest,100) / 100) oil_imperial_volume,
		   oil_boe_volume * (isnull(wi.working_interest,100) / 100) oil_boe_volume,
		   oil_mcfe_volume * (isnull(wi.working_interest,100) / 100) oil_mcfe_volume,
		   ethane_metric_volume * (isnull(wi.working_interest,100) / 100) ethane_metric_volume,
		   ethane_imperial_volume * (isnull(wi.working_interest,100) / 100) ethane_imperial_volume,
		   ethane_boe_volume * (isnull(wi.working_interest,100) / 100) ethane_boe_volume,
		   ethane_mcfe_volume * (isnull(wi.working_interest,100) / 100) ethane_mcfe_volume,
		   propane_metric_volume * (isnull(wi.working_interest,100) / 100) propane_metric_volume,
		   propane_imperial_volume * (isnull(wi.working_interest,100) / 100) propane_imperial_volume,
		   propane_boe_volume * (isnull(wi.working_interest,100) / 100) propane_boe_volume,
		   propane_mcfe_volume * (isnull(wi.working_interest,100) / 100) propane_mcfe_volume,
		   butane_metric_volume * (isnull(wi.working_interest,100) / 100) butane_metric_volume,
		   butane_imperial_volume * (isnull(wi.working_interest,100) / 100) butane_imperial_volume,
		   butane_boe_volume * (isnull(wi.working_interest,100) / 100) butane_boe_volume,
		   butane_mcfe_volume * (isnull(wi.working_interest,100) / 100) butane_mcfe_volume,
		   pentane_metric_volume * (isnull(wi.working_interest,100) / 100) pentane_metric_volume,
		   pentane_imperial_volume * (isnull(wi.working_interest,100) / 100) pentane_imperial_volume,
		   pentane_boe_volume * (isnull(wi.working_interest,100) / 100) pentane_boe_volume,
		   pentane_mcfe_volume * (isnull(wi.working_interest,100) / 100) pentane_mcfe_volume,
		   condensate_metric_volume * (isnull(wi.working_interest,100) / 100) condensate_metric_volume,
		   condensate_imperial_volume * (isnull(wi.working_interest,100) / 100) condensate_imperial_volume,
		   condensate_boe_volume * (isnull(wi.working_interest,100) / 100) condensate_boe_volume,
		   condensate_mcfe_volume * (isnull(wi.working_interest,100) / 100) condensate_mcfe_volume,
		   total_ngl_metric_volume * (isnull(wi.working_interest,100) / 100) total_ngl_metric_volume,
		   total_ngl_imperial_volume * (isnull(wi.working_interest,100) / 100) total_ngl_imperial_volume,
		   total_ngl_boe_volume * (isnull(wi.working_interest,100) / 100) total_ngl_boe_volume,
		   total_ngl_mcfe_volume * (isnull(wi.working_interest,100) / 100) total_ngl_mcfe_volume,
		   total_liquid_metric_volume * (isnull(wi.working_interest,100) / 100) total_liquid_metric_volume,
		   total_liquid_imperial_volume * (isnull(wi.working_interest,100) / 100) total_liquid_imperial_volume,
		   total_liquid_boe_volume * (isnull(wi.working_interest,100) / 100) total_liquid_boe_volume,
		   total_liquid_mcfe_volume * (isnull(wi.working_interest,100) / 100) total_liquid_mcfe_volume,
		   total_boe_volume * (isnull(wi.working_interest,100) / 100) total_boe_volume,
		   water_metric_volume * (isnull(wi.working_interest,100) / 100) water_metric_volume,
		   water_imperial_volume * (isnull(wi.working_interest,100) / 100) water_imperial_volume,
		   water_boe_volume * (isnull(wi.working_interest,100) / 100) water_boe_volume,
		   water_mcfe_volume * (isnull(wi.working_interest,100) / 100) water_mcfe_volume,
		   hours_on,
		   hours_down,
		   casing_pressure,
		   tubing_pressure,
		   joints_to_fluid,
		   bsw
	FROM [stage].t_stg_prodview_volumes_final pgf
	JOIN (
		  SELECT cost_centre, unit_cc_num
		  FROM [data_mart].t_dim_entity 
		  WHERE is_cc_dim=1
		  AND unit_cc_num IS NULL
	) ent ON pgf.cc_num = ent.cost_centre
	JOIN [stage].[t_cc_num_working_interest] wi 
		ON pgf.cc_num = wi.cc_num 
		AND (pgf.activity_date >= wi.effective_date 
		AND pgf.activity_date < wi.termination_date)

	--SET @rowcnt = @rowcnt + @@ROWCOUNT

	/*-- NET>> based on unit cc num working interest for cc's with unit cc num*/
	insert into [stage].t_fact_source_fdc_prodview
	SELECT site_id,
		   pgf.uwi,
		   pgf.cc_num,
		   activity_date_key,
		   scenario_key,
		   data_type,
		   2 gross_net_key,
		   gas_metric_volume * (isnull(wi.working_interest,100) / 100) gas_metric_volume,
		   gas_imperial_volume * (isnull(wi.working_interest,100) / 100) gas_imperial_volume,
		   gas_boe_volume * (isnull(wi.working_interest,100) / 100) gas_boe_volume,
		   gas_mcfe_volume * (isnull(wi.working_interest,100) / 100) gas_mcfe_volume,
		   oil_metric_volume * (isnull(wi.working_interest,100) / 100) oil_metric_volume,
		   oil_imperial_volume * (isnull(wi.working_interest,100) / 100) oil_imperial_volume,
		   oil_boe_volume * (isnull(wi.working_interest,100) / 100) oil_boe_volume,
		   oil_mcfe_volume * (isnull(wi.working_interest,100) / 100) oil_mcfe_volume,
		   ethane_metric_volume * (isnull(wi.working_interest,100) / 100) ethane_metric_volume,
		   ethane_imperial_volume * (isnull(wi.working_interest,100) / 100) ethane_imperial_volume,
		   ethane_boe_volume * (isnull(wi.working_interest,100) / 100) ethane_boe_volume,
		   ethane_mcfe_volume * (isnull(wi.working_interest,100) / 100) ethane_mcfe_volume,
		   propane_metric_volume * (isnull(wi.working_interest,100) / 100) propane_metric_volume,
		   propane_imperial_volume * (isnull(wi.working_interest,100) / 100) propane_imperial_volume,
		   propane_boe_volume * (isnull(wi.working_interest,100) / 100) propane_boe_volume,
		   propane_mcfe_volume * (isnull(wi.working_interest,100) / 100) propane_mcfe_volume,
		   butane_metric_volume * (isnull(wi.working_interest,100) / 100) butane_metric_volume,
		   butane_imperial_volume * (isnull(wi.working_interest,100) / 100) butane_imperial_volume,
		   butane_boe_volume * (isnull(wi.working_interest,100) / 100) butane_boe_volume,
		   butane_mcfe_volume * (isnull(wi.working_interest,100) / 100) butane_mcfe_volume,
		   pentane_metric_volume * (isnull(wi.working_interest,100) / 100) pentane_metric_volume,
		   pentane_imperial_volume * (isnull(wi.working_interest,100) / 100) pentane_imperial_volume,
		   pentane_boe_volume * (isnull(wi.working_interest,100) / 100) pentane_boe_volume,
		   pentane_mcfe_volume * (isnull(wi.working_interest,100) / 100) pentane_mcfe_volume,
		   condensate_metric_volume * (isnull(wi.working_interest,100) / 100) condensate_metric_volume,
		   condensate_imperial_volume * (isnull(wi.working_interest,100) / 100) condensate_imperial_volume,
		   condensate_boe_volume * (isnull(wi.working_interest,100) / 100) condensate_boe_volume,
		   condensate_mcfe_volume * (isnull(wi.working_interest,100) / 100) condensate_mcfe_volume,
		   total_ngl_metric_volume * (isnull(wi.working_interest,100) / 100) total_ngl_metric_volume,
		   total_ngl_imperial_volume * (isnull(wi.working_interest,100) / 100) total_ngl_imperial_volume,
		   total_ngl_boe_volume * (isnull(wi.working_interest,100) / 100) total_ngl_boe_volume,
		   total_ngl_mcfe_volume * (isnull(wi.working_interest,100) / 100) total_ngl_mcfe_volume,
		   total_liquid_metric_volume * (isnull(wi.working_interest,100) / 100) total_liquid_metric_volume,
		   total_liquid_imperial_volume * (isnull(wi.working_interest,100) / 100) total_liquid_imperial_volume,
		   total_liquid_boe_volume * (isnull(wi.working_interest,100) / 100) total_liquid_boe_volume,
		   total_liquid_mcfe_volume * (isnull(wi.working_interest,100) / 100) total_liquid_mcfe_volume,
		   total_boe_volume * (isnull(wi.working_interest,100) / 100) total_boe_volume,
		   water_metric_volume * (isnull(wi.working_interest,100) / 100) water_metric_volume,
		   water_imperial_volume * (isnull(wi.working_interest,100) / 100) water_imperial_volume,
		   water_boe_volume * (isnull(wi.working_interest,100) / 100) water_boe_volume,
		   water_mcfe_volume * (isnull(wi.working_interest,100) / 100) water_mcfe_volume,
		   hours_on,
		   hours_down,
		   casing_pressure,
		   tubing_pressure,
		   joints_to_fluid,
		   bsw
	FROM [stage].t_stg_prodview_volumes_final pgf
	JOIN (
			SELECT cost_centre, unit_cc_num
			FROM [data_mart].t_dim_entity 
			WHERE is_cc_dim=1 AND unit_cc_num is NOT null
	) ent ON pgf.cc_num = ent.cost_centre
	JOIN [stage].[t_cc_num_working_interest] wi ON ent.unit_cc_num = wi.cc_num 
		AND (pgf.activity_date >= wi.effective_date 
		AND pgf.activity_date < wi.termination_date)

	--SET @rowcnt = @rowcnt + @@ROWCOUNT

	--COMMIT TRANSACTION
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
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		--RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

	END CATCH

	--RETURN @@ERROR