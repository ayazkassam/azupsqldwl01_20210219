CREATE PROC [datamart_marketing].[marketing_etl_salespoints_ALL] AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FlownetId varchar(100), @SalesIdrec varchar(100), @SalesPoint varchar(100);
	DECLARE @nbr_rows INT 
			,  @i INT 
	DECLARE @paramDefiniton  nvarchar(500) =N'@FlownetIdOUT varchar(100) OUTPUT,
											 @SalesIdrecOUT varchar(100) OUTPUT, 
											 @SalesPointOUT varchar(100) OUTPUT, 
											 @seq int'
	truncate table [datamart_marketing].t_stg_prodview_all_flownet_hierarchy;

	
	IF OBJECT_ID('tempdb..#tbl') IS NOT  NULL
			drop table #tbl
	
	IF OBJECT_ID('tempdb..#cte') IS NOT  NULL
			drop table #cte
	
	CREATE TABLE #cte
	(
		[flownet_id] [varchar](32) NULL,
		[flownet_name] [varchar](50) NULL,
		[sales_disposition_point] [varchar](100) NULL,
		[sales_disposition_point_idrec] [varchar](100) NULL,
		[cube_child] [varchar](100) NULL,
		[cube_parent] [varchar](100) NULL,
		[child_idrec] [varchar](32) NULL,
		[parent_idrec] [varchar](32) NULL,
		[child_name] [varchar](100) NULL,
		[parent_name] [varchar](100) NULL,
		[uwi] [varchar](50) NULL,
		[cc_num] [varchar](50) NULL,
		xlevel int,
		[idrecmetereventtk] [varchar](26) NULL,
		[dttmstart] [datetime] NULL,
		[dttmend] [datetime] NULL,
		[meter_type] [varchar](50) NULL
	);


	BEGIN TRANSACTION		
	
	    
		INSERT
	    INTO [datamart_marketing].t_stg_prodview_all_flownet_hierarchy
        SELECT * FROM datamart_marketing.v_stg_prodview_all_flownet_hierarchy;
	
	COMMIT TRANSACTION

	--
	truncate table [datamart_marketing].[t_stg_marketing_ALL_flownet_hierarchy]
	
	CREATE TABLE #tbl
	WITH
		( DISTRIBUTION = ROUND_ROBIN
		)
	AS
	SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence
			,[idflownet]
			,[sales_point_name]
			,[sales_point_idrec]
	from
	(
		select distinct 
				[idflownet]
				,[sales_point_name]
				,[sales_point_idrec] 
		FROM    [datamart_marketing].[v_ctrl_marketing_sales_points_ALL] ms
				join	[datamart_marketing].[t_stg_prodview_all_flownet_hierarchy] fh
					on ms.[idflownet] = fh.flownet_id
						and fh.parent_idrec = ms.[sales_point_idrec]
		WHERE fh.child_idrec <> '97F059B13EC940EB974436E0E33D4884'
	) t
	SET @nbr_rows = (SELECT COUNT(*) FROM #tbl);
	SET @i = 1;
	declare @xlevel int = 1
	declare @rowsadded int = 0
	WHILE   @i <= @nbr_rows
	BEGIN
	    EXECUTE sp_executesql N'SELECT 
									 @FlownetIdOUT=[idflownet]
									,@SalesPointOUT=[sales_point_name]
									,@SalesIdrecOUT=[sales_point_idrec] 
							 FROM #tbl
							  WHERE Sequence = @seq', @paramDefiniton,
							  @seq = @i,
							  @FlownetIdOUT = @FlownetId OUTPUT,
							  @SalesPointOUT = @SalesPoint OUTPUT,
							  @SalesIdrecOUT = @SalesIdrec OUTPUT

		IF OBJECT_ID('tempdb..#t_stg_marketing_ALL_flownet_hierarchy') IS NOT  NULL
			drop table #t_stg_marketing_ALL_flownet_hierarchy
		set @xlevel = 1
		truncate table #cte
		INSERT INTO #cte
				   ([flownet_id]
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
				   ,xlevel
				   ,[idrecmetereventtk]
				   ,[meter_type]
				   ,[dttmstart]
				   ,[dttmend]
				   )
     

		SELECT 
			distinct
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
					1 xlevel,
					idrecmetereventtk,
					meter_type,
					fh.dttmstart,
					fh.dttmend
			FROM [datamart_marketing].[t_stg_prodview_all_flownet_hierarchy] fh
			WHERE fh.flownet_id = @FlownetId
			AND  fh.parent_idrec IN (@SalesIdrec)
			and child_idrec <> '97F059B13EC940EB974436E0E33D4884'
			
			WHILE EXISTS
			(
				SELECT  
					
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
						xlevel,
						idrecmetereventtk,
						meter_type,
						dttmstart,
						dttmend
				FROM 
					#cte
				WHERE xlevel=@xlevel
			)
			BEGIN
				INSERT INTO #cte
					   ([flownet_id]
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
					   ,xlevel
					   ,[idrecmetereventtk]
					   ,[meter_type]
					   ,[dttmstart]
					   ,[dttmend]
					   )
				SELECT  
					distinct
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
							#cte.xlevel+1,
							child.idrecmetereventtk,
							child.meter_type,
							child.dttmstart,
							child.dttmend
					FROM 
						#cte
						INNER JOIN [datamart_marketing].[t_stg_prodview_all_flownet_hierarchy]  child ON child.cube_parent = #cte.cube_child
						LEFT JOIN #cte cte_check on cte_check.cube_child = #cte.cube_child
													and cte_check.flownet_id = child.flownet_id
													and cte_check.child_idrec = child.child_idrec
													and cte_check.cube_parent = #cte.cube_parent

					WHERE child.flownet_id = @FlownetId
							AND child.child_name <> child.parent_name
							and child.child_idrec <> '97F059B13EC940EB974436E0E33D4884'
							and #cte.xlevel = @xlevel
							and cte_check.flownet_id is NULL

					set @xlevel += 1
					IF @xlevel > 10000
					BEGIN 
						RAISERROR( 'Too many loops!', 16, 1 ) 
						BREAK 
					END;
			END
			declare @cnt int = (select count(*) from #cte)
			print 'INSERTED ' + cast(@cnt as varchar(10)) + ' ROWS'
			insert into
			[datamart_marketing].[t_stg_marketing_ALL_flownet_hierarchy]
			(
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
			)
			SELECT  
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
			FROM #cte
		
		SET     @i = @i + 1;
    END;

 	DROP TABLE #tbl;
	truncate table [datamart_marketing].[t_prodview_sales_disposition_points];
	--
	 
	BEGIN TRANSACTION

	 INSERT INTO [datamart_marketing].[t_prodview_sales_disposition_points]
	 SELECT * 
	 FROM [datamart_marketing].[v_uwis_by_sales_disposition_points];

	COMMIT TRANSACTION 

END