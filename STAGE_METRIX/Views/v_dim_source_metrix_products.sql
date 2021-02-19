CREATE VIEW [STAGE_METRIX].[v_dim_source_metrix_products]
AS select code	as Product_Code
--	, CASE WHEN code = 'LITEMIX' THEN 'Ethane' else DESCRIPTION end as Product_Description
    , DESCRIPTION as Product_Description
	, SORT_ORDER as Product_Sort_Order
	, case	when DESCRIPTION like '%oil%' then 'Total Oil'
			when code in ('C2','C3','C4','C5','LPGNGL','COND','LITEMIX') then 'NGLs'
		else DESCRIPTION end as Product_Group
	, cast(case when DESCRIPTION like '%oil%' then '2'
			when code = 'gas' then '1'
			when code in ('C2','C3','C4','C5','LPGNGL','COND') then '3'
			when code = 'h20' then '4'
		else '5' end   +  cast(SORT_ORDER as varchar(5)) as int) as Product_Group_sort	 
from [STAGE_METRIX_METRIX].products
where ACTIVE_VALUE = 'Y'
and code in ('C2','C3','C4','C5','COND','GAS','LPGNGL','OIL','RAWGAS','SUL','h2o','LITEMIX');