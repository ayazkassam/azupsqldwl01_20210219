CREATE VIEW [stage_csx].[v_rpt_csx_well_insurance_election]
AS select distinct w.*
	, cx.Contract_File_Number
	, ie.INSURANCE as Insurance_Election
from (
	select distinct wd1.FILE_NUMBER
		, wd1.FILE_STATUS
		, wd1.WELL_UWI
		, wd1.WELL_STATUS
		, wd1.SORTED_UWI
		, wd2.LICENCE_NUMBER
	from stage_csx_csland.[W_DETAIL1] wd1
	left outer join stage_csx_csland.w_detail2 wd2 on wd1.file_number = wd2.file_number
	where FILE_STATUS not in ('SOLD', 'SOLD1','INACTIVE')
) w
join (
		/*contracts well xref*/
		select FILE_NUMBER as Contract_File_Number
			, REL_FILE_NUMBER as Well_File_Number
		from stage_csx_csland.[X_REFERENCE]
		where SUBSYSTEM = 'C'
		and REL_SUBSYSTEM = 'W'
) cx on w.FILE_NUMBER = cx.Well_File_Number
left outer join (
		/*insurance election*/
		select FILE_NUMBER
			, INSURANCE
		from stage_csx_csland.C_OPER_CAPL81

		union all

		select FILE_NUMBER
			, INSURANCE
		from stage_csx_csland.C_OPER_CAPL90
) ie on cx.Contract_File_Number = ie.FILE_NUMBER;