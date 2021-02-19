CREATE VIEW [stage].[v_fact_source_valnav_reserves_typecurves_final]
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
FROM
(
SELECT entity_guid entity_key,
	   CASE WHEN  booked_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(booked_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(booked_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(booked_date) AS VARCHAR),2) AS INT)
	  END activity_date_key,
	  accounts account_key,
	  reserve_category_id reserve_category_key,
	  scenario scenario_key,
	  'GRS' gross_net_key,
	  '-1' normalized_time_key,
	  scenario_type,
	  tech_gross_volume as imperial_volume,
	  gross_volume_boe as boe_volume,
	  gross_volume_met as metric_volume,
	  gross_volume_mcfe as mcfe_volume
FROM [stage].v_fact_source_valnav_reserves_typecurves
--
UNION ALL
--
SELECT entity_guid entity_key,
	   CASE WHEN  booked_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(booked_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(booked_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(booked_date) AS VARCHAR),2) AS INT)
	  END activity_date_key,
	  accounts account_key,
	  reserve_category_id reserve_category_key,
	  scenario scenario_key,
	  'WI' gross_net_key,
	  '-1' normalized_time_key,
	  scenario_type,
	  tech_wi_volume as imperial_volume,
	  wi_volume_boe as boe_volume,
	  wi_volume_met as metric_volume,
	  wi_volume_mcfe as mcfe_volume
FROM [stage].v_fact_source_valnav_reserves_typecurves
)rs
GROUP BY entity_key,
	   activity_date_key,
	   account_key,
	   reserve_category_key,
	   scenario_key,
	   gross_net_key,
	   normalized_time_key,
	   scenario_type;