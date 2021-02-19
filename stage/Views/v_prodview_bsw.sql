CREATE VIEW [stage].[v_prodview_bsw]
AS SELECT DISTINCT
       CASE WHEN ltrim(rtrim(puc.keymigrationsource)) IS NULL or ltrim(rtrim(puc.keymigrationsource))=''
	        THEN puc.compida
	        ELSE ltrim(rtrim(puc.keymigrationsource))
	   END keymigrationsource,
       compida,
       pu.costcenterida cc_num,
       completionname,
	   cwc.dttmstart,
	   cwc.dttmstart calc_dttm_start,
	   CASE WHEN LEAD (cwc.dttmstart, 1) over (partition by cwc.idflownet, cwc.idrecparent order by cwc.dttmstart) IS NULL
	        THEN cwc.dttmstart
			ELSE LEAD (cwc.dttmstart, 1) over (partition by cwc.idflownet, cwc.idrecparent order by cwc.dttmstart) -1
	   END calc_dttm_end,
	   cwc.bsw
FROM 
				 stage_prodview.[t_pvt_pvunit] pu,
                 stage_prodview.[t_pvt_pvunitcomp] puc,
                 stage_prodview.[t_pvt_pvunitcompwhcut] cwc
	 
WHERE     pu.idflownet = puc.idflownet
      AND pu.idrec = puc.idrecparent
      AND puc.idflownet = cwc.idflownet
      AND puc.idrec = cwc.idrecparent
and pu.idflownet not in ('330B969210A04F1ABD132DD3F01C65B1','85DD56B8B4C7425FB03F788616D23D74');