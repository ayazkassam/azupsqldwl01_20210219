CREATE VIEW [stage].[v_valnav_netback_accounts]
AS select 
  * 
from 
  [stage].[CTE_v_valnav_netback_accounts]
where 
  path1='Netback'
  and parent_id is not null;