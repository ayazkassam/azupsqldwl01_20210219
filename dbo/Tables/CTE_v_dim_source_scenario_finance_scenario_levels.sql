CREATE TABLE [dbo].[CTE_v_dim_source_scenario_finance_scenario_levels] (
    [level]                     INT             NULL,
    [scenario_key]              VARCHAR (8000)  NULL,
    [scenario_parent_key]       VARCHAR (8000)  NULL,
    [scenario_description]      VARCHAR (8000)  NULL,
    [scenario_cube_name]        VARCHAR (50)    NULL,
    [unary_operator]            VARCHAR (50)    NULL,
    [scenario_formula]          VARCHAR (1037)  NULL,
    [scenario_formula_property] VARCHAR (500)   NULL,
    [scenario_sort_key]         VARCHAR (500)   NULL,
    [Hierarchy_Path]            NVARCHAR (1000) NULL,
    [hierarchy_type]            VARCHAR (11)    NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

