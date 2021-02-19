CREATE VIEW [stage].[v_cc_uwi_master_source] AS SELECT DISTINCT
       CAST(FIRST_VALUE (cc_num) OVER (PARTITION BY uwi ORDER BY win_order) AS VARCHAR(50))
          cc_num,
       CAST(uwi AS VARCHAR(50)) as uwi,
       CAST(FIRST_VALUE (well_name)
          OVER (PARTITION BY uwi ORDER BY win_order) AS VARCHAR(100))
          well_name,
	   CAST(FIRST_VALUE(data_source) OVER (PARTITION BY uwi ORDER BY win_order) AS VARCHAR(20)) data_source
  FROM
(
SELECT DISTINCT
               puc.compida uwi,
               FIRST_VALUE (
                  puc.completionname)
               OVER (PARTITION BY puc.compida, pu.costcenterida
                     ORDER BY (CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate
									WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate
									ELSE ISNULL(puc.sysmoddate , pu.sysmoddate)
							   END)
				     DESC)  well_name,
               pu.costcenterida cc_num,
              'Prodview' data_source,
              '1' win_order			   
          FROM [stage_prodview].[t_pvt_pvunit] pu, 
		       [stage_prodview].[t_pvt_pvunitcomp] puc
         WHERE puc.compida IS NOT NULL
		 AND   pu.idflownet = puc.idflownet AND pu.idrec = puc.idrecparent
       AND pu.dttmend IS NULL
		and puc.dttmend IS NULL
--
union
--
SELECT DISTINCT 
  uwi,
                        uwi_desc AS well_name,
                        cost_centre_id,
                        'Qbyte' AS data_source,
						'2' win_order
  FROM [stage].[t_cost_centre_hierarchy]
  where uwi <> ''
 -- AND cc_type IN ('OGW','UNT','UNW','INJ','RYI','HGW','PAD','PDW','WSL','FEE','SLD','ABN','POT','COM','PUD','PLT','GGS','LOC','ACQ','BTY')
--
union 
--
SELECT DISTINCT well_location uwi,   
		        well_name,
               cost_centre_id,
			   'PVR' as data_source,
			   '3' win_order
FROM [stage].[t_pvr_twell]
--
union 
--
SELECT DISTINCT CASE RTRIM(LTRIM (UPPER (fs.LOCATION)))
                  WHEN '100000000000W000' THEN RTRIM(LTRIM (fs.secondary_location))
                  ELSE RTRIM(LTRIM (UPPER (fs.LOCATION)))
               END AS uwi, 
		       RTRIM(LTRIM (fs.NAME)) AS well_name,
               UPPER (ISNULL(RTRIM(LTRIM (fs.datapoint_8)), RTRIM(LTRIM (fs.pa_code)))) AS cost_centre_id,
			   'Fieldview' as data_source,
			   '4' win_order
FROM [stage].[t_stg_avocet_mv_fv_site] fs
WHERE   (  ISNULL (LTRIM(RTRIM (fs.datapoint_8)), LTRIM(RTRIM (fs.pa_code))) IS NOT NULL
--AND SUBSTRING(ISNULL (LTRIM(RTRIM (fs.datapoint_8)), LTRIM(RTRIM (fs.pa_code))),1,1) <> 'N'
--AND SUBSTRING(ISNULL (LTRIM(RTRIM (fs.datapoint_8)), LTRIM(RTRIM (fs.pa_code))),1,1) <> '?'
)
AND TYPE IN (1, 5, 6)
--
union 
--
SELECT DISTINCT uwi,   
		        well_name,
               cc_num,
			   'PRISM' as data_source,
			   '5' win_order
FROM [stage].[t_stg_prism_uwi_cc]
) sd;