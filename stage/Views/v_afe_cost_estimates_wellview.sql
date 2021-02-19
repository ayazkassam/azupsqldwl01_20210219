CREATE VIEW [stage].[v_afe_cost_estimates_wellview]
AS SELECT
                 afe.afe_num,
                 /*
                 CASE
                    WHEN afe.afe_num IS NOT NULL
                       THEN REPLACE ('AFE_' + afe.afe_num, 'AFE_***DUMMY**', 'DUMMY AFE')
                    ELSE
                       'AFE_NOT_REQUIRED'
                 END AS afe_num,
                 */
                 afe.afe_name,
                 cc.cc_num,
                 cc.uwi,
                 es.gl_account,
                 es.gl_net_account,
                 afe.afe_udf_7_code AS project_id,
                 CASE
                    WHEN afe.afe_udf_7_code IS NOT NULL
                       THEN 'PROJECT_'
                            + RIGHT (REPLICATE ('0', 6) + afe.afe_udf_7_code, 6)
                    ELSE
                       'UNKNOWN_CAPITAL_PROJECT'
                 END AS capital_project_number,
                 CASE
                    WHEN ISNULL (afe.managing_org_id, org2.org_id) IS NOT NULL
                       THEN 'ORG_' + CONVERT (NVARCHAR (25), ISNULL (afe.managing_org_id, org2.org_id))
                    ELSE
                       'UNKNOWN_ORG'
                 END AS organizations,
                 ISNULL (afe.managing_org_id, org2.org_id) AS org_id,
                 CASE
                    WHEN es.afe_num IS NULL
                       THEN 'OP'
                    WHEN org2.org_id IS NULL
                       THEN 'NOP'
                    ELSE
                       'OP'
                 END AS op_flag,
                 cc.operator_client_id,
                 cc.contract_operator_client_id,
				 CASE WHEN vendor.vendor_key IS NULL
				     THEN  '-1'
					 ELSE  es.vendorcode
				 END  vendor_id, --'-1' AS vendor_id,
                 'Unspecified Job Type' AS afe_job_type,
                 'Unspecified Job SubType' AS afe_job_subtype,
                 'Unspecified Status' AS afe_job_status1,
                 'Unspecified Status Details' AS afe_job_status2,
                 CASE
                    WHEN cc.well_stat_code IS NOT NULL
                       THEN 'WS_' + cc.well_stat_code
                    ELSE
                      'No_Well_Status'
                 END AS well_status,
                 CASE
                    WHEN cc.primary_prod_code IS NOT NULL
                       THEN 'Prod_' + cc.primary_prod_code
                    ELSE
                       'No_Primary_Product'
                 END AS primary_product,
                 CASE
                    WHEN cc.cc_udf_2_code IS NOT NULL
                       THEN 'TAX_' + cc.cc_udf_2_code
                    ELSE
                       'UNDEFINED_TAX_STREAM'
                 END AS tax_stream,
                 CASE
                    WHEN afe.engineer_assigned IS NOT NULL
                       THEN 'RESP_' + afe.engineer_assigned
                    ELSE
                       'NO_ASSIGNED_RESPONSIBILITY'
                 END AS engineer_assigned,
                 CASE UPPER (cc.cc_udf_12_code)
                    WHEN 'NA'
                       THEN 'No_Run_Id'
                    WHEN NULL
                       THEN 'No_Run_Id'
                    ELSE
                       'RUN_' + cc.cc_udf_12_code
                 END AS run_id,
                 CASE UPPER (cc.cc_udf_13_code)
                    WHEN 'BASE'
                       THEN 'PRIOR'
                    WHEN 'NA'
                       THEN 'No_Budget_Year'
                    WHEN NULL
                       THEN 'No_Budget_Year'
                    ELSE
                       'BY' + cc.cc_udf_13_code
                 END AS base_incr,
                 CASE UPPER (cc.cc_udf_15_code)
                    WHEN 'NA'
                       THEN 'No_Budget_Group'
                    WHEN NULL
                       THEN 'No_Budget_Group'
                    ELSE
                       'BG_' + cc.cc_udf_15_code
                 END AS play,
                 CASE UPPER (cc.cc_udf_14_code)
                    WHEN 'INCR'
                       THEN 'No_Acquisition_Code'
                    WHEN 'NA'
                       THEN 'No_Acquisition_Code'
                    WHEN NULL
                       THEN 'No_Acquisition_Code'
                    ELSE
                       'ACQ_' + cc.cc_udf_14_code
                 END AS acquisitions,
                 CASE UPPER (cc.cc_udf_10_code)
                    WHEN NULL
                       THEN 'No_Disposition_Code'
                    ELSE
                       'DISP_' + cc.cc_udf_10_code
                 END AS dispositions,
                 CASE
                    WHEN cc.cc_udf_12_code IS NOT NULL
                       THEN 'PT_' + cc.cc_udf_12_code
                    ELSE
                       'NO_PAYOUT_TYPE'
                 END AS payout_type,
                 ISNULL (cc.province, 'NO_PROVINCE_CODE') AS province,
                 --cc.onstream_date,
                 --ISNULL (cc.onstream_year, 'UNDEFINED_ONSTREAM_YEAR') AS onstream_year,
                 ISNULL (org1.op_curr_code, org2.op_curr_code) AS op_curr_code,
                 ISNULL (org1.reporting_curr_code, org2.reporting_curr_code) AS reporting_curr_code,
                 ISNULL (afe.client_id, 'NO_AFE_OP') AS afe_client_id,
                 afe.client_name AS afe_client_name,
                 CASE
                    WHEN afe.afe_start_date IS NOT NULL
                       THEN   'SD_'
                            + CONVERT (NVARCHAR (4), DATEPART (YEAR, afe.afe_start_date))
                            + '_'
                            + SUBSTRING (CONVERT (NVARCHAR (6), afe.afe_start_date, 112), 5, 2)
                    ELSE
                       'UNDEFINED_START_DATE'
                 END AS afe_start_date,
                 afe.afe_approval_date,
                 CASE
                    WHEN ISNULL (afe.afe_udf_1_code,
                                 ISNULL (afe.budget_activity_year, afe.extrapolated_budget_year)) IS NOT NULL
                       THEN REPLACE ('BY' + ISNULL (afe.afe_udf_1_code,
                                                    ISNULL (afe.budget_activity_year,
                                                            afe.extrapolated_budget_year)),
                                     'BYPRIOR PER',
                                     'PRIOR_PERIOD')
                    ELSE
                       'UNDEFINED_BUDGET_YEAR'
                 END AS budget_year,
                 ISNULL (afe.project_approval_status, 'UNKNOWN_APPROVAL_STATUS') AS project_approval_status,
                 ISNULL (afe.project_execution_status, 'UNKNOWN_EXECUTION_STATUS') AS project_execution_status,
                 CASE
                    WHEN afe.acct_yr < am.min_yr
                       THEN DATEADD (MONTH,
                                     DATEDIFF (MONTH, 0,
                                               DATEADD (MONTH, -1, CONVERT (  DATETIME, '01/JAN/'
                                                                            + CONVERT (NVARCHAR (4), am.min_yr
                                                                                      )
                                                                           )
                                                       )
                                              ) + 1, 0
                                    ) - 1
                    WHEN afe.acct_yr > am.max_yr
                       THEN DATEADD (MONTH,
                                     DATEDIFF (MONTH, 0,
                                               DATEADD (MONTH, 1, CONVERT (  DATETIME, '01/JAN/'
                                                                           + CONVERT (NVARCHAR (4), am.max_yr
                                                                                     )
                                                                          )
                                                       )
                                              ) + 1, 0
                                    ) - 1
                    ELSE
                       DATEADD (MONTH, DATEDIFF (MONTH, 0, es.time_period) + 1, 0) - 1
                 END AS afe_date,
                 CASE
                    WHEN afe.acct_yr < am.min_yr
                       THEN 'APre' + CONVERT (NVARCHAR (4), am.min_yr)
                    WHEN afe.acct_yr > am.max_yr
                       THEN 'Future_AM'
                    WHEN afe.acct_yr IS NULL
                       THEN 'A1980_01'
                    ELSE
                         'A' + CONVERT (NVARCHAR (4), DATEPART (YEAR, es.time_period))
                       + '_' + SUBSTRING (CONVERT (NVARCHAR (6), es.time_period, 112), 5, 2)
                 END AS acct_mnth,
                 afe.acct_yr,
                 CASE
                    WHEN afe.prod_yr BETWEEN pm.min_yr AND pm.max_yr
                       THEN    'P' + CONVERT (NVARCHAR (4), DATEPART (YEAR, es.time_period))
                             + '_' + SUBSTRING (CONVERT (NVARCHAR (6), es.time_period, 112), 5, 2)
                    WHEN     afe.prod_yr IS NULL
                         AND afe.acct_yr BETWEEN pm.min_yr AND pm.max_yr
                       THEN   'P' + CONVERT (NVARCHAR (4), DATEPART (YEAR, es.time_period))
                            + '_' + SUBSTRING (CONVERT (NVARCHAR (6), es.time_period, 112), 5, 2)
                    WHEN    afe.prod_yr < pm.min_yr
                         OR (afe.prod_yr IS NULL AND afe.acct_yr < pm.min_yr)
                       THEN 'PPre' + CONVERT (NVARCHAR (4), pm.min_yr)
                    WHEN    afe.prod_yr > pm.max_yr
                         OR (afe.prod_yr IS NULL AND afe.acct_yr > pm.max_yr)
                       THEN 'Future_PM'
                    ELSE
                       NULL
                 END AS prod_mnth,
                 afe.prod_yr,
                 es.grs_net_flag AS grs_net_indicator,
                 CASE
                    WHEN afe.afe_type_code IS NOT NULL
                       THEN 'AFE_TYPE_' + afe.afe_type_code
                    ELSE
                       'UNDEFINED_AFE_TYPE'
                 END AS afe_type,
                 es.maj_class_code,
                 CASE afe.cip_transfer_flag
                    WHEN 'Y'
                       THEN 'TRANSFERRED'
                    WHEN 'N'
                       THEN 'NON-TRANSFERRED'
                    ELSE
                       'TRANSFER_STATUS_UNKNOWN'
                 END AS wip_expenses,
                 CASE ISNULL (afe.capital_or_dry_hole_exp_code,
                              cc.capital_or_dry_hole_exp_code)
                    WHEN 'C'
                       THEN 'SUCCESSFUL_EFFORT'
                    WHEN 'D'
                       THEN 'UNSUCCESSFUL_EFFORT'
                    WHEN 'Z'
                       THEN 'OTHER_EFFORT'
                    ELSE
                       ISNULL (ISNULL (cc.capital_or_dry_hole_exp_code,
                                       afe.capital_or_dry_hole_exp_code),
                               'UNDETERMINED_EFFORT')
                 END AS capital_or_dry_hole_expense,
                 CASE
                     WHEN afe.tax_code IS NOT NULL
                       THEN 'TAX_' + afe.tax_code
                     ELSE
                       'UNDEFINED_TAX_CODE'
                 END AS tax_code,
                 --CASE
                 --   WHEN ppe.major_minor IS NOT NULL THEN 'PPE_' + ppe.major_minor
                 --   ELSE 'NO_PPE_CODE'
                 --END AS asset_continuity,
                 CASE
                    WHEN afe.afe_stat_code IS NOT NULL
                       THEN 'AFE_STAT_' + afe.afe_stat_code
                    ELSE 'UNDEFINED_AFE_STATUS'
                 END AS afe_status,
                 CASE
                    WHEN afe.afe_start_date IS NOT NULL
                       THEN   'START_DATE_' + CONVERT (NVARCHAR (4), DATEPART (YEAR, afe.afe_start_date))
                            + '_' + UPPER (SUBSTRING (DATENAME (MONTH, afe.afe_start_date), 1, 3))
                    ELSE
                       'NO_START_DATE'
                 END AS start_date,
                 CASE
                    WHEN ISNULL (org1.op_curr_code, org2.op_curr_code) = 'USD'
                       THEN CASE es.grs_net_flag
                               WHEN 'NET'
                                  THEN
                                     (es.amount * ISNULL (afe.net_estimate_pct, 100) / 100)
                               ELSE
                                  es.amount
                            END / cc.cc_per_afe
                    WHEN ISNULL (org1.reporting_curr_code, org2.reporting_curr_code) = 'USD'
                       THEN CASE es.grs_net_flag
                               WHEN 'NET'
                                  THEN
                                     (es.amount * ISNULL (afe.net_estimate_pct, 100) / 100)
                               ELSE
                                  es.amount
                            END / cc.cc_per_afe
                    ELSE NULL
                 END AS us_dollar_amt,
                 CASE
                    WHEN ISNULL (org1.op_curr_code, org2.op_curr_code) = 'CAD'
                       THEN CASE es.grs_net_flag
                               WHEN 'NET'
                                  THEN
                                     (es.amount * ISNULL (afe.net_estimate_pct, 100) / 100)
                               ELSE
                                  es.amount
                            END / cc.cc_per_afe
                    WHEN ISNULL (org1.reporting_curr_code, org2.reporting_curr_code) = 'CAD'
                       THEN CASE es.grs_net_flag
                               WHEN 'NET'
                                  THEN
                                     (es.amount * ISNULL (afe.net_estimate_pct, 100) / 100)
                               ELSE
                                  es.amount
                            END / cc.cc_per_afe
                    ELSE NULL
                 END AS can_dollar_amt,
                 afe.net_estimate_pct AS net_working_interest,
                 CASE
                    WHEN cap.account_id IS NOT NULL
                       THEN 'Y'
                    ELSE
                       'N'
                 END AS is_capital
            FROM
                 (
                  /* Obtain all Wellview AFE estimates irregardless of what net major minor account is tied to each
                     transaction
                  */
                  SELECT
                         wv.*
                    FROM
                         (
                          --
                          /* The same query against the gross dollars is used twice, so that net estimates can also
                             be derived for the same intersections
                          */
                          SELECT
                                 afe_num,
                                 afe_supp,
                                 time_period,
                                 DATEPART (YEAR, time_period) AS acct_yr,
                                 start_date,
                                 'NET' AS grs_net_flag,
                                 CASE
                                    WHEN major_acct IS NOT NULL AND minor_acct IS NOT NULL
                                       THEN major_acct + '_' + minor_acct
                                 END AS gl_account,
                                 gl_net_account,
                                 maj_class_code,
                                 scenario,
								 vendorcode,
                                 amount
                            FROM
                                 [stage].[t_source_cost_estimates_wellview]
                           WHERE
                                 is_valid_afe = 'Y'
						   AND   scenario = 'WELLVIEW'
                          --
                          UNION ALL
                          --
                          SELECT
                                 afe_num,
                                 afe_supp,
                                 time_period,
                                 DATEPART (YEAR, time_period) AS acct_yr,
                                 start_date,
                                 'GRS' AS grs_net_flag,
                                 CASE
                                    WHEN major_acct IS NOT NULL AND minor_acct IS NOT NULL
                                       THEN major_acct + '_' + minor_acct
                                 END AS gl_account,
                                 gl_net_account,
                                 maj_class_code,
                                 scenario,
								 vendorcode,
                                 amount
                            FROM
                                 [stage].[t_source_cost_estimates_wellview]
                           WHERE
                                 is_valid_afe = 'Y'
						    AND   scenario = 'WELLVIEW'
                          --
                         ) wv
                ) es
