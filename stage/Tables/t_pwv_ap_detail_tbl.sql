﻿CREATE TABLE [stage].[t_pwv_ap_detail_tbl] (
    [DOCUMENT]             VARCHAR (40)    NOT NULL,
    [FOLDER_ID]            DATETIME        NOT NULL,
    [PWR_ID]               INT             NOT NULL,
    [PWR_DETAIL_ID]        INT             NOT NULL,
    [ORG_ID]               INT             NULL,
    [ACCOUNT]              VARCHAR (12)    NULL,
    [ACCOUNT_DESC]         VARCHAR (500)   NULL,
    [AFE_NUM]              VARCHAR (10)    NULL,
    [AFE_DESC]             VARCHAR (500)   NULL,
    [CC_NUM]               VARCHAR (10)    NULL,
    [CC_DESC]              VARCHAR (500)   NULL,
    [ACTVY_PER_DATE]       DATETIME        NULL,
    [REPORTING_CURR_AMT]   NUMERIC (14, 2) NULL,
    [LI_VOLUME]            NUMERIC (12, 2) NULL,
    [LI_REMARKS]           VARCHAR (72)    NULL,
    [GOVERN_AGR_ID]        INT             NULL,
    [GOVERN_AGR_TYPE_CODE] VARCHAR (2)     NULL,
    [INVOICE]              VARCHAR (20)    NULL,
    [CLIENT_ID]            VARCHAR (6)     NULL,
    [INVC_DATE]            DATETIME        NULL,
    [ON_HOLD]              INT             NULL,
    [DISCOUNT_AMT]         NUMERIC (14, 2) NULL,
    [CONTINUITY_CODE]      VARCHAR (6)     NULL,
    [QTY]                  NUMERIC (16, 4) NULL,
    [UOM]                  VARCHAR (10)    NULL,
    [DESCRIPTION]          VARCHAR (2000)  NULL,
    [UNIT_PRICE]           NUMERIC (14, 2) NULL,
    [SERVICE_START_DATE]   DATETIME        NULL,
    [SERVICE_END_DATE]     DATETIME        NULL,
    [FIELD_TICKET_NUMBER]  VARCHAR (30)    NULL,
    [PWR_COMMODITY_CODE]   VARCHAR (15)    NULL,
    [PWR_COMMODITY_TITLE]  VARCHAR (254)   NULL,
    [PO_LINE_NUMBER]       INT             NULL,
    [WORK_ORDER_NUMBER]    VARCHAR (50)    NULL,
    [JV_FOOTNOTE]          VARCHAR (2000)  NULL,
    [GL_SUB_CODE]          VARCHAR (6)     NULL,
    [USER_DEFINED_TAG]     VARCHAR (10)    NULL,
    [PST_PROVINCE]         VARCHAR (2)     NULL,
    [PST_AMT]              NUMERIC (14, 2) NULL,
    [ASSET_NUMBER]         VARCHAR (30)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

