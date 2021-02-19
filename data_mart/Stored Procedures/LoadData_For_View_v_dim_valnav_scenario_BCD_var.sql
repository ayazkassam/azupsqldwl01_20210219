CREATE PROC [data_mart].[LoadData_For_View_v_dim_valnav_scenario_BCD_var] AS
BEGIN
	--IF OBJECT_ID('tempdb..#CTE') IS NOT NULL DROP TABLE #CTE;
    IF OBJECT_ID('[dbo].[CTE_v_dim_valnav_scenario_BCD_var]') IS NOT NULL 
	  TRUNCATE TABLE [dbo].[CTE_v_dim_valnav_scenario_BCD_var]--DROP TABLE [dbo].[CTE_v_dim_valnav_scenario_BCD_var];
    ELSE
	CREATE TABLE [dbo].[CTE_v_dim_valnav_scenario_BCD_var]
	  (
	     [xlevel] INT,
	     [scenario_key] [varchar](1000) NULL,
	     [scenario_parent_key] [varchar](1000) NULL,
	     [scenario_description] [varchar](2000) NULL,
	     [scenario_cube_name] [varchar](50) NULL,
	     [unary_operator] [varchar](50) NULL,
	     [scenario_formula] [varchar](500) NULL,
	     [scenario_formula_property] [varchar](500) NULL,
	     [scenario_sort_key] [varchar](50) NULL
	  );

	INSERT INTO [dbo].[CTE_v_dim_valnav_scenario_BCD_var]
	SELECT 1 AS xlevel,
	       scenario_key,
		   scenario_parent_key,
		   scenario_description,
		   scenario_cube_name,
		   unary_operator,
		   scenario_formula,
		   scenario_formula_property,
		   scenario_sort_key
	FROM [data_mart].t_dim_scenario sc
    WHERE sc.scenario_cube_name in ('Valnav')
    and scenario_key in ('Variances'	)

	-- Loop recursively through the child records
	DECLARE @counter INT = 1;

	WHILE EXISTS (
	SELECT *
	from [dbo].[CTE_v_dim_valnav_scenario_BCD_var]
	join [data_mart].t_dim_scenario child 
		on child.scenario_parent_key = [dbo].[CTE_v_dim_valnav_scenario_BCD_var].scenario_key 
		and child.scenario_cube_name = [dbo].[CTE_v_dim_valnav_scenario_BCD_var].scenario_cube_name
		WHERE [dbo].[CTE_v_dim_valnav_scenario_BCD_var].xlevel = @counter
		)

	BEGIN

		-- Insert next level
		INSERT INTO [dbo].[CTE_v_dim_valnav_scenario_BCD_var] --( xlevel, FeatureId, ParentId, FeatureName, PathString, PathLength )
		SELECT @counter + 1 AS xlevel,
	       child.scenario_key,
		   child.scenario_parent_key,
		   child.scenario_description,
		   child.scenario_cube_name,
		   child.unary_operator,
		   child.scenario_formula,
		   child.scenario_formula_property,
		   child.scenario_sort_key
	from [dbo].[CTE_v_dim_valnav_scenario_BCD_var]
	join [data_mart].t_dim_scenario child 
		on child.scenario_parent_key = [dbo].[CTE_v_dim_valnav_scenario_BCD_var].scenario_key 
		and child.scenario_cube_name = [dbo].[CTE_v_dim_valnav_scenario_BCD_var].scenario_cube_name
		WHERE [dbo].[CTE_v_dim_valnav_scenario_BCD_var].xlevel = @counter;

		SET @counter += 1;

		-- Loop safety
		IF @counter > 99
		BEGIN 
			RAISERROR( 'Too many loops!', 16, 1 ) 
			BREAK 
		END;

	END

	SELECT 1
END