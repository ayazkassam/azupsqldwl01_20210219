CREATE VIEW [stage].[v_siteview_source_cost_estimates]
AS SELECT
                LTRIM (RTRIM (UPPER (j.sitename))) AS site_name,
                ISNULL (UPPER (j.refno), 'PENDING/NA') AS afe_num,
                'GRS' AS grs_net_flag,
                DateAdd (DD, DateDiff (DD, 0, ISNULL (jr.dttmstart, jr.syscreatedate)), 0) AS time_period,
                CAST (NULL AS DATE) AS start_date,
                CAST (CASE
                         WHEN maj1.net_major_acct IS NOT NULL
                            THEN maj1.net_major_acct + '_' + jrc.minor_acct
                         WHEN maj2.net_major_acct IS NOT NULL
                            THEN maj2.net_major_acct + '_' + jrc.minor_acct
                         ELSE
                            CASE
                               WHEN jrc.major_acct IS NOT NULL
                                  THEN jrc.major_acct + '_' + jrc.minor_acct
                               WHEN j.afe_major_acct IS NOT NULL
                                  THEN j.afe_major_acct + '_' + jrc.minor_acct
                               ELSE
                                  NULL
                            END
                      END AS NVARCHAR (50)
                     ) AS gl_net_account,
                COALESCE (jrc.major_acct, j.afe_major_acct) AS major_acct,
                COALESCE (jrc.minor_acct, j.afe_minor_acct) AS minor_acct,
                LTRIM (RTRIM (UPPER (jrc.codedes))) AS acct_desc,
                'UNKNOWN_AFE_TYPE' AS sv_afe_type,
                'SITEVIEW' AS scenario,
                ISNULL (jrc.cost, 0) AS amount,
                LTRIM (RTRIM (jrc.vendor)) AS vendor,
                j.idrec AS jobrec,
                jrc.idrec AS costrec,
                COALESCE (maj1.class_code, maj2.class_code) AS maj_class_code,
                CASE
                   WHEN COALESCE (maj1.net_major_acct, maj2.net_major_acct) IS NOT NULL
                      THEN 'Y'
                   ELSE
                      'N'
                END AS is_valid_qbyte_major,
                j.is_valid_afe,
				jrc.vendorcode
           FROM
                (         SELECT
                                 sh.idsite,
                                 sh.sitename,
                                 LTRIM (RTRIM (afe.refno)) AS refno,
                                 afe.allocation,
                                 CASE ISNULL (COUNT (afe.idrec)
                                                 OVER (PARTITION BY sh.idsite,
                                                                    job.idrec),
                                              1)
                                    WHEN 0
                                       THEN 1
                                    ELSE
                                       ISNULL (COUNT (afe.idrec)
                                                  OVER (PARTITION BY sh.idsite,
                                                                     job.idrec),
                                               1)
                                 END AS afe_count,
                                 job.idrec,
                                 afe.idrec AS afe_idrec,
                                 afe.afe_name,
                                 afe.afe_type_code,
                                 afe.afe_type,
                                 ISNULL (afe.is_valid_afe, 'N') AS is_valid_afe,
                                 afe.afe_major_acct,
                                 afe.afe_minor_acct,
                                 afe.afe_gl_account
                            FROM
                                 [stage].[t_siteview_svt_svsiteheader] sh
                      INNER JOIN
                                 [stage].[t_siteview_svt_svjob] job
                              ON
                                 (job.idsite = sh.idsite)
                 LEFT OUTER JOIN
                                 (         SELECT
                                                  q.afe_num,
                                                  q.afe_name,
                                                  q.afe_type_code,
                                                  CASE
                                                     WHEN q.afe_type_code IS NOT NULL
                                                        THEN 'AFE_TYPE_' + q.afe_type_code
                                                     ELSE
                                                                          NULL
                                                  END AS afe_type,
                                                  ja.*,
                                                  CASE
                                                     WHEN q.afe_num IS NOT NULL
                                                        THEN 'Y'
                                                     ELSE
                                                        'N'
                                                  END AS is_valid_afe,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (ja.refno)))                = 8
                                                        THEN LTRIM (RTRIM (SUBSTRING (LTRIM (RTRIM (ja.refno)),
                                                                                      1,
                                                                                      CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) - 1
                                                                                     )
                                                                          )
                                                                   )
                                                  END AS afe_major_acct,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (ja.refno)))                = 8
                                                        THEN LTRIM (RTRIM (SUBSTRING (LTRIM (RTRIM (ja.refno)),
                                                                                      CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) + 1,
                                                                                      LEN (LTRIM (RTRIM (ja.refno)))
                                                                                     )
                                                                          )
                                                                   )
                                                  END AS afe_minor_acct,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (ja.refno)))                = 8
                                                        THEN LTRIM (RTRIM (REPLACE (LTRIM (RTRIM (ja.refno)), '.', '_')))
                                                  END AS afe_gl_account
                                             FROM
                                                  [stage].[t_siteview_svt_svjobafe] ja
                                  LEFT OUTER JOIN
                                                  [stage].[t_qbyte_authorizations_for_expenditure] q
                                               ON
                                                  (LTRIM (RTRIM (ja.refno)) = q.afe_num)
                                            WHERE
                                                  LTRIM (RTRIM (ja.refno)) IS NOT NULL
                                 ) afe
                              ON
                                 (job.idrec = afe.idrecparent)
                ) j
     INNER JOIN
                [stage].[t_siteview_svt_svjobreport] jr
             ON
                (    jr.idsite      = j.idsite
                 AND jr.idrecparent = j.idrec
                )
     INNER JOIN
                (SELECT
                        a.*,
                        CASE
                           WHEN CHARINDEX ('.', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (SUBSTRING (a.code1,
                                                            1,
                                                            CHARINDEX ('.', a.code1, 1) - 1
                                                           )
                                                )
                                         )
                           WHEN CHARINDEX ('-', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (SUBSTRING (a.code1,
                                                            1,
                                                            CHARINDEX ('-', a.code1, 1) - 1
                                                           )
                                                )
                                         )
                           ELSE
                              LTRIM (RTRIM (a.code1))
                        END AS major_acct,
                        CASE
                           WHEN CHARINDEX ('.', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (SUBSTRING (a.code1,
                                                            CHARINDEX ('.', a.code1, 1) + 1,
                                                            LEN (a.code1)
                                                           )
                                                )
                                         )
                           WHEN CHARINDEX ('-', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (SUBSTRING (a.code1,
                                                            CHARINDEX ('-', a.code1, 1) + 1,
                                                            LEN (a.code1)
                                                           )
                                                )
                                         )
                           WHEN CHARINDEX ('-', a.code2, 1) = 0
                              THEN LTRIM (RTRIM (a.code2))
                        END AS minor_acct,
                        CASE
                           WHEN CHARINDEX ('.', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (REPLACE (a.code1, '.', '_')))
                           WHEN CHARINDEX ('-', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (REPLACE (a.code1, '-', '_')))
                           WHEN     CHARINDEX ('.', a.code1, 1) = 0
                                AND CHARINDEX ('-', a.code2, 1) = 0
                                AND LTRIM (RTRIM (a.code1)) <> ''
                                AND LTRIM (RTRIM (a.code2)) <> ''
                              THEN LTRIM (RTRIM (a.code1)) + '_' + LTRIM (RTRIM (a.code2))
                           ELSE
                              NULL
                        END AS gl_account
                   FROM
                        [stage].[t_siteview_svt_svjobreportcost] a
                  WHERE
                        ISNULL (a.cost, 0) <> 0
                    --AND (   LTRIM (RTRIM (a.code1)) IS NOT NULL
                    --     OR LTRIM (RTRIM (a.code2)) IS NOT NULL
                    --    )
                ) jrc
             ON
                (    jrc.idsite         = j.idsite
                 AND jrc.idrecafecustom = j.afe_idrec
                 AND jrc.idrecparent    = jr.idrec
                )
