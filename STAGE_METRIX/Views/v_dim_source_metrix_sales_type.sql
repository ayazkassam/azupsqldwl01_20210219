CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_sales_type]
AS select 'Operated' as Op_Non_Op 
	, code as Sales_Type_Code
	, DESCRIPTION as Sales_Type
	, SORT_ORDER as Sales_Type_Sort_Key
	, 1 as is_sales
	, 0 as is_royalty
from [STAGE_METRIX_METRIX].[PARTICIPANT_TYPES]
where ACTIVE_VALUE = 'Y'
union all
select distinct 'Partner Operated' as Op_Non_Op	
	, TRANSACTION_TYPE as code
	, case TRANSACTION_TYPE 
			when 'TYPE1' then 'Sales'	/* excluded */
			when 'TYPE2' then 'Crown Royalty'
			when 'TYPE3' then 'Freehold Royalty'
			when 'TYPE4' then 'Override Royalty'
			when 'TYPE5' then 'Production'
			when 'TYPE6' then 'Wellhead Data'
	end as Transaction_Type
	, right(TRANSACTION_TYPE,1) as Sales_Type_Sort_Key
	, 1 as is_sales
	, 0 as is_royalty
from [STAGE_METRIX].[t_stg_metirx_parnter_op_battery_txns]--[STAGE_METRIX_METRIX].[PARTNER_OP_BATTERY_TXNS]
where TRANSACTION_TYPE <> 'TYPE1'
union all
select distinct 'Royalty' as Op_Non_Op 
	, OBLIGATION_TYPE as code
	, case OBLIGATION_TYPE 
			when 'CRWN' then 'Crown'
			when 'FRHD' then 'Freehold'
			when 'INDIAN' then 'Indian'
			when 'ORR' then 'Override'
		end as Obligation_Type
	, case OBLIGATION_TYPE 
			when 'CRWN' then 1
			when 'FRHD' then 2
			when 'INDIAN' then 3
			when 'ORR' then 4
		end as Sales_Type_Sort_Key
	, 0 as is_sales
	, 1 as is_royalty
from [STAGE_METRIX].[t_stg_metrix_royalty_splits];