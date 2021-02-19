CREATE TABLE [stage].[t_qbyte_cost_centre_name_revised_desc] (
    [cost_centre_id]           VARCHAR (500)  NULL,
    [cost_centre_name]         VARCHAR (4000) NULL,
    [cost_centre_name_revised] VARCHAR (4000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

