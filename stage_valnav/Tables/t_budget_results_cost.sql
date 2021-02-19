﻿CREATE TABLE [stage_valnav].[t_budget_results_cost] (
    [RESULT_ID]                    NVARCHAR (50) NOT NULL,
    [STEP_DATE]                    DATETIME2 (7) NOT NULL,
    [OP_WI_GR_FIXED]               FLOAT (53)    NOT NULL,
    [OP_WI_WI_FIXED]               FLOAT (53)    NOT NULL,
    [OP_WI_GR_VARIABLE]            FLOAT (53)    NOT NULL,
    [OP_WI_WI_VARIABLE]            FLOAT (53)    NOT NULL,
    [OP_FI_GR_FIXED]               FLOAT (53)    NOT NULL,
    [OP_FI_WI_VARIABLE]            FLOAT (53)    NOT NULL,
    [OP_FI_GR_VARIABLE]            FLOAT (53)    NOT NULL,
    [OP_FI_WI_FIXED]               FLOAT (53)    NOT NULL,
    [OP_GR_OTHER_REVENUE]          FLOAT (53)    NOT NULL,
    [OP_WI_OTHER_REVENUE]          FLOAT (53)    NOT NULL,
    [CAP_GR_CAN_EXPLORATION]       FLOAT (53)    NOT NULL,
    [CAP_WI_CAN_EXPLORATION]       FLOAT (53)    NOT NULL,
    [CAP_GR_CAN_DEVELOPMENT]       FLOAT (53)    NOT NULL,
    [CAP_WI_CAN_DEVELOPMENT]       FLOAT (53)    NOT NULL,
    [CAP_GR_CAN_ALLOWANCE]         FLOAT (53)    NOT NULL,
    [CAP_WI_CAN_ALLOWANCE]         FLOAT (53)    NOT NULL,
    [CAP_GR_CAN_PROPERTY]          FLOAT (53)    NOT NULL,
    [CAP_WI_CAN_PROPERTY]          FLOAT (53)    NOT NULL,
    [CAP_GR_US_TANGIBLE]           FLOAT (53)    NOT NULL,
    [CAP_WI_US_TANGIBLE]           FLOAT (53)    NOT NULL,
    [CAP_GR_US_INTANGIBLE]         FLOAT (53)    NOT NULL,
    [CAP_WI_US_INTANGIBLE]         FLOAT (53)    NOT NULL,
    [CAP_GR_US_PROP_LEASE]         FLOAT (53)    NOT NULL,
    [CAP_WI_US_PROP_LEASE]         FLOAT (53)    NOT NULL,
    [CAP_GR_US_GG]                 FLOAT (53)    NOT NULL,
    [CAP_WI_US_GG]                 FLOAT (53)    NOT NULL,
    [CAP_GR_ABANDONMENT]           FLOAT (53)    NOT NULL,
    [CAP_WI_ABANDONMENT]           FLOAT (53)    NOT NULL,
    [CAP_GR_SALVAGE]               FLOAT (53)    NOT NULL,
    [CAP_WI_SALVAGE]               FLOAT (53)    NOT NULL,
    [CAP_GR_OTHER]                 FLOAT (53)    NOT NULL,
    [CAP_WI_OTHER]                 FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_CAN_EXPLORATION] FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_CAN_DEVELOPMENT] FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_CAN_ALLOWANCE]   FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_CAN_PROPERTY]    FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_US_TANGIBLE]     FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_US_INTANGIBLE]   FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_US_PROP_LEASE]   FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_US_GG]           FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_ABANDONMENT]     FLOAT (53)    NOT NULL,
    [CAP_UNRISKED_SALVAGE]         FLOAT (53)    NOT NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

