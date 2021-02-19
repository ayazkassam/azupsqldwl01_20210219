CREATE PROC [data_mart].[LoadData_For_View_v_dim_valnav_current_prior_budget_scenario_source] AS
BEGIN
	--IF OBJECT_ID('tempdb..#CTE') IS NOT NULL DROP TABLE #CTE;
    IF OBJECT_ID('[dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source]') IS NOT NULL 
	  TRUNCATE TABLE [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source]--DROP TABLE [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source];
    ELSE
	CREATE TABLE [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source]
	  (
		xlevel INT,
		scenario_cube_name VARCHAR(50),
		scenario_key VARCHAR(1000),
		scenario_parent_key VARCHAR(1000),
		scenario_description VARCHAR(2000),
		scenario_sort_key VARCHAR(50),
		source_replace_text VARCHAR(200),
		dest_replace_text VARCHAR(200)
	  );

	--WITH cte AS
	--(
	INSERT INTO [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source]
	select 1 AS xlevel,
		   scenario_cube_name,
		   scenario_key,
		   scenario_parent_key,
		   scenario_description,
		   scenario_sort_key,
		   /*-- IF text1/text1 are not used then use the Node parent key as the basis for replacement */
		   CASE WHEN ct.text1 IS NULL THEN rtrim(ltrim(ct.variable_value)) ELSE ct.text1 END source_replace_text,
		   CASE WHEN ct.text2 IS NULL THEN rtrim(ltrim(ct.cube_child_member)) ELSE ct.text2 END dest_replace_text
		  -- ,sc.*
	from [data_mart].t_dim_scenario sc
	join [stage].t_ctrl_valnav_etl_variables ct 
		on sc.scenario_key = ct.variable_value 
		and replace(sc.scenario_cube_name,' ','') = left(ct.variable_name, charindex('_',ct.variable_name)-1)	/*prevent duplication and allow for the different cubes to have different values*/
	where sc.scenario_cube_name in ('Valnav','Capital','Volumes','Lease Ops','Finance')
	and ct.variable_name in ('VALNAV_CURRENT_APPROVED_BUDGET','VALNAV_PRIOR_APPROVED_BUDGET'
							,'CAPITAL_CURRENT_APPROVED_BUDGET','CAPITAL_PRIOR_APPROVED_BUDGET'
							,'VOLUMES_CURRENT_APPROVED_BUDGET','VOLUMES_PRIOR_APPROVED_BUDGET'
							,'FINANCE_CURRENT_APPROVED_BUDGET','FINANCE_PRIOR_APPROVED_BUDGET')

	-- Loop recursively through the child records
	DECLARE @counter INT = 1;

	WHILE EXISTS (
	SELECT *
	from [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source]
	join [data_mart].t_dim_scenario child 
		on child.scenario_parent_key = [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_key 
		and child.scenario_cube_name = [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_cube_name
		WHERE [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].xlevel = @counter
		)

	BEGIN

		-- Insert next level
		INSERT INTO [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source] --( xlevel, FeatureId, ParentId, FeatureName, PathString, PathLength )
		SELECT @counter + 1 AS xlevel, child.scenario_cube_name,
		   child.scenario_key,
		   child.scenario_parent_key,
		   child.scenario_description,
		   child.scenario_sort_key,
		   source_replace_text,
		   dest_replace_text

	from [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source]
	join [data_mart].t_dim_scenario child 
		on child.scenario_parent_key = [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_key 
		and child.scenario_cube_name = [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].scenario_cube_name
		WHERE [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source].xlevel = @counter;

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