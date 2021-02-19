﻿CREATE TABLE [STAGE_METRIX_METRIX].[TRACT_MASTERS] (
    [CREATE_USER]                 VARCHAR (30)    NOT NULL,
    [CREATE_PROGRAM]              VARCHAR (120)   NULL,
    [CREATE_DATE_TIME]            DATETIME2 (7)   NOT NULL,
    [LAST_UPDATE_USER]            VARCHAR (30)    NOT NULL,
    [LAST_UPDATE_PROGRAM]         VARCHAR (120)   NULL,
    [LAST_UPDATE_DATE_TIME]       DATETIME2 (7)   NOT NULL,
    [LAST_UPDATE_AUDIT_ID]        NUMERIC (16)    NULL,
    [VERSION]                     NUMERIC (10)    NOT NULL,
    [SYS_ID]                      NUMERIC (16)    NOT NULL,
    [PRODUCTION_DATE]             NUMERIC (6)     NOT NULL,
    [NAME]                        VARCHAR (40)    NOT NULL,
    [LEGAL_PRESENTATION]          VARCHAR (30)    NOT NULL,
    [REPORT_LIQUID_AS_CONDENSATE] VARCHAR (1)     NULL,
    [COST_CENTRE_CODE]            VARCHAR (16)    NULL,
    [TRACT_ID]                    VARCHAR (16)    NOT NULL,
    [CROWN_MINERAL_PERCENT]       NUMERIC (11, 8) NOT NULL,
    [FREEHOLD_MINERAL_PERCENT]    NUMERIC (11, 8) NOT NULL,
    [FEDERAL_MINERAL_PERCENT]     NUMERIC (11, 8) NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
