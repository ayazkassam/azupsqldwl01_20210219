CREATE PROC [OLAPControl].[usp_Run_Task_Info_Log] @RunID [uniqueidentifier],@Run_Task_key [int] OUT,@Job [nvarchar](100),@Cube [nvarchar](100),@Package [nvarchar](100),@Task [nvarchar](100),@Description [nvarchar](500),@Message [nvarchar](1000),@Information [nvarchar](1000),@FailedTask [nvarchar](100),@ExceptionMsg [nvarchar](1000),@Start_date [datetime],@End_date [datetime],@Inserted_count [int],@Updated_count [int],@Deleted_count [int],@Total [float],@Data_01 [nvarchar](100),@Data_02 [nvarchar](100),@Data_03 [nvarchar](100),@Data_Value_01 [float],@Data_Value_02 [float],@Data_Value_03 [float],@Status_Code [int],@Username [nvarchar](100) AS
BEGIN
--select 1

SET NOCOUNT ON;
--SET ANSI_WARNINGS OFF; 

BEGIN TRY

	Declare @TaskDate datetime = getdate()

	Declare @ExistingRunID uniqueidentifier


	select @ExistingRunID = [RunID] from [OLAPControl].t_Run_Job_Log where RunID = @RunID

	--if @RunID is null or doesn't correspond to an existing record in the t_Run_Job_Log table, throw an exception
	IF @ExistingRunID is null
	RAISERROR ('Job RunID does not exist in [t_Run_Job_Log] table', 16,1); --msg,severity,state



	Declare @ExistingCubeRunTask_Key int
	select @ExistingCubeRunTask_Key = [Run_Task_key] from [OLAPControl].t_Run_Task_Log where Run_Task_key = @Run_Task_key


	--Set Status and Status_Code (default: 3 - Information)
	Declare @Status nvarchar(50)
	select @Status = [Status] from [OLAPControl].[t_Run_Status_Codes] where [Status_Code] = @Status_Code;


	BEGIN TRANSACTION

		--If task key has been provided, update task record (ELSE insert)
		IF @ExistingCubeRunTask_Key is NOT null 
		BEGIN

			UPDATE [OLAPControl].[t_Run_Task_Log]
		   SET [Job] = coalesce(@Job,[Job])	
				,[Cube] = coalesce(@Cube,[Cube])	
				,[Package] = coalesce(@Package,[Package])
				,[Task] = coalesce(@Task,[Task])
				,[Description] = coalesce(@Description,[Description])
				,[Message] =  coalesce(@Message,[Message])
				,[Information] = coalesce(@Information,[Information])
				,[FailedTask] = coalesce(@FailedTask,[FailedTask])
				,[ExceptionMsg] = coalesce(@ExceptionMsg,[ExceptionMsg])
				,[Start_date] = coalesce(@Start_date,[Start_date])
				,[End_date] = coalesce(@End_date,[End_date])
				,[Inserted_count] = coalesce(@Inserted_count,[Inserted_count])
				,[Updated_count] = coalesce(@Updated_count,[Updated_count])
				,[Deleted_count] = coalesce(@Deleted_count,[Deleted_count])
				,[Total] = coalesce(@Total,[Total])
				,[Data_01] = coalesce(@Data_01,[Data_01])
				,[Data_02] = coalesce(@Data_02,[Data_02])
				,[Data_03] = coalesce(@Data_03,[Data_03])
				,[Data_Value_01] = coalesce(@Data_Value_01,[Data_Value_01])
				,[Data_Value_02]  = coalesce(@Data_Value_02,[Data_Value_02])
				,[Data_Value_03] = coalesce(@Data_Value_03,[Data_Value_03])
				,[Status_Code] = coalesce(@Status_Code,[Status_Code])
				,[Status] = coalesce(@Status,[Status])
				,[Username] = coalesce(@Username,[Username])
			WHERE [Run_Task_key] = @ExistingCubeRunTask_Key;
			
		END
		ELSE						-- insert a new tast record
			
		
		 --Insert end task record into "task level" table
		 --Get job details from main [t_Run_Job_Log] table
		 
		INSERT INTO [OLAPControl].[t_Run_Task_Log]
					([RunID]
					,[Job]
					,[Cube]
					,[Package]
					,[Task]
					,[Description]
					,[Message]
					,[Information]
					,[FailedTask]
					,[ExceptionMsg]
					,[Start_date]
					,[End_date]
					,[Inserted_count]
					,[Updated_count]
					,[Deleted_count]
					,[Total]
					,[Data_01]
					,[Data_02]
					,[Data_03]
					,[Data_Value_01]
					,[Data_Value_02]
					,[Data_Value_03]
					,[Status_Code]
					,[Status]
					,[Username])
				select top 1 
					[RunID]
					,coalesce(@Job,[Job])	
					,coalesce(@Cube,[Cube])
					,coalesce(@Package,[Package])
					,@Task
					,@Description
					,@Message
					,@Information
					,@FailedTask
					,@ExceptionMsg
					,coalesce(@Start_date,@TaskDate)
					,@End_date -- will default to null
					,@Inserted_count
					,@Updated_count
					,@Deleted_count
					,@Total
					,@Data_01
					,@Data_02
					,@Data_03
					,@Data_Value_01
					,@Data_Value_02
					,@Data_Value_03
					,coalesce(@Status_Code,[Status_Code])
					,coalesce(@Status,[Status])
					,coalesce(@Username,[Username])
					from [OLAPControl].[t_Run_Job_Log]
					WHERE [RunID] = @RunID;
			

		--return pk of task that has been inserted
		set @Run_Task_key =1--scope_identity()

		COMMIT TRANSACTION

		----------------------------------------------------------------------------------------------------------------
		--Iterate over tasks within Job Run and calculate the end date and the duration for each task (uses its own transaction)		
		EXEC [OLAPControl].usp_Run_Util @RunID =  @RunID, @Status_Code = @Status_Code
		----------------------------------------------------------------------------------------------------------------

		
		
		
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