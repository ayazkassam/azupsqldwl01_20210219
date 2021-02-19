CREATE VIEW [stage_csx].[v_rpt_csx_latest_working_interest]
AS select wi.file_number
	, wi.uwi as uwi
	, wi.file_status
	, ltrim(rtrim(wd2.accounting_project)) as csx_cost_centre
	, wi.well_status
	, wd2.licence_number
	, wi.effective_date
	, case when wi.effective_date = wi.next_effective_date then null else wi.next_effective_date end AS termination_date
	, wi.expiry_date AS original_termination_date
	, wi.partner_id
	, cast(stuff(wi.partner_id, 1, patindex('%[0-9]%', wi.partner_id)-1, '') as int) as formatted_partner_id
	, coalesce(o.name,ba.name) as name
	, wi.partner_type
	, wi.doi_type
	, case when o.owner is not null and isnull(o.calculate_nets, 'n') = 'y' then 'y' else 'n' end as net_owner
	, wi.ownership_percent as csx_ownership_percent
	, sum (wi.ownership_percent) over (partition by wi.uwi, wi.effective_date) as csx_total_well_wrkng_intrst
	, row_number() over (partition by wi.uwi, wi.effective_date order by wi.ownership_percent desc, coalesce(o.name,ba.name) ) as pct_rnk  /*--rank partners by ownership weight, and name*/
from (
	select wd.file_number
		, wd.file_status
		, rtrim(ltrim(wd.well_uwi)) as uwi
		, xr.effective_date
		, xr.expiry_date
		, dd.partner as partner_id
		, dd.partner_type
		, xr.doi_type
		, wd.well_status
		, dd.partner_percent as ownership_percent
		, first_value(effective_date) over (partition by well_uwi order by effective_date desc) as next_effective_date
		, dense_rank() over (partition by well_uwi order by effective_date desc, expiry_date desc) as rnk
	from stage_csx_csland.d_xref xr
	join stage_csx_csland.w_detail1 wd on xr.file_number = wd.file_number
	join stage_csx_csland.d_detail dd on dd.doi_id = xr.doi_id
	where xr.subsystem     = 'W'
	AND xr.doi_type NOT IN ('APEN','APO','APO-2')
) wi
left outer join stage_csx_csland.ba_table ba on wi.partner_id = ba.primary_key 
left outer join stage_csx_csland.t_owners o on wi.partner_id = o.owner
left outer join stage_csx_csland.w_detail2 wd2 on wi.file_number = wd2.file_number
where rnk = 1 /*get current DOI Working Interest only*/
and wi.ownership_percent <> 0;