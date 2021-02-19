﻿CREATE TABLE [pv30_prodcopy].[pvt_pvunitallocmonthday] (
    [idflownet]                 VARCHAR (32)  NOT NULL,
    [idrecparent]               VARCHAR (32)  NULL,
    [idrec]                     VARCHAR (32)  NOT NULL,
    [idrecunit]                 VARCHAR (32)  NULL,
    [idrecunittk]               VARCHAR (26)  NULL,
    [idreccomp]                 VARCHAR (32)  NULL,
    [idreccomptk]               VARCHAR (26)  NULL,
    [idreccompzone]             VARCHAR (32)  NULL,
    [idreccompzonetk]           VARCHAR (26)  NULL,
    [dttm]                      DATETIME      NULL,
    [year]                      INT           NULL,
    [month]                     INT           NULL,
    [dayofmonth]                INT           NULL,
    [durdown]                   FLOAT (53)    NULL,
    [durop]                     FLOAT (53)    NULL,
    [volprodgathhcliq]          FLOAT (53)    NULL,
    [volprodgathgas]            FLOAT (53)    NULL,
    [volprodgathwater]          FLOAT (53)    NULL,
    [volprodgathsand]           FLOAT (53)    NULL,
    [volprodallochcliq]         FLOAT (53)    NULL,
    [volprodallocoil]           FLOAT (53)    NULL,
    [volprodalloccond]          FLOAT (53)    NULL,
    [volprodallocngl]           FLOAT (53)    NULL,
    [volprodallochcliqgaseq]    FLOAT (53)    NULL,
    [volprodallocgas]           FLOAT (53)    NULL,
    [volprodallocwater]         FLOAT (53)    NULL,
    [volprodallocsand]          FLOAT (53)    NULL,
    [allocfacthcliq]            FLOAT (53)    NULL,
    [allocfactgas]              FLOAT (53)    NULL,
    [allocfactwater]            FLOAT (53)    NULL,
    [allocfactsand]             FLOAT (53)    NULL,
    [volnewprodallochcliq]      FLOAT (53)    NULL,
    [volnewprodallocoil]        FLOAT (53)    NULL,
    [volnewprodalloccond]       FLOAT (53)    NULL,
    [volnewprodallocngl]        FLOAT (53)    NULL,
    [volnewprodallochcliqgaseq] FLOAT (53)    NULL,
    [volnewprodallocgas]        FLOAT (53)    NULL,
    [volnewprodallocwater]      FLOAT (53)    NULL,
    [volnewprodallocsand]       FLOAT (53)    NULL,
    [wihcliq]                   FLOAT (53)    NULL,
    [wigas]                     FLOAT (53)    NULL,
    [wiwater]                   FLOAT (53)    NULL,
    [wisand]                    FLOAT (53)    NULL,
    [nrihcliq]                  FLOAT (53)    NULL,
    [nrigas]                    FLOAT (53)    NULL,
    [nriwater]                  FLOAT (53)    NULL,
    [nrisand]                   FLOAT (53)    NULL,
    [vollosthcliq]              FLOAT (53)    NULL,
    [vollostgas]                FLOAT (53)    NULL,
    [vollostwater]              FLOAT (53)    NULL,
    [vollostsand]               FLOAT (53)    NULL,
    [voldifftargethcliq]        FLOAT (53)    NULL,
    [voldifftargetoil]          FLOAT (53)    NULL,
    [voldifftargetcond]         FLOAT (53)    NULL,
    [voldifftargetngl]          FLOAT (53)    NULL,
    [voldifftargetgas]          FLOAT (53)    NULL,
    [voldifftargetwater]        FLOAT (53)    NULL,
    [voldifftargetsand]         FLOAT (53)    NULL,
    [volstartremainrecovhcliq]  FLOAT (53)    NULL,
    [volstartremainrecovgas]    FLOAT (53)    NULL,
    [volstartremainrecovwater]  FLOAT (53)    NULL,
    [volstartremainrecovsand]   FLOAT (53)    NULL,
    [volrecovhcliq]             FLOAT (53)    NULL,
    [volrecovgas]               FLOAT (53)    NULL,
    [volrecovwater]             FLOAT (53)    NULL,
    [volrecovsand]              FLOAT (53)    NULL,
    [volinjectrecovgas]         FLOAT (53)    NULL,
    [volinjectrecovhcliq]       FLOAT (53)    NULL,
    [volinjectrecovwater]       FLOAT (53)    NULL,
    [volinjectrecovsand]        FLOAT (53)    NULL,
    [volremainrecovhcliq]       FLOAT (53)    NULL,
    [volremainrecovgas]         FLOAT (53)    NULL,
    [volremainrecovwater]       FLOAT (53)    NULL,
    [volremainrecovsand]        FLOAT (53)    NULL,
    [volstartinvhcliq]          FLOAT (53)    NULL,
    [volstartinvhcliqgaseq]     FLOAT (53)    NULL,
    [volstartinvwater]          FLOAT (53)    NULL,
    [volstartinvsand]           FLOAT (53)    NULL,
    [volendinvhcliq]            FLOAT (53)    NULL,
    [volendinvhcliqgaseq]       FLOAT (53)    NULL,
    [volendinvwater]            FLOAT (53)    NULL,
    [volendinvsand]             FLOAT (53)    NULL,
    [volchginvhcliq]            FLOAT (53)    NULL,
    [volchginvhcliqgaseq]       FLOAT (53)    NULL,
    [volchginvwater]            FLOAT (53)    NULL,
    [volchginvsand]             FLOAT (53)    NULL,
    [voldispsalehcliq]          FLOAT (53)    NULL,
    [voldispsaleoil]            FLOAT (53)    NULL,
    [voldispsalecond]           FLOAT (53)    NULL,
    [voldispsalengl]            FLOAT (53)    NULL,
    [voldispsalegas]            FLOAT (53)    NULL,
    [voldispfuelgas]            FLOAT (53)    NULL,
    [voldispflaregas]           FLOAT (53)    NULL,
    [voldispincinerategas]      FLOAT (53)    NULL,
    [voldispventgas]            FLOAT (53)    NULL,
    [voldispinjectgas]          FLOAT (53)    NULL,
    [voldispinjectwater]        FLOAT (53)    NULL,
    [volinjecthcliq]            FLOAT (53)    NULL,
    [volinjectgas]              FLOAT (53)    NULL,
    [volinjectwater]            FLOAT (53)    NULL,
    [volinjectsand]             FLOAT (53)    NULL,
    [volprodcumhcliq]           FLOAT (53)    NULL,
    [volprodcumoil]             FLOAT (53)    NULL,
    [volprodcumcond]            FLOAT (53)    NULL,
    [volprodcumngl]             FLOAT (53)    NULL,
    [volprodcumgas]             FLOAT (53)    NULL,
    [volprodcumwater]           FLOAT (53)    NULL,
    [volprodcumsand]            FLOAT (53)    NULL,
    [idrecmeasmeth]             VARCHAR (32)  NULL,
    [idrecmeasmethtk]           VARCHAR (26)  NULL,
    [idrecfluidlevel]           VARCHAR (32)  NULL,
    [idrecfluidleveltk]         VARCHAR (26)  NULL,
    [idrectest]                 VARCHAR (32)  NULL,
    [idrectesttk]               VARCHAR (26)  NULL,
    [idrecparam]                VARCHAR (32)  NULL,
    [idrecparamtk]              VARCHAR (26)  NULL,
    [idrecdowntime]             VARCHAR (32)  NULL,
    [idrecdowntimetk]           VARCHAR (26)  NULL,
    [idrecgasanalysis]          VARCHAR (32)  NULL,
    [idrecgasanalysistk]        VARCHAR (26)  NULL,
    [idrechcliqanalysis]        VARCHAR (32)  NULL,
    [idrechcliqanalysistk]      VARCHAR (26)  NULL,
    [idrecoilanalysis]          VARCHAR (32)  NULL,
    [idrecoilanalysistk]        VARCHAR (26)  NULL,
    [idrecwateranalysis]        VARCHAR (32)  NULL,
    [idrecwateranalysistk]      VARCHAR (26)  NULL,
    [idrecstatus]               VARCHAR (32)  NULL,
    [idrecstatustk]             VARCHAR (26)  NULL,
    [idrecpumpentry]            VARCHAR (32)  NULL,
    [idrecpumpentrytk]          VARCHAR (26)  NULL,
    [idrecfacility]             VARCHAR (32)  NULL,
    [idrecfacilitytk]           VARCHAR (26)  NULL,
    [pumpeff]                   FLOAT (53)    NULL,
    [idreccalcset]              VARCHAR (32)  NULL,
    [idreccalcsettk]            VARCHAR (26)  NULL,
    [syslockmeui]               SMALLINT      NULL,
    [syslockchildrenui]         SMALLINT      NULL,
    [syslockme]                 SMALLINT      NULL,
    [syslockchildren]           SMALLINT      NULL,
    [syslockdate]               DATETIME      NULL,
    [sysmoddate]                DATETIME      NULL,
    [sysmoduser]                VARCHAR (50)  NULL,
    [syscreatedate]             DATETIME      NULL,
    [syscreateuser]             VARCHAR (50)  NULL,
    [systag]                    VARCHAR (255) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

