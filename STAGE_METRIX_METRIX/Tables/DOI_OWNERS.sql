﻿CREATE TABLE [STAGE_METRIX_METRIX].[DOI_OWNERS] (
    [CREATE_USER]              VARCHAR (30)    NULL,
    [CREATE_DATE_TIME]         DATETIME2 (7)   NULL,
    [LAST_UPDATE_USER]         VARCHAR (30)    NULL,
    [LAST_UPDATE_DATE_TIME]    DATETIME2 (7)   NULL,
    [VERSION]                  NUMERIC (10)    NULL,
    [SYS_ID]                   NUMERIC (16)    NULL,
    [OWNER_INTEREST_PERCENT]   NUMERIC (11, 8) NULL,
    [GST_FOR_FACILITY_CHARGES] VARCHAR (1)     NULL,
    [EXCLUDE_OWNER]            VARCHAR (1)     NULL,
    [OWNER_ID]                 VARCHAR (16)    NULL,
    [DOI_MASTER_SYS_ID]        NUMERIC (16)    NULL,
    [CREATE_PROGRAM]           VARCHAR (120)   NULL,
    [LAST_UPDATE_PROGRAM]      VARCHAR (120)   NULL,
    [LAST_UPDATE_AUDIT_ID]     NUMERIC (16)    NULL,
    [SILENT_PARTNER_PARENT_ID] VARCHAR (16)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

