CREATE TABLE [stage].[t_prodview_bsw] (
    [keymigrationsource] VARCHAR (100) NULL,
    [compida]            VARCHAR (100) NULL,
    [cc_num]             VARCHAR (50)  NULL,
    [completionname]     VARCHAR (100) NULL,
    [dttmstart]          DATE          NULL,
    [calc_dttm_start]    DATE          NULL,
    [calc_dttm_end]      DATE          NULL,
    [bsw]                FLOAT (53)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

