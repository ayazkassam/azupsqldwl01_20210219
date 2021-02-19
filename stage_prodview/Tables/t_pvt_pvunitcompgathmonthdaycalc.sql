﻿CREATE TABLE [stage_prodview].[t_pvt_pvunitcompgathmonthdaycalc] (
    [idflownet]                    VARCHAR (32)  NOT NULL,
    [idrecparent]                  VARCHAR (32)  NULL,
    [idrec]                        VARCHAR (32)  NOT NULL,
    [idreccomp]                    VARCHAR (32)  NULL,
    [idreccomptk]                  VARCHAR (26)  NULL,
    [dttm]                         DATETIME      NULL,
    [year]                         INT           NULL,
    [month]                        INT           NULL,
    [dayofmonth]                   INT           NULL,
    [durop]                        FLOAT (53)    NULL,
    [durdown]                      FLOAT (53)    NULL,
    [voltotalliq]                  FLOAT (53)    NULL,
    [volhcliq]                     FLOAT (53)    NULL,
    [volgas]                       FLOAT (53)    NULL,
    [volwater]                     FLOAT (53)    NULL,
    [volsand]                      FLOAT (53)    NULL,
    [volcasinggas]                 FLOAT (53)    NULL,
    [volnewprodgathhcliq]          FLOAT (53)    NULL,
    [volnewprodgathgas]            FLOAT (53)    NULL,
    [volnewprodgathwater]          FLOAT (53)    NULL,
    [volnewprodgathsand]           FLOAT (53)    NULL,
    [volgathrecovhcliq]            FLOAT (53)    NULL,
    [volgathrecovgas]              FLOAT (53)    NULL,
    [volgathrecovwater]            FLOAT (53)    NULL,
    [volgathrecovsand]             FLOAT (53)    NULL,
    [volgathinjectrecovgas]        FLOAT (53)    NULL,
    [volgathinjectrecovhcliq]      FLOAT (53)    NULL,
    [volgathinjectrecovwater]      FLOAT (53)    NULL,
    [volgathinjectrecovsand]       FLOAT (53)    NULL,
    [volgathstartremainrecovhcliq] FLOAT (53)    NULL,
    [volgathstartremainrecovgas]   FLOAT (53)    NULL,
    [volgathstartremainrecovwater] FLOAT (53)    NULL,
    [volgathstartremainrecovsand]  FLOAT (53)    NULL,
    [volgathremainrecovhcliq]      FLOAT (53)    NULL,
    [volgathremainrecovgas]        FLOAT (53)    NULL,
    [volgathremainrecovwater]      FLOAT (53)    NULL,
    [volgathremainrecovsand]       FLOAT (53)    NULL,
    [gor]                          FLOAT (53)    NULL,
    [idrecmeasmeth]                VARCHAR (32)  NULL,
    [idrecmeasmethtk]              VARCHAR (26)  NULL,
    [idrecfluidlevel]              VARCHAR (32)  NULL,
    [idrecfluidleveltk]            VARCHAR (26)  NULL,
    [idrectest]                    VARCHAR (32)  NULL,
    [idrectesttk]                  VARCHAR (26)  NULL,
    [idrecparam]                   VARCHAR (32)  NULL,
    [idrecparamtk]                 VARCHAR (26)  NULL,
    [idrecdowntime]                VARCHAR (32)  NULL,
    [idrecdowntimetk]              VARCHAR (26)  NULL,
    [idrecgasanalysis]             VARCHAR (32)  NULL,
    [idrecgasanalysistk]           VARCHAR (26)  NULL,
    [idrechcliqanalysis]           VARCHAR (32)  NULL,
    [idrechcliqanalysistk]         VARCHAR (26)  NULL,
    [idrecoilanalysis]             VARCHAR (32)  NULL,
    [idrecoilanalysistk]           VARCHAR (26)  NULL,
    [idrecwateranalysis]           VARCHAR (32)  NULL,
    [idrecwateranalysistk]         VARCHAR (26)  NULL,
    [idrecstatus]                  VARCHAR (32)  NULL,
    [idrecstatustk]                VARCHAR (26)  NULL,
    [idrecpumpentry]               VARCHAR (32)  NULL,
    [idrecpumpentrytk]             VARCHAR (26)  NULL,
    [idrecfacility]                VARCHAR (32)  NULL,
    [idrecfacilitytk]              VARCHAR (26)  NULL,
    [pumpeff]                      FLOAT (53)    NULL,
    [ratetotalliq]                 FLOAT (53)    NULL,
    [ratehcliq]                    FLOAT (53)    NULL,
    [rategas]                      FLOAT (53)    NULL,
    [ratewater]                    FLOAT (53)    NULL,
    [ratesand]                     FLOAT (53)    NULL,
    [ratechgtotalliq]              FLOAT (53)    NULL,
    [ratechghcliq]                 FLOAT (53)    NULL,
    [ratechggas]                   FLOAT (53)    NULL,
    [ratechgwater]                 FLOAT (53)    NULL,
    [ratechgsand]                  FLOAT (53)    NULL,
    [pctchgtotliq]                 FLOAT (53)    NULL,
    [pctchghcliq]                  FLOAT (53)    NULL,
    [pctchggas]                    FLOAT (53)    NULL,
    [pctchgwater]                  FLOAT (53)    NULL,
    [pctchgsand]                   FLOAT (53)    NULL,
    [rateintol]                    SMALLINT      NULL,
    [ratehcliqintol]               SMALLINT      NULL,
    [rategasintol]                 SMALLINT      NULL,
    [ratewaterintol]               SMALLINT      NULL,
    [ratesandintol]                SMALLINT      NULL,
    [vollosthcliq]                 FLOAT (53)    NULL,
    [vollostgas]                   FLOAT (53)    NULL,
    [vollostwater]                 FLOAT (53)    NULL,
    [vollostsand]                  FLOAT (53)    NULL,
    [voldifftargethcliq]           FLOAT (53)    NULL,
    [voldifftargetgas]             FLOAT (53)    NULL,
    [voldifftargetwater]           FLOAT (53)    NULL,
    [voldifftargetsand]            FLOAT (53)    NULL,
    [volinjecthcliq]               FLOAT (53)    NULL,
    [volinjectgas]                 FLOAT (53)    NULL,
    [volinjectwater]               FLOAT (53)    NULL,
    [volinjectsand]                FLOAT (53)    NULL,
    [syslockmeui]                  SMALLINT      NULL,
    [syslockchildrenui]            SMALLINT      NULL,
    [syslockme]                    SMALLINT      NULL,
    [syslockchildren]              SMALLINT      NULL,
    [syslockdate]                  DATETIME      NULL,
    [sysmoddate]                   DATETIME      NULL,
    [sysmoduser]                   VARCHAR (50)  NULL,
    [syscreatedate]                DATETIME      NULL,
    [syscreateuser]                VARCHAR (50)  NULL,
    [systag]                       VARCHAR (255) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