LEFT OUTER JOIN
                (
                 /* Retrieve a listing of valid AFEs from QByteFM, along with pertinent attribute information */
                           SELECT
                                  ae.afe_num,
                                  [stage].[InitCap] (ae.afe_name) AS afe_name,
                                  op.client_id,
                                  op.client_name,
                                  op.op_nonop,
                                  op.ref_org_id,
                                  ae.managing_org_id,
                                  ae.capital_or_dry_hole_exp_code,
                                  ae.tax_code,
                                  ae.cip_transfer_flag,
                                  ae.afe_type_code,
                                  ae.afe_stat_code,
                                  ae.engineer_assigned,
                                  LTRIM (RTRIM (UPPER (ae.afe_udf_5_code))) AS afe_udf_5_code, /* alternate source of Assigned Engineer information */
                                  LTRIM (RTRIM (ae.afe_udf_7_code)) AS afe_udf_7_code, /* source of Capital Project Number information */
                                  ae.afe_start_date,
                                  ae.approval_date AS afe_approval_date,
                                  LTRIM (RTRIM (UPPER (ae.afe_udf_1_code))) AS afe_udf_1_code,
                                  DATEPART (YEAR, ae.budget_activity_year) AS budget_activity_year,
                                  CASE
                                     WHEN     COALESCE (LEN (REPLACE ([stage].[Translate] (UPPER (SUBSTRING (ae.afe_num, 3, 1)),
                                                                                                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                                                                                 '                          '
                                                                                                ),
                                                                      ' ',
                                                                      ''
                                                                     )
                                                            ),
                                                        0
                                                       ) = 0
                                          AND COALESCE (LEN (REPLACE ([stage].[Translate] (UPPER (SUBSTRING (ae.afe_num, 1, 2)),
                                                                                                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                                                                                 '                          '
                                                                                                ),
                                                                      ' ',
                                                                      ''
                                                                     )
                                                            ),
                                                        0
                                                       ) <> 0
                                          AND ae.afe_num <> '-1'
                                        THEN
                                           DATEPART (YYYY, TRY_CONVERT (DATETIME,
                                                                        CONCAT ('12/31/',
                                                                                RIGHT (  REPLICATE ('0', 2)
                                                                                       + REPLACE ([stage].[Translate] (UPPER (SUBSTRING (ae.afe_num,
                                                                                                                                               1,
                                                                                                                                               2
                                                                                                                                              )
                                                                                                                                   ),
                                                                                                                             'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                                                                                                             '                          '
                                                                                                                            ),
                                                                                                  ' ',
                                                                                                  ''
                                                                                                 ),
                                                                                       2
                                                                                      )
                                                                               ),
                                                                        1
                                                                       )
                                                    )
                                     ELSE
                                        NULL
                                  END AS extrapolated_budget_year,
                                  CAST(NULL AS VARCHAR(100)) AS project_approval_status,
                                  CAST(NULL AS VARCHAR(100)) AS project_execution_status,
                                  ISNULL (DATEADD (dd, DATEDIFF (dd, 0, ae.afe_start_date), 0), DATEADD (dd, DATEDIFF (dd, 0, ae.create_date), 0)) AS calc_afe_date,
                                  DATEPART (YEAR, ISNULL (ae.afe_start_date, ae.create_date)) AS acct_yr,
                                  'ACCOUNTING' AS am_period_type,
                                  DATEPART (YEAR, ISNULL (ae.afe_start_date, ae.create_date)) AS prod_yr,
                                  'PRODUCTION' AS pm_period_type,
                                  net_estimate_pct
                             FROM
                                  [stage].[t_qbyte_authorizations_for_expenditure] ae
                 LEFT OUTER JOIN
                                 (         SELECT
                                                  o.afe_num,
                                                  'OP_' + CONVERT (NVARCHAR (25), o.client_id) AS client_id,
                                                  CASE
                                                     WHEN LTRIM (RTRIM (ba.name_1)) IS NOT NULL
                                                        THEN   LTRIM (RTRIM ([stage].[InitCap] (ba.name_1)))
                                                             + ' (OP_'
                                                             + CONVERT (NVARCHAR (25), o.client_id)
                                                             + ')'
                                                     ELSE
                                                        NULL
                                                  END AS client_name,
                                                  CASE
                                                     WHEN LTRIM (RTRIM (ba.ref_org_id)) IS NOT NULL
                                                        THEN 'OP'
                                                     ELSE
                                                        'NOP'
                                                  END AS op_nonop,
                                                  LTRIM (RTRIM (ba.ref_org_id)) AS ref_org_id
                                             FROM
                                                  (SELECT
                                                          DISTINCT
                                                                   FIRST_VALUE (client_id)
                                                                      OVER (PARTITION BY
                                                                                         afe_num
                                                                                ORDER BY
                                                                                         last_update_date DESC,
                                                                                         last_update_user,
                                                                                         create_date
                                                                           ) AS client_id,
                                                                   afe_num
                                                              FROM
                                                                   [stage].[t_qbyte_operator_afes]
                                                  ) o
                                  LEFT OUTER JOIN
                                                  [stage].[t_qbyte_business_associates] ba
                                               ON
                                                  o.client_id = ba.id
                                 ) op
                              ON
                                 (ae.afe_num = op.afe_num)
                ) afe
             ON
                (es.afe_num = afe.afe_num)
