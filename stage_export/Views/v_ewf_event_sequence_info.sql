CREATE VIEW [stage_export].[v_ewf_event_sequence_info]
AS SELECT CAST (SUBSTRING (da.entity_key, 1, 14) AS VARCHAR (14)) wellbore,
	   CAST (da.entity_key AS VARCHAR (50)) uwi,
       CAST (wd.crstatus_desc AS VARCHAR (60)) AS modes,
	   iw2.current_status_date current_status_date,
       CAST (wd.pool_desc AS VARCHAR (60)) AS pool,
       CAST (wd.zone_desc AS VARCHAR (60)) AS production_zone,
	   pd.on_production_date,
	   CAST (da.cost_centre AS VARCHAR (100)) AS cost_center,
       CAST (da.working_interest_pct AS FLOAT) AS working_interest,
       CASE
             WHEN wd.unit_desc IS NULL THEN 'Unknown'
             ELSE CAST (wd.unit_desc AS VARCHAR (60))
       END unit,
       CAST (wd.LOCATION AS VARCHAR (50)) formatted_uwi,
       CAST (wd.well_id AS VARCHAR (50)) sorted_uwi,
       CAST (wp.long_name AS VARCHAR (50)) well_type,
       CAST ('Data Not Yet Available' AS VARCHAR (50)) well_event_type,
	   row_number() OVER(ORDER BY da.entity_key) row_id
FROM
		  (SELECT * --DISTINCT entity_key uwi
		  FROM [data_mart].t_dim_entity
		  WHERE is_uwi=1
		  AND entity_key > '0'
		  AND SUBSTRING(entity_key,1,1) <> 'W') da
INNER JOIN [stage].t_ihs_well_description wd
   ON da.entity_key = wd.uwi
INNER JOIN [stage].t_ihs_well iw2
   ON da.entity_key = iw2.uwi
LEFT OUTER JOIN [stage].t_ihs_pden pd
   ON da.uwi = pd.pden_id
LEFT OUTER JOIN [stage].t_ihs_r_well_profile_type wp
   ON iw2.profile_type = wp.well_profile_type;