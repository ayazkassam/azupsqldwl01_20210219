CREATE VIEW [stage].[v_fact_source_valnav_financial_typecurves]
AS SELECT entity_key,
        activity_date_key,
		account_key,
		reserve_category_key,
		scenario_key,
		gross_net_key,
		normalized_time_key,
		scenario_type,
	    sum(cad) cad,
		sum(cad)/1000 k_cad
FROM
(
 SELECT entity_key,
		activity_date_key,
		accounts account_key,
		reserve_category_id reserve_category_key,
		scenario scenario_key,
		normalized_time_key,
		'GRS' gross_net_key,
		scenario_type,
		isnull(success_gross_value,0) + isnull(failure_gross_value,0) cad		
 FROM [stage].v_fact_source_valnav_capital_typecurves
 --
 UNION ALL
 --
 SELECT entity_key,
		activity_date_key,
		accounts account_key,
		reserve_category_id reserve_category_key,
		scenario scenario_key,
		normalized_time_key,
		'WI' gross_net_key,
		scenario_type,
		isnull(success_interest_value,0) + isnull(failure_interest_value,0) cad		
 FROM [stage].v_fact_source_valnav_capital_typecurves
 ) sc
 GROUP BY entity_key,
        activity_date_key,
		account_key,
		reserve_category_key,
		scenario_key,
		normalized_time_key,
		gross_net_key,
		scenario_type
--
UNION ALL
--
-- Economics Data
SELECT entity_key,
	   activity_date_key,
	   accounts,
	   reserve_category_id,
	   scenario,
	   gross_net,
	   normalized_time_key,
	   'Type Curve' scenario_type,
	   cad,
	   k_cad
FROM [Stage].[v_fact_source_valnav_economics_typecurves_final]
--
UNION ALL
--
-- Custom Royalties
SELECT entity_key,
	   activity_date_key,
	   accounts,
	   reserve_category_id,
	   scenario,
	   grs_net,
	   normalized_time_key,
	   scenario_type,
	   cad,
	   k_cad
FROM [Stage].[v_fact_source_valnav_royalties_typecurves]
UNION ALL
-- Royalty by Product
--
SELECT entity_key,
	   activity_date_key,
	   account_key,
	   reserve_category_key,
	   scenario_key,
	   gross_net_key,
	   normalized_time_key,
	   scenario_type,
	   cad,
	   k_cad
FROM [stage].[v_fact_source_valnav_revenues_royalty_by_product_typecurves];