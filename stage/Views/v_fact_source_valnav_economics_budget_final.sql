CREATE VIEW [stage].[v_fact_source_valnav_economics_budget_final]
AS SELECT entity_guid as entity_key,
       CASE WHEN  step_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(step_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(step_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(step_date) AS VARCHAR),2) AS INT)
		END activity_date_key,
	   reserve_category_id,
	   scenario,
	   CAST(CASE WHEN vna.account_id IS NULL  OR datediff(MONTH,onstream_date, step_date)+1 >= mp.max_on_prod_days THEN '-1'
	                  
	        ELSE 
				CASE WHEN od.onstream_date IS NULL OR datediff(MONTH,onstream_date, step_date)+1 <= 0 THEN '-1'
		        ELSE  CONCAT(
								   RIGHT(CONCAT('0',datediff(MONTH,onstream_date, step_date)+1),2),
								   '.01'
								   )
	         END
	   END AS VARCHAR(5)) AS normalized_time_key,
	   --datediff(MONTH,onstream_date, step_date)+1 diff,
	   --onstream_date,
	   gross_net,
	   accounts,
	   round(cad_value, 6) as cad,
	   round(cad_value /1000, 6) as k_cad

	
FROM
(SELECT variable_value AS max_on_prod_days
                       FROM [stage].[t_ctrl_valnav_etl_variables]
                      WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS'
					  ) mp,
(
SELECT entity_guid,
	   step_date,
	   reserve_category_id,
	   scenario,
	   scenario_type,
	   'WI' gross_net,
	   CASE accounts
	        --WHEN 'wi_revenue'			THEN 'WI_Revenue'
			--WHEN 'ri_revenue'			THEN 'RI_Revenue'
			WHEN 'roy_adj_total'		THEN 'Roy_Adj_Total'
			WHEN 'net_op_income'		THEN 'Net_Op_Income'
			WHEN 'npv2'					THEN 'NPV2'
			WHEN 'npv4'					THEN 'NPV4'
			WHEN 'op_wi_wi_variable'	THEN 'OpVariable'
			WHEN 'op_wi_wi_fixed'		THEN 'OpFixed'
			WHEN 'btax_payout_months'	THEN 'BTax_Payout_Months'
			WHEN 'btax_ror'				THEN 'BTax_ROR'
			WHEN 'btax_profit_ratio'	THEN 'BTax_Profit_Ratio'
			WHEN 'cap_wi_abandonment_salvage' then 'Abandonment_Salvage_Costs'
		END accounts,
	   cad_value
FROM stage.v_fact_source_valnav_economics_budget
UNPIVOT (cad_value FOR accounts IN (roy_adj_total,net_op_income, npv2, npv4, op_wi_wi_variable, op_wi_wi_fixed, btax_payout_months, btax_ror, btax_profit_ratio, cap_wi_abandonment_salvage )) as acc
) sd
LEFT OUTER JOIN 
   (SELECT object_id, first_step_date onstream_date
		  FROM [stage].t_valnav_onstream_date_budget) od
	 ON sd.entity_guid = od.object_id
LEFT OUTER JOIN
[stage].v_valnav_netback_accounts vna
ON sd.accounts = vna.account_id
WHERE cad_value IS NOT NULL;