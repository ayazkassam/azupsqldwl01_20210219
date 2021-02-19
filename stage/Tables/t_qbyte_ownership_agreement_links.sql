CREATE TABLE [stage].[t_qbyte_ownership_agreement_links] (
    [CREATE_DATE]             DATETIME     NULL,
    [CREATE_USER]             VARCHAR (32) NULL,
    [ORG_ID]                  NUMERIC (4)  NULL,
    [LAST_UPDT_DATE]          DATETIME     NULL,
    [LAST_UPDT_USER]          VARCHAR (32) NULL,
    [TERM_DATE]               DATETIME     NULL,
    [TERM_USER]               VARCHAR (32) NULL,
    [OWNERSHIP_LINK_ID]       NUMERIC (10) NULL,
    [AGREEMENT_ID]            NUMERIC (10) NULL,
    [EFFECTIVE_DATE]          DATETIME     NULL,
    [EXPIRY_DATE]             DATETIME     NULL,
    [AFE_NUM]                 VARCHAR (10) NULL,
    [CC_NUM]                  VARCHAR (10) NULL,
    [MAJOR_ACCT]              VARCHAR (4)  NULL,
    [MINOR_ACCT]              VARCHAR (4)  NULL,
    [BURDEN_ID]               VARCHAR (10) NULL,
    [ROYALTY_AGREEMENT_REF]   VARCHAR (10) NULL,
    [PRODUCTION_REVENUE_CODE] VARCHAR (3)  NULL,
    [BILL_CODE]               VARCHAR (10) NULL,
    [EXTERNAL_REFERENCE_ID]   VARCHAR (10) NULL,
    [ACCT_GROUP_CODE]         VARCHAR (6)  NULL,
    [TERMINATE_FLAG]          VARCHAR (1)  NULL,
    [MASS_UPDATE_ID]          NUMERIC (10) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

