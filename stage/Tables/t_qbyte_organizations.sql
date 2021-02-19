CREATE TABLE [stage].[t_qbyte_organizations] (
    [CREATE_DATE]                    DATETIME     NULL,
    [CREATE_USER]                    VARCHAR (32) NULL,
    [ORG_ID]                         NUMERIC (4)  NULL,
    [ORG_TYPE_CODE]                  VARCHAR (1)  NULL,
    [ORG_NAME]                       VARCHAR (40) NULL,
    [OP_CURR_CODE]                   VARCHAR (6)  NULL,
    [REPORTING_CURR_CODE]            VARCHAR (6)  NULL,
    [LAST_UPDT_DATE]                 DATETIME     NULL,
    [LAST_UPDT_USER]                 VARCHAR (32) NULL,
    [FISCAL_YEAR_END]                NUMERIC (2)  NULL,
    [TAX_CODE]                       VARCHAR (20) NULL,
    [GST_REG_NUM]                    VARCHAR (20) NULL,
    [TERM_DATE]                      DATETIME     NULL,
    [TERM_USER]                      VARCHAR (32) NULL,
    [PROFILE_GROUP_CODE]             VARCHAR (3)  NULL,
    [NON_STANDARD_VOLUME_ENTRY_FLAG] VARCHAR (1)  NULL,
    [SELF_SUSTAINING_FLAG]           VARCHAR (1)  NULL,
    [ADMIN_CC_NUM]                   VARCHAR (10) NULL,
    [MULTI_TIER_JIB_FLAG]            VARCHAR (1)  NULL,
    [CASH_CALL_DRAW_DOWN_FLAG]       VARCHAR (1)  NULL,
    [JIB_INVC_ORG_ID]                NUMERIC (4)  NULL,
    [COUNTRY_FOR_TAXATION]           VARCHAR (2)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

