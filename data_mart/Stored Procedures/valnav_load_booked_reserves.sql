CREATE PROC [data_mart].[valnav_load_booked_reserves] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY	
    
	-- Truncate reserves staging table for master information for booked reserves

	TRUNCATE TABLE [stage].t_valnav_xls_reserves_uwis

    -- Insert new reserves staging table records for master information for booked reserves

    --BEGIN TRANSACTION

	   INSERT INTO [stage].t_valnav_xls_reserves_uwis
	   SELECT entity_guid,
		      uwi,
			  formatted_uwi,
			  cc_num,
			  year_end_reserves_property
	   FROM [stage].v_valnav_xls_reserves_uwis;

	--COMMIT TRANSACTION

	--
	--BEGIN TRANSACTION

	--Load net new members that don't currently exist - create new guids / keys
	 INSERT INTO [data_mart].t_dim_entity 
	 (entity_key,
	  entity_name,
	  uwi,
	  formatted_uwi,
	  cost_centre,
	  cost_centre_name,
	  unit_cc_num,
	  unit_cc_name,
	  facility,
	  facility_name,
	  facility_code,
	  area,
	  area_name,
	  area_code,
	  district,
	  district_name,
	  district_code,
	  region,
	  region_name,
	  region_code,
	  op_nonop,
	  province,
	  cgu,
	  budget_group,
	  year_end_reserves_property,
	  is_valnav
	  )
	 SELECT --xs.entity_guid,
	   NEWID() AS entity_key,
	   xs.formatted_uwi entity_name,
	   xs.formatted_uwi uwi,
	   xs.formatted_uwi,
	   xs.cc_num cost_centre,
	   cc.cost_centre_name,
	   cc.unit_cc_num,
	   cc.unit_cc_name,
	   cc.facility,
	   cc.facility_name,
	   cc.facility_code,
	   cc.area,
	   cc.area_name,
	   cc.area_code,
	   cc.district,
	   cc.district_name,
	   cc.district_code,
	   cc.region,
	   cc.region_name,
	   cc.region_code,
	   cc.op_nonop,
	   cc.province,
	   cc.cgu,
	   cc.budget_group,
	   xs.year_end_reserves_property,
	   1 is_valnav
	FROM [stage].[t_valnav_xls_reserves_uwis] xs
	LEFT OUTER JOIN
     (SELECT DISTINCT cost_centre,
				      cost_centre_name,
					  --FIRST_VALUE(uwi) OVER (PARTITION BY cost_centre ORDER BY cost_centre) uwi,
					  --uwi,
					  --formatted_uwi,
					  unit_cc_num,
					  unit_cc_name,
					  facility,
					  facility_name,
					  facility_code,
					  area,
					  area_name,
					  area_code,
					  district,
					  district_name,
					  district_code,
					  region,
					  region_name,
					  region_code,
					  province,
					  op_nonop,
					  cgu,
					  budget_group
			FROM [data_mart].t_dim_entity
			WHERE is_cc_dim =1
			AND cost_centre IS NOT NULL
			) cc
	ON xs.cc_num = cc.cost_centre
	WHERE xs.entity_guid IS NULL;
	
    --	

	--SET @rowcnt = @@ROWCOUNT

	--COMMIT TRANSACTION


	-- Delete existing xls reserves facts (if any) before inserting new ones
	
	--BEGIN TRANSACTION 

      DELETE [data_mart].t_fact_valnav_reserves_xls
       WHERE scenario_key IN
                (SELECT DISTINCT variable_value
                   FROM [stage].t_ctrl_valnav_etl_variables
                  WHERE VARIABLE_NAME IN ('XLS_RESERVES_CUBE_SCENARIO_VOLUMES'));

   -- COMMIT TRANSACTION


	 -- Insert xls (booked) reserves
	 --BEGIN TRANSACTION 

	 INSERT INTO [data_mart].t_fact_valnav_reserves_xls
	 SELECT entity_key,
			activity_date_key,
			account_key,
			reserve_category_key,
			scenario_key,
			gross_net_key,
			normalized_time_key,
			sum(imperial_volume) imperial_volume,
			sum(boe_volume) boe_volume,
			sum(metric_volume) metric_volume,
			sum(mcfe_volume) mcfe_volume,
			scenario_type,
			CURRENT_TIMESTAMP last_update_date
	 FROM [stage].v_fact_source_valnav_reserves_xls
	 GROUP BY entity_key,
			activity_date_key,
			account_key,
			reserve_category_key,
			scenario_key,
			gross_net_key,
			normalized_time_key,
			scenario_type;

	--SET @rowcnt = @@ROWCOUNT

	--COMMIT TRANSACTION


	-- Delete existing xls financial facts (if any) before inserting new ones
	--BEGIN TRANSACTION 

      DELETE [data_mart].t_fact_valnav_financial_xls
       WHERE scenario_key IN
                (SELECT DISTINCT variable_value
                   FROM [stage].t_ctrl_valnav_etl_variables
                  WHERE VARIABLE_NAME IN ('XLS_RESERVES_CUBE_SCENARIO'));

   -- COMMIT TRANSACTION


	-- Insert Financial records
	--BEGIN TRANSACTION 
--
	 INSERT INTO [data_mart].t_fact_valnav_financial_xls
	 SELECT entity_key,
			activity_date_key,
			account_key,
			reserve_category_key,
			scenario_key,
			gross_net_key,
			normalized_time_key,
			sum(cad) cad,
			sum(k_cad) k_cad,
			scenario_type,
			CURRENT_TIMESTAMP last_update_date
	 FROM [stage].v_fact_source_valnav_financial_xls
	 GROUP BY entity_key,
			activity_date_key,
			account_key,
			reserve_category_key,
			scenario_key,
			gross_net_key,
			normalized_time_key,
			scenario_type;

	--COMMIT TRANSACTION


	 -- Year End Reseve Property update
	--BEGIN TRANSACTION

	 	
      UPDATE [data_mart].t_dim_entity 
         SET year_end_reserves_property =
                (SELECT DISTINCT rx.year_end_reserves_property
                   FROM [stage].t_valnav_xls_reserves_uwis rx
                  WHERE rx.cc_num = [data_mart].t_dim_entity.cost_centre)
       WHERE EXISTS
                (SELECT 1
                   FROM  [stage].t_valnav_xls_reserves_uwis r
                  WHERE [data_mart].t_dim_entity.cost_centre = r.cc_num);
      --
    --COMMIT TRANSACTION

	 
   
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

  --RETURN @@ERROR

END