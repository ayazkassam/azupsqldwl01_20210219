﻿CREATE TABLE [stage_ihs].[t_ihs_well] (
    [UWI]                       VARCHAR (20)    NOT NULL,
    [ABANDONMENT_DATE]          DATETIME        NULL,
    [ACTIVE_IND]                VARCHAR (1)     NULL,
    [ASSIGNED_FIELD]            VARCHAR (20)    NULL,
    [BASE_NODE_ID]              VARCHAR (20)    NULL,
    [BOTTOM_HOLE_LATITUDE]      NUMERIC (12, 7) NULL,
    [BOTTOM_HOLE_LONGITUDE]     NUMERIC (12, 7) NULL,
    [CASING_FLANGE_ELEV]        NUMERIC (10, 5) NULL,
    [CASING_FLANGE_ELEV_OUOM]   VARCHAR (20)    NULL,
    [COMPLETION_DATE]           DATETIME        NULL,
    [CONFIDENTIAL_DATE]         DATETIME        NULL,
    [CONFIDENTIAL_DEPTH]        NUMERIC (10, 5) NULL,
    [CONFIDENTIAL_DEPTH_OUOM]   VARCHAR (20)    NULL,
    [CONFIDENTIAL_TYPE]         VARCHAR (20)    NULL,
    [CONFID_STRAT_NAME_SET_ID]  VARCHAR (20)    NULL,
    [CONFID_STRAT_UNIT_ID]      VARCHAR (20)    NULL,
    [COUNTRY]                   VARCHAR (20)    NULL,
    [COUNTY]                    VARCHAR (20)    NULL,
    [CURRENT_CLASS]             VARCHAR (20)    NULL,
    [CURRENT_STATUS]            VARCHAR (20)    NULL,
    [CURRENT_STATUS_DATE]       DATETIME        NULL,
    [DEEPEST_DEPTH]             NUMERIC (10, 5) NULL,
    [DEEPEST_DEPTH_OUOM]        VARCHAR (20)    NULL,
    [DEPTH_DATUM]               VARCHAR (20)    NULL,
    [DEPTH_DATUM_ELEV]          NUMERIC (10, 5) NULL,
    [DEPTH_DATUM_ELEV_OUOM]     VARCHAR (20)    NULL,
    [DERRICK_FLOOR_ELEV]        NUMERIC (10, 5) NULL,
    [DERRICK_FLOOR_ELEV_OUOM]   VARCHAR (20)    NULL,
    [DIFFERENCE_LAT_MSL]        NUMERIC (10, 5) NULL,
    [DISCOVERY_IND]             VARCHAR (1)     NULL,
    [DISTRICT]                  VARCHAR (20)    NULL,
    [DRILL_TD]                  NUMERIC (10, 5) NULL,
    [DRILL_TD_OUOM]             VARCHAR (20)    NULL,
    [EFFECTIVE_DATE]            DATETIME        NULL,
    [ELEV_REF_DATUM]            VARCHAR (20)    NULL,
    [EXPIRY_DATE]               DATETIME        NULL,
    [FAULTED_IND]               VARCHAR (1)     NULL,
    [FINAL_DRILL_DATE]          DATETIME        NULL,
    [FINAL_TD]                  NUMERIC (10, 5) NULL,
    [FINAL_TD_OUOM]             VARCHAR (20)    NULL,
    [GEOGRAPHIC_REGION]         VARCHAR (20)    NULL,
    [GEOLOGIC_PROVINCE]         VARCHAR (20)    NULL,
    [GROUND_ELEV]               NUMERIC (10, 5) NULL,
    [GROUND_ELEV_OUOM]          VARCHAR (20)    NULL,
    [GROUND_ELEV_TYPE]          VARCHAR (20)    NULL,
    [INITIAL_CLASS]             VARCHAR (20)    NULL,
    [KB_ELEV]                   NUMERIC (10, 5) NULL,
    [KB_ELEV_OUOM]              VARCHAR (20)    NULL,
    [LEASE_NAME]                VARCHAR (60)    NULL,
    [LEASE_NUM]                 VARCHAR (20)    NULL,
    [LEGAL_SURVEY_TYPE]         VARCHAR (20)    NULL,
    [LOCATION_TYPE]             VARCHAR (20)    NULL,
    [LOG_TD]                    NUMERIC (10, 5) NULL,
    [LOG_TD_OUOM]               VARCHAR (20)    NULL,
    [MAX_TVD]                   NUMERIC (10, 5) NULL,
    [MAX_TVD_OUOM]              VARCHAR (20)    NULL,
    [NET_PAY]                   NUMERIC (6)     NULL,
    [NET_PAY_OUOM]              VARCHAR (20)    NULL,
    [OLDEST_STRAT_AGE]          NUMERIC (12)    NULL,
    [OLDEST_STRAT_NAME_SET_AGE] VARCHAR (20)    NULL,
    [OLDEST_STRAT_NAME_SET_ID]  VARCHAR (20)    NULL,
    [OLDEST_STRAT_UNIT_ID]      VARCHAR (20)    NULL,
    [OPERATOR]                  VARCHAR (20)    NULL,
    [PARENT_RELATIONSHIP_TYPE]  VARCHAR (20)    NULL,
    [PARENT_UWI]                VARCHAR (20)    NULL,
    [PLATFORM_ID]               VARCHAR (20)    NULL,
    [PLATFORM_SF_TYPE]          VARCHAR (24)    NULL,
    [PLOT_NAME]                 VARCHAR (20)    NULL,
    [PLOT_SYMBOL]               VARCHAR (20)    NULL,
    [PLUGBACK_DEPTH]            NUMERIC (10, 5) NULL,
    [PLUGBACK_DEPTH_OUOM]       VARCHAR (20)    NULL,
    [PPDM_GUID]                 VARCHAR (38)    NULL,
    [PRIMARY_SOURCE]            VARCHAR (20)    NULL,
    [PROFILE_TYPE]              VARCHAR (20)    NULL,
    [PROVINCE_STATE]            VARCHAR (20)    NOT NULL,
    [REGULATORY_AGENCY]         VARCHAR (20)    NULL,
    [REMARK]                    VARCHAR (2000)  NULL,
    [RIG_ON_SITE_DATE]          DATETIME        NULL,
    [RIG_RELEASE_DATE]          DATETIME        NULL,
    [ROTARY_TABLE_ELEV]         NUMERIC (10, 5) NULL,
    [SOURCE_DOCUMENT]           VARCHAR (20)    NULL,
    [SPUD_DATE]                 DATETIME        NULL,
    [STATUS_TYPE]               VARCHAR (20)    NULL,
    [SUBSEA_ELEV_REF_TYPE]      VARCHAR (20)    NULL,
    [SURFACE_LATITUDE]          NUMERIC (12, 7) NULL,
    [SURFACE_LONGITUDE]         NUMERIC (12, 7) NULL,
    [SURFACE_NODE_ID]           VARCHAR (20)    NULL,
    [TAX_CREDIT_CODE]           VARCHAR (20)    NULL,
    [TD_STRAT_AGE]              NUMERIC (12)    NULL,
    [TD_STRAT_NAME_SET_AGE]     VARCHAR (20)    NULL,
    [TD_STRAT_NAME_SET_ID]      VARCHAR (20)    NULL,
    [TD_STRAT_UNIT_ID]          VARCHAR (20)    NULL,
    [WATER_ACOUSTIC_VEL]        NUMERIC (10, 5) NULL,
    [WATER_ACOUSTIC_VEL_OUOM]   VARCHAR (20)    NULL,
    [WATER_DEPTH]               NUMERIC (10, 5) NULL,
    [WATER_DEPTH_DATUM]         VARCHAR (20)    NULL,
    [WATER_DEPTH_OUOM]          VARCHAR (20)    NULL,
    [WELL_EVENT_NUM]            VARCHAR (4)     NULL,
    [WELL_GOVERNMENT_ID]        VARCHAR (20)    NULL,
    [WELL_INTERSECT_MD]         NUMERIC (10, 5) NULL,
    [WELL_NAME]                 VARCHAR (66)    NULL,
    [WELL_NUM]                  VARCHAR (20)    NULL,
    [WELL_NUMERIC_ID]           NUMERIC (12)    NULL,
    [WHIPSTOCK_DEPTH]           NUMERIC (10, 5) NULL,
    [WHIPSTOCK_DEPTH_OUOM]      VARCHAR (20)    NULL,
    [ROW_CHANGED_BY]            VARCHAR (30)    NULL,
    [ROW_CHANGED_DATE]          DATETIME        NULL,
    [ROW_CREATED_BY]            VARCHAR (30)    NULL,
    [ROW_CREATED_DATE]          DATETIME        NULL,
    [ROW_QUALITY]               VARCHAR (20)    NULL,
    [X_CURRENT_LICENSEE]        VARCHAR (20)    NULL,
    [X_EVENT_NUM]               NUMERIC (3)     NULL,
    [X_EVENT_NUM_MAX]           NUMERIC (3)     NULL,
    [X_OFFSHORE_IND]            VARCHAR (20)    NULL,
    [X_ONPROD_DATE]             DATETIME        NULL,
    [X_ONINJECT_DATE]           DATETIME        NULL,
    [X_POOL]                    VARCHAR (20)    NULL,
    [X_UWI_SORT]                VARCHAR (20)    NULL,
    [X_UWI_DISPLAY]             VARCHAR (24)    NULL,
    [X_TD_TVD]                  NUMERIC (10, 5) NULL,
    [X_PLUGBACK_TVD]            NUMERIC (10, 5) NULL,
    [X_WHIPSTOCK_TVD]           NUMERIC (10, 5) NULL,
    [X_ORIGINAL_STATUS]         VARCHAR (20)    NULL,
    [X_ORIGINAL_UNIT]           VARCHAR (12)    NULL,
    [X_PREVIOUS_STATUS]         VARCHAR (20)    NULL,
    [CONFID_STRAT_AGE]          NUMERIC (12)    NULL,
    [X_SURFACE_ABANDON_TYPE]    VARCHAR (20)    NULL,
    [GEOG_COORD_SYSTEM_ID]      VARCHAR (20)    NULL,
    [LOCATION_QUALIFIER]        VARCHAR (20)    NULL,
    [X_CONFIDENTIAL_PERIOD]     VARCHAR (20)    NULL,
    [X_PRIMARY_BOREHOLE_UWI]    VARCHAR (20)    NULL,
    [X_DIGITAL_LOG_IND]         VARCHAR (1)     NULL,
    [X_RASTER_LOG_IND]          VARCHAR (1)     NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

