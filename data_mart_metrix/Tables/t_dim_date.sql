﻿CREATE TABLE [data_mart_metrix].[t_dim_date] (
    [date_key]                         INT          NOT NULL,
    [full_Date]                        DATETIME     NULL,
    [day_of_month]                     TINYINT      NULL,
    [day_of_month_dd]                  VARCHAR (2)  NULL,
    [day_of_month_with_suffix]         VARCHAR (4)  NULL,
    [day_of_week_name]                 VARCHAR (9)  NULL,
    [day_of_week_name_short]           VARCHAR (9)  NULL,
    [day_of_week_number]               INT          NULL,
    [day_of_Week_in_month]             TINYINT      NULL,
    [day_of_Year_number]               INT          NULL,
    [week_of_year_number]              TINYINT      NULL,
    [week_of_year_number_dd]           VARCHAR (2)  NULL,
    [week_of_month_number]             TINYINT      NULL,
    [week_start_date_full]             DATETIME     NULL,
    [week_start_date_dd_mon_yyyy]      VARCHAR (12) NULL,
    [calendar_month_number]            TINYINT      NULL,
    [calendar_month_name]              VARCHAR (30) NULL,
    [calendar_month_name_short]        VARCHAR (9)  NULL,
    [weekDay_flag]                     CHAR (1)     NULL,
    [first_Day_of_Calendar_month_flag] CHAR (1)     NULL,
    [last_Day_of_Calendar_month_flag]  CHAR (1)     NULL,
    [calendar_quarter_number]          TINYINT      NULL,
    [calendar_quarter_name]            VARCHAR (8)  NULL,
    [calendar_quarter_name_short]      VARCHAR (2)  NULL,
    [calendar_year_number]             INT          NULL,
    [calendar_year_name]               VARCHAR (30) NULL,
    [days_since_20000101]              INT          NULL,
    [weeks_since_20000101]             INT          NULL,
    [months_since_20000101]            INT          NULL,
    [quarters_since_20000101]          INT          NULL,
    [years_since_20000101]             INT          NULL,
    [holiday_flag]                     CHAR (1)     NULL,
    [holiday_description]              VARCHAR (64) NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);
