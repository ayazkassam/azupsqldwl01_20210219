CREATE VIEW [dbo].[v_dim_voucher_number]
AS SELECT DISTINCT cast ([VOUCHER_NUM] as varchar(20)) voucher_num
      , cast([SRC_CODE] as varchar(20)) src_code
	  , cast(convert(varchar(8), [CREATE_DATE], 112) as int) AS create_date
	  , cast(VOUCHER_ID as varchar(20)) as voucher_id
  FROM [stage].[t_qbyte_vouchers];