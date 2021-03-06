﻿CREATE VIEW [stage].[v_fact_source_valnav_production_budget_final]
AS SELECT entity_key,
       activity_date_key,
	   accounts account_key,
	   reserve_category_id,
	   scenario scenario_key,
	   scenario_type,
	   grs_net gross_net_key,
	   normalized_time_key,
	   sum(imperial_volume) imperial_volume,
	   sum(boe_volume) boe_volume,
	   sum(metric_volume) metric_volume,
	   sum(mcfe_volume) mcfe_volume
FROM
(
SELECT				entity_id entity_key,
                    CASE WHEN  step_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(step_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(step_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(step_date) AS VARCHAR),2) AS INT)
					END activity_date_key,
                    --step_date AS actvy_date,
                    accounts,
                    reserve_category_id,
                    scenario,
                    scenario_type,
                    gn.grs_net,
					/*
                    CASE
                       WHEN    normalized_time_key = '-1'
                            OR MONTHS_BETWEEN (TRUNC (step_date, 'month'),
                                               TRUNC (onstream_date, 'month')) >=
                                  mpd.max_on_prod_days
                       THEN
                          '-1'
                       ELSE
                             LPAD (
                                  MONTHS_BETWEEN (
                                     TRUNC (step_date, 'month'),
                                     TRUNC (onstream_date, 'month'))
                                + 1,
                                2,
                                '0')
                          || '.'
                          || LPAD (TO_NUMBER (TO_CHAR (step_date, 'DD')),
                                   2,
                                   '0')
                    END
                       AS production_days_on_id,
					   */
					 CASE
                       WHEN    normalized_time_key = '-1'
                            OR datediff(MONTH,onstream_date, step_date)+1 >= mp.max_on_prod_days
                       THEN
                          '-1'
                       ELSE
                              CONCAT(
								   RIGHT(CONCAT('0',datediff(MONTH,onstream_date, step_date)+1),2),
								   '.01'
								   )
                    END
                       AS normalized_time_key,
                    CASE gn.grs_net
                       WHEN 'GRS' THEN gross_volume_imp
                       WHEN 'WI' THEN wi_volume_imp
                       WHEN 'RI' THEN ri_volume_imp
                    END AS imperial_volume,
                    CASE gn.grs_net
                       WHEN 'GRS' THEN gross_volume_boe
                       WHEN 'WI' THEN wi_volume_boe
                       WHEN 'RI' THEN ri_volume_boe
                    END AS boe_volume,
                    CASE gn.grs_net
                       WHEN 'GRS' THEN gross_volume_met
                       WHEN 'WI' THEN wi_volume_met
                       WHEN 'RI' THEN ri_volume_met
                    END AS metric_volume,
                    CASE gn.grs_net
                       WHEN 'GRS' THEN gross_volume_mcfe
                       WHEN 'WI' THEN wi_volume_mcfe
                       WHEN 'RI' THEN ri_volume_mcfe
                    END  AS mcfe_volume
               FROM (select *
			         from [stage].v_fact_source_valnav_production_budget
					 --where entity_id='a8e18b1c-dc56-4533-8a40-b09550bb9916'
					 )vp,
                    (SELECT 'GRS' AS grs_net 
                     UNION ALL
                     SELECT 'WI' AS grs_net 
                     UNION ALL
                     SELECT 'RI' AS grs_net) gn,
                    (SELECT variable_value AS max_on_prod_days
                       FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
                      WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS'
					  ) mp
) sd
GROUP BY entity_key,
       activity_date_key,
	   accounts,
	   reserve_category_id,
	   scenario,
	   scenario_type,
	   grs_net,
	   normalized_time_key

--------------------------------
UNION ALL
--------------------------------
-- Initial Production
--------------------------------
 SELECT entity_key,
       activity_date_key,
	   accounts account_key,
	   reserve_category_id,
	   scenario scenario_key,
	   scenario_type,
	   grs_net gross_net_key,
	   normalized_time_key,
	   sum(imperial_volume) imperial_volume,
	   sum(boe_per_day) boe_volume,
	   sum(metric_volume) metric_volume,
	   sum(mcfe_volume) mcfe_volume
