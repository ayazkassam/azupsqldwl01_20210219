CREATE VIEW [stage].[v_qbyte_cc_hierarchy]
AS SELECT CAST(rep_ent.corp AS VARCHAR(50)) corp,
	CAST('Bonavista Corporate Hierarchy' AS VARCHAR(1000)) corp_name,
	CAST(rep_ent.region AS VARCHAR(50)) region,
	CAST(rep_ent.region_name AS VARCHAR(1000)) region_name,
	CAST(rep_ent.region_code AS VARCHAR(100)) region_code,
	CAST(rep_ent.district AS VARCHAR(50)) district,
	CAST(rep_ent.district_name AS VARCHAR(1000)) district_name,
	CAST(rep_ent.district_code AS VARCHAR(100)) district_code,
	CAST(rep_ent.area AS VARCHAR(50)) area,
	CAST(rep_ent.area_name AS VARCHAR(1000)) area_name,
	CAST(rep_ent.area_code AS VARCHAR(100)) area_code,
	CAST(rep_ent.facility AS VARCHAR(50)) facility,
	CAST(rep_ent.facility_name AS VARCHAR(1000)) facility_name,
	CAST(rep_ent.facility_code AS VARCHAR(100)) facility_code,
	CAST(rep_ent.cc_num AS VARCHAR(50)) cost_centre_id,
	CAST(rep_ent.cc_name AS VARCHAR(1000)) cost_centre_name,
	CAST(cc.unit_cc_num AS VARCHAR(50)) as unit_cc_num,
	CAST(CASE WHEN cc.cc_name IS NULL THEN 'Unknown Unit Name' ELSE stage.initcap(cc2.cc_name) END AS VARCHAR(1000)) unit_cc_name,
	ccw.working_interest working_interest_pct,
	CAST(CASE WHEN cc.cc_num IS NULL THEN 'Operated' WHEN ba_org.ref_org_id IS NULL THEN 'NonOp' ELSE 'Operated' END AS VARCHAR(10)) op_nonop,
	CAST(CASE WHEN ISNULL(udf15.description,cc.cc_udf_15_code) IS NULL THEN 'Unknown Budget Group' ELSE ISNULL(udf15.description,cc.cc_udf_15_code) END AS VARCHAR(200)) budget_group, 
	CAST(CASE WHEN cc.cc_udf_13_code IS NULL THEN 'No Budget Year' WHEN UPPER(LTRIM(RTRIM(cc.cc_udf_13_code))) = 'BASE' THEN 'PRIOR' ELSE cc.cc_udf_13_code END AS VARCHAR(10)) budget_year,
	CAST(CASE WHEN UPPER(LTRIM(RTRIM(cc.cc_udf_13_code))) = cast(year(CURRENT_TIMESTAMP) as varchar(4)) THEN 'Incremental' ELSE 'Base' END AS VARCHAR(50)) budget_year_group,
	CAST(CASE WHEN udf14.code IS NULL THEN 'Unknown Origin' ELSE udf14.description END AS VARCHAR(100)) origin,
	CAST(CASE udf14.code 
			WHEN 'ACQU' THEN 'Total Acquisitions'
			WHEN 'DISP' THEN 'Total Acquisitions'
			ELSE 'Total Exp Dev Program' END AS VARCHAR(100)) origin_group,             
	CAST(CASE WHEN cc.cc_udf_19_code IS NULL THEN 'UNKNOWN ACQUIRED FROM' ELSE cc.cc_udf_19_code END AS VARCHAR(100)) acquired_from,
	CAST(CASE WHEN bdh.disposed IS NULL THEN 'Unknown Disposed' ELSE bdh.disposed END AS VARCHAR(20)) disposed_flag,
	CAST(CASE WHEN cc.primary_prod_code IS NULL THEN 'Unknown Primary Product' ELSE cc.primary_prod_code END AS VARCHAR(50)) primary_product,
	CAST(cc.cc_type_desc AS VARCHAR(50)) cc_type,
	CAST(cc.cc_type_code AS VARCHAR(50)) cc_type_code,
	CAST(cc.province AS VARCHAR(50)) province,
	CAST(CASE WHEN cc.create_date IS NULL THEN NULL ELSE CONCAT (DATEPART(year,cc.create_date),'-',RIGHT(CONCAT('0', DATEPART(mm,cc.create_date)),2),'-',RIGHT(CONCAT('0', DATEPART(dd,cc.create_date)),2))  END AS VARCHAR(50)) create_date,
	CAST(CASE WHEN cc.cc_udf_1_code IS NULL THEN 'Unknown CGU' ELSE cc.cc_udf_1_code END AS VARCHAR(100)) cgu, 
	CAST(CASE WHEN udf7.description IS NULL THEN 'Unknown Current Reserve Property' ELSE udf7.description END AS VARCHAR(200)) current_reserves_property,
	CAST(CASE WHEN ye_res.year_end_reserves_property IS NULL THEN null ELSE ye_res.year_end_reserves_property END AS VARCHAR(200)) year_end_reserves_property, 
	CAST(CASE WHEN fa.focus_area_flag IS NULL THEN 'Unknown Focus Area Flag' ELSE fa.focus_area_flag END AS VARCHAR(10)) focus_area_flag, 
	CAST(CASE WHEN bdh.disp_pkg IS NULL THEN 'Unknown Disp Package' ELSE bdh.disp_pkg END AS VARCHAR(200)) disposition_package,
	CAST(CASE WHEN bdh.disp_type IS NULL THEN 'Unknown Disp Type' ELSE bdh.disp_type END AS VARCHAR(200)) disposition_type,
	CAST(CASE WHEN bdh.disp_area IS NULL THEN 'Unknown Disp Area' ELSE bdh.disp_area END AS VARCHAR(200)) disposition_area,
	CAST(CASE WHEN bdh.disp_facility IS NULL THEN 'Unknown Disp Facility' ELSE bdh.disp_facility END AS VARCHAR(200)) disposition_facility,
	CAST(try_convert(date,ihs.spud_date) AS VARCHAR(50)) spud_date,
	CAST(try_convert(date,ihs.rig_release_date) AS VARCHAR(50)) rig_release_date,
	cast(try_convert(date,os.on_prod_date) as varchar(50)) on_production_date,
	CAST(try_convert(Date,ihs.on_production_date) AS VARCHAR(50)) on_prod_date_accumap,
	CAST(try_convert(date,ihs.last_production_date) AS VARCHAR(50)) last_production_date,
	
	cast(ihs.license_no as varchar(50)) license_no,
	CAST(cc.survey_system_code AS VARCHAR(50)) survey_system_code,
	CAST(cc.uwi AS VARCHAR(50)) uwi,
	CAST(cc.uwi_desc AS VARCHAR(100)) uwi_desc,
	CAST(cc.meridian AS VARCHAR(50)) meridian,
	CAST(cc.range AS VARCHAR(50)) range ,
	CAST(cc.township AS VARCHAR(50)) township,
	CAST(cc.section AS VARCHAR(50)) section,
	CAST(CASE WHEN cc.cc_udf_17_code IS NULL THEN 'Unknown Tax Pool' ELSE cc.cc_udf_17_code END AS VARCHAR(100)) tax_pools,
	CAST(CASE WHEN cc.term_date IS NULL THEN NULL ELSE CONCAT (DATEPART(year,cc.term_date),'-',RIGHT(CONCAT('0', DATEPART(mm,cc.term_date)),2),'-',RIGHT(CONCAT('0', DATEPART(dd,cc.term_date)),2)) END AS VARCHAR(50)) cc_term_date, 
	CAST('QBYTE' AS VARCHAR(50)) entity_source,
	zp.zone_play,
	CAST (CASE WHEN cc.cc_udf_4_code IS NULL THEN 'Unknown GCA FCC' ELSE cc.cc_udf_4_code END AS VARCHAR(100)) gca_fcc,
	CAST(mcg.control_group AS VARCHAR(50)) metrix_control_group,
	CAST(vby.valnav_budget_year AS VARCHAR(100)) valnav_budget_year,
	CAST(vby.valnav_budget_quarter AS VARCHAR(100)) valnav_budget_quarter,
	sd.sales_disposition_point,
	os.Data_Source as on_prod_data_source,
	cc.CC_UDF_2_CODE as qbyte_license,
	cc.CC_UDF_6_CODE as surface_location,
	cc.CC_UDF_16_CODE as Sask_Resource_Surcharge
	, CAST(vms.Meter_Station AS VARCHAR(100)) Meter_Station
	, cast(caw.group1 as varchar(100)) group1
	, cast(caw.group2 as varchar(100)) group2
	, cast(caw.group3 as varchar(100)) group3
	, cast(caw.group4 as varchar(100)) group4
	, cast(caw.group5 as varchar(100)) group5
	, cast(caw.group6 as varchar(100)) group6
	, cast(caw.group7 as varchar(100)) group7
	, cast(caw.group8 as varchar(100)) group8
	, cast(caw.group9 as varchar(100)) group9
	, cast(caw.group10 as varchar(100)) group10
	, vpl.plant
	, vki.keyera_inlet
