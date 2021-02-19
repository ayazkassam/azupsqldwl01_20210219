CREATE VIEW [dbo].[v_dim_voucher_type]
AS SELECT cast(voucher_type_code as varchar(20)) as voucher_type_code,
	   cast(voucher_type_desc as varchar(500)) as voucher_type_desc,
	   cast(parent_id as varchar(20)) as parent_id

FROM(
SELECT 'Actual' voucher_type_code,
       'Actual' voucher_type_desc,
	   null parent_id
------	/* there would not be ACCRU vouchers to these accounts. */
----UNION ALL
------
----SELECT 'Accrual' voucher_type_code,
----       'Accrual' voucher_type_desc,
----	   null parent_id
--
UNION ALL
--
SELECT [VOUCHER_TYPE_CODE] voucher_type_code,
      [VOUCHER_TYPE_DESC] voucher_type_desc,
	  case when accrual_flag = 'N' then 'Actual' else 'Accrual' end parent_id
 FROM [stage].[t_qbyte_voucher_types]
 where [VOUCHER_TYPE_CODE] <> 'ACCRU'
) S;