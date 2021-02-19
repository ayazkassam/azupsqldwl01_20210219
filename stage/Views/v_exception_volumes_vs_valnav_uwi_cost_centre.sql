CREATE VIEW [stage].[v_exception_volumes_vs_valnav_uwi_cost_centre]
AS SELECT  DISTINCT xc.entity_key, entity_name, volumes_cost_centre, volumes_cost_centre_name, valnav_cost_centre, valnav_cost_centre_name, ums.data_source volumes_uwi_source
FROM
( -- xc
SELECT vol.entity_key, vol.entity_name, vol.cost_centre volumes_cost_centre, vol.cost_centre_name volumes_cost_centre_name, vnav.cost_centre valnav_cost_centre, vnav.cost_centre_name valnav_cost_centre_name
FROM
(
SELECT distinct entity_key, entity_name, cost_centre, cost_centre_name
from [data_mart].t_dim_entity
where is_uwi='1' 
and cost_centre is not null
) vol
--
JOIN 
(
SELECT distinct entity_name, cost_centre, cost_centre_name
from [data_mart].t_dim_entity
where is_valnav='1' 
and cost_centre is not null
) vnav
ON vol.entity_key = vnav.entity_name
) xc
--
JOIN
[stage].[t_fact_source_fdc_valnav_volumes_daily] vd
ON xc.entity_key = vd.entity_key
--
LEFT OUTER JOIN 
[stage].[t_cc_uwi_master_source] ums
ON xc.entity_key = ums.uwi
WHERE volumes_cost_centre <> valnav_cost_centre;