CREATE PROC [data_mart_metrix].[build_dim_well] AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

	--BEGIN TRANSACTION
		truncate table [data_mart_metrix].[t_dim_well]
	--COMMIT TRANSACTION

	BEGIN TRANSACTION
		
	insert into [data_mart_metrix].[t_dim_well]

    SELECT [Well_Tract_Sys_ID]
		, [Well_Tract_ID]
		, [Well_Tract_Type_Code]
		, [Well_Tract_Type]
		, [Well_Tract_Province]
		, [Well_Tract_Name]
		, [Cost_Centre_Code]
		, [Unique_Identifier]
		, [UWI]
		, [Formatted_UWI]
		, [Production_Status]
		, [Primary_Product]
		, [Well_Facility_id]
		, [Well_PA_Responsible_User_ID]
		, [Well_PA_Responsible_User]
		, [cost_centre_name]
		, [corp]
		, [corp_name]
		, [region]
		, [region_name]
		, [region_code]
		, [district]
		, [district_name]
		, [district_code]
		, [area]
		, [area_name]
		, [area_code]
		, [facility]
		, [facility_name]
		, [facility_code]
		, [cc_type]
		, [cc_type_code]
		, Report_Liquid_as_Condensate
		, Unit_ID
		, Unit_Name
		, Unit_Province
		, Unit_Govt_Code
		, Unit_Cost_Centre_Code
		, spud_date
		, rig_release_date
		, on_production_date
		, create_date
		, cc_term_date
		, cgu
		, current_reserves_property
		, year_end_reserves_property
		, [disposition_package]
		, [Royalty_Entity_ID]
		, [Oil_Royalty_Entity_ID]
		, [Reserve_Code]
		, crown_royalty_percent
		, freehold_royalty_percent
		, federal_percent
		, acquired_from
    FROM [stage_metrix].[v_dim_source_metrix_well_tracts]

	--SET @rowcnt = @@ROWCOUNT

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
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		--RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

	END CATCH

	--RETURN @@ERROR
END