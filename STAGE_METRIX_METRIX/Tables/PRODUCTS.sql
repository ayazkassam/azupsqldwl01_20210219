﻿CREATE TABLE [STAGE_METRIX_METRIX].[PRODUCTS] (
    [CREATE_USER]                    VARCHAR (30)    NULL,
    [CREATE_PROGRAM]                 VARCHAR (120)   NULL,
    [CREATE_DATE_TIME]               DATETIME2 (7)   NULL,
    [LAST_UPDATE_USER]               VARCHAR (30)    NULL,
    [LAST_UPDATE_PROGRAM]            VARCHAR (120)   NULL,
    [LAST_UPDATE_DATE_TIME]          DATETIME2 (7)   NULL,
    [LAST_UPDATE_AUDIT_ID]           NUMERIC (18)    NULL,
    [VERSION]                        NUMERIC (18)    NULL,
    [DESCRIPTION]                    VARCHAR (60)    NULL,
    [SHORT_DESCRIPTION]              VARCHAR (30)    NULL,
    [SORT_ORDER]                     NUMERIC (18)    NULL,
    [ACTIVE_VALUE]                   VARCHAR (1)     NULL,
    [CODE]                           VARCHAR (16)    NULL,
    [GENERAL_USAGE]                  VARCHAR (1)     NULL,
    [OIL_GAS_USAGE]                  VARCHAR (1)     NULL,
    [GAS_DISPOSITION_USAGE]          VARCHAR (1)     NULL,
    [NON_GAS_DISPOSITION_USAGE]      VARCHAR (1)     NULL,
    [BATTERY_DISPOSITION_USAGE]      VARCHAR (1)     NULL,
    [COMBINE_NGL_USAGE]              VARCHAR (1)     NULL,
    [FINANCIAL_INTERFACE_USAGE]      VARCHAR (1)     NULL,
    [PARTNER_OPERATED_USAGE]         VARCHAR (1)     NULL,
    [FACILITY_CHARGE_USAGE]          VARCHAR (1)     NULL,
    [INJECTION_SUMMARY_USAGE]        VARCHAR (1)     NULL,
    [INJECTION_RECEIPT_USAGE]        VARCHAR (1)     NULL,
    [INJECTION_DELIVERY_USAGE]       VARCHAR (1)     NULL,
    [INJECTION_DISPOSAL_USAGE]       VARCHAR (1)     NULL,
    [FDC_INJECTION_USAGE]            VARCHAR (1)     NULL,
    [FDC_ADJUSTMENT_USAGE]           VARCHAR (1)     NULL,
    [INJECTION_SUMMARY_CODE]         VARCHAR (16)    NULL,
    [INJECTION_SUMMARY_REPORT_CODE]  VARCHAR (2)     NULL,
    [INJECTION_RECEIPT_REPORT_CODE]  VARCHAR (2)     NULL,
    [INJECTION_DELIVERY_REPORT_CODE] VARCHAR (2)     NULL,
    [INJECTION_DISPOSAL_REPORT_CODE] VARCHAR (2)     NULL,
    [BASE_PRODUCT_USAGE]             VARCHAR (1)     NULL,
    [CTP_OIL_USAGE]                  VARCHAR (1)     NULL,
    [REPORT_AS_USAGE]                VARCHAR (1)     NULL,
    [INJECTION_CONSUMPTION_USAGE]    VARCHAR (1)     NULL,
    [GEQ_ALLOWED_FLAG]               VARCHAR (1)     NULL,
    [COMPOSITION_ALLOWED_FLAG]       VARCHAR (1)     NULL,
    [GIGAJOULES_ALLOWED_FLAG]        VARCHAR (1)     NULL,
    [GAS_BYPRODUCT_USAGE]            VARCHAR (1)     NULL,
    [GAS_EQUIVALENT_FACTOR]          NUMERIC (11, 8) NULL,
    [REPORT_OIL_AS_USAGE]            VARCHAR (1)     NULL,
    [REPORT_WATER_AS_USAGE]          VARCHAR (1)     NULL,
    [PARENT_PRODUCT_CODE]            VARCHAR (16)    NULL,
    [ROYALTY_BYP_USAGE]              VARCHAR (1)     NULL,
    [OBLIG_USAGE]                    VARCHAR (1)     NULL,
    [MIX_FLAG]                       VARCHAR (1)     NULL,
    [SPEC_FLAG]                      VARCHAR (1)     NULL,
    [SPEC_PRODUCT_CODE]              VARCHAR (16)    NULL,
    [PARENT_SPEC_PRODUCT_CODE]       VARCHAR (16)    NULL,
    [NGL_VAL_REPORTING_PROD_CODE]    VARCHAR (16)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

