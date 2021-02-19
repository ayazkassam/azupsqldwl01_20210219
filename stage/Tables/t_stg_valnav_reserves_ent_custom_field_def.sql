CREATE TABLE [stage].[t_stg_valnav_reserves_ent_custom_field_def] (
    [parent_id]     NVARCHAR (50) NOT NULL,
    [NAME]          NVARCHAR (50) NOT NULL,
    [string_value]  VARCHAR (100) NULL,
    [date_value]    DATETIME2 (7) NULL,
    [numeric_value] FLOAT (53)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

