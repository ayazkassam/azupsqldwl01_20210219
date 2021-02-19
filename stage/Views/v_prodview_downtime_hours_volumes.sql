CREATE VIEW [stage].[v_prodview_downtime_hours_volumes] AS SELECT DISTINCT pu.idflownet
		, CASE WHEN LTRIM (RTRIM (pu.keymigrationsource)) IS NULL OR LTRIM (RTRIM (pu.keymigrationsource)) = ''
				THEN puc.compida ELSE LTRIM (RTRIM (pu.keymigrationsource)) END AS keymigrationsource
		, puc.compida
		, COALESCE (pu.unitidpa, pu.costcenterida) AS cc_num
		, FIRST_VALUE (puc.completionname) OVER (PARTITION BY pu.keymigrationsource, puc.compida, pu.costcenterida
				ORDER BY CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate ELSE puc.sysmoddate END DESC) AS completionname
		, FIRST_VALUE (pu.name) OVER (PARTITION BY pu.keymigrationsource, puc.compida, pu.costcenterida
				ORDER BY CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate ELSE puc.sysmoddate END DESC) AS name
		, FIRST_VALUE (pu.nameshort) OVER (PARTITION BY pu.keymigrationsource, puc.compida, pu.costcenterida 
				ORDER BY CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate ELSE puc.sysmoddate END DESC) AS nameshort
		, puc.typmigrationsource
		, pz.dttm
		, pz.durop * 24.0 AS hours_on
		, pz.durdown * 24.0 AS hours_down
		, pz.vollosthcliq
		, pz.vollostgas
		, pz.vollostwater
		, pz.durdown
		, pz.durop
		, dt.codedowntm1
		--, coalesce(FIRST_VALUE(dt.codedowntm1) OVER (PARTITION BY puc.keymigrationsource ORDER BY dt.durdowncalc DESC),
		--    'Other Problems (Comment Required)') codedowntm1
		/* first value used due to duplicate issue */
	
	FROM stage_prodview.t_pvt_pvunit pu
	JOIN stage_prodview.t_pvt_pvunitcomp puc ON pu.idflownet = puc.idflownet AND pu.idrec = puc.idrecparent
	JOIN stage_prodview.t_pvt_pvunitallocmonthday pz ON pu.idflownet = pz.idflownet AND pu.idrec = pz.idrecunit AND puc.idrec = pz.idreccomp
	JOIN stage_prodview.t_pvt_pvunitcompdowntm dt ON puc.idflownet = dt.idflownet AND pz.idrecdowntime = dt.idrec
	--puc.idrec = dt.idrecparent
	WHERE pu.costcenterida IS NOT NULL
	AND pz.durop < 1
	AND cast(pz.dttm as date) >= cast(pu.unitidc as date);