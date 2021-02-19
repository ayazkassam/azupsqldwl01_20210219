CREATE TABLE [data_mart].[t_leaseops_current_prior_scenario] (
    [scenario_cube_name]        VARCHAR (50)   NULL,
    [scenario_key]              VARCHAR (8000) NULL,
    [scenario_parent_key]       VARCHAR (8000) NULL,
    [scenario_description]      VARCHAR (8000) NULL,
    [unary_operator]            VARCHAR (1)    NOT NULL,
    [scenario_formula]          VARCHAR (1037) NULL,
    [scenario_formula_property] VARCHAR (500)  NULL,
    [scenario_sort_key]         VARCHAR (55)   NULL,
    [isleaf]                    INT            NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

