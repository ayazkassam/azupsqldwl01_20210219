CREATE VIEW [stage].[v_fact_source_cost_actuals_qbyte]
AS SELECT
                li_id,
                voucher_id,
                COALESCE (afe.afe_num, facts.afe_key, '-1') AS afe_id,
                COALESCE (afe.afe_num, facts.afe_key, '-1') AS afe_number,
                cc.uwi,
                cc.cost_centre AS cc_number,
                COALESCE (cc.entity_key, facts.entity_key, '-1') AS entity_id,
                accounting_month_key,
                activity_month_key,
                scenario_key,
                account_key,
                organization_key,
                afe.client_id AS afe_client_id,
                vendor_key,
                afe.afe_type_code AS afe_type,
                afe.afe_status_code AS afe_status,
                -1 AS afe_job_type_id,
                'Unspecified Job Type' AS afe_job_type,
                'Unspecified Job SubType' AS afe_job_subtype,
                -1 AS afe_job_status_id,
                'Unspecified Status' AS afe_job_status1,
                'Unspecified Status Details' AS afe_job_status2,
                afe.afe_start_date,
                --COALESCE (afe.extrapolated_budget_year, afe.budget_activity_year) AS budget_year,
				--afe.extrapolated_budget_year, afe.budget_activity_year,
                afe.project_approval_status,
                afe.project_execution_status,
                afe.engineer_assigned,
                afe.afe_udf_7_code AS project_id,
                CASE WHEN facts.gross_net_key=4 THEN 'TRUE_GRS' -- Make Calc Gross as True Gross
					ELSE gn.gross_net_id
				END AS gross_net_indicator,
                facts.gross_net_key,
                /*
                ISNULL (cc.op_nonop, 'OP') AS op_nonop,
                ISNULL (prod_date.date_key, -2) AS on_production_date_key,
                ISNULL (cc_date.date_key, -2) AS cc_create_date_key,
                ISNULL (cc_term_date.date_key, -2) AS cc_termination_date_key,
                ISNULL (cc.budget_group, 'Unknown Budget Group') AS budget_group,
                */
                cad,
                usd,
                ROUND (afe.net_estimate_pct, 2) AS net_working_interest
           FROM
                (SELECT
                        *
                   FROM
                        [data_mart].[t_fact_gl]
                  WHERE
                        is_capital = 1
				  AND gross_net_key <> 3
				  -- True Gross not loaded since Calc Gross becomes True Gross -- see above
                ) facts
LEFT OUTER JOIN
                [data_mart].[t_dim_gross_net] gn
             ON
                (facts.gross_net_key = gn.[gross_net_key])
LEFT OUTER JOIN
                [data_mart].[t_dim_authorization_for_expenditure] afe
             ON
                (facts.afe_key = afe.afe_num)
LEFT OUTER JOIN 
                (SELECT
                        entity_key,
                        cost_centre,
                        uwi,
                        CAST (spud_date AS datetime) AS spud_date,
                        CAST (rig_release_date AS datetime) AS rig_release_date,
                        CAST (on_production_date AS datetime) AS on_production_date, 
                        CASE
                           WHEN ISDATE (create_date) = 0
                              THEN NULL
                           ELSE
                              CAST (create_date AS datetime)
                        END AS cc_create_date,
                        CASE
                           WHEN ISDATE (cc_term_date) = 0
                              THEN NULL
                           ELSE
                              CAST (cc_term_date AS datetime)
                        END AS cc_termination_date,
                        CAST (op_nonop AS NVARCHAR(10)) AS op_nonop,
                        CAST (budget_group AS NVARCHAR(200)) AS budget_group
                   FROM
                        [data_mart].[t_dim_entity]
                  WHERE
                        is_cc_dim = 1
                ) cc
             ON
                (facts.entity_key = cc.entity_key)
LEFT OUTER JOIN 
                [data_mart].[dim_date] prod_date
             ON
                (cc.on_production_date = prod_date.full_Date)
LEFT OUTER JOIN 
                [data_mart].[dim_date] cc_date
             ON
                (cc.cc_create_date = cc_date.full_Date)
LEFT OUTER JOIN 
                [data_mart].[dim_date] cc_term_date
             ON
                (cc.cc_termination_date = cc_term_date.full_Date)
LEFT OUTER JOIN 
                (SELECT
                        *
                   FROM
                        [data_mart].[dim_date]
                  WHERE
                        full_date <= (EOMONTH (DATEADD (MONTH, -1, CURRENT_TIMESTAMP)))
                ) me_dates
             ON
                (facts.accounting_month_key = me_dates.date_key);