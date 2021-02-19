CREATE TABLE [dbo].[CTE_v_dim_valnav_current_prior_budget_scenario_source] (
    [xlevel]               INT            NULL,
    [scenario_cube_name]   VARCHAR (50)   NULL,
    [scenario_key]         VARCHAR (1000) NULL,
    [scenario_parent_key]  VARCHAR (1000) NULL,
    [scenario_description] VARCHAR (2000) NULL,
    [scenario_sort_key]    VARCHAR (50)   NULL,
    [source_replace_text]  VARCHAR (200)  NULL,
    [dest_replace_text]    VARCHAR (200)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

