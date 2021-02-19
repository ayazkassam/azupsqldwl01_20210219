CREATE TABLE [stage].[t_ctrl_qbyte_conversion_factors] (
    [gas_si_to_imp_conv_factor]    NUMERIC (14, 10) NULL,
    [liquid_si_to_imp_conv_factor] NUMERIC (14, 10) NULL,
    [gas_boe_thermal]              NUMERIC (8, 5)   NULL,
    [liquid_boe_thermal]           NUMERIC (8, 5)   NULL,
    [gas_mcfe6_thermal]            NUMERIC (8, 5)   NULL,
    [liquid_mcfe6_thermal]         NUMERIC (8, 5)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

