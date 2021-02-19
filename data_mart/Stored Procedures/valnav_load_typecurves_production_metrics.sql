CREATE PROC [data_mart].[valnav_load_typecurves_production_metrics] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Price_Deck varchar(100), @Max_Sort_Key varchar(10)

BEGIN TRY	

    -- Get current Price Deck

    SELECT @Price_Deck = (SELECT distinct price_deck FROM [stage].v_valnav_typecurves_price_deck);

	-- Get Current max sort key

	SELECT @Max_Sort_Key = (SELECT  max(scenario_sort_key) FROM [data_mart].[t_dim_scenario_typecurves]) ;

    /*update the current scenario description with current timestamp*/
	update [data_mart].t_dim_scenario_typecurves
	set scenario_description = scenario_key + ' (Last refreshed - ' + convert(varchar(10),dateadd(hh,-7,getdate()),120) + ')'
	where scenario_key= @Price_Deck ;


    -- Check if new price deck exist, if not then insert

	IF NOT exists (select scenario_key from  [data_mart].t_dim_scenario_typecurves where scenario_key=@Price_Deck) 
		BEGIN 

			--BEGIN TRANSACTION

			INSERT INTO [data_mart].t_dim_scenario_typecurves
			SELECT distinct price_deck scenario_key,
				'Type Curves' scneario_parent_key,
				price_deck + ' (Last refreshed - ' + convert(varchar(10),dateadd(hh,-7,getdate()),120) + ')'  scenario_description,
				'Valnav' scenario_cube_name,
				'+' unary_operator,
				null scenario_formula,
				null scenario_formula_property,
				@Max_Sort_Key + 1 as scenario_sort_key
				-- ROW_NUMBER() OVER(ORDER BY name DESC) as scenario_sort_key
			FROM [stage].v_valnav_typecurves_price_deck 
			--
			UNION ALL
			--
			SELECT distinct cube_child_member + '_' + price_deck scenario_key,
				price_deck scneario_parent_key,
				cube_child_member scenario_description,
				'Valnav' scenario_cube_name,
				'+' unary_operator,
				null scenario_formula,
				null scenario_formula_property,
				@Max_Sort_Key + 1 + ROW_NUMBER() OVER(ORDER BY price_deck DESC) as scenario_sort_key
				-- ROW_NUMBER() OVER(ORDER BY name DESC) as scenario_sort_key
			FROM [stage].v_valnav_typecurves_price_deck ;

		-- COMMIT TRANSACTION

	 END

	 /*insert new scenario into default scenario control if it doesn't exist*/
	IF NOT exists (select scenario_key from stage.t_stg_type_curves_current_scenario where scenario_key=@Price_Deck) 
	begin
		 --begin transaction
		 insert into stage.t_stg_type_curves_current_scenario (scenario_key)
				select distinct scenario_parent_key
				from [data_mart].t_dim_scenario_typecurves
				where scenario_parent_key <> 'Type Curves'
				and scenario_parent_key  is not null
				and not exists (select 1 from stage.t_stg_type_curves_current_scenario s
								where scenario_parent_key = s.scenario_key)

		-- commit transaction
	end


    -- Delete current working scenario records before inserting new ones.
    --BEGIN TRANSACTION
	   DELETE FROM [data_mart].t_fact_valnav_production_typecurves
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
	   
	   INSERT INTO [data_mart].t_fact_valnav_production_typecurves
	   SELECT entity_key,
			  activity_date_key,
			  account_key,
			  reserve_category_id reserve_category_key,
			  scenario_key + '_' + @Price_Deck scenario_key,
			  gross_net_key,
			  normalized_time_key,
			  sum(imperial_volume) imperial_volume,
			  sum(boe_volume) boe_volume,
			  sum(metric_volume) metric_volume,
			  sum(mcfe_volume) mcfe_volume,
			  scenario_type,
			  current_timestamp as last_update_date
	   FROM [stage].v_fact_source_valnav_production_typecurves_final
	   GROUP BY entity_key,
			  activity_date_key,
			  account_key,
			  reserve_category_id,
			  scenario_key,
			  gross_net_key,
			  normalized_time_key,
			  scenario_type;
	
    --	

	--SET @rowcnt = @@ROWCOUNT

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
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)
      

  END CATCH

 -- RETURN @@ERROR

END