CREATE PROC [data_mart].[build_prodview_downtime_scenario] @complete_rebuild_flag [varchar](1) AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	


	
    IF @complete_rebuild_flag IS NULL OR @complete_rebuild_flag = ''
		SET @complete_rebuild_flag = 'N'

	IF @complete_rebuild_flag = 'Y'
		truncate table [data_mart].[t_dim_scenario_fdc_downtime];



	IF OBJECT_ID('tempdb..#t_dim_scenario_fdc_downtime_MERGE') IS NOT NULL
		DROP TABLE #t_dim_scenario_fdc_downtime_MERGE
			
	CREATE TABLE #t_dim_scenario_fdc_downtime_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
    AS
		SELECT
  		  DISTINCT
			 CASE WHEN trg.scenario_id is NULL THEN 'NEW' 
					 ELSE 'UPDATE'
				END Flag,
	          codedowntm1 scenario_id,
			   null scenario_desc
		FROM  [stage_prodview].[t_pvt_pvunitcompdowntm] Src
				LEFT JOIN [data_mart].[t_dim_scenario_fdc_downtime] trg
				ON (trg.scenario_id    = src.codedowntm1)
		WHERE codedowntm1 IS NOT NULL
		EXCEPT
		SELECT 'UPDATE' Flag,
				scenario_id,
				scenario_desc
		FROM
			[data_mart].[t_dim_scenario_fdc_downtime]
	
	UPDATE [data_mart].[t_dim_scenario_fdc_downtime]
	SET [data_mart].[t_dim_scenario_fdc_downtime].[scenario_desc] = src.[scenario_desc]
	FROM
		#t_dim_scenario_fdc_downtime_MERGE src
	WHERE
		src.scenario_id = [data_mart].[t_dim_scenario_fdc_downtime].scenario_id
		and src.Flag = 'UPDATE'

	DECLARE @max_scenario_key int  = COALESCE((select max(scenario_key) from [data_mart].[t_dim_scenario_fdc_downtime]), 0)
	INSERT INTO [data_mart].[t_dim_scenario_fdc_downtime] (scenario_key, scenario_id, scenario_desc)
	SELECT
		@max_scenario_key + ROW_NUMBER() OVER(ORDER BY scenario_id) scenario_key,
		scenario_id,
		scenario_desc
	FROM
		#t_dim_scenario_fdc_downtime_MERGE src
	WHERE
		src.Flag = 'NEW'

	
	IF OBJECT_ID('tempdb..#t_dim_scenario_MERGE') IS NOT NULL
		DROP TABLE #t_dim_scenario_MERGE
			
	CREATE TABLE #t_dim_scenario_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
    AS
		SELECT
  		  DISTINCT
			 CASE WHEN trg.scenario_key is NULL THEN 'NEW' 
					 ELSE 'UPDATE'
				END Flag,
				scenario_id scenario_key,
				'Downtime' scenario_parent_key,
				scenario_id scenario_description,
				'Volumes' scenario_cube_name,
				'+' unary_operator,
				null scenario_formula,
				null scenario_formula_property,
				src.scenario_key scenario_sort_key
		FROM [data_mart].[t_dim_scenario_fdc_downtime] src
			LEFT JOIN [data_mart].[t_dim_scenario] trg
		ON (trg.scenario_key    = src.scenario_id)
		EXCEPT
		SELECT 'UPDATE' Flag,
				scenario_key,
				scenario_parent_key,
				scenario_description,
				scenario_cube_name,
				unary_operator,
				scenario_formula,
				scenario_formula_property,
				scenario_sort_key
		FROM
			[data_mart].[t_dim_scenario]
	
	UPDATE [data_mart].[t_dim_scenario]
	SET
		[data_mart].[t_dim_scenario].scenario_parent_key        =   src.scenario_parent_key,
		[data_mart].[t_dim_scenario].scenario_description       =   src.scenario_description,
		[data_mart].[t_dim_scenario].scenario_cube_name         =   src.scenario_cube_name,
		[data_mart].[t_dim_scenario].unary_operator				=   src.unary_operator,
		[data_mart].[t_dim_scenario].scenario_formula			=   src.scenario_formula,
		[data_mart].[t_dim_scenario].scenario_formula_property  =   src.scenario_formula_property,
		[data_mart].[t_dim_scenario].scenario_sort_key			=   src.scenario_sort_key
	FROM
		#t_dim_scenario_MERGE src
	WHERE
		src.scenario_key = [data_mart].[t_dim_scenario].scenario_key
		AND Flag = 'UPDATE'

	INSERT INTO [data_mart].[t_dim_scenario] (scenario_parent_key, scenario_description, scenario_cube_name,
											  unary_operator, scenario_formula, scenario_formula_property,
											  scenario_sort_key)
	SELECT
		scenario_parent_key, scenario_description, scenario_cube_name,
		unary_operator, scenario_formula, scenario_formula_property,
		scenario_sort_key
	FROM
		#t_dim_scenario_MERGE
	WHERE
		Flag = 'INSERT'
	
	SELECT 1
  
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