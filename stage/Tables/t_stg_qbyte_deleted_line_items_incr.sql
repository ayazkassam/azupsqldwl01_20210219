﻿CREATE TABLE [stage].[t_stg_qbyte_deleted_line_items_incr] (
    [AUDIT_ACTION]                  VARCHAR (6)      NULL,
    [AUDIT_USER]                    VARCHAR (30)     NULL,
    [AUDIT_TIMESTAMP]               VARCHAR (50)     NULL,
    [AUDIT_PROGRAM]                 VARCHAR (100)    NULL,
    [LI_ID]                         NUMERIC (10)     NULL,
    [VOUCHER_ID]                    NUMERIC (10)     NULL,
    [LI_ORIGIN_CODE]                VARCHAR (3)      NULL,
    [MAJOR_ACCT]                    VARCHAR (4)      NULL,
    [MINOR_ACCT]                    VARCHAR (4)      NULL,
    [LI_AMT]                        NUMERIC (14, 2)  NULL,
    [GL_SUB_CODE]                   VARCHAR (6)      NULL,
    [AFE_ITEM_NUM]                  VARCHAR (6)      NULL,
    [DEST_ORG_ID]                   NUMERIC (4)      NULL,
    [LI_TYPE_CODE]                  VARCHAR (3)      NULL,
    [REPORTING_CURR_AMT]            NUMERIC (14, 2)  NULL,
    [GST_AMT]                       NUMERIC (14, 2)  NULL,
    [GST_FACTOR]                    NUMERIC (14, 10) NULL,
    [ORG_REP_CURR_AMT]              NUMERIC (14, 2)  NULL,
    [ORG_REP_CURR_TRANSLATION_RATE] NUMERIC (14, 10) NULL,
    [ORG_REP_CURR_GROSS_UP_AMT]     NUMERIC (14, 2)  NULL,
    [LI_VOL]                        NUMERIC (12, 2)  NULL,
    [TRANSLATION_RATE]              NUMERIC (14, 10) NULL,
    [ACTVY_PER_DATE]                DATETIME         NULL,
    [ALLOC_DATE]                    DATETIME         NULL,
    [BILLED_DATE]                   DATETIME         NULL,
    [AFE_NUM]                       VARCHAR (10)     NULL,
    [CONTINUITY_CODE]               VARCHAR (6)      NULL,
    [CASH_TX_ID]                    NUMERIC (10)     NULL,
    [CC_NUM]                        VARCHAR (10)     NULL,
    [SRC_INVC_ID]                   NUMERIC (10)     NULL,
    [RESULT_INVC_ID]                NUMERIC (10)     NULL,
    [ORIGINAL_LI_ID]                NUMERIC (10)     NULL,
    [SRC_AGR_ID]                    NUMERIC (10)     NULL,
    [SRC_AGR_TYPE_CODE]             VARCHAR (2)      NULL,
    [GOVERN_AGR_ID]                 NUMERIC (10)     NULL,
    [GOVERN_AGR_TYPE_CODE]          VARCHAR (2)      NULL,
    [GROSS_UP_AMT]                  NUMERIC (14, 2)  NULL,
    [GROSS_UP_VOL]                  NUMERIC (12, 2)  NULL,
    [LI_REM]                        VARCHAR (72)     NULL,
    [ET_ID]                         NUMERIC (10)     NULL,
    [REPORTING_CURR_GROSS_UP_AMT]   NUMERIC (14, 2)  NULL,
    [LI_AS_ENTERED_VOL]             NUMERIC (12, 2)  NULL,
    [ALLOC_LI_ID]                   NUMERIC (10)     NULL,
    [PRE_TAX_AMT]                   NUMERIC (14, 2)  NULL,
    [REPORTING_CURR_GST_AMT]        NUMERIC (14, 2)  NULL,
    [LI_ENERGY_AMOUNT]              NUMERIC (12, 2)  NULL,
    [WAREHOUSE_HANDLING_FLAG]       VARCHAR (1)      NULL,
    [GROSS_UP_ENERGY_VAL]           NUMERIC (12, 2)  NULL,
    [JIB_REVERSED_FLAG]             VARCHAR (1)      NULL,
    [DISCOUNT_AMT]                  NUMERIC (14, 2)  NULL,
    [MISCELLANEOUS_INCOME_CATEGORY] VARCHAR (30)     NULL,
    [GOVERN_AGR_OVERRIDE_FLAG]      VARCHAR (1)      NULL,
    [CREATE_DATE]                   DATETIME         NULL,
    [CREATE_USER]                   VARCHAR (30)     NULL,
    [LAST_UPDATE_DATE]              DATETIME         NULL,
    [LAST_UPDATE_USER]              VARCHAR (30)     NULL,
    [ALLOCATION_REVERSED_FLAG]      VARCHAR (1)      NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

