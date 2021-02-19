CREATE TABLE [data_mart].[t_fact_leaseops_opex_accruals_20210201] (
    [entity_key]           VARCHAR (500) NOT NULL,
    [account_key]          VARCHAR (50)  NULL,
    [accounting_month_key] INT           NULL,
    [activity_month_key]   INT           NULL,
    [gross_net_key]        INT           NOT NULL,
    [vendor_key]           INT           NOT NULL,
    [scenario_key]         VARCHAR (500) NULL,
    [cad]                  FLOAT (53)    NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

