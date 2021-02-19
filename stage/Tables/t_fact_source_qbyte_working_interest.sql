CREATE TABLE [stage].[t_fact_source_qbyte_working_interest] (
    [Account]              VARCHAR (16)     NOT NULL,
    [accounting_period]    INT              NOT NULL,
    [activity_period]      INT              NOT NULL,
    [entity_key]           VARCHAR (10)     NULL,
    [create_date]          INT              NULL,
    [on_production_date]   INT              NULL,
    [last_production_date] INT              NULL,
    [rig_release_date]     INT              NULL,
    [spud_date]            INT              NULL,
    [cc_term_date]         INT              NULL,
    [Scenario]             VARCHAR (2)      NOT NULL,
    [op_nonop]             VARCHAR (10)     NULL,
    [budget_group]         VARCHAR (200)    NULL,
    [working_interest]     NUMERIC (38, 11) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

