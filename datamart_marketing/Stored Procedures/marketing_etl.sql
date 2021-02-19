CREATE PROC [datamart_marketing].[marketing_etl] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
  SET NOCOUNT ON;
  BEGIN TRY
	-- 
	truncate table [datamart_marketing].t_stg_prodview_all_flownet_hierarchy;
	--
	BEGIN TRANSACTION		
	    
		INSERT
	    INTO [datamart_marketing].t_stg_prodview_all_flownet_hierarchy
        SELECT * FROM [datamart_marketing].[v_stg_prodview_all_flownet_hierarchy];
	
	COMMIT TRANSACTION
	DECLARE 
	  @FlownetId varchar(100), 
	  @SalesIdrec varchar(100), 
	  @SalesPoint varchar(100),
	  @i INT = 0,
	  @Total_Row INT = 1;

   IF OBJECT_ID('tempdb..#flownet_cursor') IS NOT NULL
      DROP TABLE #flownet_cursor	 

    CREATE TABLE #flownet_cursor WITH (DISTRIBUTION = ROUND_ROBIN)
      AS

	    SELECT DISTINCT
			 [idflownet]
			,[sales_point_name]
			,[sales_point_idrec]  
			, ROW_NUMBER() OVER (ORDER BY [idflownet],
			                              [sales_point_name],
			                              [sales_point_idrec]) RN
		FROM [datamart_marketing].[v_ctrl_marketing_sales_points];

	SET @Total_Row = (SELECT COUNT(0) CNT FROM #flownet_cursor)	
	TRUNCATE TABLE [datamart_marketing].[t_stg_marketing_flownet_hierarchy];	--

	WHILE @i <= @Total_Row 
	  BEGIN 	

	    SELECT
		  @FlownetId = [idflownet], 
		  @SalesPoint = [sales_point_name], 
		  @SalesIdrec = [sales_point_idrec]
        FROM
		  #flownet_cursor
        WHERE 
		  rn = @i      

        DECLARE @counter INT = 0;
	    TRUNCATE TABLE [datamart_marketing].[CTE_t_stg_marketing_flownet_hierarchy]
	    INSERT INTO [datamart_marketing].[CTE_t_stg_marketing_flownet_hierarchy]
	      (
             [level]
             ,[flownet_id]
             ,[flownet_name]
             ,[sales_disposition_point]
             ,[sales_disposition_point_idrec]
             ,[cube_child]
             ,[cube_parent]
             ,[child_idrec]
             ,[parent_idrec]
             ,[child_name]
             ,[parent_name]
             ,[uwi]
             ,[cc_num]
             ,[idrecmetereventtk]
             ,[dttmstart]
             ,[dttmend]
             ,[meter_type]
	      )

          SELECT  
            0  as [Level],
            fh.flownet_id,
		    fh.flownet_name,
		    @SalesPoint as sales_disposition_point,
		    @SalesIdrec as sales_disposition_point_idrec,
		    cube_child,
		    cube_parent,
		    child_idrec,
		    parent_idrec,
		    child_name,
		    parent_name,
		    uwi,
		    cc_num,
		    idrecmetereventtk,		  
		    fh.dttmstart,
		    fh.dttmend,
		    meter_type
		  FROM 
		    [datamart_marketing].[t_stg_prodview_all_flownet_hierarchy] fh
		  WHERE 
		    fh.flownet_id = @FlownetId AND
		    fh.parent_idrec IN (@SalesIdrec)

	    WHILE EXISTS 
          (
	      	SELECT 1
	      	FROM [datamart_marketing].[t_stg_prodview_all_flownet_hierarchy] child
	      	INNER JOIN [datamart_marketing].[CTE_t_stg_marketing_flownet_hierarchy] parent 
              ON child.cube_parent = parent.cube_child
	      	WHERE 
	      	  child.flownet_id = @FlownetId AND
	      	  child.child_name <> child.parent_name AND
	      	  parent.[level] = @counter
          )
	      BEGIN
		
		    INSERT INTO [datamart_marketing].[CTE_t_stg_marketing_flownet_hierarchy]
	          (
                 [level]
                 ,[flownet_id]
                 ,[flownet_name]
                 ,[sales_disposition_point]
                 ,[sales_disposition_point_idrec]
                 ,[cube_child]
                 ,[cube_parent]
                 ,[child_idrec]
                 ,[parent_idrec]
                 ,[child_name]
                 ,[parent_name]
                 ,[uwi]
                 ,[cc_num]
                 ,[idrecmetereventtk]
                 ,[dttmstart]
                 ,[dttmend]
                 ,[meter_type]
	          )

		      SELECT 
		        @counter + 1,
                child.flownet_id,
		        child.flownet_name,
		        @SalesPoint as sales_disposition_point,
		        @SalesIdrec as sales_disposition_point_idrec,
		        child.cube_child,
		        child.cube_parent,
		        child.child_idrec,
		        child.parent_idrec,
		        child.child_name,
		        child.parent_name,
		        child.uwi,
		        child.cc_num,
		        child.idrecmetereventtk,		  
		        child.dttmstart,
		        child.dttmend,
		        child.meter_type
	  	      FROM [datamart_marketing].[t_stg_prodview_all_flownet_hierarchy] child
	  	      INNER JOIN [datamart_marketing].[CTE_t_stg_marketing_flownet_hierarchy] parent 
                  ON child.cube_parent = parent.cube_child
	  	      WHERE 
	  	        child.flownet_id = @FlownetId AND
	  	        child.child_name <> child.parent_name AND
	  	        parent.[level] = @counter
		      
		    SET @counter += 1;
  		    
		    -- Loop safety
		    IF @counter > 99
		    BEGIN 
			   RAISERROR( 'Too many loops!', 16, 1 ) 
			   BREAK 
		    END;
	      END
		INSERT INTO [datamart_marketing].[t_stg_marketing_flownet_hierarchy]
		SELECT DISTINCT 
		  flownet_id,
		  flownet_name,
		  sales_disposition_point,
		  sales_disposition_point_idrec,
		  cube_child,
		  cube_parent,
		  child_idrec,
		  parent_idrec,
		  child_name,
		  parent_name,
		  uwi,
		  cc_num,
		  idrecmetereventtk,
		  dttmstart,
		  dttmend,
		  meter_type
		FROM 
		  [datamart_marketing].[CTE_t_stg_marketing_flownet_hierarchy];

        SET @i = @i + 1
    
      END;
 -- Process Qbyte CC DOI
 TRUNCATE TABLE [datamart_marketing].[t_stg_qbyte_cost_centre_doi];
 BEGIN TRANSACTION


	INSERT INTO [datamart_marketing].[t_stg_qbyte_cost_centre_doi]
	SELECT *
	FROM [datamart_marketing].[v_stg_qbyte_cost_centre_doi];

 COMMIT TRANSACTION
  -- Process Prodview DOI
 TRUNCATE TABLE [datamart_marketing].[t_stg_prodview_group_point_doi];
 --BEGIN TRANSACTION


	INSERT INTO [datamart_marketing].[t_stg_prodview_group_point_doi]
	SELECT *
	FROM [datamart_marketing].[v_stg_prodview_group_point_doi];

 --COMMIT TRANSACTION

 -- Process Facts
 DROP TABLE [datamart_marketing].[t_fact_marketing];
 --BEGIN TRANSACTION

	
	SELECT *
	INTO [datamart_marketing].[t_fact_marketing]
	FROM [datamart_marketing].[v_fact_source_marketing];

 --COMMIT TRANSACTION

 END TRY
 
 BEGIN CATCH
        
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
			--	,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		--  If the error renders the transaction as uncommittable or we have open transactions, rollback
		 IF @@TRANCOUNT > 0
		 BEGIN
		 	ROLLBACK TRANSACTION
		 END
		 RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)      

  END CATCH

 -- RETURN @@ERROR

END