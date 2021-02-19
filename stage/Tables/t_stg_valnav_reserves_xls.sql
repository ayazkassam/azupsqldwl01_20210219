CREATE TABLE [stage].[t_stg_valnav_reserves_xls] (
    [source_file]       VARCHAR (1000) NULL,
    [reserve_category]  VARCHAR (100)  NULL,
    [cc_num]            VARCHAR (50)   NULL,
    [uwi]               VARCHAR (100)  NULL,
    [accounts]          VARCHAR (500)  NULL,
    [scenario]          VARCHAR (100)  NULL,
    [accounting_month]  VARCHAR (100)  NULL,
    [reserves_property] VARCHAR (1000) NULL,
    [zone_play]         VARCHAR (1000) NULL,
    [amount]            FLOAT (53)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

