CREATE TABLE [stage].[t_cc_uwi_master_source] (
    [cc_num]      VARCHAR (50)  NULL,
    [uwi]         VARCHAR (50)  NULL,
    [well_name]   VARCHAR (100) NULL,
    [data_source] VARCHAR (20)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

