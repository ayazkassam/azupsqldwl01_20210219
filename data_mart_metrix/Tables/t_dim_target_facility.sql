CREATE TABLE [data_mart_metrix].[t_dim_target_facility] (
    [target_facility_id]              VARCHAR (30)  NULL,
    [target_facility_name]            VARCHAR (100) NULL,
    [target_facility_government_code] VARCHAR (50)  NULL,
    [target_facility_province]        VARCHAR (6)   NULL,
    [target_facility_operator_id]     VARCHAR (50)  NULL,
    [target_facility_operator_name]   VARCHAR (100) NULL,
    [facility_type_code]              VARCHAR (30)  NULL,
    [facility_type_desc]              VARCHAR (100) NULL,
    [facility_code]                   VARCHAR (30)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

