CREATE TABLE [stage].[t_avocet_ontream_dates] (
    [SITE_ID]       VARCHAR (50)   NULL,
    [UWI]           VARCHAR (100)  NULL,
    [CC_NUM]        VARCHAR (1000) NULL,
    [ONSTREAM_DATE] DATETIME       NULL,
    [ONSTREAM_YEAR] VARCHAR (4)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

