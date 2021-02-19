CREATE TABLE [dbo].[Parse_Hierarchy_Path_20200612] (
    [Hierarchy_Path]   VARCHAR (1000) NULL,
    [account_level_01] VARCHAR (1000) NULL,
    [account_level_02] VARCHAR (1000) NULL,
    [account_level_03] VARCHAR (1000) NULL,
    [account_level_04] VARCHAR (1000) NULL,
    [account_level_05] VARCHAR (1000) NULL,
    [account_level_06] VARCHAR (1000) NULL,
    [account_level_07] VARCHAR (1000) NULL,
    [account_level_08] VARCHAR (1000) NULL,
    [account_level_09] VARCHAR (1000) NULL,
    [account_level_10] VARCHAR (1000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