LEFT OUTER JOIN
                [stage].[t_qbyte_major_accounts] maj1
             ON
                (jrc.major_acct = maj1.major_acct)
LEFT OUTER JOIN
                [stage].[t_qbyte_major_accounts] maj2
             ON
                (j.afe_major_acct = maj2.major_acct)
--
UNION
--
         SELECT
                LTRIM (RTRIM (UPPER (j.sitename))) AS site_name,
                ISNULL (UPPER (j.refno), 'PENDING/NA') AS afe_num,
                'GRS' AS grs_net_flag,
                DateAdd (DD, DateDiff (DD, 0, ISNULL (jr.dttmstart, jr.syscreatedate)), 0) AS time_period,
                CAST (NULL AS DATE) AS start_date,
                CAST (CASE
                         WHEN maj1.net_major_acct IS NOT NULL
                            THEN maj1.net_major_acct + '_' + jrc.minor_acct
                         WHEN maj2.net_major_acct IS NOT NULL
                            THEN maj2.net_major_acct + '_' + jrc.minor_acct
                         ELSE
                            CASE
                               WHEN jrc.major_acct IS NOT NULL
                                  THEN jrc.major_acct + '_' + jrc.minor_acct
                               WHEN j.afe_major_acct IS NOT NULL
                                  THEN j.afe_major_acct + '_' + jrc.minor_acct
                               ELSE
                                  NULL
                            END
                      END AS NVARCHAR (50)
                     ) AS gl_net_account,
                COALESCE (jrc.major_acct, j.afe_major_acct) AS major_acct,
                COALESCE (jrc.minor_acct, j.afe_minor_acct) AS minor_acct,
                LTRIM (RTRIM (UPPER (jrc.codedes))) AS acct_desc,
                'UNKNOWN_AFE_TYPE' AS sv_afe_type,
                'SITEVIEW' AS scenario,
                  ISNULL (jrc.cost, 0)
                * CASE j.allocation_total
                     WHEN 0
                        THEN ISNULL (j.allocation, cast(100 as float) / j.afe_count) / 100
                     ELSE
                        ISNULL (j.allocation, 0) / 100
                  END AS amount,
                LTRIM (RTRIM (jrc.vendor)) AS vendor,
                j.idrec AS jobrec,
                jrc.idrec AS costrec,
                COALESCE (maj1.class_code, maj2.class_code) AS maj_class_code,
                CASE
                   WHEN COALESCE (maj1.net_major_acct, maj2.net_major_acct) IS NOT NULL
                      THEN 'Y'
                   ELSE
                      'N'
                END AS is_valid_qbyte_major,
                j.is_valid_afe,
				jrc.vendorcode
           FROM
                (         SELECT
                                 sh.idsite,
                                 sh.sitename,
                                 LTRIM (RTRIM (afe.refno)) AS refno,
                                 afe.allocation,
                                 CASE ISNULL (COUNT (afe.idrec)
                                                 OVER (PARTITION BY sh.idsite,
                                                                    job.idrec),
                                              1)
                                    WHEN 0
                                       THEN 1
                                    ELSE
                                       ISNULL (COUNT (afe.idrec)
                                                  OVER (PARTITION BY sh.idsite,
                                                                     job.idrec),
                                               1)
                                 END AS afe_count,
                                 SUM (ISNULL (allocation, 0))
                                    OVER (PARTITION BY sh.idsite, job.idrec) AS allocation_total,
                                 job.idrec,
                                 afe.idrec AS afe_idrec,
                                 afe.afe_name,
                                 afe.afe_type_code,
                                 afe.afe_type,
                                 ISNULL (afe.is_valid_afe, 'N') AS is_valid_afe,
                                 afe.afe_major_acct,
                                 afe.afe_minor_acct,
                                 afe.afe_gl_account
                            FROM
                                 [stage].[t_siteview_svt_svsiteheader] sh
                      INNER JOIN
                                 [stage].[t_siteview_svt_svjob] job
                              ON
                                 (job.idsite = sh.idsite)
                 LEFT OUTER JOIN
                                 (         SELECT
                                                  q.afe_num,
                                                  q.afe_name,
                                                  q.afe_type_code,
                                                  CASE
                                                     WHEN q.afe_type_code IS NOT NULL
                                                        THEN 'AFE_TYPE_' + q.afe_type_code
                                                     ELSE
                                                                          NULL
                                                  END AS afe_type,
                                                  ja.*,
                                                  CASE
                                                     WHEN q.afe_num IS NOT NULL
                                                        THEN 'Y'
                                                     ELSE
                                                        'N'
                                                  END AS is_valid_afe,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (ja.refno)))                = 8
                                                        THEN LTRIM (RTRIM (SUBSTRING (LTRIM (RTRIM (ja.refno)),
                                                                                      1,
                                                                                      CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) - 1
                                                                                     )
                                                                          )
                                                                   )
                                                  END AS afe_major_acct,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (ja.refno)))                = 8
                                                        THEN LTRIM (RTRIM (SUBSTRING (LTRIM (RTRIM (ja.refno)),
                                                                                      CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) + 1,
                                                                                      LEN (LTRIM (RTRIM (ja.refno)))
                                                                                     )
                                                                          )
                                                                   )
                                                  END AS afe_minor_acct,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (ja.refno)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (ja.refno)))                = 8
                                                        THEN LTRIM (RTRIM (REPLACE (LTRIM (RTRIM (ja.refno)), '.', '_')))
                                                  END AS afe_gl_account
                                             FROM
                                                  [stage].[t_siteview_svt_svjobafe] ja
                                  LEFT OUTER JOIN
                                                  [stage].[t_qbyte_authorizations_for_expenditure] q
                                               ON
                                                  (LTRIM (RTRIM (ja.refno)) = q.afe_num)
                                            WHERE
                                                  LTRIM (RTRIM (ja.refno)) IS NOT NULL
                                 ) afe
                              ON
                                 (job.idrec = afe.idrecparent)
                ) j
     INNER JOIN
                [stage].[t_siteview_svt_svjobreport] jr
             ON
                (    jr.idsite      = j.idsite
                 AND jr.idrecparent = j.idrec
                )
     INNER JOIN
                (SELECT
                        a.*,
                        CASE
                           WHEN CHARINDEX ('.', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (SUBSTRING (a.code1,
                                                            1,
                                                            CHARINDEX ('.', a.code1, 1) - 1
                                                           )
                                                )
                                         )
                           WHEN CHARINDEX ('-', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (SUBSTRING (a.code1,
                                                            1,
                                                            CHARINDEX ('-', a.code1, 1) - 1
                                                           )
                                                )
                                         )
                           ELSE
                              LTRIM (RTRIM (a.code1))
                        END AS major_acct,
                        CASE
                           WHEN CHARINDEX ('.', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (SUBSTRING (a.code1,
                                                            CHARINDEX ('.', a.code1, 1) + 1,
                                                            LEN (a.code1)
                                                           )
                                                )
                                         )
                           WHEN CHARINDEX ('-', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (SUBSTRING (a.code1,
                                                            CHARINDEX ('-', a.code1, 1) + 1,
                                                            LEN (a.code1)
                                                           )
                                                )
                                         )
                           WHEN CHARINDEX ('-', a.code2, 1) = 0
                              THEN LTRIM (RTRIM (a.code2))
                        END AS minor_acct,
                        CASE
                           WHEN CHARINDEX ('.', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (REPLACE (a.code1, '.', '_')))
                           WHEN CHARINDEX ('-', a.code1, 1) <> 0
                              THEN LTRIM (RTRIM (REPLACE (a.code1, '-', '_')))
                           WHEN     CHARINDEX ('.', a.code1, 1) = 0
                                AND CHARINDEX ('-', a.code2, 1) = 0
                                AND LTRIM (RTRIM (a.code1)) <> ''
                                AND LTRIM (RTRIM (a.code2)) <> ''
                              THEN LTRIM (RTRIM (a.code1)) + '_' + LTRIM (RTRIM (a.code2))
                           ELSE
                              NULL
                        END AS gl_account
                   FROM
                        [stage].[t_siteview_svt_svjobreportcost] a
                  WHERE
                        ISNULL (a.cost, 0) <> 0
                    --AND (   LTRIM (RTRIM (a.code1)) IS NOT NULL
                    --     OR LTRIM (RTRIM (a.code2)) IS NOT NULL
                    --    )
                ) jrc
             ON
                (    jrc.idsite      = j.idsite
                 AND jrc.idrecparent = jr.idrec
                )
