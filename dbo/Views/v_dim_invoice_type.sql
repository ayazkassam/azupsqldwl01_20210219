CREATE VIEW [dbo].[v_dim_invoice_type]
AS SELECT cast(invoice_type_code as varchar(20)) as invoice_type_code,
       cast(invoice_type_description as varchar(500)) as invoice_type_description,
	   cast(invoice_type_long_desc as varchar (550)) as invoice_type_long_desc,
	   cast(parent_id as varchar(20)) as parent_id,
	   cast(ctrl_major_acct as varchar(20)) ctrl_major_acct,
	   cast(ctrl_minor_acct as varchar(20)) ctrl_minor_acct,
	   cast (ctrl_major_acct + '_' + ctrl_minor_acct as varchar(50)) AS gl_account,
	   cast(sort_key as int) as sort_key
FROM
(
SELECT 'Receivable' invoice_type_code,
       'Receivable' invoice_type_description,
	   'Receivable' invoice_type_long_desc,
	   null parent_id,
	   null ctrl_major_acct,
	   null ctrl_minor_acct,
	   1 AS sort_key
--
UNION ALL
--
SELECT 'Payable' invoice_type_code,
       'Payable' invoice_type_description,
	   'Payable' invoice_type_long_desc,
	   null parent_id,
	   null ctrl_major_acct,
	   null ctrl_minor_acct,
	   2 AS sort_key
--
UNION ALL
--
SELECT DISTINCT 
		invc_type_code,
		invc_type_desc,
		invc_type_code + ' - ' + stage.InitCap (invc_type_desc) AS invoice_type_long_desc,
        CASE WHEN PAYABLE_OR_RECEIVABLE_CODE = 'R' THEN 'Receivable' ELSE 'Payable' END parent_id,
		ctrl_major_acct,
		ctrl_minor_acct,
		null as sort_key
  FROM [stage].[t_qbyte_invoice_types]

) s;