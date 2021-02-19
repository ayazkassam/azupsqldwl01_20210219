CREATE TABLE [stage].[CTE_v_valnav_netback_accounts] (
    [Level]      INT           NULL,
    [account_id] VARCHAR (100) NULL,
    [parent_id]  VARCHAR (100) NULL,
    [Path1]      VARCHAR (100) NULL,
    [Path2]      VARCHAR (100) NULL,
    [Path3]      VARCHAR (100) NULL,
    [Path4]      VARCHAR (100) NULL,
    [Path5]      VARCHAR (100) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