FROM (
	SELECT a.hierarchy_code AS corp,
		a.hierarchy_code AS corp_name,
		a.reporting_level_code + '_' + a.reporting_entity_code AS region,
		a.reporting_entity_code as region_code,
		CASE WHEN a.reporting_entity_desc IS NULL THEN NULL ELSE 'Region: ' + stage.initcap(LTRIM(RTRIM(REPLACE(a.reporting_entity_desc,char(9), ' ')))) END AS region_name,
		b.reporting_level_code + '_' + b.reporting_entity_code AS district,
		b.reporting_entity_code as district_code,
		CASE WHEN b.reporting_entity_code IS NULL THEN NULL ELSE  'District: ' + b.reporting_entity_code END  AS district_name,
		c.reporting_level_code + '_' + c.reporting_entity_code AS area, 
		c.reporting_entity_code area_code,
		c.reporting_entity_code qbyte_area,
		CASE WHEN c.reporting_entity_desc IS NULL THEN NULL ELSE 'Area: ' + stage.initcap(LTRIM(RTRIM(REPLACE(c.reporting_entity_desc,char(9), ' ')))) END AS area_name,
		d.reporting_level_code + '_' + d.reporting_entity_code  AS facility,
		d.reporting_entity_code as facility_code,
		CASE WHEN  d.reporting_entity_desc IS NULL THEN NULL ELSE  'Facility: ' + stage.initcap(LTRIM (RTRIM(REPLACE (d.reporting_entity_desc,char(9), ' ')))) END as facility_name,
		CASE WHEN e.reporting_entity_code IS NULL THEN NULL ELSE LTRIM(RTRIM(REPLACE(UPPER (e.reporting_entity_code), '***DUMMY**', 'DUMMY CC'))) END cc_num,
		CASE WHEN e.reporting_entity_desc IS NULL THEN NULL ELSE stage.initcap(LTRIM(RTRIM(REPLACE(REPLACE(e.reporting_entity_desc, char (9),' '), '***Dummy**', 'Dummy') + ' (' + e.reporting_entity_code + ')'))) END cc_name
	FROM [Stage].[t_qbyte_reporting_entities] a,
	[Stage].[t_qbyte_reporting_entities] b,
	[Stage].[t_qbyte_reporting_entities] c
	LEFT OUTER JOIN  [Stage].[t_qbyte_reporting_entities] d ON (c.reporting_level_code = d.parent_reporting_level_code AND c.reporting_entity_code = d.parent_reporting_entity_code)
	LEFT OUTER JOIN [Stage].[t_qbyte_reporting_entities] e ON (d.reporting_level_code = e.parent_reporting_level_code AND d.reporting_entity_code = e.parent_reporting_entity_code) 
	WHERE a.parent_reporting_entity_code = 'CORP'
	AND a.hierarchy_code = 'CORP HIER'
	AND a.reporting_level_code = b.parent_reporting_level_code
	AND a.reporting_entity_code = b.parent_reporting_entity_code
	AND b.hierarchy_code = a.hierarchy_code
	AND b.reporting_level_code = c.parent_reporting_level_code
	AND b.reporting_entity_code = c.parent_reporting_entity_code
	AND c.hierarchy_code = a.hierarchy_code
	AND d.hierarchy_code = a.hierarchy_code
	AND e.hierarchy_code = a.hierarchy_code
) rep_ent
LEFT OUTER JOIN [Stage].[v_qbyte_cost_centres_attributes] cc ON rep_ent.cc_num = cc.cc_num
LEFT OUTER JOIN [Stage].[t_qbyte_cost_centres] cc2 ON cc.UNIT_CC_NUM = cc2.cc_num
LEFT OUTER JOIN (
		select DISTINCT cc_num,
			FIRST_VALUE (working_interest) OVER (PARTITION BY cc_num order by effective_date desc) working_interest
		from stage.t_cc_num_working_interest
) ccw ON rep_ent.cc_num = ccw.cc_num
LEFT OUTER JOIN (
		SELECT x1.ID, x1.ref_org_id
		FROM [Stage].[t_qbyte_business_associates] x1,
		[Stage].[t_qbyte_organizations] y1
		WHERE x1.ref_org_id = y1.org_id
) ba_org ON cc.operator_client_id = ba_org.id
LEFT OUTER JOIN (
	/*--Budget Group*/
	SELECT DISTINCT code, stage.initcap(LTRIM(RTRIM(description))) description
	FROM [Stage].[t_qbyte_udf_codes]
	WHERE udf_type_code IN ('CC_UDF_15_CODE', 'AFE_UDF_15_CODE')
) udf15 ON cc.cc_udf_15_code = udf15.code
LEFT OUTER JOIN (
	/*-- Origin*/
	SELECT DISTINCT UPPER(LTRIM(RTRIM(code))) code,
		stage.initcap(LTRIM(RTRIM(description))) description
	FROM [Stage].[t_qbyte_udf_codes]
	WHERE udf_type_code IN ('CC_UDF_14_CODE', 'AFE_UDF_14_CODE')
) udf14 ON cc.cc_udf_14_code = udf14.code
LEFT OUTER JOIN [Stage].t_qbyte_cc_bnp_divest_hierarchy bdh ON rep_ent.cc_num = bdh.cc_num
LEFT OUTER JOIN ( 
/*-- Current Reserve Property*/
	SELECT DISTINCT code, description
	FROM [Stage].[t_qbyte_udf_codes]
	WHERE udf_type_code = 'CC_UDF_7_CODE'
) udf7 ON cc.cc_udf_7_code = udf7.code
LEFT OUTER JOIN [stage].[t_stg_focus_area] fa ON rep_ent.qbyte_area = fa.area
----------------------------------------------------
LEFT OUTER JOIN  (
	SELECT DISTINCT ccu.cc_num,
		MAX(ihs.spud_date) OVER (PARTITION BY ccu.cc_num) spud_date,
		MAX(ihs.rig_release) OVER (PARTITION BY ccu.cc_num) rig_release_date,
		MAX(ihs.on_production_date) OVER (PARTITION BY ccu.cc_num) on_production_date,
		MAX(ihs.last_production_date) OVER (PARTITION BY ccu.cc_num) last_production_date,
		MAX(ihs.license_no) OVER (PARTITION BY ccu.cc_num) license_no
	FROM [Stage].[t_cc_uwi_master_source] ccu
	LEFT OUTER JOIN [Stage].[t_ihs_attributes] ihs ON ccu.uwi = ihs.uwi
) ihs ON rep_ent.cc_num = ihs.cc_num
LEFT OUTER JOIN (
		select distinct ccu.cc_num
			, max(pd.on_prod_date) OVER (PARTITION BY ccu.cc_num) on_prod_date
			, max(pd.data_source) OVER (PARTITION BY ccu.cc_num) data_source
		from [Stage].[t_cc_uwi_master_source] ccu
		join stage.v_stg_on_prod_dates pd on ccu.uwi = pd.uwi
) os ON rep_ent.cc_num = os.cc_num
LEFT OUTER JOIN (
	/*-- Year End Reserves*/
	select  distinct cost_centre,
		FIRST_VALUE(year_end_reserves_property) OVER (PARTITION BY cost_centre order by cost_centre) year_end_reserves_property
	from [data_mart].t_dim_entity
	where is_valnav=1
	and year_end_reserves_property is not null 
	and cost_centre is not null
) ye_res ON rep_ent.cc_num = ye_res.cost_centre
left outer join (
	/*ensure zone play is pulling the correct entity is being used based on UWI*/
	select distinct cost_centre
		, FIRST_VALUE(zone_play) OVER (PARTITION BY cost_centre order by cost_centre) zone_play
	from [stage].[t_valnav_dim_hierarchy_source] v
	where exists (	select 1 
					from data_mart.t_dim_entity e 
					where e.is_uwi = 1
					and v.entity_name = e.uwi)
	and cost_centre is not null
) zp on rep_ent.cc_num = zp.cost_centre
LEFT OUTER JOIN [stage_metrix].v_source_metrix_control_groups mcg ON rep_ent.cc_num = mcg.cc_num
LEFT OUTER JOIN (
	select  distinct cost_centre,
		FIRST_VALUE(valnav_budget_year) OVER (PARTITION BY cost_centre order by valnav_budget_year desc) valnav_budget_year,
		FIRST_VALUE(valnav_budget_quarter) OVER (PARTITION BY cost_centre order by valnav_budget_year desc) valnav_budget_quarter
	from [data_mart].t_dim_entity
	where is_valnav=1
	and coalesce(valnav_budget_year, valnav_budget_quarter) is not null
	and cost_centre is not null
) vby ON rep_ent.cc_num = vby.cost_centre
left outer join (
	select distinct cost_centre
		, first_value(sales_disposition_point) over (partition by cost_centre order by sales_disposition_point) as sales_disposition_point
	from data_mart.t_dim_entity
	where (is_uwi = 1 or is_cc_dim = 1)
	and sales_disposition_point is not null
) sd on rep_ent.cc_num  = sd.cost_centre
left outer join 
    (SELECT DISTINCT code cc_num, 
			       -- first value used as safety guard in case of duplicates
	               first_value(group1) over (partition by code order by group1) group1,
				   first_value(group2) over (partition by code order by group2) group2,
				   first_value(group3) over (partition by code order by group3) group3,
				   first_value(group4) over (partition by code order by group4) group4,
				   first_value(group5) over (partition by code order by group5) group5,
				   first_value(group6) over (partition by code order by group6) group6,
				   first_value(group7) over (partition by code order by group7) group7,
				   first_value(group8) over (partition by code order by group8) group8,
				   first_value(group9) over (partition by code order by group9) group9,
				   first_value(group10) over (partition by code order by group10) group10
	FROM [stage_mds].[t_mds_bcd_cost_centre_custom_groupings]) caw on rep_ent.cc_num = caw.cc_num
LEFT OUTER JOIN (
	select  distinct cost_centre,
		FIRST_VALUE(Meter_Station) OVER (PARTITION BY cost_centre order by meter_station desc) Meter_Station
	from [data_mart].t_dim_entity
	where is_valnav=1
	and Meter_Station is not null
	and cost_centre is not null
) vms ON rep_ent.cc_num = vms.cost_centre
LEFT OUTER JOIN (
	select  distinct cost_centre,
		FIRST_VALUE(plant) OVER (PARTITION BY cost_centre order by plant desc) plant
	from [data_mart].t_dim_entity
	where is_valnav=1
	and plant is not null
	and cost_centre is not null
) vpl ON rep_ent.cc_num = vpl.cost_centre
LEFT OUTER JOIN (
	select  distinct cost_centre,
		FIRST_VALUE(keyera_inlet) OVER (PARTITION BY cost_centre order by keyera_inlet desc) keyera_inlet
	from [data_mart].t_dim_entity
	where is_valnav=1
	and keyera_inlet is not null
	and cost_centre is not null
) vki ON rep_ent.cc_num = vki.cost_centre;