CREATE VIEW [dbo].[v_dim_scenario_finance]
AS select cast(scenario_key as varchar(1000)) as scenario_key
	, scenario_description
	, cast(scenario_cube_name as varchar(50)) as scenario_cube_name
	, unary_operator
	, cast(replace(scenario_formula,'[Scenario].[Scenario Hierarchy]','[Scenario].[Posted Hierarchy]') as varchar(1000)) as scenario_formula
	, cast(scenario_formula_property as varchar(50)) as scenario_formula_property
	, cast(scenario_level_01 as varchar(1000)) as posted_level_01
	, cast(scenario_level_02 as varchar(1000)) as posted_level_02
	, cast(scenario_level_03 as varchar(1000)) as posted_level_03
	, cast(scenario_level_04 as varchar(1000)) as posted_level_04
	, cast(scenario_level_05 as varchar(1000)) as posted_level_05
	, cast(scenario_level_01_sort_key as varchar(50)) as posted_level_01_sort_key
	, cast(scenario_level_02_sort_key as varchar(50)) as posted_level_02_sort_key
	, cast(scenario_level_03_sort_key as varchar(50)) as posted_level_03_sort_key
	, cast(scenario_level_04_sort_key as varchar(50)) as posted_level_04_sort_key
	, cast(scenario_level_05_sort_key as varchar(50)) as posted_level_05_sort_key
	, cast(case when hierarchy_type in ('Posted','Unposted') then 'Actuals with Unposted' end as varchar(1000)) unposted_level_01
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_01 end as varchar(1000)) as unposted_level_02
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_02 end as varchar(1000)) as unposted_level_03
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_03 end as varchar(1000)) as unposted_level_04
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_04 end as varchar(1000)) as unposted_level_05
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_01_sort_key end as varchar(50)) as unposted_level_01_sort_key
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_02_sort_key end as varchar(50)) as unposted_level_02_sort_key
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_03_sort_key end as varchar(50)) as unposted_level_03_sort_key
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_04_sort_key end as varchar(50)) as unposted_level_04_sort_key
	, cast(case when hierarchy_type in ('Posted','Unposted') then scenario_level_05_sort_key end as varchar(50)) as unposted_level_05_sort_key

    , cast(case when hierarchy_type in ('Posted','Unposted') then scenario_key end as varchar(1000)) as unposted_scenario_key
from stage.v_dim_source_scenario_finance;