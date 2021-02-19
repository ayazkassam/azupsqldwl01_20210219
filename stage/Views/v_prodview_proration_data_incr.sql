CREATE VIEW [stage].[v_prodview_proration_data_incr]
AS SELECT 
       --pu.name uwi,
	   puc.completionname uwi,    
	   pu.costcenterida costcenter,
	   CASE WHEN RTRIM (LTRIM (pu.keymigrationsource)) IS NULL OR pu.keymigrationsource = '' 
			THEN puc.compida ELSE pu.keymigrationsource END AS FDC,
	   CONVERT(DATE, cgmd.dttm) dttm,
	   ROUND ( ((cgmd.volgas / 1000) *  fmdc.balfactgas), 2)  prorated_gas,
	   ROUND ((cgmd.volhcliq * fmdc.balfacthcliq) , 2) prorated_oil,
	   ROUND ((cgmd.volwater * fmdc.balfactwater), 2) prorated_water

	   
	   /*
	   pu.idflownet,
	   puc.idrec,

       fh.name,
       fh.usertxt2 prorated_setting,
	  
	   pu.typ1 unit_type,
	   f.typ1,
	   cgmd.dttm,
	   cgmd.volgas / 1000 gathered_gas,
	   fmdc.balfactgas prorated_factor_gas,
	   fmdc.balfacthcliq prorated_factor_oil,
	   fmdc.balfactwater prorated_factor_water
	   */
FROM stage_prodview.t_pvt_pvflownetheader fh
JOIN stage_prodview.t_pvt_pvunit pu
ON fh.idflownet = pu.idflownet
JOIN stage_prodview.t_pvt_pvunitcomp puc
ON pu.idrec = puc.idrecparent
JOIN stage_prodview.t_pvt_pvunitcompgathmonthcalc cgm
ON puc.idrec = cgm.idrecparent
JOIN stage_prodview.t_pvt_pvunitcompgathmonthdaycalc_incr cgmd
--ON pu.idflownet = cgmd.idflownet
ON cgm.idrec = cgmd.idrecparent
JOIN  stage_prodview.t_pvt_pvfacility f
on pu.idrecfacilitycalc = f.idrec
JOIN stage_prodview.t_pvt_pvFacilityMonthDayCalc fmdc
ON pu.idrecfacilitycalc = fmdc.idrecfacility
AND f.idrec = fmdc.idrecfacility
AND cgmd.dttm = fmdc.dttm
JOIN 
   (SELECT DISTINCT idflownet,
				idrecparent,
				first_value(methodgas) over (partition by idflownet, idrecparent order by dttmstart desc) methodgas
				--first_value(methodhcliq) over (partition by idflownet, idrecparent order by dttmstart desc) methodhcliq,
				--first_value(methodwater) over (partition by idflownet, idrecparent order by dttmstart desc) methodwater
   from stage_prodview.t_pvt_pvunitcompmeasmeth
   ) cmas
ON puc.idrec = cmas.idrecparent
--
AND upper(fh.usertxt2) = 'PRORATED'
AND upper(f.typ1) = 'PRODUCTION'
--
AND upper(cmas.methodgas) = 'TESTED';