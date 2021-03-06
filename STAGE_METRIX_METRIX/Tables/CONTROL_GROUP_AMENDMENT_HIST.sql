﻿CREATE TABLE [STAGE_METRIX_METRIX].[CONTROL_GROUP_AMENDMENT_HIST] (
    [CREATE_USER]               VARCHAR (30)  NULL,
    [CREATE_PROGRAM]            VARCHAR (120) NULL,
    [CREATE_DATE_TIME]          DATETIME2 (7) NULL,
    [LAST_UPDATE_USER]          VARCHAR (30)  NULL,
    [LAST_UPDATE_PROGRAM]       VARCHAR (120) NULL,
    [LAST_UPDATE_DATE_TIME]     DATETIME2 (7) NULL,
    [LAST_UPDATE_AUDIT_ID]      NUMERIC (16)  NULL,
    [VERSION]                   NUMERIC (10)  NULL,
    [SYS_ID]                    NUMERIC (16)  NULL,
    [PRODUCTION_DATE]           NUMERIC (6)   NULL,
    [CONTROL_GROUP_ID]          VARCHAR (16)  NULL,
    [REQUESTED_DATE_TIME]       DATETIME2 (7) NULL,
    [REQUESTED_BY_USER]         VARCHAR (30)  NULL,
    [AMENDMENT_REASON]          VARCHAR (255) NULL,
    [OPEN_FROM_STEP_NUMBER]     VARCHAR (6)   NULL,
    [ASSIGNED_TO_USER]          VARCHAR (30)  NULL,
    [SCHEDULED_DATE_TIME]       DATETIME2 (7) NULL,
    [SCHEDULED_BY_USER]         VARCHAR (30)  NULL,
    [CLOSED_DATE_TIME]          DATETIME2 (7) NULL,
    [CLOSED_BY_USER]            VARCHAR (30)  NULL,
    [CLOSED_ACCOUNTING_DATE]    NUMERIC (6)   NULL,
    [RESET_ALL_FACILITIES_FLAG] VARCHAR (1)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

