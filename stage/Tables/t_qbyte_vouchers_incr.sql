CREATE TABLE [stage].[t_qbyte_vouchers_incr] (
    [VOUCHER_ID]          NUMERIC (10)    NULL,
    [VOUCHER_NUM]         NUMERIC (5)     NULL,
    [VOUCHER_TYPE_CODE]   VARCHAR (6)     NULL,
    [ORG_ID]              NUMERIC (4)     NULL,
    [ACCT_PER_DATE]       DATETIME        NULL,
    [CURR_CODE]           VARCHAR (6)     NULL,
    [SRC_CODE]            VARCHAR (6)     NULL,
    [VOUCHER_STAT_CODE]   VARCHAR (1)     NULL,
    [CREATE_DATE]         DATETIME        NULL,
    [CREATE_USER]         VARCHAR (30)    NULL,
    [CTRL_AMT]            NUMERIC (14, 2) NULL,
    [CTRL_VOL]            NUMERIC (12, 2) NULL,
    [GL_POSTING_DATE]     DATETIME        NULL,
    [CURR_CONV_DATE]      DATETIME        NULL,
    [SRC_MODULE_ID]       VARCHAR (20)    NULL,
    [VOUCHER_REM]         VARCHAR (40)    NULL,
    [GL_POST_USER]        VARCHAR (30)    NULL,
    [LAST_UPDATE_DATE]    DATETIME        NULL,
    [LAST_UPDATE_USER]    VARCHAR (30)    NULL,
    [VOUCHER_REVERSAL_ID] NUMERIC (10)    NULL,
    [JIB_RUN_NUM]         NUMERIC (2)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

