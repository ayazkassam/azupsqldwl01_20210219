CREATE VIEW [stage].[v_qbyte_corp_hierarchy]
AS SELECT
       hierarchy_code,
       reporting_code_level1,
       reporting_entity_location1,
       corp_code,
       corp_name,
       reporting_code_level2,
       reporting_entity_location2,
       region_code,
       region_name,
       reporting_code_level3,
       reporting_entity_location3,
       district_code,
       district_name,
       reporting_code_level4,
       reporting_entity_location4,
       area_code,
       area_name,
       area_entity_id,
       area_select,
       reporting_code_level5,
       reporting_entity_location5,
       facility_code,
       facility_name,
       facility_entity_id,
       reporting_code_level6,
       reporting_entity_location6,
       cc_num AS cost_centre,
       cc_name AS cost_centre_name,
       sort_key
  FROM
       (
                 SELECT
                        a.hierarchy_code,
                        LTRIM (RTRIM (a.reporting_level_code)) AS reporting_code_level1,
                        LTRIM (RTRIM (a.reporting_entity_location)) AS reporting_entity_location1,
                        a.reporting_entity_code AS corp_code,
                        CASE
                           WHEN a.reporting_entity_desc IS NOT NULL
                             THEN LTRIM (RTRIM ([stage].[InitCap] (a.reporting_entity_desc)
                                               )
                                        )
                           ELSE
                             NULL
                        END AS corp_name,
                        LTRIM (RTRIM (b.reporting_level_code)) AS reporting_code_level2,
                        LTRIM (RTRIM (b.reporting_entity_location)) AS reporting_entity_location2,
                        b.reporting_entity_code AS region_code,
                        CASE
                           WHEN b.reporting_entity_code IS NOT NULL
                            THEN LTRIM (RTRIM ([stage].[InitCap] (b.reporting_entity_desc)
                                              )
                                       )
                           ELSE
                              NULL
                        END AS region_name,
                        LTRIM (RTRIM (c.reporting_level_code)) AS reporting_code_level3,
                        LTRIM (RTRIM (c.reporting_entity_location)) AS reporting_entity_location3,
                        c.reporting_entity_code AS district_code,
                        CASE
                           WHEN c.reporting_entity_desc IS NOT NULL
                              THEN LTRIM (RTRIM ([stage].[InitCap] (c.reporting_entity_desc)))
                           ELSE
                              NULL
                        END AS district_name,
                        LTRIM (RTRIM (d.reporting_level_code)) AS reporting_code_level4,
                        LTRIM (RTRIM (d.reporting_entity_location)) AS reporting_entity_location4,
                        d.reporting_entity_code AS area_code,
                        CASE
                           WHEN d.reporting_entity_desc IS NOT NULL
                              THEN LTRIM (RTRIM ([stage].[InitCap] (d.reporting_entity_desc)))
                           ELSE
                              NULL
                        END AS area_name,
                        CASE
                           WHEN d.reporting_entity_location IS NULL
                              THEN 'NON_SELECT'
                           ELSE
                              d.reporting_entity_location
                        END area_select,
                        d.reporting_entity_id AS area_entity_id,

                        LTRIM (RTRIM (e.reporting_level_code)) AS reporting_code_level5,
                        LTRIM (RTRIM (e.reporting_entity_location)) AS reporting_entity_location5,
                        e.reporting_entity_code AS facility_code,
                        CASE
                           WHEN e.reporting_entity_desc IS NOT NULL
                              THEN LTRIM (RTRIM ([stage].[InitCap] (e.reporting_entity_desc)))
                           ELSE
                              NULL
                        END AS facility_name,
                        e.reporting_entity_id AS facility_entity_id,
                        LTRIM (RTRIM (f.reporting_level_code)) AS reporting_code_level6,
                        LTRIM (RTRIM (f.reporting_entity_location)) AS reporting_entity_location6,
                        CASE
                           WHEN f.reporting_entity_code IS NULL
                              THEN NULL
                           ELSE
                              LTRIM (RTRIM (REPLACE (UPPER (f.reporting_entity_code), '***DUMMY**', 'DUMMY CC')))
                        END AS cc_num,
                        CASE
                           WHEN f.reporting_entity_desc IS NULL
                              THEN NULL
                           ELSE
                              [stage].[InitCap] (LTRIM (RTRIM (  REPLACE (REPLACE (f.reporting_entity_desc, char (9),' '), '***Dummy**', 'Dummy')
                                                                     + ' (' + f.reporting_entity_code + ')'
                                                                    )
                                                             )
                                                      )
                        END AS cc_name,
                        CONCAT (LTRIM (RTRIM (a.reporting_entity_location)),
                                LTRIM (RTRIM (a.reporting_entity_desc)), '_',
                                LTRIM (RTRIM (b.reporting_entity_location)), '_',
                                LTRIM (RTRIM (b.reporting_entity_desc)), '_',
                                LTRIM (RTRIM (c.reporting_entity_location)), '_',
                                LTRIM (RTRIM (c.reporting_entity_desc)), '_',
                                LTRIM (RTRIM (d.reporting_entity_code)), '_',
                                LTRIM (RTRIM (d.reporting_entity_desc)), '_',
                                LTRIM (RTRIM (e.reporting_entity_code)), '_',
                                LTRIM (RTRIM (e.reporting_entity_desc)), '_',
                                LTRIM (RTRIM (f.reporting_entity_code)), '_',
                                LTRIM (RTRIM (f.reporting_entity_desc))
                               ) AS sort_key
                   FROM
                        [stage].[t_qbyte_reporting_entities] a
             INNER JOIN
                        [stage].[t_qbyte_reporting_entities] b
                     ON
                        (    a.reporting_level_code  = b.parent_reporting_level_code
                         AND a.reporting_entity_code = b.parent_reporting_entity_code
                         AND b.hierarchy_code        = a.hierarchy_code)
             INNER JOIN
                        [stage].[t_qbyte_reporting_entities] c
                     ON
                        (    b.reporting_level_code  = c.parent_reporting_level_code
                         AND b.reporting_entity_code = c.parent_reporting_entity_code
                         AND c.hierarchy_code        = a.hierarchy_code)
             INNER JOIN
                        [stage].[t_qbyte_reporting_entities] d
                     ON
                        (    c.reporting_level_code  = d.parent_reporting_level_code
                         AND c.reporting_entity_code = d.parent_reporting_entity_code
                         AND d.hierarchy_code        = a.hierarchy_code)
        LEFT OUTER JOIN
                        [stage].[t_qbyte_reporting_entities] e
                     ON
                        (    d.reporting_level_code  = e.parent_reporting_level_code
                         AND d.reporting_entity_code = e.parent_reporting_entity_code
                         AND e.hierarchy_code        = a.hierarchy_code)
        LEFT OUTER JOIN
                        [stage].[t_qbyte_reporting_entities] f
                     ON
                        (    e.reporting_level_code  = f.parent_reporting_level_code
                         AND e.reporting_entity_code = f.parent_reporting_entity_code
                         AND f.hierarchy_code        = a.hierarchy_code
                        )
                  WHERE
                        LTRIM (RTRIM (a.parent_reporting_entity_code)) IS NULL
                    AND a.hierarchy_code                               = 'CORP HIER'
       ) v;