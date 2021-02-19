CREATE TABLE [STAGE_METRIX].[t_stg_metrix_government_registry] (
    [Facility_ID]   VARCHAR (30)  NULL,
    [Facility_Name] VARCHAR (100) NULL,
    [Operator_Name] VARCHAR (100) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

