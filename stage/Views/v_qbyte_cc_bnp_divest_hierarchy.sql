CREATE VIEW [stage].[v_qbyte_cc_bnp_divest_hierarchy]
AS SELECT b.hierarchy_code,
       [stage].initcap(a.reporting_entity_desc) disp_type,
       --'Disp Pkg: ' + 
	   [stage].initcap(b.reporting_entity_desc) disp_pkg,
       --'Disp Area: '
	    + [stage].initcap(c.reporting_entity_desc) disp_area,
       --'Disp Facility: ' +
	   [stage].initcap(d.reporting_entity_desc) disp_facility,
       e.reporting_entity_code AS cc_num,
       CASE
          WHEN UPPER (b.parent_reporting_entity_code) LIKE '%POT%' THEN 'N'
          ELSE 'Y'
       END   disposed
  FROM [Stage].[t_qbyte_reporting_entities] a,
       [Stage].[t_qbyte_reporting_entities] b,
       [Stage].[t_qbyte_reporting_entities] c
	   LEFT OUTER JOIN [Stage].[t_qbyte_reporting_entities] d
	   ON (c.reporting_level_code = d.parent_reporting_level_code
	       AND c.reporting_entity_code = d.parent_reporting_entity_code
		  )
       LEFT OUTER JOIN  [Stage].[t_qbyte_reporting_entities] e
	   ON (d.reporting_level_code = e.parent_reporting_level_code
	       AND d.reporting_entity_code = e.parent_reporting_entity_code
		  )
 WHERE     a.parent_reporting_level_code = 'CORP'
       AND a.hierarchy_code = 'BNP DIVEST'
       AND a.reporting_level_code = b.parent_reporting_level_code
       AND a.reporting_entity_code = b.parent_reporting_entity_code
       AND b.hierarchy_code = a.hierarchy_code
       AND b.reporting_level_code = c.parent_reporting_level_code
       AND b.reporting_entity_code = c.parent_reporting_entity_code
       AND c.hierarchy_code = a.hierarchy_code
       AND d.hierarchy_code = a.hierarchy_code
       AND e.hierarchy_code = a.hierarchy_code;