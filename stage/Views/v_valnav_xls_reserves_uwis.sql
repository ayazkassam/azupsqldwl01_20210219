CREATE VIEW [stage].[v_valnav_xls_reserves_uwis]
AS SELECT DISTINCT entity_guid,
                ISNULL (uwi, formatted_uwi) uwi,
                formatted_uwi,
                sd.cc_num,
                ccr.reserve_property year_end_reserves_property
  FROM		 (SELECT 
               ISNULL(ec.entity_key, dh.entity_guid) entity_guid,
               dh.uwi uwi,
               rx.formatted_uwi,
               rx.cc_num cc_num
          FROM ( -- Reserves XLS
                SELECT DISTINCT
                       RTRIM(LTRIM (uwi)) formatted_uwi,
                       RTRIM(LTRIM (FIRST_VALUE (cc_num) OVER (PARTITION BY uwi ORDER BY uwi)))
                          cc_num
                  FROM [stage].t_stg_valnav_reserves_xls
                 WHERE RTRIM(LTRIM (uwi)) IS NOT NULL
				 ) rx
		  LEFT OUTER JOIN
               ( -- Guids by uwi
                SELECT DISTINCT
                       uwi,
                       formatted_uwi,
                       FIRST_VALUE (entity_key)
                          OVER (PARTITION BY formatted_uwi order by uwi)
                          entity_guid
                  FROM [data_mart].t_dim_entity
				  WHERE is_valnav=1
				  ) dh      
         ON rx.formatted_uwi = dh.formatted_uwi
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
			AND LEN(entity_key) > 6	) ec
		 ON LTRIM(RTRIM(rx.cc_num)) = ec.cost_centre
		 ) sd
LEFT OUTER JOIN
      (SELECT DISTINCT
               cc_num,
               FIRST_VALUE (reserves_property) OVER (PARTITION BY cc_num order by cc_num)  reserve_property
          FROM (SELECT RTRIM(LTRIM (cc_num)) cc_num,
                       RTRIM(LTRIM (reserves_property)) reserves_property
                  FROM [stage].t_stg_valnav_reserves_xls
                 WHERE cc_num IS NOT NULL) rp
		) ccr
ON sd.cc_num = ccr.cc_num;