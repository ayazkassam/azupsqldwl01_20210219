CREATE PROC [data_mart].[valnav_load_typecurves_reserves_metrics] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Price_Deck varchar(100)

BEGIN TRY	

	 -- Get current Price Deck

    SELECT @Price_Deck = (SELECT distinct price_deck FROM [stage].v_valnav_typecurves_price_deck);


    -- Delete current working scenario records before inserting new ones.
   -- BEGIN TRANSACTION
	   DELETE FROM [data_mart].t_fact_valnav_reserves_typecurves
       WHERE
             scenario_key IN (SELECT
                                 DISTINCT
                                          cube_child_member + '_' + @Price_Deck
                                     FROM
                                          [stage].t_ctrl_valnav_etl_variables
                                    WHERE
                                          variable_name = 'TYPE_CURVES_BUDGET_YEAR'
                        );

	--COMMIT TRANSACTION

	--
	--BEGIN TRANSACTION

	-- Insert New Transactions 
	   
	   INSERT INTO [data_mart].t_fact_valnav_reserves_typecurves
	   SELECT entity_key,
			  activity_date_key,
			  account_key,
			  reserve_category_key,
			  scenario_key + '_' + @Price_Deck scenario_key,
			  gross_net_key,
			  normalized_time_key,
			  sum(imperial_volume) imperial_volume,
			  sum(boe_volume) boe_volume,
			  sum(metric_volume) metric_volume,
			  sum(mcfe_volume) mcfe_volume,
			  scenario_type,
			  current_timestamp as last_update_date
	   FROM [stage].v_fact_source_valnav_reserves_typecurves_final
	   GROUP BY entity_key,
			  activity_date_key,
			  account_key,
			  reserve_category_key,
			  scenario_key,
			  gross_net_key,
			  normalized_time_key,
			  scenario_type;
	
    --	

	--SET @rowcnt = @@ROWCOUNT
	SELECT 1
	--COMMIT TRANSACTION



   
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