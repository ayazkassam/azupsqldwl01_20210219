﻿CREATE TABLE [STAGE_METRIX_METRIX].[FC_FORMULA_RETRIEVALS] (
    [CREATE_USER]               VARCHAR (30)  NOT NULL,
    [CREATE_DATE_TIME]          DATETIME2 (7) NOT NULL,
    [LAST_UPDATE_USER]          VARCHAR (30)  NOT NULL,
    [LAST_UPDATE_DATE_TIME]     DATETIME2 (7) NOT NULL,
    [VERSION]                   NUMERIC (10)  NOT NULL,
    [ACTIVE_VALUE]              VARCHAR (1)   NOT NULL,
    [CODE]                      VARCHAR (16)  NOT NULL,
    [CALCULATION_BASED_FLAG]    VARCHAR (1)   NOT NULL,
    [ENTITY_EXCEPTIONS_FLAG]    VARCHAR (1)   NOT NULL,
    [FROM_TO_EXCEPTIONS_FLAG]   VARCHAR (1)   NOT NULL,
    [PURCHASER_EXCEPTIONS_FLAG] VARCHAR (1)   NOT NULL,
    [UNIT_WELL_FLAG]            VARCHAR (1)   NOT NULL,
    [UNIT_TRACT_FLAG]           VARCHAR (1)   NOT NULL,
    [CATEGORY]                  VARCHAR (6)   NOT NULL,
    [BATTERY_USAGE]             VARCHAR (6)   NOT NULL,
    [GGS_USAGE]                 VARCHAR (6)   NOT NULL,
    [PLANT_USAGE]               VARCHAR (6)   NOT NULL,
    [UNIT_USAGE]                VARCHAR (6)   NOT NULL,
    [OIL_USAGE]                 VARCHAR (6)   NOT NULL,
    [WATER_USAGE]               VARCHAR (6)   NOT NULL,
    [NA_USAGE]                  VARCHAR (6)   NOT NULL,
    [GAS_USAGE]                 VARCHAR (6)   NOT NULL,
    [BYP_USAGE]                 VARCHAR (6)   NOT NULL,
    [CREATE_PROGRAM]            VARCHAR (120) NULL,
    [LAST_UPDATE_PROGRAM]       VARCHAR (120) NULL,
    [LAST_UPDATE_AUDIT_ID]      NUMERIC (16)  NULL,
    [DESCRIPTION]               VARCHAR (60)  NULL,
    [SHORT_DESCRIPTION]         VARCHAR (30)  NULL,
    [SORT_ORDER]                NUMERIC (6)   NULL,
    [USAGE_DETAILS]             VARCHAR (600) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

