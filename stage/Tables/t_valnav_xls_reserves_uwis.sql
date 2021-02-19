CREATE TABLE [stage].[t_valnav_xls_reserves_uwis] (
    [entity_guid]                VARCHAR (500)  NULL,
    [uwi]                        VARCHAR (200)  NULL,
    [formatted_uwi]              VARCHAR (100)  NULL,
    [cc_num]                     VARCHAR (50)   NULL,
    [year_end_reserves_property] VARCHAR (1000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

