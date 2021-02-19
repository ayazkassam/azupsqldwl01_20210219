﻿CREATE TABLE [stage].[t_qbyte_ba_addresses] (
    [CREATE_DATE]              DATETIME      NULL,
    [CREATE_USER]              VARCHAR (30)  NULL,
    [ID]                       NUMERIC (10)  NULL,
    [BA_ID]                    NUMERIC (10)  NULL,
    [ADDRESS_TYPE_CODE]        VARCHAR (8)   NULL,
    [SHORT_NAME]               VARCHAR (15)  NULL,
    [ADDRESS_LINE_1]           VARCHAR (40)  NULL,
    [LAST_UPDATE_DATE]         DATETIME      NULL,
    [LAST_UPDATE_USER]         VARCHAR (30)  NULL,
    [CHANGED_TO_BA_ADDRESS_ID] NUMERIC (10)  NULL,
    [PHONE]                    VARCHAR (17)  NULL,
    [PHONE_EXTENSION]          VARCHAR (4)   NULL,
    [FAX]                      VARCHAR (17)  NULL,
    [FAX_2]                    VARCHAR (17)  NULL,
    [EMAIL]                    VARCHAR (100) NULL,
    [CITY]                     VARCHAR (40)  NULL,
    [POSTAL_CODE]              VARCHAR (10)  NULL,
    [PROVINCE_CODE]            VARCHAR (2)   NULL,
    [COUNTRY_CODE]             VARCHAR (2)   NULL,
    [ALTERNATE_BA_NAME_1]      VARCHAR (40)  NULL,
    [ALTERNATE_BA_NAME_2]      VARCHAR (40)  NULL,
    [ADDRESS_LINE_2]           VARCHAR (40)  NULL,
    [ADDRESS_LINE_3]           VARCHAR (40)  NULL,
    [ADDRESS_LINE_4]           VARCHAR (40)  NULL,
    [EXTERNAL_LINK_REF]        VARCHAR (10)  NULL,
    [EXTERNAL_BA_REF]          VARCHAR (15)  NULL,
    [EXTERNAL_BA_ADDRESS_REF]  VARCHAR (20)  NULL,
    [EFFECTIVE_DATE]           DATETIME      NULL,
    [INACTIVE_DATE]            DATETIME      NULL,
    [INACTIVATED_USER]         VARCHAR (32)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
