CREATE TABLE [stage].[t_qbyte_special_exchange_rates] (
    [ORG_ID]                 NUMERIC (4)      NULL,
    [CREATE_USER]            VARCHAR (30)     NULL,
    [CREATE_DATE]            DATETIME         NULL,
    [LAST_UPDATE_USER]       VARCHAR (30)     NULL,
    [LAST_UPDATE_DATE]       DATETIME         NULL,
    [ACCT_PER_DATE]          DATETIME         NULL,
    [SPECIAL_CURR_RATE_CODE] VARCHAR (6)      NULL,
    [FROM_CURR_CODE]         VARCHAR (6)      NULL,
    [TO_CURR_CODE]           VARCHAR (6)      NULL,
    [EXCHANGE_RATE]          NUMERIC (14, 10) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

