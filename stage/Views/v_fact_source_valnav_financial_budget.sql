CREATE VIEW [stage].[v_fact_source_valnav_financial_budget]
AS SELECT entity_key
	, activity_date_key
	, account_key
	, reserve_category_key
	, scenario_key
	, gross_net_key
	, normalized_time_key
	, scenario_type
	, sum(cad) cad
	, sum(cad)/1000 k_cad
	, cast(null as float) as WI
FROM (
	SELECT entity_key
		, activity_date_key
		, accounts account_key
		, reserve_category_id reserve_category_key
		, scenario scenario_key
		, normalized_time_key
		, 'GRS' gross_net_key
		, scenario_type
		, isnull(success_gross_value,0) + isnull(failure_gross_value,0) cad		
	FROM [stage].v_fact_source_valnav_capital_budget

	UNION ALL

	SELECT entity_key
		, activity_date_key
		, accounts account_key
		, reserve_category_id reserve_category_key
		, scenario scenario_key
		, normalized_time_key
		, 'WI' gross_net_key
		, scenario_type
		, isnull(success_interest_value,0) + isnull(failure_interest_value,0) cad		
	FROM [stage].v_fact_source_valnav_capital_budget
) sc
GROUP BY entity_key, activity_date_key, account_key, reserve_category_key, scenario_key, normalized_time_key, gross_net_key, scenario_type

UNION ALL

/*-- Economics Data*/
SELECT entity_key
	, activity_date_key
	, accounts
	, reserve_category_id
	, scenario
	, gross_net
	, normalized_time_key
	, 'Budget' scenario_type
	, cad
	, k_cad
	, null as WI
FROM [stage].[v_fact_source_valnav_economics_budget_final]

UNION ALL

/*--Well Counts*/
SELECT entity_key
	, activity_date_key
	, accounts
	, reserve_category_id
	, scenario
	, grs_net
	, '-1' normalized_time_key
	, scenario_type
	, cad
	, k_cad
	, null as WI
FROM [stage].[v_fact_source_valnav_well_counts_budget]

UNION ALL

/*-- Custom Royalties*/
SELECT entity_key
	, activity_date_key
	, accounts
	, reserve_category_id
	, scenario
	, grs_net
	, normalized_time_key
	, scenario_type
	, cad
	, k_cad
	, null as WI
FROM [stage].[v_fact_source_valnav_royalties_budget]

UNION ALL

/*-- Chance of Success*/
SELECT entity_key
	, activity_date_key
	, accounts
	, reserve_category_id
	, scenario
	, grs_net
	, normalized_time_key
	, scenario_type
	, chance_of_success cad
	, chance_of_success k_cad
	, null as WI
FROM [stage].v_fact_source_valnav_chance_of_success_budget

UNION ALL

/*-- Royalty by Product*/
SELECT entity_key
	, activity_date_key
	, account_key
	, reserve_category_key
	, scenario_key
	, gross_net_key
	, normalized_time_key
	, scenario_type
	, cad
	, k_cad
	, null as WI
FROM [stage].[v_fact_source_valnav_revenues_royalty_by_product_budget]

union all

/*lateral length*/
SELECT entity_key
	, activity_date_key
	, account_key
	, reserve_category_key
	, scenario_key
	, gross_net_key
	, '-1' normalized_time_key
	, scenario_type
	, cad
	, cad k_cad
	, null as WI
FROM [stage].v_fact_source_valnav_lateral_length_budget

union all

/*working interest*/
SELECT entity_key
	, activity_date_key
	, account_key
	, reserve_category_key
	, scenario_key
	, gross_net_key
	, '-1' normalized_time_key
	, scenario_type
	, null cad
	, null k_cad
	, working_interest as WI
FROM [stage].v_fact_source_valnav_qbyte_working_interest;