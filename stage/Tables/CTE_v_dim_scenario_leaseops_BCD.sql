CREATE TABLE [stage].[CTE_v_dim_scenario_leaseops_BCD] (
    [RN]                        INT            NULL,
    [NLEVEL]                    INT            NULL,
    [scenario_key]              VARCHAR (1000) NULL,
    [scenario_parent_key]       VARCHAR (1000) NULL,
    [scenario_description]      VARCHAR (2000) NULL,
    [scenario_cube_name]        VARCHAR (50)   NULL,
    [unary_operator]            VARCHAR (50)   NULL,
    [scenario_formula]          VARCHAR (500)  NULL,
    [scenario_formula_property] VARCHAR (500)  NULL,
    [scenario_sort_key]         VARCHAR (50)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

