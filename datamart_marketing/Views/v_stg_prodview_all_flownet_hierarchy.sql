CREATE VIEW [datamart_marketing].[v_stg_prodview_all_flownet_hierarchy] AS SELECT DISTINCT
		  pv.idflownet flownet_id,
          fh.name flownet_name,
          pv.idrec child_idrec,
          pv.name child_name,
		  pv.typ1,
		  pv.typ2,
          --pun.idrecparent,
          pv2.idrec parent_idrec,
          pv2.name parent_name,
          puc.compida uwi,
		  pv.costcenterida cc_num,
          COALESCE(puc.compida, pv.name) cube_child,
          pv2.name cube_parent,
		  punm.idrecmetereventtk,
		  puf.dttmstart,
		  --isnull(puf.dttmend, cast ('12-31-9999' as date)) dttmend,
		  isnull(isnull(puf.dttmend, pv.dttmend) ,cast ('12-31-9999' as date)) dttmend,
		  pv.dttmend pvunit_dttmend,
		  pun.name meter_type
     FROM stage_prodview.t_pvt_pvunit pv
	 INNER JOIN 
          stage_prodview.t_pvt_pvunitnode pun
	 ON  pv.idflownet = pun.idflownet
	 AND pv.idrec = pun.idrecparent 
     INNER JOIN
	     stage_prodview.t_pvt_pvunitnodeflowto puf
	 ON pv.idflownet = puf.idflownet
	 AND pun.idrec = puf.idrecparent  
     INNER JOIN 
	     stage_prodview.t_pvt_pvunitnode pun2
	 ON  pv.idflownet = pun2.idflownet
	 AND puf.idrecinlet = pun2.idrec
     ---in PV21 --> AND puf.idrecunitinlet = pun2.idrec            
     INNER JOIN
	     stage_prodview.t_pvt_pvunit pv2
     ON pv.idflownet = pv2.idflownet
     AND pun2.idrecparent = pv2.idrec  
     INNER JOIN
	    stage_prodview.t_PVT_PVFLOWNETHEADER fh
	 ON  pv.idflownet = fh.idflownet           
	LEFT OUTER JOIN
          stage_prodview.t_pvt_pvunitcomp puc
	 ON pv.idrec = puc.idrecparent
	LEFT OUTER JOIN
	       stage_prodview.t_pvt_pvunitnodemeterevent punm
	 ON  puf.idflownet = punm.idflownet
    AND   puf.idrecparent = punm.idrecparent
	WHERE pun.name not in ('Metered Condensate','Metered Water','Metered Oil','Metered Condensate V-100','Metered Condensate V-120','Metered Water V-120','Storm Fuel Gas')
	and isnull(puf.recircflow,0) = 0
	and pv.dttmend is NULL
	and pun.dttmend IS NULL
	and puf.dttmend IS NULL;