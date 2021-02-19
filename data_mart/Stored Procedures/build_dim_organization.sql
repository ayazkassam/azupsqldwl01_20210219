CREATE PROC [data_mart].[build_dim_organization] @complete_rebuild_flag [varchar](1) AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 IF @complete_rebuild_flag IS NULL OR @complete_rebuild_flag = ''
		SET @complete_rebuild_flag = 'N'
BEGIN TRY
	IF @complete_rebuild_flag = 'Y'
	   
	    BEGIN

		   --  BEGIN TRANSACTION

			truncate table [data_mart].[t_dim_organization];

		   -- COMMIT TRANSACTION

		  END


	--BEGIN TRANSACTION			
	  IF OBJECT_ID('tempdb..#t_dim_organization_MERGE') IS NOT NULL
        DROP TABLE #t_dim_organization_MERGE	 

	 CREATE TABLE #t_dim_organization_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
        AS
	   SELECT
			CASE WHEN trg.organization_id is NULL THEN 'NEW' 
				 ELSE 'UPDATE'
			END Flag
			, src.organization_id					
			, src.organization_type_code			
			, src.organization_name								
			, src.operating_currency_code			
			, src.reporting_currency_code			
			, src.create_date						
			, src.create_user						
			, src.last_update_date					
			, src.last_update_user					
			, src.fiscal_year_end					
			, src.tax_code							
			, src.gst_registration_number			
			, src.termination_date					
			, src.termination_user					
			, src.profile_group_code				
			, src.non_standard_volume_entry_flag	
			, src.self_sustaining_flag				
			, src.admin_cost_centre					
			, src.multi_tier_jib_flag				
			, src.cash_call_draw_down_flag			
			, src.jib_invoice_org_id				
			, src.country_for_taxation				
			, src.is_ba_matching_entry	
		FROM
			 [stage].[v_dim_source_organizations] src
			 LEFT JOIN [data_mart].[t_dim_organization] as trg
					ON (src.organization_id = trg.organization_id)
		EXCEPT
		SELECT
			'UPDATE' Flag
			, trg.organization_id					
			, trg.organization_type_code			
			, trg.organization_name								
			, trg.operating_currency_code			
			, trg.reporting_currency_code			
			, trg.create_date						
			, trg.create_user						
			, trg.last_update_date					
			, trg.last_update_user					
			, trg.fiscal_year_end					
			, trg.tax_code							
			, trg.gst_registration_number			
			, trg.termination_date					
			, trg.termination_user					
			, trg.profile_group_code				
			, trg.non_standard_volume_entry_flag	
			, trg.self_sustaining_flag				
			, trg.admin_cost_centre					
			, trg.multi_tier_jib_flag				
			, trg.cash_call_draw_down_flag			
			, trg.jib_invoice_org_id				
			, trg.country_for_taxation				
			, trg.is_ba_matching_entry	
		FROM [data_mart].[t_dim_organization] as trg
		
		INSERT INTO [data_mart].[t_dim_organization]( 
			  organization_id					
			, organization_type_code			
			, organization_name								
			, operating_currency_code			
			, reporting_currency_code			
			, create_date						
			, create_user						
			, last_update_date					
			, last_update_user					
			, fiscal_year_end					
			, tax_code							
			, gst_registration_number			
			, termination_date					
			, termination_user					
			, profile_group_code				
			, non_standard_volume_entry_flag	
			, self_sustaining_flag				
			, admin_cost_centre					
			, multi_tier_jib_flag				
			, cash_call_draw_down_flag			
			, jib_invoice_org_id				
			, country_for_taxation				
			, is_ba_matching_entry	)
		SELECT
			organization_id					
			, organization_type_code			
			, organization_name								
			, operating_currency_code			
			, reporting_currency_code			
			, create_date						
			, create_user						
			, last_update_date					
			, last_update_user					
			, fiscal_year_end					
			, tax_code							
			, gst_registration_number			
			, termination_date					
			, termination_user					
			, profile_group_code				
			, non_standard_volume_entry_flag	
			, self_sustaining_flag				
			, admin_cost_centre					
			, multi_tier_jib_flag				
			, cash_call_draw_down_flag			
			, jib_invoice_org_id				
			, country_for_taxation				
			, is_ba_matching_entry
		FROM
			#t_dim_organization_MERGE
		WHERE
			flag = 'NEW'

	DECLARE  @rowcnt INT
	  EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	

	UPDATE [data_mart].[t_dim_organization]
	  SET
			  [data_mart].[t_dim_organization].organization_id					  =		src.organization_id
			, [data_mart].[t_dim_organization].organization_type_code			  =		src.organization_type_code
			, [data_mart].[t_dim_organization].organization_name					  =		src.organization_name
			, [data_mart].[t_dim_organization].operating_currency_code			  =		src.operating_currency_code
			, [data_mart].[t_dim_organization].reporting_currency_code			  =		src.reporting_currency_code
			, [data_mart].[t_dim_organization].create_date						  =		src.create_date
			, [data_mart].[t_dim_organization].create_user						  =		src.create_user
			, [data_mart].[t_dim_organization].last_update_date					  =		src.last_update_date
			, [data_mart].[t_dim_organization].last_update_user					  =		src.last_update_user
			, [data_mart].[t_dim_organization].fiscal_year_end					  =		src.fiscal_year_end
			, [data_mart].[t_dim_organization].tax_code							  =		src.tax_code
			, [data_mart].[t_dim_organization].gst_registration_number			  =		src.gst_registration_number
			, [data_mart].[t_dim_organization].termination_date					  =		src.termination_date
			, [data_mart].[t_dim_organization].termination_user					  =		src.termination_user
			, [data_mart].[t_dim_organization].profile_group_code				  =		src.profile_group_code
			, [data_mart].[t_dim_organization].non_standard_volume_entry_flag	  =		src.non_standard_volume_entry_flag
			, [data_mart].[t_dim_organization].self_sustaining_flag				  =		src.self_sustaining_flag
			, [data_mart].[t_dim_organization].admin_cost_centre					  =		src.admin_cost_centre
			, [data_mart].[t_dim_organization].multi_tier_jib_flag				  =		src.multi_tier_jib_flag
			, [data_mart].[t_dim_organization].cash_call_draw_down_flag			  =		src.cash_call_draw_down_flag
			, [data_mart].[t_dim_organization].jib_invoice_org_id				  =		src.jib_invoice_org_id
			, [data_mart].[t_dim_organization].country_for_taxation				  =		src.country_for_taxation
			, [data_mart].[t_dim_organization].is_ba_matching_entry				  =		src.is_ba_matching_entry
	FROM
		 #t_dim_organization_MERGE src
	WHERE
		[data_mart].[t_dim_organization].organization_id = src.organization_id
		and src.Flag = 'UPDATE'
	  --	
      --
	
    --COMMIT TRANSACTION



	IF @complete_rebuild_flag = 'Y'
	    BEGIN

		  -- BEGIN TRANSACTION

		   INSERT INTO [data_mart].[t_dim_organization]
           (	organization_id								
				, organization_name)
		 VALUES
           (-2	
           , 'Missing (-2)' 
			);

			INSERT INTO [data_mart].[t_dim_organization]
			(	organization_id					
				, organization_name)
			VALUES
           (-1 , 'Unknown (-1)');

		   --COMMIT TRANSACTION

		  END
       
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
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)


  END CATCH

 -- RETURN @@ERROR

END