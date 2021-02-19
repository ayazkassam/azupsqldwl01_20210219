CREATE PROC [data_mart].[build_dim_entity_valnav_GLJ] AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY	

 	--BEGIN TRANSACTION
	/*-- Merge Valnav Guid/Entity hierarchy/attributes from [stage].[dbo].[v_dim_source_entity_valnav_entities_GLJ] */
      IF OBJECT_ID('tempdb..#dim_entity_valnav_GLJ_MERGE') IS NOT NULL
        DROP TABLE #dim_entity_valnav_GLJ_MERGE	 

      CREATE TABLE #dim_entity_valnav_GLJ_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
		  SELECT
	        'NEW' Flag,		    
            s.entity_guid, 
			s.entity_name, 
			s.cost_centre, 
			s.cost_centre_name, 
			s.unit_cc_num, 
			s.unit_cc_name, 
			s.corp, 
			s.corp_name,
			s.facility, 
			s.facility_name, 
			s.facility_code, 
			s.area, 
			s.area_name, 
			s.area_code, 
			s.district, 
			s.district_name, 
			s.district_code,
			s.region, 
			s.region_name, 
			s.region_code, 
			s.province, 
			s.op_nonop, 
			s.cgu, 
			s.budget_group,
			s.year_end_reserves_property, 
			s.formatted_uwi, 
			s.uwi, 
			'Valnav'  entity_source,
			0  is_cc_dim,
			1  is_valnav
          FROM 
		    [stage].[v_dim_source_entity_valnav_entities_GLJ] s
	      LEFT JOIN [data_mart].[t_dim_entity] t
	        ON t.entity_key = s.entity_guid
          WHERE
	        t.entity_key IS NULL

          UNION ALL

		  SELECT
	        'UPDATE' Flag,		    
            s.entity_guid, 
			s.entity_name, 
			s.cost_centre, 
			s.cost_centre_name, 
			s.unit_cc_num, 
			s.unit_cc_name, 
			s.corp, 
			s.corp_name,
			s.facility, 
			s.facility_name, 
			s.facility_code, 
			s.area, 
			s.area_name, 
			s.area_code, 
			s.district, 
			s.district_name, 
			s.district_code,
			s.region, 
			s.region_name, 
			s.region_code, 
			s.province, 
			s.op_nonop, 
			s.cgu, 
			s.budget_group,
			s.year_end_reserves_property, 
			s.formatted_uwi, 
			s.uwi, 
			'Valnav'  entity_source,
			0  is_cc_dim,
			1  is_valnav
          FROM
		    (
		       SELECT  
                 s.entity_guid, 
			     s.entity_name, 
			     s.cost_centre, 
			     s.cost_centre_name, 
			     s.unit_cc_num, 
			     s.unit_cc_name, 
			     s.corp, 
			     s.corp_name,
			     s.facility, 
			     s.facility_name, 
			     s.facility_code, 
			     s.area, 
			     s.area_name, 
			     s.area_code, 
			     s.district, 
			     s.district_name, 
			     s.district_code,
			     s.region, 
			     s.region_name, 
			     s.region_code, 
			     s.province, 
			     s.op_nonop, 
			     s.cgu, 
			     s.budget_group,
			     s.year_end_reserves_property, 
			     s.formatted_uwi, 
			     s.uwi
               FROM 
		         [stage].[v_dim_source_entity_valnav_entities_GLJ] s
	           INNER JOIN [data_mart].[t_dim_entity] t
	             ON t.entity_key = s.entity_guid

               EXCEPT

	           SELECT  
                 t.entity_key entity_guid, 
			     t.entity_name, 
			     t.cost_centre, 
			     t.cost_centre_name, 
			     t.unit_cc_num, 
			     t.unit_cc_name, 
			     t.corp, 
			     t.corp_name,
			     t.facility, 
			     t.facility_name, 
			     t.facility_code, 
			     t.area, 
			     t.area_name, 
			     t.area_code, 
			     t.district, 
			     t.district_name, 
			     t.district_code,
			     t.region, 
			     t.region_name, 
			     t.region_code, 
			     t.province, 
			     t.op_nonop, 
			     t.cgu, 
			     t.budget_group,
			     t.year_end_reserves_property, 
			     t.formatted_uwi, 
			     t.uwi
               FROM [data_mart].[t_dim_entity] t
			) s

	  INSERT INTO [data_mart].[t_dim_entity]
	    (
		  entity_key, 
		  entity_name, 
		  cost_centre, 
		  cost_centre_name, 
		  unit_cc_num, 
		  unit_cc_name, 
		  corp, 
		  corp_name,
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
		  budget_group,
		  year_end_reserves_property, 
		  formatted_uwi, 
		  uwi, 
		  entity_source, 
		  is_cc_dim, 
		  is_valnav
		)

		SELECT
		  entity_guid, 
		  entity_name, 
		  cost_centre, 
		  cost_centre_name, 
		  unit_cc_num, 
		  unit_cc_name, 
		  corp, 
		  corp_name,
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
		  budget_group,
		  year_end_reserves_property, 
		  formatted_uwi, 
		  uwi, 
		  entity_source, 
		  is_cc_dim, 
		  is_valnav
		FROM
		  #dim_entity_valnav_GLJ_MERGE
        WHERE
	      Flag = 'New'

	  ------ ROW_COUNT
	  DECLARE  @rowcnt INT
	  EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	  UPDATE [data_mart].[t_dim_entity]
      SET
		  [t_dim_entity].entity_key					= UPD.entity_guid
		, [t_dim_entity].entity_name				= UPD.entity_name
		, [t_dim_entity].cost_centre				= UPD.cost_centre
		, [t_dim_entity].cost_centre_name			= UPD.cost_centre_name
		, [t_dim_entity].unit_cc_num				= UPD.unit_cc_num
		, [t_dim_entity].unit_cc_name				= UPD.unit_cc_name
		, [t_dim_entity].corp						= UPD.corp
		, [t_dim_entity].corp_name					= UPD.corp_name
		, [t_dim_entity].facility					= UPD.facility
		, [t_dim_entity].facility_name				= UPD.facility_name
		, [t_dim_entity].facility_code				= UPD.facility_code
		, [t_dim_entity].area						= UPD.area
		, [t_dim_entity].area_name					= UPD.area_name
		, [t_dim_entity].area_code					= UPD.area_code
		, [t_dim_entity].district					= UPD.district
		, [t_dim_entity].district_name				= UPD.district_name
		, [t_dim_entity].district_code				= UPD.district_code
		, [t_dim_entity].region						= UPD.region
		, [t_dim_entity].region_name				= UPD.region_name
		, [t_dim_entity].region_code				= UPD.region_code
		, [t_dim_entity].province					= UPD.province
		, [t_dim_entity].op_nonop					= UPD.op_nonop
		, [t_dim_entity].cgu						= UPD.cgu
		, [t_dim_entity].budget_group				= UPD.budget_group
		, [t_dim_entity].year_end_reserves_property	= UPD.year_end_reserves_property
		, [t_dim_entity].formatted_uwi				= UPD.formatted_uwi
		, [t_dim_entity].uwi						= UPD.uwi
		, [t_dim_entity].entity_source				= UPD.entity_source
		, [t_dim_entity].is_cc_dim					= UPD.is_cc_dim
		, [t_dim_entity].is_valnav					= UPD.is_valnav		
      FROM #dim_entity_valnav_GLJ_MERGE UPD
      WHERE 
        [data_mart].[t_dim_entity].entity_key = UPD.entity_guid AND
	    UPD.Flag = 'UPDATE'	

	--COMMIT TRANSACTION
      SELECT @rowcnt INSERTED
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
--  RETURN @@ERROR

END