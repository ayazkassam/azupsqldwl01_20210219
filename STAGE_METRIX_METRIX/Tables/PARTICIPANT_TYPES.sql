﻿CREATE TABLE [STAGE_METRIX_METRIX].[PARTICIPANT_TYPES] (
    [CREATE_USER]                 VARCHAR (30)  NOT NULL,
    [CREATE_PROGRAM]              VARCHAR (120) NULL,
    [CREATE_DATE_TIME]            DATETIME2 (7) NOT NULL,
    [LAST_UPDATE_USER]            VARCHAR (30)  NOT NULL,
    [LAST_UPDATE_PROGRAM]         VARCHAR (120) NULL,
    [LAST_UPDATE_DATE_TIME]       DATETIME2 (7) NOT NULL,
    [LAST_UPDATE_AUDIT_ID]        NUMERIC (16)  NULL,
    [VERSION]                     NUMERIC (10)  NOT NULL,
    [DESCRIPTION]                 VARCHAR (60)  NOT NULL,
    [SHORT_DESCRIPTION]           VARCHAR (30)  NULL,
    [SORT_ORDER]                  NUMERIC (6)   NULL,
    [ACTIVE_VALUE]                VARCHAR (1)   NOT NULL,
    [CODE]                        VARCHAR (16)  NOT NULL,
    [IN_TRANSIT_USAGE]            VARCHAR (1)   NULL,
    [STORAGE_CROWN_ROYALTY_USAGE] VARCHAR (1)   NULL,
    [LINE_PACK_USAGE]             VARCHAR (1)   NULL,
    [INVENTORY_USAGE]             VARCHAR (1)   NULL,
    [OTHER_PURCHASER_USAGE]       VARCHAR (1)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

