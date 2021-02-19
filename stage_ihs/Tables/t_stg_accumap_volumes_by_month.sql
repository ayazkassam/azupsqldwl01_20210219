CREATE TABLE [stage_ihs].[t_stg_accumap_volumes_by_month] (
    [uwi]          VARCHAR (40)    NOT NULL,
    [product_type] VARCHAR (8000)  NULL,
    [year]         NUMERIC (4)     NOT NULL,
    [jan]          NUMERIC (14, 4) NULL,
    [feb]          NUMERIC (14, 4) NULL,
    [mar]          NUMERIC (14, 4) NULL,
    [apr]          NUMERIC (14, 4) NULL,
    [may]          NUMERIC (14, 4) NULL,
    [jun]          NUMERIC (14, 4) NULL,
    [jul]          NUMERIC (14, 4) NULL,
    [aug]          NUMERIC (14, 4) NULL,
    [sep]          NUMERIC (14, 4) NULL,
    [oct]          NUMERIC (14, 4) NULL,
    [nov]          NUMERIC (14, 4) NULL,
    [dec]          NUMERIC (14, 4) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

