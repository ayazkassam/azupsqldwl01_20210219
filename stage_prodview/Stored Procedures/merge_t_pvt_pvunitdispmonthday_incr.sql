﻿CREATE PROC [stage_prodview].[merge_t_pvt_pvunitdispmonthday_incr] AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY	
  --BEGIN TRANSACTION

    IF OBJECT_ID('tempdb..#t_t_pvt_pvunitdispmonthday_MERGE') IS NOT NULL
      DROP TABLE #t_t_pvt_pvunitdispmonthday_MERGE	 

    CREATE TABLE #t_t_pvt_pvunitdispmonthday_MERGE WITH (DISTRIBUTION = ROUND_ROBIN)
      AS	
	    SELECT
	      'NEW' Flag,
	       src.[idflownet]
          ,src.[idrecparent]
          ,src.[idrec]
          ,src.[dttm]
          ,src.[year]
          ,src.[month]
          ,src.[dayofmonth]
          ,src.[idrecunit]
          ,src.[idrecunittk]
          ,src.[idreccomp]
          ,src.[idreccomptk]
          ,src.[idreccompzone]
          ,src.[idreccompzonetk]
          ,src.[idrecdispunitnode]
          ,src.[idrecdispunitnodetk]
          ,src.[idrecdispunit]
          ,src.[idrecdispunittk]
          ,src.[volhcliq]
          ,src.[volhcliqgaseq]
          ,src.[volgas]
          ,src.[volwater]
          ,src.[volsand]
          ,src.[volc1liq]
          ,src.[volc1gaseq]
          ,src.[volc1gas]
          ,src.[volc2liq]
          ,src.[volc2gaseq]
          ,src.[volc2gas]
          ,src.[volc3liq]
          ,src.[volc3gaseq]
          ,src.[volc3gas]
          ,src.[volic4liq]
          ,src.[volic4gaseq]
          ,src.[volic4gas]
          ,src.[volnc4liq]
          ,src.[volnc4gaseq]
          ,src.[volnc4gas]
          ,src.[volic5liq]
          ,src.[volic5gaseq]
          ,src.[volic5gas]
          ,src.[volnc5liq]
          ,src.[volnc5gaseq]
          ,src.[volnc5gas]
          ,src.[volc6liq]
          ,src.[volc6gaseq]
          ,src.[volc6gas]
          ,src.[volc7liq]
          ,src.[volc7gaseq]
          ,src.[volc7gas]
          ,src.[voln2liq]
          ,src.[voln2gaseq]
          ,src.[voln2gas]
          ,src.[volco2liq]
          ,src.[volco2gaseq]
          ,src.[volco2gas]
          ,src.[volh2sliq]
          ,src.[volh2sgaseq]
          ,src.[volh2sgas]
          ,src.[volothercompliq]
          ,src.[volothercompgaseq]
          ,src.[volothercompgas]
          ,src.[heat]
          ,src.[idreccalcset]
          ,src.[idreccalcsettk]
          ,src.[syslockmeui]
          ,src.[syslockchildrenui]
          ,src.[syslockme]
          ,src.[syslockchildren]
          ,src.[syslockdate]
          ,src.[sysmoddate]
          ,src.[sysmoduser]
          ,src.[syscreatedate]
          ,src.[syscreateuser]
          ,src.[systag] 
		FROM
          [stage_prodview].[t_pvt_pvunitdispmonthday] as trg
        LEFT JOIN [stage_prodview].[t_pvt_pvunitdispmonthday_incr] as src
          ON trg.[idflownet] = src.[idflownet] AND
	         trg.[idrec] = src.[idrec] AND
		     trg.[dttm]	= src.[dttm]
        WHERE
		  trg.[idflownet] IS NULL AND
		  trg.[idrec] IS NULL AND
		  trg.[dttm] IS NULL
       
        UNION ALL

        SELECT
		  'UPDATE' Flag,
	       src.[idflownet]
          ,src.[idrecparent]
          ,src.[idrec]
          ,src.[dttm]
          ,src.[year]
          ,src.[month]
          ,src.[dayofmonth]
          ,src.[idrecunit]
          ,src.[idrecunittk]
          ,src.[idreccomp]
          ,src.[idreccomptk]
          ,src.[idreccompzone]
          ,src.[idreccompzonetk]
          ,src.[idrecdispunitnode]
          ,src.[idrecdispunitnodetk]
          ,src.[idrecdispunit]
          ,src.[idrecdispunittk]
          ,src.[volhcliq]
          ,src.[volhcliqgaseq]
          ,src.[volgas]
          ,src.[volwater]
          ,src.[volsand]
          ,src.[volc1liq]
          ,src.[volc1gaseq]
          ,src.[volc1gas]
          ,src.[volc2liq]
          ,src.[volc2gaseq]
          ,src.[volc2gas]
          ,src.[volc3liq]
          ,src.[volc3gaseq]
          ,src.[volc3gas]
          ,src.[volic4liq]
          ,src.[volic4gaseq]
          ,src.[volic4gas]
          ,src.[volnc4liq]
          ,src.[volnc4gaseq]
          ,src.[volnc4gas]
          ,src.[volic5liq]
          ,src.[volic5gaseq]
          ,src.[volic5gas]
          ,src.[volnc5liq]
          ,src.[volnc5gaseq]
          ,src.[volnc5gas]
          ,src.[volc6liq]
          ,src.[volc6gaseq]
          ,src.[volc6gas]
          ,src.[volc7liq]
          ,src.[volc7gaseq]
          ,src.[volc7gas]
          ,src.[voln2liq]
          ,src.[voln2gaseq]
          ,src.[voln2gas]
          ,src.[volco2liq]
          ,src.[volco2gaseq]
          ,src.[volco2gas]
          ,src.[volh2sliq]
          ,src.[volh2sgaseq]
          ,src.[volh2sgas]
          ,src.[volothercompliq]
          ,src.[volothercompgaseq]
          ,src.[volothercompgas]
          ,src.[heat]
          ,src.[idreccalcset]
          ,src.[idreccalcsettk]
          ,src.[syslockmeui]
          ,src.[syslockchildrenui]
          ,src.[syslockme]
          ,src.[syslockchildren]
          ,src.[syslockdate]
          ,src.[sysmoddate]
          ,src.[sysmoduser]
          ,src.[syscreatedate]
          ,src.[syscreateuser]
          ,src.[systag] 
        FROM
          (
             SELECT
	           src.[idflownet]
              ,src.[idrecparent]
              ,src.[idrec]
              ,src.[dttm]
              ,src.[year]
              ,src.[month]
              ,src.[dayofmonth]
              ,src.[idrecunit]
              ,src.[idrecunittk]
              ,src.[idreccomp]
              ,src.[idreccomptk]
              ,src.[idreccompzone]
              ,src.[idreccompzonetk]
              ,src.[idrecdispunitnode]
              ,src.[idrecdispunitnodetk]
              ,src.[idrecdispunit]
              ,src.[idrecdispunittk]
              ,src.[volhcliq]
              ,src.[volhcliqgaseq]
              ,src.[volgas]
              ,src.[volwater]
              ,src.[volsand]
              ,src.[volc1liq]
              ,src.[volc1gaseq]
              ,src.[volc1gas]
              ,src.[volc2liq]
              ,src.[volc2gaseq]
              ,src.[volc2gas]
              ,src.[volc3liq]
              ,src.[volc3gaseq]
              ,src.[volc3gas]
              ,src.[volic4liq]
              ,src.[volic4gaseq]
              ,src.[volic4gas]
              ,src.[volnc4liq]
              ,src.[volnc4gaseq]
              ,src.[volnc4gas]
              ,src.[volic5liq]
              ,src.[volic5gaseq]
              ,src.[volic5gas]
              ,src.[volnc5liq]
              ,src.[volnc5gaseq]
              ,src.[volnc5gas]
              ,src.[volc6liq]
              ,src.[volc6gaseq]
              ,src.[volc6gas]
              ,src.[volc7liq]
              ,src.[volc7gaseq]
              ,src.[volc7gas]
              ,src.[voln2liq]
              ,src.[voln2gaseq]
              ,src.[voln2gas]
              ,src.[volco2liq]
              ,src.[volco2gaseq]
              ,src.[volco2gas]
              ,src.[volh2sliq]
              ,src.[volh2sgaseq]
              ,src.[volh2sgas]
              ,src.[volothercompliq]
              ,src.[volothercompgaseq]
              ,src.[volothercompgas]
              ,src.[heat]
              ,src.[idreccalcset]
              ,src.[idreccalcsettk]
              ,src.[syslockmeui]
              ,src.[syslockchildrenui]
              ,src.[syslockme]
              ,src.[syslockchildren]
              ,src.[syslockdate]
              ,src.[sysmoddate]
              ,src.[sysmoduser]
              ,src.[syscreatedate]
              ,src.[syscreateuser]
              ,src.[systag] 
		    FROM
              [stage_prodview].[t_pvt_pvunitdispmonthday] as trg
            INNER JOIN [stage_prodview].[t_pvt_pvunitdispmonthday_incr] as src
              ON trg.[idflownet] = src.[idflownet] AND
	             trg.[idrec] = src.[idrec] AND
		         trg.[dttm]	= src.[dttm]

            EXCEPT

			SELECT
	           trg.[idflownet]
              ,trg.[idrecparent]
              ,trg.[idrec]
              ,trg.[dttm]
              ,trg.[year]
              ,trg.[month]
              ,trg.[dayofmonth]
              ,trg.[idrecunit]
              ,trg.[idrecunittk]
              ,trg.[idreccomp]
              ,trg.[idreccomptk]
              ,trg.[idreccompzone]
              ,trg.[idreccompzonetk]
              ,trg.[idrecdispunitnode]
              ,trg.[idrecdispunitnodetk]
              ,trg.[idrecdispunit]
              ,trg.[idrecdispunittk]
              ,trg.[volhcliq]
              ,trg.[volhcliqgaseq]
              ,trg.[volgas]
              ,trg.[volwater]
              ,trg.[volsand]
              ,trg.[volc1liq]
              ,trg.[volc1gaseq]
              ,trg.[volc1gas]
              ,trg.[volc2liq]
              ,trg.[volc2gaseq]
              ,trg.[volc2gas]
              ,trg.[volc3liq]
              ,trg.[volc3gaseq]
              ,trg.[volc3gas]
              ,trg.[volic4liq]
              ,trg.[volic4gaseq]
              ,trg.[volic4gas]
              ,trg.[volnc4liq]
              ,trg.[volnc4gaseq]
              ,trg.[volnc4gas]
              ,trg.[volic5liq]
              ,trg.[volic5gaseq]
              ,trg.[volic5gas]
              ,trg.[volnc5liq]
              ,trg.[volnc5gaseq]
              ,trg.[volnc5gas]
              ,trg.[volc6liq]
              ,trg.[volc6gaseq]
              ,trg.[volc6gas]
              ,trg.[volc7liq]
              ,trg.[volc7gaseq]
              ,trg.[volc7gas]
              ,trg.[voln2liq]
              ,trg.[voln2gaseq]
              ,trg.[voln2gas]
              ,trg.[volco2liq]
              ,trg.[volco2gaseq]
              ,trg.[volco2gas]
              ,trg.[volh2sliq]
              ,trg.[volh2sgaseq]
              ,trg.[volh2sgas]
              ,trg.[volothercompliq]
              ,trg.[volothercompgaseq]
              ,trg.[volothercompgas]
              ,trg.[heat]
              ,trg.[idreccalcset]
              ,trg.[idreccalcsettk]
              ,trg.[syslockmeui]
              ,trg.[syslockchildrenui]
              ,trg.[syslockme]
              ,trg.[syslockchildren]
              ,trg.[syslockdate]
              ,trg.[sysmoddate]
              ,trg.[sysmoduser]
              ,trg.[syscreatedate]
              ,trg.[syscreateuser]
              ,trg.[systag] 
		    FROM
              [stage_prodview].[t_pvt_pvunitdispmonthday] as trg
          ) src


    INSERT INTO [stage_prodview].[t_pvt_pvunitdispmonthday] 
	  (
	     [idflownet]
        ,[idrecparent]
        ,[idrec]
        ,[dttm]
        ,[year]
        ,[month]
        ,[dayofmonth]
        ,[idrecunit]
        ,[idrecunittk]
        ,[idreccomp]
        ,[idreccomptk]
        ,[idreccompzone]
        ,[idreccompzonetk]
        ,[idrecdispunitnode]
        ,[idrecdispunitnodetk]
        ,[idrecdispunit]
        ,[idrecdispunittk]
        ,[volhcliq]
        ,[volhcliqgaseq]
        ,[volgas]
        ,[volwater]
        ,[volsand]
        ,[volc1liq]
        ,[volc1gaseq]
        ,[volc1gas]
        ,[volc2liq]
        ,[volc2gaseq]
        ,[volc2gas]
        ,[volc3liq]
        ,[volc3gaseq]
        ,[volc3gas]
        ,[volic4liq]
        ,[volic4gaseq]
        ,[volic4gas]
        ,[volnc4liq]
        ,[volnc4gaseq]
        ,[volnc4gas]
        ,[volic5liq]
        ,[volic5gaseq]
        ,[volic5gas]
        ,[volnc5liq]
        ,[volnc5gaseq]
        ,[volnc5gas]
        ,[volc6liq]
        ,[volc6gaseq]
        ,[volc6gas]
        ,[volc7liq]
        ,[volc7gaseq]
        ,[volc7gas]
        ,[voln2liq]
        ,[voln2gaseq]
        ,[voln2gas]
        ,[volco2liq]
        ,[volco2gaseq]
        ,[volco2gas]
        ,[volh2sliq]
        ,[volh2sgaseq]
        ,[volh2sgas]
        ,[volothercompliq]
        ,[volothercompgaseq]
        ,[volothercompgas]
        ,[heat]
        ,[idreccalcset]
        ,[idreccalcsettk]
        ,[syslockmeui]
        ,[syslockchildrenui]
        ,[syslockme]
        ,[syslockchildren]
        ,[syslockdate]
        ,[sysmoddate]
        ,[sysmoduser]
        ,[syscreatedate]
        ,[syscreateuser]
        ,[systag]
	  )
	  SELECT
	     src.[idflownet]
        ,src.[idrecparent]
        ,src.[idrec]
        ,src.[dttm]
        ,src.[year]
        ,src.[month]
        ,src.[dayofmonth]
        ,src.[idrecunit]
        ,src.[idrecunittk]
        ,src.[idreccomp]
        ,src.[idreccomptk]
        ,src.[idreccompzone]
        ,src.[idreccompzonetk]
        ,src.[idrecdispunitnode]
        ,src.[idrecdispunitnodetk]
        ,src.[idrecdispunit]
        ,src.[idrecdispunittk]
        ,src.[volhcliq]
        ,src.[volhcliqgaseq]
        ,src.[volgas]
        ,src.[volwater]
        ,src.[volsand]
        ,src.[volc1liq]
        ,src.[volc1gaseq]
        ,src.[volc1gas]
        ,src.[volc2liq]
        ,src.[volc2gaseq]
        ,src.[volc2gas]
        ,src.[volc3liq]
        ,src.[volc3gaseq]
        ,src.[volc3gas]
        ,src.[volic4liq]
        ,src.[volic4gaseq]
        ,src.[volic4gas]
        ,src.[volnc4liq]
        ,src.[volnc4gaseq]
        ,src.[volnc4gas]
        ,src.[volic5liq]
        ,src.[volic5gaseq]
        ,src.[volic5gas]
        ,src.[volnc5liq]
        ,src.[volnc5gaseq]
        ,src.[volnc5gas]
        ,src.[volc6liq]
        ,src.[volc6gaseq]
        ,src.[volc6gas]
        ,src.[volc7liq]
        ,src.[volc7gaseq]
        ,src.[volc7gas]
        ,src.[voln2liq]
        ,src.[voln2gaseq]
        ,src.[voln2gas]
        ,src.[volco2liq]
        ,src.[volco2gaseq]
        ,src.[volco2gas]
        ,src.[volh2sliq]
        ,src.[volh2sgaseq]
        ,src.[volh2sgas]
        ,src.[volothercompliq]
        ,src.[volothercompgaseq]
        ,src.[volothercompgas]
        ,src.[heat]
        ,src.[idreccalcset]
        ,src.[idreccalcsettk]
        ,src.[syslockmeui]
        ,src.[syslockchildrenui]
        ,src.[syslockme]
        ,src.[syslockchildren]
        ,src.[syslockdate]
        ,src.[sysmoddate]
        ,src.[sysmoduser]
        ,src.[syscreatedate]
        ,src.[syscreateuser]
        ,src.[systag]	    
      FROM
	    #t_t_pvt_pvunitdispmonthday_MERGE src
      WHERE
	    Flag = 'NEW'

	UPDATE [stage_prodview].[t_pvt_pvunitdispmonthday]
    SET 	 
       [stage_prodview].[t_pvt_pvunitdispmonthday].[idrecparent]					= UPD.[idrecparent]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[year]							= UPD.[year]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[month]							= UPD.[month]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[dayofmonth]					= UPD.[dayofmonth]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idrecunit]						= UPD.[idrecunit]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idrecunittk]					= UPD.[idrecunittk]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idreccomp]						= UPD.[idreccomp]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idreccomptk]					= UPD.[idreccomptk]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idreccompzone]					= UPD.[idreccompzone]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idreccompzonetk]				= UPD.[idreccompzonetk]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idrecdispunitnode]				= UPD.[idrecdispunitnode]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idrecdispunitnodetk]			= UPD.[idrecdispunitnodetk]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idrecdispunit]					= UPD.[idrecdispunit]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idrecdispunittk]				= UPD.[idrecdispunittk]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volhcliq]						= UPD.[volhcliq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volhcliqgaseq]					= UPD.[volhcliqgaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volgas]						= UPD.[volgas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volwater]						= UPD.[volwater]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volsand]						= UPD.[volsand]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc1liq]						= UPD.[volc1liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc1gaseq]					= UPD.[volc1gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc1gas]						= UPD.[volc1gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc2liq]						= UPD.[volc2liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc2gaseq]					= UPD.[volc2gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc2gas]						= UPD.[volc2gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc3liq]						= UPD.[volc3liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc3gaseq]					= UPD.[volc3gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc3gas]						= UPD.[volc3gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volic4liq]						= UPD.[volic4liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volic4gaseq]					= UPD.[volic4gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volic4gas]						= UPD.[volic4gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volnc4liq]						= UPD.[volnc4liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volnc4gaseq]					= UPD.[volnc4gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volnc4gas]						= UPD.[volnc4gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volic5liq]						= UPD.[volic5liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volic5gaseq]					= UPD.[volic5gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volic5gas]						= UPD.[volic5gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volnc5liq]						= UPD.[volnc5liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volnc5gaseq]					= UPD.[volnc5gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volnc5gas]						= UPD.[volnc5gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc6liq]						= UPD.[volc6liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc6gaseq]					= UPD.[volc6gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc6gas]						= UPD.[volc6gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc7liq]						= UPD.[volc7liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc7gaseq]					= UPD.[volc7gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volc7gas]						= UPD.[volc7gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[voln2liq]						= UPD.[voln2liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[voln2gaseq]					= UPD.[voln2gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[voln2gas]						= UPD.[voln2gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volco2liq]						= UPD.[volco2liq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volco2gaseq]					= UPD.[volco2gaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volco2gas]						= UPD.[volco2gas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volh2sliq]						= UPD.[volh2sliq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volh2sgaseq]					= UPD.[volh2sgaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volh2sgas]						= UPD.[volh2sgas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volothercompliq]				= UPD.[volothercompliq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volothercompgaseq]				= UPD.[volothercompgaseq]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[volothercompgas]				= UPD.[volothercompgas]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[heat]							= UPD.[heat]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idreccalcset]					= UPD.[idreccalcset]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[idreccalcsettk]				= UPD.[idreccalcsettk]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[syslockmeui]					= UPD.[syslockmeui]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[syslockchildrenui]				= UPD.[syslockchildrenui]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[syslockme]						= UPD.[syslockme]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[syslockchildren]				= UPD.[syslockchildren]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[syslockdate]					= UPD.[syslockdate]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[sysmoddate]					= UPD.[sysmoddate]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[sysmoduser]					= UPD.[sysmoduser]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[syscreatedate]					= UPD.[syscreatedate]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[syscreateuser]					= UPD.[syscreateuser]
      ,[stage_prodview].[t_pvt_pvunitdispmonthday].[systag]						= UPD.[systag]
    FROM #t_t_pvt_pvunitdispmonthday_MERGE UPD
	WHERE
      [stage_prodview].[t_pvt_pvunitdispmonthday].[idflownet] = UPD.[idflownet] AND
	  [stage_prodview].[t_pvt_pvunitdispmonthday].[idrec] = UPD.[idrec] AND
	  [stage_prodview].[t_pvt_pvunitdispmonthday].[dttm]	= UPD.[dttm] AND
	  UPD.Flag = 'UPDATE'		
      --	
      --
	--SET @rowcnt = @@ROWCOUNT

   -- COMMIT TRANSACTION       
   
 END TRY
 
 BEGIN CATCH        
       -- Grab error information from SQL functions
		DECLARE @ErrorSeverity INT	= ERROR_SEVERITY()
				,@ErrorNumber INT	= ERROR_NUMBER()
				,@ErrorMessage nvarchar(4000)	= ERROR_MESSAGE()
				,@ErrorState INT = ERROR_STATE()
				--,@ErrorLine  INT = ERROR_LINE()
				,@ErrorProc nvarchar(200) = ERROR_PROCEDURE()
				
		-- If the error renders the transaction as uncommittable or we have open transactions, rollback
		--IF @@TRANCOUNT > 0
		--BEGIN
		--	ROLLBACK TRANSACTION
		--END
		RAISERROR (@ErrorMessage , @ErrorSeverity, @ErrorState, @ErrorNumber)     

  END CATCH
 -- RETURN @@ERROR
END