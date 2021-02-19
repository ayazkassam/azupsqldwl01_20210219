CREATE PROC [data_mart].[valnav_archive_basedecline_data] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY	
    
	
	-- Archvive Production data    
	  BEGIN TRANSACTION
	            
      UPDATE [data_mart].t_fact_valnav_production
         SET scenario_key =
                (SELECT DISTINCT archive_scenario
                   FROM [stage].t_ctrl_valnav_etl_variables ct
                  WHERE LTRIM(RTRIM(archive_scenario)) IS NOT NULL
                        AND [data_mart].t_fact_valnav_production.scenario_key = ct.cube_child_member
						AND ct.variable_name='BASE_DECLINE_BASE_GROUP')
       WHERE EXISTS
                (SELECT 1
                   FROM [stage].t_ctrl_valnav_etl_variables ev
                  WHERE LTRIM(RTRIM (archive_scenario)) IS NOT NULL
                  AND [data_mart].t_fact_valnav_production.scenario_key = ev.cube_child_member
				  AND ev.variable_name='BASE_DECLINE_BASE_GROUP');
      --
      COMMIT TRANSACTION
      --
     
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

  --RETURN @@ERROR

END