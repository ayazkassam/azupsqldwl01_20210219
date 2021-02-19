CREATE VIEW [stage].[v_fact_source_ap_ar]
AS select 
     invc_type_code,
	 ba_id,
	 invc_id,
	 invc_num,
	 case when invoice_date between sd.start_date and ed.end_date
	      then invoice_date
		  else -1
	 end invoice_date,
	 org_id,
	 accounting_month,
	 case when due_date between sd.start_date and ed.end_date
	      then due_date
		  else -1
	 end due_date,
	 voucher_id,
	 voucher_type_code,
	 voucher_num,
	 li_type_code,
     cad,
	 invoice_amount
FROM
(
select 
    cast(i.invc_type_code as varchar(20)) invc_type_code,
    cast(i.client_id as int) ba_id,
	cast(i.invc_id as varchar(20)) invc_id,
	cast(i.invc_num as varchar(50)) invc_num,
	cast(convert(varchar(8), i.invc_date, 112) as int) AS invoice_date,
	cast (CASE WHEN l.dest_org_id IS NULL THEN v.org_id ELSE l.dest_org_id END as int) AS org_id,
	cast(convert(varchar(8), v.acct_per_date, 112) as int) AS accounting_month,
	cast(convert(varchar(8), i.due_date, 112) as int) AS due_date,
	cast(v.VOUCHER_ID as varchar(20)) voucher_id,
	cast(v.voucher_type_code as varchar(20)) voucher_type_code,
    cast(v.voucher_num as varchar(20)) as voucher_num,
	l.li_amt as cad,
	cast(l.li_type_code as varchar(10)) as li_type_code,
	i.invc_amt invoice_amount
from
	[stage].[t_qbyte_invoices] i,
	[stage].[t_qbyte_line_items] l,
	(select id
	 from [stage].[t_qbyte_business_associates]
	 group by id
	 ) b,
	[stage].[t_qbyte_vouchers] v
where 
    i.invc_id	= l.result_invc_id
and i.client_id = b.id
and l.voucher_id = v.voucher_id
and v.voucher_stat_code = 'P'
) src

CROSS JOIN
(		
			SELECT int_value start_date
			FROM [stage].t_ctrl_etl_variables
			WHERE variable_name='FINANCE_ACTIVITY_DATE_START'
		) sd
--
CROSS JOIN
	   (SELECT int_value end_date
		FROM [stage].t_ctrl_etl_variables
		WHERE variable_name='FINANCE_ACTIVITY_DATE_END') ed;