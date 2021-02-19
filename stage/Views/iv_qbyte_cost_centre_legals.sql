CREATE VIEW [stage].[iv_qbyte_cost_centre_legals]
AS SELECT
       [ID]
      ,[CC_NUM]
      ,[CREATE_DATE]
      ,[CREATE_USER]
      ,[LAST_UPDATE_DATE]
      ,[LAST_UPDATE_USER]
      ,[PRIMARY_FLAG]
      ,[SURVEY_SYSTEM_CODE]
      ,[LOCATION_ELEMENT_1]
      ,[LOCATION_ELEMENT_2]
      ,[LOCATION_ELEMENT_3]
      ,[LOCATION_ELEMENT_4]
      ,[LOCATION_ELEMENT_5]
      ,[LOCATION_ELEMENT_6]
      ,[LOCATION_ELEMENT_7]
      ,[LOCATION_ELEMENT_8]
       --
       ,nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                concat(   stage.TRIM(location_element_1)                           /* Unique Well Identifier Format and Chronological
                                                                          Sequence of Wells Drilled in the Quarter Unit */
                , stage.TRIM(location_element_2)                           /* Quarter Unit */
                , stage.LPAD (stage.TRIM(location_element_3), 3, '0')            /* Unit */
                , stage.TRIM(location_element_4)                           /* Block */
                , stage.LPAD (stage.TRIM(location_element_5), 3, '0')            /* NTS Map Sheet Number 1 */
                , stage.TRIM(location_element_6)                           /* NTS Map Sheet Number 2 */
                , stage.LPAD (stage.TRIM(location_element_7), 2, '0')            /* NTS Map Sheet Number 3 */
                , stage.LPAD (isnull (stage.TRIM(location_element_8), '0'), 2, '0') /* Event Sequence Code */
				)
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                   concat(stage.TRIM(location_element_1)                /* Unique Well Identifier Format and Chronological Sequence
								                                      of Wells Drilled in the Unit */
					, stage.TRIM(location_element_2)                /* Unit */
					, stage.LPAD (stage.TRIM(location_element_3), 2, '0') /* Section */
					, stage.LPAD (stage.TRIM(location_element_4), 2, '0') /* Degrees Latitude */
					, stage.LPAD (stage.TRIM(location_element_5), 2, '0') /* Minutes Latitude */
					, stage.LPAD (stage.TRIM(location_element_6), 3, '0') /* Degrees Longitude */
					, stage.LPAD (stage.TRIM(location_element_7), 2, '0') /* Minutes Longitude */
					, stage.TRIM(location_element_8)                /* Event Sequence Code */
					)
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN
				concat(stage.TRIM(location_element_1)                /* Unique Well Identifier Format */
                , stage.LPAD (stage.TRIM(location_element_2), 2, '0') /* Legal Subdivision */
                , stage.LPAD (stage.TRIM(location_element_3), 2, '0') /* Section */
                , stage.LPAD (stage.TRIM(location_element_4), 3, '0') /* Township */
                , stage.LPAD (stage.TRIM(location_element_5), 2, '0') /* Range */
                , stage.TRIM(location_element_6)                /* Direction of Range Numbering */
                , stage.TRIM(location_element_7)                /* Meridian */
                , stage.LPAD (stage.TRIM(location_element_8), 2, '0') /* Event Sequence Code */
				)
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                concat(stage.TRIM(location_element_1)                           /* Unique Well Identifier Format and Location Exception */
                , stage.LPAD (stage.TRIM(location_element_2), 2, '0')            /* Legal Subdivision */
                , stage.LPAD (stage.TRIM(location_element_3), 2, '0')            /* Section */
                , stage.LPAD (stage.TRIM(location_element_4), 3, '0')            /* Township */ 
                , stage.LPAD (stage.TRIM(location_element_5), 2, '0')            /* Range */
                , 'W' , isnull (stage.TRIM(location_element_6), '0')         /* Meridian */
                , stage.LPAD (isnull (stage.TRIM(location_element_7), '0'), 2, '0') /* Event Sequence Code */
				)
          ELSE
                concat(stage.TRIM(location_element_1)
				, stage.TRIM(location_element_2)
				, stage.TRIM(location_element_3)
				, stage.TRIM(location_element_4)
				, stage.TRIM(location_element_5)
				, stage.TRIM(location_element_6)
				, stage.TRIM(location_element_7)
				, stage.TRIM(location_element_8))
       END as varchar(100)) ,'') AS uwi,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
				--NVL2 (location_element_1,                    /* Chronological Sequence of Wells Drilled in the Quarter Unit */
				--		location_element_1 || '/',
				--		NULL			)     
				concat(
				coalesce(nullif(stage.TRIM(location_element_1),'')+'/','')
                , stage.TRIM(location_element_2)             /* Quarter Unit */
                , '-' + stage.TRIM(location_element_3)       /* Unit */
                , '-' + stage.TRIM(location_element_4)       /* Block */
                , '/' + stage.TRIM(location_element_5)       /* NTS Map Sheet Number 1 */
                , '-' + stage.TRIM(location_element_6)       /* NTS Map Sheet Number 2 */
                , '-' + stage.TRIM(location_element_7)       /* NTS Map Sheet Number 3 */
                --|| NVL2 (TRIM (location_element_8),
                --         '/' || NVL (location_element_8, '00'),
                --         NULL
                --        )   
				, coalesce('/'+nullif(stage.TRIM(location_element_8),''),'')	  /* Event Sequence Code */
				)

          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                   --NVL2 (SUBSTRING (stage.TRIM(location_element_1), 2, 2),
                   --      SUBSTRING (stage.TRIM(location_element_1), 2, 2) + '/',
                   --      NULL
                   --     )
				concat(
					coalesce(nullif(SUBSTRING (stage.TRIM(location_element_1), 2, 2),'')+'/','')
					, stage.TRIM(location_element_2)                       /* Unit */
					, stage.LPAD (stage.TRIM(location_element_3), 2, '0') + ' ' /* Section */
					, stage.LPAD (stage.TRIM(location_element_4), 2, '0') + '-' /* Degrees Latitude */
					, stage.LPAD (stage.TRIM(location_element_5), 2, '0') + ' ' /* Minutes Latitude */
					, stage.LPAD (stage.TRIM(location_element_6), 3, '0') + '-' /* Degrees Longitude */
					, stage.LPAD (stage.TRIM(location_element_7), 2, '0') + '/' /* Minutes Longitude */
					, stage.TRIM(location_element_8)                       /* Event Sequence Code */
				)
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN
                concat(
					SUBSTRING (   stage.TRIM(location_element_1), 2, 2)
					, '/' + stage.TRIM(location_element_2)                /* Legal Subdivision */
					, '-' + stage.TRIM(location_element_3)                /* Section */
					, '-' + stage.TRIM(location_element_4)                /* Township */
					, '-' + stage.TRIM(location_element_5)                /* Range */
					, stage.TRIM(location_element_6)                       /* Direction of Range Numbering */
					, stage.TRIM(location_element_7)                       /* Meridian */
					, '/' + stage.LPAD (stage.TRIM(location_element_8), 2, '0') /* Event Sequence Code */
				)
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                   concat(
					SUBSTRING (stage.TRIM(location_element_1), 2, 2)                    /* Location Exception */
					, '/' + stage.TRIM(location_element_2)                            /* Legal Subdivision */
					, '-' + stage.TRIM(location_element_3)                            /* Section */
					, '-' + stage.TRIM(location_element_4)                            /* Township */ 
					, '-' + stage.TRIM(location_element_5)                            /* Range */
					, 'W' + isnull (stage.TRIM(location_element_6), '0')          /* Meridian */
					, '/' + SUBSTRING (stage.LPAD (isnull (stage.TRIM(location_element_7),
												 '0'),
											2, '0'),                        /* Event Sequence Code */
									  2,
									  1
									 )
					)
          WHEN LEN (concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8))
                      ) <> 16
             THEN stage.INITCAP (   
							concat(
								stage.TRIM(location_element_1)
							   , stage.TRIM(location_element_2)
							   , stage.TRIM(location_element_3)
							   , stage.TRIM(location_element_4)
							   , stage.TRIM(location_element_5)
							   , stage.TRIM(location_element_6)
							   , stage.TRIM(location_element_7)
							   , stage.TRIM(location_element_8)
						   )
                          )
       END as varchar(100)) ,'') AS uwi_alias,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                   --NVL2 (location_element_1,                    /* Chronological Sequence of Wells Drilled in the Quarter Unit */
                   --      location_element_1 + '/',
                   --      NULL
                   --     )                                                   
				concat(
					coalesce(nullif(stage.TRIM(location_element_1),'')+'/','')
					, stage.TRIM(location_element_2)                           /* Quarter Unit */
					, '-' + stage.TRIM(location_element_3)                    /* Unit */
					, '-' + stage.TRIM(location_element_4)                    /* Block */
					, '/' + stage.TRIM(location_element_5)                    /* NTS Map Sheet Number 1 */
					, '-' + stage.TRIM(location_element_6)                    /* NTS Map Sheet Number 2 */
					, '-' + stage.TRIM(location_element_7)                    /* NTS Map Sheet Number 3 */
					--+ NVL2 (stage.TRIM(location_element_8),
					--         '/' + isnull (location_element_8, '00'),
					--         NULL
					--        )                                       /* Event Sequence Code */
					, coalesce('/' + nullif(location_element_8,''),'')
					)

          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                   --NVL2 (SUBSTRING (stage.TRIM(location_element_1), 2, 2),
                   --      SUBSTRING (stage.TRIM(location_element_1), 2, 2) + '/',
                   --      NULL
                   --     )
				concat(
				coalesce(nullif(SUBSTRING (stage.TRIM(location_element_1), 2, 2),'')+'/','')
                , stage.TRIM(location_element_2)                       /* Unit */
                , stage.LPAD (stage.TRIM(location_element_3), 2, '0') + ' ' /* Section */
                , stage.LPAD (stage.TRIM(location_element_4), 2, '0') + '-' /* Degrees Latitude */
                , stage.LPAD (stage.TRIM(location_element_5), 2, '0') + ' ' /* Minutes Latitude */
                , stage.LPAD (stage.TRIM(location_element_6), 3, '0') + '-' /* Degrees Longitude */
                , stage.LPAD (stage.TRIM(location_element_7), 2, '0') + '/' /* Minutes Longitude */
                , stage.TRIM(location_element_8)                       /* Event Sequence Code */
				)
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN
                concat(SUBSTRING (   stage.TRIM(location_element_1), 2, 2)
                , '/' + stage.TRIM(location_element_2)                /* Legal Subdivision */
                , '-' + stage.TRIM(location_element_3)                /* Section */
                , '-' + stage.TRIM(location_element_4)                /* Township */
                , '-' + stage.TRIM(location_element_5)                /* Range */
                , stage.TRIM(location_element_6)                       /* Direction of Range Numbering */
                , stage.TRIM(location_element_7)                       /* Meridian */
                , '/' + stage.LPAD (stage.TRIM(location_element_8), 2, '0') /* Event Sequence Code */
				)

          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                concat(SUBSTRING (stage.TRIM(location_element_1), 1, 3)                 /* Location Exception */
					, '/' + stage.TRIM(location_element_2)                         /* Legal Subdivision */
					, '-' + stage.TRIM(location_element_3)                         /* Section */
					, '-' + stage.TRIM(location_element_4)                         /* Township */ 
					, '-' + stage.TRIM(location_element_5)                         /* Range */
					, 'W' + isnull (stage.TRIM(location_element_6), '0')       /* Meridian */
					, '/' + stage.LPAD (isnull (stage.TRIM(location_element_7),
										 '0'),
									2, '0')                              /* Event Sequence Code */
				)
          WHEN LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) != 16
             THEN stage.INITCAP (   
							concat(stage.TRIM(location_element_1)
                           , stage.TRIM(location_element_2)
                           , stage.TRIM(location_element_3)
                           , stage.TRIM(location_element_4)
                           , stage.TRIM(location_element_5)
                           , stage.TRIM(location_element_6)
                           , stage.TRIM(location_element_7)
                           , stage.TRIM(location_element_8))
                          )
       END as varchar(100)) ,'') AS location,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                concat( SUBSTRING (stage.TRIM(location_element_1), 1, 1)                           /* Survey System Code */
                , stage.LPAD (stage.TRIM(location_element_5), 3, '0')                           /* NTS Map Sheet Number 1 */
                , stage.TRIM(location_element_6)                                          /* NTS Map Sheet Number 2 */
                , stage.LPAD (stage.TRIM(location_element_7), 2, '0')                           /* NTS Map Sheet Number 3 */
                , stage.TRIM(location_element_4)                                          /* Block */
                , stage.LPAD (stage.TRIM(location_element_3), 3, '0')                           /* Unit */
                , stage.TRIM(location_element_2)                                          /* Quarter Unit */
                , stage.LPAD (isnull (SUBSTRING (stage.TRIM(location_element_1), 2, 2), '0'), 2, '0') /* Chronological Sequence of Wells Drilled
                                                                                         in the Quarter Unit */
                , stage.LPAD (isnull (stage.TRIM(location_element_8), '0'), 2, '0')                /* Event Sequence Code */
				)
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                   concat(SUBSTRING (stage.TRIM(location_element_1), 1, 1) /* Unique Well Identifier Format */
						, stage.LPAD (stage.TRIM(location_element_4), 2, '0') /* Degrees Latitude */
						, stage.LPAD (stage.TRIM(location_element_5), 2, '0') /* Minutes Latitude */
						, stage.LPAD (stage.TRIM(location_element_6), 3, '0') /* Degrees Longitude */
						, stage.LPAD (stage.TRIM(location_element_7), 2, '0') /* Minutes Longitude */
						, stage.TRIM(location_element_8)                /* Event Sequence Code */
						, stage.LPAD (stage.TRIM(location_element_3), 2, '0') /* Section */
						, stage.TRIM(location_element_2)                /* Unit */
					)
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN
                concat(SUBSTRING (stage.TRIM(location_element_1), 1, 1)             /* Unique Well Identifier Format */
                , stage.TRIM(location_element_6)                            /* Direction of Range Numbering */
                , stage.TRIM(location_element_7)                            /* Meridian */
                , stage.LPAD (stage.TRIM(location_element_4), 3, '0')             /* Township */
                , stage.LPAD (stage.TRIM(location_element_5), 2, '0')             /* Range */
                , stage.LPAD (stage.TRIM(location_element_3), 2, '0')             /* Section */
                , stage.LPAD (stage.TRIM(location_element_2), 2, '0')             /* Legal Subdivision */
                , stage.LPAD (isnull (SUBSTRING (stage.TRIM(location_element_1), 2, 2),
                              '0'),
                         2, '0')
                , stage.LPAD (stage.TRIM(location_element_8), 2, '0')             /* Event Sequence Code */
				)
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN
                concat(SUBSTRING (stage.TRIM(location_element_1), 1, 1)             /* Unique Well Identifier Format */
                , 'W'                                                  /* Direction of Range Numbering */
                , isnull (stage.TRIM(location_element_6), '0')                 /* Meridian */
                , stage.LPAD (stage.TRIM(location_element_4), 3, '0')             /* Township */
                , stage.LPAD (stage.TRIM(location_element_5), 2, '0')             /* Range */
                , stage.LPAD (stage.TRIM(location_element_3), 2, '0')             /* Section */
                , stage.LPAD (stage.TRIM(location_element_2), 2, '0')             /* Legal Subdivision */
                , stage.LPAD (isnull (SUBSTRING (stage.TRIM(location_element_1), 2, 2),
                              '0'),
                         2, '0')
                , stage.LPAD (stage.TRIM(location_element_7), 2, '0')             /* Event Sequence */
				)
       END as varchar(100)) ,'') AS sorted_uwi,
       --
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN SUBSTRING (stage.TRIM(location_element_1), 1, 1) /* Survey System Code */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN SUBSTRING (stage.TRIM(location_element_1), 1, 1) /* Unique Well Identifier Format */
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN SUBSTRING (stage.TRIM(location_element_1), 1, 1) /* Unique Well Identifier Format */
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN SUBSTRING (stage.TRIM(location_element_1), 1, 1) /* Unique Well Identifier Format */
       END as varchar(100)) ,'') AS uwi_sort_element_1,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_5), 3, '0') /* NTS Map Sheet Number 1 */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_4), 2, '0') /* Degrees Latitude */
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN stage.TRIM(location_element_6) /* Direction of Range Numbering */
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN 'W' /* Direction of Range Numbering */
       END as varchar(100)) ,'') AS uwi_sort_element_2,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.TRIM(location_element_6) /* NTS Map Sheet Number 2 */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_5), 2, '0') /* Minutes Latitude */
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN stage.TRIM(location_element_7) /* Meridian */
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN isnull (stage.TRIM(location_element_6), '0') /* Meridian */
       END as varchar(100)) ,'') AS uwi_sort_element_3,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_7), 2, '0') /* NTS Map Sheet Number 3 */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_6), 3, '0') /* Degrees Longitude */
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (   concat(stage.TRIM(location_element_1)
                           , stage.TRIM(location_element_2)
                           , stage.TRIM(location_element_3)
                           , stage.TRIM(location_element_4)
                           , stage.TRIM(location_element_5)
                           , stage.TRIM(location_element_6)
                           , stage.TRIM(location_element_7)
                           , stage.TRIM(location_element_8))
                          ) = 16
             THEN stage.LPAD (stage.TRIM(location_element_4), 3, '0') /* Township */
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_4), 3, '0') /* Township */
       END as varchar(100)) ,'') AS uwi_sort_element_4,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.TRIM(location_element_4) /* Block */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_7), 2, '0') /* Minutes Longitude */
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN stage.LPAD (stage.TRIM(location_element_5), 2, '0') /* Range */
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_5), 2, '0') /* Range */
       END as varchar(100)) ,'') AS uwi_sort_element_5,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_3), 3, '0') /* Unit */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.TRIM(location_element_8) /* Event Sequence Code */
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN stage.LPAD (stage.TRIM(location_element_3), 2, '0') /* Section */
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_3), 2, '0') /* Section */
       END as varchar(100)) ,'') AS uwi_sort_element_6,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.TRIM(location_element_2) /* Quarter Unit */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_3), 2, '0') /* Section */
          WHEN     survey_system_code = 'FF' /* Free Form */
				     AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN stage.LPAD (stage.TRIM(location_element_2), 2, '0') /* Legal Subdivision */
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (stage.TRIM(location_element_2), 2, '0') /* Legal Subdivision */
       END as varchar(100)) ,'') AS uwi_sort_element_7,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (isnull (SUBSTRING (stage.TRIM(location_element_1), 2, 2), '0'), 2, '0') /* Chronological Sequence of Wells Drilled
                                                                                        in the Quarter Unit */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.TRIM(location_element_2) /* Unit */
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN stage.LPAD (isnull (SUBSTRING (stage.TRIM(location_element_1), 2, 2),
                             '0'),
                        2, '0')
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (isnull (SUBSTRING (stage.TRIM(location_element_1), 2, 2),
                             '0'),
                        2, '0')
       END as varchar(100)) ,'') AS uwi_sort_element_8,
       nullif(cast(
	   CASE
          WHEN     survey_system_code = 'NTS' /* National Topographic System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (isnull (stage.TRIM(location_element_8), '0'), 2, '0') /* Event Sequence Code */
          WHEN     survey_system_code = 'FPS' /* Federal Permit System */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN NULL
          WHEN     survey_system_code = 'FF' /* Free Form */
               AND LEN (	concat( stage.TRIM(location_element_1)
						   , stage.TRIM(location_element_2)
						   , stage.TRIM(location_element_3)
						   , stage.TRIM(location_element_4)
						   , stage.TRIM(location_element_5)
						   , stage.TRIM(location_element_6)
						   , stage.TRIM(location_element_7)
						   , stage.TRIM(location_element_8))
                          ) = 16
             THEN stage.LPAD (stage.TRIM(location_element_8), 2, '0') /* Event Sequence Code */
          WHEN     survey_system_code = 'DLS' /* Dominion Land Survey */
               AND concat( stage.TRIM(location_element_1)
                   , stage.TRIM(location_element_2)
                   , stage.TRIM(location_element_3)
                   , stage.TRIM(location_element_4)
                   , stage.TRIM(location_element_5)
                   , stage.TRIM(location_element_6)
                   , stage.TRIM(location_element_7)
                   , stage.TRIM(location_element_8)) != ''
             THEN stage.LPAD (isnull (stage.TRIM(location_element_7),
                             '0'),
                        2, '0') /* Event Sequence */
       END as varchar(100)) ,'') AS uwi_sort_element_9
       --
  FROM
       stage.t_qbyte_cost_centre_legals ccl;