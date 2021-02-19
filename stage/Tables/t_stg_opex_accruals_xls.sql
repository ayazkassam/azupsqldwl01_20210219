CREATE TABLE [stage].[t_stg_opex_accruals_xls] (
    [source_file]      VARCHAR (1000) NULL,
    [area]             VARCHAR (500)  NULL,
    [accounts]         VARCHAR (1000) NULL,
    [scenario]         VARCHAR (500)  NULL,
    [accounting_month] VARCHAR (100)  NULL,
    [amount]           FLOAT (53)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

