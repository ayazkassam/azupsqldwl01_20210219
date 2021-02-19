CREATE VIEW [stage].[v_prodview_allocated_volumes]
AS SELECT distinct 
     pu.idflownet
    , CASE WHEN LTRIM (RTRIM (pu.keymigrationsource)) IS NULL OR LTRIM (RTRIM (pu.keymigrationsource)) = ''
		THEN puc.compida ELSE LTRIM (RTRIM (pu.keymigrationsource)) END AS keymigrationsource
	, puc.compida
	--, COALESCE (pu.unitidpa, pu.costcenterida) AS cc_num
	,  pu.costcenterida cc_num
	, FIRST_VALUE (puc.completionname) OVER (PARTITION BY pu.keymigrationsource, puc.compida, COALESCE (pu.unitidpa, pu.costcenterida)
			ORDER BY (CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate ELSE puc.sysmoddate END) DESC) AS completionname
	, FIRST_VALUE (pu.NAME) OVER (PARTITION BY pu.keymigrationsource, puc.compida, COALESCE (pu.unitidpa, pu.costcenterida)
			ORDER BY (CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate ELSE puc.sysmoddate END) DESC) AS name
	, FIRST_VALUE (pu.nameshort) OVER (PARTITION BY pu.keymigrationsource, puc.compida, COALESCE (pu.unitidpa, pu.costcenterida)
			ORDER BY (CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate ELSE puc.sysmoddate END) DESC) AS nameshort

	, FIRST_VALUE (fh.usertxt2) OVER (PARTITION BY pu.keymigrationsource, puc.compida, COALESCE (pu.unitidpa, pu.costcenterida)
		ORDER BY pz.dttm DESC) AS facilityidd

	, puc.typmigrationsource
	, pu.unitidc
	, pz.dttm
	, pz.durop * 24 hours_on
	, ROUND (pz.voldispsalegas / 1000, 15) AS gassalesestimate
	, pz.voldispsalehcliq
	, pz.voldispinjectwater
	, pz.volprodallochcliq
	--
	-- Raw

	
	, ROUND (
	      (case when cs.flowdirection = 'both'
		        then pz.volprodgathgas - COALESCE(pz.volinjectrecovgas, 0)
				else pz.volprodgathgas 
		   end) 
		   / 1000, 15) AS volprodgathgas
   

	, pz.volprodgathhcliq
	, pz.volprodgathwater
	--
	, pz.volnewprodallochcliq
	, pz.volnewprodallocwater
	, pz.volremainrecovhcliq


	, comp.prescas
	, comp.prestub

FROM stage_prodview.t_pvt_pvunit pu
JOIN stage_prodview.t_pvt_pvunitcomp puc ON pu.idflownet = puc.idflownet AND pu.idrec = puc.idrecparent
JOIN stage_prodview.t_pvt_pvunitallocmonthday pz ON pu.idflownet = pz.idflownet AND pu.idrec = pz.idrecunit AND puc.idrec = pz.idreccomp
--tubing and casing pressures
LEFT OUTER JOIN stage_prodview.t_pvt_pvunitcompparam comp
ON pz.idrecparam = comp.idrec
AND puc.idrec = comp.idrecparent


LEFT outer JOIN stage_prodview.t_pvt_pvflownetheader fh ON pz.idflownet = fh.idflownet 

-- join to bring flowdirection and change how gathered volumes are used
LEFT OUTER JOIN 
     (SELECT DISTINCT 
        idflownet,
		idrecparent,
		FIRST_VALUE(flowdirection) OVER (PARTITION BY idflownet, idrecparent order by dttm desc) flowdirection
		--FIRST_VALUE(dttm) OVER (PARTITION BY idflownet, idrecparent order by dttm desc) dttm
	  FROM stage_prodview.[t_pvt_pvunitcompstatus]
     ) cs 
	 
ON puc.idflownet = cs.idflownet
AND puc.idrec = cs.idrecparent

WHERE pu.costcenterida IS NOT NULL
and cast(pz.dttm as date) >= cast(pu.unitidc as date);