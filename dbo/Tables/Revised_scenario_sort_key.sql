CREATE TABLE [dbo].[Revised_scenario_sort_key] (
    [scenario_sort_key]         NVARCHAR (1000) NULL,
    [scenario_sort_key_Revised] NVARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

