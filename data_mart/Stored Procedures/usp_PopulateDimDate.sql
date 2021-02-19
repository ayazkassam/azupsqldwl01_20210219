CREATE PROC [data_mart].[usp_PopulateDimDate] @piStartYear [INT],@piNumYears [INT] AS
BEGIN

   declare @TOTAL_DAYS_IN_A_WEEK integer
   select @TOTAL_DAYS_IN_A_WEEK=7
   declare @BEGIN_OF_TIME_20000101 datetime
   select @BEGIN_OF_TIME_20000101=convert(datetime,'20000101',112)

   declare @li integer
   declare @ld date
   declare @liMonthPrev integer
   declare @liWeekOfYearPrev integer
   declare @liYear integer

   declare @ls varchar(32)
   declare @lsCalendarYear varchar(32)

   declare @liDateKey integer
   declare @dt datetime
   declare @liDayOfMonth integer
   declare @lsDayOfMonthDD varchar(2)
   declare @lsDayWithSuffix varchar(8)
   declare @lsDayOfWeekName varchar(10)
   declare @lsDayOfWeekNameShort varchar(3)
   declare @liDayOfWeekNumber varchar(10)
   declare @liDaysInAWeekCounterForWeekNumber integer
   declare @liDayOfWeekInMonth integer
   declare @liDayOfYear integer
   declare @liWeekOfYear integer
   declare @liWeekOfMonth integer
   declare @liWeekOfYearDD varchar(2)
   declare @ldWeekStartDateFull datetime
   declare @lsWeekStartDateDD_MON_YYYY varchar(12)
   declare @liMonth integer
   declare @lsCalendarMonthName varchar(12)
   declare @lsCalendarMonthNameShort varchar(3)
   declare @lsWeekDayFlag varchar(1)
   declare @lsFirstDayOfCalendarMonthFlag varchar(1)
   declare @lsLastDayOfCalendarMonthFlag varchar(1)

   declare @liCalendarQuarterNumber integer
   declare @lsCalendarQuarterName varchar(8)
   declare @lsCalendarQuarterNameShort varchar(2)

   declare @liDaysSinceBeginingOfTime integer
   declare @liWeeksSinceBeginingOfTime integer
   declare @liMonthsSinceBeginingOfTime integer
   declare @liQuartersSinceBeginingOfTime integer
   declare @liYearsSinceBeginingOfTime integer

   declare @lsHolidayFlag varchar(1)
   declare @lsHolidayDesc varchar(64)
   declare @liCalendarYearNumber integer

   -- initializing
   select @li=0
   select @liYear=@piStartYear
   select @ls=convert(varchar,@liYear)
   select @ls='01 Jan '+@ls+' 00:00:00:000'

   select @dt= convert(datetime,@ls,113)

   select @liMonthPrev=-1
   select @liWeekOfYearPrev=-1

   delete from [data_mart].dim_date

   while (@liYear<@piStartYear+@piNumYears)
   begin
 
	  -- we need key in the format YYYYMMDD
      select @liDateKey=convert(integer,convert(varchar,@dt,112))   

	  -- we need day of month: 1,2....31
	  select @liDayOfMonth=DATEPART(DAY,@dt)                               

	  -- now pad 0 in front so it is in dd format 2 char long string
	  select @ls=convert(varchar,@liDayOfMonth)
	  if @liDayOfMonth<10
	  begin
	     select @lsDayOfMonthDD='0'+@ls
	  end
	  else
	  begin
	     select @lsDayOfMonthDD=@ls
	  end
	  
	  
	  -- day of month as str: "1","2"..."31"
	  select @ls=convert(varchar,@liDayOfMonth)                            

	  -- then organise "1st, 24th,..." and so on
	  select @lsDayWithSuffix=CASE 
                                   WHEN @liDayOfMonth IN (11,12,13) THEN @ls + 'th'
                                   WHEN RIGHT(@liDayOfMonth,1) = 1 THEN @ls + 'st'
                                   WHEN RIGHT(@liDayOfMonth,1) = 2 THEN @ls  + 'nd'
                                   WHEN RIGHT(@liDayOfMonth,1) = 3 THEN @ls + 'rd'
                                   ELSE @ls + 'th' 
                              END
      
	  -- obtain day of week: 1,2....7
	  select @liDayOfWeekNumber=DATEPART(DW,@dt)

	  -- and convert in name
	  select @lsDayOfWeekName=CASE 
                               WHEN @liDayOfWeekNumber=1 THEN 'Sunday'
                               WHEN @liDayOfWeekNumber=2 THEN 'Monday'
                               WHEN @liDayOfWeekNumber=3 THEN 'Tuesday'
                               WHEN @liDayOfWeekNumber=4 THEN 'Wednesday'
                               WHEN @liDayOfWeekNumber=5 THEN 'Thursday'
                               WHEN @liDayOfWeekNumber=6 THEN 'Friday'
                               WHEN @liDayOfWeekNumber=7 THEN 'Saturday'
                          END

	  -- and short (3 char) week name
	  select @lsDayOfWeekNameShort=CASE 
                               WHEN @liDayOfWeekNumber=1 THEN 'Sun'
                               WHEN @liDayOfWeekNumber=2 THEN 'Mon'
                               WHEN @liDayOfWeekNumber=3 THEN 'Tue'
                               WHEN @liDayOfWeekNumber=4 THEN 'Wed'
                               WHEN @liDayOfWeekNumber=5 THEN 'Thu'
                               WHEN @liDayOfWeekNumber=6 THEN 'Fri'
                               WHEN @liDayOfWeekNumber=7 THEN 'Sat'
                          END

      -- and if it is a work day
	  select @lsWeekDayFlag=CASE 
                               WHEN @liDayOfWeekNumber=1 THEN 'N'
                               WHEN @liDayOfWeekNumber=2 THEN 'Y'
                               WHEN @liDayOfWeekNumber=3 THEN 'Y'
                               WHEN @liDayOfWeekNumber=4 THEN 'Y'
                               WHEN @liDayOfWeekNumber=5 THEN 'Y'
                               WHEN @liDayOfWeekNumber=6 THEN 'Y'
                               WHEN @liDayOfWeekNumber=7 THEN 'N'
                          END

	  -- we need month number : 1,2....12
	  select @liMonth=DATEPART(MONTH,@dt)                               

	  -- now dealing with week in a month
	  -- things like third Friday, foutrth monday
	  -- we reset the counters when we start processing new month
	  -- first counter is what we put in the database (1...5)
	  -- second counter grows from 0 to 6, and when reaches 7 it is reset, advancing main counter
	  if @liMonth<>@liMonthPrev
	  begin
	     -- next month, reset the counters
	     select @liDaysInAWeekCounterForWeekNumber=0

		 -- this one will be the same for first seven days in month, then it will be advanced
		 select @liDayOfWeekInMonth=1

		 -- and rest the week in the month... it will grow, but not necessarily after 7 dats, may be earlier
		 -- e.g. if month starts on FrI, it will be the same for two days, Fri and Sat
		 -- but on Sun with a new week it will advance
		 select @liWeekOfMonth=1

	     select @liMonthPrev=@liMonth
	  end
	  else
	  begin
	     -- we on the same month, but check if we arrived to the beginning of the week (SUNDAY, MS week starts on SUNDAY, day 1 of a week)
		 if @liDayOfWeekNumber=1
		 begin
            select @liWeekOfMonth=@liWeekOfMonth+1		    
		 end
	  end
						     
      -- now just the day number in a year (1...365/366)
	  select @liDayOfYear=DATEPART(DY,@dt)

	  -- now just the week number in a year (1....52)
	  select @liWeekOfYear=DATEPART(WEEK,@dt)

 	  -- now pad 0 in front so it is in dd format 2 char long string
	  select @ls=convert(varchar,@liWeekOfYear)
	  if @liWeekOfYear<10
	  begin
	     select @liWeekOfYearDD='0'+@ls
	  end
	  else
	  begin
	     select @liWeekOfYearDD=@ls
	  end

	  -- now month names
      select @lsCalendarMonthName=DATENAME(MONTH,@dt)
      select @lsCalendarMonthNameShort=SUBSTRING(@lsCalendarMonthName,1,3)

	  -- Year Number
	  select @liCalendarYearNumber=DATEPART(YEAR,@dt)
	  select @lsCalendarYear=convert(varchar,@liCalendarYearNumber)

	  -- now check if this is a new week, if so reset the starting date for this week,
	  -- this starting date will be the same for the remainder of the week
	  -- notce how this starting date never goes to the previous year
	  if @liWeekOfYear<>@liWeekOfYearPrev
	  begin
	     select @liWeekOfYearPrev=@liWeekOfYear

		 select @ldWeekStartDateFull=@dt
		 select @lsWeekStartDateDD_MON_YYYY=@lsDayOfMonthDD+'_'+@lsCalendarMonthNameShort+'_'+@lsCalendarYear

	  end

      -- now mark the first day of month
	  if @liDayOfMonth=1
	  begin
	     select @lsFirstDayOfCalendarMonthFlag='Y'
	  end
	  else
	  begin
	     select @lsFirstDayOfCalendarMonthFlag='N'
	  end

      -- now mark the lasst day of month
	  -- first add one day (peek into the future)
      select @ld=DateAdd(day,1,@dt)

	  -- and check if the month is the same on that future date
	  if @liMonth=DATEPART(MONTH,@ld)
	  begin
         select @lsLastDayOfCalendarMonthFlag='N'
	  end
	  else
	  begin
         select @lsLastDayOfCalendarMonthFlag='Y'
	  end
						  
      -- now quarters, first 1,2,3, 4
	  select @liCalendarQuarterNumber=datepart(QUARTER,@dt)

	  --then Q1, Q2, Q3, Q4
      select @lsCalendarQuarterNameShort='Q'+convert(varchar,@liCalendarQuarterNumber)

      -- finally like "Q1 2011"
      select @lsCalendarQuarterName=@lsCalendarQuarterNameShort+' '+@lsCalendarYear
							 
      select @liDaysSinceBeginingOfTime=datediff(dd,@BEGIN_OF_TIME_20000101,@dt)
      select @liWeeksSinceBeginingOfTime=datediff(ww,@BEGIN_OF_TIME_20000101,@dt)
      select @liMonthsSinceBeginingOfTime=datediff(month,@BEGIN_OF_TIME_20000101,@dt)
      select @liQuartersSinceBeginingOfTime=datediff(quarter,@BEGIN_OF_TIME_20000101,@dt)
      select @liYearsSinceBeginingOfTime=datediff(year,@BEGIN_OF_TIME_20000101,@dt)


	  select @lsHolidayFlag='N'
      select @lsHolidayDesc='N/A'

      INSERT [data_mart].dim_date(
                        date_key, 
                        full_DATE,
						day_of_month,
						day_of_month_dd,
						day_of_month_with_suffix,
						day_of_week_name,
						day_of_week_name_short,
						day_of_week_number,
						day_of_Week_in_month,
                        day_of_Year_number,
						week_of_year_number,
						week_of_year_number_dd,
						week_of_month_number,
                        week_start_date_full,
                        week_start_date_dd_mon_yyyy,
						calendar_month_number,
						calendar_month_name,
						calendar_month_name_short,
						weekDay_flag,
						first_Day_of_Calendar_month_flag,
						last_Day_of_Calendar_month_flag,
						calendar_quarter_number,
						calendar_quarter_name,
						calendar_quarter_name_short,
                        calendar_year_number,
						days_since_20000101,
						weeks_since_20000101,
						months_since_20000101,
						quarters_since_20000101,
						years_since_20000101,
						holiday_flag,
						holiday_description
	  )
      VALUES(
                        @liDateKey,
                        @dt,
						@liDayOfMonth,
						@lsDayOfMonthDD,
						@lsDayWithSuffix,
						@lsDayOfWeekName,
						@lsDayOfWeekNameShort,
						@liDayOfWeekNumber,
						@liDayOfWeekInMonth,
						@liDayOfYear,
						@liWeekOfYear,
						@liWeekOfYearDD,
						@liWeekOfMonth,
						@ldWeekStartDateFull,
						@lsWeekStartDateDD_MON_YYYY,
						@liMonth,
						@lsCalendarMonthName,
						@lsCalendarMonthNameShort,
						@lsWeekDayFlag,
						@lsFirstDayOfCalendarMonthFlag,
						@lsLastDayOfCalendarMonthFlag,
						@liCalendarQuarterNumber,
                        @lsCalendarQuarterName,
                        @lsCalendarQuarterNameShort,
						@liCalendarYearNumber,
						@liDaysSinceBeginingOfTime,
						@liWeeksSinceBeginingOfTime,
						@liMonthsSinceBeginingOfTime,
						@liQuartersSinceBeginingOfTime,
						@liYearsSinceBeginingOfTime,
						@lsHolidayFlag,
                        @lsHolidayDesc

	  )

	  -- advance
	  select @li=@li+1
      SELECT @DT  = DATEADD(DD, 1, @dt)

	  -- dont forget to advance/reset day of Week in month business
      select @liDaysInAWeekCounterForWeekNumber=@liDaysInAWeekCounterForWeekNumber+1
	  if @liDaysInAWeekCounterForWeekNumber=@TOTAL_DAYS_IN_A_WEEK
	  begin
	     select @liDaysInAWeekCounterForWeekNumber=0
		 select @liDayOfWeekInMonth=@liDayOfWeekInMonth+1
	  end



	  select @ls=convert(varchar,@dt,112)
	  select @ls=LEFT(@ls,4)
	  select @liYear=convert(int,@ls)
   end

END