LEFT OUTER JOIN
                (
                 /* Retrieve all valid AFEs with ties to cost centres from QByteFM, along with pertinent cost centre
                    information
                 */
                          SELECT
                                 acc.afe_num,
                                 ISNULL (acc.cc_num, c.cc_num) AS cc_num,
                                 COUNT (c.cc_num) OVER (PARTITION BY acc.afe_num) AS cc_per_afe,
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
                                 END AS uwi,
                                 c.location_element_1,
                                 c.location_element_2,
                                 c.location_element_3,
                                 c.location_element_4,
                                 c.location_element_5,
                                 c.location_element_6,
                                 c.location_element_7,
                                 c.cc_type_code,
                                 c.operator_client_id,
                                 c.contract_operator_client_id,
                                 c.capital_or_dry_hole_exp_code,
                                 LTRIM (RTRIM (c.well_stat_code)) AS well_stat_code,
                                 LTRIM (RTRIM (c.primary_prod_code)) AS primary_prod_code,
                                 LTRIM (RTRIM (c.cc_udf_2_code)) AS cc_udf_2_code, /* source of Tax Stream information */
                                 LTRIM (RTRIM (c.cc_udf_10_code)) AS cc_udf_10_code, /* source of Disposition Company information */
                                 LTRIM (RTRIM (c.cc_udf_12_code)) AS cc_udf_12_code, /* source of Run Id information */
                                 LTRIM (RTRIM (c.cc_udf_13_code)) AS cc_udf_13_code, /* source of Budget Year information */
                                 LTRIM (RTRIM (c.cc_udf_14_code)) AS cc_udf_14_code, /* source of Acquisition Company information */
                                 LTRIM (RTRIM (c.cc_udf_15_code)) AS cc_udf_15_code, /* source of Budget Group information */
                                 CASE
                                    WHEN c.cc_num IS NULL
                                       THEN 'OP'
                                    WHEN o1.ref_org_id IS NULL
                                       THEN 'NOP'
                                    ELSE
                                       'OP'
                                 END AS op_flag,
                                 CASE
                                    WHEN    c.cc_num IS NULL
                                         OR c.contract_operator_client_id IS NULL
                                       THEN 'NOT_COP'
                                    WHEN o2.ref_org_id IS NULL
                                       THEN 'COP_BY_OTHERS'
                                    WHEN o2.ref_org_id IS NOT NULL
                                       THEN 'COP_BY_US'
                                    ELSE
                                       NULL
                                 END AS contract_op,
                                 p.member_name AS province--,
                                 --os.onstream_date,
                                 --CASE WHEN os.onstream_date IS NOT NULL THEN 'OS' + os.onstream_year ELSE NULL END AS onstream_year
                            FROM
                                 [stage].[t_qbyte_afes_cost_centres] acc
                      INNER JOIN
                                 [stage].[t_qbyte_cost_centres] c
                              ON
                                 (acc.cc_num = c.cc_num)
                 LEFT OUTER JOIN
                                 (    SELECT
                                             x1.ID,
                                             x1.ref_org_id
                                        FROM
                                             [stage].[t_qbyte_business_associates] x1
                                  INNER JOIN
                                             [stage].[t_qbyte_organizations] y1
                                          ON
                                             (x1.ref_org_id = y1.org_id)
                                 ) o1 /* Used for the derivation of Operated flag */
                              ON
                                 (c.operator_client_id = o1.ID)
                 LEFT OUTER JOIN
                                 (    SELECT
                                             x2.ID,
                                             x2.ref_org_id
                                        FROM
                                             [stage].[t_qbyte_business_associates] x2
                                  INNER JOIN
                                             [stage].[t_qbyte_organizations] y2
                                          ON
                                             (x2.ref_org_id = y2.org_id)
                                 ) o2 /* Used in the derivation of Contract Operated flag */
                              ON
                                 (c.contract_operator_client_id = o2.ID)
                 LEFT OUTER JOIN
                                 (    SELECT
                                             p.code,
                                               CASE c.code
                                                   WHEN 'US'
                                                     THEN 'STATE: '
                                                   ELSE
                                                     'PROVINCE: '
                                               END
                                             + p.code AS member_name
                                        FROM
                                             [stage].[t_qbyte_provinces] p
                                  INNER JOIN
                                             [stage].[t_qbyte_countries] c
                                          ON
                                             (p.country_code = c.code)
                                 ) p
                              ON
                                 (c.province = p.code)
                 --LEFT OUTER JOIN
                 --                ESSBASE.MV_CC_NUM_ONSTREAM_DATES os,
                 --             ON
                 --                (c.cc_num = os.cc_num)
                ) cc
             ON
                (es.afe_num = cc.afe_num) /* Used to derive cost centre capital or dry hole expense flag */
