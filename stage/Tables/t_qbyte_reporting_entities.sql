CREATE TABLE [stage].[t_qbyte_reporting_entities] (
    [REPORTING_ENTITY_ID]          NUMERIC (10)  NULL,
    [HIERARCHY_CODE]               VARCHAR (10)  NULL,
    [REPORTING_LEVEL_CODE]         VARCHAR (10)  NULL,
    [REPORTING_ENTITY_CODE]        VARCHAR (10)  NULL,
    [REPORTING_ENTITY_DESC]        VARCHAR (240) NULL,
    [PARENT_REPORTING_ENTITY_CODE] VARCHAR (10)  NULL,
    [PARENT_REPORTING_LEVEL_CODE]  VARCHAR (10)  NULL,
    [CC_NUM]                       VARCHAR (10)  NULL,
    [REPORTING_ENTITY_LOCATION]    VARCHAR (20)  NULL,
    [PARENT_REPORTING_ENTITY_ID]   NUMERIC (10)  NULL,
    [AFE_NUM]                      VARCHAR (10)  NULL,
    [ORG_ID]                       NUMERIC (4)   NULL,
    [MAJOR_ACCT]                   VARCHAR (4)   NULL,
    [MINOR_ACCT]                   VARCHAR (4)   NULL,
    [OTHER_ID]                     VARCHAR (20)  NULL,
    [CONTINUITY_CODE]              VARCHAR (6)   NULL,
    [CREATE_USER]                  VARCHAR (30)  NULL,
    [CREATE_DATE]                  DATETIME      NULL,
    [LAST_UPDATE_USER]             VARCHAR (30)  NULL,
    [LAST_UPDATE_DATE]             DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

