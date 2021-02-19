﻿CREATE TABLE [stage].[t_ihs_r_well_profile_type] (
    [WELL_PROFILE_TYPE] VARCHAR (20)   NOT NULL,
    [ABBREVIATION]      VARCHAR (12)   NULL,
    [ACTIVE_IND]        VARCHAR (1)    NULL,
    [EFFECTIVE_DATE]    DATETIME       NULL,
    [EXPIRY_DATE]       DATETIME       NULL,
    [LONG_NAME]         VARCHAR (60)   NULL,
    [PPDM_GUID]         VARCHAR (38)   NULL,
    [REMARK]            VARCHAR (2000) NULL,
    [SHORT_NAME]        VARCHAR (30)   NULL,
    [SOURCE]            VARCHAR (20)   NULL,
    [ROW_CHANGED_BY]    VARCHAR (30)   NULL,
    [ROW_CHANGED_DATE]  DATETIME       NULL,
    [ROW_CREATED_BY]    VARCHAR (30)   NULL,
    [ROW_CREATED_DATE]  DATETIME       NULL,
    [ROW_QUALITY]       VARCHAR (20)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

