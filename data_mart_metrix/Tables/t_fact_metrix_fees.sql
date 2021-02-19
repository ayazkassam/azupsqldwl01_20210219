CREATE TABLE [data_mart_metrix].[t_fact_metrix_fees] (
    [activity_period]            INT             NULL,
    [control_group_id]           VARCHAR (50)    NULL,
    [facility_id]                VARCHAR (30)    NULL,
    [product_code]               VARCHAR (30)    NULL,
    [charge_type_code]           VARCHAR (30)    NULL,
    [facility_charge_formula_id] VARCHAR (30)    NULL,
    [charge_sequence_number]     INT             NULL,
    [EntityType]                 VARCHAR (3)     NULL,
    [EntityID]                   VARCHAR (30)    NULL,
    [expense_cost_centre_code]   VARCHAR (30)    NULL,
    [expense_owner_id]           VARCHAR (30)    NULL,
    [revenue_cost_centre_code]   VARCHAR (30)    NULL,
    [revenue_owner_id]           VARCHAR (30)    NULL,
    [expense_doi_sub_used]       VARCHAR (30)    NULL,
    [revenue_doi_sub_used]       VARCHAR (30)    NULL,
    [expense_value]              NUMERIC (11, 2) NULL,
    [expense_volume_metric]      NUMERIC (9, 1)  NULL,
    [expense_volume_imperial]    NUMERIC (9, 1)  NULL,
    [expense_volume_boe]         NUMERIC (9, 1)  NULL,
    [gst_value]                  NUMERIC (11, 2) NOT NULL,
    [pst_value]                  NUMERIC (11, 2) NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

