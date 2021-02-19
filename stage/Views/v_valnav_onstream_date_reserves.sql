CREATE VIEW [stage].[v_valnav_onstream_date_reserves]
AS SELECT object_id,
        unique_id,
		CAST ( first_step_date as datetime) first_step_date
 FROM
 (
 SELECT DISTINCT 
		 e.object_id,
		 e.unique_id,
		  MIN(step_date) first_step_date
  FROM stage_valnav.t_reserves_RESULTS_BTAX_PRODUCT rbp
  LEFT OUTER JOIN 
			stage_valnav.t_reserves_RESULTS_LOOKUP rl
	 ON rbp.result_id = rl.result_id
  LEFT OUTER JOIN
			stage_valnav.t_reserves_ENTITY e
	 ON rl.entity_id = e.object_id
  WHERE /*product_id in (0,1,2) -- light and medium oil, heave oil and gas*/
		product_id in ('GAS','HVY_OIL','LM_OIL')	--change to use text values
  AND isnull(GROSS_VOLUME,0) <> 0
  GROUP BY e.object_id,
		 e.unique_id
) s;