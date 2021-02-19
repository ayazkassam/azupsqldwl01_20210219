CREATE TABLE [stage].[t_prodview_injection_volumes] (
    [keymigrationsource]     VARCHAR (100) NULL,
    [compida]                VARCHAR (100) NULL,
    [cc_num]                 VARCHAR (50)  NULL,
    [completionname]         VARCHAR (100) NULL,
    [typmigrationsource]     VARCHAR (100) NULL,
    [typ1]                   VARCHAR (100) NULL,
    [typ2]                   VARCHAR (100) NULL,
    [dttm]                   DATE          NULL,
    [injected_prod_water]    FLOAT (53)    NULL,
    [injected_pressure_kpag] FLOAT (53)    NULL,
    [injected_src_water]     FLOAT (53)    NULL,
    [injected_gas_c02]       FLOAT (53)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

