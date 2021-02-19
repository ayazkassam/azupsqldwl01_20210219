CREATE VIEW [stage_export].[v_ewf_prod_data]
AS SELECT SUBSTRING (entity_key, 1, 14) wellbore,
	   cast(cast(activity_date_key as varchar) as datetime) prod_date,
	   ROUND(sum(gas_metric_volume), 7) gas_e3m3_volume,
	   ROUND(sum(total_liquid_metric_volume), 7) liquids_m3_volume,
	   row_number() OVER(ORDER BY activity_date_key) row_id
FROM
(SELECT *
 FROM [data_mart].t_fact_fdc
WHERE --data_type='PRODUCTION'
scenario_key='Production_PV'
AND activity_date_key NOT IN (-1,-2)
AND gross_net_key=1
AND entity_key IS NOT NULL
--AND (cast(cast(activity_date_key as varchar) as datetime) BETWEEN (CURRENT_TIMESTAMP-92) AND CURRENT_TIMESTAMP)
AND (activity_date_key between cast(replace(cast(CURRENT_TIMESTAMP-92 as date),'-','') as int) and cast(replace(cast(CURRENT_TIMESTAMP as date),'-','') as int))
) fdc
GROUP BY entity_key,SUBSTRING (entity_key, 1, 14), activity_date_key;