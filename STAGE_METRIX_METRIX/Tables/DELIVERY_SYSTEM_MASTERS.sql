﻿CREATE TABLE [STAGE_METRIX_METRIX].[DELIVERY_SYSTEM_MASTERS] (
    [CREATE_USER]                  VARCHAR (30)  NOT NULL,
    [CREATE_PROGRAM]               VARCHAR (120) NULL,
    [CREATE_DATE_TIME]             DATETIME2 (7) NOT NULL,
    [LAST_UPDATE_USER]             VARCHAR (30)  NOT NULL,
    [LAST_UPDATE_PROGRAM]          VARCHAR (120) NULL,
    [LAST_UPDATE_DATE_TIME]        DATETIME2 (7) NOT NULL,
    [LAST_UPDATE_AUDIT_ID]         NUMERIC (16)  NULL,
    [VERSION]                      NUMERIC (10)  NOT NULL,
    [SYS_ID]                       NUMERIC (16)  NOT NULL,
    [PRODUCTION_DATE]              NUMERIC (6)   NOT NULL,
    [NAME]                         VARCHAR (40)  NOT NULL,
    [GOVERNMENT_CODE]              VARCHAR (16)  NOT NULL,
    [USER_DEFINED1]                VARCHAR (16)  NULL,
    [USER_DEFINED2]                VARCHAR (16)  NULL,
    [REGISTRY_PROVINCE]            VARCHAR (2)   NULL,
    [REGISTRY_ENTITY_TYPE]         VARCHAR (2)   NULL,
    [REGISTRY_GOVERNMENT_CODE]     VARCHAR (16)  NULL,
    [PRA_FACILITY]                 VARCHAR (1)   NULL,
    [OIL_PIPELINE_SPLIT]           VARCHAR (1)   NULL,
    [GAS_PIPELINE_SPLIT]           VARCHAR (1)   NULL,
    [END_OF_STREAM_FACILITY]       VARCHAR (1)   NULL,
    [CTP_REGISTRY_PROVINCE]        VARCHAR (2)   NULL,
    [CTP_REGISTRY_GOVERNMENT_CODE] VARCHAR (16)  NULL,
    [CTP_REGISTRY_ENTITY_TYPE]     VARCHAR (2)   NULL,
    [FACILITY_OPERATOR_ID]         VARCHAR (16)  NOT NULL,
    [OIL_CTP_PRODUCT_CODE]         VARCHAR (16)  NULL,
    [DELIVERY_SYSTEM_ID]           VARCHAR (16)  NOT NULL,
    [PSEUDO_FACILITY_FLAG]         VARCHAR (1)   NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
