CREATE TABLE [dbo].[Parse_scenario_sort_key] (
    [scenario_sort_key]                  VARCHAR (1000) NULL,
    [account_level_01_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_02_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_03_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_04_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_05_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_06_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_07_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_08_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_09_scenario_sort_key] VARCHAR (1000) NULL,
    [account_level_10_scenario_sort_key] VARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

