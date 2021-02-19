CREATE PROC [OLAPControl].[usp_Run_Util] @RunID [uniqueidentifier],@Status_Code [int] AS
BEGIN

SET NOCOUNT ON;
--SET ANSI_WARNINGS OFF; 

BEGIN TRY

	Declare @TaskDate datetime = getdate()

	Declare @ExistingRunID uniqueidentifier

	select @ExistingRunID = [RunID] from [OLAPControl].t_Run_Job_Log where RunID = @RunID

	--if @RunID is null or doesn't correspond to an existing record in the t_Run_Job_Log table, throw an exception
	IF @ExistingRunID is null
	RAISERROR ('Job RunID does not exist in [t_Run_Job_Log] table', 16,1); --msg,severity,state


	--Lookup the Status from the supplied @Status_Code param
	Declare @Status nvarchar(50)
	select @Status = [Status] from [OLAPControl].[t_Run_Status_Codes] where [Status_Code] = @Status_Code;


	IF OBJECT_ID('tempdb..#JobLog_CTE') IS NOT NULL DROP TABLE #JobLog_CTE;
    CREATE TABLE #JobLog_CTE
	  (
	   [Run_Task_key] bigint,
	   [RunID]  uniqueidentifier,
	   [Start_date]  datetime,
	   [End_date]    datetime,
	   [End_date_calc] datetime,
	   [Rank_Num] int
	   )

	IF OBJECT_ID('tempdb..#JobLog_CTE2') IS NOT NULL DROP TABLE #JobLog_CTE2;
    CREATE TABLE #JobLog_CTE2
	  (
	   [Run_Task_key] bigint,
	   [RunID]  uniqueidentifier,
	   [Start_date]  datetime,
	   [End_date]    datetime,
	   [End_date_calc] datetime,
	   [Rank_Num] int
	   )


	BEGIN TRANSACTION

	 	------------------------------------------------------------------------------------------------------------------
		--Iterate over tasks within Job Run and calculate the end date and the duration for each task		

		--create records in tablearray #JobLog_CTE
			insert into #JobLog_CTE
			SELECT     [Run_Task_key]
					  ,[RunID]
					  ,[Start_date]
					  ,[End_date]
					  ,[End_date_calc]
					  ,( Row_Number() OVER (partition by [RunID] ORDER BY [Start_date] asc)) as Rank_Num  --rank based on start_date
				  FROM [OLAPControl].[t_Run_Task_Log] 
				WHERE [RunID] = @RunID ;

		  
		   insert into #JobLog_CTE2
            SELECT L1.Run_Task_Key,
			       L1.RunID,
				   coalesce(L2.[Start_date],L1.[Start_date]) Start_Date,
				   L1.End_date,
				   L1.End_date_calc,
				   L1.Rank_Num
			FROM #JobLog_CTE as L1
		    --perform left outer join of CTE to determine next record based on rank
		    left join #JobLog_CTE as L2
		    on L1.[RunID] = L2.[RunID]			--join on RunID UID
		    and L2.[Rank_Num] = (L1.[Rank_Num]+1)

				
		--update End_date_calc to be the value of the next task entry (if SQLServer2012 use new Lead function)
		UPDATE [OLAPControl].t_Run_Task_Log
		SET [OLAPControl].t_Run_Task_Log.[End_date_calc] = #JobLog_CTE2.[Start_date],
		    [OLAPControl].t_Run_Task_Log.[Duration_Sec] = datediff(s,[OLAPControl].t_Run_Task_Log.Start_Date, #JobLog_CTE2.[Start_date])

		FROM  #JobLog_CTE2
		WHERE [OLAPControl].t_Run_Task_Log.[Run_Task_Key] = #JobLog_CTE2.[Run_Task_Key]

		COMMIT TRANSACTION



/*	 
		--update End_date_calc to be the value of the next task entry (if SQLServer2012 use new Lead function)
		update L
		set L.[End_date_calc] = coalesce(R1.[Start_date],L1.[Start_date])		--if end date has been set manually by user, use that value, else start date of nxt record, if no next record, use the start_date of task
		,L.[Duration_sec] = datediff(s,L.[Start_date],coalesce(R1.[Start_date],L1.[Start_date]) )
		from [t_Run_Task_Log] L
		join #JobLog_CTE as L1
		on L.[Run_Task_key] = L1.[Run_Task_key]	--join main [t_Run_Job_Log] to CTE which is ranked based on rec start date
		
		--perform left outer join of CTE to determine next record based on rank
		left join #JobLog_CTE as R1
		on L1.[RunID] = R1.[RunID]			--join on RunID UID
		and R1.[Rank_Num] = (L1.[Rank_Num]+1)	--####get the next ranked record
		
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#JobLog_CTE') IS NOT NULL DROP TABLE #JobLog_CTE;	

*/
	


	

		--Update the status and counts of the overarching job in [t_Run_Task_Log] table

		IF OBJECT_ID('tempdb..#Job_summary_CTE') IS NOT NULL DROP TABLE #Job_summary_CTE;
        CREATE TABLE #Job_summary_CTE
	     (
	     [RunID] uniqueidentifier,
	     [Max_End_date] datetime,
		 [Inserted_count] int,
		 [Updated_count] int,
		 [Deleted_count] int,
		 [Total] float
		  )
		

	  BEGIN TRANSACTION

		--get max startdate of all tasks
	     insert into #Job_summary_CTE
			SELECT RunID
			,max([Start_date]) as [Max_End_date]
			,sum([Inserted_count]) as [Inserted_count]
			,sum([Updated_count]) as [Updated_count]
			,sum([Deleted_count]) as [Deleted_count]
			,sum([Total]) as [Total]
			FROM [OLAPControl].[t_Run_Task_Log]
			WHERE [RunID] = @RunID
			group by RunID
	

		  		
		update [OLAPControl].[t_Run_Job_Log]
		set [End_date_calc] = #Job_summary_CTE.[Max_End_date]
		,[Duration_sec] = datediff(s,[Start_date],#Job_summary_CTE.[Max_End_date])
		,[Inserted_count] = #Job_summary_CTE.[Inserted_count]
		,[Updated_count] = #Job_summary_CTE.[Updated_count]
		,[Deleted_count] = #Job_summary_CTE.[Deleted_count]
		,[Total] = #Job_summary_CTE.[Total]
		,[Status_Code] = (case when @Status_Code <> 3 then coalesce(@Status_Code,[t_Run_Job_Log].[Status_Code]) else [t_Run_Job_Log].[Status_Code] end)   --if status_code <> 3 'Information' then update parent job else keep the same
		,[Status] = (case when @Status_Code <> 3 then coalesce(@Status,[t_Run_Job_Log].[Status]) else [t_Run_Job_Log].[Status] end)
		from #Job_summary_CTE
		WHERE [OLAPControl].[t_Run_Job_Log].[RunID] = #Job_summary_CTE.[RunID]
		AND [OLAPControl].[t_Run_Job_Log].[RunID] = @RunID;
		
		------------------------------------------------------------------------------------------------------------------

		COMMIT TRANSACTION

		IF OBJECT_ID('tempdb..#JobLog_CTE') IS NOT NULL DROP TABLE #JobLog_CTE;
	    IF OBJECT_ID('tempdb..#JobLog_CTE2') IS NOT NULL DROP TABLE #JobLog_CTE2;
		IF OBJECT_ID('tempdb..#Job_summary_CTE') IS NOT NULL DROP TABLE #Job_summary_CTE;

		
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