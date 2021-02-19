CREATE VIEW [stage].[v_fact_source_valnav_reserves_GLJReserves_final]
AS SELECT entity_key,
	   activity_date_key,
	   account_key,
	   reserve_category_key,
	   scenario_key,
	   gross_net_key,
	   normalized_time_key,
	   scenario_type,
	   round(sum(imperial_volume), 7) imperial_volume,
	   round(sum(boe_volume), 7) boe_volume,
	   round(sum(metric_volume), 7) metric_volume,
	   round(sum(mcfe_volume), 7) mcfe_volume
FROM ( 
		SELECT entity_guid entity_key,
			CASE WHEN booked_date IS NULL THEN -1 ELSE convert(int,convert(varchar(8),booked_date,112)) END activity_date_key,
			accounts account_key,
			reserve_category_id reserve_category_key,
			scenario scenario_key,
			gn.grs_net gross_net_key,
			'-1' normalized_time_key,
			scenario_type,
			CASE gn.grs_net 
				WHEN 'GRS' THEN gross_volume_imp
				WHEN 'WI' THEN wi_volume_imp
				WHEN 'RI' THEN ri_volume_imp END AS imperial_volume,
			CASE gn.grs_net
				WHEN 'GRS' THEN gross_volume_boe
				WHEN 'WI' THEN wi_volume_boe
				WHEN 'RI' THEN ri_volume_boe END AS boe_volume,
			CASE gn.grs_net
				WHEN 'GRS' THEN gross_volume_met
				WHEN 'WI' THEN wi_volume_met
				WHEN 'RI' THEN ri_volume_met END AS metric_volume,
			CASE gn.grs_net
				WHEN 'GRS' THEN gross_volume_mcfe
				WHEN 'WI' THEN wi_volume_mcfe
				WHEN 'RI' THEN ri_volume_mcfe END  AS mcfe_volume
		FROM [stage].v_fact_source_valnav_reserves_gljReserves  vr
		
		, (	SELECT 'GRS' AS grs_net UNION ALL
			SELECT 'WI' AS grs_net UNION ALL
			SELECT 'RI' AS grs_net
		) gn

		
)rs
GROUP BY entity_key, activity_date_key, account_key, reserve_category_key, scenario_key, gross_net_key, normalized_time_key, scenario_type;