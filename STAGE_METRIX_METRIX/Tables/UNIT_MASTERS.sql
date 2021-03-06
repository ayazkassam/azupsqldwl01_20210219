﻿CREATE TABLE [STAGE_METRIX_METRIX].[UNIT_MASTERS] (
    [CREATE_USER]                    VARCHAR (30)   NOT NULL,
    [CREATE_PROGRAM]                 VARCHAR (120)  NULL,
    [CREATE_DATE_TIME]               DATETIME2 (7)  NOT NULL,
    [LAST_UPDATE_USER]               VARCHAR (30)   NOT NULL,
    [LAST_UPDATE_PROGRAM]            VARCHAR (120)  NULL,
    [LAST_UPDATE_DATE_TIME]          DATETIME2 (7)  NOT NULL,
    [LAST_UPDATE_AUDIT_ID]           NUMERIC (16)   NULL,
    [VERSION]                        NUMERIC (10)   NOT NULL,
    [SYS_ID]                         NUMERIC (16)   NOT NULL,
    [PRODUCTION_DATE]                NUMERIC (6)    NOT NULL,
    [NAME]                           VARCHAR (40)   NOT NULL,
    [GOVERNMENT_CODE]                VARCHAR (16)   NOT NULL,
    [COST_CENTRE_CODE]               VARCHAR (16)   NULL,
    [USER_DEFINED1]                  VARCHAR (16)   NULL,
    [USER_DEFINED2]                  VARCHAR (16)   NULL,
    [THIRD_TIER_EOR_FACTOR]          NUMERIC (6, 4) NULL,
    [CALCULATION_LEVEL]              VARCHAR (1)    NULL,
    [ROYALTY_ENTITY_SYS_ID]          NUMERIC (16)   NULL,
    [OIL_ROYALTY_ENTITY_SYS_ID]      NUMERIC (16)   NULL,
    [FACILITY_OPERATOR_ID]           VARCHAR (16)   NOT NULL,
    [PA_RESPONSIBLE_USER_ID]         VARCHAR (30)   NOT NULL,
    [UNIT_ID]                        VARCHAR (16)   NOT NULL,
    [MINERAL_OWNERSHIP_AT_TRAC_FLAG] VARCHAR (1)    NOT NULL,
    [ADJUSTING_BASE_VOLUME_FLAG]     VARCHAR (1)    NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

