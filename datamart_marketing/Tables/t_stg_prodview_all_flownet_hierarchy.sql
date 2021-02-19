CREATE TABLE [datamart_marketing].[t_stg_prodview_all_flownet_hierarchy] (
    [flownet_id]        VARCHAR (32)  NOT NULL,
    [flownet_name]      VARCHAR (50)  NULL,
    [child_idrec]       VARCHAR (32)  NOT NULL,
    [child_name]        VARCHAR (100) NULL,
    [typ1]              VARCHAR (50)  NULL,
    [typ2]              VARCHAR (50)  NULL,
    [parent_idrec]      VARCHAR (32)  NOT NULL,
    [parent_name]       VARCHAR (100) NULL,
    [uwi]               VARCHAR (50)  NULL,
    [cc_num]            VARCHAR (50)  NULL,
    [cube_child]        VARCHAR (100) NULL,
    [cube_parent]       VARCHAR (100) NULL,
    [idrecmetereventtk] VARCHAR (26)  NULL,
    [dttmstart]         DATETIME      NULL,
    [dttmend]           DATETIME      NOT NULL,
    [pvunit_dttmend]    DATETIME      NULL,
    [meter_type]        VARCHAR (50)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

