CREATE TABLE [stage].[t_pvr_uwi_onstream_dates] (
    [UWI]           VARCHAR (50) NULL,
    [ONSTREAM_DATE] DATETIME     NULL,
    [ONSTREAM_YEAR] VARCHAR (4)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

