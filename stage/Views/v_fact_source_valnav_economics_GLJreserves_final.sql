CREATE VIEW [stage].[v_fact_source_valnav_economics_GLJreserves_final]
AS SELECT entity_guid entity_key,
		CASE WHEN  actvy_date IS NULL THEN -1 ELSE  convert(int,convert(varchar(8),eomonth(actvy_date),112)) END activity_date_key,
		reserve_category_id,
		scenario,
		od.onstream_date,
		'-1' AS normalized_time_key,
		gross_net,
		va.cube_child_member accounts,
		round(cad_value, 6) as cad,
		round(cad_value/1000, 6) as k_cad
	FROM (	SELECT variable_value AS max_on_prod_days
			FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS'
	) mp
	, (		
			SELECT entity_guid,
				actvy_date,
				reserve_category_id,
				scenario,
				scenario_type,
				'WI' gross_net,
				accounts,
				cad_value
			FROM stage.v_fact_source_valnav_economics_GLJReserves
			UNPIVOT (cad_value FOR accounts IN (btax_net_revenue, btax_npv1, btax_npv4, btax_npv5, btax_npv2, btax_npv3)) as acc
			where section = 1
	) sd
	LEFT OUTER JOIN (
			SELECT DISTINCT entity_id
				, MIN (forecast_start_date) OVER (PARTITION BY entity_id) AS onstream_date
			FROM stage_valnav.t_reserves_ent_reserves_cache
			WHERE forecast_start_date IS NOT NULL
	) od ON sd.entity_guid = od.entity_id
	inner join (
			select variable_value, cube_child_member
			from stage.t_ctrl_valnav_etl_variables
			where variable_name = 'GLJ_RESERVES_ACCOUNTS'
			and comments = 'ECONOMICS'
	) va on sd.accounts = va.variable_value
	WHERE cad_value IS NOT NULL

	union all

	/*Reserves Analysis*/
	SELECT entity_guid entity_key,
		CASE WHEN  actvy_date IS NULL THEN -1 ELSE  convert(int,convert(varchar(8),eomonth(actvy_date),112)) END activity_date_key,
		reserve_category_id,
		scenario,
		od.onstream_date,
		CAST(CASE WHEN vna.account_id IS NULL  OR datediff(MONTH,onstream_date, actvy_date)+1 >= mp.max_on_prod_days THEN '-1'
			ELSE CASE WHEN od.onstream_date IS NULL OR datediff(MONTH,onstream_date, actvy_date)+1 <= 0 THEN '-1'
					ELSE CONCAT(RIGHT(CONCAT('0',datediff(MONTH,onstream_date, actvy_date)+1),2),'.01') END END AS VARCHAR(5)) AS normalized_time_key,
		gross_net,
		accounts,
		round(cad_value, 6) as cad,
		round(cad_value/1000, 6) as k_cad
	FROM (	SELECT variable_value AS max_on_prod_days
			FROM stage.T_CTRL_VALNAV_ETL_VARIABLES
			WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS'
	) mp
	, (		
			SELECT entity_guid,
				actvy_date,
				reserve_category_id,
				scenario,
				scenario_type,
				'WI' gross_net,
				CASE accounts
					when 'btax_net_revenue' then 'NPV0'
					when 'btax_npv1' then 'NPV1'
					when 'btax_npv4' then 'NPV4'
					when 'btax_npv5' then 'NPV5'
					when 'btax_npv2' then 'NPV2'
					when 'btax_npv3'  then 'NPV3'
					WHEN 'cap_wi_abandonment_salvage' then 'Abandonment_Salvage_Costs'
					else accounts END AS accounts,
				cad_value
			FROM stage.v_fact_source_valnav_economics_GLJReserves
			UNPIVOT (cad_value FOR accounts IN (btax_net_revenue, btax_npv1, btax_npv4, btax_npv5, btax_npv2, btax_npv3
											, Roy_Adj_Total, Net_Op_Income, OpVariable, OpFixed, BTax_Payout_Months, BTax_ROR
											, BTax_Profit_Ratio, cap_wi_abandonment_salvage)) as acc
			where section = 2
	) sd
	LEFT OUTER JOIN (
			SELECT DISTINCT entity_id
				, MIN (forecast_start_date) OVER (PARTITION BY entity_id) AS onstream_date
			FROM stage_valnav.t_reserves_ent_reserves_cache
			WHERE forecast_start_date IS NOT NULL
	) od ON sd.entity_guid = od.entity_id
	LEFT OUTER JOIN [stage].v_valnav_netback_accounts vna ON sd.accounts = vna.account_id
	WHERE cad_value IS NOT NULL;