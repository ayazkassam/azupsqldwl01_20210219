CREATE TABLE [datamart_marketing].[t_stg_prodview_group_point_doi] (
    [idflownet]        VARCHAR (100)   NULL,
    [idrecparent]      VARCHAR (100)   NULL,
    [dttmstart]        DATETIME        NULL,
    [dttmend]          DATETIME        NOT NULL,
    [typ1]             VARCHAR (50)    NULL,
    [ba_name]          VARCHAR (100)   NULL,
    [working_interest] NUMERIC (13, 5) NULL,
    [refidb]           VARCHAR (50)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

