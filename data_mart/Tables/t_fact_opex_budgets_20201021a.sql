CREATE TABLE [data_mart].[t_fact_opex_budgets_20201021a] (
    [entity_key]               VARCHAR (500)  NULL,
    [account_key]              VARCHAR (50)   NULL,
    [accounting_month_key]     INT            NULL,
    [activity_month_key]       INT            NULL,
    [gross_net_key]            INT            NULL,
    [vendor_key]               INT            NULL,
    [scenario_key]             VARCHAR (1000) NOT NULL,
    [spud_date_key]            INT            NULL,
    [rig_release_date_key]     INT            NULL,
    [on_production_date_key]   INT            NULL,
    [cc_create_date_key]       INT            NULL,
    [cc_termination_date_key]  INT            NULL,
    [cad]                      FLOAT (53)     NULL,
    [usd]                      FLOAT (53)     NULL,
    [metric_volume]            FLOAT (53)     NULL,
    [imperial_volume]          FLOAT (53)     NULL,
    [boe_volume]               FLOAT (53)     NULL,
    [mcfe_volume]              FLOAT (53)     NULL,
    [cad_fixed]                FLOAT (53)     NULL,
    [cad_variable]             FLOAT (53)     NULL,
    [cad_econ_fixed]           FLOAT (53)     NULL,
    [cad_econ_variable_gas]    FLOAT (53)     NULL,
    [cad_econ_variable_oil]    FLOAT (53)     NULL,
    [is_leaseops]              INT            NOT NULL,
    [last_production_date_key] INT            NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

