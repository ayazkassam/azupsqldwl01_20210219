﻿CREATE TABLE [STAGE_METRIX_METRIX].[DOI_MASTERS] (
    [CREATE_USER]                 VARCHAR (30)  NULL,
    [CREATE_PROGRAM]              VARCHAR (120) NULL,
    [CREATE_DATE_TIME]            DATETIME2 (7) NULL,
    [LAST_UPDATE_USER]            VARCHAR (30)  NULL,
    [LAST_UPDATE_PROGRAM]         VARCHAR (120) NULL,
    [LAST_UPDATE_DATE_TIME]       DATETIME2 (7) NULL,
    [LAST_UPDATE_AUDIT_ID]        NUMERIC (16)  NULL,
    [VERSION]                     NUMERIC (10)  NULL,
    [SYS_ID]                      NUMERIC (16)  NULL,
    [SUB_ID]                      VARCHAR (16)  NULL,
    [EFFECTIVE_DATE]              NUMERIC (6)   NULL,
    [USER_DEFINED1]               VARCHAR (30)  NULL,
    [DEFAULT_DOI]                 VARCHAR (1)   NULL,
    [DIVISION_OF_INTEREST_SYS_ID] NUMERIC (16)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

