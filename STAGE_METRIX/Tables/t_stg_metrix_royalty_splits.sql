﻿CREATE TABLE [STAGE_METRIX].[t_stg_metrix_royalty_splits] (
    [CREATE_USER]               VARCHAR (30)    NOT NULL,
    [CREATE_PROGRAM]            VARCHAR (120)   NULL,
    [CREATE_DATE_TIME]          DATETIME2 (7)   NOT NULL,
    [LAST_UPDATE_USER]          VARCHAR (30)    NOT NULL,
    [LAST_UPDATE_PROGRAM]       VARCHAR (120)   NULL,
    [LAST_UPDATE_DATE_TIME]     DATETIME2 (7)   NOT NULL,
    [LAST_UPDATE_AUDIT_ID]      NUMERIC (16)    NULL,
    [VERSION]                   NUMERIC (10)    NOT NULL,
    [SYS_ID]                    NUMERIC (16)    NOT NULL,
    [PRODUCTION_DATE]           NUMERIC (6)     NOT NULL,
    [OBLIGATION_TYPE]           VARCHAR (6)     NOT NULL,
    [ROYALTY_VALUE]             NUMERIC (11, 2) NULL,
    [ROYALTY_VOLUME]            NUMERIC (9, 1)  NULL,
    [SHARE_TYPE]                VARCHAR (1)     NULL,
    [PAYMENT_TYPE]              VARCHAR (6)     NULL,
    [WORKING_INTEREST]          NUMERIC (11, 8) NULL,
    [ROYALTY_HOLIDAY]           VARCHAR (1)     NULL,
    [OBLIGATION_TOTAL_VALUE]    NUMERIC (11, 2) NULL,
    [OBLIGATION_TOTAL_VOLUME]   NUMERIC (9, 1)  NULL,
    [CROWN_CLASSIFICATION]      VARCHAR (6)     NULL,
    [UNITIZATION_TYPE]          VARCHAR (6)     NULL,
    [DOI_SUB_USED]              VARCHAR (12)    NULL,
    [WORKING_INTEREST_PERCENT]  NUMERIC (11, 8) NULL,
    [SILENT_PARTNER_OWNER]      VARCHAR (1)     NULL,
    [TAX_TYPE]                  VARCHAR (6)     NULL,
    [GROSS_NRT]                 NUMERIC (11, 2) NULL,
    [REPORT_AS_CONDENSATE]      VARCHAR (1)     NULL,
    [CROWN_ADJUSTMENT_VALUE]    NUMERIC (11, 2) NULL,
    [WELL_USER_DEFINED1]        VARCHAR (16)    NULL,
    [BATTERY_FACILITY_ID]       VARCHAR (16)    NULL,
    [CONTROL_GROUP_ID]          VARCHAR (16)    NULL,
    [ROYALTY_OBLIGATION_SYS_ID] NUMERIC (16)    NULL,
    [FACILITY_SYS_ID]           NUMERIC (16)    NULL,
    [DOI_OWNER_ID]              VARCHAR (16)    NOT NULL,
    [ROYALTY_OWNER_ID]          VARCHAR (16)    NULL,
    [WELL_TRACT_SYS_ID]         NUMERIC (16)    NOT NULL,
    [PRODUCT_CODE]              VARCHAR (16)    NULL,
    [UNIT_ID]                   VARCHAR (16)    NULL,
    [ROYALTY_NRT_VALUE]         NUMERIC (11, 2) NULL,
    [ROYALTY_NRT_VOLUME]        NUMERIC (9, 1)  NULL,
    [GROSS_NRT_VOLUME]          NUMERIC (9, 1)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

