CREATE PROC [stage].[LoadData_For_t_qbyte_cost_centre_revised_desc] AS
BEGIN
  
  TRUNCATE TABLE [stage].[t_qbyte_cost_centre_name_revised_desc];
  

  INSERT INTO [stage].[t_qbyte_cost_centre_name_revised_desc]
  SELECT 
	   cost_centre_id,
       cost_centre_name,
	   cost_centre_name cost_centre_name_revised
  FROM [stage].t_cost_centre_hierarchy cc;
	;  


  IF OBJECT_ID('tempdb..#text_exceptions') IS NULL 
    CREATE TABLE #text_exceptions
  	(
  		RN INT,
  		[STRING] VARCHAR(200),
  	    [REPLACEMENT_STRING] VARCHAR(200)
  	)
  ELSE
	DELETE FROM #text_exceptions;

  INSERT INTO #text_exceptions
	SELECT 
	  ROW_NUMBER() OVER(ORDER BY UPPER(STRING)) rn,
      rtrim(ltrim(RS.STRING)) string,
	  rtrim(ltrim(RS.REPLACEMENT_STRING)) replacement_string
	FROM [stage].[t_ctrl_dim_desc_text_excptions] RS
	WHERE RS.Replacement_String IS NOT NULL AND
         RS.Is_Active = 'Y' AND
         RS.Cube_Name = 'CC' 
		
		 ;

DECLARE 

	@replacement_string NVARCHAR(1000) = '',
   
    @String VARCHAR (100) = '' ,

	@TxtMinRow INT = 1,
    @TxtMaxRow INT

  

  SELECT @TxtMaxRow = MAX(rn) FROM #text_exceptions
 

		
		WHILE @TxtMinRow <= @TxtMaxRow
		 BEGIN
		        SELECT @String = String FROM #text_exceptions WHERE rn = @TxtMinRow
				SELECT @replacement_string = Replacement_String FROM #text_exceptions WHERE rn = @TxtMinRow

				update [stage].[t_qbyte_cost_centre_name_revised_desc] 
				set cost_centre_name_revised = replace(cost_centre_name_revised COLLATE Latin1_General_BIN, @String, @replacement_string)
                
				

			   SET @TxtMinRow = @TxtMinRow + 1

		 END

	
END