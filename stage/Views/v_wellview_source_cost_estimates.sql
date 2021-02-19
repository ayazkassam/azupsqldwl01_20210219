CREATE VIEW [stage].[v_wellview_source_cost_estimates]
AS SELECT
               cost.afe_num,
               cost.afe_supp,
               cost.time_period,
               cost.start_date,
               cost.wv_afe_type,
               cost.grs_net_flag,
               CASE
                  WHEN maj.net_major_acct IS NOT NULL
                     THEN maj.net_major_acct + '_' + cost.minor_acct
                  ELSE
                     CASE
                        WHEN cost.major_acct IS NOT NULL
                           THEN cost.major_acct + '_' + cost.minor_acct
                        ELSE
                           NULL
                     END
               END AS gl_net_account,
               cost.major_acct,
               cost.minor_acct,
               'WELLVIEW' AS scenario,
               SUM (cost.amount) AS amount,
               maj.class_code AS maj_class_code,
               CASE WHEN maj.net_major_acct IS NOT NULL THEN 'Y' ELSE 'N' END AS is_valid_qbyte_major,
               cost.is_valid_afe,
			   cost.vendorcode
          FROM 
               (
                --
                         SELECT
                                UPPER (afe.afenumber) AS afe_num,
                                ISNULL (afe.afenumbersupp, 'NO SUPP') AS afe_supp,
                                'GRS' AS grs_net_flag,
                                DateAdd (DD, DateDiff (DD, 0, wr.dttmstart), 0) AS time_period,
                                DateAdd (DD, DateDiff (DD, 0, wh.dttmspud), 0) AS spud_date,
                                FIRST_VALUE (DateAdd (DD, DateDiff (DD, 0, wh.dttmspud), 0))
                                   OVER (PARTITION BY afe.afenumber
                                             ORDER BY DateAdd (DD, DateDiff (DD, 0, wh.dttmspud), 0) ASC
                                        ) AS start_date,
                                'UNKNOWN_AFE_TYPE' AS wv_afe_type,
                                COALESCE (wa.major_acct, afe.afe_major_acct) AS major_acct,
                                COALESCE (wa.minor_acct, afe.afe_minor_acct) AS minor_acct,
                                COALESCE (wa.gl_account, afe.afe_gl_account) AS gl_account,
                                wa.cost AS amount,
                                ISNULL (afe.is_valid_afe, 'N') AS is_valid_afe,
								wa.vendorcode
                           FROM
                                [stage].[t_wellview_wvt_wvwellheader] wh
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
                                        [stage].[t_wellview_wvt_wvjobreportcostgen] a
                                  WHERE
                                        a.cost IS NOT NULL
								  AND (ISNULL(a.systag,'XXX') not in ('Peloton.Integrator.Sv5xWv10xCosts','Peloton.Integrator.Wv9xSv4xCosts')
								  --- version 8>>'Peloton.Integrator.Wv9xSv4xCosts'
								       or isnull(a.syscreateuser,'XXX') <> 'PCESYSVC')
								 -- to avoid double dipping from Siteview as well - Siteview Wins
                                ) wa
                             ON
                                (wh.idwell = wa.idwell)
                     INNER JOIN
                                [stage].[t_wellview_wvt_wvjob] wj
                             ON
                                (wh.idwell = wj.idwell)
                     INNER JOIN
                                [stage].[t_wellview_wvt_wvjobreport] wr
                             ON
                                (    wh.idwell = wr.idwell
                                 AND wj.idrec  = wr.idrecparent
                                 AND wr.idrec  = wa.idrecparent
								 
                                )
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
                                                 a.*,
                                                 CASE WHEN q.afe_num IS NOT NULL THEN 'Y' ELSE 'N' END AS is_valid_afe,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (a.afenumber)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (a.afenumber)))                = 8
                                                        THEN LTRIM (RTRIM (SUBSTRING (LTRIM (RTRIM (a.afenumber)),
                                                                                      1,
                                                                                      CHARINDEX ('.', LTRIM (RTRIM (a.afenumber)), 1) - 1
                                                                                     )
                                                                          )
                                                                   )
                                                  END AS afe_major_acct,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (a.afenumber)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (a.afenumber)))                = 8
                                                        THEN LTRIM (RTRIM (SUBSTRING (LTRIM (RTRIM (a.afenumber)),
                                                                                      CHARINDEX ('.', LTRIM (RTRIM (a.afenumber)), 1) + 1,
                                                                                      LEN (LTRIM (RTRIM (a.afenumber)))
                                                                                     )
                                                                          )
                                                                   )
                                                  END AS afe_minor_acct,
                                                  CASE
                                                     WHEN     CHARINDEX ('.', LTRIM (RTRIM (a.afenumber)), 1) <> 0
                                                          AND LEN (LTRIM (RTRIM (a.afenumber)))                = 8
                                                        THEN LTRIM (RTRIM (REPLACE (LTRIM (RTRIM (a.afenumber)), '.', '_')))
                                                  END AS afe_gl_account
                                            FROM
                                                 [stage].[t_wellview_wvt_wvjobafe] a
                                 LEFT OUTER JOIN
                                                 [stage].[t_qbyte_authorizations_for_expenditure] q
                                              ON
                                                 (LTRIM (RTRIM (a.afenumber)) = q.afe_num)
                                           WHERE
                                                 LTRIM (RTRIM (a.afenumber)) IS NOT NULL
                                ) afe
                             ON
                                (    wj.idwell = afe.idwell
                                 AND wj.idrec  = afe.idrecparent
                                )
                          WHERE     
                                (UPPER (wa.major_acct) <> 'INV' OR wa.major_acct IS NULL)
                            AND (UPPER (wa.minor_acct) <> 'CLR' OR wa.minor_acct IS NULL)
                --
                ) cost
