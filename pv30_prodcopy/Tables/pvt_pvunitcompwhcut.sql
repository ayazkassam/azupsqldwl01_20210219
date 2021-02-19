CREATE TABLE [pv30_prodcopy].[pvt_pvunitcompwhcut] (
    [idflownet]         VARCHAR (32)   NOT NULL,
    [idrecparent]       VARCHAR (32)   NULL,
    [idrec]             VARCHAR (32)   NOT NULL,
    [dttmstart]         DATETIME       NULL,
    [bsw]               FLOAT (53)     NULL,
    [sandcut]           FLOAT (53)     NULL,
    [com]               VARCHAR (2000) NULL,
    [syslockmeui]       SMALLINT       NULL,
    [syslockchildrenui] SMALLINT       NULL,
    [syslockme]         SMALLINT       NULL,
    [syslockchildren]   SMALLINT       NULL,
    [syslockdate]       DATETIME       NULL,
    [sysmoddate]        DATETIME       NULL,
    [sysmoduser]        VARCHAR (50)   NULL,
    [syscreatedate]     DATETIME       NULL,
    [syscreateuser]     VARCHAR (50)   NULL,
    [systag]            VARCHAR (255)  NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

