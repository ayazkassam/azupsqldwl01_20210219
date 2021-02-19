CREATE TABLE [stage].[t_prodview_allocated_volumes_incr] (
    [idflownet]            VARCHAR (100)   NULL,
    [keymigrationsource]   VARCHAR (100)   NULL,
    [compida]              VARCHAR (100)   NULL,
    [cc_num]               VARCHAR (50)    NULL,
    [completionname]       VARCHAR (100)   NULL,
    [name]                 VARCHAR (100)   NULL,
    [nameshort]            VARCHAR (100)   NULL,
    [facilityidd]          VARCHAR (100)   NULL,
    [typmigrationsource]   VARCHAR (100)   NULL,
    [dttm]                 DATE            NULL,
    [hours_on]             NUMERIC (18, 4) NULL,
    [gassalesestimate]     FLOAT (53)      NULL,
    [voldispsalehcliq]     FLOAT (53)      NULL,
    [voldispinjectwater]   FLOAT (53)      NULL,
    [volprodallochcliq]    FLOAT (53)      NULL,
    [volprodgathgas]       FLOAT (53)      NULL,
    [volprodgathhcliq]     FLOAT (53)      NULL,
    [volprodgathwater]     FLOAT (53)      NULL,
    [volnewprodallochcliq] FLOAT (53)      NULL,
    [volnewprodallocwater] FLOAT (53)      NULL,
    [volremainrecovhcliq]  FLOAT (53)      NULL,
    [prestub]              FLOAT (53)      NULL,
    [prescas]              FLOAT (53)      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

