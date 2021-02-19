CREATE TABLE [stage].[t_stg_prism_uwi_cc] (
    [uwi]       VARCHAR (50) NULL,
    [well_name] VARCHAR (50) NULL,
    [cc_num]    VARCHAR (50) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

