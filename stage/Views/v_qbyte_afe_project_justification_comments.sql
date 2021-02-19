CREATE VIEW [stage].[v_qbyte_afe_project_justification_comments]
AS SELECT
               a.afe_num,
               REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (a.comments,
                                                                     '  ', ' '
                                                                    ),
                                                            '  ', ' '
                                                           ),
                                                   '  ', ' '
                                                  ),
                                          '  ', ' '
                                         ),
                                 '  ', ' '
                                ),
                        '  ', ' '
                       ) AS project_justification_comments
          FROM
               (SELECT
                       afe_num,
                       ROW_NUMBER ()
                          OVER (PARTITION BY afe_num
                                ORDER BY afe_proj_just_line_id ASC
                               ) AS position,
                       LOWER (CONCAT (LTRIM (RTRIM (afe_proj_just_desc)),
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 1)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 1)
                                                                   OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 2)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 2)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 3)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 3)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 4)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 4)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 5)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 5)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 6)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 6)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 7)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 7)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 8)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 8)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 9)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 9)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 10)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 10)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 11)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 11)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 12)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 12)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 13)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 13)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 14)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 14)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 15)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 15)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 16)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 16)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 17)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 17)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 18)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 18)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 19)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 19)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 20)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 20)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 21)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 21)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 22)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 22)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 23)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 23)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 24)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 24)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 25)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 25)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 26)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 26)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 27)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 27)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 28)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 28)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 29)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 29)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 30)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 30)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 31)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 31)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 32)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 32)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 33)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 33)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 34)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 34)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 35)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 35)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 36)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 36)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 37)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 37)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 38)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 38)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 39)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 39)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 40)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 40)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 41)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 41)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 42)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 42)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 43)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 43)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 44)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 44)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 45)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 45)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 46)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 46)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 47)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 47)
                                                          OVER (PARTITION BY afe_num
                                                                              ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 48)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 48)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 49)
                                                 OVER (PARTITION BY afe_num
                                                           ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 49)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                      END,
                                      CASE
                                         WHEN LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 50)
                                                 OVER (PARTITION BY afe_num
                                                              ORDER BY afe_proj_just_line_id ASC) IS NOT NULL
                                            THEN ' ' + LEAD (LTRIM (RTRIM (afe_proj_just_desc)), 50)
                                                          OVER (PARTITION BY afe_num
                                                                 ORDER BY afe_proj_just_line_id ASC)
                                    ELSE NULL END
                           )
                          ) AS comments
                  FROM
                       [stage].[t_qbyte_afe_project_justifications]
               ) a
         WHERE
               a.position = 1;