CREATE VIEW [stage].[v_qbyte_afe_cc_list] AS with cte as (
	select cc.afe_num
		, cc_num
		, last_update_date
		, last_update_user
		, create_date
	from stage.t_qbyte_afes_cost_centres cc
	join (
		select afe_num, count(*) rows
		from stage.t_qbyte_afes_cost_centres
		group by afe_num
		--having count(*) <= 3
	) f on cc.afe_num = f.afe_num
)

select distinct c2.AFE_NUM
	, c1.cc_list
	, c2.Number_of_CCs
from (
	select afe_num,  
		--, stuff((select ',' + cc_num
		--		from cte ee
		--		where  ee.afe_num=e.afe_num
		--		order by afe_num
		--	for xml path('')), 1, 1, '') as 
			--,''
			(  -- need to check!
			   select 
			      -- SUSBSTRING 1,20 for showing first 3 cc nums
			      SUBSTRING(STRING_AGG (cc_num, ',') WITHIN GROUP (ORDER BY last_update_date desc, last_update_user, create_date ), 1,20)
			   from cte ee
			   where  ee.afe_num=e.afe_num
			   GROUP BY ee.afe_num
			) as cc_list
	from cte e
	group by e.afe_num
) c1
right outer join (
		select afe_num, count(*) Number_of_CCs
		from stage.t_qbyte_afes_cost_centres
		group by afe_num
) c2 on c1.AFE_NUM = c2.AFE_NUM;