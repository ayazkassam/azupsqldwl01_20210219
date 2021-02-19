CREATE TABLE [stage].[t_stg_type_curves_current_scenario] (
    [scenario_key]        VARCHAR (1000) NULL,
    [is_current_scenario] CHAR (1)       NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

