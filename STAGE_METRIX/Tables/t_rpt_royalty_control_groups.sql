CREATE TABLE [STAGE_METRIX].[t_rpt_royalty_control_groups] (
    [well_tract_sys_id]         NUMERIC (16) NULL,
    [royalty_obligation_sys_id] NUMERIC (16) NULL,
    [product_code]              VARCHAR (16) NULL,
    [production_date]           NUMERIC (6)  NULL,
    [control_group_id]          VARCHAR (16) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

