CREATE VIEW [datamart_marketing].[v_uwis_by_sales_disposition_points]
AS select distinct
          --flownet_name,
          uwi,
		  --uwi_name,
		  --first_value(sales_disposition_point) over (partition by uwi order by dttm desc) sales_point
		  --first_value(sales_disposition_point) over (partition by uwi order by dttm, volgas desc) sales_disposition_point
		  first_value(sales_disposition_point) over (partition by uwi order by dttm desc, volgas desc) sales_disposition_point
from

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
	sum(sales_volume) sales_volume,
	sum(volgas) volgas,
	sum(volhcliq) volhcliq
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
			upper(ltrim(rtrim(data.typdisp1))) typ,
			CASE WHEN upper(ltrim(rtrim(data.typdisp1))) IN ('SALE','FUEL') 
				 THEN data.volgas/1000
				 ELSE NULL
			END allocated_volume,
			CASE WHEN upper(ltrim(rtrim(data.typdisp1))) IN ('SALE') 
				 THEN data.volgas/1000
				 ELSE NULL
			END sales_volume,
			data.dispproductname productname,
			data.volhcliq,
			data.volgas/ 1000 volgas
	   ---data.volgas/1000 as gas_volume
	FROM
	   
	    ( 
	       -- timerange
			-->> Start date range based on current date - 181
			SELECT CAST(CAST(YEAR(CURRENT_TIMESTAMP-181) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(CURRENT_TIMESTAMP-181) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(CURRENT_TIMESTAMP-181) AS VARCHAR),2) AS INT) start_date_range_key,
            CAST(CAST(YEAR(CURRENT_TIMESTAMP-1) AS VARCHAR) + right(replicate('00',2) + CAST( MONTH(CURRENT_TIMESTAMP-1) AS VARCHAR),2)
						+ right(replicate('00',2) + CAST( DAY(CURRENT_TIMESTAMP-1) AS VARCHAR),2) AS INT) end_date_range_key,
			cast (CURRENT_TIMESTAMP-181 as date) start_date_range,
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
		from  [datamart_marketing].[t_stg_marketing_ALL_flownet_hierarchy]
		---------where ISNULL(idrecmetereventtk,'GOOD ONE') <> 'pvunitmeterliquid'
		WHERE meter_type <> 'Test Gas'
	    ) ent

		LEFT OUTER JOIN 
		          
				( SELECT dis.*, nod.typdisp1, nod.dispproductname
					FROM stage_prodview.t_pvt_pvunitdispmonthday dis
					JOIN stage_prodview.t_pvt_pvunitnode nod
					ON dis.idrecdispunitnode = nod.idrec
					JOIN stage_prodview.t_pvt_pvunit un
					ON dis.idrecdispunit = un.idrec
					JOIN stage_prodview.t_pvt_pvunitcomp well
					ON dis.idreccomp = well.idrec
					JOIN stage_prodview.t_pvt_pvflownetheader flow
					ON flow.idflownet=dis.idflownet
					--					
					WHERE   nod.dispproductname in ('All Products','Gas') 
					and nod.typdisp1 = 'Sale'
						) data

		ON 
		     ent.child_idrec = data.idrecunit
		and  ent.sales_disposition_point_idrec = data.idrecdispunit
		
  /*				
	 LEFT OUTER JOIN  ( SELECT *
	                   FROM stage_prodview.t_pvt_pvunitdispmonthday
					   --WHERE productname in ('All Products','Gas')
					   )data

	  ON ent.child_idrec = data.idrecunit --origin
	  AND ent.sales_disposition_point_idrec = data.idrecdispunit
	  --AND (data.dttmprod >= ent.dttmstart and data.dttmprod <= ent.dttmend)	
	 --
	 LEFT OUTER JOIN stage_prodview.t_pvt_pvday pvday
	 ON  data.idflownet = pvday.idflownet
	 AND data.idrecparent = pvday.idrec
	 AND (pvday.dttm >= ent.dttmstart and pvday.dttm <= ent.dttmend)	
	 --
	WHERE  (pvday.dttm between timerange.start_date_range and timerange.end_date_range)
	AND upper(ltrim(rtrim(data.typdisp1))) IN ('SALE') ---,'FUEL') 

*/
  
   WHERE  (data.dttm between timerange.start_date_range and timerange.end_date_range)
	AND upper(ltrim(rtrim(data.typdisp1))) IN ('SALE') ---,'FUEL') 

	
 ) source
 --where dttmprod='2015-02-08'
 --and uwi_name='100/09-35-050-18W5/00'
 group by flownet_name, flownet_id, child_idrec, uwi_name, uwi, cc_num, sales_disposition_point, typ, dttm
 ) sav
where uwi is not null;