LEFT OUTER JOIN
                [stage].[t_qbyte_major_accounts] maj
             ON
                (cost.major_acct = maj.major_acct)
       GROUP BY
                cost.afe_num,
                cost.afe_supp,
                cost.time_period,
                cost.start_date,
                cost.grs_net_flag,
                cost.wv_afe_type,
                CASE
                   WHEN maj.net_major_acct IS NOT NULL
                      THEN maj.net_major_acct + '_' + cost.minor_acct
                   ELSE
                      CASE
                         WHEN cost.major_acct IS NOT NULL
                            THEN cost.major_acct + '_' + cost.minor_acct
                         ELSE
                            NULL
                      END
                END,
                cost.major_acct,
                cost.minor_acct,
                maj.class_code,
                CASE WHEN maj.net_major_acct IS NOT NULL THEN 'Y' ELSE 'N' END,
                cost.is_valid_afe,
				cost.vendorcode
         HAVING
                SUM (cost.amount) <> 0
--
UNION ALL
--
  SELECT
         cost.afe_num,
         cost.afe_supp,
         cost.time_period,
         cost.start_date,
         cost.wv_afe_type,
         cost.grs_net_flag,
         CASE
            WHEN cost.net_major_acct IS NOT NULL
               THEN cost.net_major_acct + '_' + cost.minor_acct
            ELSE
               CASE
                  WHEN cost.major_acct IS NOT NULL
                     THEN cost.major_acct + '_' + cost.minor_acct
                  ELSE
                     NULL
               END
         END AS gl_net_account,
         cost.major_acct,
         cost.minor_acct,
         'WELLVIEW_TOTAL' AS scenario,
         SUM (cost.costfinalactual) AS amount,
         cost.class_code AS maj_class_code,
         cost.is_valid_qbyte_major,
         cost.is_valid_afe,
		 null vendorcode
    FROM
         (
           --
                   SELECT
                          DISTINCT
                                   UPPER (afe.afenumber) AS afe_num,
                                   ISNULL (afe.afenumbersupp, 'NO SUPP') AS afe_supp,
                                   'GRS' AS grs_net_flag,
                                   FIRST_VALUE (DateAdd (DD, DateDiff (DD, 0, wj.dttmstart), 0))
                                      OVER (PARTITION BY afe.afenumber, wj.costfinalactual
                                                ORDER BY DateAdd (DD, DateDiff (DD, 0, wj.dttmstart), 0) ASC) AS time_period,
                                   FIRST_VALUE (DateAdd (DD, DateDiff (DD, 0, wh.dttmspud), 0))
                                      OVER (PARTITION BY afe.afenumber
                                                ORDER BY DateAdd (DD, DateDiff (DD, 0, wh.dttmspud), 0) ASC) AS spud_date,
                                   FIRST_VALUE (DateAdd (DD, DateDiff (DD, 0, wh.dttmspud), 0))
                                      OVER (PARTITION BY afe.afenumber
                                                ORDER BY DateAdd (DD, DateDiff (DD, 0, wh.dttmspud), 0) ASC) AS start_date,
                                   ISNULL (afe.afe_type_code, 'UNKNOWN_AFE_TYPE') AS wv_afe_type,
                                   xref.major_acct,
                                   xref.minor_acct,
                                   xref.gl_net_account,
                                   xref.net_major_acct,
                                   xref.class_code,
                                   ISNULL (xref.is_valid_qbyte_major, 'N') AS is_valid_qbyte_major,
                                   ISNULL (afe.is_valid_afe, 'N') AS is_valid_afe,
                                   wj.costfinalactual
                              FROM
                                   [stage].[t_wellview_wvt_wvwellheader] wh
               INNER JOIN
                          (SELECT
                                  *
                             FROM
                                  [stage].[t_wellview_wvt_wvjob]
                            WHERE
                                  costfinalactual IS NOT NULL
                          ) wj
                       ON
                          (wh.idwell = wj.idwell)
               INNER JOIN
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
                                           a.*,
                                           CASE WHEN q.afe_num IS NOT NULL THEN 'Y' ELSE 'N' END AS is_valid_afe
                                      FROM
                                           [stage].[t_wellview_wvt_wvjobafe] a
                           LEFT OUTER JOIN
                                           [stage].[t_qbyte_authorizations_for_expenditure] q
                                        ON
                                           (LTRIM (RTRIM (a.afenumber)) = q.afe_num)
                                     WHERE
                                           LTRIM (RTRIM (a.afenumber)) IS NOT NULL
                          ) afe
                       ON (    wj.idwell = afe.idwell
                           AND wj.idwell = afe.idwell
                           AND wj.idrec  = afe.idrecparent
                          )
               INNER JOIN
                          [stage].[t_wellview_wvt_wvjobreport] wr
                       ON
                          (   wh.idwell = wr.idwell
                           AND wj.idrec = wr.idrecparent
						   AND (ISNULL(wr.systag,'XXX') not in ('Peloton.Integrator.Sv5xWv10xCosts','Peloton.Integrator.Wv9xSv4xCosts')
						   --- version 8>> 'Peloton.Integrator.Wv9xSv4xCosts'
						       or isnull(wr.syscreateuser,'XXX') <> 'PCESYSVC')
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
                                           CASE WHEN ma.major_acct IS NOT NULL THEN 'Y' ELSE 'N' END AS is_valid_qbyte_major
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
                          (afe.afe_type = xref.afe_type)
          --
         ) cost
GROUP BY
         cost.afe_num,
         cost.afe_supp,
         cost.time_period,
         cost.start_date,
         cost.grs_net_flag,
         cost.wv_afe_type,
         CASE
            WHEN cost.net_major_acct IS NOT NULL
               THEN cost.net_major_acct + '_' + cost.minor_acct
            ELSE
               CASE
                  WHEN cost.major_acct IS NOT NULL
                     THEN cost.major_acct + '_' + cost.minor_acct
                  ELSE
                     NULL
               END
         END,
         cost.major_acct,
         cost.minor_acct,
         cost.class_code,
         cost.is_valid_qbyte_major,
         cost.is_valid_afe
  HAVING
         SUM (cost.costfinalactual) <> 0;