CREATE VIEW [stage].[v_mds_source_bcd_cc_custom_groupings]
AS SELECT CAST(cost_centre_id AS NVARCHAR(50)) AS cost_centre_id,
		CAST(cost_centre_name AS NVARCHAR(250)) AS cost_centre_name,
		CAST(cc_type_code AS NVARCHAR(50)) AS cc_type_code,
		--cc_term_date,
		group1,
		group2,
		group3,
		group4,
		group5,
		group6,
		group7,
		group8,
		group9,
		group10,
		ImportType
FROM
(
 SELECT cost_centre_id,
		cost_centre_name,
		cc_type_code,
		--cc_term_date,
		group1,
		group2,
		group3,
		group4,
		group5,
		group6,
		group7,
		group8,
		group9,
		group10,
		0 AS ImportType /* add */
  FROM [stage].[t_cost_centre_hierarchy] cc

  --WHERE cc_term_date IS NULL /* Not terminated */
  --AND cc_type_code NOT IN ('SLD')

  --
  UNION 
  --
  SELECT code,
		name,
		[cost centre type],
		--cc_term_date,
		group1,
		group2,
		group3,
		group4,
		group5,
		group6,
		group7,
		group8,
		group9,
		group10,
		6 AS ImportType /* permanently delete if not part of this list */
  FROM [stage_mds].t_mds_bcd_cost_centre_custom_groupings mds

  --WHERE (cc_term_date IS NOT NULL /* terminated */
  --         OR cc_type_code IN ('SLD') )
  WHERE NOT EXISTS
           (SELECT 1
		    FROM [stage].[t_cost_centre_hierarchy] cc
			--[stage_mds].dbo.t_mds_bcd_cost_centre_custom_groupings cg
			WHERE  mds.code = cc.cost_centre_id
			)
  
  ) s;