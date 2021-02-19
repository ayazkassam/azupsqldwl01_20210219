CREATE VIEW [datamart_marketing].[v_fact_source_allocated_sales_raw_volumes]
AS SELECT 
       flownet_id,
	   flownet_name,
	   child_idrec,
	   uwi_name,
	   cc_num,
	   typ,
	   sales_disposition_point,
	   sav.dttm activity_date,
	   allocated_volume,
	   --sales_volume,
	   CASE WHEN SUM(allocated_volume) OVER (PARTITION BY child_idrec, sav.dttm) = 0
	        THEN NULL
			ELSE (isnull(allocated_volume,0) / SUM(allocated_volume) OVER (PARTITION BY child_idrec, sav.dttm))
					* raw.gasrawprod 
	   END raw_volume,
	   --ppd.gas,
	   --psy.gas_shrinkage,
	   CASE WHEN ppd.gas IS NOT NULL
	        THEN  ppd.gas * isnull(psy.gas_shrinkage, 1)
			WHEN (isnull(allocated_volume,0) <> 0 AND UPPER (isnull (raw.facilityidd, 'ALLOCATED')) = 'ALLOCATED')
			THEN allocated_volume
			ELSE  (CASE WHEN SUM(allocated_volume) OVER (PARTITION BY child_idrec, sav.dttm) = 0
				  THEN NULL
			      ELSE (isnull(allocated_volume,0) / SUM(allocated_volume) OVER (PARTITION BY child_idrec, sav.dttm))
					* raw.gasrawprod 
				   END
				  ) * isnull (psy.gas_shrinkage, 1)


	   END sales_volume
FROM
(
-- sav 
SELECT 
    flownet_name,
	flownet_id,
	child_idrec, 
	uwi_name,
	uwi,
	cc_num,
	sales_disposition_point, 
	typ, 
	dttm, 
	sum(allocated_volume) allocated_volume,
	sum(sales_volume) sales_volume
from
	(
	-- source

	SELECT	ent.flownet_name,
			ent.flownet_id,
			ent.sales_disposition_point,
			ent.child_idrec,
			ent.uwi_name,
			ent.uwi,
			parent_idrec,
			ent.cc_num,
			--data.dttmprod,
			data.dttm,
			data.idrecdispunit,
			upper(ltrim(rtrim(pun.typdisp1))) typ,
			CASE WHEN upper(ltrim(rtrim(pun.typdisp1))) IN ('SALE','FUEL') 
				 THEN data.volgas/1000
				 ELSE NULL
			END allocated_volume,
			CASE WHEN upper(ltrim(rtrim(pun.typdisp1))) IN ('SALE') 
				 THEN data.volgas/1000
				 ELSE NULL
			END sales_volume
	   ---data.volgas/1000 as gas_volume
	FROM
	   
	    ( 
	       -- timerange
			-->> Start date range based on current date - 121
			SELECT CAST(CAST(YEAR(CURRENT_TIMESTAMP-121) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(CURRENT_TIMESTAMP-121) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(CURRENT_TIMESTAMP-121) AS VARCHAR),2) AS INT) start_date_range_key,
            CAST(CAST(YEAR(CURRENT_TIMESTAMP-1) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(CURRENT_TIMESTAMP-1) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(CURRENT_TIMESTAMP-1) AS VARCHAR),2) AS INT) end_date_range_key,
			cast (CURRENT_TIMESTAMP-121 as date) start_date_range,
			cast (CURRENT_TIMESTAMP-1 as date) end_date_range					
	    ) timerange,  
        (-- ent
		select distinct 
			flownet_name,
			flownet_id,
			sales_disposition_point,
			sales_disposition_point_idrec,
			uwi,
			child_name uwi_name,
			cube_child,
			child_idrec,
			parent_idrec,
			cc_num,
			dttmstart,
			dttmend
		from  [datamart_marketing].[t_stg_marketing_flownet_hierarchy]
		--where uwi is not null
		where ISNULL(idrecmetereventtk,'GOOD ONE') <> 'pvunitmeterliquid'
		and meter_type <> 'Test Gas'
	    ) ent
	 LEFT OUTER JOIN stage_prodview.t_pvt_pvunitdispmonthday data
	  ON ent.child_idrec =  data.idrecunit  ---data.idrecunitorigin
	  AND ent.sales_disposition_point_idrec = data.idrecdispunit
	 --- AND (data.dttm >= ent.dttmstart and data.dttm <= ent.dttmend)	
	 --
	 JOIN stage_prodview.t_pvt_pvunitnode pun
	 ON data.idrecdispunit = pun.idrecparent

	 AND upper(pun.typdisp1) IN ('SALE','FUEL') 
	 AND pun.dispositionpoint=1
	 and upper(pun.dispproductname)='GAS'
	 WHERE(data.dttm between timerange.start_date_range and timerange.end_date_range)


 ) source

 group by flownet_name, flownet_id, child_idrec, uwi_name, uwi, cc_num, sales_disposition_point, typ, dttm
) sav
LEFT OUTER JOIN
(
-- raw volumes
SELECT pu.idflownet,
	   pu.idrec,
	   pz.dttm,
	   fh.usertxt2 facilityidd,
	   ROUND (pz.volprodgathgas / 1000, 15) AS gasrawprod
 FROM stage_prodview.t_pvt_pvunit pu
JOIN stage_prodview.t_pvt_pvunitcomp puc ON pu.idflownet = puc.idflownet AND pu.idrec = puc.idrecparent
JOIN stage_prodview.t_pvt_pvunitallocmonthday pz ON pu.idflownet = pz.idflownet AND pu.idrec = pz.idrecunit AND puc.idrec = pz.idreccomp
JOIN stage_prodview.t_pvt_pvflownetheader fh
	  ON pu.idflownet = fh.idflownet
	  JOIN (SELECT distinct flownet_id
	         FROM [datamart_marketing].t_ctrl_marketing_etl_variables
			 WHERE etl_type = 'MAIN SETUP'
			 ) mif
	   ON pu.idflownet = mif.flownet_id
 WHERE     pu.costcenterida IS NOT NULL
) raw
ON sav.flownet_id   = raw.idflownet
AND sav.child_idrec = raw.idrec
AND sav.dttm    = raw.dttm
--
-- Prorate Data
 LEFT OUTER JOIN [stage].[t_prodview_proration_data] ppd
     ON	(	sav.uwi_name = ppd.uwi
      AND   sav.dttm = ppd.tdate
        )
--
-- Shrinkage Rates
 LEFT OUTER JOIN [stage].[t_prodview_shrink_yield_rates] psy
     ON (    sav.flownet_id = psy.idflownet
      -- AND prv.keymigrationsource = psy.keymigrationsource
       AND sav.uwi = psy.compida
	   AND  sav.dttm >= psy.dttmstart 
	   AND  sav.dttm <= psy.dttmend
	   );