CREATE TABLE [stage].[t_tmp_text_execptions] (
    [rn]                 BIGINT        NULL,
    [String]             VARCHAR (200) NULL,
    [Replacement_String] VARCHAR (200) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

