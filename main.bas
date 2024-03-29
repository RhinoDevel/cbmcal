#RetroDevStudio.MetaData.BASIC:2049,BASIC V2,uppercase,10,10
1000 REM ---------------------------
1010 REM --- CONFIG.GLOBAL VARS. ---
1020 REM ---------------------------
1030 CF$="CBMCAL-CONF":REM CONFIG.FILE
1040 DE=8:REM DISK DEVICE NR. (8,9,..)
1050 DD$="0":REM DISK DRV. NR. (0 OR 1)
1060 YE=2024:REM YEAR
1070 MO=3:REM MONTH (1 TO 12)
1080 REM --------------------------
1090 REM --- OTHER GLOBAL VARS. ---
1100 REM --------------------------
1110 DIM DW(11):REM FOR WEEKDAY-BY-DATE
1120 DIM WD$(6):REM THE WEEKDAYS
1130 DIM MD(11):REM NON-LEAP MONTH DAYS
1140 I=0:J=0:REM COUNTERS
1150 B0=0:B1=0:B2=0:REM NUMBER BUFFERS
1160 B0$="":REM STRING BUFFER
1170 IN$="":REM FOR USER INPUT
1180 CO$="":REM STORES A USER COMMAND
1190 YE$="":MO$="":DA$="":REM A DATE.
1200 DA=0:REM DAY
1210 WD=0:REM INDEX INTO WD$.
1220 REM ------------------------
1230 REM --- INIT "CONSTANTS" ---
1240 REM ------------------------
1250 FOR I=0 TO 11:READ DW(I):NEXT I
1260 FOR I=0 TO 6:READ WD$(I):NEXT I
1270 FOR I=0 TO 11:READ MD(I):NEXT I
1280 REM ------------------------------
1290 REM --- OPEN DISK CMD. CHANNEL ---
1300 REM ------------------------------
1310 OPEN15,DE,15
1320 REM --------------------
1330 REM --- JUMP TO MAIN ---
1340 REM --------------------
1350 GOTO 2270
1360 REM -------------------
1370 REM --- SUBROUTINES ---
1380 REM -------------------
1381 REM **************************
1382 REM *** TRY READ CONF.FILE ***
1383 REM **************************
1384 OPEN 2,DE,2,"@"+DD$+":"+CF$+",S,R"
1385 GOSUB 2100
1386 IF B=62 THEN 1416:REM NOT FOUND,OK
1387 IF B=0 THEN 1390
1388 PRINT"ERROR: READ CONF.FILE!";B0
1389 GOTO 1416:REM RETURNS ON ERROR
1390 INPUT#2,DE,DD$,YE,MO 
1416 CLOSE2:RETURN
1417 REM ******************************
1418 REM *** (OVER-)WRITE CONF.FILE ***
1419 REM ******************************
1420 OPEN 2,DE,2,"@"+DD$+":"+CF$+",S,W"
1430 GOSUB 2100
1440 IF B0=0 THEN 1470
1450 PRINT"ERROR: WRITE CONF.FILE!";B0
1460 GOTO 1510:REM RETURNS ON ERROR
1470 PRINT#2,STR$(DE)
1480 PRINT#2,DD$
1490 PRINT#2,STR$(YE)
1500 PRINT#2,STR$(MO)
1510 CLOSE2:RETURN
1520 REM ******************************
1530 REM *** LEAP YEAR YES/NO TO B2 ***
1540 REM ******************************
1550 IF YE/100<>INT(YE/100) GOTO 1580
1560 IF YE/400=INT(YE/400) GOTO 1590
1570 B2=0:RETURN:REM NOT A LEAP YEAR
1580 IF YE/4<>INT(YE/4) GOTO 1570
1590 B2=1:RETURN:REM IT IS A LEAP YEAR
1600 REM *******************
1610 REM *** PRINT MONTH ***
1620 REM *******************
1630 REM TITLE ROW (THE WEEKDAYS):
1640 PRINT " ";
1650 FOR I=0 TO 5
1660 PRINT WD$(I);"  ";
1670 NEXT I
1680 PRINT WD$(6)
1690 REM 1ST (MAYBE INCOMPL.) DAY ROW:
1700 PRINT " ";
1710 FOR I=0 TO 5
1720 IF I>=WD THEN 1740
1730 PRINT "   ";:GOTO 1750
1740 PRINT I-WD+1;" ";
1750 NEXT I
1760 PRINT I-WD+1;" "
1770 REM FOLLOWING (COMPLETE) DAY ROWS:
1780 B0=I-WD+1+1
1790 B1=MD(MO-1)
1800 IF MO<>2 THEN 1840:REM NO FEBRUARY
1810 GOSUB1550:REM IS A LEAP YEAR?
1820 IF B2=0 THEN 1840:REM NO LEAP YEAR
1830 B1=B1+1:REM 29 DAYS IN FEBRUARY
1840 J=0
1850 FOR I=B0 TO B1
1860 IF I<10 THEN PRINT " ";
1870 PRINT I;
1880 J=J+1
1890 IF J<7 THEN 1920
1900 PRINT""
1910 J=0
1920 NEXT I
1930 PRINT""
1940 RETURN
1950 REM *****************************
1960 REM *** FILL WD BY YE,MO & DA ***
1970 REM *****************************
1980 B0=YE
1990 IF MO<3 THEN B0=B0-1
2000 WD=B0+INT(B0/4)
2010 WD=WD-INT(B0/100)
2020 WD=WD+INT(B0/400)
2030 WD=WD+DW(MO-1)+DA
2040 WD=WD-INT(WD/7)*7
2050 WD=WD+6:WD=WD-INT(WD/7)*7
2060 RETURN
2070 REM ******************************
2080 REM *** READ DISK ERR. CHANNEL ***
2090 REM ******************************
2100 INPUT#15,B0,B0$,B1,B2:RETURN
2110 REM *****************************
2120 REM *** MONTH FROM INPUT CMD. ***
2130 REM *****************************
2140 YE$=MID$(IN$,2,4)
2150 MO$=MID$(IN$,6,2)
2160 REM *** MONTH FROM YE$ AND MO$ ***
2170 YE=VAL(YE$)
2180 MO=VAL(MO$)
2190 REM *** MONTH FROM YE AND MO ***
2200 DA=1
2210 GOSUB 1980:REM FILLS WD
2220 GOSUB 1640:REM PRINTS MONTH
2230 RETURN
2240 REM --------------------
2250 REM --- MAIN ROUTINE ---
2260 REM -------------------
2270 PRINT""
2271 GOSUB 1384:REM TRY READ CONF.FILE.
2272 GOSUB 2200
2280 INPUT"";IN$:REM READS COMMANDLINE
2290 CO$=LEFT$(IN$,1):REM GETS COMMAND
2300 IF CO$<>"M" THEN 2320
2310 GOSUB 2140:GOTO 2280
2320 IF CO$<>"C" THEN 2325
2322 GOSUB 1420:REM WRITE CONFIG FILE. 
2325 IF CO$<>"Q" THEN 2340
2330 GOTO 2380:REM GOES TO EXIT CODE
2340 GOTO 2280
2350 REM >>>>>>>>><<<<<<<<
2360 REM >>> EXIT CODE <<<
2370 REM >>>>>>>>><<<<<<<<
2380 CLOSE15:END
2390 REM ------------
2400 REM --- DATA ---
2410 REM ------------
2420 REM FOR WEEKDAY-BY-DATE CALC.:
2430 DATA 0,3,2,5,0,3,5,1,4,6,2,4
2440 REM FOR WEEKDAY ITERATION:
2450 DATA MO,TU,WE,TH,FR,SA,SU
2460 REM DAYS OF MONTH (NON-LEAP YEAR)
2470 DATA 31,28,31,30,31,30,31,31,30,31,30,31