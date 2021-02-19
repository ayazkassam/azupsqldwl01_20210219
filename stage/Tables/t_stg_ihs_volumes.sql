CREATE TABLE [stage].[t_stg_ihs_volumes] (
    [uwi]    VARCHAR (50)    NULL,
    [oil]    NUMERIC (14, 4) NULL,
    [cond]   NUMERIC (14, 4) NULL,
    [gas]    NUMERIC (14, 4) NULL,
    [water]  NUMERIC (14, 4) NULL,
    [month]  NVARCHAR (128)  NULL,
    [year]   NUMERIC (4)     NULL,
    [cc_num] VARCHAR (50)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

