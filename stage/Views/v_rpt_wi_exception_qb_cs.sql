CREATE VIEW [stage].[v_rpt_wi_exception_qb_cs]
AS select t2.*
	, ent.cc_type_code
	, ent.cost_centre_name
	, ent.district_code
	, ent.op_nonop
	, cs.file_number
	, cs.file_status
	, cs.well_status
	, case 
			/*Exception when one system is missing*/
			when qbyte_total_wi is null and csx__total_wi is not null then 'Missing Qbyte WI'
			when csx__total_wi is null and qbyte_total_wi is not null then 'Missing CSX WI'
			/*exception when two systems are missing*/
			when qbyte_total_wi is null and csx__total_wi is null then 'Missing Qbyte and CSX WI'
			when Num_Mismatches <> 0 then 'Partner Mismatch'
		 end as ExceptionType
from (
	select uwi
		, cost_centre
		, partner_id
		, partner_name
		, qbyte_working_interest
		, csx_working_interest
		, sum(Mismatch_Counter) over (partition by uwi, cost_centre) as Num_Mismatches
		, sum(qbyte_working_interest) over (partition by uwi, cost_centre) as qbyte_total_wi
		, sum(csx_working_interest) over (partition by uwi, cost_centre) as csx__total_wi
	from (
		select distinct uwi
			, cost_centre
			, partner_id
			, max(partner_name) as partner_name
			, sum(qbyte_working_interest) as qbyte_working_interest
			, sum(csx_working_interest) as csx_working_interest
			, case when sum(qbyte_working_interest) = sum(csx_working_interest) then 0 else 1 end as Mismatch_Counter
		from (
			select coalesce(q.uwi, c.uwi) as uwi
				, coalesce(q.cost_centre, c.cost_centre) as cost_centre
				, coalesce(q.partner_id, c.partner_id) as partner_id
				, coalesce(q.partner_name, c.partner_name) as partner_name
				, q.qbyte_working_interest
				, c.csx_working_interest
			from (
				/*distinct list of working interest from Qbyte*/
				select uwi
					, cc_num as cost_centre
					, partner_ba_id as partner_id
					, ba_name as partner_name
					, round(sum(QB_DOI),6) as qbyte_working_interest
				from stage.v_rpt_qb_latest_working_interest
				group by uwi, cc_num, partner_ba_id, ba_name
			) q
			full outer join (
				/*distinct list of working interest from CSExplorer*/
				SELECT uwi
					, csx_cost_centre as cost_centre
					, partner_id
					, name as partner_name
					, round(sum(csx_ownership_percent),6) as csx_working_interest
				FROM stage.t_rpt_csx_latest_working_interest
				GROUP BY uwi, csx_cost_centre, partner_id, name
			) c on q.uwi = c.uwi
				and q.cost_centre = c.cost_centre
				and q.partner_id = c.partner_id
		) sq
		where uwi is not null
		group by uwi, cost_centre, partner_id
	) t1
) t2
left outer join data_mart.t_dim_entity ent on t2.cost_centre = ent.entity_key and ent.is_cc_dim = 1

left outer join (
	select distinct uwi
		, ltrim(rtrim(file_status)) file_status
		, ltrim(rtrim(file_number)) file_number
		, ltrim(rtrim(well_status)) well_status
	from stage.t_rpt_csx_latest_working_interest 
) cs on t2.uwi = cs.uwi

where ent.cc_type_code not in ('PUD','SLD','POT','PLT','BTY','GGS','UNT','NFC','FEE','LOC','ACQ','ARE','OPL','COM','NWI')
and Num_Mismatches > 0;