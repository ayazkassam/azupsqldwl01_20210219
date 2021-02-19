﻿CREATE TABLE [data_mart_metrix].[t_fact_metrix] (
    [activity_period]              INT             NULL,
    [purchaser_id]                 VARCHAR (50)    NULL,
    [product_code]                 VARCHAR (30)    NULL,
    [sales_type]                   VARCHAR (30)    NULL,
    [sales_tik]                    VARCHAR (30)    NULL,
    [control_group_id]             VARCHAR (50)    NULL,
    [owner_id]                     VARCHAR (30)    NULL,
    [well_tract_id]                VARCHAR (30)    NULL,
    [battery_id]                   VARCHAR (30)    NULL,
    [source_facility_id]           VARCHAR (30)    NULL,
    [target_facility_id]           VARCHAR (30)    NULL,
    [purchaser_sequence]           VARCHAR (10)    NULL,
    [delivery_sequence]            VARCHAR (10)    NULL,
    [royalty_payor]                VARCHAR (30)    NULL,
    [ar_contract]                  VARCHAR (500)   NULL,
    [sales_value]                  NUMERIC (11, 2) NULL,
    [sales_volume]                 NUMERIC (9, 1)  NULL,
    [sales_volume_imperial]        NUMERIC (11, 2) NULL,
    [sales_volume_boe]             NUMERIC (11, 2) NULL,
    [sales_value_net_of_transport] NUMERIC (11, 2) NULL,
    [actual_gigajoules]            NUMERIC (12)    NULL,
    [opening_inventory]            NUMERIC (38, 1) NULL,
    [transfer_received]            NUMERIC (38, 1) NULL,
    [production_volume]            NUMERIC (38, 1) NULL,
    [transfer_sent]                NUMERIC (38, 1) NULL,
    [closing_inventory]            NUMERIC (38, 1) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

