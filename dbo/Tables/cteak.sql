CREATE TABLE [dbo].[cteak] (
    [flownet_id]                    VARCHAR (32)  NOT NULL,
    [flownet_name]                  VARCHAR (50)  NULL,
    [sales_disposition_point]       INT           NOT NULL,
    [sales_disposition_point_idrec] INT           NOT NULL,
    [cube_child]                    VARCHAR (100) NULL,
    [cube_parent]                   VARCHAR (100) NULL,
    [child_idrec]                   VARCHAR (32)  NOT NULL,
    [parent_idrec]                  VARCHAR (32)  NOT NULL,
    [child_name]                    VARCHAR (100) NULL,
    [parent_name]                   VARCHAR (100) NULL,
    [uwi]                           VARCHAR (50)  NULL,
    [cc_num]                        VARCHAR (50)  NULL,
    [xlevel]                        INT           NOT NULL,
    [idrecmetereventtk]             VARCHAR (26)  NULL,
    [meter_type]                    VARCHAR (50)  NULL,
    [dttmstart]                     DATETIME      NULL,
    [dttmend]                       DATETIME      NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

