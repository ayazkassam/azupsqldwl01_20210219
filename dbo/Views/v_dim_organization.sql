CREATE VIEW [dbo].[v_dim_organization]
AS SELECT organization_id
		, organization_name
		, organization_type_code
		, case when organization_id in (-1,-2) then 9999 + organization_id else organization_id end as sort_key
	FROM [data_mart].[t_dim_organization]
	union all

	select -1, 'Unknown','U', 9999;