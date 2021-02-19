CREATE TABLE [pv30_prodcopy].[pvt_pvunitcompdowntm] (
    [idflownet]         VARCHAR (32)   NOT NULL,
    [idrecparent]       VARCHAR (32)   NULL,
    [idrec]             VARCHAR (32)   NOT NULL,
    [typdowntm]         VARCHAR (20)   NULL,
    [dttmstart]         DATETIME       NULL,
    [durdownstartday]   FLOAT (53)     NULL,
    [codedowntm1]       VARCHAR (50)   NULL,
    [codedowntm2]       VARCHAR (50)   NULL,
    [codedowntm3]       VARCHAR (50)   NULL,
    [dttmend]           DATETIME       NULL,
    [durdownendday]     FLOAT (53)     NULL,
    [durdowncalc]       FLOAT (53)     NULL,
    [dttmplanend]       DATETIME       NULL,
    [durdownplanend]    FLOAT (53)     NULL,
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

