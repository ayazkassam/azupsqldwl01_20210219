CREATE VIEW [stage].[v_qbyte_source_cost_estimates]
AS SELECT
                cc.cc_num,
                sd.afe_num,
                sd.major_acct,
                sd.minor_acct,
                sd.supp_gross_est,
                sd.supp_net_est,
                sd.orig_gross_est,
                sd.orig_net_est,
                sd.gross_est,
                sd.net_est
           FROM (
                 --
                          /* Source AFE Data for Estimates from a Supplement perspective */
                          SELECT
                                 sup.afe_num,
                                 sup.major_acct,
                                 sup.minor_acct,
                                 sup.supp_gross_est - ISNULL (org.orig_gross_est, 0) AS supp_gross_est,
                                 sup.supp_net_est - ISNULL (org.orig_net_est, 0) AS supp_net_est,
                                 org.orig_gross_est,
                                 org.orig_net_est,
                                 sup.supp_gross_est AS gross_est,
                                 sup.supp_net_est AS net_est
                            FROM
                                 (    SELECT
                                             /* Source of Supplement Estimate Amounts based on MAX AFE supplement and revision numbers */
                                             LTRIM (RTRIM (a.afe_num)) AS afe_num,
                                             a.major_acct,
                                             a.minor_acct,
                                             a.afe_supplement_num,
                                             a.afe_revision_num,
                                             a.gross_cost_est_amt AS supp_gross_est,
                                             a.net_cost_est_amt AS supp_net_est
                                        FROM
                                             [stage].[t_qbyte_cost_estimate_items] a
                                  INNER JOIN
                                             (SELECT
                                                     DISTINCT
                                                              afe_num,
                                                              MAX (afe_revision_num)
                                                                 OVER (PARTITION BY afe_num
                                                                           ORDER BY afe_supplement_num DESC
                                                                      ) AS afe_revision_num,
                                                              MAX (afe_supplement_num)
                                                                 OVER (PARTITION BY afe_num
                                                                           ORDER BY afe_supplement_num DESC
                                                                      ) AS afe_supplement_num
                                                         FROM
                                                              [stage].[t_qbyte_cost_estimate_items]
                                             ) b
                                          ON
                                             (    a.afe_num            = b.afe_num
                                              AND a.afe_revision_num   = b.afe_revision_num
                                              AND a.afe_supplement_num = b.afe_supplement_num
                                             )
                                 ) sup
                 LEFT OUTER JOIN
                                 (SELECT
                                         /* Source of Original AFE Estimate Amounts */
                                         LTRIM (RTRIM (afe_num)) AS afe_num,
                                         major_acct,
                                         minor_acct,
                                         ce.gross_cost_est_amt AS orig_gross_est,
                                         ce.net_cost_est_amt AS orig_net_est
                                    FROM
                                         [stage].[t_qbyte_cost_estimate_items] ce
                                   WHERE
                                         ce.afe_supplement_num = ce.afe_revision_num
                                     AND ce.afe_supplement_num = 0
                                     -- AND (gross_cost_est_amt + net_cost_est_amt) <> 0
                                 ) org
                              ON
                                 (    sup.afe_num    = org.afe_num
                                  AND sup.major_acct = org.major_acct
                                  AND sup.minor_acct = org.minor_acct
                                 )
                           WHERE
                                 sup.minor_acct <> 'CLR'
                 --
                 UNION ALL
                 --
                          /* Source AFE Data for Estimates from an Original AFE perspective */
                          SELECT
                                 org.afe_num,
                                 org.major_acct,
                                 org.minor_acct,
                                 -1 * org.orig_gross_est AS supp_gross_est, /* Automatically reverses the original entry */
                                 -1 * org.orig_net_est AS supp_net_est, /* Automatically reverses the original entry */
                                 org.orig_gross_est,
                                 org.orig_net_est,
                                 sup.supp_gross_est AS gross_est,
                                 sup.supp_net_est AS net_est
                            FROM
                                 (SELECT
                                         /* Source of Original AFE Estimate Amounts */
                                         LTRIM (RTRIM (afe_num)) AS afe_num,
                                         major_acct,
                                          minor_acct,
                                         ce.gross_cost_est_amt AS orig_gross_est,
                                         ce.net_cost_est_amt AS orig_net_est
                                    FROM
                                         [stage].[t_qbyte_cost_estimate_items] ce
                                   WHERE
                                         ce.afe_supplement_num = ce.afe_revision_num
                                     AND ce.afe_supplement_num = 0
                                 ) org
                 LEFT OUTER JOIN
                                 (    SELECT
                                             /* Source of Supplement Estimate Amounts based on MAX AFE supplement and revision numbers */
                                             LTRIM (RTRIM (a.afe_num)) AS afe_num,
                                             a.major_acct,
                                             a.minor_acct,
                                             a.afe_supplement_num,
                                             a.afe_revision_num,
                                             a.gross_cost_est_amt AS supp_gross_est,
                                             a.net_cost_est_amt AS supp_net_est
                                        FROM
                                             [stage].[t_qbyte_cost_estimate_items] a
                                  INNER JOIN
                                             (SELECT
                                                     DISTINCT
                                                              afe_num,
                                                              MAX (afe_revision_num)
                                                                 OVER (PARTITION BY afe_num
                                                                           ORDER BY afe_supplement_num DESC
                                                                      ) AS afe_revision_num,
                                                              MAX (afe_supplement_num)
                                                                 OVER (PARTITION BY afe_num
                                                                           ORDER BY afe_supplement_num DESC
                                                                      ) AS afe_supplement_num
                                                         FROM
                                                              [stage].[t_qbyte_cost_estimate_items]
                                             ) b
                                          ON
                                             (    a.afe_num            = b.afe_num
                                              AND a.afe_revision_num   = b.afe_revision_num
                                              AND a.afe_supplement_num = b.afe_supplement_num
                                             )
                                 ) sup
                              ON
                                 (    org.afe_num    = sup.afe_num
                                  AND org.major_acct = sup.major_acct
                                  AND org.minor_acct = sup.minor_acct
                                 )
                           WHERE
                                 org.minor_acct <> 'CLR'
                             AND (    sup.afe_num IS NULL
                                  AND sup.major_acct IS NULL
                                  AND sup.minor_acct IS NULL
                                 )
                ) sd
LEFT OUTER JOIN
                [stage].[t_qbyte_afes_cost_centres] cc
             ON
                (sd.afe_num = cc.afe_num);