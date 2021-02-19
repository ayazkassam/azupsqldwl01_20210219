CREATE TABLE [stage].[t_prodview_typfluidprod] (
    [keymigrationsource] VARCHAR (100) NULL,
    [compida]            VARCHAR (100) NULL,
    [typfluidprod]       VARCHAR (100) NULL,
    [dttm]               DATE          NULL,
    [ettm]               DATE          NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

