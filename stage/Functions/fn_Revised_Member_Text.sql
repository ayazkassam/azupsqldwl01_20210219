CREATE FUNCTION [stage].[fn_Revised_Member_Text] (@text_name [Varchar](1000),@cube_name [varchar](200)) RETURNS Varchar(1000)
AS
Begin
    Declare
		@revised_string varchar(1000) = @text_name,
        
		@old_string varchar(1000),
		@replacement_string varchar(1000);

  --  SELECT
  --    CASE 
		--WHEN @revised_string like '%' + String + '%' THEN REPLACE(@revised_string COLLATE Latin1_General_BIN, String, Replacement_String)
  --    ELSE 
	 --   @revised_string
	 -- END
  --  FROM
  --    [stage].[dbo].[t_ctrl_dim_desc_text_excptions]
  --  WHERE
  --    Replacement_String IS NOT NULL
  --    AND Is_Active = 'Y'
  --    AND Cube_Name = @cube_name
  --  ORDER BY  UPPER (String);

--	DECLARE exception_cur CURSOR FOR
--           SELECT
--                  String,
--                  Replacement_String
--             FROM
--                  [stage].[t_ctrl_dim_desc_text_excptions]
--            WHERE
--                  Replacement_String IS NOT NULL
--              AND Is_Active = 'Y'
--              AND Cube_Name = @cube_name
--          ORDER BY  UPPER (String);


--       OPEN exception_cur

--       FETCH NEXT FROM exception_cur
--       INTO @old_string, @replacement_string

--       WHILE @@FETCH_STATUS = 0
--	   BEGIN

--	      IF @revised_string like '%'+@old_string+'%'
--		    begin
--               SET @revised_string = REPLACE(@revised_string COLLATE Latin1_General_BIN, @old_string, @replacement_string)
--			   goto Close_Cursor
--			end
           
-- 	      FETCH NEXT FROM exception_cur
--             INTO @old_string, @replacement_string

--	   END

--Close_Cursor:
	
--      CLOSE exception_cur;
--      DEALLOCATE exception_cur;

 
      return @revised_string
End