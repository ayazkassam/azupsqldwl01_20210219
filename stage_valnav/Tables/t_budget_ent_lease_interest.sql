CREATE TABLE [stage_valnav].[t_budget_ent_lease_interest] (
    [OBJECT_ID] NVARCHAR (50) NOT NULL,
    [PARENT_ID] NVARCHAR (50) NOT NULL,
    [NAME]      NVARCHAR (50) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

