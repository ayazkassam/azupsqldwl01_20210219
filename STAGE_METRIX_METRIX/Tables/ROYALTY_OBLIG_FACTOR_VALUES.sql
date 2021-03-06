﻿CREATE TABLE [STAGE_METRIX_METRIX].[ROYALTY_OBLIG_FACTOR_VALUES] (
    [SYS_ID]                    NUMERIC (18)    NULL,
    [CREATE_USER]               VARCHAR (30)    NULL,
    [CREATE_PROGRAM]            VARCHAR (120)   NULL,
    [CREATE_DATE_TIME]          DATETIME2 (7)   NULL,
    [LAST_UPDATE_USER]          VARCHAR (30)    NULL,
    [LAST_UPDATE_PROGRAM]       VARCHAR (120)   NULL,
    [LAST_UPDATE_DATE_TIME]     DATETIME2 (7)   NULL,
    [LAST_UPDATE_AUDIT_ID]      NUMERIC (18)    NULL,
    [VERSION]                   NUMERIC (18)    NULL,
    [PRODUCTION_DATE]           NUMERIC (18)    NULL,
    [ROYALTY_GLOBAL_FACTOR_ID]  VARCHAR (16)    NULL,
    [ROYALTY_OBLIGATION_SYS_ID] NUMERIC (18)    NULL,
    [FACTOR]                    NUMERIC (18, 8) NULL,
    [REQUIRED_FLAG]             VARCHAR (1)     NULL,
    [OBL_GLOBAL_FACTOR_ID]      VARCHAR (16)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

