CREATE VIEW [stage].[v_fact_source_valnav_revenues_royalty_by_product_typecurves]
AS SELECT entity_id entity_key,
        activity_date_key,
		accounts account_key,
		reserve_category_id reserve_category_key,
		scenario scenario_key,
		gross_net gross_net_key,
		normalized_time_key,
		cad,
		cad / 1000 k_cad,
		scenario_type
FROM
(
	SELECT entity_id ,
		activity_date_key,
		--CASE WHEN product_id = 2 THEN 'Sales' + accounts + ' Revenue' 
		--	 ELSE accounts + ' Revenue' 
		--END accounts,
		accounts + ' Revenue' accounts,
		reserve_category_id,
		scenario,
		gn.gross_net,
		CASE gn.gross_net
			WHEN 'GRS' THEN gross_revenue
			WHEN 'WI' THEN wi_revenue
			WHEN 'RI' THEN ri_revenue
			--WHEN 'FI' THEN fi_revenue
		END cad,
        scenario_type,
		normalized_time_key
	from Stage.v_fact_source_valnav_royalty_by_product_calculations_typecurves,
      (SELECT 'GRS' gross_net 
	  UNION ALL 
	  SELECT 'WI'
	  UNION ALL 
	  SELECT 'RI' 
	  --UNION ALL 
	  --SELECT 'FI'
	  ) gn
) rev_src
  WHERE cad <> 0 
--
UNION ALL
--
-- royalties from Typecurves
 SELECT entity_id entity_key,
        activity_date_key,
		accounts account_key,
		reserve_category_id reserve_category_key,
		scenario scenario_key,
		gross_net gross_net_key,
		normalized_time_key,
		cad,
		cad / 1000 k_cad,
		scenario_type
FROM
(
 SELECT entity_id,
		activity_date_key,
		scenario_type,
		scenario,
		reserve_category_id,
		normalized_time_key,
		'WI' gross_net,
		-- accounts,
		CASE royalty_type
		     WHEN 'crown_royalty' THEN 'Crown ' + accounts + ' Royalty'
			 WHEN 'gor_royalty' THEN 'GOR ' + accounts + ' Royalty'
			 WHEN 'freehold_royalty' THEN 'Freehold ' + accounts + ' Royalty'
			 WHEN 'indian_royalty' THEN 'Indian ' + accounts + ' Royalty'
			 WHEN 'mineral_tax_royalty' THEN 'Mineral Tax ' + accounts + ' Royalty'
			 WHEN 'sask_cap_surcharge_royalty' THEN 'Sask Cap Surcharge ' + accounts + ' Royalty'
		END accounts,
		cad
 from v_fact_source_valnav_royalty_by_product_calculations_typecurves
UNPIVOT (cad FOR royalty_type IN (crown_royalty, gor_royalty, freehold_royalty, indian_royalty, mineral_tax_royalty, sask_cap_surcharge_royalty)) as roy
) roy_src
WHERE cad <> 0;