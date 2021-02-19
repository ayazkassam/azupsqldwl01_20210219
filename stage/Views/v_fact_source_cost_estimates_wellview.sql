CREATE VIEW [stage].[v_fact_source_cost_estimates_wellview]
AS SELECT
                COALESCE (afe.afe_key, '-1') AS afe_id,
                est.afe_num AS afe_number,
                est.uwi,
                COALESCE (cc.entity_key, '-1') AS entity_id,
                est.cc_num AS cc_number,
                CASE
                   WHEN est.afe_date IS NULL
                      THEN -1
                   ELSE
                      CAST (  CAST (YEAR (est.afe_date) AS VARCHAR)
                            + RIGHT (REPLICATE ('00', 2) + CAST (MONTH (est.afe_date) AS VARCHAR), 2)
                            + RIGHT (REPLICATE ('00', 2) + CAST (DAY (est.afe_date) AS VARCHAR), 2) AS INT
                           )
                END AS acct_per_id,
                est.afe_date AS acct_per_date,
                est.acct_mnth,
                est.acct_yr,
                CASE
                   WHEN est.afe_date IS NULL
                      THEN -1
                   ELSE
                      CAST (  CAST (YEAR (est.afe_date) AS VARCHAR)
                            + RIGHT (REPLICATE ('00', 2) + CAST (MONTH (est.afe_date) AS VARCHAR), 2)
                            + RIGHT (REPLICATE ('00', 2) + CAST (DAY (est.afe_date) AS VARCHAR), 2) AS INT
                           )
                END AS actvy_per_id,
                est.afe_date AS actvy_per_date,
                est.prod_mnth AS actvy_mnth,
                est.prod_yr AS actvy_yr,
                'Wellview Field Estimate Detail' AS scenario,
                est.gl_net_account,
                est.capital_project_number,
                est.org_id,
                est.afe_client_id,
                est.vendor_id,
                est.base_incr,
                est.play,
                est.tax_stream,
                est.acquisitions,
                est.dispositions,
                est.tax_code,
                est.wip_expenses,
                est.capital_or_dry_hole_expense,
                est.afe_type,
                est.afe_status,
                -1 AS afe_job_type_id,
                est.afe_job_type,
                est.afe_job_subtype,
                -1 AS afe_job_status_id,
                est.afe_job_status1,
                est.afe_job_status2,
                est.afe_start_date,
                est.budget_year,
                est.project_approval_status,
                est.project_execution_status,
                est.engineer_assigned,
                est.grs_net_indicator AS grs_net,
                /*
                CASE
                   WHEN     COALESCE (est.project_id, '-1') = '-1'
                        AND d.afe_key IS NOT NULL
                      THEN
                         COALESCE (d.area, '-1')
                   ELSE
                      est.project_id
                END AS project_id,
                */
                est.project_id,
                '-1' AS budget_wedge_id,
                est.us_dollar_amt,
                est.can_dollar_amt,
                ROUND (est.net_working_interest, 2) AS net_working_interest
           FROM
                [stage].[t_afe_cost_estimates_wellview] est
LEFT OUTER JOIN
                [data_mart].[t_dim_authorization_for_expenditure] afe
             ON
                (est.afe_num = afe.afe_num)
LEFT OUTER JOIN
                [data_mart].[t_dim_entity] cc
             ON
                (    est.cc_num = cc.cost_centre
                 AND est.cc_num = cc.entity_key
                );