CREATE PROC [OLAPControl].[usp_Run_End_Job] @RunID [uniqueidentifier],@Job [nvarchar](100),@Cube [nvarchar](100),@Package [nvarchar](100),@Task [nvarchar](100),@Description [nvarchar](500),@Message [nvarchar](1000),@Information [nvarchar](1000),@FailedTask [nvarchar](100),@ExceptionMsg [nvarchar](1000),@End_date [datetime],@Inserted_count [int],@Updated_count [int],@Deleted_count [int],@Total [float],@Data_01 [nvarchar](100),@Data_02 [nvarchar](100),@Data_03 [nvarchar](100),@Data_Value_01 [float],@Data_Value_02 [float],@Data_Value_03 [float],@Status_Code [int],@ParentRunID [uniqueidentifier],@QueueRunID [uniqueidentifier],@Username [nvarchar](100),@IsCubeRefreshFlag [int] AS
BEGIN
SET NOCOUNT ON;
select 1
--BEGIN TRY

--	Declare @enddate datetime = getdate()
--	Declare @ExistingRunID uniqueidentifier

--	select @ExistingRunID = [RunID] from [OLAPControl].t_Run_Job_Log where RunID = @RunID

--	--if @RunID is null or doesn't correspond to an existing record in the t_Run_Job_Log table, throw an exception
--	IF @ExistingRunID is null
--	RAISERROR ('Job RunID does not exist in [t_Run_Job_Log] table', 16,1); --msg,severity,state


--	--Set Status and Status_Code (default: 4 - Completed-success)
--	Declare @Status nvarchar(50)
--	select @Status = [Status] from [OLAPControl].[t_Run_Status_Codes] where [Status_Code] = @Status_Code;


----	BEGIN TRANSACTION

--			--Insert end task record into "task level" table
--			--Get job details from main [t_Run_Job_Log] table
			 
--			INSERT INTO [OLAPControl].[t_Run_Task_Log]
--						([RunID]
--						,[Job]
--						,[Cube]
--						,[Package]
--						,[Task]
--						,[Description]
--						,[Message]
--						,[Information]
--						,[FailedTask]
--						,[ExceptionMsg]
--						,[Start_date]
--						,[End_date]
--						,[Inserted_count]
--						,[Updated_count]
--						,[Deleted_count]
--						,[Total]
--						,[Data_01]
--						,[Data_02]
--						,[Data_03]
--						,[Data_Value_01]
--						,[Data_Value_02]
--						,[Data_Value_03]
--						,[Status_Code]
--						,[Status]
--						,[Username])
--					select top 1 
--						[RunID]
--						,coalesce(@Job,[Job])	
--						,coalesce(@Cube,[Cube])
--						,coalesce(@Package,[Package])
--						,coalesce(@Task,[Task])
--						,coalesce(@Description,[Description])
--						,coalesce(@Message,[Message])
--						,coalesce(@Information,[Information])
--						,coalesce(@FailedTask,[FailedTask])
--						,coalesce(@ExceptionMsg,[ExceptionMsg])
--						,coalesce(@End_date,@enddate)			--when writing end record, set start date as end date
--						,coalesce(@End_date,@enddate)
--						,@Inserted_count
--						,@Updated_count
--						,@Deleted_count
--						,@Total
--						,@Data_01
--						,@Data_02
--						,@Data_03
--						,@Data_Value_01
--						,@Data_Value_02
--						,@Data_Value_03
--						,coalesce(@Status_Code,[Status_Code])
--						,coalesce(@Status,[Status])
--						,coalesce(@Username,[Username])
--						from [OLAPControl].[t_Run_Job_Log]
--						WHERE [RunID] = @RunID;



--			--update job end in overarching job log table, all columns can be overwritten except end_date and run_ID but 
--			UPDATE [OLAPControl].[t_Run_Job_Log]
--				SET [Job] = coalesce(@Job,[Job])	
--					,[Cube] = coalesce(@Cube,[Cube])	
--					,[Package] = coalesce(@Package,[Package])
--					,[Task] = coalesce(@Task,[Task])
--					,[Description] = coalesce(@Description,[Description])
--					,[Message] =  coalesce(@Message,[Message])
--					,[Information] = coalesce(@Information,[Information])
--					,[FailedTask] = coalesce(@FailedTask,[FailedTask])
--					,[ExceptionMsg] = coalesce(@ExceptionMsg,[ExceptionMsg])
--					,[End_date] = coalesce(@End_date,@enddate)
--					,[Inserted_count] = coalesce(@Inserted_count,[Inserted_count])
--					,[Updated_count] = coalesce(@Updated_count,[Updated_count])
--					,[Deleted_count] = coalesce(@Deleted_count,[Deleted_count])
--					,[Total] = coalesce(@Total,[Total])
--					,[Data_01] = coalesce(@Data_01,[Data_01])
--					,[Data_02] = coalesce(@Data_02,[Data_02])
--					,[Data_03] = coalesce(@Data_03,[Data_03])
--					,[Data_Value_01] = coalesce(@Data_Value_01,[Data_Value_01])
--					,[Data_Value_02]  = coalesce(@Data_Value_02,[Data_Value_02])
--					,[Data_Value_03] = coalesce(@Data_Value_03,[Data_Value_03])
--					,[Status_Code] = coalesce(@Status_Code,Status_Code)
--					,[Status] = coalesce(@Status,[Status])
--					,[ParentRunID] = coalesce(@ParentRunID,[ParentRunID])
--					,[QueueRunID] = coalesce(@QueueRunID,[QueueRunID])
--					,[Username] = coalesce(@Username,[Username])
--					,[IsCubeRefreshFlag] = coalesce(@IsCubeRefreshFlag,[IsCubeRefreshFlag])
--			 WHERE [RunID] = @RunID;
			 
		
		
		--COMMIT TRANSACTION 
			 
		------------------------------------------------------------------------------------------------------------------
		-- Iterate over tasks within Job Run and calculate the end date and the duration for each task		
		--EXEC usp_Run_Util @RunID =  @RunID, @Status_Code = @Status_Code
		------------------------------------------------------------------------------------------------------------------


		--------------------------------------------------------------------
		-- Update the Queue record if the job was initiated via the Queue --
		--------------------------------------------------------------------
		--set @QueueRunID = (select [QueueRunID] from [dbo].[t_Run_Job_Log] WHERE [RunID] = @RunID) 
		--if @QueueRunID is not null
	--		EXEC dbo.usp_Run_Queue_Item_End @QueueRunID = @QueueRunID






			 

		
		
	--END TRY
	--BEGIN CATCH
	--	-- Grab error information from SQL functions
	--	DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
	--			,@ErrorNumber INT	= ERROR_NUMBER()
	--			,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
	--			,@ErrorState INT = ERROR_STATE()
	--			,@ErrorLine  INT = ERROR_LINE()
	--			,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
	--	-- If the error renders the transaction as uncommittable or we have open transactions, rollback
	--	IF @@TRANCOUNT > 0
	--	BEGIN
	--		ROLLBACK TRANSACTION
	--	END
	--	RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)

	--END CATCH
	
	--RETURN @@ERROR
 
 
      
END