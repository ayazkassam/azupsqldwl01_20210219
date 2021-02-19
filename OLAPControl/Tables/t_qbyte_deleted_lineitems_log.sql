CREATE TABLE [OLAPControl].[t_qbyte_deleted_lineitems_log] (
    [LI_ID]       NUMERIC (10) NOT NULL,
    [DeletedDate] DATETIME     NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

