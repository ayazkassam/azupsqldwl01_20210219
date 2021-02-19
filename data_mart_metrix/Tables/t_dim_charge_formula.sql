CREATE TABLE [data_mart_metrix].[t_dim_charge_formula] (
    [facility_charge_formula_id] VARCHAR (30)  NULL,
    [formula_description]        VARCHAR (100) NULL,
    [retrieval_code]             VARCHAR (30)  NULL,
    [retrieval_description]      VARCHAR (100) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

