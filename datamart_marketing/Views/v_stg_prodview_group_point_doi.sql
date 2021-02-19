CREATE VIEW [datamart_marketing].[v_stg_prodview_group_point_doi]
AS SELECT DISTINCT
			idflownet,
			idrecparent,
			dttmstart,
			CASE
                            WHEN LEAD (
                                    dttmstart,
                                    1)
                                 OVER (
                                    PARTITION BY idflownet, idrecparent, subtyp2
                                    ORDER BY dttmstart)
                                    IS NULL
                            THEN
                               isnull (dttmend,
                                    cast ('12-31-9999' as date))
                            ELSE
                               isnull (
                                    LEAD (
                                       dttmstart,
                                       1)
                                    OVER (
                                       PARTITION BY idflownet,
                                                    idrecparent,
                                                    subtyp2
                                       ORDER BY dttmstart)
                                  - 1,
                                  cast ('12-31-9999' as date))
                         END
                            dttmend,
					typ1,
					subtyp2 ba_name,
					CASE WHEN ISNUMERIC(refidb) = 1
					     THEN CAST (refidb as numeric(13,5))
						 ELSE NULL
					END working_interest,
					refidb
					--refida
  FROM stage_prodview.t_pvt_pvunitagreemt
  WHERE subtyp1='Marketing';