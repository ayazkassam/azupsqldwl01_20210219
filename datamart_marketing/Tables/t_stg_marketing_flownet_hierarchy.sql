CREATE TABLE [datamart_marketing].[t_stg_marketing_flownet_hierarchy] (
    [flownet_id]                    VARCHAR (32)  NULL,
    [flownet_name]                  VARCHAR (50)  NULL,
    [sales_disposition_point]       VARCHAR (100) NULL,
    [sales_disposition_point_idrec] VARCHAR (100) NULL,
    [cube_child]                    VARCHAR (100) NULL,
    [cube_parent]                   VARCHAR (100) NULL,
    [child_idrec]                   VARCHAR (32)  NULL,
    [parent_idrec]                  VARCHAR (32)  NULL,
    [child_name]                    VARCHAR (100) NULL,
    [parent_name]                   VARCHAR (100) NULL,
    [uwi]                           VARCHAR (50)  NULL,
    [cc_num]                        VARCHAR (50)  NULL,
    [idrecmetereventtk]             VARCHAR (26)  NULL,
    [dttmstart]                     DATETIME      NULL,
    [dttmend]                       DATETIME      NULL,
    [meter_type]                    VARCHAR (50)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

