CREATE PROC [stage].[spLoad_CTE_v_dim_scenario_leaseops_BCD] @parent_scenario_key [varchar](1000),@nlevel [int] AS
begin
	
	SET NOCOUNT ON
		
	IF @nlevel > 99
      BEGIN 
          RAISERROR( 'Too many loops!', 16, 1 ) 
      END;		
	DECLARE @nmbr int = 0
	DECLARE @cnt int = 0
	DECLARE @nextLevel int = 0
	set @nlevel = coalesce(@nlevel, 0)
	DECLARE @next_parent_scenario_key varchar(1000) = ''
	
	IF @nlevel = 0
		BEGIN
			IF OBJECT_ID('[stage].[CTE_v_dim_scenario_leaseops_BCD]') IS NOT NULL
				 DROP TABLE [stage].[CTE_v_dim_scenario_leaseops_BCD]	 
			CREATE TABLE [stage].[CTE_v_dim_scenario_leaseops_BCD]
			(
				RN INT,
				NLEVEL INT,
				[scenario_key] [varchar](1000) NULL,
				[scenario_parent_key] [varchar](1000) NULL,
				[scenario_description] [varchar](2000) NULL,
				[scenario_cube_name] [varchar](50) NULL,
				[unary_operator] [varchar](50) NULL,
				[scenario_formula] [varchar](500) NULL,
				[scenario_formula_property] [varchar](500) NULL,
				[scenario_sort_key] [varchar](50) NULL
			)
		END
	INSERT INTO [stage].[CTE_v_dim_scenario_leaseops_BCD]
           (
			RN
		   ,NLEVEL
		   ,[scenario_key]
           ,[scenario_parent_key]
           ,[scenario_description]
           ,[scenario_cube_name]
           ,[unary_operator]
           ,[scenario_formula]
           ,[scenario_formula_property]
           ,[scenario_sort_key])
	select 
			ROW_NUMBER() OVER (ORDER BY scenario_key) RN,
			@nlevel NLEVEL,
			scenario_key,
			scenario_parent_key,
			scenario_description,
			scenario_cube_name,
			unary_operator,
			scenario_formula,
			scenario_formula_property,
			scenario_sort_key
		from [data_mart].t_dim_scenario sc
		where sc.scenario_cube_name in ('Lease Ops')
		and 
			(
				( @nlevel = 0 and 	scenario_key in ('Actuals','OPEX Budget','Variances'))
				OR
				(@nlevel > 0 and len(coalesce(@parent_scenario_key, '')) > 0 and scenario_parent_key = @parent_scenario_key)
			)
	set @nmbr =	(select count(*) from [stage].[CTE_v_dim_scenario_leaseops_BCD] where NLEVEL = @nlevel)
	set @cnt = 1
	
	WHILE @cnt <= @nmbr
	BEGIN
		set @next_parent_scenario_key = 
			(select scenario_key
			FROM 
				[stage].[CTE_v_dim_scenario_leaseops_BCD]
			WHERE RN = @cnt
				  AND NLEVEL = @nlevel
				  AND (
							(@parent_scenario_key is not null and scenario_parent_key = @parent_scenario_key)
							or @parent_scenario_key is null
					)
			)
		set @nextLevel = @nlevel+1
		--PRINT 'PARENT SCENARIO: ' + COALESCE(@parent_scenario_key,'<NULL>')
		--PRINT 'NEXT PARENT SCENARIO: ' + COALESCE(@next_parent_scenario_key,'<NULL>')
		if @next_parent_scenario_key is not null
			exec [stage].[spLoad_CTE_v_dim_scenario_leaseops_BCD] @parent_scenario_key = @next_parent_scenario_key, @nlevel = @nextLevel
		set @cnt = @cnt + 1
	END
end