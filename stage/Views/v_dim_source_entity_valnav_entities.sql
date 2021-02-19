CREATE VIEW [stage].[v_dim_source_entity_valnav_entities]
AS SELECT distinct
                   entity_key,

                   FIRST_VALUE (entity_name) OVER (PARTITION BY entity_key ORDER BY source_db_sort_key) AS entity_name,

                   -- If cost_centre is null for Base Decline - get the cc num from Budget for same UWI
                   -- If the cc num (budget one) is null or more than 1 uwi then inherit cc num from same uwi for Base Decline
                   -- else just the one associated with guid

                  CASE WHEN cost_centre IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (cost_centre) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (cost_centre) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (cost_centre) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS cost_centre,

                  CASE WHEN cost_centre_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (cost_centre_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (cost_centre_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (cost_centre_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS cost_centre_name,

 	         CASE WHEN corp IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (corp) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (corp) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (corp) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS corp,

				   'Bonavista Corporate Hierarchy' corp_name,

		CASE WHEN region IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (region) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (region) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (region) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS region,

                   CASE WHEN region_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (region_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (region_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (region_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS region_name,

			  CASE WHEN region_code IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (region_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (region_code) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (region_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS region_code,
		CASE WHEN district IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (district) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (district) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (district) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS district,
                   CASE WHEN district_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (district_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (district_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (district_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS district_name,
			 CASE WHEN district_code IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (district_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (district_code) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (district_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS district_code,
		 CASE WHEN area IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (area) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (area) OVER (PARTITION BY uwi  ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (area) OVER (PARTITION BY entity_key   ORDER BY  source_db_sort_key) 
                            END
                   END AS area,
                    CASE WHEN area_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (area_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (area_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (area_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS area_name,
				 CASE WHEN area_code IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (area_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (area_code) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (area_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS area_code,
		 CASE WHEN facility IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (facility) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (facility) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (facility) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS facility,
                   CASE WHEN facility_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (facility_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (facility_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (facility_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS facility_name,
				    CASE WHEN facility_code IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (facility_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (facility_code) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (facility_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS facility_code,
		CASE WHEN cc_type IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (cc_type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE(cc_type) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE(cc_type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
        END AS cc_type,
		CASE WHEN budget_group IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (budget_group) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (budget_group) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (budget_group) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
        END AS budget_group,
		CASE WHEN budget_year IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (budget_year) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (budget_year) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (budget_year) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
        END AS budget_year,
		CASE WHEN op_nonop IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (op_nonop) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (op_nonop) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (op_nonop) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS op_nonop,
		CASE WHEN origin IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (origin) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (origin) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (origin) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS origin,
		CASE WHEN province IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (province) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (province) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (province) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS province,
		CASE WHEN create_date IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (create_date ) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (create_date ) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (create_date ) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS create_date,
		CASE WHEN spud_date IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (spud_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (spud_date ) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (spud_date ) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS spud_date,
		CASE WHEN rig_release_date IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (rig_release_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (rig_release_date) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (rig_release_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS rig_release_date,
		CASE WHEN on_production_date IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (on_production_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (on_production_date) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (on_production_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                END AS on_production_date,
		CASE WHEN last_production_date IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (last_production_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (last_production_date) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (last_production_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                END AS last_production_date,
		CASE WHEN acquired_from IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (acquired_from) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (acquired_from) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (acquired_from) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                END AS acquired_from,		
        CASE WHEN current_reserves_property IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (current_reserves_property) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (current_reserves_property) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (current_reserves_property) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS current_reserves_property,         
		 CASE WHEN disposition_package IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (disposition_package) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (disposition_package) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (disposition_package) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS disposition_package,
		 CASE WHEN disposition_type IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (disposition_package) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (disposition_type) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (disposition_type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS disposition_type,
		 CASE WHEN disposition_area IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (disposition_area) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (disposition_area) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (disposition_area) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS disposition_area,
		 CASE WHEN disposition_facility IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (disposition_facility) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (disposition_facility) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (disposition_facility) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS disposition_facility,
		CASE WHEN disposed_flag IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (disposed_flag) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (disposed_flag) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (disposed_flag) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
        END AS disposed_flag,
	CASE WHEN focus_area_flag IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (focus_area_flag) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (focus_area_flag) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (focus_area_flag) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
         END AS focus_area_flag,
         CASE WHEN primary_product IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (primary_product) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (primary_product) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (primary_product) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS primary_product,
                  CASE WHEN cgu IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (cgu) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (cgu) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (cgu) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS cgu,
                   CASE WHEN working_interest IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (working_interest) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (working_interest) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (working_interest) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS working_interest,
                   CASE WHEN year_end_reserves_property IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (year_end_reserves_property) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (year_end_reserves_property) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (year_end_reserves_property) OVER (PARTITION BY entity_key order by source_db_sort_key)
                            END
                   END AS year_end_reserves_property,
				   CASE WHEN unit_cc_num IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (unit_cc_num) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (unit_cc_num) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (unit_cc_num) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS unit_cc_num,
                CASE WHEN unit_cc_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (unit_cc_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (unit_cc_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (unit_cc_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS unit_cc_name,
                CASE WHEN survey_system_code IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (survey_system_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (survey_system_code) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (survey_system_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS survey_system_code,
		   	FIRST_VALUE (uwi) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) AS uwi,  
		        FIRST_VALUE (uwi_desc) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) AS uwi_desc,  
			CASE WHEN meridian IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (meridian) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (meridian) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (meridian) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS meridian,
		   CASE WHEN range IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (range) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (range) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (range) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS range,
			CASE WHEN township IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (township) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (township) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (township) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS township,
			CASE WHEN section IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (section) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (section) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (section) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS section,
			CASE WHEN tax_pools IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (tax_pools) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (tax_pools) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (tax_pools) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS tax_pools,
			CASE WHEN strat_unit_id IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (strat_unit_id) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (strat_unit_id) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (strat_unit_id) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS strat_unit_id,
			CASE WHEN crstatus_desc IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (crstatus_desc) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (crstatus_desc) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (crstatus_desc) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS crstatus_desc,
			CASE WHEN license_no IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (license_no) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (license_no) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (license_no) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS license_no,		    
			CASE WHEN surf_location IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (surf_location) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (surf_location) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (surf_location) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS surf_location,		
			CASE WHEN tvd_depth IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (tvd_depth) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (tvd_depth) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (tvd_depth) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS tvd_depth,	
			CASE WHEN total_depth IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (total_depth) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (total_depth) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (total_depth) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS total_depth,	
			CASE WHEN zone_desc IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (zone_desc) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (zone_desc) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (zone_desc) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS zone_desc,	
			CASE WHEN deviation_flag IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (deviation_flag) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (deviation_flag) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (deviation_flag) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)

                       END
                   END AS deviation_flag,	
			FIRST_VALUE (formatted_uwi) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) AS formatted_uwi,  
			CASE WHEN bottom_hole_latitude IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (bottom_hole_latitude) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (bottom_hole_latitude) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)

                               ELSE FIRST_VALUE (bottom_hole_latitude) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS bottom_hole_latitude,
				   CASE WHEN bottom_hole_longitude IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (bottom_hole_longitude) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (bottom_hole_longitude) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (bottom_hole_longitude) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS bottom_hole_longitude,
			CASE WHEN surface_latitude IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (surface_latitude) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (surface_latitude) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (surface_latitude) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS surface_latitude,
			CASE WHEN surface_longitude IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (surface_longitude) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (surface_longitude) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (surface_longitude) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS surface_longitude,
			CASE WHEN gas_shrinkage_factor IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (gas_shrinkage_factor) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (gas_shrinkage_factor) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (gas_shrinkage_factor) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS gas_shrinkage_factor,
			CASE WHEN ngl_yield_factor IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (ngl_yield_factor) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (ngl_yield_factor) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (ngl_yield_factor) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS ngl_yield_factor,
			CASE WHEN pvunit_completion_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (pvunit_completion_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (pvunit_completion_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (pvunit_completion_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS pvunit_completion_name,
			CASE WHEN pvunit_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (pvunit_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (pvunit_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (pvunit_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS pvunit_name,
			CASE WHEN pvunit_short_name IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (pvunit_short_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (pvunit_short_name) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (pvunit_short_name) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS pvunit_short_name,
		FIRST_VALUE (entity_source) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) entity_source,
		0 is_cc_dim,
			CASE WHEN cc_term_date IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (cc_term_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (cc_term_date) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (cc_term_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS cc_term_date,
  			CASE WHEN chance_of_success IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (chance_of_success) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (chance_of_success) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (chance_of_success) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS chance_of_success,
                  CASE WHEN budget_quarter IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (budget_quarter) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (budget_quarter) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (budget_quarter) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS budget_quarter,
			CASE WHEN capital_group IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (capital_group) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (capital_group) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (capital_group) OVER (PARTITION BY entity_key  ORDER BY  source_db_sort_key)
                            END
                   END AS capital_group,
				   CASE WHEN capital_type IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (capital_type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (capital_type) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (capital_type) OVER (PARTITION BY entity_key  ORDER BY  source_db_sort_key)
                            END
                   END AS capital_type,
                  CASE WHEN de_risk IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (de_risk) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (de_risk) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (de_risk) OVER (PARTITION BY entity_key  ORDER BY  source_db_sort_key)
                            END
                   END AS de_risk,               
  			CASE WHEN depth_gci IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (depth_gci) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (depth_gci) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (depth_gci) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS depth_gci,
                  CASE WHEN drill_days IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (drill_days) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (drill_days) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (drill_days) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS drill_days,
			CASE WHEN nra IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (nra) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (nra) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (nra) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS nra,
            CAST(
			 CASE WHEN reserve_realized_date IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (reserve_realized_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (reserve_realized_date) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (reserve_realized_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END 
			  AS VARCHAR(50)) AS reserve_realized_date,
			CASE WHEN royalty_income_interest IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (royalty_income_interest) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (royalty_income_interest) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (royalty_income_interest) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS royalty_income_interest,
			CASE WHEN well_direction IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (well_direction) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (well_direction) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (well_direction) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS well_direction,	
                   CASE WHEN zone_play IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (zone_play) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (zone_play) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (zone_play) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS zone_play,
				   CASE WHEN budget_year_group IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (budget_year_group) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (budget_year_group) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (budget_year_group) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS budget_year_group,
				   CASE WHEN origin_group IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (origin_group) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (origin_group) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (origin_group) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS origin_group,
				   CASE WHEN valnav_budget_year IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (valnav_budget_year) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (valnav_budget_year) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (valnav_budget_year) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS valnav_budget_year,
				   CASE WHEN cc_type_code IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (cc_type_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (cc_type_code) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key) 
                               ELSE FIRST_VALUE (cc_type_code) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key) 
                            END
                   END AS cc_type_code,
				   CASE WHEN cc_num_working_interest_pct IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (cc_num_working_interest_pct) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (cc_num_working_interest_pct) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (cc_num_working_interest_pct) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS cc_num_working_interest_pct,
				   CASE WHEN lateral_length IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (lateral_length) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (lateral_length) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (lateral_length) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS lateral_length,
				    CASE WHEN segment_start_date IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (segment_start_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (segment_start_date) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (segment_start_date) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS segment_start_date,
				    CASE WHEN type_curve_kpi IS NULL AND source_db = 'BASE DECLINE'
                       THEN FIRST_VALUE (type_curve_kpi) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                       ELSE -- budget
                            CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                               -- If more than 1 uwi then use the uwi based
                               THEN FIRST_VALUE (type_curve_kpi) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                               ELSE FIRST_VALUE (type_curve_kpi) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                            END
                   END AS type_curve_kpi,
		   1 is_valnav,
		CASE WHEN completion_type IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (completion_type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (completion_type) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (completion_type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS completion_type,
		CASE WHEN total_proppant_placed IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (total_proppant_placed) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (total_proppant_placed) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (total_proppant_placed) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS total_proppant_placed,
		CASE WHEN c_star IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (c_star) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (c_star) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (c_star) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS c_star,
		CASE WHEN Production_Category IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (Production_Category) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (Production_Category) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (Production_Category) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS Production_Category,
		CASE WHEN Incentive_Type IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (Incentive_Type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (Incentive_Type) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (Incentive_Type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS Incentive_Type,
		CASE WHEN Meter_Station IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (Meter_Station) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (Meter_Station) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (Meter_Station) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS Meter_Station, 
		CASE WHEN royalty_type IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (royalty_type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (royalty_type) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (royalty_type) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS royalty_type,
		CASE WHEN first_prod_month IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (first_prod_month) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (first_prod_month) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (first_prod_month) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS first_prod_month,

		CASE WHEN group1 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group1) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group1) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group1) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group1,

		CASE WHEN group2 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group2) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group2) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group2) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group2,

		CASE WHEN group3 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group3) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group3) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group3) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group3,

		CASE WHEN group4 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group4) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group4) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group4) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group4,

		CASE WHEN group5 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group5) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group5) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group5) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group5,

		CASE WHEN group6 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group6) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group6) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group6) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group6,

		CASE WHEN group7 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group7) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group7) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group7) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group7,

		CASE WHEN group8 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group8) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group8) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group8) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group8,

		CASE WHEN group9 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group9) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group9) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group9) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group9,

		CASE WHEN group10 IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (group10) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (group10) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (group10) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS group10,

		--completion_month
		CASE WHEN completion_month IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (completion_month) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (completion_month) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (completion_month) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS completion_month,

		--Plant
		CASE WHEN Plant IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (Plant) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (Plant) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (Plant) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS Plant,

		--Keyera inlet
		CASE WHEN keyera_inlet IS NULL AND source_db = 'BASE DECLINE'
            THEN FIRST_VALUE (keyera_inlet) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
            ELSE -- budget
                CASE WHEN COUNT (entity_key) OVER (PARTITION BY uwi) > 1
                    -- If more than 1 uwi then use the uwi based
                    THEN FIRST_VALUE (keyera_inlet) OVER (PARTITION BY uwi ORDER BY  source_db_sort_key)
                    ELSE FIRST_VALUE (keyera_inlet) OVER (PARTITION BY entity_key ORDER BY  source_db_sort_key)
                END
        END AS keyera_inlet		
		
FROM [stage].[t_valnav_dim_hierarchy_source]
WHERE UWI IS NOT NULL;