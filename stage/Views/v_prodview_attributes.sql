CREATE VIEW [stage].[v_prodview_attributes] AS SELECT pv.uwi
	, pv.pvunit_cost_centre
	, pv.pvunit_license_num
	, pv.pvunit_completion_name
	, pv.pvunit_name
	, pvunit_short_name
	, sy.gas_shrinkage_factor
	, sy.ngl_yield_factor
	, ISNULL (pv.routename, 'No Run Specified - ' + ISNULL (pv.flownet_name, 'Unknown Network')) AS routename
	, ISNULL (pv.flownet_name, 'Unknown Network') AS flownet_name
	, sdp.sales_disposition_point
	, pv.engineering_on_prod_date
	, pv.engineering_inline_test_date
	, pv.schematic_typical
FROM (
	SELECT DISTINCT LTRIM(RTRIM(puc.compida)) AS uwi
		, FIRST_VALUE (COALESCE (pu.unitidpa, pu.costcenterida)) 
				OVER (PARTITION BY puc.compida ORDER BY CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate ELSE ISNULL (puc.sysmoddate, pu.sysmoddate) END DESC, pu.sortbyuser DESC, puc.completionname ) AS pvunit_cost_centre
		, FIRST_VALUE (pu.unitida) 
				OVER (PARTITION BY puc.compida ORDER BY CASE  WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate ELSE ISNULL (puc.sysmoddate, pu.sysmoddate) END DESC, pu.sortbyuser DESC, puc.completionname ) AS pvunit_license_num
		, FIRST_VALUE (puc.completionname) 
				OVER (PARTITION BY puc.compida ORDER BY CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate ELSE ISNULL (puc.sysmoddate, pu.sysmoddate) END DESC, pu.sortbyuser DESC, puc.completionname) AS pvunit_completion_name
		, FIRST_VALUE (pu.name) 
				OVER (PARTITION BY puc.compida ORDER BY CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate ELSE ISNULL (puc.sysmoddate, pu.sysmoddate) END DESC, pu.sortbyuser DESC, puc.completionname ) AS pvunit_name
		, FIRST_VALUE (pu.nameshort) 
				OVER (PARTITION BY puc.compida ORDER BY CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate ELSE ISNULL (puc.sysmoddate, pu.sysmoddate) END DESC, pu.sortbyuser DESC, puc.completionname ) AS pvunit_short_name
		, FIRST_VALUE (prn.name) 
				OVER (PARTITION BY puc.compida ORDER BY pr.dttmstart DESC) AS routename
		, FIRST_VALUE (fh.name) 
				OVER (PARTITION BY puc.compida ORDER BY pr.dttmstart DESC) AS flownet_name
		, FIRST_VALUE(puc.compidc) OVER (PARTITION BY puc.compida 
			ORDER BY (CASE	WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate
							WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate ELSE ISNULL(puc.sysmoddate , pu.sysmoddate) END) DESC
						, pu.sortbyuser DESC, puc.completionname) AS engineering_on_prod_date
		, FIRST_VALUE(puc.compidd) OVER (PARTITION BY puc.compida 
			ORDER BY (CASE	WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate
							WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate ELSE ISNULL(puc.sysmoddate , pu.sysmoddate) END) DESC
						, pu.sortbyuser DESC, puc.completionname) AS engineering_inline_test_date
		, FIRST_VALUE (pu.costcenteridb) 
				OVER (PARTITION BY puc.compida ORDER BY CASE WHEN pu.sysmoddate > puc.sysmoddate THEN pu.sysmoddate WHEN puc.sysmoddate > pu.sysmoddate THEN puc.sysmoddate ELSE ISNULL (puc.sysmoddate, pu.sysmoddate) END DESC, pu.sortbyuser DESC, puc.completionname ) AS schematic_typical
	FROM stage_prodview.t_pvt_pvunit pu
	JOIN stage_prodview.t_pvt_pvunitcomp puc ON pu.idflownet = puc.idflownet AND pu.idrec = puc.idrecparent
	LEFT outer JOIN stage_prodview.t_pvt_pvroutesetroute prn ON pu.idrecroutesetroutecalc = prn.idrec
	LEFT outer JOIN stage_prodview.t_pvt_pvrouteset pr ON prn.idrecparent = pr.idrec 
	LEFT outer JOIN stage_prodview.t_pvt_pvflownetheader fh ON pu.idflownet = fh.idflownet
	WHERE LTRIM (RTRIM (puc.compida)) <> '100000000000W000'
	and pu.idflownet not in ('330B969210A04F1ABD132DD3F01C65B1','85DD56B8B4C7425FB03F788616D23D74')
) pv
LEFT JOIN (
		/*- shrink and yield from Prodview*/
		SELECT DISTINCT compida AS uwi
			, FIRST_VALUE (gas_shrinkage) OVER (PARTITION BY compida ORDER BY dttmend DESC) AS gas_shrinkage_factor
			, FIRST_VALUE (total_yield_factor) OVER (PARTITION BY compida ORDER BY dttmend DESC) AS ngl_yield_factor
		FROM stage.v_prodview_shrink_yield_rates
) sy ON pv.uwi = sy.uwi
LEFT OUTER JOIN [datamart_marketing].t_prodview_sales_disposition_points sdp ON pv.uwi = sdp.uwi;