CREATE VIEW [STAGE_METRIX].[v_source_metrix_control_groups]
AS SELECT DISTINCT
	   cc_num,
	   --control_group,
	   --well_id,
	   --name,
	   CASE WHEN count(control_group) over (partition by cc_num) > 1
	        THEN first_value (control_group) over (partition by cc_num order by well_id)
			ELSE control_group
	   END control_group
FROM
(
SELECT DISTINCT 
                cg.id control_group,
				wm.cost_centre_code cc_num,
				wm.WELL_ID,
				wm.NAME
FROM [stage_metrix_METRIX].CONTROL_GROUPS cg
--
JOIN [stage_metrix_METRIX].CONTROL_GROUP_HIERARCHIES cgh
--
ON cg.id = cgh.control_group_id
AND cg.current_production_date = cgh.production_date
--
JOIN [stage_metrix_METRIX].FACILITIES f
--
ON cgh.facility_sys_id = f.sys_id
--
JOIN [stage_metrix_METRIX].BATTERY_FACILITIES bf
--
ON f.sys_id = bf.facility_sys_id
--
JOIN [stage_metrix_METRIX].WELL_MASTERS wm
--
ON bf.id = wm.battery_facility_id
AND wm.production_date = cg.current_production_date
--
WHERE wm.cost_centre_code not in ('999999','999998')
) sd;