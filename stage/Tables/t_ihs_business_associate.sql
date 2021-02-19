﻿CREATE TABLE [stage].[t_ihs_business_associate] (
    [BUSINESS_ASSOCIATE]   VARCHAR (20)   NULL,
    [ACTIVE_IND]           VARCHAR (1)    NULL,
    [BA_ABBREVIATION]      VARCHAR (20)   NULL,
    [BA_CATEGORY]          VARCHAR (20)   NULL,
    [BA_CODE]              VARCHAR (20)   NULL,
    [BA_NAME]              VARCHAR (240)  NULL,
    [BA_SHORT_NAME]        VARCHAR (30)   NULL,
    [BA_TYPE]              VARCHAR (30)   NULL,
    [CREDIT_CHECK_DATE]    DATETIME       NULL,
    [CREDIT_CHECK_IND]     VARCHAR (1)    NULL,
    [CREDIT_CHECK_SOURCE]  VARCHAR (20)   NULL,
    [CREDIT_RATING]        VARCHAR (20)   NULL,
    [CREDIT_RATING_SOURCE] VARCHAR (20)   NULL,
    [CURRENT_STATUS]       VARCHAR (20)   NULL,
    [EFFECTIVE_DATE]       DATETIME       NULL,
    [EXPIRY_DATE]          DATETIME       NULL,
    [FIRST_NAME]           VARCHAR (30)   NULL,
    [LAST_NAME]            VARCHAR (40)   NULL,
    [MAIN_EMAIL_ADDRESS]   VARCHAR (20)   NULL,
    [MAIN_FAX_NUM]         VARCHAR (20)   NULL,
    [MAIN_PHONE_NUM]       VARCHAR (20)   NULL,
    [MAIN_WEB_URL]         VARCHAR (20)   NULL,
    [MIDDLE_INITIAL]       VARCHAR (3)    NULL,
    [PPDM_GUID]            VARCHAR (38)   NULL,
    [REMARK]               VARCHAR (2000) NULL,
    [SOURCE]               VARCHAR (20)   NULL,
    [ROW_CHANGED_BY]       VARCHAR (30)   NULL,
    [ROW_CHANGED_DATE]     DATETIME       NULL,
    [ROW_CREATED_BY]       VARCHAR (30)   NULL,
    [ROW_CREATED_DATE]     DATETIME       NULL,
    [ROW_QUALITY]          VARCHAR (20)   NULL,
    [BA_GROUP]             VARCHAR (20)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