LEFT OUTER JOIN
                [stage].[t_qbyte_major_accounts] maj1
             ON
                (jrc.major_acct = maj1.major_acct)
LEFT OUTER JOIN
                [stage].[t_qbyte_major_accounts] maj2
             ON
                (j.afe_major_acct = maj2.major_acct)
          WHERE
                jrc.idrecafecustom IS NULL
--
UNION
--
         SELECT
                LTRIM (RTRIM (UPPER (j.sitename))) AS site_name,
                ISNULL (UPPER (j.refno), 'PENDING/NA') AS afe_num,
                'GRS' AS grs_net_flag,
                DateAdd (DD, DateDiff (DD, 0, ISNULL (j.dttmstart, jr.time_period)), 0) AS time_period,
                CAST (NULL AS DATE) AS start_date,
                xref.gl_net_account,
                xref.major_acct,
                xref.minor_acct,
                xref.account_description AS acct_desc,
                ISNULL (j.afe_type_code, 'UNKNOWN_AFE_TYPE') AS sv_afe_type,
                'SITEVIEW_TOTAL' AS scenario,
                ISNULL (j.usernum2, 0) AS amount,
                NULL AS vendor,
                j.idrec AS jobrec,
                NULL AS costrec,
                xref.class_code AS maj_class_code,
                ISNULL (xref.is_valid_qbyte_major, 'N') AS is_valid_qbyte_major,
                j.is_valid_afe,
				null vendorcode
           FROM
                (         SELECT
                                 sh.idsite,
                                 sh.sitename,
                                 LTRIM (RTRIM (afe.refno)) AS refno,
                                 afe.allocation,
                                 CASE ISNULL (COUNT (afe.idrec)
                                                 OVER (PARTITION BY sh.idsite,
                                                                    job.idrec),
                                              1)
                                    WHEN 0
                                       THEN 1
                                    ELSE
                                       ISNULL (COUNT (afe.idrec)
                                                  OVER (PARTITION BY sh.idsite,
                                                                     job.idrec),
                                               1)
                                 END AS afe_count,
                                 job.idrec,
                                 afe.idrec AS afe_idrec,
                                 job.usernum2,
                                 job.dttmstart,
                                 afe.afe_name,
                                 afe.afe_type_code,
                                 afe.afe_type,
                                 ISNULL (afe.is_valid_afe, 'N') AS is_valid_afe
                            FROM
                                 [stage].[t_siteview_svt_svsiteheader] sh
                      INNER JOIN
                                 [stage].[t_siteview_svt_svjob] job
                              ON
                                 (job.idsite = sh.idsite)
                 LEFT OUTER JOIN
                                 (         SELECT
                                                  q.afe_num,
                                                  q.afe_name,
                                                  q.afe_type_code,
                                                  CASE
                                                     WHEN q.afe_type_code IS NOT NULL
                                                        THEN 'AFE_TYPE_' + q.afe_type_code
                                                     ELSE
                                                        NULL
                                                  END AS afe_type,
                                                  ja.*,
                                                  CASE
                                                     WHEN q.afe_num IS NOT NULL
                                                        THEN 'Y'
                                                     ELSE
                                                        'N'
                                                  END AS is_valid_afe
                                             FROM
                                                  [stage].[t_siteview_svt_svjobafe] ja
                                  LEFT OUTER JOIN
                                                  [stage].[t_qbyte_authorizations_for_expenditure] q
                                               ON
                                                  (LTRIM (RTRIM (ja.refno)) = q.afe_num)
                                            WHERE
                                                  LTRIM (RTRIM (ja.refno)) IS NOT NULL
                                 ) afe
                              ON
                                 (job.idrec = afe.idrecparent)
                           WHERE
                                 job.usernum2 IS NOT NULL
                ) j
     INNER JOIN
                (  SELECT
                          idsite,
                          idrecparent,
                          MAX (LTRIM (RTRIM (ISNULL (dttmstart, syscreatedate)))) AS time_period
                     FROM
                          [stage].[t_siteview_svt_svjobreport]
                 GROUP BY
                          idsite,
                          idrecparent
                ) jr
             ON
                (    jr.idsite      = j.idsite
                 AND jr.idrecparent = j.idrec
                )
