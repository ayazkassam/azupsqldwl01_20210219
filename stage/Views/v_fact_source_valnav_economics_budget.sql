CREATE VIEW [stage].[v_fact_source_valnav_economics_budget]
AS SELECT    e.object_id AS entity_guid,
          rb.step_date,
          --rb.wi_revenue,
          --rbp.ri_revenue,
          rb.roy_adj_total,
          rb.net_op_income,
          CAST (NULL AS float) AS npv2,
          CAST (NULL AS float) AS npv3,
          CAST (NULL AS float) AS npv4,
          CAST (NULL AS float)                                     /* rsc.op_wi_wi_variable */
              AS op_wi_wi_variable,
          CAST (NULL AS float)                                        /* rsc.op_wi_wi_fixed */
              AS op_wi_wi_fixed,
          NULL AS btax_payout_months,
          NULL AS btax_ror,
          NULL AS btax_profit_ratio,
		  rsc.cap_wi_abandonment_salvage,
          rl.entity_id,
          e.formatted_id,
          RTRIM(LTRIM (e.unique_id)) AS uwi,
          rl.reserve_category_id,
          'Budget' AS scenario_type,
          vev2.cube_child_member AS scenario

 FROM		  
			(SELECT year(cast(variable_value as datetime)) first_year
				FROM [stage].t_ctrl_valnav_etl_variables
				WHERE variable_name='VALNAV_ACTIVITY_DATE_START'
			)  trs,
			(SELECT  year(cast(variable_value as datetime)) last_year
				FROM [stage].t_ctrl_valnav_etl_variables
				WHERE variable_name='VALNAV_ACTIVITY_DATE_END'
			) tre,
			[stage_valnav].t_budget_results_btax rb
			LEFT OUTER JOIN  [stage_valnav].t_budget_results_lookup rl
			ON rb.result_id = rl.result_id
			LEFT OUTER JOIN
			     (  SELECT result_id, step_date, SUM (ri_revenue) AS ri_revenue
					FROM  [stage_valnav].t_budget_results_btax_product
					GROUP BY result_id, step_date
					 HAVING SUM (ri_revenue) <> 0) rbp
            ON rb.result_id = rbp.result_id
			AND rb.step_date = rbp.step_date
			LEFT OUTER JOIN
				 (  SELECT result_id,
                    step_date,
                    --SUM (op_wi_wi_variable) AS op_wi_wi_variable,
                    --SUM (op_wi_wi_fixed) AS op_wi_wi_fixed,
					sum(cap_wi_abandonment+cap_wi_salvage) as cap_wi_abandonment_salvage
					--sum(cap_wi_salvage) as cap_wi_salvage
					FROM [stage_valnav].t_budget_results_cost
					GROUP BY result_id, step_date
					HAVING SUM (op_wi_wi_variable) + SUM (op_wi_wi_fixed)  + sum(cap_wi_abandonment) +sum(cap_wi_salvage) <> 0  ) rsc
		    ON rb.result_id = rsc.result_id
			AND rb.step_date = rsc.step_date
			LEFT OUTER JOIN [stage_valnav].t_budget_entity e
			ON rl.entity_id = e.object_id
			INNER JOIN
	        (SELECT fsp.plan_id, fs.*
             FROM [stage_valnav].t_budget_fisc_scenario fs
                  LEFT OUTER JOIN [stage_valnav].t_budget_fisc_scenario_params fsp
                     ON (fs.object_id = fsp.parent_id)
             WHERE fs.name = '<Current Options>' ) sn
            ON rl.scenario_id = sn.object_id

			inner join (
				select cfd.parent_id
					, ltrim(rtrim(cfd.string_value)) as variable_value
					, cfd.cube_child_member
					, cfd.sign_flip_flag
				from (
						select c.*
							, v.cube_child_member, v.sign_flip_flag
							, row_number() over (	partition by parent_id 
													order by case ltrim(rtrim(c.name)) 
															when 'Budget Year' then 3 
															when 'DISTRICT' then 2 
															when 'CAPITAL GROUP' then 1 end) rnk
						FROM [stage].t_stg_valnav_budget_ent_custom_field_def c
						join [stage].t_ctrl_valnav_etl_variables v on ltrim(rtrim(c.string_value)) = v.variable_value
						WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT', 'CAPITAL GROUP')
						and v.variable_name = 'BUDGET_BUDGET_YEAR'
						AND ISNULL (v.sign_flip_flag, 'N') <> 'Y'
				) cfd 
				where rnk = 1	
			) vev2 on rl.entity_id = vev2.parent_id


		/*	INNER JOIN
				
				select * from (SELECT *
				 FROM [stage].dbo.t_stg_valnav_budget_ent_custom_field_def
				 WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT','CAPITAL GROUP')) cfd
			--ON rl.entity_id = cfd.parent_id

			INNER JOIN 
				(SELECT variable_value, cube_child_member, sign_flip_flag
				FROM T_CTRL_VALNAV_ETL_VARIABLES
				WHERE variable_name = 'BUDGET_BUDGET_YEAR'
				AND ISNULL (sign_flip_flag, 'N') <> 'Y') vev2
			ON  ltrim(rtrim(cfd.string_value)) = vev2.variable_value--1475
		*/

			INNER JOIN 
				(SELECT variable_value
				FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
				WHERE variable_name = 'RESERVE_CATEGORY_ID') vev
			ON rl.reserve_category_id = vev.variable_value
			
			



