CREATE TABLE [stage].[t_ihs_attributes] (
    [uwi]                   VARCHAR (100)   NOT NULL,
    [crstatus_desc]         VARCHAR (200)   NULL,
    [license_no]            VARCHAR (50)    NULL,
    [surf_location]         VARCHAR (50)    NULL,
    [tvd_depth]             NUMERIC (7, 2)  NULL,
    [total_depth]           NUMERIC (7, 2)  NULL,
    [zone_desc]             VARCHAR (200)   NULL,
    [spud_date]             DATETIME        NULL,
    [rig_release]           DATETIME        NULL,
    [on_production_date]    DATETIME        NULL,
    [deviation_flag]        VARCHAR (50)    NULL,
    [strat_unit_id]         VARCHAR (20)    NULL,
    [primary_product]       VARCHAR (20)    NULL,
    [province_state]        VARCHAR (20)    NOT NULL,
    [location]              VARCHAR (50)    NULL,
    [well_name]             VARCHAR (4000)  NULL,
    [bottom_hole_latitude]  NUMERIC (12, 7) NULL,
    [bottom_hole_longitude] NUMERIC (12, 7) NULL,
    [surface_latitude]      NUMERIC (12, 7) NULL,
    [surface_longitude]     NUMERIC (12, 7) NULL,
    [last_production_date]  DATETIME        NULL,
    [current_licensee]      VARCHAR (100)   NULL,
    [original_licensee]     VARCHAR (500)   NULL,
    [operator]              VARCHAR (100)   NULL,
    [mode]                  VARCHAR (50)    NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

