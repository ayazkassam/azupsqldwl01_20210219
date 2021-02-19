CREATE TABLE [stage].[t_ctrl_ewf_primary_product_xref] (
    [ihs_primary_product] VARCHAR (20) NULL,
    [ewf_primary_product] VARCHAR (20) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

