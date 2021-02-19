CREATE TABLE [stage].[t_ctrl_valnav_products] (
    [product_id]            INT            NOT NULL,
    [accounts]              VARCHAR (50)   NULL,
    [si_to_imp_conv_factor] NUMERIC (8, 5) NULL,
    [boe_thermal]           NUMERIC (8, 5) NULL,
    [mcfe6_thermal]         NUMERIC (8, 5) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

