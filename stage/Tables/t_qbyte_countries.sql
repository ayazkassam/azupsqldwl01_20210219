CREATE TABLE [stage].[t_qbyte_countries] (
    [CODE]            VARCHAR (30)  NULL,
    [NAME]            VARCHAR (40)  NULL,
    [COUNTRY_COMMENT] VARCHAR (300) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

