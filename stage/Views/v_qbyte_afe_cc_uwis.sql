CREATE VIEW [stage].[v_qbyte_afe_cc_uwis]
AS SELECT
                afe.afe_num AS [afe_num],
                afe.afe_type_code AS [afe_type_code],
                afe.afe_name AS [afe_name],
                afe.afe_stat_code AS [afe_stat_code],
                afe.curr_code AS [curr_code],
                afe.ownership_org_id AS [ownership_org_id],
                afe.jib_flag AS [jib_flag],
                afe.cip_transfer_flag AS [cip_transfer_flag],
                afe.use_jibe_edits_flag AS [use_jibe_edits_flag],
                afe.accrual_flag AS [accrual_flag],
                afe.create_date AS [create_date],
                afe.create_user AS [create_user],
                afe.last_updt_date AS [last_updt_date],
                afe.last_updt_user AS [last_updt_user],
                afe.budget_activity_id AS [budget_activity_id],
                afe.budget_activity_year AS [budget_activity_year],
                afe.effective_date AS [effective_date],
                afe.proposal_date AS [proposal_date],
                afe.approval_date AS [approval_date],
                afe.due_date AS [due_date],
                afe.commitment_date AS [commitment_date],
                afe.alloc_amt AS [alloc_amt],
                afe.tax_code AS [tax_code],
                afe.term_date AS [term_date],
                afe.term_user AS [term_user],
                afe.afe_start_date AS [afe_start_date],
                afe.afe_finish_date AS [afe_finish_date],
                afe.capital_accrual_method_code AS [capital_accrual_method_code],
                afe.managing_org_id AS [managing_org_id],
                afe.net_estimate_pct AS [net_estimate_pct],
                afe.internal_approver AS [internal_approver],
                afe.province AS [province],
                afe.manager_name AS [manager_name],
                afe.success_effort_type_code AS [success_effort_type_code],
                afe.capital_accrual_cc_num AS [capital_accrual_cc_num],
                afe.geologist_assigned AS [geologist_assigned],
                afe.geophysicist_assigned AS [geophysicist_assigned],
                afe.engineer_assigned AS [engineer_assigned],
                afe.equip_component_amt AS [equip_component_amt],
                afe.wrhse_component_amt AS [wrhse_component_amt],
                afe.translation_rate AS [translation_rate],
                afe.original_alloc_amt AS [original_alloc_amt],
                afe.reporting_alloc_amt AS [reporting_alloc_amt],
                afe.allow_other_orgs_code AS [allow_other_orgs_code],
                afe.survey_system_code AS [survey_system_code],
                afe.location_element_1 AS [location_element_1],
                afe.location_element_2 AS [location_element_2],
                afe.location_element_3 AS [location_element_3],
                afe.location_element_4 AS [location_element_4],
                afe.location_element_5 AS [location_element_5],
                afe.location_element_6 AS [location_element_6],
                afe.location_element_7 AS [location_element_7],
                afe.location_element_8 AS [location_element_8],
                afe.last_updt_status_user AS [last_updt_status_user],
                afe.last_updt_status_date AS [last_updt_status_date],
                afe.doi_type_code AS [doi_type_code],
                afe.afe_class_code AS [afe_class_code],
                afe.default_gl_sub_code AS [default_gl_sub_code],
                afe.overhead_start_date AS [overhead_start_date],
                afe.overhead_end_date AS [overhead_end_date],
                afe.afe_udf_1_code AS [afe_udf_1_code],
                afe.afe_udf_2_code AS [afe_udf_2_code],
                afe.afe_udf_3_code AS [afe_udf_3_code],
                afe.afe_udf_4_code AS [afe_udf_4_code],
                afe.afe_udf_5_code AS [afe_udf_5_code],
                afe.afe_udf_6_code AS [afe_udf_6_code],
                afe.afe_udf_7_code AS [afe_udf_7_code],
                afe.afe_udf_8_code AS [afe_udf_8_code],
                afe.afe_udf_9_code AS [afe_udf_9_code],
                afe.afe_udf_10_code AS [afe_udf_10_code],
                afe.afe_udf_11_code AS [afe_udf_11_code],
                afe.afe_udf_12_code AS [afe_udf_12_code],
                afe.afe_udf_13_code AS [afe_udf_13_code],
                afe.afe_udf_14_code AS [afe_udf_14_code],
                afe.afe_udf_15_code AS [afe_udf_15_code],
                afe.afe_udf_16_code AS [afe_udf_16_code],
                afe.afe_udf_17_code AS [afe_udf_17_code],
                afe.afe_udf_18_code AS [afe_udf_18_code],
                afe.afe_udf_19_code AS [afe_udf_19_code],
                afe.afe_udf_20_code AS [afe_udf_20_code],
                afe.afe_reporting_udf_1_code AS [afe_reporting_udf_1_code],
                afe.afe_reporting_udf_2_code AS [afe_reporting_udf_2_code],
                afe.afe_reporting_udf_3_code AS [afe_reporting_udf_3_code],
                afe.capital_or_dry_hole_exp_code AS [capital_or_dry_hole_exp_code],
                afe.last_accrued_date AS [last_accrued_date],
                afe.country_code AS [country_code],
                acc.cc_num AS [cc_num],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                         CONCAT (
                                 UPPER (LTRIM (RTRIM (location_element_1))),                        /* Unique Well Identifier Format and Chronological
                                                                                                       Sequence of Wells Drilled in the Quarter Unit */
                                 UPPER (LTRIM (RTRIM (location_element_2))),                        /* Quarter Unit */
                                 LEFT (LTRIM (RTRIM (location_element_3)) + REPLICATE ('0', 3), 3), /* Unit */
                                 LTRIM (RTRIM (location_element_4)),                                /* Block */
                                 LEFT (LTRIM (RTRIM (location_element_5)) + REPLICATE ('0', 3), 3), /* NTS Map Sheet Number 1 */
                                 UPPER (LTRIM (RTRIM (location_element_6))),                        /* NTS Map Sheet Number 2 */
                                 LEFT (LTRIM (RTRIM (location_element_7)) + REPLICATE ('0', 2), 2), /* NTS Map Sheet Number 3 */
                                 LEFT (LTRIM (RTRIM (location_element_8)) + REPLICATE ('0', 2), 2)  /* Event Sequence Code */
                                 )
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                         CONCAT (
                                 UPPER (LTRIM (RTRIM (location_element_1))),                        /* Unique Well Identifier Format and Chronological
                                                                                                       Sequence of Wells Drilled in the Unit */
                                 LTRIM (RTRIM (location_element_2)),                                /* Unit */
                                 LEFT (LTRIM (RTRIM (location_element_3)) + REPLICATE ('0', 2), 2), /* Section */
                                 LEFT (LTRIM (RTRIM (location_element_4)) + REPLICATE ('0', 2), 2), /* Degrees Latitude */
                                 LEFT (LTRIM (RTRIM (location_element_5)) + REPLICATE ('0', 2), 2), /* Minutes Latitude */
                                 LEFT (LTRIM (RTRIM (location_element_6)) + REPLICATE ('0', 3), 3), /* Degrees Longitude */
                                 LEFT (LTRIM (RTRIM (location_element_7)) + REPLICATE ('0', 2), 2), /* Minutes Longitude */
                                 LTRIM (RTRIM (location_element_8))                                 /* Event Sequence Code */
                                )
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN
                         CONCAT (
                                 LTRIM (RTRIM (location_element_1)),                                /* Unique Well Identifier Format */
                                 LEFT (LTRIM (RTRIM (location_element_2)) + REPLICATE ('0', 2), 2), /* Legal Subdivision */
                                 LEFT (LTRIM (RTRIM (location_element_3)) + REPLICATE ('0', 2), 2), /* Section */
                                 LEFT (LTRIM (RTRIM (location_element_4)) + REPLICATE ('0', 3), 3), /* Township */
                                 LEFT (LTRIM (RTRIM (location_element_5)) + REPLICATE ('0', 2), 2), /* Range */
                                 LTRIM (RTRIM (location_element_6)),                                /* Direction of Range Numbering */
                                 LTRIM (RTRIM (location_element_7)),                                /* Meridian */
                                 LEFT (LTRIM (RTRIM (location_element_8)) + REPLICATE ('0', 2), 2)  /* Event Sequence Code */
                                )
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                          CONCAT (
                                  LTRIM (RTRIM (location_element_1)),                                /* Unique Well Identifier Format and Location Exception */
                                  LEFT (LTRIM (RTRIM (location_element_2)) + REPLICATE ('0', 2), 2), /* Legal Subdivision */
                                  LEFT (LTRIM (RTRIM (location_element_3)) + REPLICATE ('0', 2), 2), /* Section */
                                  LEFT (LTRIM (RTRIM (location_element_4)) + REPLICATE ('0', 3), 3), /* Township */
                                  LEFT (LTRIM (RTRIM (location_element_5)) + REPLICATE ('0', 2), 2), /* Range */
                                  'W',                                                               /* Direction of Range Numbering */
                                  LTRIM (RTRIM (location_element_6)),                                /* Meridian */
                                  LEFT (LTRIM (RTRIM (location_element_7)) + REPLICATE ('0', 2), 2)  /* Event Sequence Code */
                                 ) 
                   ELSE
                      CONCAT (
                              LTRIM (RTRIM (location_element_1)),
                              LTRIM (RTRIM (location_element_2)),
                              LTRIM (RTRIM (location_element_3)),
                              LTRIM (RTRIM (location_element_4)),
                              LTRIM (RTRIM (location_element_5)),
                              LTRIM (RTRIM (location_element_6)),
                              LTRIM (RTRIM (location_element_7)),
                              LTRIM (RTRIM (location_element_8))
                             )
                END AS [uwi],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                         CONCAT (
                                 CASE
                                    WHEN REPLACE (LTRIM (RTRIM (SUBSTRING (location_element_1, 2, 2))), '0', NULL) IS NULL
                                       THEN '0/'
                                    ELSE
                                       CONCAT (UPPER (LTRIM (RTRIM (location_element_1))), '/')
                                 END,                                                             /* Chronological Sequence of Wells Drilled in the Quarter Unit */
                                 UPPER (location_element_2),                                      /* Quarter Unit */
                                 '-',
                                 COALESCE (REPLACE (LTRIM (location_element_3), '0', NULL), '0'), /* Unit */
                                 '-',
                                 location_element_4,                                              /* Block */
                                 '/', 
                                 COALESCE (REPLACE (LTRIM (location_element_5), '0', NULL), '0'), /* NTS Map Sheet Number 1 */
                                 '-',
                                 UPPER (location_element_6),                                      /* NTS Map Sheet Number 2 */
                                 '-',
                                 COALESCE (REPLACE (LTRIM (location_element_7), '0', NULL), '0'), /* NTS Map Sheet Number 3 */
                                 CASE
                                    WHEN LTRIM (RTRIM (location_element_8)) IS NULL
                                       THEN '/00'
                                    ELSE
                                       '/' + LEFT (LTRIM (RTRIM (location_element_8)) + REPLICATE ('0', 2), 2)
                                 END                                                              /* Event Sequence Code */
                                )
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                         CONCAT (
                                 CASE
                                    WHEN SUBSTRING (LTRIM (RTRIM (location_element_1)), 2, 2) IS NULL
                                       THEN NULL
                                    ELSE
                                       SUBSTRING (UPPER (LTRIM (RTRIM (location_element_1))), 2, 2)
                                 END,
                                 '/',
                                 LTRIM (RTRIM (location_element_2)),                                /* Unit */
                                 LEFT (LTRIM (RTRIM (location_element_3)) + REPLICATE ('0', 2), 2), /* Section */
                                 ' ',
                                 LEFT (LTRIM (RTRIM (location_element_4)) + REPLICATE ('0', 2), 2), /* Degrees Latitude */
                                 '-',
                                 LEFT (LTRIM (RTRIM (location_element_5)) + REPLICATE ('0', 2), 2), /* Minutes Latitude */
                                 ' ',
                                 LEFT (LTRIM (RTRIM (location_element_6)) + REPLICATE ('0', 3), 3), /* Degrees Longitude */
                                 '-',
                                 LEFT (LTRIM (RTRIM (location_element_7)) + REPLICATE ('0', 2), 2), /* Minutes Longitude */
                                 '/',
                                 LTRIM (RTRIM (location_element_8))                                 /* Event Sequence Code */
                                )
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN
                         CONCAT (
                                 SUBSTRING (location_element_1, 2, 2),
                                 '/',
                                 location_element_2,                               /* Legal Subdivision */
                                 '-',
                                 location_element_3,                               /* Section */
                                 '-',
                                 location_element_4,                               /* Township */
                                 '-',
                                 location_element_5,                               /* Range */
                                 location_element_6,                               /* Direction of Range Numbering */
                                 location_element_7,                               /* Meridian */
                                 '/',
                                 LEFT (location_element_8 + REPLICATE ('0', 2), 2) /* Event Sequence Code */
                                )
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                         CONCAT (
                                 SUBSTRING (location_element_1, 2, 2),                               /* Location Exception */
                                 '/', 
                                 location_element_2,                                                 /* Legal Subdivision */
                                 '-',
                                 location_element_3,                                                 /* Section */
                                 '-',
                                 location_element_4,                                                 /* Township */
                                 '-',
                                 location_element_5,                                                 /* Range */
                                 'W',                                                                /* Direction of Range Numbering */
                                 location_element_6,                                                 /* Meridian */
                                 '/',
                                 SUBSTRING (LEFT (location_element_7 + REPLICATE ('0', 2), 2), 2, 1) /* Event Sequence Code */
                                )
                   WHEN LEN (CONCAT (
                                     LTRIM (RTRIM (location_element_1)),
                                     LTRIM (RTRIM (location_element_2)),
                                     LTRIM (RTRIM (location_element_3)),
                                     LTRIM (RTRIM (location_element_4)),
                                     LTRIM (RTRIM (location_element_5)),
                                     LTRIM (RTRIM (location_element_6)),
                                     LTRIM (RTRIM (location_element_7)),
                                     LTRIM (RTRIM (location_element_8))
                                    )
                            ) = 16
                      THEN
                         [stage].[InitCap] (CONCAT (LTRIM (RTRIM (location_element_1)),
                                                          LTRIM (RTRIM (location_element_2)),
                                                          LTRIM (RTRIM (location_element_3)),
                                                          LTRIM (RTRIM (location_element_4)),
                                                          LTRIM (RTRIM (location_element_5)),
                                                          LTRIM (RTRIM (location_element_6)),
                                                          LTRIM (RTRIM (location_element_7)),
                                                          LTRIM (RTRIM (location_element_8))
                                                         )
                                                 )
                END AS [uwi_description],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                         CONCAT (
                                 UPPER (LTRIM (RTRIM (location_element_1))),                        /* Unique Well Identifier Format and Chronological
                                                                                                       Sequence of Wells Drilled in the Quarter Unit */
                                 '/',
                                 UPPER (LTRIM (RTRIM (location_element_2))),                        /* Quarter Unit */
                                 '-',
                                 LEFT (LTRIM (RTRIM (location_element_3)) + REPLICATE ('0', 3), 3), /* Unit */
                                 '-',
                                 LTRIM (RTRIM (location_element_4)),                                /* Block */
                                 '/',
                                 LEFT (LTRIM (RTRIM (location_element_5)) + REPLICATE ('0', 3), 3), /* NTS Map Sheet Number 1 */
                                 '-',
                                 UPPER (LTRIM (RTRIM (location_element_6))),                        /* NTS Map Sheet Number 2 */
                                 '-',
                                 LEFT (LTRIM (RTRIM (location_element_7)) + REPLICATE ('0', 2), 2), /* NTS Map Sheet Number 3 */
                                       CASE
                                          WHEN LTRIM (RTRIM (location_element_8)) IS NULL
                                             THEN '/00'
                                          ELSE
                                             '/' + LEFT (LTRIM (RTRIM (location_element_8)) + REPLICATE ('0', 2), 2)
                                       END  /* Event Sequence Code */
                                )
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND   LTRIM (RTRIM (location_element_1))
                            + LTRIM (RTRIM (location_element_2))
                            + LTRIM (RTRIM (location_element_3))
                            + LTRIM (RTRIM (location_element_4))
                            + LTRIM (RTRIM (location_element_5))
                            + LTRIM (RTRIM (location_element_6))
                            + LTRIM (RTRIM (location_element_7))
                            + LTRIM (RTRIM (location_element_8)) IS NOT NULL
                      THEN
                           CASE
                              WHEN SUBSTRING (RTRIM (LTRIM(LOCATION_ELEMENT_1)), 2, 2) IS NULL
                                 THEN SUBSTRING (RTRIM (LTRIM(LOCATION_ELEMENT_1)), 2, 2) + '/'
                              ELSE
                                 NULL
                           END
                         + LTRIM (RTRIM (location_element_2))                                         /* Unit */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_3))), 2) + ' ' /* Section */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_4))), 2) + '-' /* Degrees Latitude */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_5))), 2) + ' ' /* Minutes Latitude */
                         + RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_6))), 3) + '-' /* Degrees Longitude */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_7))), 2) + '/' /* Minutes Longitude */
                         + LTRIM (RTRIM (location_element_8))                                         /* Event Sequence Code */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN
                            SUBSTRING (   location_element_1, 2, 2)
                         + '/' + location_element_2                                   /* Legal Subdivision */
                         + '-' + location_element_3                                   /* Section */
                         + '-' + location_element_4                                   /* Township */
                         + '-' + location_element_5                                   /* Range */
                         + location_element_6                                         /* Direction of Range Numbering */
                         + location_element_7                                         /* Meridian */
                         + '/' + RIGHT (REPLICATE ('0', 2) + (location_element_8), 2) /* Event Sequence Code */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                            SUBSTRING (location_element_1, 1, 3)                  /* Location Exception */
                         + '/' + location_element_2                               /* Legal Subdivision */
                         + '-' + location_element_3                               /* Section */
                         + '-' + location_element_4                               /* Township */ 
                         + '-' + location_element_5                               /* Range */
                         + 'W' + ISNULL (LTRIM (RTRIM (location_element_6)), '0') /* Meridian */
                         + '/' + RIGHT (REPLICATE ('0', 2)                        /* Event Sequence Code */
                         + (ISNULL (LTRIM (RTRIM (location_element_7)), '0')), 2)
                   WHEN LEN (CONCAT (
                                     LTRIM (RTRIM (location_element_1)),
                                     LTRIM (RTRIM (location_element_2)),
                                     LTRIM (RTRIM (location_element_3)),
                                     LTRIM (RTRIM (location_element_4)),
                                     LTRIM (RTRIM (location_element_5)),
                                     LTRIM (RTRIM (location_element_6)),
                                     LTRIM (RTRIM (location_element_7)),
                                     LTRIM (RTRIM (location_element_8))
                                    )
                            ) <> 16
                      THEN [stage].InitCap (  LTRIM (RTRIM (location_element_1))
                                                  + LTRIM (RTRIM (location_element_2))
                                                  + LTRIM (RTRIM (location_element_3))
                                                  + LTRIM (RTRIM (location_element_4))
                                                  + LTRIM (RTRIM (location_element_5))
                                                  + LTRIM (RTRIM (location_element_6))
                                                  + LTRIM (RTRIM (location_element_7))
                                                  + LTRIM (RTRIM (location_element_8))
                                                 )
                END AS [location],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                         CONCAT (
                                 SUBSTRING (LTRIM (RTRIM (location_element_1)), 1, 1),                             /* Survey System Code */
                                 RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_5))), 3),             /* NTS Map Sheet Number 1 */
                                 COALESCE (UPPER (LTRIM (RTRIM (location_element_6))), ''),                        /* NTS Map Sheet Number 2 */
                                 RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_7))), 2),             /* NTS Map Sheet Number 3 */
                                 COALESCE (LTRIM (RTRIM (location_element_4)), ''),                                /* Block */
                                 RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_3))), 3),             /* Unit */
                                 UPPER (LTRIM (RTRIM (location_element_2))),                                       /* Quarter Unit */
                                 RIGHT (REPLICATE ('0', 2) +
                                 (ISNULL (SUBSTRING (UPPER (LTRIM (RTRIM (location_element_1))), 2, 2), '0')), 2), /* Chronological Sequence of Wells
                                                                                                                      Drilled in the Quarter Unit */
                                 CASE
                                    WHEN LTRIM (RTRIM (location_element_8)) IS NULL
                                       THEN '00'
                                    ELSE
                                       LEFT (LTRIM (RTRIM (location_element_8)) + REPLICATE ('0', 2), 2)
                                 END                                                                               /* Event Sequence Code */
                                )
	
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                           SUBSTRING (LTRIM (RTRIM (location_element_1)), 1, 1)                 /* Unique Well Identifier Format */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_4))), 2) /* Degrees Latitude */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_5))), 2) /* Minutes Latitude */
                         + RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_6))), 2) /* Degrees Longitude */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_7))), 2) /* Minutes Longitude */
                         + LTRIM (RTRIM (location_element_8))                                   /* Event Sequence Code */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_3))), 2) /* Section */
                         + LTRIM (RTRIM (location_element_2))                                   /* Unit */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN
                           SUBSTRING (LTRIM (RTRIM (location_element_1)), 1, 1)                     /* Unique Well Identifier Format */
                         + LTRIM (RTRIM (location_element_6))                                       /* Direction of Range Numbering */
                         + LTRIM (RTRIM (location_element_7))                                       /* Meridian */
                         + RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_4))), 3)     /* Township */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_5))), 2)     /* Range */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_3))), 2)     /* Section */
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_2))), 2)     /* Legal Subdivision */
                         + RIGHT (REPLICATE ('0', 2)
                         + (ISNULL (SUBSTRING (LTRIM (RTRIM (location_element_1)), 2, 2), '0')), 2)
                         + RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_8))), 2)     /* Event Sequence Code */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN
                         CONCAT (
                                 SUBSTRING (LTRIM (RTRIM (location_element_1)), 1, 1),                             /* Unique Well Identifier Format */
                                 'W',                                                                              /* Direction of Range Numbering */
                                 ISNULL (LTRIM (RTRIM (location_element_6)), '0'),                                 /* Meridian */
                                 RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_4))), 3),             /* Township */
                                 RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_5))), 2),             /* Range */
                                 RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_3))), 2),             /* Section */
                                 RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_2))), 2),             /* Legal Subdivision */
                                 RIGHT (REPLICATE ('0', 2) + (ISNULL (SUBSTRING (LTRIM (RTRIM (location_element_1)), 2, 2), '0')), 2),
                                 RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_7))), 2)              /* Event Sequence */
                                )
                END AS [sorted_uwi],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN SUBSTRING (LTRIM (RTRIM (location_element_1)), 1, 1) /* Survey System Code */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN SUBSTRING (LTRIM (RTRIM (location_element_1)), 1, 1) /* Unique Well Identifier Format */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN SUBSTRING (LTRIM (RTRIM (location_element_1)), 1, 1) /* Unique Well Identifier Format */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN SUBSTRING (LTRIM (RTRIM (location_element_1)), 1, 1) /* Unique Well Identifier Format */
                END AS [uwi_sort_element_1],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_5))), 3) /* NTS Map Sheet Number 1 */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_4))), 2) /* Degrees Latitude */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN LTRIM (RTRIM (location_element_6)) /* Direction of Range Numbering */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN 'W' /* Direction of Range Numbering */
                END AS [uwi_sort_element_2],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN UPPER (LTRIM (RTRIM (location_element_6))) /* NTS Map Sheet Number 2 */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_5))), 2) /* Minutes Latitude */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN LTRIM (RTRIM (location_element_7)) /* Meridian */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN ISNULL (LTRIM (RTRIM (location_element_6)), '0') /* Meridian */
                END AS [uwi_sort_element_3],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_7))), 2) /* NTS Map Sheet Number 3 */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_6))), 3) /* Degrees Longitude */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_4))), 3) /* Township */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_4))), 2) /* Township */
                END AS [uwi_sort_element_4],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN UPPER (LTRIM (RTRIM (location_element_4))) /* Block */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_7))), 2) /* Minutes Longitude */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_5))), 2) /* Range */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_5))), 2) /* Range */
                END AS [uwi_sort_element_5],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 3) + (LTRIM (RTRIM (location_element_3))), 3) /* Unit */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN LTRIM (RTRIM (location_element_8)) /* Event Sequence Code */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_3))), 3) /* Section */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_3))), 3) /* Section */
                END AS [uwi_sort_element_6],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN UPPER (LTRIM (RTRIM (location_element_2))) /* Quarter Unit */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_3))), 2) /* Section */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_2))), 2) /* Legal Subdivision */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_2))), 2) /* Legal Subdivision */
                END AS [uwi_sort_element_7],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN   RIGHT (REPLICATE ('0', 2)                                                 /* Chronological Sequence of Wells Drilled */
                           + (ISNULL (SUBSTRING (LTRIM (RTRIM (location_element_1)), 2, 2), '0')), 2)  /* in the Quarter Unit */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN LTRIM (RTRIM (location_element_2)) /*) Unit */
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN RIGHT (REPLICATE ('0', 2) + (ISNULL (SUBSTRING (LTRIM (RTRIM (location_element_1)), 2, 2), '0')), 2)
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (ISNULL (SUBSTRING (LTRIM (RTRIM (location_element_1)), 2, 2), '0')), 2)
                END AS [uwi_sort_element_8],
                --
                CASE
                   WHEN     survey_system_code = 'NTS' /* National Topographic System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (ISNULL (LTRIM (RTRIM (location_element_8)), '0')), 2) /* Event Sequence Code */
                   WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN NULL
                   WHEN     survey_system_code = 'FF' /* Free Form */
                        AND LEN (CONCAT (
                                         LTRIM (RTRIM (location_element_1)),
                                         LTRIM (RTRIM (location_element_2)),
                                         LTRIM (RTRIM (location_element_3)),
                                         LTRIM (RTRIM (location_element_4)),
                                         LTRIM (RTRIM (location_element_5)),
                                         LTRIM (RTRIM (location_element_6)),
                                         LTRIM (RTRIM (location_element_7)),
                                         LTRIM (RTRIM (location_element_8))
                                        )
                                ) = 16
                      THEN RIGHT (REPLICATE ('0', 2) + (LTRIM (RTRIM (location_element_8))), 2) /* Event Sequence Code */
                   WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
                        AND CONCAT (
                                    LTRIM (RTRIM (location_element_1)),
                                    LTRIM (RTRIM (location_element_2)),
                                    LTRIM (RTRIM (location_element_3)),
                                    LTRIM (RTRIM (location_element_4)),
                                    LTRIM (RTRIM (location_element_5)),
                                    LTRIM (RTRIM (location_element_6)),
                                    LTRIM (RTRIM (location_element_7)),
                                    LTRIM (RTRIM (location_element_8))
                                   ) IS NOT NULL
                      THEN RIGHT (REPLICATE ('0', 2) + (ISNULL (LTRIM (RTRIM (location_element_7)), '0')), 2) /* Event Sequence */
                END AS [uwi_sort_element_9]
                --
           FROM
                [stage].[t_qbyte_authorizations_for_expenditure] afe
