CREATE TABLE [stage_prodview].[t_pvt_pvunitnodemeterevent] (
    [idflownet]         VARCHAR (32)  NOT NULL,
    [idrecparent]       VARCHAR (32)  NULL,
    [idrec]             VARCHAR (32)  NOT NULL,
    [dttmstart]         DATETIME      NULL,
    [idrecmeterevent]   VARCHAR (32)  NULL,
    [idrecmetereventtk] VARCHAR (26)  NULL,
    [syslockmeui]       SMALLINT      NULL,
    [syslockchildrenui] SMALLINT      NULL,
    [syslockme]         SMALLINT      NULL,
    [syslockchildren]   SMALLINT      NULL,
    [syslockdate]       DATETIME      NULL,
    [sysmoddate]        DATETIME      NULL,
    [sysmoduser]        VARCHAR (50)  NULL,
    [syscreatedate]     DATETIME      NULL,
    [syscreateuser]     VARCHAR (50)  NULL,
    [systag]            VARCHAR (255) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

