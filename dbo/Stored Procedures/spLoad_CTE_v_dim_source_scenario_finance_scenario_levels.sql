CREATE PROC [dbo].[spLoad_CTE_v_dim_source_scenario_finance_scenario_levels] AS
BEGIN

 DECLARE @counter INT = 0;

 TRUNCATE TABLE [dbo].CTE_v_dim_source_scenario_finance_scenario_levels
 
 INSERT INTO [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels]
 ([level] ,
	[scenario_key] ,
	[scenario_parent_key] ,
	[scenario_description],
	[scenario_cube_name] ,
	[unary_operator],
	[scenario_formula],
	[scenario_formula_property],
	[scenario_sort_key],
	[Hierarchy_Path],
	[hierarchy_type])
  select 
        0  as [Level]
		,scenario_key
		, scenario_parent_key
		, scenario_description
		, scenario_cube_name
		, unary_operator
		, scenario_formula
		, scenario_formula_property
		, convert(varchar(500), case when scenario_parent_key <> '' then '000000 // ' else '' end + scenario_sort_key) as scenario_sort_key
		, convert(nvarchar(1000),case when scenario_parent_key <> '' then scenario_parent_key + ' // ' else '' end + scenario_key) AS Hierarchy_Path
		, hierarchy_type
	 from dbo.v_CTE_v_dim_source_scenario_finance_dim_scenario 
	 where scenario_cube_name = 'Finance'
	 and scenario_parent_key is null

	WHILE EXISTS 
    (
		select 1
		from dbo.v_CTE_v_dim_source_scenario_finance_dim_scenario child
		join [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels] parent on child.scenario_parent_key = parent.scenario_key 
		where child.scenario_cube_name = 'Finance'
			and parent.[level] = @counter
    )
	BEGIN
		
		 INSERT INTO [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels]
		 ([level] ,
			[scenario_key] ,
			[scenario_parent_key] ,
			[scenario_description],
			[scenario_cube_name] ,
			[unary_operator],
			[scenario_formula],
			[scenario_formula_property],
			[scenario_sort_key],
			[Hierarchy_Path],
			[hierarchy_type])

		select 
			@counter + 1
			, child.scenario_key
			, child.scenario_parent_key
			, child.scenario_description
			, child.scenario_cube_name
			, child.unary_operator
			, child.scenario_formula
			, child.scenario_formula_property
			, convert(varchar(500), parent.scenario_sort_key + ' // ' + child.scenario_sort_key) as scenario_sort_key
			, convert(nvarchar(1000),parent.Hierarchy_Path + ' // ' + child.scenario_key) AS Hierarchy_Path
			, child.hierarchy_type
		from dbo.v_CTE_v_dim_source_scenario_finance_dim_scenario child
		join [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels] parent on child.scenario_parent_key = parent.scenario_key 
		where child.scenario_cube_name = 'Finance'
			and parent.[level] = @counter

		SET @counter += 1;
  
		  -- Loop safety
		IF @counter > 99
		  BEGIN 
			  RAISERROR( 'Too many loops!', 16, 1 ) 
			  BREAK 
		  END;
	END

	SELECT count(1)  from [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels]
END