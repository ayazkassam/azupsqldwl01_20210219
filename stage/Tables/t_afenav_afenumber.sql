CREATE TABLE [stage].[t_afenav_afenumber] (
    [document_id] VARCHAR (50) NOT NULL,
    [version]     INT          NOT NULL,
    [afenumber]   VARCHAR (50) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

