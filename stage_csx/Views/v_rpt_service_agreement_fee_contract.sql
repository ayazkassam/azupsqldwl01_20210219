CREATE VIEW [stage_csx].[v_rpt_service_agreement_fee_contract]
AS SELECT 
	   sf.file_number service_file_number,
       cb.file_status service_file_status,

	   case when xf.rel_file_number like 'JF%' 
	        then xf.rel_file_number
			else null
	   end facility_file_number,
	   case when xf.rel_file_number like 'JF%'
		then xf.rel_file_sub 
		else null
	   end facility_file_sub,
	   case when xf.rel_file_number like 'JF%'
	   then xf.file_status 
	   else null
	   end facility_file_status,

	   cb.contract_date,
	   --cb.producer,
	   ba_prod.short_name producer,
	   ba_proc.short_name processor,
	   cb.contract_name,
	   cs.division,
	   --cs.area,
	   area.name area,

	   ta.description admin_company,
	   --cb.effective_date,
	   --

	   sl.prod_uwi location,
	   sl.prod_project project_number,

	   sl.PROD_DESCRIPTION project_description,

	   sf.proc_uwi processor_location,
	   sf.proc_project processor_project,
	   sf.proc_description,
	   
	   sf.service_type,
	   sf.variable_fee,
	   sf.fee_capital capital_fee,
	   sf.fee_operating operating_fee,
	   sf.fee_capital + sf.fee_operating total_fees,
	   sf.fee_basis,
	   sf.fee_effect_date fee_effective_date,
	   sf.termination_date,
	   sf.service_term_date
	   --
	  
	   

FROM stage_csx_csland.C_SERVICE_FEES   sf
--
LEFT OUTER JOIN stage_csx_csland.C_SERVICE_LOC sl
ON sf.file_number = sl.file_number
AND sf.loc_occurrence = sl.loc_occurrence
--

LEFT OUTER JOIN stage_csx_csland.C_BASE cb
ON sf.file_number = cb.file_number
--

LEFT OUTER JOIN stage_csx_csland.C_SUB cs
ON sf.file_number = cs.file_number
--

LEFT OUTER JOIN stage_csx_csland.T_AREA area
ON cs.area = area.code
--

LEFT OUTER JOIN stage_csx_csland.BA_TABLE ba_prod
ON cb.producer = ba_prod.primary_key
--
LEFT OUTER JOIN stage_csx_csland.BA_TABLE ba_proc
ON cb.processor = ba_proc.primary_key
--

LEFT OUTER JOIN stage_csx_csland.T_ADMIN ta
ON cb.admin_company = ta.code
--



LEFT OUTER JOIN 

 (SELECT xf.*, cb2.file_status
  FROM  stage_csx_csland.X_REFERENCE xf
  LEFT OUTER JOIN stage_csx_csland.C_BASE cb2
   ON xf.rel_file_number = cb2.file_number
    --WHERE cb2.termination_date is not null or UPPER(cb2.file_status) <> 'TERMINATED'
   ) xf
ON sf.file_number = xf.file_number
--



--


--WHERE sf.termination_date is null



WHERE sf.hist_occurrence=0;