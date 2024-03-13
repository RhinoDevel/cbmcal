#RetroDevStudio.MetaData.BASIC:2049,BASIC V2,uppercase,10,10
1000 REM --- OTHER GLOBAL VARS. ---
1050 DIM DW(11):REM FOR WEEKDAY-BY-DATE
1100 DIM WD$(6):REM THE WEEKDAYS
1150 DIM MD(11):REM NON-LEAP MONTH DAYS
1200 I=0:J=0:REM COUNTERS
1250 B0=0:B1=0:B2=0:REM NUMBER BUFFERS
1300 IN$="":REM FOR USER INPUT
1350 CO$="":REM STORES A USER COMMAND
1400 YE$="":MO$="":DA$="":REM A DATE.
1450 YE=2024:MO=3:DA=0:REM DATE AS INTS.
1500 WD=0:REM INDEX INTO WD$.
1550 REM --- INIT "CONSTANTS" ---
1600 FOR I=0 TO 11:READ DW(I):NEXT I
1650 FOR I=0 TO 6:READ WD$(I):NEXT I
1700 FOR I=0 TO 11:READ MD(I):NEXT I
1750 REM --- JUMP TO MAIN ---
1800 GOTO 5050
1850 REM --- SUBROUTINES ---
1900 REM *** LEAP YEAR YES/NO TO B2 ***
1950 IF YE/100<>INT(YE/100) GOTO 2100
2000 IF YE/400=INT(YE/400) GOTO 2150
2050 B2=0:RETURN:REM NOT A LEAP YEAR
2100 IF YE/4<>INT(YE/4) GOTO 2050
2150 B2=1:RETURN:REM IT IS A LEAP YEAR
2200 REM *** PRINT MONTH ***
2250 REM TITLE ROW (THE WEEKDAYS):
2300 PRINT " ";
2350 FOR I=0 TO 5
2400 PRINT WD$(I);"  ";
2450 NEXT I
2500 PRINT WD$(6)
2550 REM 1ST (MAYBE INCOMPL.) DAY ROW:
2600 PRINT " ";
2650 FOR I=0 TO 5
2700 IF I>=WD THEN 2800
2750 PRINT "   ";:GOTO 2850
2800 PRINT I-WD+1;" ";
2850 NEXT I
2900 PRINT I-WD+1;" "
2950 REM FOLLOWING (COMPLETE) DAY ROWS:
3000 B0=I-WD+1+1
3050 B1=MD(MO-1)
3100 IF MO<>2 THEN 3300:REM NO FEBRUARY
3150 GOSUB1950:REM IS A LEAP YEAR?
3200 IF B2=0 THEN 3300:REM NO LEAP YEAR
3250 B1=B1+1:REM 29 DAYS IN FEBRUARY
3300 J=0
3350 FOR I=B0 TO B1
3400 IF I<10 THEN PRINT " ";
3450 PRINT I;
3500 J=J+1
3550 IF J<7 THEN 3700
3600 PRINT""
3650 J=0
3700 NEXT I
3750 PRINT""
3800 RETURN
3850 REM *** FILL WD BY YE,MO & DA ***
3900 B0=YE
3950 IF MO<3 THEN B0=B0-1
4000 WD=B0+INT(B0/4)
4050 WD=WD-INT(B0/100)
4100 WD=WD+INT(B0/400)
4150 WD=WD+DW(MO-1)+DA
4200 WD=WD-INT(WD/7)*7
4250 WD=WD+6:WD=WD-INT(WD/7)*7
4300 RETURN
4350 REM *** MONTH FROM INPUT CMD. ***
4400 YE$=MID$(IN$,2,4)
4450 MO$=MID$(IN$,6,2)
4500 REM *** MONTH FROM YE$ AND MO$ ***
4550 YE=VAL(YE$)
4600 MO=VAL(MO$)
4650 REM *** MONTH FROM YE AND MO ***
4700 DA=1
4750 GOSUB 3900:REM FILLS WD
4800 GOSUB 2300:REM PRINTS MONTH
4850 RETURN
4900 REM --------------------
4950 REM --- MAIN ROUTINE ---
5000 REM --------------------
5050 PRINT"":GOSUB 4700
5100 INPUT"";IN$:REM READS COMMANDLINE
5150 CO$=LEFT$(IN$,1):REM GETS COMMAND
5200 IF CO$<>"M" THEN 5300
5250 GOSUB 4400:GOTO 5100
5300 IF CO$<>"Q" THEN 5400
5350 END
5400 GOTO 5100
5450 END
5500 REM --- DATA ---
5550 REM FOR WEEKDAY-BY-DATE CALC.:
5600 DATA 0,3,2,5,0,3,5,1,4,6,2,4
5650 REM FOR WEEKDAY ITERATION:
5700 DATA MO,TU,WE,TH,FR,SA,SU
5750 REM DAYS OF MONTH (NON-LEAP YEAR)
5800 DATA 31,28,31,30,31,30,31,31,30,31,30,31