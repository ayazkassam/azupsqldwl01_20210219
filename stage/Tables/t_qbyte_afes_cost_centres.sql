CREATE TABLE [stage].[t_qbyte_afes_cost_centres] (
    [CREATE_DATE]          DATETIME      NULL,
    [CREATE_USER]          VARCHAR (30)  NULL,
    [AFE_NUM]              VARCHAR (10)  NULL,
    [CC_NUM]               VARCHAR (10)  NULL,
    [LAST_UPDATE_USER]     VARCHAR (30)  NULL,
    [LAST_UPDATE_DATE]     DATETIME      NULL,
    [CREATE_PROGRAM]       VARCHAR (100) NULL,
    [LAST_UPDATE_AUDIT_ID] NUMERIC (10)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

