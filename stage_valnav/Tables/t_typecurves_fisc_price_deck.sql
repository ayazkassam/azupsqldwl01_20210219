CREATE TABLE [stage_valnav].[t_typecurves_fisc_price_deck] (
    [OBJECT_ID]        NVARCHAR (50)   NOT NULL,
    [NAME]             NVARCHAR (50)   NULL,
    [DESCRIPTION]      NVARCHAR (2000) NULL,
    [LAST_CHANGE_DATE] BIGINT          NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

