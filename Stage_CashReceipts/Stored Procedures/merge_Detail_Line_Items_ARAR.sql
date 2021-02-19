CREATE PROC [Stage_CashReceipts].[merge_Detail_Line_Items_ARAR] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY	


	
	TRUNCATE TABLE [Stage_CashReceipts].[Detail_Line_Items_ARAR_backup]
	BEGIN TRANSACTION			

			
			 
			INSERT INTO  [Stage_CashReceipts].[Detail_Line_Items_ARAR_backup]
			SELECT * FROM  [Stage_CashReceipts].[Detail_Line_Items_ARAR]
			

	COMMIT TRANSACTION
	
	IF OBJECT_ID('tempdb..#Detail_Line_Items_ARAR_MERGE') IS NOT NULL
      DROP TABLE #Detail_Line_Items_ARAR_MERGE

	CREATE TABLE #Detail_Line_Items_ARAR_MERGE(
			[Flag] varchar(10),
			[key] [uniqueidentifier]  NULL,
			[Timestamp] [date] NULL,
			[LineItemName] [varchar](150) NOT NULL,
			[ProdMonth] [date] NOT NULL,
			[AcctMonth] [date] NULL,
			[BAPurchaserID] [int] NULL,
			[BAName] [varchar](100) NOT NULL,
			[Origin Location] [varchar](100) NULL,
			[Product] [varchar](50) NOT NULL,
			[Delivery Location] [varchar](100) NULL,
			[Facility Code] [varchar](100) NULL,
			[Production Accountant] [nchar](50) NULL,
			[LineItemMaster_fk] [uniqueidentifier] NULL,
			[LIM_AutoCount] [int] NULL,
			[Volume] [real] NULL,
			[Dollars] [money] NULL,
			[Energy] [real] NULL,
			[Comment] [varchar](100) NULL,
			[Amendment] [bit] DEFAULT ((0)) NOT NULL,
			[Modified By] [varchar](50) NULL,
			[Modified Date] [datetime] NULL,
			[Hide] [bit] NULL,
			[timestampdt] [datetime] NULL
		) 

	BEGIN TRANSACTION

		INSERT INTO #Detail_Line_Items_ARAR_MERGE
			   (
				[Flag]
			   ,[key]
			   ,[Timestamp]
			   ,[LineItemName]
			   ,[ProdMonth]
			   ,[AcctMonth]
			   ,[BAPurchaserID]
			   ,[BAName]
			   ,[Origin Location]
			   ,[Product]
			   ,[Delivery Location]
			   ,[Facility Code]
			   ,[Production Accountant]
			   ,[LineItemMaster_fk]
			   ,[LIM_AutoCount]
			   ,[Volume]
			   ,[Dollars]
			   ,[Energy]
			   ,[Comment]
			   ,[Amendment]
			   ,[Modified By]
			   ,[Modified Date]
			   ,[Hide])
		SELECT 'NEW' Flag
			   ,src.[key]
			   ,src.[Timestamp]
			   ,src.[LineItemName]
			   ,src.[ProdMonth]
			   ,src.[AcctMonth]
			   ,src.[BAPurchaserID]
			   ,src.[BAName]
			   ,src.[Origin Location]
			   ,src.[Product]
			   ,src.[Delivery Location]
			   ,src.[Facility Code]
			   ,src.[Production Accountant]
			   ,src.[LineItemMaster_fk]
			   ,src.[LIM_AutoCount]
			   ,src.[Volume]
			   ,src.[Dollars]
			   ,src.[Energy]
			   ,src.[Comment]
			   ,src.[Amendment]
			   ,src.[Modified By]
			   ,src.[Modified Date]
			   ,src.[Hide]
		FROM
		    [Stage_CashReceipts].[stage_Detail_Line_Items_ARAR] as src
			LEFT JOIN [Stage_CashReceipts].[Detail_Line_Items_ARAR] as facts
				ON  facts.[key]		= src.[key]
			WHERE facts.[key] IS NULL
		UNION ALL
			SELECT 'UPDATE' Flag
				   ,src.[key]
				   ,src.[Timestamp]
				   ,src.[LineItemName]
				   ,src.[ProdMonth]
				   ,src.[AcctMonth]
				   ,src.[BAPurchaserID]
				   ,src.[BAName]
				   ,src.[Origin Location]
				   ,src.[Product]
				   ,src.[Delivery Location]
				   ,src.[Facility Code]
				   ,src.[Production Accountant]
				   ,src.[LineItemMaster_fk]
				   ,src.[LIM_AutoCount]
				   ,src.[Volume]
				   ,src.[Dollars]
				   ,src.[Energy]
				   ,src.[Comment]
				   ,src.[Amendment]
				   ,src.[Modified By]
				   ,src.[Modified Date]
				   ,src.[Hide]
			FROM
				(
					SELECT 	   
					    src.[key]
					   ,src.[Timestamp]
					   ,src.[LineItemName]
					   ,src.[ProdMonth]
					   ,src.[AcctMonth]
					   ,src.[BAPurchaserID]
					   ,src.[BAName]
					   ,src.[Origin Location]
					   ,src.[Product]
					   ,src.[Delivery Location]
					   ,src.[Facility Code]
					   ,src.[Production Accountant]
					   ,src.[LineItemMaster_fk]
					   ,src.[LIM_AutoCount]
					   ,src.[Volume]
					   ,src.[Dollars]
					   ,src.[Energy]
					   ,src.[Comment]
					   ,src.[Amendment]
					   ,src.[Modified By]
					   ,src.[Modified Date]
					   ,src.[Hide]
					FROM
						[Stage_CashReceipts].[stage_Detail_Line_Items_ARAR] as src
						INNER JOIN [Stage_CashReceipts].[Detail_Line_Items_ARAR] as facts
							ON  facts.[key]		= src.[key]
				EXCEPT
					SELECT 	   
					    facts.[key]
					   ,facts.[Timestamp]
					   ,facts.[LineItemName]
					   ,facts.[ProdMonth]
					   ,facts.[AcctMonth]
					   ,facts.[BAPurchaserID]
					   ,facts.[BAName]
					   ,facts.[Origin Location]
					   ,facts.[Product]
					   ,facts.[Delivery Location]
					   ,facts.[Facility Code]
					   ,facts.[Production Accountant]
					   ,facts.[LineItemMaster_fk]
					   ,facts.[LIM_AutoCount]
					   ,facts.[Volume]
					   ,facts.[Dollars]
					   ,facts.[Energy]
					   ,facts.[Comment]
					   ,facts.[Amendment]
					   ,facts.[Modified By]
					   ,facts.[Modified Date]
					   ,facts.[Hide]
					FROM
						[Stage_CashReceipts].[Detail_Line_Items_ARAR] as facts
				) src
   
    UPDATE [Stage_CashReceipts].[Detail_Line_Items_ARAR]
	SET
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Timestamp]				=  src.[Timestamp],				
	     [Stage_CashReceipts].[Detail_Line_Items_ARAR].[LineItemName]			=  src.[LineItemName],			
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[ProdMonth]				=  src.[ProdMonth],				
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[AcctMonth]				=  src.[AcctMonth],				
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[BAPurchaserID]			=  src.[BAPurchaserID],			
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[BAName]					=  src.[BAName],					
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Origin Location]		=  src.[Origin Location],			
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Product]				=  src.[Product],					
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Delivery Location]		=  src.[Delivery Location],		
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Facility Code]			=  src.[Facility Code],			
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Production Accountant]	=  src.[Production Accountant],	
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[LineItemMaster_fk]		=  src.[LineItemMaster_fk],		
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[LIM_AutoCount]			=  src.[LIM_AutoCount],			
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Volume]					=  src.[Volume],					
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Dollars]				=  src.[Dollars],					
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Energy]					=  src.[Energy],					
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Comment]				=  src.[Comment],					
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Amendment]				=  src.[Amendment],				
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Modified By]			=  src.[Modified By],				
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Modified Date]			=  src.[Modified Date],			
		 [Stage_CashReceipts].[Detail_Line_Items_ARAR].[Hide]					=  src.[Hide]
	FROM
		#Detail_Line_Items_ARAR_MERGE src
	WHERE
		[Stage_CashReceipts].[Detail_Line_Items_ARAR].[key] = src.[key]
		AND	src.Flag='UPDATE' 
	

	INSERT INTO [Stage_CashReceipts].[Detail_Line_Items_ARAR]
			   ([key]
			   ,[Timestamp]
			   ,[LineItemName]
			   ,[ProdMonth]
			   ,[AcctMonth]
			   ,[BAPurchaserID]
			   ,[BAName]
			   ,[Origin Location]
			   ,[Product]
			   ,[Delivery Location]
			   ,[Facility Code]
			   ,[Production Accountant]
			   ,[LineItemMaster_fk]
			   ,[LIM_AutoCount]
			   ,[Volume]
			   ,[Dollars]
			   ,[Energy]
			   ,[Comment]
			   ,[Amendment]
			   ,[Modified By]
			   ,[Modified Date]
			   ,[Hide]
			   ,[timestampdt])
	SELECT
		 src.[key]
		,src.[Timestamp]
		,src.[LineItemName]
		,src.[ProdMonth]
		,src.[AcctMonth]
		,src.[BAPurchaserID]
		,src.[BAName]
		,src.[Origin Location]
		,src.[Product]
		,src.[Delivery Location]
		,src.[Facility Code]
		,src.[Production Accountant]
		,src.[LineItemMaster_fk]
		,src.[LIM_AutoCount]
		,src.[Volume]
		,src.[Dollars]
		,src.[Energy]
		,src.[Comment]
		,src.[Amendment]
		,src.[Modified By]
		,src.[Modified Date]
		,src.[Hide],
		getdate()
	FROM
		#Detail_Line_Items_ARAR_MERGE src
	WHERE
		src.Flag='NEW' 
	
	DECLARE @deleted INT = (SELECT COUNT(*) 
							 FROM 
									[Stage_CashReceipts].[Detail_Line_Items_ARAR] 
							WHERE
								[key] not in
								(SELECT [key] FROM [Stage_CashReceipts].[stage_Detail_Line_Items_ARAR]))


	DELETE FROM [Stage_CashReceipts].[Detail_Line_Items_ARAR]
	WHERE
		[key] not in
		(SELECT [key] FROM [Stage_CashReceipts].[stage_Detail_Line_Items_ARAR])

	
      --	
      --
	DECLARE @inserted INT = (SELECT COUNT(*) FROM #Detail_Line_Items_ARAR_MERGE WHERE Flag='NEW')
	DECLARE @updated INT = (SELECT COUNT(*) FROM #Detail_Line_Items_ARAR_MERGE WHERE Flag='UPDATE')
	SELECT @inserted INSERTED, @updated UPDATED, @deleted DELETED

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

  --RETURN @@ERROR

END