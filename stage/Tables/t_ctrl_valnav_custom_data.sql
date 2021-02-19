CREATE TABLE [stage].[t_ctrl_valnav_custom_data] (
    [CustomDataName]  VARCHAR (100) NOT NULL,
    [CalculationName] VARCHAR (50)  NULL,
    [DisplayName]     VARCHAR (100) NULL,
    [CustomDataID]    VARCHAR (50)  NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

