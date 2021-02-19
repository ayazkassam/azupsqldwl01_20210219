CREATE TABLE [stage].[t_prodview_attributes] (
    [uwi]                          VARCHAR (50)   NULL,
    [pvunit_completion_name]       VARCHAR (50)   NULL,
    [pvunit_name]                  VARCHAR (100)  NULL,
    [pvunit_short_name]            VARCHAR (50)   NULL,
    [gas_shrinkage_factor]         DECIMAL (5, 2) NULL,
    [ngl_yield_factor]             DECIMAL (9, 2) NULL,
    [routename]                    VARCHAR (100)  NULL,
    [flownet_name]                 VARCHAR (100)  NULL,
    [sales_disposition_point]      VARCHAR (100)  NULL,
    [engineering_on_prod_date]     VARCHAR (50)   NULL,
    [engineering_inline_test_date] VARCHAR (50)   NULL,
    [schematic_typical]            VARCHAR (50)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

