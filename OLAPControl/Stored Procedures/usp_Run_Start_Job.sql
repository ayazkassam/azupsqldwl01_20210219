CREATE PROC [OLAPControl].[usp_Run_Start_Job] @RunID [nvarchar](100),@Job [nvarchar](100),@Cube [nvarchar](100),@Package [nvarchar](100),@Task [nvarchar](100),@Description [nvarchar](500),@Message [nvarchar](1000),@Information [nvarchar](1000),@Status_Code [int],@ParentRunID [uniqueidentifier],@QueueRunID [uniqueidentifier],@Username [nvarchar](100),@IsCubeRefreshFlag [int] AS
BEGIN

SET NOCOUNT ON;
SELECT 1
	--BEGIN TRY
	
	--	Declare @stdate datetime = getdate()
	--	set @RunID = coalesce(@RunID,newid())
	--	set @Username = coalesce(@Username,SYSTEM_USER)


	--	Declare @ExistingRunID uniqueidentifier
	--	select @ExistingRunID = [RunID] from [OLAPControl].t_Run_Job_Log where RunID = @RunID


	
	--	--if @RunID is not null raise an exception
	--	IF @ExistingRunID is not null
	--	RAISERROR ('Job RunID already exists in [t_Run_Job_Log] table', 16,1); --msg,severity,state



	--	--Set Status and Status_Code (default: 1 - Started)
	--	Declare @Status nvarchar(50)
	--	select @Status = [Status] from [OLAPControl].[t_Run_Status_Codes] where [Status_Code] = @Status_Code;



	--	--BEGIN TRANSACTION

	--		--Insert record into overarching Job table
	--		INSERT INTO [OLAPControl].[t_Run_Job_Log]
	--					([RunID]
	--					,[Job]
	--					,[Cube]
	--					,[Package]
	--					,[Task]
	--					,[Description]
	--					,[Message]
	--					,[Information]
	--					,[Start_date]
	--					,[End_date]
	--					,[Inserted_count]
	--					,[Updated_count]
	--					,[Deleted_count]
	--					,[Total]
	--					,[Data_01]
	--					,[Data_02]
	--					,[Data_03]
	--					,[Data_Value_01]
	--					,[Data_Value_02]
	--					,[Data_Value_03]
	--					,[Status_Code]
	--					,[Status]
	--					,[ParentRunID]
	--					,[QueueRunID]
	--					,[Username]
	--					,[IsCubeRefreshFlag])
	--			 VALUES
	--				   (@RunID 
	--					,@Job
	--					,@Cube
	--					,@Package
	--					,@Task
	--					,@Description
	--					,@Message
	--					,@Information
	--					,@stdate
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,@Status_Code
	--					,@Status
	--					,@ParentRunID
	--					,@QueueRunID
	--					,@Username
	--					,@IsCubeRefreshFlag);


	--		--Insert record into task leveltable			
	--		INSERT INTO [OLAPControl].[t_Run_Task_Log]
	--					([RunID]
	--					,[Job]
	--					,[Cube]
	--					,[Package]
	--					,[Task]
	--					,[Description]
	--					,[Message]
	--					,[Information]
	--					,[Start_date]
	--					,[End_date]
	--					,[Inserted_count]
	--					,[Updated_count]
	--					,[Deleted_count]
	--					,[Total]
	--					,[Data_01]
	--					,[Data_02]
	--					,[Data_03]
	--					,[Data_Value_01]
	--					,[Data_Value_02]
	--					,[Data_Value_03]
	--					,[Status_Code]
	--					,[Status]
	--					,[Username])
	--			 VALUES
	--				   (@RunID 
	--					,@Job
	--					,@Cube
	--					,@Package
	--					,@Task
	--					,@Description
	--					,@Message
	--					,@Information
	--					,@stdate
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,null
	--					,@Status_Code
	--					,@Status
	--					,@Username);
			
	--	COMMIT TRANSACTION
		
		
	--END TRY
	--BEGIN CATCH
	--	-- Grab error information from SQL functions
	--	DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
	--			,@ErrorNumber INT	= ERROR_NUMBER()
	--			,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
	--			,@ErrorState INT = ERROR_STATE()
	--		--	,@ErrorLine  INT = ERROR_LINE()
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