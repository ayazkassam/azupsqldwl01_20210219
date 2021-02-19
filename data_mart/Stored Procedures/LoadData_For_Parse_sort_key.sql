CREATE PROC [data_mart].[LoadData_For_Parse_sort_key] AS
BEGIN
  IF OBJECT_ID('tempdb..#sort_key') IS NOT NULL
    DROP TABLE #sort_key	 

  CREATE TABLE #sort_key WITH (DISTRIBUTION = ROUND_ROBIN)
    AS
  SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT 1)) position, 
    SRC.[sort_key] 
  FROM
    (SELECT [sort_key] FROM [dbo].[Revised_sort_key] GROUP BY [sort_key]) SRC

  IF OBJECT_ID('tempdb..#Parse_sort_key') IS NULL
   CREATE TABLE #Parse_sort_key
     ( 
	    [sort_key] VARCHAR(1000),
        [position] INT,
	    [item] VARCHAR(100)
	   )
  ELSE
	TRUNCATE TABLE #Parse_sort_key

  DECLARE
    @MinPosition INT = (SELECT MIN(Position) FROM #sort_key),
	@MaxPosition INT = (SELECT MAX(Position) FROM #sort_key),
	@rn INT = 1,

    @SQLQUERY  VARCHAR(MAX) = 'Lease Operating Reporting // Operating Expenses // R&M - DOWNHOLE // WIRELINE/COIL TUBING UNIT // 6600_687', 
	@sort_key VARCHAR(1000), -- FOR TABLE ORIGINAL
    @DELIMITOR CHAR(2) = '//' ,
    @Position INT = 1

  WHILE @MinPosition <= @MaxPosition
    BEGIN
	  SET @rn = @MinPosition

	  SELECT @SQLQUERY = [sort_key] FROM #sort_key WHERE position = @rn
	  SELECT @sort_key = [sort_key] FROM #sort_key WHERE position = @rn

      DECLARE @DELIMITORPOSITION INT = CHARINDEX(@DELIMITOR, @SQLQUERY), 
              @VALUE             VARCHAR(100), 
              @STARTPOSITION     INT = 1 


      IF @DELIMITORPOSITION = 0 
        BEGIN 
            INSERT INTO #Parse_sort_key 
			  (
			    [sort_key],
				[position],
				[item]
			  )
            VALUES 
			  (
			    @SQLQUERY, 1, @SQLQUERY
			  )				 
          --  RETURN 
        END 

      SET @SQLQUERY = @SQLQUERY + @DELIMITOR 
 
      WHILE @DELIMITORPOSITION > 0 
        BEGIN 
            SET @VALUE =  LTRIM(RTRIM(SUBSTRING(@SQLQUERY, @STARTPOSITION, @DELIMITORPOSITION - @STARTPOSITION))) 
            --SELECT @VALUE
            IF( @VALUE <> '' ) 
			  BEGIN
			   -- SET @SQLQUERY = SUBSTRING(@SQLQUERY, 1, LEN(@SQLQUERY) - 2)
			    
				INSERT INTO #Parse_sort_key 
				  (
					 [sort_key],
					 [position],
					 [item]				  
				  )
				VALUES 
				  (
					 @sort_key,
					 @Position,
					 @VALUE
				  )
                 SET @Position = @Position +1 
			  END 	
 
            SET @STARTPOSITION = @DELIMITORPOSITION + 2 
            SET @DELIMITORPOSITION = CHARINDEX(@DELIMITOR, @SQLQUERY, @STARTPOSITION) 
        END  

      SET @MinPosition  = @MinPosition + 1
	  SET @Position = 1
	END
 
  IF OBJECT_ID('[dbo].[Parse_sort_key]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Parse_sort_key];
  ELSE
    CREATE TABLE [dbo].[Parse_sort_key]
	  (
	   sort_key VARCHAR(1000),
	   account_level_01_sort_key VARCHAR(1000),
	   account_level_02_sort_key VARCHAR(1000),
	   account_level_03_sort_key VARCHAR(1000),
	   account_level_04_sort_key VARCHAR(1000),
	   account_level_05_sort_key VARCHAR(1000),
	   account_level_06_sort_key VARCHAR(1000),
	   account_level_07_sort_key VARCHAR(1000),
	   account_level_08_sort_key VARCHAR(1000),
	   account_level_09_sort_key VARCHAR(1000),
	   account_level_10_sort_key VARCHAR(1000)
	  )

  INSERT INTO [dbo].[Parse_sort_key]
    (
	  sort_key, 
      account_level_01_sort_key,
      account_level_02_sort_key,
      account_level_03_sort_key,
      account_level_04_sort_key,
      account_level_05_sort_key, 
      account_level_06_sort_key,
      account_level_07_sort_key,
      account_level_08_sort_key,
      account_level_09_sort_key,
      account_level_10_sort_key
	)

  SELECT 
    [sort_key],   
    [1] as account_level_01_sort_key, 
	[2] as account_level_02_sort_key, 
	[3] as account_level_03_sort_key, 
	[4] as account_level_04_sort_key,
	[5] as account_level_05_sort_key ,   
    [6] as account_level_06_sort_key, 
	[7] as account_level_07_sort_key, 
	[8] as account_level_08_sort_key, 
	[9] as account_level_09_sort_key,
	[10] as account_level_10_sort_key   
  FROM  
    (
	  SELECT 
	    [sort_key], 
		position, 
		LTRIM(RTRIM([item])) [item]   
      FROM 
	    #Parse_sort_key
    ) AS PHP  
  PIVOT  
    (  
      MAX([item])
      FOR position IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10] )  
    ) AS PivotTable 
  SELECT 1
END