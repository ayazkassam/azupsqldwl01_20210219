CREATE PROC [data_mart].[full_ap_ar_open_facts] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @before_count as INT, @after_count as INT

BEGIN TRY	

	/*-- Insert Open AP AR transactions*/
	declare @agingDate int
		, @counter int
		, @TotalCount int
	set @counter = 1

	truncate table [data_mart].t_fact_ap_ar_open

	/*create temp table to determine number of months to calculate  
		-- rolling 15 months ending with the current month end */
	select distinct date_key aging_date
			, row_number() over (order by date_key) as Rnk
	into #months
	from [data_mart].dim_date
	where last_Day_of_Calendar_month_flag='Y'
	and date_key between convert(int,convert(varchar(8),dateadd(m,-14, eomonth(current_timestamp)),112))
		 and convert(int,convert(varchar(8),eomonth(current_timestamp),112))


	set @TotalCount = (select count(*) from #months)	

	/*loop over each month and insert open facts*/
	while @counter <= @TotalCount
	begin
		set @agingDate = (select aging_date from #months where rnk = @counter)

		insert into [data_mart].t_fact_ap_ar_open
		select invc_type_code
			, ba_id
			, invc_id
			, invc_num
			, invoice_date
			, org_id
			, aging_date accounting_month
			, due_date
			, voucher_id
			, voucher_type_code
			, voucher_num
			, sum(cad) cad_open
			, max(invoice_amount) invoice_amount
		from (
			select ba_id
				, aging_date
				, invc_id
				, invc_num
				, invoice_date
				, invc_type_code
				, due_date
				, org_id
				, first_value (voucher_id) over 
					(partition by ba_id, aging_date, invc_id, invc_num, invoice_date,invc_type_code, due_date, org_id 
						order by li_type_code desc) voucher_id
				, first_value (voucher_num) over 
					(partition by ba_id, aging_date, invc_id, invc_num, invoice_date, invc_type_code, due_date, org_id 
						order by li_type_code desc) voucher_num
				, first_value (voucher_type_code) over 
					(partition by ba_id, aging_date, invc_id, invc_num, invoice_date, invc_type_code, due_date, org_id 
						order by li_type_code desc) voucher_type_code
				, cad
				, invoice_amount
			from (
				select invc_type_code
					, ba_id
					, @agingDate aging_date
					, invc_id
					, invc_num
					, invoice_date
					, due_date
					, org_id
					, voucher_id
					, voucher_type_code
					, voucher_num
					, li_type_code
					, cad
					, invoice_amount
				from [data_mart].t_fact_ap_ar aps
				where accounting_month <= @agingDate
			) sd
		) source
		group by ba_id, aging_date, invc_id, invc_num, invoice_date, invc_type_code, due_date, org_id, voucher_id, voucher_num, voucher_type_code
		having sum(cad) <> 0

		set @counter = @counter + 1 
		--SET @rowcnt = @@ROWCOUNT + @rowcnt
	end

	drop table #months


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