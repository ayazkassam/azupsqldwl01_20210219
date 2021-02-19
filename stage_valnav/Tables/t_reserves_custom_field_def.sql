CREATE TABLE [stage_valnav].[t_reserves_custom_field_def] (
    [OBJECT_ID]          NVARCHAR (50)   NOT NULL,
    [NAME]               NVARCHAR (50)   NOT NULL,
    [USAGE_TYPE]         INT             NOT NULL,
    [DEF_TYPE]           INT             NOT NULL,
    [SECURITY_ENABLED]   TINYINT         NOT NULL,
    [FORMAT]             NVARCHAR (50)   NULL,
    [PRECISION]          INT             NULL,
    [IMPERIAL_UNIT]      NVARCHAR (50)   NULL,
    [METRIC_UNIT]        NVARCHAR (50)   NULL,
    [ENFORCE_VALUES]     TINYINT         NULL,
    [DEFAULT_LIST_VALUE] NVARCHAR (4000) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

