CREATE VIEW [stage].[v_prodview_typfluidprod]
AS SELECT DISTINCT CASE WHEN keymigrationsource IS NULL or keymigrationsource='' THEN compida ELSE keymigrationsource END keymigrationsource,
	compida,
	typfluidprod,
	dttm,
	ISNULL(LEAD(dttm, 1) OVER (PARTITION BY keymigrationsource, compida ORDER BY dttm) - 1, CAST ('12-31-9999' AS DATE)) ettm
FROM (
	SELECT DISTINCT puc.keymigrationsource,
		puc.compida,
		cs.typfluidprod,
		cs.dttm
	FROM stage_prodview.t_pvt_pvunitcomp puc
	, stage_prodview.t_pvt_pvunitcompstatus cs
	WHERE puc.idflownet = cs.idflownet AND puc.idrec = cs.idrecparent
	and puc.idflownet not in ('330B969210A04F1ABD132DD3F01C65B1','85DD56B8B4C7425FB03F788616D23D74')
) s;