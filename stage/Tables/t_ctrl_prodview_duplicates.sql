CREATE TABLE [stage].[t_ctrl_prodview_duplicates] (
    [keymigrationsource] VARCHAR (100) NULL,
    [created_date]       DATE          NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

