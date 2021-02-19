CREATE PROC [stage].[spLoad_CTE_v_valnav_netback_accounts] AS
BEGIN

  DECLARE @counter INT = 0;

  IF OBJECT_ID('[stage].[CTE_v_valnav_netback_accounts]') IS NOT NULL
    TRUNCATE TABLE [stage].[CTE_v_valnav_netback_accounts]
  
  INSERT INTO [stage].[CTE_v_valnav_netback_accounts]
  SELECT
    0  as [Level],
    account_id,
    parent_id,
    account_desc as path1,
    cast(Null as varchar(100)) as Path2,
    cast(Null as varchar(100)) as Path3,
    cast(Null as varchar(100)) as Path4,
    cast(Null as varchar(100)) as Path5
  FROM [stage].t_ctrl_special_accounts
  WHERE 
    is_valnav = 1 and 
    parent_id is null
  

  WHILE EXISTS 
    (
      SELECT *
      FROM [stage].[CTE_v_valnav_netback_accounts] CTE
      INNER JOIN [stage].t_ctrl_special_accounts child 
      	ON child.parent_id = CTE.account_id 
      WHERE 
        CTE.[Level] = @counter AND
        child.is_valnav = 1
    )
  
  BEGIN  
      -- Insert next level
    INSERT INTO [stage].[CTE_v_valnav_netback_accounts] --( xlevel, FeatureId, ParentId, FeatureName, PathString, PathLength )
      SELECT 
  	    @counter + 1 AS [level], 
        child.account_id,
        child.parent_id,
  	    CTE.path1,
  	    case when CTE.Level + 1 = 1 then account_desc else Path2 end,
        case when CTE.Level + 1 = 2 then account_desc else Path3 end,
        case when CTE.Level + 1 = 3 then account_desc else Path4 end,
        case when CTE.Level + 1 = 4 then account_desc else Path5 end
      FROM
	    [stage].[CTE_v_valnav_netback_accounts] CTE
      INNER JOIN [stage].t_ctrl_special_accounts child
        ON child.parent_id = CTE.account_id AND 
           child.is_valnav = 1
      WHERE
        CTE.[level] = @counter AND
        path1 = 'Netback'
      
  	SET @counter += 1;
  
      -- Loop safety
    IF @counter > 99
      BEGIN 
          RAISERROR( 'Too many loops!', 16, 1 ) 
          BREAK 
      END;
  
  END

  SELECT 1  
END