LEFT OUTER JOIN
                (SELECT
                        DISTINCT
                                 q1.afe_num,
                                 /*
                                 CASE
                                    WHEN q1.afe_type_code IN ('ACCRU', 'ACCR')
                                       THEN
                                          q2.cc_num
                                    ELSE
                                       FIRST_VALUE (q2.cc_num)
                                          OVER (PARTITION BY
                                                             q1.afe_num
                                                    ORDER BY
                                                             q2.last_update_date DESC,
                                                             q2.last_update_user,
                                                             q2.create_date
                                               )
                                 END AS cc_num,
                                 */
                                 FIRST_VALUE (q2.cc_num)
                                    OVER (PARTITION BY
                                                       q1.afe_num
                                              ORDER BY
                                                       q2.last_update_date DESC,
                                                       q2.last_update_user,
                                                       q2.create_date
                                         ) AS cc_num,
                                 q1.afe_type_code
                            FROM
                                 [stage].[t_qbyte_authorizations_for_expenditure] q1
                 LEFT OUTER JOIN
                                 [stage].[t_qbyte_afes_cost_centres] q2
                              ON
                                 (q1.afe_num = q2.afe_num)
                ) acc
             ON
                (
                     afe.afe_num       = acc.afe_num
                 AND afe.afe_type_code = acc.afe_type_code
                );