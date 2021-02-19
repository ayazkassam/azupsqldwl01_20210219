CREATE TABLE [OLAPControl].[t_Run_Status_Codes] (
    [Status_Code] INT            NOT NULL,
    [Status]      NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (500) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

