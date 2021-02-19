CREATE TABLE [stage].[t_ctrl_accounts_xref] (
    [source_app]        VARCHAR (30)  NOT NULL,
    [source_table]      VARCHAR (30)  NOT NULL,
    [source_column]     VARCHAR (30)  NOT NULL,
    [source_major_acct] VARCHAR (10)  NULL,
    [source_minor_acct] VARCHAR (10)  NULL,
    [account]           VARCHAR (21)  NULL,
    [source_desc]       VARCHAR (150) NULL,
    [target_major_acct] VARCHAR (10)  NULL,
    [target_minor_acct] VARCHAR (10)  NULL,
    [target_account]    VARCHAR (100) NOT NULL,
    [target_parent]     VARCHAR (100) NULL,
    [target_app]        VARCHAR (15)  NOT NULL,
    [is_active]         VARCHAR (1)   NULL,
    [sort_key]          VARCHAR (100) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

