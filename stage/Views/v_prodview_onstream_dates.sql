CREATE VIEW [stage].[v_prodview_onstream_dates]
AS SELECT site_id,
         uwi,
         cc_num,
         MIN (actvy_per_date) AS onstream_date,
         MIN (YEAR(actvy_per_date)) AS onstream_year
    FROM (  SELECT site_id,
                   uwi,
                   cc_num,
                   actvy_per_date,
                   SUM (daily_volume) AS monthly_volume,
                   CASE SUM (daily_volume) WHEN 0 THEN 'Y' ELSE 'N' END
                      AS is_zero_vol
              FROM (SELECT keymigrationsource site_id,
                           compida uwi,
                           cc_num,
                           dttm AS actvy_per_date,
                           volprodgathgas,
                           volprodgathhcliq,
                           volprodgathwater,
                             ISNULL(volprodgathgas, 0)
                           + ISNULL(volprodgathhcliq, 0)
                           + ISNULL(volprodgathwater, 0)
                              AS daily_volume
                      FROM stage.[t_prodview_allocated_volumes]
                     WHERE keymigrationsource = compida
					 --
					 union all
					 --
					 SELECT keymigrationsource site_id,
                           compida uwi,
                           cc_num,
                           dttm AS actvy_per_date,
                           volprodgathgas,
                           volprodgathhcliq,
                           volprodgathwater,
                             ISNULL(volprodgathgas, 0)
                           + ISNULL(volprodgathhcliq, 0)
                           + ISNULL(volprodgathwater, 0)
                              AS daily_volume
                      FROM stage.[t_prodview_allocated_volumes_incr]
                     WHERE keymigrationsource = compida
                  ) s
          GROUP BY site_id,
                   uwi,
                   cc_num,
                   actvy_per_date) sd
   WHERE is_zero_vol = 'N'
GROUP BY site_id, uwi, cc_num;