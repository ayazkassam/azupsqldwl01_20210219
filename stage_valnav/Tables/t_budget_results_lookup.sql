CREATE TABLE [stage_valnav].[t_budget_results_lookup] (
    [ENTITY_ID]           NVARCHAR (50) NOT NULL,
    [SCENARIO_ID]         NVARCHAR (50) NOT NULL,
    [RESERVE_CATEGORY_ID] INT           NOT NULL,
    [PLAN_DEFINITION_ID]  NVARCHAR (50) NOT NULL,
    [RESULT_ID]           NVARCHAR (50) NOT NULL,
    [RESULT_TYPE]         INT           NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

