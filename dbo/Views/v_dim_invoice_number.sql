CREATE VIEW [dbo].[v_dim_invoice_number]
AS SELECT DISTINCT cast(invoice_number as varchar(20)) as invoice_number,
		cast(invoice_description as varchar(100)) as invoice_description,
		cast(payment_status_code as varchar(10)) payment_status_code,
		cast(payment_status_desc as varchar(100)) payment_status_desc,
		cast(hold_date as date) hold_date,
		cast(INVC_ID as varchar(20)) invoice_id
	FROM (
		SELECT distinct invc_num invoice_number,
			invc_num invoice_description,
			pay_stat_code payment_status_code,
			pay_desc.code_desc payment_status_desc,
			hold_date
			, inv.INVC_ID
		FROM [stage].[t_qbyte_invoices] inv
		LEFT OUTER JOIN (
						SELECT *
						FROM [stage].[t_qbyte_codes]
						WHERE CODE_TYPE_CODE='PAY_STAT_CODE'
		) pay_desc ON inv.pay_stat_code = pay_desc.code

	) S;