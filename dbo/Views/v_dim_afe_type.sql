CREATE VIEW [dbo].[v_dim_afe_type]
AS SELECT a.parent_reporting_entity_code AS parent_afe_type,
	CAST(a.reporting_entity_code AS VARCHAR(50)) afe_type,
	[stage].[InitCap](a.reporting_entity_desc) + ' AFE Types' afe_type_desc,                  
	CAST([stage].[TRIM] (a.reporting_level_code) AS VARCHAR(100))AS reporting_level_code,
	NULL AS afe_type_group
FROM [stage].[t_qbyte_reporting_entities] a 
WHERE a.parent_reporting_level_code IS NULL
AND a.hierarchy_code = 'AFETYPE'

union all 

select null
	, 'Unknown'
	, 'Unknown'
	, 'ROLLUP'
	, null

--
UNION ALL
--
SELECT b.parent_reporting_entity_code AS parent_afe_type,
	CAST(b.reporting_entity_code AS VARCHAR(50)) afe_type,
	[stage].[InitCap](b.reporting_entity_desc) afe_type_desc,
	CAST([stage].[TRIM](b.reporting_level_code) AS VARCHAR(100)) AS reporting_level_code,
	b.parent_reporting_entity_code AS afe_type_group
FROM [stage].[t_qbyte_reporting_entities] b
WHERE b.parent_reporting_level_code = 'ROLLUP'
AND b.hierarchy_code = 'AFETYPE'

union all

select 'Unknown'
	, '-2'
	, 'Unknown'
	, 'OTH'
	, 'Unknown'

union all

select 'Unknown'
	, 'AFE Type Not Applicable'
	, 'Unknown'
	, 'OTH'
	, 'Unknown';