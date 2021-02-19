CREATE TABLE [data_mart_metrix].[t_dim_charge_type] (
    [charge_type]               VARCHAR (30)  NOT NULL,
    [charge_type_description]   VARCHAR (100) NOT NULL,
    [charge_type_name]          VARCHAR (100) NOT NULL,
    [charge_type_short]         VARCHAR (50)  NULL,
    [charge_type_specific_code] VARCHAR (30)  NULL,
    [is_active]                 VARCHAR (1)   NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

