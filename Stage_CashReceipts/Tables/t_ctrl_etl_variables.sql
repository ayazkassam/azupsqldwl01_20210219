CREATE TABLE [Stage_CashReceipts].[t_ctrl_etl_variables] (
    [VARIABLE_NAME]  VARCHAR (200)  NULL,
    [VARIABLE_VALUE] VARCHAR (200)  NULL,
    [COMMENTS]       VARCHAR (1000) NULL,
    [DATE_VALUE]     DATETIME       NULL,
    [INT_VALUE]      INT            NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

