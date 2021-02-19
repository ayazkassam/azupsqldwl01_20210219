CREATE PROC [data_mart_metrix].[full_metrix_fees_facts] AS
BEGIN
	SET NOCOUNT ON;

	begin try
		--begin transaction
			truncate table data_mart_metrix.t_fact_metrix_fees;
		--commit transaction

		--begin transaction
			insert into data_mart_metrix.t_fact_metrix_fees

			select activity_period
				, control_group_id
				, facility_id
				, product_code
				, charge_type_code
				, facility_charge_formula_id
				, charge_sequence_number
				, entityType
				, EntityID
				, expense_cost_centre_code
				, expense_owner_id
				, revenue_cost_centre_code
				, revenue_owner_id
				, expense_doi_sub_used
				, revenue_doi_sub_used
				, expense_value
				, expense_volume
				, expense_volume_imperial
				, expense_volume_boe
				, gst_value
				, pst_value
			from stage_metrix.v_fact_source_metrix_fees;
		
			DECLARE @rowcnt INT
  		    EXEC [dbo].[LastRowCount] @rowcnt OUTPUT	
			SELECT @rowcnt INSERTED

		--commit transaction

	end try
 
	begin catch

		/*-- grab error information from sql functions*/
		declare @errorseverity int	= error_severity()
			,@errornumber int	= error_number()
			,@errormessage nvarchar(4000)	= error_message()
			,@errorstate int = error_state()
		--	,@errorline  int = error_line()
			,@errorproc nvarchar(200) = error_procedure()
				
		/*-- if the error renders the transaction as uncommittable or we have open transactions, rollback*/
		--if @@trancount > 0
		--begin
		--	rollback transaction
		--end
	
		raiserror (@errormessage , @errorseverity, @errorstate, @errornumber)

	end catch

	--return @@error

end