FROM
(
 SELECT             vp.entity_id entity_key,
					CASE WHEN  onstream_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(onstream_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(onstream_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(onstream_date) AS VARCHAR),2) AS INT)
					END activity_date_key,
                    --onstream_date actvy_date,
                    ip.ip_account accounts,
                    reserve_category_id,
                    scenario,
                    scenario_type,
                    gn.grs_net,
                    '-1' AS normalized_time_key,
                    CAST (NULL AS float) AS imperial_volume,
                    CAST (
                       (CASE
                           WHEN     cb.capital_type IS NULL
                                AND UPPER (scenario_type) IN ('BUDGET','TYPE CURVE') -- NOT BASE CAPITAL_TYPE and applicable to Budget...not base decline
                           THEN
                                (CASE gn.grs_net
                                    WHEN 'GRS' THEN gross_volume_boe
                                    WHEN 'WI' THEN wi_volume_boe
                                    WHEN 'RI' THEN ri_volume_boe
                                 END)
                              / 
							  (
							  datediff(DAY,
					           DATEADD(MONTH, DATEDIFF(MONTH, 0, cast(onstream_date as datetime)), 0),
							   cast((EOMONTH (DATEADD (M, ip.add_factor,ISNULL (cast(onstream_date as datetime), CURRENT_TIMESTAMP))) ) as datetime)
							  ) + 1
							  )
                           ELSE
                              NULL
                        END) AS float)
                       AS boe_per_day,
                    CAST (NULL AS float) AS metric_volume,
                    CAST (NULL AS float) AS mcfe_volume
               FROM (SELECT 'GRS' AS grs_net
                     UNION ALL
                     SELECT 'WI' AS grs_net
                     UNION ALL
                     SELECT 'RI' AS grs_net) gn,
                    (SELECT variable_value AS max_on_prod_days
                       FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
                      WHERE variable_name = 'MAX_PROD_DAYS_ON_MONTHS') mpd,
                    (SELECT 'IP1 Boed' AS ip_account, 0 AS add_factor
                     UNION ALL
                     SELECT 'IP3 Boed' AS ip_account, 2 AS add_factor
                     UNION ALL
                     SELECT 'IP6 Boed' AS ip_account, 5 AS add_factor
                     UNION ALL
                     SELECT 'IP12 Boed' AS ip_account, 11 AS add_factor) ip,
			        [stage].v_fact_source_valnav_production_budget  vp
			        LEFT OUTER JOIN
                    (SELECT *
                       FROM [data_mart].t_dim_entity
                      WHERE is_valnav=1
					  AND UPPER (LTRIM(RTRIM (capital_type))) = 'BASE') cb
					ON vp.entity_id = cb.entity_key                   
              WHERE     accounts NOT IN ('RawGas', 'Water')
              AND isnull (step_date, CURRENT_TIMESTAMP) BETWEEN ISNULL (onstream_date,CURRENT_TIMESTAMP)
                                                     AND EOMONTH (DATEADD (m,ip.add_factor,ISNULL (onstream_date, CURRENT_TIMESTAMP)))
 ) sd
GROUP BY entity_key,
       activity_date_key,
	   accounts,
	   reserve_category_id,
	   scenario,
	   scenario_type,
	   grs_net,
	   normalized_time_key
-------------------------------
UNION ALL
-------------------------------
-- Peek Production

SELECT entity_id entity_key,
       CASE WHEN  onstream_date IS NULL  THEN -1
						 ELSE  CAST(CAST(YEAR(onstream_date) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(onstream_date) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(onstream_date) AS VARCHAR),2) AS INT)
					END activity_date_key,
	   'Peak Rate Boed' account_key,
	   reserve_category_id,
	   scenario scenario_key,
	   scenario_type,
	   grs_net gross_net_key,
	   '-1' normalized_time_key,
	   null imperial_volume,
	   boe_volume / DAY(EOMONTH(step_date)) boe_volume,
	   null metric_volume,
	   null mcfe_volume

FROM
(
SELECT DISTINCT entity_id,
                           reserve_category_id,
                           step_date,
                           onstream_date,
                           boe_volume,
                           grs_net,
                           scenario,
                           scenario_type,
                           MAX (boe_volume)
                              OVER (PARTITION BY entity_id,
                                                 reserve_category_id,
                                                 grs_net,
                                                 scenario,
                                                 scenario_type)
                              AS max_boe_volume
             FROM (  SELECT entity_id,
                            reserve_category_id,
                            step_date,
                            onstream_date,
                            gn.grs_net,
                            scenario,
                            scenario_type,
                            SUM (
                               CASE gn.grs_net
                                  WHEN 'GRS' THEN gross_volume_boe
                                  WHEN 'WI' THEN wi_volume_boe
                                  WHEN 'RI' THEN ri_volume_boe
                               END)
                               AS boe_volume
                       --SUM (gross_volume_boe) AS gross_volume_boe
                       FROM [stage].v_fact_source_valnav_production_budget f,
                            (SELECT 'GRS' AS grs_net
                             UNION ALL
                             SELECT 'WI' AS grs_net
                             UNION ALL
                             SELECT 'RI' AS grs_net) gn,
                            (SELECT variable_value curr_year,
                                    variable_value + 1 next_year
                               FROM [stage].T_CTRL_VALNAV_ETL_VARIABLES
                              WHERE variable_name = 'CURRENT_BUDGET_YEAR') yb
                      WHERE     accounts NOT IN ('RawGas', 'Water')
                            AND YEAR(step_date) <= yb.next_year
                   GROUP BY entity_id,
                            step_date,
                            onstream_date,
                            reserve_category_id,
                            grs_net,
                            scenario,
                            scenario_type
                     HAVING SUM (
                               CASE gn.grs_net
                                  WHEN 'GRS' THEN gross_volume_boe
                                  WHEN 'WI' THEN wi_volume_boe
                                  WHEN 'RI' THEN ri_volume_boe
                               END) <> 0) sd
			) s
WHERE boe_volume = max_boe_volume;