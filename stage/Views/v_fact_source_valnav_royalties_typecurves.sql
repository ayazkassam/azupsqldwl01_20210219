CREATE VIEW [stage].[v_fact_source_valnav_royalties_typecurves]
AS SELECT e.object_id AS entity_key,
          CASE WHEN  rr.step_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(rr.step_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(rr.step_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(rr.step_date) AS VARCHAR),2) AS INT)
		  END activity_date_key,
          rl.reserve_category_id,
		  vev2.cube_child_member AS scenario,
		  'WI' as grs_net,
		  'Custom Royalty' as accounts,
		  CAST ('Type Curve' AS VARCHAR (10)) AS scenario_type,
		  CAST(CASE WHEN od.onstream_date IS NULL  OR datediff(MONTH,od.onstream_date, rr.step_date)+1 >= mp.max_on_prod_days THEN '-1'
	                  
	        ELSE 
				CASE WHEN od.onstream_date IS NULL OR datediff(MONTH,od.onstream_date, rr.step_date)+1 < 0 THEN '-1'
		        ELSE  CONCAT(
								   RIGHT(CONCAT('0',datediff(MONTH,od.onstream_date, rr.step_date)+1),2),
								   '.01'
								   )
	         END
	      END AS VARCHAR(5)) AS normalized_time_key,
          rr.royalty as cad,
          rr.royalty/1000 as k_cad
FROM
    	(SELECT year(cast(variable_value as datetime)) first_year
				FROM [stage].t_ctrl_valnav_etl_variables
				WHERE variable_name='VALNAV_ACTIVITY_DATE_START'
		)  trs,
			(SELECT  year(cast(variable_value as datetime)) last_year
				FROM [stage].t_ctrl_valnav_etl_variables
				WHERE variable_name='VALNAV_ACTIVITY_DATE_END'
		) tre,
		(SELECT variable_value AS max_on_prod_days
                       FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
                      WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS'
			 ) mp,
		(SELECT *
             FROM stage_valnav.t_typecurves_RESULTS_REGIME
            WHERE royalty <> 0) rr
	LEFT OUTER JOIN  stage_valnav.t_typecurves_RESULTS_LOOKUP rl
	ON  rr.result_id = rl.result_id
	LEFT OUTER JOIN	stage_valnav.t_typecurves_ENTITY e
	ON rl.entity_id = e.object_id
	INNER JOIN
	        (SELECT fsp.plan_id, fs.*
             FROM stage_valnav.t_typecurves_FISC_SCENARIO fs
                  LEFT OUTER JOIN stage_valnav.t_typecurves_FISC_SCENARIO_PARAMS fsp
                     ON (fs.object_id = fsp.parent_id)
             WHERE fs.name = '<Current Options>' ) sn
    ON rl.scenario_id = sn.object_id
	INNER JOIN 
			(SELECT variable_value
             FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
            WHERE variable_name = 'TYPE_CURVES_RESERVE_CATEGORY_ID') vev
	ON rl.reserve_category_id = vev.variable_value
	INNER JOIN
			(SELECT *
			FROM [stage].t_stg_valnav_typecurves_ent_custom_field_def
			WHERE name='Budget Year') cfd
	ON rl.entity_id = cfd.parent_id
	INNER JOIN 
			(SELECT variable_value, cube_child_member, sign_flip_flag
             FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
            WHERE variable_name = 'TYPE_CURVES_BUDGET_YEAR'
			AND ISNULL (sign_flip_flag, 'N') <> 'Y') vev2
	 ON  ltrim(rtrim(cfd.string_value)) = vev2.variable_value
	 LEFT OUTER JOIN
	      (SELECT object_id, first_step_date onstream_date
		  FROM [stage].t_valnav_onstream_date_typecurves) od
	 ON rl.entity_id = od.object_id
     --
WHERE rl.plan_definition_id = 0
 AND   year(rr.step_date) BETWEEN trs.first_year AND tre.last_year;