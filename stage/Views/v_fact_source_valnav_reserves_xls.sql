CREATE VIEW [stage].[v_fact_source_valnav_reserves_xls]
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
			  imp_vol_mth imperial_volume,
			  boe_vol_mth boe_volume,
			  met_vol_mth metric_volume,
			  mcfe_vol_mth mcfe_volume,
			  'RESERVES' scenario_type
	   FROM
	   (
	   SELECT
	    ----- ISNULL (ISNULL (e.entity_key, ec.entity_key), LTRIM(RTRIM (rx.uwi)))   entity_key,
	     ISNULL (ISNULL (ec.entity_key, e.entity_key), LTRIM(RTRIM (rx.uwi)))   entity_key,
          -- nvl for rx.uwi necessary as there could be cases where data does not line up.
          -- For example a uwi...  'Other Revenue and Expenses'
         -- ISNULL (ISNULL (e.uwi, ec.uwi),  RTRIM(LTRIM (rx.uwi))) uwi,
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
          ROUND (CAST (amount * 1000 AS float), 7) imp_vol_mth,
          -- ROUND (SUM (CAST (mcfe_vol_mth AS DECIMAL)), 7)
          ROUND (
             CAST (
                CASE
                   WHEN UPPER (ax.cube_child_member) LIKE '%GAS%'
                   THEN
                      (amount * 1000) / 35.49373 * 5.91562
                   ELSE
                      (amount * 1000)
                END AS float),
             7)
             boe_vol_mth,
          ROUND (
             CAST (
                CASE
                   WHEN UPPER (ax.cube_child_member) LIKE '%GAS%'
                   THEN
                      (amount * 1000) / 35.49373
                   ELSE
                      (amount * 1000) / 6.29287
                END AS float),
             7)
             met_vol_mth,
          ROUND (
             CAST (
                CASE
                   WHEN UPPER (ax.cube_child_member) LIKE '%GAS%'
                   THEN
                      (amount * 1000) * 1
                   ELSE
                      (amount * 1000) * 6
                END AS float),
             7)
             mcfe_vol_mth
     --rx.*
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
                 -- uwi,
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
			AND LTRIM(RTRIM (area)) IS NOT NULL AND RTRIM(LTRIM (cost_centre)) IS NOT NULL
			AND LEN(entity_key) > 6
			) ec
		ON LTRIM(RTRIM(rx.cc_num)) = ec.cost_centre
		LEFT OUTER JOIN
			(SELECT variable_value, cube_child_member, comments measure_type
             FROM [stage].t_ctrl_valnav_etl_variables
            WHERE variable_name = 'XLS_RESERVES_ACCOUNTS') ax
		ON RTRIM(LTRIM (rx.accounts)) = ax.variable_value
		LEFT OUTER JOIN
		(SELECT variable_value, cube_child_member
             FROM [stage].t_ctrl_valnav_etl_variables
            WHERE variable_name = 'XLS_RESERVES_RESERVE_CATEGORY') rs
		ON RTRIM(LTRIM (rx.reserve_category)) = rs.variable_value
