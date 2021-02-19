CREATE VIEW [stage].[v_prodview_shrink_yield_rates]
AS SELECT DISTINCT CASE WHEN ltrim(rtrim(puc.keymigrationsource)) IS NULL or ltrim(rtrim(puc.keymigrationsource))=''
					THEN puc.compida ELSE ltrim(rtrim(puc.keymigrationsource)) END keymigrationsource,
	puc.compida,
	ps.idflownet,
	ps.dttmstart,
	ps.dttmend,
	ps.gas_shrinkage,
	ps.c2_yield,
	ps.c3_yield,
	ps.c4_yield,
	ps.c5_yield,
	ps.condy_yield,
	isnull (ps.c2_yield, 0)
	+ isnull (ps.c3_yield, 0)
	+ isnull (ps.c4_yield, 0)
	+ isnull (ps.c5_yield, 0)
	+ isnull (ps.condy_yield, 0)
	total_yield_factor
FROM (  
	SELECT sd.idflownet,
		sd.idrecparent,
		dttmstart,
		dttmend,
		MAX (CASE WHEN sd.typ2 LIKE '%Gas Shrinkage (%)%' THEN sd.VALUE ELSE 0 END) AS gas_shrinkage,
		MAX (CASE WHEN sd.typ2 LIKE '%C2%' THEN sd.VALUE ELSE 0 END) AS c2_yield,
		MAX (CASE WHEN sd.typ2 LIKE '%C3%' THEN sd.VALUE ELSE 0 END) AS c3_yield,
		MAX (CASE WHEN sd.typ2 LIKE '%C4%' THEN sd.VALUE ELSE 0 END) AS c4_yield,
		MAX (CASE WHEN sd.typ2 LIKE '%C5%' THEN sd.VALUE ELSE 0 END) AS c5_yield,
		MAX (CASE WHEN sd.typ2 LIKE '%CONDY%' THEN sd.VALUE ELSE 0 END) AS condy_yield
	FROM (
		SELECT DISTINCT idflownet,
			idrecparent,
			dttmstart,
			CASE WHEN LEAD (dttmstart,1) OVER (PARTITION BY idflownet, idrecparent, typ2 ORDER BY dttmstart) IS NULL
				THEN isnull (dttmend,cast ('12-31-9999' as date)) 
				ELSE isnull (LEAD (dttmstart,1) OVER (PARTITION BY idflownet,idrecparent,typ2 ORDER BY dttmstart)- 1, cast ('12-31-9999' as date)) END dttmend,
			typ2,
			cast (REPLACE (VALUE, '..', '.') as float) VALUE
		FROM stage_prodview.t_pvt_pvunitothertag
		WHERE typ1 = 'CUBE REPORTING'
		AND isnumeric(isnull(ltrim(rtrim(value)),1)) = 1
		--and idflownet not in ('330B969210A04F1ABD132DD3F01C65B1','85DD56B8B4C7425FB03F788616D23D74')						 
	) sd
	GROUP BY sd.idflownet, sd.idrecparent, dttmstart, dttmend
) ps
, stage_prodview.t_pvt_pvunitcomp puc
WHERE ps.idrecparent = puc.idrecparent;