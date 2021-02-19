CREATE TABLE [stage].[t_qbyte_doi_decks] (
    [CREATE_DATE]         DATETIME     NULL,
    [CREATE_USER]         VARCHAR (32) NULL,
    [LAST_UPDATE_DATE]    DATETIME     NULL,
    [LAST_UPDATE_USER]    VARCHAR (32) NULL,
    [ID]                  NUMERIC (10) NULL,
    [NAME]                VARCHAR (40) NULL,
    [TERMINATE_FLAG]      VARCHAR (1)  NULL,
    [BILLING_AGENT_BA_ID] NUMERIC (10) NULL,
    [TERM_DATE]           DATETIME     NULL,
    [TERM_USER]           VARCHAR (32) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

