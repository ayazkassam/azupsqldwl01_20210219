CREATE PROC [data_mart].[align_entities_to_qbyte_cc] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	
	--BEGIN TRANSACTION

	/*align cost centre names*/
	--update [data_mart].[t_dim_entity]
	--set cost_centre_name = x.cost_centre_name
	--from (	select distinct cost_centre_id as cost_centre
	--		, cost_centre_name
	--	from stage.v_dim_source_entity_cost_centre_hierarchy
	--) x
	--where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	--and x.cost_centre_name <> [data_mart].[t_dim_entity].cost_centre_name
     IF OBJECT_ID('tempdb..#CTE_1') IS NOT NULL
       DROP TABLE #CTE_1	 

     CREATE TABLE #CTE_1 WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
        select 
		  cost_centre_id as cost_centre,
		  cost_centre_name
		from stage.v_dim_source_entity_cost_centre_hierarchy	     
		GROUP BY
		  cost_centre_id,
		  cost_centre_name
	
	update [data_mart].[t_dim_entity]
	set cost_centre_name = x.cost_centre_name
	from #CTE_1 x
	where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	and x.cost_centre_name <> [data_mart].[t_dim_entity].cost_centre_name
	-----------------------------------------------------------------------------------------------

	/*align facility*/
	--update [data_mart].[t_dim_entity]
	--set facility		= x.facility
	--	, facility_name	= x.facility_name
	--	, facility_code	= x.facility_code
	--from (	
	--	select distinct cost_centre_id as cost_centre
	--		, facility
	--		, facility_name
	--		, facility_code
	--	from stage.v_dim_source_entity_cost_centre_hierarchy
	--) x
	--where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	--and x.facility <> [data_mart].[t_dim_entity].facility	

     IF OBJECT_ID('tempdb..#CTE_2') IS NOT NULL
       DROP TABLE #CTE_2	 

     CREATE TABLE #CTE_2 WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
		select 
		  cost_centre_id as cost_centre,
		  facility,
		  facility_name,
		  facility_code
		from stage.v_dim_source_entity_cost_centre_hierarchy     
		GROUP BY
		  cost_centre_id,
		  facility,
		  facility_name,
		  facility_code
	
	update [data_mart].[t_dim_entity]
	set facility		= x.facility
		, facility_name	= x.facility_name
		, facility_code	= x.facility_code
	from #CTE_2 x
	where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	and x.facility <> [data_mart].[t_dim_entity].facility	
	-----------------------------------------------------------------------------------------------

	/*align area*/
	--update [data_mart].[t_dim_entity]
	--set area		= x.area
	--	, area_name	= x.area_name
	--	, area_code	= x.area_code
	--from (	
	--	select distinct cost_centre_id as cost_centre
	--		, area
	--		, area_name
	--		, area_code
	--	from stage.v_dim_source_entity_cost_centre_hierarchy
	--) x
	--where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	--and x.area <> [data_mart].[t_dim_entity].area	

     IF OBJECT_ID('tempdb..#CTE_3') IS NOT NULL
       DROP TABLE #CTE_3	 

     CREATE TABLE #CTE_3 WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
		select 
		  cost_centre_id as cost_centre,
		  area,
		  area_name,
		  area_code
		from stage.v_dim_source_entity_cost_centre_hierarchy   
		GROUP BY
		  cost_centre_id,
		  area,
		  area_name,
		  area_code

	update [data_mart].[t_dim_entity]
	set area		= x.area
		, area_name	= x.area_name
		, area_code	= x.area_code
	from #CTE_3 x
	where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	and x.area <> [data_mart].[t_dim_entity].area	
	-----------------------------------------------------------------------------------------------


	/*align district*/
	--update [data_mart].[t_dim_entity]
	--set district		= x.district
	--	, district_name	= x.district_name
	--	, district_code	= x.district_code
	--from (	
	--	select distinct cost_centre_id as cost_centre
	--		, district
	--		, district_name
	--		, district_code
	--	from stage.v_dim_source_entity_cost_centre_hierarchy
	--) x
	--where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	--and x.district <> [data_mart].[t_dim_entity].district

     IF OBJECT_ID('tempdb..#CTE_4') IS NOT NULL
       DROP TABLE #CTE_4	 

     CREATE TABLE #CTE_4 WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
		select 
		  cost_centre_id as cost_centre,
		  district,
		  district_name,
		  district_code
		from stage.v_dim_source_entity_cost_centre_hierarchy  
		GROUP BY
		  cost_centre_id,
		  district,
		  district_name,
		  district_code

	update [data_mart].[t_dim_entity]
	set district		= x.district
		, district_name	= x.district_name
		, district_code	= x.district_code
	from #CTE_4 x
	where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	and x.district <> [data_mart].[t_dim_entity].district
	-----------------------------------------------------------------------------------------------

	/*align region*/
	--update [data_mart].[t_dim_entity]
	--set region		= x.region
	--	, region_name	= x.region_name
	--	, region_code	= x.region_code
	--from (	
	--	select distinct cost_centre_id as cost_centre
	--		, region
	--		, region_name
	--		, region_code
	--	from stage.v_dim_source_entity_cost_centre_hierarchy
	--) x
	--where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	--and x.region <> [data_mart].[t_dim_entity].region	

     IF OBJECT_ID('tempdb..#CTE_5') IS NOT NULL
       DROP TABLE #CTE_5	 

     CREATE TABLE #CTE_5 WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
		select 
		  cost_centre_id as cost_centre,
		  region,
		  region_name,
		  region_code
		from stage.v_dim_source_entity_cost_centre_hierarchy 
		GROUP BY
		  cost_centre_id,
		  region,
		  region_name,
		  region_code

	update [data_mart].[t_dim_entity]
	set region		= x.region
		, region_name	= x.region_name
		, region_code	= x.region_code
	from #CTE_5 x
	where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	and x.region <> [data_mart].[t_dim_entity].region	
	-----------------------------------------------------------------------------------------------

	/*align unit cost centres*/
	--update [data_mart].[t_dim_entity]
	--set unit_cc_num	 = x.unit_cc_num
	--	, unit_cc_name = x.unit_cc_name
	--from (	
	--	select distinct cost_centre_id as cost_centre
	--		, unit_cc_num
	--		, unit_cc_name
	--	from stage.v_dim_source_entity_cost_centre_hierarchy
	--) x
	--where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	--and x.unit_cc_name <> [data_mart].[t_dim_entity].unit_cc_name

     IF OBJECT_ID('tempdb..#CTE_6') IS NOT NULL
       DROP TABLE #CTE_6	 

     CREATE TABLE #CTE_6 WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
		select 
		  cost_centre_id as cost_centre,
		  unit_cc_num,
		  unit_cc_name
		from stage.v_dim_source_entity_cost_centre_hierarchy
		GROUP BY
		  cost_centre_id,
          unit_cc_num,
		  unit_cc_name

	update [data_mart].[t_dim_entity]
	set unit_cc_num	 = x.unit_cc_num
		, unit_cc_name = x.unit_cc_name
	from #CTE_6 x
	where x.cost_centre  = [data_mart].[t_dim_entity].cost_centre
	and x.unit_cc_name <> [data_mart].[t_dim_entity].unit_cc_name
	-----------------------------------------------------------------------------------------------

	/*align disposition flags*/
	--update [data_mart].[t_dim_entity]
	--set	  disposition_package	 = x.disposition_package
	--	, disposition_type		 = x.disposition_type
	--	, disposition_area		 = x.disposition_area
	--	, disposition_facility	 = x.disposition_facility
	--	, disposed_flag			 = x.disposed_flag
	--from (
	--		select distinct cost_centre_id as cost_centre
	--		, disposition_package
	--		, disposition_type
	--		, disposition_area
	--		, disposition_facility
	--		, disposed_flag
	--	from stage.v_dim_source_entity_cost_centre_hierarchy
	--) x
	--where [data_mart].[t_dim_entity].cost_centre = x.cost_centre
	--and [data_mart].[t_dim_entity].disposed_flag <> x.disposed_flag

     IF OBJECT_ID('tempdb..#CTE_7') IS NOT NULL
       DROP TABLE #CTE_7	 

     CREATE TABLE #CTE_7 WITH (DISTRIBUTION = ROUND_ROBIN)
     AS
		select 
		  cost_centre_id as cost_centre,
		  disposition_package,
		  disposition_type,
		  disposition_area,
		  disposition_facility,
		  disposed_flag
		from stage.v_dim_source_entity_cost_centre_hierarchy
		GROUP BY
		  cost_centre_id,
		  disposition_package,
		  disposition_type,
		  disposition_area,
		  disposition_facility,
		  disposed_flag

	update [data_mart].[t_dim_entity]
	set	  disposition_package	 = x.disposition_package
		, disposition_type		 = x.disposition_type
		, disposition_area		 = x.disposition_area
		, disposition_facility	 = x.disposition_facility
		, disposed_flag			 = x.disposed_flag
	from #CTE_7 x
	where [data_mart].[t_dim_entity].cost_centre = x.cost_centre
	and [data_mart].[t_dim_entity].disposed_flag <> x.disposed_flag
	-----------------------------------------------------------------------------------------------

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
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

  END CATCH

  --RETURN @@ERROR

END