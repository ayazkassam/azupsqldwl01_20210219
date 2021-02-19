CREATE PROC [Stage].[load_t_stg_prodview_volumes_incr] AS
	SET NOCOUNT ON;

	BEGIN TRY

	truncate table [Stage].t_stg_prodview_volumes_final_incr
	BEGIN TRANSACTION
		/*====================================================================================================================*/
		/*					split volumes between Raw Production and Sales Production										  */
		/*====================================================================================================================*/
		insert into [Stage].t_stg_prodview_volumes_final_incr
			/*--GROSS Raw Production*/
		SELECT site_id,
			   uwi,
			   cc_num,
			   activity_date,
			   activity_date_key,
			   'PRODUCTION' data_type,
			   'Production_PV' scenario_key,
			   1 gross_net_key,
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
		FROM stage.v_stg_prodview_volumes_incr		

	
		insert into [Stage].t_stg_prodview_volumes_final_incr
			/*-- GROSS Sales Production*/
		SELECT site_id,
			   uwi,
			   cc_num,
			   activity_date,
			   activity_date_key,
			   'SALES_EST' data_type,
			   'Sales_Est_PV' scenario_key,
			   1 gross_net_key,
			   gas_sales_metric_volume,
			   gas_sales_imperial_volume,
			   gas_sales_boe_volume,
			   gas_sales_mcfe_volume,
			   oil_sales_metric_volume,
			   oil_sales_imperial_volume,
			   oil_sales_boe_volume,
			   oil_sales_mcfe_volume,
			   ethane_sales_metric_volume,
			   ethane_sales_imperial_volume,
			   ethane_sales_boe_volume,
			   ethane_sales_mcfe_volume,
			   propane_sales_metric_volume,
			   propane_sales_imperial_volume,
			   propane_sales_boe_volume,
			   propane_sales_mcfe_volume,
			   butane_sales_metric_volume,
			   butane_sales_imperial_volume,
			   butane_sales_boe_volume,
			   butane_sales_mcfe_volume,
			   pentane_sales_metric_volume,
			   pentane_sales_imperial_volume,
			   pentane_sales_boe_volume,
			   pentane_sales_mcfe_volume,
			   condensate_sales_metric_volume,
			   condensate_sales_imperial_volume,
			   condensate_sales_boe_volume,
			   condensate_sales_mcfe_volume,
			   total_ngl_sales_metric_volume,
			   total_ngl_sales_imperial_volume,
			   total_ngl_sales_boe_volume,
			   total_ngl_sales_mcfe_volume,
			   isnull(oil_sales_metric_volume,0) +  isnull(total_ngl_sales_metric_volume,0) total_liquid_metric_volume,
			   isnull(oil_sales_imperial_volume,0) +  isnull(total_ngl_sales_imperial_volume,0) total_liquid_imperial_volume,
			   isnull(oil_sales_boe_volume,0) + isnull(total_ngl_sales_boe_volume,0) total_liquid_boe_volume,
			   isnull(oil_sales_mcfe_volume,0) +  isnull(total_ngl_sales_mcfe_volume,0) total_liquid_mcfe_volume,
			   isnull(gas_sales_boe_volume,0) + isnull(oil_sales_boe_volume,0) + isnull(total_ngl_sales_boe_volume,0) total_boe_volume,
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
		FROM stage.v_stg_prodview_volumes_incr

		select count(*) INSERTED from [Stage].t_stg_prodview_volumes_final_incr


	COMMIT TRANSACTION

	END TRY
 
	BEGIN CATCH
        
		/*-- Grab error information from SQL functions*/
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
				--,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		/*-- If the error renders the transaction as uncommittable or we have open transactions, rollback*/
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)
	END CATCH

	--RETURN @@ERROR