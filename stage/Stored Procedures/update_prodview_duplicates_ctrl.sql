CREATE PROC [Stage].[update_prodview_duplicates_ctrl] AS

	SET NOCOUNT ON;

	BEGIN TRY

	BEGIN TRANSACTION	
		/*delete existing duplicates*/
		delete from [Stage].[t_ctrl_prodview_duplicates]
		where [created_date] <=  convert(date,dateadd(d,-5,getdate()))
		or [created_date] = convert(date,getdate())
		/*find current duplicates*/
		insert into stage.t_ctrl_prodview_duplicates
		select distinct keymigrationsource, convert(date,getdate())
		from (
			/*SELECT keymigrationsource,dttm, count(*) cnt
			FROM [stage].[t_prodview_raw_volumes]
			where keymigrationsource is not null
			group by keymigrationsource, dttm
			having count(*) > 1


			union
			*/

			SELECT keymigrationsource,dttm, count(*) cnt
			FROM [stage].[t_prodview_downtime_hours_volumes]
			where keymigrationsource is not null
			group by keymigrationsource, dttm
			having count(*) > 1

			union
						
			SELECT keymigrationsource,dttm, count(*) cnt
			FROM [stage].t_prodview_injection_volumes
			where keymigrationsource is not null
			group by keymigrationsource, dttm
			having count(*) > 1

			union

			SELECT keymigrationsource,dttm, count(*) cnt
			from [stage].[t_prodview_allocated_volumes]
			where keymigrationsource is not null
			group by keymigrationsource, dttm
			having count(*) > 1

			union

			select prv.keymigrationsource, prv.dttm, count(*) cnt
			from [stage].[t_prodview_allocated_volumes] prv
			join [stage].[t_prodview_shrink_yield_rates] psy
				on prv.idflownet = psy.idflownet
				and prv.keymigrationsource = psy.keymigrationsource
				and prv.compida = psy.compida
				and  prv.dttm >= psy.dttmstart 
				and  prv.dttm <= psy.dttmend
			where prv.keymigrationsource is not null
			group by prv.keymigrationsource, prv.dttm
			having count(*) > 1

			union

			select prv.keymigrationsource, prv.dttm, count(*) cnt
			from [stage].[t_prodview_allocated_volumes] prv
			join [stage].[t_prodview_typfluidprod] ptf
				on prv.keymigrationsource = ptf.keymigrationsource
				and prv.compida	= ptf.compida
				and prv.dttm >= ptf.dttm 
				and prv.dttm <= ptf.ettm
			where prv.keymigrationsource is not null
			group by prv.keymigrationsource, prv.dttm
			having count(*) > 1

			union

			SELECT keymigrationsource,dttm, count(*) cnt
			FROM [stage].[t_prodview_allocated_volumes_incr]
			where keymigrationsource is not null
			group by keymigrationsource, dttm
			having count(*) > 1

			union
						
			SELECT keymigrationsource,dttm, count(*) cnt
			FROM [stage].t_prodview_injection_volumes_incr
			where keymigrationsource is not null
			group by keymigrationsource, dttm
			having count(*) > 1

			union

			SELECT keymigrationsource,dttm, count(*) cnt
			FROM [stage].[t_prodview_downtime_hours_volumes_incr]
			where keymigrationsource is not null
			group by keymigrationsource, dttm
			having count(*) > 1

			union

			SELECT keymigrationsource,dttm, count(*) cnt
			FROM [stage].[t_prodview_allocated_volumes_incr]
			where keymigrationsource is not null
			group by keymigrationsource, dttm
			having count(*) > 1

			union

			select prv.keymigrationsource, prv.dttm, count(*) cnt
			from [stage].[t_prodview_allocated_volumes_incr] prv
			join [stage].[t_prodview_shrink_yield_rates] psy
				on prv.idflownet = psy.idflownet
				and prv.keymigrationsource = psy.keymigrationsource
				and prv.compida = psy.compida
				and  prv.dttm >= psy.dttmstart 
				and  prv.dttm <= psy.dttmend
			where prv.keymigrationsource is not null
			group by prv.keymigrationsource, prv.dttm
			having count(*) > 1

			union

			select prv.keymigrationsource, prv.dttm, count(*) cnt
			from [stage].[t_prodview_allocated_volumes_incr] prv
			join [stage].[t_prodview_typfluidprod] ptf
				on prv.keymigrationsource = ptf.keymigrationsource
				and prv.compida	= ptf.compida
				and prv.dttm >= ptf.dttm 
				and prv.dttm <= ptf.ettm
			where prv.keymigrationsource is not null
			group by prv.keymigrationsource, prv.dttm
			having count(*) > 1
		) s

		select count(*) INSERTED 
		from [Stage].[t_ctrl_prodview_duplicates]
		where [created_date] =   convert(date,getdate())

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
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

	END CATCH

	--RETURN @@ERROR