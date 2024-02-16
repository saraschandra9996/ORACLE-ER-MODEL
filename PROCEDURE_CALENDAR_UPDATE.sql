CREATE  OR REPLACE  PROCEDURE PRC_CALENDAR_UPDATE(I_MIN_DATE_KEY INTEGER, I_MAX_DATE_KEY INTEGER)
AS 


BEGIN 
	FOR I IN (		SELECT  TO_CHAR(TO_DATE(I_MIN_DATE_KEY,'YYYYMMDD')+LEVEL-1,'YYYYMMDD') AS I_IN_DATE FROM  DUAL
					CONNECT BY  LEVEL <=TO_DATE(I_MAX_DATE_KEY,'YYYYMMDD')-TO_DATE(I_MIN_DATE_KEY,'YYYYMMDD')+1 
			 )
	
	LOOP 
	     EXECUTE IMMEDIATE ' INSERT INTO DIM_DATE
	          select 
                to_date('||I.I_IN_DATE||',''yyyymmdd'') as D_DATE,
                to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''YYYY'') as CALENDARYEAR,
                CASE WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 1 AND 6 THEN  ''H1'' ELSE ''H2'' END CALENDARHALFYEAR,
                CASE WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 1  AND 3 THEN ''Q1''
                     WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 4  AND 6 THEN ''Q2''
                     WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 7  AND 9 THEN ''Q2''
                     WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 10  AND 12 THEN ''Q4'' END CALENDARQUARTER,
                to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''Month'') as CALENDARMONTH,
                ''Week ''||to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''ww'') as CALENDARWEEK,
                to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''Day'') as  CALENDARDAYOFWEEK,
                to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''yyyy'') as FISCALYEAR,
                CASE WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 1 AND 6 THEN  ''H1'' ELSE ''H2'' END FISCALHALFYEAR,
                CASE WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 1  AND 3 THEN ''Q1''
                     WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 4  AND 6 THEN ''Q2''
                     WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 7  AND 9 THEN ''Q2''
                     WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') BETWEEN 10  AND 12 THEN ''Q4'' END FISCALQUARTER,
                ''Month ''||to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''MM'') as FISCALMONTH,
                CASE WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''Day'') IN (''Monday   '',''Tuesday  '',''Wednesday'',''Thursday '',''Friday   '') THEN ''WorkDay''
                     WHEN to_char(to_date('||I.I_IN_DATE||',''yyyymmdd''),''Day'') IN (''Saturday '',''Sunday   '')  THEN  ''WeekEnd'' END  as ISWORKDAY,
                null as EUROPESEASON,
                null as NORTHAMERICASEASON,
                null as ASIASEASON
                from  dual';
	 
			COMMIT;
	
	
	END LOOP;
END;
