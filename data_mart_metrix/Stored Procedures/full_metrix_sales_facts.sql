CREATE PROC [data_mart_metrix].[full_metrix_sales_facts] AS
BEGIN
	SET NOCOUNT ON;

	begin try
		--begin transaction
			truncate table data_mart_metrix.t_fact_metrix;
		--commit transaction

		begin transaction
			insert into data_mart_metrix.t_fact_metrix
			select activity_period
				, purchaser_id
				, product
				, sales_type
				, sales_tik
				, control_group_id
				, owner_id
				, well_tract_id
				, battery_id
				, source_facility_id
				, target_facility_id
				, purchaser_sequence
				, delivery_sequence
				, royalty_payor
				, ar_contract
				, sales_value
				, sales_volume
				, sales_volume_imperial
				, sales_volume_boe
				, sales_value_net_of_transport
				, actual_gigajoules
				, opening_inventory
				, transfer_received
				, production_volume
				, transfer_sent
				, closing_inventory
			from stage_metrix.v_fact_source_metrix_sales;
		
		--	SET @rowcnt = @@ROWCOUNT

		commit transaction

		begin transaction
			insert into data_mart_metrix.t_fact_metrix
			select activity_period
				, purchaser_id
				, product
				, sales_type
				, sales_tik
				, control_group_id
				, owner_id
				, well_tract_id
				, battery_id
				, source_facility_id
				, target_facility_id
				, purchaser_sequence
				, delivery_sequence
				, royalty_payor
				, ar_contract
				, sales_value
				, sales_volume
				, sales_volume_imperial
				, sales_volume_boe
				, sales_value_net_of_transport
				, actual_gigajoules
				, opening_inventory
				, transfer_received
				, production_volume
				, transfer_sent
				, closing_inventory
			from stage_metrix.v_fact_source_metrix_nonop_sales;

			--SET @rowcnt = @rowcnt + @@ROWCOUNT
		commit transaction

		begin transaction
			insert into data_mart_metrix.t_fact_metrix
			select activity_period
				, purchaser_id
				, product
				, sales_type
				, sales_tik
				, control_group_id
				, owner_id
				, well_tract_id
				, battery_id
				, source_facility_id
				, target_facility_id
				, purchaser_sequence
				, delivery_sequence
				, royalty_payor
				, ar_contract
				, sales_value
				, sales_volume
				, sales_volume_imperial
				, sales_volume_boe
				, sales_value_net_of_transport
				, actual_gigajoules
				, opening_inventory
				, transfer_received
				, production_volume
				, transfer_sent
				, closing_inventory
			from stage_metrix.v_fact_source_metrix_inventories;

			--SET @rowcnt = @rowcnt + @@ROWCOUNT
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