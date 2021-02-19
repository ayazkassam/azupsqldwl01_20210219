CREATE VIEW [stage].[v_fact_source_valnav_financial_xls]
AS SELECT entity_key,
			  CASE WHEN  actvy_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(actvy_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(actvy_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(actvy_date) AS VARCHAR),2) AS INT)
			  END activity_date_key,
			  accounts account_key,
			  reserve_category_id reserve_category_key,
			  scenario scenario_key,
			  gross_net gross_net_key,
			  normalized_time_key,
			  cad,
			  k_cad,
			  'RESERVES' scenario_type
	   FROM
(
SELECT   ISNULL (ISNULL (e.entity_key, ec.entity_key), LTRIM(RTRIM (rx.uwi)))
             entity_key,
          -- nvl for rx.uwi necessary as there could be cases where data does not line up.
          -- For example a uwi...  'Other Revenue and Expenses'
          --ISNULL (ISNULL (e.uwi, ec.uwi),  RTRIM(LTRIM (rx.uwi))) uwi,
          CAST (rbd.reserve_book_date as datetime) actvy_date,
          ax.cube_child_member accounts,
          rs.cube_child_member reserve_category_id,
          cs.scenario,
          CASE
             WHEN UPPER (rx.accounts) LIKE '%GROSS%' THEN 'GRS'
             ELSE 'WI'
          END
             gross_net,
          '-1' normalized_time_key,
          ROUND (
             CAST (
                CASE
                   WHEN ax.cube_child_member LIKE '%Well_Counts%' THEN amount
                   ELSE amount * 1000
                END AS float),
             7)
             cad,
          --ROUND (CAST (amount * 1000 AS NUMBER), 7) cad,
          ROUND (CAST (amount AS float), 7) k_cad
FROM
              (SELECT variable_value reserve_book_date
				FROM [stage].t_ctrl_valnav_etl_variables
				WHERE variable_name = 'RESERVE_BOOK_DATE') rbd,
			  (SELECT variable_value scenario
				FROM [stage].t_ctrl_valnav_etl_variables
				WHERE variable_name = 'XLS_RESERVES_CUBE_SCENARIO_VOLUMES') cs,
		     [stage].t_stg_valnav_reserves_xls rx
			 LEFT OUTER JOIN
			 ( -- Guids by uwi
				SELECT DISTINCT
                  --uwi,
                  formatted_uwi,
                  FIRST_VALUE (entity_key) OVER (PARTITION BY formatted_uwi ORDER BY formatted_uwi)
                     entity_key
				FROM [data_mart].t_dim_entity
				WHERE is_valnav=1) e
			ON LTRIM(RTRIM(rx.uwi)) = e.formatted_uwi
			LEFT OUTER JOIN
	           (-- Guids based on cc_num
				SELECT DISTINCT
                  cost_centre,
                  FIRST_VALUE (entity_key) OVER (PARTITION BY cost_centre ORDER BY cost_centre)
                     entity_key,
                  FIRST_VALUE (uwi) OVER (PARTITION BY cost_centre ORDER BY cost_centre) uwi,
                  FIRST_VALUE (formatted_uwi) OVER (PARTITION BY cost_centre ORDER BY cost_centre)
                     formatted_uwi
				FROM [data_mart].t_dim_entity
				WHERE is_valnav=1
				AND LTRIM(RTRIM (area)) IS NOT NULL AND RTRIM(LTRIM (cost_centre)) IS NOT NULL) ec
		   ON rx.cc_num = ec.cost_centre
		   LEFT OUTER JOIN
		    (SELECT variable_value, cube_child_member, comments measure_type
             FROM [stage].t_ctrl_valnav_etl_variables
            WHERE variable_name = 'XLS_RESERVES_ACCOUNTS') ax
		  ON rx.accounts = ax.variable_value
		  LEFT OUTER JOIN
			(SELECT variable_value, cube_child_member
             FROM [stage].t_ctrl_valnav_etl_variables
            WHERE variable_name = 'XLS_RESERVES_RESERVE_CATEGORY') rs
		  ON RTRIM(LTRIM (rx.reserve_category)) = rs.variable_value
WHERE ax.measure_type IN ('CAPITAL', 'ECONOMICS')
) sd;