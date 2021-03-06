﻿CREATE TABLE [stage].[t_qbyte_invoices] (
    [CREATE_DATE]                    DATETIME         NULL,
    [CREATE_USER]                    VARCHAR (32)     NULL,
    [INVC_TYPE_CODE]                 VARCHAR (3)      NULL,
    [PAYABLE_OR_RECEIVABLE_CODE]     VARCHAR (1)      NULL,
    [CREDIT_DAYS]                    NUMERIC (3)      NULL,
    [INVC_ID]                        NUMERIC (10)     NULL,
    [INVC_NUM]                       VARCHAR (20)     NULL,
    [INVC_DATE]                      DATETIME         NULL,
    [CLIENT_ID]                      NUMERIC (6)      NULL,
    [INVC_AMT]                       NUMERIC (14, 2)  NULL,
    [INVC_ORIGIN_CODE]               VARCHAR (3)      NULL,
    [PAY_STAT_CODE]                  VARCHAR (1)      NULL,
    [PRIORITY_CODE]                  VARCHAR (1)      NULL,
    [RCVD_DATE]                      DATETIME         NULL,
    [DUE_DATE]                       DATETIME         NULL,
    [HOLD_DATE]                      DATETIME         NULL,
    [SENT_FOR_APPROVAL_DATE]         DATETIME         NULL,
    [APPROVAL_DATE]                  DATETIME         NULL,
    [APPROVAL_REM]                   VARCHAR (60)     NULL,
    [SENT_TO]                        VARCHAR (30)     NULL,
    [GST_AMT]                        NUMERIC (14, 2)  NULL,
    [GST_FACTOR]                     NUMERIC (14, 10) NULL,
    [RELEASE_FOR_PAYMENT_AMT]        NUMERIC (14, 2)  NULL,
    [SEPARATE_CHQ_FLAG]              VARCHAR (1)      NULL,
    [AFE_NUM]                        VARCHAR (10)     NULL,
    [CC_NUM]                         VARCHAR (10)     NULL,
    [INVC_REM]                       VARCHAR (120)    NULL,
    [VOUCHER_ID]                     NUMERIC (10)     NULL,
    [NRWT_AMT]                       NUMERIC (14, 2)  NULL,
    [ALTERNATE_ADDRESS_ID]           NUMERIC (6)      NULL,
    [PURCHASE_ORDER_NUM]             VARCHAR (20)     NULL,
    [ATTACHMENT_REQD_FLAG]           VARCHAR (1)      NULL,
    [CONTRACT_NUM]                   VARCHAR (20)     NULL,
    [PST_AMT]                        NUMERIC (14, 2)  NULL,
    [GST_DISTRIBUTION_AMT]           NUMERIC (14, 2)  NULL,
    [PAYMENT_CODE]                   VARCHAR (3)      NULL,
    [DISCOUNT_DUE_DATE]              DATETIME         NULL,
    [DISCOUNT_AMT]                   NUMERIC (14, 2)  NULL,
    [DISCOUNT_ACHIEVED]              VARCHAR (1)      NULL,
    [MISCELLANEOUS_INCOME_AMT]       NUMERIC (14, 2)  NULL,
    [WITHHOLDING_TAX_AMT]            NUMERIC (14, 2)  NULL,
    [INVOICE_APPROVAL_INDIVIDUAL_ID] NUMERIC (10)     NULL,
    [ALTERNATE_CLIENT_ID]            NUMERIC (6)      NULL,
    [PAYMENT_FORMAT_CODE]            VARCHAR (6)      NULL,
    [PAYMENT_HANDLING_CODE]          VARCHAR (2)      NULL,
    [CHQ_MAIL_TYPE_CODE]             VARCHAR (2)      NULL,
    [LAST_UPDATE_DATE]               DATETIME         NULL,
    [LAST_UPDATE_USER]               VARCHAR (30)     NULL,
    [ORG_ID]                         NUMERIC (4)      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