LEFT OUTER JOIN
                (	SELECT account_id
					FROM [stage].[t_ctrl_special_accounts]
					WHERE [is_capital] = 1

					union all

					select account_id
					from [data_mart].t_dim_account_hierarchy
					WHERE is_capital = 1
                ) cap
             ON
                (es.gl_net_account = cap.account_id)
     INNER JOIN
                (SELECT
                        MIN (int_value) AS min_yr,
                        MAX (int_value) AS max_yr,
                        'ACCOUNTING' AS period_type
                   FROM
                        [stage].[t_ctrl_etl_variables]
                  WHERE
                        variable_name IN ('CAPITAL_ACCOUNTING_DATE_START_YEAR', 'CAPITAL_ACCOUNTING_DATE_END_YEAR')
                ) am
             ON
                (afe.am_period_type = am.period_type) /* Obtain minimum and maximum Acct_Mth year information */
     INNER JOIN
                (SELECT
                        'ALL' AS cube_name,
                        'PRODUCTION' AS period_type,
                        MIN (left(int_value,4)) AS min_yr,
                        MAX (left(int_value,4)) AS max_yr
                   FROM
                        [stage].[t_ctrl_etl_variables]
                  WHERE
                        variable_name IN ('CAPITAL_ACTIVITY_DATE_START', 'CAPITAL_ACTIVITY_DATE_END')
                ) pm
             ON
                (afe.pm_period_type = pm.period_type) /* Obtain minimum and maximum Prod_Mth year information */
LEFT OUTER JOIN
                [stage].[t_qbyte_organizations] org1
             ON
                (afe.managing_org_id = org1.org_id)
LEFT OUTER JOIN
                [stage].[t_qbyte_organizations] org2
             ON
                (afe.client_id = 'OP_' + CONVERT (NVARCHAR (25), org2.org_id))
--
LEFT OUTER JOIN 
                (SELECT vn.*, cast(vendor_key as varchar(50)) vendor_key2
				 FROM
				 [data_mart].t_dim_vendor vn
				 )vendor
ON es.vendorcode = vendor.vendor_key2;