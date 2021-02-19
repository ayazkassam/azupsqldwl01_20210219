CREATE TABLE [Stage_CashReceipts].[PA_Splits_Current] (
    [ARContract]       NVARCHAR (100) NULL,
    [ProdMonth]        NVARCHAR (10)  NULL,
    [AcctMonth]        NVARCHAR (10)  NULL,
    [ControlGroup]     NVARCHAR (100) NULL,
    [PA]               NVARCHAR (100) NULL,
    [Volume]           FLOAT (53)     NULL,
    [Energy]           FLOAT (53)     NULL,
    [Revenue]          FLOAT (53)     NULL,
    [Owner]            NVARCHAR (100) NULL,
    [last_update_date] DATETIME2 (7)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

