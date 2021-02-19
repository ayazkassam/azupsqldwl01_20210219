CREATE TABLE [stage].[Custom_Groupings_Leaf] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [ImportType]       TINYINT        NOT NULL,
    [ImportStatus_ID]  TINYINT        CONSTRAINT [df_Custom Groupings_Leaf_ImportStatus_ID] DEFAULT ((0)) NOT NULL,
    [Batch_ID]         INT            NULL,
    [BatchTag]         NVARCHAR (50)  NOT NULL,
    [ErrorCode]        INT            CONSTRAINT [df_Custom Groupings_Leaf_ErrorCode] DEFAULT ((0)) NOT NULL,
    [Code]             NVARCHAR (250) NULL,
    [Name]             NVARCHAR (250) NULL,
    [NewCode]          NVARCHAR (250) NULL,
    [Cost Centre Type] NVARCHAR (100) NULL,
    [Group1]           NVARCHAR (100) NULL,
    [Group2]           NVARCHAR (100) NULL,
    [Group3]           NVARCHAR (100) NULL,
    [Group4]           NVARCHAR (100) NULL,
    [Group5]           NVARCHAR (100) NULL,
    [Group6]           NVARCHAR (100) NULL,
    [Group7]           NVARCHAR (100) NULL,
    [Group8]           NVARCHAR (100) NULL,
    [Group9]           NVARCHAR (100) NULL,
    [Group10]          NVARCHAR (100) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

