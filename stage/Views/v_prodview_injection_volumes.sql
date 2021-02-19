CREATE VIEW [stage].[v_prodview_injection_volumes]
AS SELECT keymigrationsource
	, compida
	, cc_num
	, completionname
	, typmigrationsource
	, typ1
	, typ2
	, dttm
	, SUM (injected_prod_water) injected_prod_water
	, SUM (injected_src_water) injected_src_water
	, SUM (prestub) injected_pressure_kpag
	, SUM (volinjectgas) injected_gas_c02
from (
	SELECT CASE WHEN ltrim(rtrim(pu.keymigrationsource)) IS NULL or ltrim(rtrim(pu.keymigrationsource))=''
			THEN puc.compida ELSE ltrim(rtrim(pu.keymigrationsource)) END keymigrationsource
		, puc.compida
		, pu.costcenterida cc_num
		, FIRST_VALUE (puc.completionname) OVER (PARTITION BY pu.keymigrationsource,puc.compida,pu.costcenterida
			ORDER BY ((case when pu.sysmoddate > puc.sysmoddate then pu.sysmoddate else puc.sysmoddate end)) desc) AS completionname
		, puc.typmigrationsource
		, pu.typ1
		, pu.typ2
		, pc.dttm
		, CASE WHEN typ2 IN ('Well (source)') THEN pc.volinjectwater ELSE NULL END injected_src_water
		, CASE WHEN typ2 IN ('Water Injection', 'Well (inj)') THEN pc.volinjectwater ELSE NULL END injected_prod_water
		, cast(comp.prestub as float) prestub
	--    ,cast(pucp.tubing_pressure as float) prestub
		, pc.volinjectgas
	from stage_prodview.t_pvt_pvunit pu
	join stage_prodview.t_pvt_pvunitcomp puc on pu.idflownet = puc.idflownet and pu.idrec = puc.idrecparent
	join stage_prodview.t_pvt_pvunitallocmonthday pc on pu.idflownet = pc.idflownet and puc.idrec = pc.idreccomp
	left outer join stage_prodview.t_pvt_pvflownetheader fh on pu.idflownet = fh.idflownet
	--left outer join t_stg_prodview_pressures_pivot pucp ON puc.idflownet = pucp.idflownet AND puc.idrec = pucp.idrecparent AND pc.dttm = pucp.dttm
	LEFT OUTER JOIN stage_prodview.t_pvt_pvunitcompparam comp
      ON pc.idrecparam = comp.idrec
       AND puc.idrec = comp.idrecparent
	where pu.typ2 IN ('Water Injection', 'Well (inj)', 'Well (source)')
	AND cast (pc.dttm as date) >= cast (pu.unitidc as date)
	--and pu.idflownet not in ('330B969210A04F1ABD132DD3F01C65B1','85DD56B8B4C7425FB03F788616D23D74')
) s
GROUP BY keymigrationsource, compida, cc_num, completionname, typmigrationsource, typ1, typ2, dttm;