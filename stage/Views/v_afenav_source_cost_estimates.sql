CREATE VIEW [stage].[v_afenav_source_cost_estimates]
AS SELECT --afe.*,
      cast(afe.document_id as varchar(50)) afe_document_id,
      afenumber.AFENUMBER,
	  cast(afe_type.other_value1 as varchar(50)) afe_type,
	  fieldcost.amount_date,
	  'INCURRED' amount_type,
	  ng.net_grs,
	  CASE WHEN ng.net_grs = 'GRS'
	       THEN fieldcost.gross_fieldcost 
		   ELSE fieldcost.net_fieldcost
	  END AS amount,
	  afe.legacy_afeid

  FROM [stage].t_afenav_afe afe

  JOIN  
  -- find latest afe version
       (SELECT DISTINCT afenumber_doc,
         first_value(document_id) over ( partition by afenumber_doc order by version desc) max_document_id
		FROM [stage].t_afenav_afe afe 
		--WHERE  afe.LEGACY_AFEID in ('21163' ,'23103')  
	   ) maxver

	ON afe.document_id = maxver.max_document_id

  JOIN [stage].t_afenav_afenumber afenumber
  ON afe.AFENUMBER_DOC = afenumber.DOCUMENT_ID

  JOIN 
	       (SELECT document_id, 
				   amount_date,
				   sum(gross_amount) gross_fieldcost,
				   sum(net_amount) net_fieldcost
			FROM [stage].t_afenav_fieldcost_amounts
			WHERE gross_amount <> 0
			GROUP BY document_id, amount_date
		   ) fieldcost
   on afe.FIELDCOST_DOC = fieldcost.DOCUMENT_ID

   JOIN [stage].t_afenav_afe_custom afe_custom
   ON afe.DOCUMENT_ID = afe_custom.DOCUMENT_ID

   JOIN  [stage].t_afenav_lut_afe_type afe_type
   ON afe_custom.afe_type = afe_type.document_id

   CROSS JOIN 
     (SELECT 'GRS' net_grs 
	  UNION ALL
	  SELECT 'NET' net_grs
	 ) ng;