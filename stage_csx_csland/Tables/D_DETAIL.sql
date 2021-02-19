CREATE TABLE [stage_csx_csland].[D_DETAIL] (
    [DOI_ID]           NUMERIC (7)     NOT NULL,
    [OCCURRENCE]       NUMERIC (6)     NOT NULL,
    [PARTNER]          CHAR (6)        NULL,
    [PARTNER_PERCENT]  NUMERIC (11, 8) NULL,
    [SILENT_PARTNER]   VARCHAR (1)     NULL,
    [PARTNER_TYPE]     CHAR (10)       NULL,
    [PENALTY]          VARCHAR (1)     NULL,
    [SILENT_OWNER]     CHAR (6)        NULL,
    [TIK]              VARCHAR (1)     NULL,
    [EXTERNAL_USE]     VARCHAR (1)     NULL,
    [GST]              VARCHAR (1)     NULL,
    [SUSPENDED]        VARCHAR (1)     NULL,
    [SAP_PARTNER_TYPE] VARCHAR (1)     NULL,
    [NRI_CALC_YN]      VARCHAR (1)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

