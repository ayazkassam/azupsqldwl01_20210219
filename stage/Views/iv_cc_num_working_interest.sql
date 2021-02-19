CREATE VIEW [stage].[iv_cc_num_working_interest]
AS SELECT SD.cc_num,
       sum(SD.doi) working_interest,
       SD.effective_date,
       SD.termination_date--,

	  -- ,AGREEMENT_ID
	  -- ,ba_id

	   -- STEP 4: Join organizations table to enusure only BNP ba_id's --- as OPERATED.
FROM
(

--Op ccs DOIs

SELECT         doi.agreement_id,
               doi.partner_ba_id AS ba_id,
               doi.effective_date,
               doi.termination_date,
               doi.original_expiry_date,
               doi.cc_num,
               doi.fm_partner_pct AS doi
               --max(doi.termination_date) over (partition by doi.cc_num) max_termination_date
	FROM 
		(
		 -- doi STEP 3: Associate links to DOI / Partners BA ID
		 SELECT         lnk.agreement_id,
                       lnk.cc_num,
                       lnk.effective_date,
                       lnk.termination_date,
                       lnk.original_expiry_date,
					   lnk.major_acct,
					   lnk.minor_acct,
                       ddp.fm_partner_pct,
                       ddp.partner_ba_id,
					   lnk.cc_type_code,
					   --
					   lnk.OWNERSHIP_LINK_ID,
					   lnk.ACCT_GROUP_CODE
        FROM	(-- lnk: STEP  2:  come with termination date based on next_effective_date / expiry_date
				SELECT         cc_num,
                               ownership_link_id,
                               agreement_id,
                               effective_date,
							   major_acct,
							   minor_acct,
							   ISNULL((CASE WHEN next_effective_date IS NULL
							        THEN expiry_date
									ELSE next_effective_date
							         END), cast ('21000101' as datetime)) AS termination_date,
                               expiry_date AS original_expiry_date,
                               org_id,
							   cc_type_code,
							   next_effective_date,
							   ACCT_GROUP_CODE
				FROM	(--lnks STEPS 1 / 1.2 results
				         SELECT link.cc_num,
                                       link.ownership_link_id,
                                       link.agreement_id,
                                       link.effective_date,
                                       link.expiry_date,
                                       link.org_id,
									   link.major_acct,
									   link.minor_acct,
                                       x.next_effective_date,
									   cc.cc_type_code,
									   link.ACCT_GROUP_CODE
                                  FROM		(
								         --- step 1: look in ownership_agreement_links  with conditions below
											SELECT al.ownership_link_id,
                                               al.agreement_id,
                                               al.effective_date,
                                               al.expiry_date,
                                               al.cc_num,
                                               al.org_id,
											   al.major_acct,
											   al.minor_acct,
											   al.acct_group_code,
                                               ROW_NUMBER ()
                                               OVER (
                                                  PARTITION BY al.cc_num,
                                                               al.effective_date
                                                  ORDER BY
                                                     al.last_updt_date DESC,
                                                     al.create_date DESC)
                                                  AS ROW_NUMBER
                                          FROM [stage].[t_qbyte_ownership_agreement_links] al

										  -- Introduced new join to ensure only OP records taken into consideration so the effective and temerination dates align properly
										 /*   INNER JOIN 
														(SELECT doi_deck_id,
																partner_ba_id,
																la_partner_pct,
																fm_partner_pct
														FROM [dbo].[t_qbyte_doi_deck_partners]
														WHERE silent_partner_flag = 'N') ddp
														ON al.agreement_id = ddp.doi_deck_id

                                                  INNER JOIN dbo.t_qbyte_organizations org
												  ON ddp.partner_ba_id = org.org_id

										*/

                                         WHERE     al.effective_date
                                                      IS NOT NULL
                                               AND al.afe_num IS NULL
                                               AND al.acct_group_code IS NULL
                                               AND al.major_acct IS NULL
                                               AND al.minor_acct IS NULL
                                               AND al.production_revenue_code
                                                      IS NULL
                                               AND al.terminate_flag = 'N'

											  -- and al.CC_NUM='473310'

											   ---and al.AGREEMENT_ID <> '14751'
											   
                                               ) link,
									( -- step 1.2 find next_effective date based on effective_date sequence for the given cc num
									  SELECT cc_num,
                                               effective_date,
                                               LAG (
                                                  effective_date)
                                               OVER (
                                                  PARTITION BY cc_num
                                                  ORDER BY
                                                     effective_date DESC)
                                                  AS next_effective_date
                                          FROM (SELECT DISTINCT
                                                       cc_num, effective_date
                                                  FROM [stage].[t_qbyte_ownership_agreement_links] oal

												  -- Introduced new join to ensure only OP records taken into consideration so the effective and temerination dates align properly
												  INNER JOIN 
														(SELECT doi_deck_id,
																partner_ba_id,
																la_partner_pct,
																fm_partner_pct
														FROM [stage].[t_qbyte_doi_deck_partners]
														WHERE silent_partner_flag = 'N') ddp
														ON oal.agreement_id = ddp.doi_deck_id

                                                  INNER JOIN stage.t_qbyte_organizations org
												  ON ddp.partner_ba_id = org.org_id

                                                 WHERE 
												       afe_num IS NULL
                                                       AND acct_group_code  IS NULL
                                                      AND major_acct IS NULL
                                                      AND minor_acct IS NULL
                                                      AND production_revenue_code  IS NULL
                                                      AND terminate_flag = 'N'
															
													  --and   CC_NUM='473310'

										----			   and AGREEMENT_ID <> '14751'

											    ) ln

													  
											     ) x,
									[stage].[t_qbyte_cost_centres] cc
						WHERE     link.ROW_NUMBER = 1
                        AND link.cc_num = x.cc_num
                        AND link.effective_date =  x.effective_date
						AND link.cc_num = cc.cc_num
					) lnks
					) lnk
		INNER JOIN 
            (SELECT doi_deck_id,
                    partner_ba_id,
                    la_partner_pct,
                    fm_partner_pct
              FROM [stage].[t_qbyte_doi_deck_partners]
              WHERE silent_partner_flag = 'N') ddp
		 ON lnk.agreement_id = ddp.doi_deck_id
		LEFT OUTER JOIN	  [stage].t_qbyte_accounts qa
		ON lnk.major_acct = qa.major_acct
		AND lnk.minor_acct = qa.minor_acct  
        ) doi


  INNER JOIN
	   (SELECT         ID,
                       name_1,
                       short_name,
                       ba_type_code,
                       legal_name,
                       alternate_id,
                       effective_date AS ba_effective_date
                  FROM [stage].[t_qbyte_business_associates]
	     ) ba          
  ON ba.id = doi.partner_ba_id
  INNER JOIN [stage].t_qbyte_organizations org
  ON ba.id = org.org_id


  WHERE doi.cc_type_code NOT IN ('NWI')
  --

  UNION ALL
  --
  -- Non Op CCs DOIs
  SELECT         doi.agreement_id,
               doi.partner_ba_id AS ba_id,
               doi.effective_date,
               doi.termination_date,
               doi.original_expiry_date,
               doi.cc_num,
               doi.fm_partner_pct AS doi
               --max(doi.termination_date) over (partition by doi.cc_num) max_termination_date
	FROM 
		(
		 -- doi
		 SELECT         lnk.agreement_id,
                       lnk.cc_num,
                       lnk.effective_date,
                       lnk.termination_date,
                       lnk.original_expiry_date,
					   lnk.major_acct,
					   lnk.minor_acct,
                       ddp.fm_partner_pct,
                       ddp.partner_ba_id,
					   lnk.cc_type_code
        FROM	(-- lnk
				SELECT         cc_num,
                               ownership_link_id,
                               agreement_id,
                               effective_date,
							   major_acct,
							   minor_acct,
							   ISNULL((CASE WHEN next_effective_date IS NULL
							        THEN expiry_date
									ELSE next_effective_date
							         END), cast ('21000101' as datetime)) AS termination_date,
                               expiry_date AS original_expiry_date,
                               org_id,
							   cc_type_code
				FROM	(--lnks
				         SELECT link.cc_num,
                                       link.ownership_link_id,
                                       link.agreement_id,
                                       link.effective_date,
                                       link.expiry_date,
                                       link.org_id,
									   link.major_acct,
									   link.minor_acct,
                                       x.next_effective_date,
									   cc.cc_type_code
                                  FROM		(SELECT al.ownership_link_id,
                                               al.agreement_id,
                                               al.effective_date,
                                               al.expiry_date,
                                               al.cc_num,
                                               al.org_id,
											   al.major_acct,
											   al.minor_acct,
                                               ROW_NUMBER ()
                                               OVER (
                                                  PARTITION BY al.cc_num,
                                                               al.effective_date
                                                  ORDER BY
                                                     al.last_updt_date DESC,
                                                     al.create_date DESC)
                                                  AS ROW_NUMBER
                                          FROM [stage].[t_qbyte_ownership_agreement_links] al
                                         WHERE     al.effective_date
                                                      IS NOT NULL
                                               AND al.afe_num IS NULL
                                               AND al.acct_group_code = 'NOPWI'		
                                               AND al.major_acct IS NULL
                                               AND al.minor_acct IS NULL
                                               AND al.production_revenue_code
                                                      IS NULL
                                               AND al.terminate_flag = 'N'
                                               ) link,
									(SELECT cc_num,
                                               effective_date,
                                               LAG (
                                                  effective_date)
                                               OVER (
                                                  PARTITION BY cc_num
                                                  ORDER BY
                                                     effective_date DESC)
                                                  AS next_effective_date
                                          FROM (SELECT DISTINCT
                                                       cc_num, effective_date
                                                  FROM [stage].[t_qbyte_ownership_agreement_links]
                                                 WHERE     afe_num IS NULL
                                                       AND acct_group_code= 'NOPWI'		
                                                       AND major_acct IS NULL
                                                       AND minor_acct IS NULL
                                                       AND production_revenue_code
                                                              IS NULL
                                                       AND terminate_flag =
                                                              'N') ln
											     ) x,
									[stage].t_qbyte_cost_centres cc
						WHERE     link.ROW_NUMBER = 1
                        AND link.cc_num = x.cc_num
                        AND link.effective_date =  x.effective_date
						AND link.cc_num = cc.cc_num
					) lnks
					) lnk
		INNER JOIN 
            (SELECT doi_deck_id,
                    partner_ba_id,
                    la_partner_pct,
                    fm_partner_pct
              FROM [stage].[t_qbyte_doi_deck_partners]
              WHERE silent_partner_flag = 'N') ddp
		 ON lnk.agreement_id = ddp.doi_deck_id
		LEFT OUTER JOIN	  [stage].t_qbyte_accounts qa
		ON lnk.major_acct = qa.major_acct
		AND lnk.minor_acct = qa.minor_acct  
        ) doi
  INNER JOIN
	   (SELECT         ID,
                       name_1,
                       short_name,
                       ba_type_code,
                       legal_name,
                       alternate_id,
                       effective_date AS ba_effective_date
                  FROM [stage].[t_qbyte_business_associates]
	     ) ba          
  ON ba.id = doi.partner_ba_id
  INNER JOIN [stage].t_qbyte_organizations org
  ON ba.id = org.org_id
  WHERE doi.cc_type_code IN ('NWI')

  ) sd

   --where cc_num='473310' -- '473312' --'425206' 

  GROUP BY SD.cc_num, SD.effective_date, SD.termination_date;