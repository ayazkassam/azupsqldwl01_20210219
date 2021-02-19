CREATE VIEW [stage].[v_ihs_attributes]
AS SELECT wd.uwi,
	wd.crstatus_desc,
	wd.license_no,
	wd.surf_location,
	wd.tvd_depth,
	wd.total_depth,
	wd.zone_desc,
	wd.spud_date,
	rig_release,
	pd.on_production_date,
	CASE UPPER (RTRIM(LTRIM (deviation_flag)))
			WHEN 'V' THEN 'Vertical'
			WHEN 'H' THEN 'Horizontal'
			WHEN 'D' THEN 'Directional'
		ELSE deviation_flag END deviation_flag,
	pd.strat_unit_id,
	pd.primary_product,
	wd.province_state,
	wd.location,
	[Stage].[InitCap](wd.well_name) well_name,
	bll.latitude bottom_hole_latitude,
	bll.longitude bottom_hole_longitude,
	ISNULL(sll.latitude, bll.latitude) surface_latitude,
	ISNULL(sll.longitude, bll.longitude) surface_longitude,
	pd.last_production_date,
	wd.licensee_desc current_licensee,
	wl.original_licensee AS original_licensee,
	wd.operator_desc AS operator,
	ws.petra_mode as mode
FROM [Stage].[t_ihs_well_description] wd
LEFT OUTER JOIN  [Stage].[t_ihs_pden] pd ON  wd.uwi = pd.pden_id
LEFT OUTER JOIN (
		SELECT DISTINCT uwi
			, FIRST_VALUE (longitude) OVER (PARTITION BY uwi ORDER BY row_changed_date DESC) longitude
			, FIRST_VALUE (latitude) OVER (PARTITION BY uwi ORDER BY row_changed_date DESC) latitude
		FROM [Stage].[t_ihs_well_node]
		WHERE node_position = 'S'
) sll ON wd.uwi = sll.uwi
LEFT OUTER JOIN (
		SELECT DISTINCT uwi,
			FIRST_VALUE (longitude) OVER (PARTITION BY uwi ORDER BY row_changed_date DESC) longitude,
			FIRST_VALUE (latitude) OVER (PARTITION BY uwi ORDER BY row_changed_date DESC) latitude
		FROM [Stage].[t_ihs_well_node]
		WHERE node_position = 'B'
) bll ON wd.uwi = bll.uwi
LEFT OUTER JOIN
 (
 SELECT 
					       wl.expiry_date,
			               wl.expired_ind,
			        	   orig_lic_ba.ba_name AS original_licensee,
						   wl.uwi,
			        	   wl.license_num
			        	   --wl_stat.license_status
			          FROM stage.t_ihs_well_license wl
			        
			          LEFT OUTER JOIN
			        
                          ( -- get name of Original Licensee
		                 
		                    SELECT BUSINESS_ASSOCIATE,
		                           BA_NAME
		                      FROM stage.t_ihs_business_associate
			        		    
		                 )orig_lic_ba
			        
                       ON wl.X_ORIGINAL_LICENSEE = orig_lic_ba.BUSINESS_ASSOCIATE      
			        
			          --LEFT OUTER JOIN
			        
			          --    (  -- get license status
			        	 --   SELECT *
			        		--  FROM stage.t_ihs_well_license_status
			        	 -- )wl_stat
			          --ON wl_stat.LICENSE_ID = wl.LICENSE_ID
			) wl
	ON wd.uwi = wl.uwi
	--
	LEFT OUTER JOIN 
                          ( SELECT [status],
                		           long_name,
                				   status_group,
								   petra_mode
                		      FROM stage.t_ihs_r_well_status r_ws
							 LEFT OUTER JOIN
							      (
								    SELECT source_code,
									       petra_mode 
									  FROM stage.t_ihs_xref_status
								  ) x_ws
							  ON r_ws.status = x_ws.SOURCE_CODE
                		  ) ws
     ON wd.crstatus = ws.[status];