WHERE ax.measure_type = 'RESERVES'
AND (   UPPER (rx.accounts) LIKE '%GROSS%'   OR UPPER (rx.accounts) LIKE '%W.I.%')
--
UNION ALL
--
SELECT   ISNULL (ISNULL (ec.entity_key, e.entity_key), LTRIM(RTRIM (rx.uwi)))  entity_key,
          -- nvl for rx.uwi necessary as there could be cases where data does not line up.
          -- For example a uwi...  'Other Revenue and Expenses'
          --ISNULL (ISNULL (e.uwi, ec.uwi),  RTRIM(LTRIM (rx.uwi))) uwi,
          CAST (rbd.reserve_book_date as datetime) actvy_date,
          rx.accounts,
          rs.cube_child_member reserve_category_id,
          cs.scenario,
          'RI' gross_net,
          '-1' production_days_on_id,
          ROUND (CAST (amount * 1000 AS float), 7) imp_vol_mth,
          -- ROUND (SUM (CAST (mcfe_vol_mth AS DECIMAL)), 7)
          ROUND (
             CAST (
                CASE
                   WHEN UPPER (rx.accounts) LIKE '%GAS%'
                   THEN
                      (amount * 1000) / 35.49373 * 5.91562
                   ELSE
                      (amount * 1000)
                END AS float),
             7)
             boe_vol_mth,
          ROUND (
             CAST (
                CASE
                   WHEN UPPER (rx.accounts) LIKE '%GAS%'
                   THEN
                      (amount * 1000) / 35.49373
                   ELSE
                      (amount * 1000) / 6.29287
                END AS float),
             7)
             met_vol_mth,
          ROUND (
             CAST (
                CASE
                   WHEN UPPER (rx.accounts) LIKE '%GAS%'
                   THEN
                      (amount * 1000) * 1
                   ELSE
                      (amount * 1000) * 6
                END AS float),
             7)
             mcfe_vol_mth
FROM
              (SELECT variable_value reserve_book_date
				FROM [stage].t_ctrl_valnav_etl_variables
				WHERE variable_name = 'RESERVE_BOOK_DATE') rbd,
			  (SELECT variable_value scenario
				FROM [stage].t_ctrl_valnav_etl_variables
				WHERE variable_name = 'XLS_RESERVES_CUBE_SCENARIO_VOLUMES') cs,
		     (SELECT rco.uwi,
                  rco.cc_num,
                  rco.reserve_category,
                  -- rwi.accounts,
                  rco.accounting_month,
                  'Booked_Res_' + SUBSTRING (LTRIM(RTRIM (rco.accounts)), 1, 3) accounts,
                  --rwi.amount wi_amount,
                  --rco.amount co_amount,
                  rco.amount - ISNULL (rwi.amount, 0) amount
             FROM 
                  (  SELECT uwi,
                            cc_num,
                            reserve_category,
                            SUBSTRING (LTRIM(RTRIM (accounts)), 1, 3) accounts,
                            accounting_month,
                            SUM (amount) amount
                       FROM [stage].t_stg_valnav_reserves_xls
                      WHERE UPPER (accounts) LIKE '%COMP.%'
                   GROUP BY uwi,
                            cc_num,
                            reserve_category,
                            SUBSTRING (LTRIM(RTRIM (accounts)), 1, 3),
                            accounting_month) rco
				 LEFT OUTER JOIN
				 (  SELECT uwi,
                            cc_num,
                            reserve_category,
                            SUBSTRING (LTRIM(RTRIM (accounts)), 1, 3) accounts,
                            accounting_month,
                            SUM (amount) amount
                       FROM [stage].t_stg_valnav_reserves_xls
                      WHERE UPPER (accounts) LIKE '%W.I.%'
                   GROUP BY uwi,
                            cc_num,
                            reserve_category,
                            SUBSTRING (LTRIM(RTRIM (accounts)), 1, 3),
                            accounting_month) rwi
			     ON   rco.uwi = rwi.uwi
                  AND rco.cc_num = rwi.cc_num
                  AND rco.reserve_category = rwi.reserve_category
                  AND rco.accounting_month = rwi.accounting_month
                  AND rco.accounts = rwi.accounts
				  ) rx
	   LEFT OUTER JOIN
			 ( -- Guids by uwi
			SELECT DISTINCT
                  uwi,
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
			AND LTRIM(RTRIM (area)) IS NOT NULL AND RTRIM(LTRIM (cost_centre)) IS NOT NULL
			AND LEN(entity_key) > 6
			) ec
		ON rx.cc_num = ec.cost_centre
		LEFT OUTER JOIN
		(SELECT variable_value, cube_child_member
             FROM [stage].t_ctrl_valnav_etl_variables
            WHERE variable_name = 'XLS_RESERVES_RESERVE_CATEGORY') rs
		ON RTRIM(LTRIM (rx.reserve_category)) = rs.variable_value
WHERE rx.amount <> 0
) sd;