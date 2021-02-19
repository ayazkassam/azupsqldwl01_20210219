CREATE VIEW [stage_export].[v_ewf_wellbore_info] AS SELECT    CAST (uwi.wellbore AS VARCHAR (14)) wellbore,
          CAST (wd.well_name AS VARCHAR (50)) well_name,
          CAST (REPLACE (e.district_name, 'District: ','') AS VARCHAR (100)) district,
          CAST (REPLACE (e.area_name, 'Area: ','') AS VARCHAR (100)) area,
          CAST (REPLACE (e.facility_name, 'Facility: ','') AS VARCHAR (100)) facility,
          CAST (wd.license_no AS VARCHAR (50)) license_number,
          wd.license_date,
          CAST (wd.surf_location AS VARCHAR (50)) surface_location,
          CAST (wd.uwi AS VARCHAR (50)) bottom_hole_location,
          CAST (wd.licensee_desc AS VARCHAR (100)) current_licensee,
          CAST (NULL AS VARCHAR (100)) AS production_facility,
          CAST (
             CONCAT(iw2.confidential_type,  iw2.confidential_date) AS VARCHAR (50))
             AS confidential_indicator,
          CAST (wd.class_desc AS VARCHAR (100)) lahee,
		  current_uwi,
          CAST (SUBSTRING (uwi.current_uwi, LEN (uwi.current_uwi)-1, 2) AS VARCHAR (10)) AS current_event_sequence,
          wd.spud_date,
          wd.rig_release rig_release_date,
          iw2.current_status_date last_status_update_date,
          CAST (wd.field_desc AS VARCHAR (100)) FIELD,
          CAST (
             SUBSTRING (wd.LOCATION, 1, LEN (wd.LOCATION) - 2) AS VARCHAR (50)) formatted_wbid,
          CAST (
             SUBSTRING (wd.well_id, 1, LEN (wd.well_id) - 2) AS VARCHAR (50))   sorted_wbid,
          CAST (
             (CASE
                 WHEN px.ewf_primary_product IS NULL THEN 'OTHER'
                 ELSE px.ewf_primary_product
              END) AS VARCHAR (50)) primary_product,
          row_number() OVER(ORDER BY uwi.wellbore) row_id		
	FROM
			(SELECT *
				FROM [data_mart].t_dim_entity
				WHERE is_uwi=1
				) e
			INNER JOIN 
			(SELECT DISTINCT
                  SUBSTRING(iw.uwi, 1, 14) wellbore,
                  MAX (iw.uwi) OVER (PARTITION BY SUBSTRING (iw.uwi, 1, 14))
                     current_uwi
			 FROM
			    [stage].t_ihs_well iw
			     INNER JOIN
			    (SELECT *
				   FROM [data_mart].t_dim_entity
				   WHERE is_uwi=1
				 ) uwi
			    ON iw.uwi = uwi.entity_key
			 ) uwi
			ON e.entity_key = uwi.current_uwi
			INNER JOIN
			[stage].t_ihs_well_description wd
			ON uwi.current_uwi = wd.uwi
			INNER JOIN
			[stage].t_ihs_well iw2
			ON e.entity_key = iw2.uwi
			LEFT OUTER JOIN
			[stage].t_ihs_pden pd
			ON uwi.current_uwi = pd.pden_id
			LEFT OUTER JOIN
			[stage].t_ctrl_ewf_primary_product_xref px
			ON pd.primary_product = px.ihs_primary_product;