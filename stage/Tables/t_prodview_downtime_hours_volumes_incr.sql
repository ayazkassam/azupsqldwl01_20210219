CREATE TABLE [stage].[t_prodview_downtime_hours_volumes_incr] (
    [idflownet]          VARCHAR (100) NULL,
    [keymigrationsource] VARCHAR (100) NULL,
    [compida]            VARCHAR (50)  NULL,
    [cc_num]             VARCHAR (50)  NULL,
    [completionname]     VARCHAR (50)  NULL,
    [NAME]               VARCHAR (100) NULL,
    [nameshort]          VARCHAR (50)  NULL,
    [typmigrationsource] VARCHAR (100) NULL,
    [dttm]               DATETIME      NULL,
    [hours_on]           FLOAT (53)    NULL,
    [hours_down]         FLOAT (53)    NULL,
    [vollosthcliq]       FLOAT (53)    NULL,
    [vollostgas]         FLOAT (53)    NULL,
    [vollostwater]       FLOAT (53)    NULL,
    [durdown]            FLOAT (53)    NULL,
    [durop]              FLOAT (53)    NULL,
    [codedowntm1]        VARCHAR (50)  NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

