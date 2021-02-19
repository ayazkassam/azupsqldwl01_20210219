CREATE VIEW [datamart_marketing].[v_ctrl_marketing_sales_points_ALL]
AS SELECT DISTINCT pd.idflownet, 
			    fh.name flownet_name, 
				pd.idrecdispunit sales_point_idrec,
				--pd.idrecunitcalc sales_point_idrec,
				case when fh.usertxt1 = 'SOLD'
				     then 'SOLD'
					 when fh.usertxt1 = 'EA'
					 then 'TBC'
					 else pv.name 
				end sales_point_name,
				--pv.name sales_point_name,
				fh.usertxt1

FROM stage_prodview.t_pvt_pvunitdispmonthday pd --  [pvt_pvunitallocmonthday] pd --[pvt_pvcalcsetdispday] pd
     --
     JOIN stage_prodview.[t_pvt_pvunit] pv
	 ON pv.idrec  = pd.idrecdispunit  -- pd.idrecunitcalc
	 --
	 JOIN  stage_prodview.t_PVT_PVFLOWNETHEADER fh
	 ON  pv.idflownet = fh.idflownet          
	 --
	 JOIN stage_prodview.[t_pvt_pvunitnode] pun
	 ON pd.idrecdispunit = pun.idrecparent
	  
WHERE  upper(typdisp1) = 'SALE'                       ----upper(typdisp1) = 'SALE'
AND pv.name not in ('To Other Networks','To Other Network')

AND pv.name not in ('To Other Networks','To Other Network')
and fh.usertxt1 not in ('EA')
and fh.idflownet not in ('330B969210A04F1ABD132DD3F01C65B1','85DD56B8B4C7425FB03F788616D23D74');