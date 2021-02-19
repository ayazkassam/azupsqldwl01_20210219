CREATE PROC [data_mart].[LoadData_For_Parse_Hierarchy_Path] AS
BEGIN

  IF OBJECT_ID('tempdb..#Hierarchy_Path') IS NOT NULL
    DROP TABLE #Hierarchy_Path	 

  CREATE TABLE #Hierarchy_Path WITH (DISTRIBUTION = ROUND_ROBIN)
    AS
  SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT 1)) position, 
    SRC.[Hierarchy_Path] 
  FROM
    (SELECT [Hierarchy_Path] FROM [dbo].[Revised_Hierarchy_Path] GROUP BY [Hierarchy_Path]) SRC

  IF OBJECT_ID('tempdb..#Parse_Hierarchy_Path') IS NULL
   CREATE TABLE #Parse_Hierarchy_Path
     ( 
	    [Hierarchy_Path] VARCHAR(1000),
        [position] INT,
	    [item] VARCHAR(100)
	   )
  ELSE
	TRUNCATE TABLE #Parse_Hierarchy_Path

  DECLARE
    @MinPosition INT = (SELECT MIN(Position) FROM #Hierarchy_Path),
	@MaxPosition INT = (SELECT MAX(Position) FROM #Hierarchy_Path),
	@rn INT = 1,

    @SQLQUERY  VARCHAR(MAX) = 'Lease Operating Reporting // Operating Expenses // R&M - DOWNHOLE // WIRELINE/COIL TUBING UNIT // 6600_687', 
	@Hierarchy_Path VARCHAR(1000), -- FOR TABLE ORIGINAL
    @DELIMITOR CHAR(2) = '//' ,
    @Position INT = 1

  WHILE @MinPosition <= @MaxPosition
    BEGIN
	  SET @rn = @MinPosition

	  SELECT @SQLQUERY = [Hierarchy_Path] FROM #Hierarchy_Path WHERE position = @rn
	  SELECT @Hierarchy_Path = [Hierarchy_Path] FROM #Hierarchy_Path WHERE position = @rn

      DECLARE @DELIMITORPOSITION INT = CHARINDEX(@DELIMITOR, @SQLQUERY), 
              @VALUE             VARCHAR(100), 
              @STARTPOSITION     INT = 1 


      IF @DELIMITORPOSITION = 0 
        BEGIN 
            INSERT INTO #Parse_Hierarchy_Path 
			  (
			    [Hierarchy_Path],
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
            SET @VALUE = SUBSTRING(@SQLQUERY, @STARTPOSITION, 
                         @DELIMITORPOSITION - @STARTPOSITION) 
            --SELECT @VALUE
            IF( @VALUE <> '' ) 
			  BEGIN
			   -- SET @SQLQUERY = SUBSTRING(@SQLQUERY, 1, LEN(@SQLQUERY) - 2)
				INSERT INTO #Parse_Hierarchy_Path 
				  (
					 [Hierarchy_Path],
					 [position],
					 [item]				  
				  )
				VALUES 
				  (
					 @Hierarchy_Path,
					 @Position,
					 @VALUE
				  )
                 SET @Position = @Position +1 
			  END 	
 
            SET @STARTPOSITION = @DELIMITORPOSITION + 2 
            SET @DELIMITORPOSITION = CHARINDEX(@DELIMITOR, @SQLQUERY, 
                                     @STARTPOSITION) 
        END  

      SET @MinPosition  = @MinPosition + 1
	  SET @Position = 1
	END

 
  IF OBJECT_ID('[dbo].[Parse_Hierarchy_Path]') IS NOT NULL 
    TRUNCATE TABLE [dbo].[Parse_Hierarchy_Path];
  ELSE
    CREATE TABLE [dbo].[Parse_Hierarchy_Path]
	  (
	   Hierarchy_Path VARCHAR(1000),
	   account_level_01 VARCHAR(1000),
	   account_level_02 VARCHAR(1000),
	   account_level_03 VARCHAR(1000),
	   account_level_04 VARCHAR(1000),
	   account_level_05 VARCHAR(1000),
	   account_level_06 VARCHAR(1000),
	   account_level_07 VARCHAR(1000),
	   account_level_08 VARCHAR(1000),
	   account_level_09 VARCHAR(1000),
	   account_level_10 VARCHAR(1000)
	  )

  INSERT INTO [dbo].[Parse_Hierarchy_Path]
    (
	  Hierarchy_Path, 
      account_level_01,
      account_level_02,
      account_level_03,
      account_level_04,
      account_level_05, 
      account_level_06,
      account_level_07,
      account_level_08,
      account_level_09,
      account_level_10
	)

  SELECT 
    [Hierarchy_Path],   
    [1] as account_level_01, 
	[2] as account_level_02, 
	[3] as account_level_03, 
	[4] as account_level_04,
	[5] as account_level_05,   
    [6] as account_level_06, 
	[7] as account_level_07, 
	[8] as account_level_08, 
	[9] as account_level_09,
	[10] as account_level_10   
  FROM  
    (
	  SELECT 
	    [Hierarchy_Path], 
		position, 
		LTRIM(RTRIM([item])) [item]
      FROM 
	    #Parse_Hierarchy_Path
    ) AS PHP  
  PIVOT  
    (  
      MAX([item])
      FOR position IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10] )  
    ) AS PivotTable  
	--SELECT * FROM [dbo].[Parse_Hierarchy_Path]

  SELECT 1
END