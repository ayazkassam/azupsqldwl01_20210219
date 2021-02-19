CREATE TABLE [stage].[t_fact_source_leaseops_valnav_volumes] (
    [entity_key]               VARCHAR (500)  NULL,
    [account_key]              VARCHAR (20)   NULL,
    [accounting_month_key]     INT            NULL,
    [activity_month_key]       INT            NULL,
    [gross_net_key]            INT            NULL,
    [vendor_key]               INT            NULL,
    [scenario_key]             VARCHAR (1000) NULL,
    [spud_date_key]            INT            NULL,
    [rig_release_date_key]     INT            NULL,
    [on_production_date_key]   INT            NULL,
    [cc_create_date_key]       INT            NULL,
    [cc_termination_date_key]  INT            NULL,
    [metric_volume]            FLOAT (53)     NULL,
    [imperial_volume]          FLOAT (53)     NULL,
    [boe_volume]               FLOAT (53)     NULL,
    [mcfe_volume]              FLOAT (53)     NULL,
    [last_production_date_key] INT            NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

