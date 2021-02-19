CREATE VIEW [datamart_marketing].[v_ctrl_marketing_sales_points]
AS SELECT DISTINCT pd.idflownet, 
			    fh.name flownet_name, 
				pd.idrecdispunit sales_point_idrec,
				--pd.idrecunitcalc sales_point_idrec,
				case when fh.usertxt1 = 'SOLD'
				     then 'SOLD'
					 when fh.usertxt1 = 'EA'
					 then 'TBC'
					 else pv.name 
				end sales_point_name
				--pv.name sales_point_name,
				--fh.usertxt1

FROM stage_prodview.t_pvt_pvunitdispmonthday pd --  [pvt_pvunitallocmonthday] pd --[pvt_pvcalcsetdispday] pd
     --
     JOIN stage_prodview.t_pvt_pvunit pv
	 ON pv.idrec  = pd.idrecdispunit  -- pd.idrecunitcalc
	 --
	 JOIN  stage_prodview.t_pvt_pvflownetheader fh
	 ON  pv.idflownet = fh.idflownet          
	 --
	 JOIN stage_prodview.t_pvt_pvunitnode pun
	 ON pd.idrecdispunit = pun.idrecparent
	  
WHERE  upper(typdisp1) = 'SALE'                       ----upper(typdisp1) = 'SALE'
AND pv.name not in ('To Other Networks','To Other Network')

AND pv.name not in ('To Other Networks','To Other Network')
and fh.usertxt1 not in ('EA')
AND pd.idflownet in (SELECT DISTINCT flownet_id
			      FROM [datamart_marketing].[t_ctrl_marketing_etl_variables]
				  WHERE etl_type='MAIN SETUP')
--
UNION ALL
--
-- Mereged Network - Marketing Report
SELECT DISTINCT 
		flownet_id,
		flownet_name,
		parent_idrec sales_point_idrec,
		parent_name sales_point_name
FROM [datamart_marketing].[v_stg_prodview_all_flownet_hierarchy]
WHERE flownet_name = 'Marketing Report';