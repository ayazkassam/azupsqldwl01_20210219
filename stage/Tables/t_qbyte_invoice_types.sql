CREATE TABLE [stage].[t_qbyte_invoice_types] (
    [CREATE_DATE]                DATETIME     NULL,
    [CREATE_USER]                VARCHAR (32) NULL,
    [INVC_TYPE_CODE]             VARCHAR (3)  NULL,
    [PAYABLE_OR_RECEIVABLE_CODE] VARCHAR (1)  NULL,
    [CTRL_MAJOR_ACCT]            VARCHAR (4)  NULL,
    [CTRL_MINOR_ACCT]            VARCHAR (4)  NULL,
    [INVC_TYPE_DESC]             VARCHAR (80) NULL,
    [PURCHASE_ORDER_REQD_FLAG]   VARCHAR (1)  NULL,
    [LAST_UPDT_USER]             VARCHAR (32) NULL,
    [LAST_UPDT_DATE]             DATETIME     NULL,
    [CREDIT_DAYS]                NUMERIC (3)  NULL,
    [CREDIT_ANALYST]             VARCHAR (20) NULL,
    [AUTO_CALC_INVC_GST_FLAG]    VARCHAR (1)  NULL,
    [CASH_CALL_FLAG]             VARCHAR (1)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

