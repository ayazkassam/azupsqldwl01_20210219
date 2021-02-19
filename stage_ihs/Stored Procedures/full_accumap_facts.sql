CREATE PROC [stage_ihs].[full_accumap_facts] AS
begin
	SET NOCOUNT ON;

	BEGIN TRY

	--BEGIN TRANSACTION
		truncate table [stage_ihs].t_fact_accumap
	--COMMIT TRANSACTION
		
	--BEGIN TRANSACTION	
		insert into [stage_ihs].t_fact_accumap

		select f.uwi
			, f.activity_date
			, isnull(convert(int,convert(varchar(8),w.On_Production_Date,112)),-1) on_prod_date_key
			, isnull(convert(int,convert(varchar(8),w.Spud_Date,112)),-1) spud_date_key
			, isnull(convert(int,convert(varchar(8),w.Rig_Release,112)),-1) rig_release_date_key
			, w.License_Number
			, w.operator
			, case when w.On_Production_Date is null then '-1'
				else case when isnull(f.activity_date,-1) in (-1,-2) then '-1'
						else case when datediff(mm,w.On_Production_Date, convert(date,convert(varchar(10),f.activity_date)))+1 >= cev.production_months_on_cutoff
									or datediff(mm,w.On_Production_Date, convert(date,convert(varchar(10),f.activity_date)))+1 <= 0 then '-1'
								else concat(right(concat('0',datediff(mm,w.On_Production_Date, convert(date,convert(varchar(10),f.activity_date)))+1),2),'.01')
				end end end as normalized_days_key

			, gas gas_metric_volume
			, gas * isnull(cf.gas_si_to_imp_conv_factor,1) gas_imperial_volume
			, gas * isnull(cf.gas_boe_thermal,1) gas_boe_volume
			, gas * isnull(cf.gas_si_to_imp_conv_factor,1) * isnull(cf.gas_mcfe6_thermal,1) gas_mcfe_volume

			, oil oil_metric_volume
			, oil * isnull(cf.liquid_si_to_imp_conv_factor,1) oil_imperial_volume
			, oil * isnull(cf.liquid_boe_thermal,1) oil_boe_volume
			, oil * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6) oil_mcfe_volume

			, cond condensate_metric_volume
			, cond * isnull(cf.liquid_si_to_imp_conv_factor,1) condensate_imperial_volume
			, cond * isnull(cf.liquid_boe_thermal,1) condensate_boe_volume
			, cond * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6) condensate_mcfe_volume

			, water water_metric_volume
			, water * isnull(cf.liquid_si_to_imp_conv_factor,1) water_imperial_volume
			, water * isnull(cf.liquid_boe_thermal,1) water_boe_volume
			, water * isnull(cf.liquid_si_to_imp_conv_factor,1) * isnull(cf.liquid_mcfe6_thermal,6) water_mcfe_volume

			, (isnull(cond,0) * isnull(cf.liquid_boe_thermal,1)) 
				+ (isnull(oil,0) * isnull(cf.liquid_boe_thermal,1)) 
				+ (isnull(gas,0) * isnull(cf.gas_boe_thermal,1)) total_boe_volume
			, p_hours
			, case when f.activity_date not in ('-1','-2') 
					then day(cast(cast(f.activity_date as varchar(8)) as datetime)) else 1 end as day_counter
			, cast(case when f.activity_date not in ('-1','-2') 
					then coalesce(p_hours,0) / 24 else 1 end as numeric(8,2))  as prodmth_day_counter
		from (
			select uwi
				, convert(int,convert(varchar(8),date,112)) activity_date
				, sum(oil) oil
				, sum(gas) gas
				, sum(water) water
				, sum(cond) cond
				, sum(p_hour) p_hours
			from stage_ihs.t_fact_source_accumap_volumes
			group by uwi, Date
		) f
		join [stage_ihs].v_dim_accumap_wells w on f.uwi = w.Bottom_Hole_Location
			, stage.t_ctrl_qbyte_conversion_factors cf
			, (	select int_value production_months_on_cutoff
				from stage.t_ctrl_etl_variables
				where variable_name='PRODUCTION_MONTHS_ON_CUTOFF') cev

	--SET @rowcnt = @@ROWCOUNT

	--COMMIT TRANSACTION
	SELECT 1 Inserted
	END TRY
 
	BEGIN CATCH
        
		/*-- Grab error information from SQL functions*/
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
			,@ErrorNumber INT	= ERROR_NUMBER()
			,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
			,@ErrorState INT = ERROR_STATE()
		--	,@ErrorLine  INT = ERROR_LINE()
			,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		/*-- If the error renders the transaction as uncommittable or we have open transactions, rollback*/
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

	END CATCH

END