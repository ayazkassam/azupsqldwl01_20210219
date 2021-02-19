CREATE TABLE [data_mart_metrix].[t_dim_owner] (
    [Owner_ID]        VARCHAR (30)  NULL,
    [Owner_Name]      VARCHAR (100) NULL,
    [Owner_Province]  VARCHAR (30)  NULL,
    [Owner_Govt_Code] VARCHAR (30)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

