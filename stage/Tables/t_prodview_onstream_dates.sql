CREATE TABLE [stage].[t_prodview_onstream_dates] (
    [site_id]       VARCHAR (100) NULL,
    [uwi]           VARCHAR (100) NULL,
    [cc_num]        VARCHAR (100) NULL,
    [onstream_date] DATE          NULL,
    [onstream_year] VARCHAR (4)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

