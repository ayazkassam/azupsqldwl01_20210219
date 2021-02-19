CREATE TABLE [STAGE_METRIX].[t_ctrl_metrix_products] (
    [PRODUCT_CODE]          VARCHAR (6)      NULL,
    [PRODUCT_NAME]          VARCHAR (40)     NULL,
    [SI_TO_IMP_CONV_FACTOR] NUMERIC (14, 10) NULL,
    [BOE_THERMAL]           NUMERIC (8, 5)   NULL,
    [M3_THERMAL]            NUMERIC (8, 5)   NULL,
    [MCFE6_THERMAL]         NUMERIC (8, 5)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

