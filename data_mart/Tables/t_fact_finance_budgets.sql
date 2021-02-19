CREATE TABLE [data_mart].[t_fact_finance_budgets] (
    [li_id]                INT            NULL,
    [voucher_id]           INT            NULL,
    [entity_key]           VARCHAR (500)  NULL,
    [account_key]          VARCHAR (1000) NULL,
    [accounting_month_key] INT            NULL,
    [activity_month_key]   INT            NULL,
    [gross_net_key]        INT            NULL,
    [vendor_key]           INT            NULL,
    [scenario_key]         VARCHAR (1000) NULL,
    [organization_key]     INT            NULL,
    [afe_key]              VARCHAR (10)   NULL,
    [cdn_dollars]          FLOAT (53)     NULL,
    [metric_volume]        FLOAT (53)     NULL,
    [imperial_volume]      FLOAT (53)     NULL,
    [boe_volume]           FLOAT (53)     NULL,
    [mcfe_volume]          FLOAT (53)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

