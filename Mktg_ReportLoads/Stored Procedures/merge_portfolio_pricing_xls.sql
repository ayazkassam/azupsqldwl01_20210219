CREATE PROC [Mktg_ReportLoads].[merge_portfolio_pricing_xls] AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY	
		IF OBJECT_ID('tempdb..#t_stg_portfolio_pricing_xls_merge') IS NOT NULL
			  DROP TABLE #t_stg_portfolio_pricing_xls_merge

		create table #t_stg_portfolio_pricing_xls_merge(
			[Flag] varchar(10),
			[Strip_Date] [datetime] NULL,
			[Comment] [varchar](255) NULL,
			[Product_Type] [varchar](50) NULL,
			[Name] [varchar](50) NULL,
			[Settlement_Period] [varchar](10) NULL,
			[Units] [varchar](50) NULL,
			[Currency] [varchar](3) NULL,
			[Delivery_Date] [datetime] NULL,
			[Strip_Price] [float] NULL,
			[Manual_Override] [float] NULL,
			[Realized_Price] [float] NULL,
			[Portfolio_Price] [float] NULL,
			[Modified_Date] [datetime] NOT NULL
		) 
		BEGIN TRANSACTION
			INSERT INTO #t_stg_portfolio_pricing_xls_merge
					   ([Flag]
					   ,[Strip_Date]
					   ,[Comment]
					   ,[Product_Type]
					   ,[Name]
					   ,[Settlement_Period]
					   ,[Units]
					   ,[Currency]
					   ,[Delivery_Date]
					   ,[Strip_Price]
					   ,[Manual_Override]
					   ,[Realized_Price]
					   ,[Portfolio_Price]
					   ,[Modified_Date])

			select 

				 CASE WHEN dst.comment IS NULL and dst.strip_date is NULL THEN 'INSERT'
					  ELSE 'DELETE'
				 END Flag
				, try_convert(datetime,src.Strip_Date)						 Strip_Date
				, try_convert(varchar(255),src.Comment)					 Comment
				, try_convert(varchar(50),src.Product_Type)				 Product_Type
				, try_convert(varchar(50),src.Name)						 Name
				, try_convert(varchar(10),src.Settlement_Period)		Settlement_Period
				, try_convert(varchar(50),src.Units)					 Units
				, try_convert(varchar(3),src.Currency)					 Currency
				, try_convert(datetime,src.Delivery_Date)					 Delivery_Date
				, try_convert(float,src.Strip_Price)					 Strip_Price
				, try_convert(float,src.Manual_Override)				 Manual_Override
				, try_convert(float,src.Realized_Price)					 Realized_Price
				, try_convert(float,src.Portfolio_Price)				 Portfolio_Price
				, try_convert(datetime,getdate())						 Modified_Date
			from [Mktg_ReportLoads].t_stg_portfolio_pricing_text src
				 left join [Mktg_ReportLoads].[t_stg_portfolio_pricing_xls] dst
				 on (try_convert(datetime,src.Strip_Date)= dst.strip_date
					 and COALESCE(try_convert(varchar(255),src.Comment), '9XXX9') = convert(nvarchar(255),isnull(dst.comment,''))
					)
			where src.strip_date is not null
			and src.strip_date <> 'strip_date'


			DELETE FROM [Mktg_ReportLoads].[t_stg_portfolio_pricing_xls]
			WHERE
				EXISTS(SELECT 1 FROM
						#t_stg_portfolio_pricing_xls_merge mrg
						join [Mktg_ReportLoads].[t_stg_portfolio_pricing_xls] dst
							on (mrg.Strip_Date = dst.strip_date
								 and isnull(mrg.Comment,'9XXX9')= isnull(dst.comment,'')
							  )
						WHERE
							flag='DELETE')

			INSERT INTO [Mktg_ReportLoads].[t_stg_portfolio_pricing_xls]
					   (
					   [Strip_Date]
					   ,[Comment]
					   ,[Product_Type]
					   ,[Name]
					   ,[Settlement_Period]
					   ,[Units]
					   ,[Currency]
					   ,[Delivery_Date]
					   ,[Strip_Price]
					   ,[Manual_Override]
					   ,[Realized_Price]
					   ,[Portfolio_Price]
					   ,[Modified_Date])
			select
						[Strip_Date]
					   ,[Comment]
					   ,[Product_Type]
					   ,[Name]
					   ,[Settlement_Period]
					   ,[Units]
					   ,[Currency]
					   ,[Delivery_Date]
					   ,[Strip_Price]
					   ,[Manual_Override]
					   ,[Realized_Price]
					   ,[Portfolio_Price]
					   ,[Modified_Date]
			from
				#t_stg_portfolio_pricing_xls_merge
			where
				flag='INSERT';


			DECLARE @DELETED INT = COALESCE((select count(*) from #t_stg_portfolio_pricing_xls_merge where flag='DELETE'),0)
			DECLARE @INSERTED INT = COALESCE((select count(*) from #t_stg_portfolio_pricing_xls_merge where flag='INSERT'), 0)

			SELECT @DELETED DELETED, @INSERTED INSERTED
		COMMIT TRANSACTION
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
END