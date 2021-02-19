CREATE TABLE [stage].[t_afenav_fieldcost_amounts] (
    [DOCUMENT_ID]         NVARCHAR (50)    NULL,
    [VERSION]             INT              NULL,
    [GROSS_AMOUNT]        NUMERIC (28, 14) NULL,
    [NET_AMOUNT]          NUMERIC (28, 14) NULL,
    [LISTITEM_ID]         NVARCHAR (50)    NULL,
    [AMOUNT_DATE]         DATETIME         NULL,
    [ACCOUNT]             NVARCHAR (50)    NULL,
    [AMOUNT_LOCKED]       TINYINT          NULL,
    [CALC_GROSS]          TINYINT          NULL,
    [CALC_NET]            TINYINT          NULL,
    [PHASE]               NVARCHAR (50)    NULL,
    [Copy of LISTITEM_ID] VARCHAR (50)     NULL,
    [Copy of DOCUMENT_ID] VARCHAR (50)     NULL,
    [Copy of ACCOUNT]     VARCHAR (50)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

