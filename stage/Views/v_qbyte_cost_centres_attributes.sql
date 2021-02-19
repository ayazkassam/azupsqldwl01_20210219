CREATE VIEW [stage].[v_qbyte_cost_centres_attributes]
AS SELECT cc.*,
      CASE
                       WHEN     LTRIM( RTRIM(survey_system_code)) IS NOT NULL
                            AND LTRIM( RTRIM(UWI)) IS NOT NULL
                       THEN
                          CASE LTRIM( RTRIM(survey_system_code))
                             /* 1=DLS, 2=NTS, 3, Federal Permit, 4=Geodetic Coord, F=Free Format */
                          WHEN 'DLS'    THEN  SUBSTRING (uwi, 13, 2)
                             WHEN 'NTS' THEN  SUBSTRING (uwi, 9, 2)
                          END
                       ELSE
                          CONCAT(LTRIM( RTRIM(survey_system_code )) , ' NA_Meridian') --_Map_Street'
                    END
                       meridian,                                --uwi_level_1,
                    CASE
                       WHEN     LTRIM( RTRIM(survey_system_code)) IS NOT NULL
                            AND LTRIM( RTRIM(UWI)) IS NOT NULL
                       THEN
                          CASE LTRIM( RTRIM(survey_system_code))
                             /* 1=DLS, 2=NTS, 3, Federal Permit, 4=Geodetic Coord, F=Free Format */
                             WHEN 'DLS'
                             THEN
                                 CONCAT( 
                                  SUBSTRING (uwi, 11, 2)
                                , SUBSTRING (uwi, 13, 2)
                                 )
                             WHEN 'NTS'
                             THEN
                                 CONCAT( 
                                  SUBSTRING (uwi, 12, 1)
                                , SUBSTRING (uwi, 9, 2) ---SUBSTR(tw.formated_well_location,8,1)
                                 )
                          END
                       ELSE
                          CONCAT(LTRIM( RTRIM(survey_system_code)) , ' NA_Range')   --_Block'
                    END
                       range,                                   --uwi_level_2,
                    CASE
                       WHEN     LTRIM( RTRIM(survey_system_code)) IS NOT NULL
                            AND LTRIM( RTRIM(UWI)) IS NOT NULL
                       THEN
                          CASE LTRIM( RTRIM(survey_system_code))
                             /* 1=DLS, 2=NTS, 3, Federal Permit, 4=Geodetic Coord, F=Free Format */
                             WHEN 'DLS'
                             THEN
                                CONCAT(  
                                  SUBSTRING (uwi, 8, 3)
                                , '-'
                                , SUBSTRING (uwi, 11, 2)
                                , SUBSTRING (uwi, 13, 2)
                                      )
                             WHEN 'NTS'
                             THEN
                                 CONCAT(
                                  SUBSTRING (uwi, 9, 2)
                                , '-'
                                , SUBSTRING (uwi, 12, 1) ---SUBSTR(tw.formated_well_location,8,1)
                                , SUBSTRING (uwi, 13, 2)
                                 )
                          END
                       ELSE
                          CONCAT(LTRIM( RTRIM(survey_system_code)) , ' NA_Township') --_Unit'
                    END
                       township,                                --uwi_level_3,
                    --RPAD(
                    CASE
                       WHEN     LTRIM( RTRIM(survey_system_code)) IS NOT NULL
                            AND LTRIM( RTRIM(UWI)) IS NOT NULL
                       THEN
                          CASE LTRIM( RTRIM(survey_system_code))
                             /* 1=DLS, 2=NTS, 3, Federal Permit, 4=Geodetic Coord, F=Free Format */
                             WHEN 'DLS'
                             THEN
				 CONCAT(
                                  
                                  SUBSTRING (uwi, 6, 2)
                                , '-'
                                , SUBSTRING (uwi, 8, 3)
                                , '-'
                                , SUBSTRING (uwi, 11, 2)
                                , SUBSTRING (uwi, 13, 2)
                                      )
                             WHEN 'NTS'
                             THEN
				 CONCAT(
                                  
                                  SUBSTRING (uwi, 4, 1)
                                , '-'
                                , SUBSTRING (uwi, 9, 2) ---SUBSTR(tw.formated_well_location,8,1)
                                , '-'
                                , SUBSTRING (uwi, 12, 1)
                                , SUBSTRING (uwi, 13, 2)
                                 )
                          END
                       ELSE
                          CONCAT (LTRIM( RTRIM(survey_system_code)) , ' NA_Section') --_1_4_Unit'
                    END
                       --,16,'0')
                       section
