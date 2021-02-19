CREATE TABLE [data_mart_metrix].[t_dim_facility] (
    [facility_sys_id]                 NUMERIC (16)  NOT NULL,
    [facility_id]                     VARCHAR (30)  NULL,
    [facility_name]                   VARCHAR (100) NULL,
    [facility_type_code]              VARCHAR (30)  NULL,
    [facility_type_desc]              VARCHAR (100) NULL,
    [facility_province]               VARCHAR (6)   NULL,
    [facility_government_code]        VARCHAR (30)  NULL,
    [facility_cost_centre_code]       VARCHAR (30)  NULL,
    [facility_production_status]      VARCHAR (30)  NULL,
    [facility_operator_id]            VARCHAR (50)  NULL,
    [facility_operator_name]          VARCHAR (100) NULL,
    [facility_pa_responsible_user_id] VARCHAR (50)  NULL,
    [facility_pa_responsible_user]    VARCHAR (100) NULL,
    [facility_code]                   VARCHAR (30)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

