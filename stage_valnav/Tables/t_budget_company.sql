CREATE TABLE [stage_valnav].[t_budget_company] (
    [OBJECT_ID]                 NVARCHAR (50) NOT NULL,
    [NAME]                      NVARCHAR (50) NOT NULL,
    [ENABLED]                   TINYINT       NULL,
    [USE_IN_NEW_CASE_INTERESTS] TINYINT       NULL,
    [DEFAULT_WORKING_INTEREST]  FLOAT (53)    NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

