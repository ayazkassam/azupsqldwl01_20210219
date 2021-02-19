CREATE TABLE [stage].[t_prodview_shrink_yield_rates] (
    [keymigrationsource] VARCHAR (100) NULL,
    [compida]            VARCHAR (100) NULL,
    [idflownet]          VARCHAR (100) NULL,
    [dttmstart]          DATE          NULL,
    [dttmend]            DATE          NULL,
    [gas_shrinkage]      FLOAT (53)    NULL,
    [c2_yield]           FLOAT (53)    NULL,
    [c3_yield]           FLOAT (53)    NULL,
    [c4_yield]           FLOAT (53)    NULL,
    [c5_yield]           FLOAT (53)    NULL,
    [condy_yield]        FLOAT (53)    NULL,
    [total_yield_factor] FLOAT (53)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

