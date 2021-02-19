CREATE VIEW [stage].[v_prodview_joints_to_fluid]
AS SELECT DISTINCT
       CASE WHEN ltrim(rtrim(puc.keymigrationsource)) IS NULL or ltrim(rtrim(puc.keymigrationsource))=''
	        THEN puc.compida
	        ELSE ltrim(rtrim(puc.keymigrationsource))
	   END keymigrationsource,
       compida,
       pu.costcenterida cc_num,
       completionname,
	   fl.dttm,
	   fl.dttm calc_dttm_start,
	   CASE WHEN LEAD (fl.dttm, 1) over (partition by fl.idflownet, fl.idrecparent order by dttm) IS NULL
	        THEN dttm
			ELSE LEAD (fl.dttm, 1) over (partition by fl.idflownet, fl.idrecparent order by dttm) -1
	   END calc_dttm_end,
	   fl.jointsinhole joints_to_fluid
FROM 
				 [stage_prodview].[t_pvt_pvunit] pu,
                 [stage_prodview].[t_pvt_pvunitcomp] puc,
                 [stage_prodview].[t_pvt_pvunitcompfluidlevel] fl
	 
WHERE     pu.idflownet = puc.idflownet
      AND pu.idrec = puc.idrecparent
      AND puc.idflownet = fl.idflownet
      AND puc.idrec = fl.idrecparent;