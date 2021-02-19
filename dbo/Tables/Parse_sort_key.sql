CREATE TABLE [dbo].[Parse_sort_key] (
    [sort_key]                  VARCHAR (1000) NULL,
    [account_level_01_sort_key] VARCHAR (1000) NULL,
    [account_level_02_sort_key] VARCHAR (1000) NULL,
    [account_level_03_sort_key] VARCHAR (1000) NULL,
    [account_level_04_sort_key] VARCHAR (1000) NULL,
    [account_level_05_sort_key] VARCHAR (1000) NULL,
    [account_level_06_sort_key] VARCHAR (1000) NULL,
    [account_level_07_sort_key] VARCHAR (1000) NULL,
    [account_level_08_sort_key] VARCHAR (1000) NULL,
    [account_level_09_sort_key] VARCHAR (1000) NULL,
    [account_level_10_sort_key] VARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