WHERE rl.plan_definition_id = 0
AND   year(rb.step_date) BETWEEN trs.first_year AND tre.last_year
--
UNION ALL
--
-- Results summary metrics
SELECT	DISTINCT
          e.object_id AS entity_guid,
          --rsum.forecast_start,
          --rsum.production_start,
          CASE
             WHEN rr.reserve_realized_date IS NULL
             THEN
                CASE WHEN rsum.forecast_start > rsum.production_start THEN rsum.forecast_start  ELSE  rsum.production_start END
             ELSE
                rr.reserve_realized_date
          END
             AS actvy_date,
          --NULL AS wi_revenue,
          --NULL AS ri_revenue,
          NULL AS roy_adj_total,
          NULL AS net_op_income,
          CAST (ROUND (btax_npv2, 12) AS float) AS npv2,
          CAST (ROUND (btax_npv3, 12) AS float) AS npv3,
          CAST (ROUND (btax_npv4, 12) AS float) AS npv4,
          NULL AS op_wi_wi_variable,
          NULL AS op_wi_wi_fixed,
          ROUND ( (rsum.btax_payout * 12), 1) AS btax_payout_months,
          ROUND ( (rsum.btax_ror * 100), 1) AS btax_ror,
          rsum.btax_profit_ratio,
		  null cap_wi_abandonment_salvage,
          rl.entity_id,
          e.formatted_id,
          RTRIM(LTRIM (e.unique_id)) AS uwi,
          rl.reserve_category_id,
          'Budget' AS scenario_type,
          vev2.cube_child_member AS scenario
FROM		[stage_valnav].t_budget_results_summary rsum
			LEFT OUTER JOIN  [stage_valnav].t_budget_results_lookup rl
			ON rsum.result_id = rl.result_id
			LEFT OUTER JOIN [stage_valnav].t_budget_entity e
			ON rl.entity_id = e.object_id
				INNER JOIN 
				(SELECT variable_value
				FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
				WHERE variable_name = 'RESERVE_CATEGORY_ID') vev
			ON rl.reserve_category_id = vev.variable_value
			INNER JOIN
	        (SELECT fsp.plan_id, fs.*
             FROM [stage_valnav].t_budget_fisc_scenario fs
                  LEFT OUTER JOIN [stage_valnav].t_budget_fisc_scenario_params fsp
                     ON (fs.object_id = fsp.parent_id)
             WHERE fs.name = '<Current Options>' ) sn
            ON rl.scenario_id = sn.object_id

			inner join (
				select cfd.parent_id
					, ltrim(rtrim(cfd.string_value)) as variable_value
					, cfd.cube_child_member
					, cfd.sign_flip_flag
				from (
						select c.*
							, v.cube_child_member, v.sign_flip_flag
							, row_number() over (	partition by parent_id 
													order by case ltrim(rtrim(c.name)) 
															when 'Budget Year' then 3 
															when 'DISTRICT' then 2 
															when 'CAPITAL GROUP' then 1 end) rnk
						FROM [stage].t_stg_valnav_budget_ent_custom_field_def c
						join [stage].t_ctrl_valnav_etl_variables v on ltrim(rtrim(c.string_value)) = v.variable_value
						WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT', 'CAPITAL GROUP')
						and v.variable_name = 'BUDGET_BUDGET_YEAR'
						AND ISNULL (v.sign_flip_flag, 'N') <> 'Y'
				) cfd 
				where rnk = 1	
			) vev2 on rl.entity_id = vev2.parent_id


			/*INNER JOIN
				select * from (SELECT *
				 FROM [stage].dbo.t_stg_valnav_budget_ent_custom_field_def
				 WHERE ltrim(rtrim(name)) in ('Budget Year', 'DISTRICT', 'CAPITAL GROUP')) cfd
			--ON rl.entity_id = cfd.parent_id
			INNER JOIN 
				(SELECT variable_value, cube_child_member, sign_flip_flag
				FROM T_CTRL_VALNAV_ETL_VARIABLES
				WHERE variable_name = 'BUDGET_BUDGET_YEAR'
				AND ISNULL (sign_flip_flag, 'N') <> 'Y') vev2
			ON  ltrim(rtrim(cfd.string_value)) = vev2.variable_value*/


			LEFT OUTER JOIN 
				(SELECT parent_id, date_value AS reserve_realized_date
				FROM [stage].t_stg_valnav_budget_ent_custom_field_def
				WHERE UPPER (RTRIM(LTRIM (NAME))) = 'RESERVES REALIZED DATE') rr
			ON e.object_id = rr.parent_id
WHERE (CASE WHEN rsum.forecast_start > rsum.production_start THEN rsum.forecast_start  ELSE  rsum.production_start END) IS NOT NULL
AND rl.plan_definition_id = 0;