FROM
(
SELECT c.*,
        [Stage].[InitCap](ccc.cc_type_desc) cc_type_desc,
        CASE
             WHEN     survey_system_code = 'NTS' /* National Topographic System */
                  AND  
				    CONCAT(  LTRIM( RTRIM(location_element_1))
                      ,  LTRIM( RTRIM(location_element_2))
                      , LTRIM( RTRIM(location_element_3))
                      , LTRIM( RTRIM(location_element_4))
                      , LTRIM( RTRIM(location_element_5))
                      , LTRIM( RTRIM(location_element_6))
                      , LTRIM( RTRIM(location_element_7))
                      , LTRIM( RTRIM(location_element_8))
					  )
                         IS NOT NULL
             THEN
			   CONCAT(
                   LTRIM( RTRIM(location_element_1)) /* Unique Well Identifier Format and Chronological
                                                Sequence of Wells Drilled in the Quarter Unit */
                , LTRIM( RTRIM(location_element_2))                /* Quarter Unit */
                , LEFT(LTRIM( RTRIM(location_element_3)) + REPLICATE('0',3),3)         /* Unit */
                , LTRIM( RTRIM(location_element_4))                       /* Block */
                , LEFT(LTRIM( RTRIM(location_element_5)) + REPLICATE('0',3),3) /* NTS Map Sheet Number 1 */
                , LTRIM( RTRIM(location_element_6))      /* NTS Map Sheet Number 2 */
                , LEFT(LTRIM( RTRIM(location_element_7)) + REPLICATE('0',2),2) /* NTS Map Sheet Number 3 */
                , LEFT(LTRIM( RTRIM(location_element_8)) + REPLICATE('0',2),2) /* Event Sequence Code */
				)
             WHEN     survey_system_code = 'FPS'   /* Federal Permit System */
                  AND   
				    CONCAT(
					   LTRIM( RTRIM(location_element_1))
                      , LTRIM( RTRIM(location_element_2))
                      ,  LTRIM( RTRIM(location_element_3))
                      ,  LTRIM( RTRIM(location_element_4))
                      ,  LTRIM( RTRIM(location_element_5))
                      ,  LTRIM( RTRIM(location_element_6))
                      ,  LTRIM( RTRIM(location_element_7))
                      ,  LTRIM( RTRIM(location_element_8))
					  )
                         IS NOT NULL
             THEN
			   CONCAT(
                   LTRIM( RTRIM(location_element_1)) /* Unique Well Identifier Format and Chronological Sequence
                                                of Wells Drilled in the Unit */
                ,  LTRIM( RTRIM(location_element_2))                        /* Unit */
                ,  LEFT(LTRIM( RTRIM(location_element_3)) + REPLICATE('0',2),2)      /* Section */
                ,  LEFT(LTRIM( RTRIM(location_element_4)) + REPLICATE('0',2),2) /* Degrees Latitude */
                ,  LEFT(LTRIM( RTRIM(location_element_5)) + REPLICATE('0',2),2) /* Minutes Latitude */
                ,  LEFT(LTRIM( RTRIM(location_element_6)) + REPLICATE('0',3),3) /* Degrees Longitude */
                ,  LEFT(LTRIM( RTRIM(location_element_7)) + REPLICATE('0',2),2) /* Minutes Longitude */
                ,  LTRIM( RTRIM(location_element_8))         /* Event Sequence Code */
				)
             WHEN     survey_system_code = 'FF'                /* Free Form */
                  AND LEN (
				        CONCAT(
                            LTRIM( RTRIM(location_element_1))
                         , LTRIM( RTRIM(location_element_2))
                         , LTRIM( RTRIM(location_element_3))
                         , LTRIM( RTRIM(location_element_4))
                         , LTRIM( RTRIM(location_element_5))
                         , LTRIM( RTRIM(location_element_6))
                         , LTRIM( RTRIM(location_element_7))
                         , LTRIM( RTRIM(location_element_8))
						 )
						) = 16
             THEN
                 CONCAT (
				 LTRIM( RTRIM(location_element_1)) /* Unique Well Identifier Format */
                , LEFT(LTRIM( RTRIM(location_element_2)) + REPLICATE('0',2),2) /* Legal Subdivision */
                , LEFT(LTRIM( RTRIM(location_element_3)) + REPLICATE('0',2),2)      /* Section */
                , LEFT(LTRIM( RTRIM(location_element_4)) + REPLICATE('0',3),3)     /* Township */
                , LEFT(LTRIM( RTRIM(location_element_5)) + REPLICATE('0',2),2)        /* Range */
                , LTRIM( RTRIM(location_element_6)) /* Direction of Range Numbering */
                , LTRIM( RTRIM(location_element_7))                    /* Meridian */
                , LEFT(LTRIM( RTRIM(location_element_8)) + REPLICATE('0',2),2) /* Event Sequence Code */
				)
             WHEN     survey_system_code = 'DLS'    /* Dominion Land Survey */
                  AND  CONCAT(  LTRIM( RTRIM(location_element_1))
                      , LTRIM( RTRIM(location_element_2))
                      , LTRIM( RTRIM(location_element_3))
                      , LTRIM( RTRIM(location_element_4))
                      , LTRIM( RTRIM(location_element_5))
                      , LTRIM( RTRIM(location_element_6))
                      , LTRIM( RTRIM(location_element_7))
                      , LTRIM( RTRIM(location_element_8))
					  )
                         IS NOT NULL
             THEN
                 CONCAT(  LTRIM( RTRIM(location_element_1)) /* Unique Well Identifier Format and Location Exception */
                 , LEFT(LTRIM( RTRIM(location_element_2)) + REPLICATE('0',2),2) /* Legal Subdivision */
                ,  LEFT(LTRIM( RTRIM(location_element_3)) + REPLICATE('0',2),2)     /* Section */
                ,  LEFT(LTRIM( RTRIM(location_element_4)) + REPLICATE('0',3),3)     /* Township */
                ,  LEFT(LTRIM( RTRIM(location_element_5)) + REPLICATE('0',2),2)        /* Range */
                ,  'W'
                ,  LTRIM( RTRIM(location_element_6))                    /* Meridian */
                ,  LEFT(LTRIM( RTRIM(location_element_7)) + REPLICATE('0',2),2)
				) /* Event Sequence Code */
             ELSE
                CONCAT (
				   LTRIM( RTRIM(location_element_1))
                ,  LTRIM( RTRIM(location_element_2))
                ,  LTRIM( RTRIM(location_element_3))
                ,  LTRIM( RTRIM(location_element_4))
                ,  LTRIM( RTRIM(location_element_5))
                ,  LTRIM( RTRIM(location_element_6))
                ,  LTRIM( RTRIM(location_element_7))
                ,  LTRIM( RTRIM(location_element_8))
				)
          END
             AS uwi,
		  CASE
             WHEN     survey_system_code = 'NTS' /* National Topographic System */
                  AND  
				    CONCAT(  LTRIM( RTRIM(location_element_1))
                      ,  LTRIM( RTRIM(location_element_2))
                      , LTRIM( RTRIM(location_element_3))
                      , LTRIM( RTRIM(location_element_4))
                      , LTRIM( RTRIM(location_element_5))
                      , LTRIM( RTRIM(location_element_6))
                      , LTRIM( RTRIM(location_element_7))
                      , LTRIM( RTRIM(location_element_8))
					  )
                         IS NOT NULL
             THEN
			     CONCAT(
				 CASE WHEN REPLACE(LTRIM(SUBSTRING (location_element_1, 2, 2)),'0','')  IS NULL THEN NULL
				      ELSE CONCAT(REPLACE(LTRIM(location_element_1),'0','') , '/')
				 END, /* Chronological Sequence of Wells Drilled in the Quarter Unit */
				 location_element_2, /* Quarter Unit */
				 '-',
				 REPLACE(LTRIM(location_element_3),'0',''), /* Unit */
				 '-',
				 location_element_4, /* Block */
				 '/', 
				 REPLACE(LTRIM(location_element_5),'0',''), /* NTS Map Sheet Number 1 */
				 '-',
				 location_element_6,  /* NTS Map Sheet Number 2 */
				 '-',
				 REPLACE(LTRIM(location_element_7),'0',''),  /* NTS Map Sheet Number 3 */
				 CASE WHEN RTRIM(LTRIM(location_element_8))  IS NULL THEN NULL
				      ELSE CONCAT('/', ISNULL(REPLACE(LTRIM(location_element_8),'0',''),'0'))
				 END   /* Event Sequence Code */
				 )
			 WHEN     survey_system_code = 'FPS' /* Federal Permit System */
                  AND  
				    CONCAT(  LTRIM( RTRIM(location_element_1))
                      ,  LTRIM( RTRIM(location_element_2))
                      , LTRIM( RTRIM(location_element_3))
                      , LTRIM( RTRIM(location_element_4))
                      , LTRIM( RTRIM(location_element_5))
                      , LTRIM( RTRIM(location_element_6))
                      , LTRIM( RTRIM(location_element_7))
                      , LTRIM( RTRIM(location_element_8))
					  )
                         IS NOT NULL
			 THEN
			    CONCAT(
			     CASE WHEN SUBSTRING(LTRIM(RTRIM(location_element_1)),2,2) IS NULL THEN NULL
				      ELSE SUBSTRING(LTRIM(RTRIM(location_element_1)),2,2)
				 END,
				 '/',
				 RTRIM(LTRIM (location_element_2)),                        /* Unit */
				 LEFT(LTRIM( RTRIM(location_element_3)) + REPLICATE('0',2),2),     /* Section */
				 ' ',
				 LEFT(LTRIM( RTRIM(location_element_4)) + REPLICATE('0',2),2),     /* Degrees Latitude */
				 '-',
				 LEFT(LTRIM( RTRIM(location_element_5)) + REPLICATE('0',2),2),  /* Minutes Latitude */
				 ' ',
				 LEFT(LTRIM( RTRIM(location_element_6)) + REPLICATE('0',3),3), /* Degrees Longitude */
				 '-',
				 LEFT(LTRIM( RTRIM(location_element_7)) + REPLICATE('0',2),2), /* Minutes Longitude */
				 '/',
				 LTRIM(RTRIM(location_element_8))         /* Event Sequence Code */
				)
		 WHEN     survey_system_code = 'FF' /* Free Form */
                  AND  
				    LEN(CONCAT(  LTRIM( RTRIM(location_element_1))
                      ,  LTRIM( RTRIM(location_element_2))
                      , LTRIM( RTRIM(location_element_3))
                      , LTRIM( RTRIM(location_element_4))
                      , LTRIM( RTRIM(location_element_5))
                      , LTRIM( RTRIM(location_element_6))
                      , LTRIM( RTRIM(location_element_7))
                      , LTRIM( RTRIM(location_element_8))
					  )) = 16
		 THEN CONCAT(
				SUBSTRING(location_element_1,2,2),
				'/',
				location_element_2, 	 /* Legal Subdivision */
				'-',
				location_element_3,		 /* Section */
				'-',
				location_element_4,		 /* Township */
				'-',
				location_element_5,       /* Range */
				location_element_6,       /* Direction of Range Numbering */
				location_element_7,       /* Meridian */
				'/',
				LEFT(location_element_8 + REPLICATE('0',2),2) /* Event Sequence Code */
		      )
		  WHEN     survey_system_code = 'DLS'    /* Dominion Land Survey */
                  AND  CONCAT(  LTRIM( RTRIM(location_element_1))
                      , LTRIM( RTRIM(location_element_2))
                      , LTRIM( RTRIM(location_element_3))
                      , LTRIM( RTRIM(location_element_4))
                      , LTRIM( RTRIM(location_element_5))
                      , LTRIM( RTRIM(location_element_6))
                      , LTRIM( RTRIM(location_element_7))
                      , LTRIM( RTRIM(location_element_8))
					  )
                         IS NOT NULL
		  THEN 
		    CONCAT(
			   SUBSTRING (location_element_1, 2, 2),  /* Location Exception */
			   '/', 
			   location_element_2,                  /* Legal Subdivision */
			   '-',
			   location_element_3,                  /* Section */
			   '-',
			   location_element_4,                   /* Township */
			   '-',
			   location_element_5,                   /* Range */
			   'W',
			   location_element_6,                    /* Meridian */
			   '/',
			   SUBSTRING(LEFT(location_element_7 + REPLICATE('0',2),2),
		            2,1)
			)
		 WHEN 
		       LEN(CONCAT(  LTRIM( RTRIM(location_element_1))
                      ,  LTRIM( RTRIM(location_element_2))
                      , LTRIM( RTRIM(location_element_3))
                      , LTRIM( RTRIM(location_element_4))
                      , LTRIM( RTRIM(location_element_5))
                      , LTRIM( RTRIM(location_element_6))
                      , LTRIM( RTRIM(location_element_7))
                      , LTRIM( RTRIM(location_element_8))
					  )) = 16
		 THEN
		      [Stage].[InitCap]
			  (CONCAT(  LTRIM( RTRIM(location_element_1))
                      ,  LTRIM( RTRIM(location_element_2))
                      , LTRIM( RTRIM(location_element_3))
                      , LTRIM( RTRIM(location_element_4))
                      , LTRIM( RTRIM(location_element_5))
                      , LTRIM( RTRIM(location_element_6))
                      , LTRIM( RTRIM(location_element_7))
                      , LTRIM( RTRIM(location_element_8))
					  )
					  )
		 END uwi_desc
FROM  [Stage].[t_qbyte_cost_centres] c
LEFT OUTER JOIN 
       (SELECT code, code_desc cc_type_desc
		FROM stage.[t_qbyte_codes]
		WHERE code_type_code='CC_TYPE_CODE'
	 ) ccc
ON c.cc_type_code = ccc.code
) cc;