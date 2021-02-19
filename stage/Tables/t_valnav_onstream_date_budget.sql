CREATE TABLE [stage].[t_valnav_onstream_date_budget] (
    [object_id]       NVARCHAR (50)  NULL,
    [unique_id]       NVARCHAR (100) NULL,
    [first_step_date] DATETIME       NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

