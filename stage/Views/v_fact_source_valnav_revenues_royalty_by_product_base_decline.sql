CREATE VIEW [stage].[v_fact_source_valnav_revenues_royalty_by_product_base_decline]
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
	from [stage].v_fact_source_valnav_royalty_by_product_calculations_base_decline,
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
-- royalties
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
			  --
			 WHEN 'unadjusted_crown_royalty'    THEN 'Crown '				+ accounts + ' Unadjusted Royalty'
			 WHEN 'unadjusted_freehold_royalty' THEN 'Freehold '			+ accounts + ' Unadjusted Royalty'
			 --
			 WHEN 'crown_royalty_deductions'    THEN 'Crown '				+ accounts + ' Royalty Deductions'
			 WHEN 'freehold_royalty_deductions' THEN 'Freehold '			+ accounts + ' Royalty Deductions'

			 WHEN 'unadjusted_gor_royalty'		THEN 'GOR '					+ accounts + ' Unadjusted Royalty'
			 WHEN 'gor_royalty_deductions'		THEN 'GOR '					+ accounts + ' Royalty Deductions'
		END accounts,
		cad
 from [stage].v_fact_source_valnav_royalty_by_product_calculations_base_decline
UNPIVOT (cad FOR royalty_type IN (crown_royalty, gor_royalty, freehold_royalty, indian_royalty, mineral_tax_royalty, sask_cap_surcharge_royalty
								 ,unadjusted_crown_royalty,unadjusted_freehold_royalty,crown_royalty_deductions,freehold_royalty_deductions
								 ,unadjusted_gor_royalty, gor_royalty_deductions
								 )
		) as roy
) roy_src
WHERE cad <> 0;