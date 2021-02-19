CREATE VIEW [stage].[v_acct_non_capital_expenditure]
AS SELECT
                gl.*,
                CASE
                   WHEN COALESCE (qa.acct_desc, qm.major_acct_desc) <> ''
                      THEN [stage].[InitCap] (COALESCE (qa.acct_desc, qm.major_acct_desc)) + ' (' + gl.gl_net_account + ')'
                   ELSE 
                      gl.gl_net_account
                END AS account_description,
                [stage].[InitCap] (qm.major_acct_desc) AS major_account_description,
                qm.class_code AS major_class_code,
                [stage].[InitCap] (qm.code_desc) AS class_code_description,
                qa.product_code
           FROM
                (
                          SELECT
                                 facts.major_acct,
                                 facts.minor_acct,
                                 COALESCE (acct.gl_net_account, facts.gl_account) AS gl_net_account
                            FROM
                                 (SELECT
                                         a.major_acct,
                                         a.minor_acct,
                                         a.major_acct + '_' + a.minor_acct AS gl_account
                                    FROM
                                         [stage].[t_qbyte_cost_estimate_items] a
                                 ) facts
                 LEFT OUTER JOIN
                                 (         SELECT
                                                  a.major_acct,
                                                  a.minor_acct,
                                                  a.acct_desc,
                                                  a.major_acct + '_' + a.minor_acct AS gl_account,
                                                  COALESCE (ma.net_major_acct, a.major_acct) + '_' + a.minor_acct AS gl_net_account
                                             FROM
                                                  [stage].[t_qbyte_accounts] a
                                  LEFT OUTER JOIN 
                                                  [stage].[t_qbyte_major_accounts] ma
                                               ON
                                                  (a.major_acct = ma.major_acct)
                                 ) acct
                              ON
                                 (facts.gl_account = acct.gl_account)
                 --
                 UNION
                 --
                          SELECT                                  
                                 src.major_acct,
                                 src.minor_acct,
                                 COALESCE (major.net_major_acct, src.major_acct) + '_' + src.minor_acct AS gl_net_account                                  
                            FROM
                                 (SELECT
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
                                      AND CASE
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
                                          END IS NOT NULL
                                 ) src
                 LEFT OUTER JOIN
                                 [stage].[t_qbyte_major_accounts] major
                              ON
                                 (src.major_acct = major.major_acct)
                 --
                 UNION
                 --
                          SELECT                                  
                                 src.major_acct,
                                 src.minor_acct,
                                 COALESCE (major.net_major_acct, src.major_acct) + '_' + src.minor_acct AS gl_net_account                                  
                            FROM
                                 (SELECT
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
                                          [stage].[t_wellview_wvt_wvjobreportcostgen] a
                                    WHERE
                                          ISNULL (a.cost, 0) <> 0
                                      AND CASE
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
                                          END IS NOT NULL
                                 ) src
                 LEFT OUTER JOIN
                                 [stage].[t_qbyte_major_accounts] major
                              ON
                                 (src.major_acct = major.major_acct)
                           WHERE
                                 (UPPER (src.major_acct) <> 'INV' OR src.major_acct IS NULL)
                             AND (UPPER (src.minor_acct) <> 'CLR' OR src.minor_acct IS NULL)

				
                 
                ) gl
LEFT OUTER JOIN
				(	SELECT
                        account_id,
                        account_desc
					FROM
                        [stage].[t_ctrl_special_accounts]
	                WHERE
                        COALESCE (is_capital, 0) = 1

					union all
					
					select account_id, account_desc
					from [data_mart].[t_dim_account_hierarchy]
					WHERE is_capital = 1
                ) ctrl
             ON
                (gl.gl_net_account = ctrl.account_id)
LEFT OUTER JOIN
                (SELECT
                        major_acct,
                        minor_acct,
                        acct_desc,
                        major_acct + '_' + minor_acct AS gl_account,
                        prod_code AS product_code
                   FROM
                        [stage].[t_qbyte_accounts]
                ) qa
             ON
                (gl.gl_net_account = qa.gl_account)
LEFT OUTER JOIN
                (         SELECT
                                 ma.*,
                                 code.code_desc
                            FROM
                                 [stage].[t_qbyte_major_accounts] ma
                 LEFT OUTER JOIN 
                                 (SELECT
                                         *
                                    FROM
                                         [stage].[t_qbyte_codes]
                                   WHERE
                                         code_type_code LIKE 'CLASS_CODE'
                                 ) code
                              ON
                                 (ma.class_code = code.code)
                ) qm
             ON
                (gl.major_acct = qm.major_acct)
          WHERE
                ctrl.account_id IS NULL;