LEFT OUTER JOIN
                (         SELECT
                                 xt.source_major_acct + '_' + source_minor_acct AS afe_type,
                                 xt.source_desc,
                                 xt.target_major_acct AS major_acct,
                                 xt.target_minor_acct AS minor_acct,
                                 xt.target_major_acct + '_' + target_minor_acct AS gl_net_account,
                                 xt.target_account AS account_description,
                                 xt.target_parent AS parent_account,
                                 ma.class_code,
                                 ma.net_major_acct,
                                 CASE
                                    WHEN ma.major_acct IS NOT NULL
                                       THEN 'Y'
                                    ELSE
                                       'N'
                                 END AS is_valid_qbyte_major
                            FROM
                                 [stage].[t_ctrl_accounts_xref] xt
                 LEFT OUTER JOIN
                                 [stage].[t_qbyte_major_accounts] ma
                              ON
                                 (xt.target_major_acct = ma.major_acct)
                           WHERE
                                 xt.source_app    = 'WELLVIEW'
                             AND xt.source_table  = 'WV_WVJOBAFE'
                             AND xt.source_column = 'afenumber'
                             AND xt.is_active     = 'Y'
                ) xref
             ON
                (j.afe_type = xref.afe_type)
--
UNION
--
         SELECT
                LTRIM (RTRIM (UPPER (j.sitename))) AS site_name,
                ISNULL (UPPER (j.refno), 'PENDING/NA') AS afe_num,
                'GRS' AS grs_net_flag,
                DateAdd (DD, DateDiff (DD, 0, ISNULL (j.dttmstart, jr.time_period)), 0) AS time_period,
                CAST (NULL AS DATE) AS start_date,
                xref.gl_net_account,
                xref.major_acct,
                xref.minor_acct,
                xref.account_description AS acct_desc,
                ISNULL (j.afe_type_code, 'UNKNOWN_AFE_TYPE') AS sv_afe_type,
                'SITEVIEW_TOTAL' AS scenario,
                  ISNULL (j.usernum2, 0)
                * CASE j.allocation_total
                     WHEN 0
                        THEN ISNULL (j.allocation, cast(100 as float) / j.afe_count) / 100
                     ELSE
                         ISNULL (j.allocation, 0) / 100
                  END AS amount,
                NULL AS vendor,
                j.idrec AS jobrec,
                NULL AS costrec,
                xref.class_code AS maj_class_code,
                ISNULL (xref.is_valid_qbyte_major, 'N') AS is_valid_qbyte_major,
                j.is_valid_afe,
				null vendorcode
           FROM 
                (         SELECT
                                 sh.idsite,
                                 sh.sitename,
                                 LTRIM (RTRIM (afe.refno)) AS refno,
                                 afe.allocation,
                                 CASE ISNULL (COUNT (afe.idrec)
                                                 OVER (PARTITION BY sh.idsite,
                                                                    job.idrec),
                                              1)
                                    WHEN 0
                                       THEN 1
                                    ELSE
                                       ISNULL (COUNT (afe.idrec)
                                                  OVER (PARTITION BY sh.idsite,
                                                                    job.idrec),
                                               1)
                                 END AS afe_count,
                                 SUM (ISNULL (allocation, 0))
                                    OVER (PARTITION BY sh.idsite,
                                                       job.idrec
                                         ) AS allocation_total,
                                 job.idrec,
                                 afe.idrec AS afe_idrec,
                                 job.usernum2,
                                 job.dttmstart,
                                 afe.afe_name,
                                 afe.afe_type_code,
                                 afe.afe_type,
                                 ISNULL (afe.is_valid_afe, 'N') AS is_valid_afe
                            FROM
                                 [stage].[t_siteview_svt_svsiteheader] sh
                      INNER JOIN
                                 [stage].[t_siteview_svt_svjob] job
                              ON
                                 (job.idsite = sh.idsite)
                 LEFT OUTER JOIN
                                 (         SELECT
                                                  q.afe_num,
                                                  q.afe_name,
                                                  q.afe_type_code,
                                                  CASE
                                                     WHEN q.afe_type_code IS NOT NULL
                                                        THEN 'AFE_TYPE_' + q.afe_type_code
                                                     ELSE
                                                        NULL
                                                  END AS afe_type,
                                                  ja.*,
                                                  CASE
                                                     WHEN q.afe_num IS NOT NULL
                                                        THEN 'Y'
                                                     ELSE
                                                        'N'
                                                  END AS is_valid_afe
                                             FROM
                                                  [stage].[t_siteview_svt_svjobafe] ja
                                  LEFT OUTER JOIN
                                                  [stage].[t_qbyte_authorizations_for_expenditure] q
                                               ON
                                                  (LTRIM (RTRIM (ja.refno)) = q.afe_num)
                                            WHERE
                                                  LTRIM (RTRIM (ja.refno)) IS NOT NULL
                                 ) afe
                              ON
                                 (job.idrec = afe.idrecparent)
                           WHERE
                                 job.usernum2 IS NOT NULL
                ) j
     INNER JOIN
                (  SELECT
                          idsite,
                          idrecparent,
                          MAX (LTRIM (RTRIM (ISNULL (dttmstart, syscreatedate)))) AS time_period
                     FROM
                          [stage].[t_siteview_svt_svjobreport]
                 GROUP BY
                          idsite,
                          idrecparent
                ) jr
             ON
                (    jr.idsite      = j.idsite
                 AND jr.idrecparent = j.idrec
                )
LEFT OUTER JOIN
                (         SELECT
                                 xt.source_major_acct + '_' + source_minor_acct AS afe_type,
                                 xt.source_desc,
                                 xt.target_major_acct AS major_acct,
                                 xt.target_minor_acct AS minor_acct,
                                 xt.target_major_acct + '_' + target_minor_acct AS gl_net_account,
                                 xt.target_account AS account_description,
                                 xt.target_parent AS parent_account,
                                 ma.class_code,
                                 ma.net_major_acct,
                                 CASE
                                    WHEN ma.major_acct IS NOT NULL
                                       THEN 'Y'
                                    ELSE
                                       'N'
                                 END AS is_valid_qbyte_major
                            FROM
                                 [stage].[t_ctrl_accounts_xref] xt
                 LEFT OUTER JOIN
                                 [stage].[t_qbyte_major_accounts] ma
                              ON
                                 (xt.target_major_acct = ma.major_acct)
                           WHERE
                                 xt.source_app    = 'WELLVIEW'
                             AND xt.source_table  = 'WV_WVJOBAFE'
                             AND xt.source_column = 'afenumber'
                             AND xt.is_active     = 'Y'
                ) xref
             ON
                (j.afe_type = xref.afe_type);