﻿CREATE TABLE [STAGE_METRIX].[t_stg_metrix_facility_charges] (
    [CREATE_USER]                VARCHAR (30)  NULL,
    [CREATE_PROGRAM]             VARCHAR (120) NULL,
    [CREATE_DATE_TIME]           DATETIME2 (7) NULL,
    [LAST_UPDATE_USER]           VARCHAR (30)  NULL,
    [LAST_UPDATE_PROGRAM]        VARCHAR (120) NULL,
    [LAST_UPDATE_DATE_TIME]      DATETIME2 (7) NULL,
    [LAST_UPDATE_AUDIT_ID]       NUMERIC (18)  NULL,
    [VERSION]                    NUMERIC (18)  NULL,
    [SYS_ID]                     NUMERIC (18)  NULL,
    [PRODUCTION_DATE]            NUMERIC (18)  NULL,
    [SEQUENCE_NUMBER]            NUMERIC (18)  NULL,
    [EXPENSE_DOI_EXTENSION]      NUMERIC (18)  NULL,
    [REVENUE_DOI_EXTENSION]      NUMERIC (18)  NULL,
    [OWNER_SELECTION]            VARCHAR (6)   NULL,
    [FROM_TO_SELECTION]          VARCHAR (6)   NULL,
    [PURCHASER_SELECTION]        VARCHAR (6)   NULL,
    [ENTITY_SELECTION]           VARCHAR (1)   NULL,
    [GST_APPLICABLE]             VARCHAR (1)   NULL,
    [BOOK_AT_UNIT]               VARCHAR (1)   NULL,
    [CONTROL_GROUP_ID]           VARCHAR (16)  NULL,
    [FACILITY_CHARGE_FORMULA_ID] VARCHAR (16)  NULL,
    [FACILITY_SYS_ID]            NUMERIC (18)  NULL,
    [PRODUCT_CODE]               VARCHAR (16)  NULL,
    [UNIT_ID]                    VARCHAR (16)  NULL,
    [CHARGE_TYPE_CODE]           VARCHAR (16)  NULL,
    [REVENUE_COST_CENTRE_CODE]   VARCHAR (16)  NULL,
    [ENTITY_SELECTION_TYPE]      VARCHAR (6)   NULL,
    [ACTIVE_FLAG]                VARCHAR (1)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

