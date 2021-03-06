﻿CREATE TABLE [stage].[t_qbyte_doi_deck_partners] (
    [DOI_DECK_ID]         NUMERIC (10)     NULL,
    [PARTNER_BA_ID]       NUMERIC (10)     NULL,
    [LA_PARTNER_PCT]      NUMERIC (14, 11) NULL,
    [FM_PARTNER_PCT]      NUMERIC (14, 11) NULL,
    [SILENT_PARTNER_FLAG] VARCHAR (1)      NULL,
    [ACCOUNTABLE_FLAG]    VARCHAR (1)      NULL,
    [TAKE_IN_KIND_FLAG]   VARCHAR (1)      NULL,
    [PENALTY_FLAG]        VARCHAR (1)      NULL,
    [CREATE_DATE]         DATETIME         NULL,
    [CREATE_USER]         VARCHAR (32)     NULL,
    [LAST_UPDATE_DATE]    DATETIME         NULL,
    [LAST_UPDATE_USER]    VARCHAR (32)     NULL,
    [SILENT_AGENT_BA_ID]  NUMERIC (10)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

