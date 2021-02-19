CREATE TABLE [data_mart_metrix].[t_fact_metrix_royalty] (
    [activity_period]             INT             NULL,
    [royalty_owner_id]            VARCHAR (50)    NULL,
    [product_code]                VARCHAR (30)    NULL,
    [royalty_type]                VARCHAR (30)    NULL,
    [payment_type]                VARCHAR (30)    NULL,
    [control_group_id]            VARCHAR (50)    NULL,
    [royalty_payor_id]            VARCHAR (30)    NULL,
    [well_tract_id]               VARCHAR (30)    NULL,
    [battery_id]                  VARCHAR (30)    NULL,
    [royalty_obligation_sequence] VARCHAR (10)    NULL,
    [royalty_value]               NUMERIC (11, 2) NULL,
    [royalty_volume_metric]       NUMERIC (9, 1)  NULL,
    [royalty_volume_imperial]     NUMERIC (11, 2) NULL,
    [royalty_volume_boe]          NUMERIC (11, 2) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

