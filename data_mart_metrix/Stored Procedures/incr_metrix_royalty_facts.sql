CREATE PROC [data_mart_metrix].[incr_metrix_royalty_facts] AS
BEGIN
	SET NOCOUNT ON;

	begin try
		--begin transaction
			/*delete current month transactions from fact table*/
			delete from data_mart_metrix.t_fact_metrix_royalty
			where activity_period > (select VARIABLE_VALUE from stage_metrix.t_ctrl_metrix_etl_variables where VARIABLE_NAME = 'current month')
	--	commit transaction

		begin transaction
			/*insert current month sales facts*/
			insert into data_mart_metrix.t_fact_metrix_royalty
			select activity_period
				, royalty_owner_id
				, product
				, Royalty_Type
				, payment_type
				, control_group_id
				, royalty_payor
				, well_tract_id
				, battery_facility_id
				, royalty_obligation_id
				, royalty_value
				, royalty_volumes_metric
				, royalty_volume_imperial
				, royalty_volume_boe
			from stage_metrix.v_fact_source_metrix_royalty_incr;
		
			--SET @rowcnt = @@ROWCOUNT

		commit transaction

	end try
 
	begin catch

		/*-- grab error information from sql functions*/
		declare @errorseverity int	= error_severity()
			,@errornumber int	= error_number()
			,@errormessage nvarchar(4000)	= error_message()
			,@errorstate int = error_state()
			--,@errorline  int = error_line()
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