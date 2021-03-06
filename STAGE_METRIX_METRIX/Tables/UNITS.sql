﻿CREATE TABLE [STAGE_METRIX_METRIX].[UNITS] (
    [CREATE_USER]           VARCHAR (30)  NOT NULL,
    [CREATE_PROGRAM]        VARCHAR (120) NULL,
    [CREATE_DATE_TIME]      DATETIME2 (7) NOT NULL,
    [LAST_UPDATE_USER]      VARCHAR (30)  NOT NULL,
    [LAST_UPDATE_PROGRAM]   VARCHAR (120) NULL,
    [LAST_UPDATE_DATE_TIME] DATETIME2 (7) NOT NULL,
    [LAST_UPDATE_AUDIT_ID]  NUMERIC (16)  NULL,
    [VERSION]               NUMERIC (10)  NOT NULL,
    [ID]                    VARCHAR (16)  NOT NULL,
    [PROVINCE]              VARCHAR (6)   NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

