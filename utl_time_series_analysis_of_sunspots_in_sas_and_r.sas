Time Series Analysis of Sunspots in SAS and R

github
https://github.com/rogerjdeangelis/utl_time_series_analysis_of_sunspots_in_sas_and_r

 Two Solutions

   1. SAS Proc UCM
   2. WPS/R or IML/R

proc autoreg and proc tscsreg not found

Original Topic: Estimating the next 25 years of Sunspot Activity.

The SAS UCM procedure seems more sophisticated than anything I could find in R.
However this may not be true.

github
https://tinyurl.com/ya44pphe
https://communities.sas.com/t5/SAS-Procedures/proc-autoreg-and-proc-tscsreg-not-found/m-p/452176

INPUT
=====

SD1.HAVE total obs=289

   YEAR    SUNSPOTS

   1729         5
   1730        11
   1731        16
   1732        23
   1733        36
   1734        58
 ...
 ...
   2014      17.9
   2015      13.4
   2016      29.2
   2017     100.2


PROCESS
=======

* enhanced autoreg;
ods exclude all;
ods output FitSummary        = FitSummary        ;
ods output ParameterEstimates= ParameterEstimates;
ods output FitStatistics     = FitStatistics     ;
ods output Forecasts         = Forecasts         ;
proc ucm data=sd1.have ;
    model sunspots;
    level;
    cycle /* period=11 */;
    forecast lead=25 ;
 run;quit;
ods select all;


%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
libname hlp "C:\Program_Files\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
have<-read_sas("d:/sd1/have.sas7bdat")[,2];
head(have);
sunspots<-sunspot.year;
sunspot <- ar(have$SUNSPOTS,method="burg");
str(sunspot);
want<-predict(sunspot, n.ahead = 25);
str(want);
endsubmit;
import r=want  data=wrk.want;
run;quit;
');


OUTPUT
======                   SUNSPOTS

         R         SAS         R       SAS             SAS
        ====     =======      ====    ======     =================
YEAR    PRED     FORECAST      SE     STDERR     LOWERCL    UPPERCL

1993   139.661    141.074   14.9172  15.6064     110.486    171.662
1994   152.645    160.254   22.9503  24.3157     112.596    207.912
1995   137.349    153.338   26.9549  29.6120      95.300    211.377
1996   107.750    125.088   27.7812  31.7308      62.897    187.279
1997    71.883     86.977   27.8375  32.0268      24.205    149.748
1998    39.575     52.711   27.9058  32.0749     -10.154    115.577
1999    18.171     33.426   28.0871  32.4537     -30.182     97.034
2000    11.797     34.188   28.2410  32.7536     -30.008     98.384
2001    29.918     52.865   28.3089  32.7614     -11.346    117.076
2002    63.014     81.515   28.3857  33.0884      16.663    146.367
2003    96.929    109.595   29.2343  34.4778      42.020    177.170
2004   117.056    127.739   31.0090  36.7659      55.679    199.798
2005   118.284    130.790   32.6124  39.0060      54.339    207.240
2006   101.806    119.137   33.4043  40.4329      39.890    198.384
2007    74.759     98.066   33.5419  40.9792      17.749    178.384
2008    46.158     75.527   33.5503  41.0603      -4.950    156.004
2009    24.305     59.216   33.6972  41.0610     -21.262    139.695
2010    16.347     54.024   33.9159  41.0723     -26.477    134.524
2011    24.767     60.650   34.0191  41.0749     -19.856    141.155
2012    46.088     75.766   34.0195  41.2108      -5.006    156.537
2013    71.618     93.506   34.2144  41.7347      11.708    175.305
2014    91.765    107.675   34.7995  42.7102      23.965    191.386
2015    99.553    113.854   35.5461  43.8736      27.863    199.845
2016    93.047    110.717   36.0596  44.8470      22.819    198.616
2017    75.301    100.190   36.2198  45.4299      11.149    189.231


*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
 retain year;
 * year is not correct;
 input sunspots @@;
 year=1728+_n_;
cards4;
5 11 16 23 36 58 29 20 10 8 3 0 0 2 11
27 47 63 60 39 28 26 22 11 21 40 78 122 103 73
47 35 11 5 16 34 70 81 111 101 73 40 20 16 5
11 22 40 60 80.9 83.4 47.7 47.8 30.7 12.2 9.6 10.2 32.4 47.6 54
62.9 85.9 61.2 45.1 36.4 20.9 11.4 37.8 69.8 106.1 100.8 81.6 66.5 34.8 30.6
7 19.8 92.5 154.4 125.9 84.8 68.1 38.5 22.8 10.2 24.1 82.9 132 130.9 118.1
89.9 66.6 60 46.9 41 21.3 16 6.4 4.1 6.8 14.5 34 45 43.1 47.5
42.2 28.1 10.1 8.1 2.5 0 1.4 5 12.2 13.9 35.4 45.8 41.1 30.1 23.9
15.6 6.6 4 1.8 8.5 16.6 36.3 49.6 64.2 67 70.9 47.8 27.5 8.5 13.2
56.9 121.5 138.3 103.2 85.7 64.6 36.7 24.2 10.7 15 40.1 61.5 98.5 124.7 96.3
66.6 64.5 54.1 39 20.6 6.7 4.3 22.7 54.8 93.8 95.8 77.2 59.1 44 47
30.5 16.3 7.3 37.6 74 139 111.2 101.6 66.2 44.7 17 11.3 12.4 3.4 6
32.3 54.3 59.7 63.7 63.5 52.2 25.4 13.1 6.8 6.3 7.1 35.6 73 85.1 78
64 41.8 26.2 26.7 12.1 9.5 2.7 5 24.4 42 63.5 53.8 62 48.5 43.9
18.6 5.7 3.6 1.4 9.6 47.4 57.1 103.9 80.6 63.6 37.6 26.1 14.2 5.8 16.7
44.3 63.9 69 77.8 64.9 35.7 21.2 11.1 5.7 8.7 36.1 79.7 114.4 109.6 88.8
67.8 47.5 30.6 16.3 9.6 33.2 92.6 151.6 136.3 134.7 83.9 69.4 31.5 13.9 4.4
38 141.7 190.2 184.8 159 112.3 53.9 37.5 27.9 10.2 15.1 47 93.8 105.9 105.5
104.5 66.6 68.9 38 34.5 15.5 12.6 27.5 92.5 155.4 154.7 140.5 115.9 66.6 45.9
17.9 13.4 29.2 100.2
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

SAS
===

* enhanced autoreg;
ods exclude all;
ods output FitSummary        = FitSummary        ;
ods output ParameterEstimates= ParameterEstimates;
ods output FitStatistics     = FitStatistics     ;
ods output Forecasts         = Forecasts         ;
proc ucm data=sd1.have ;
    model sunspots;
    level;
    cycle /* period=11 */;
    forecast lead=25 ;
 run;quit;
ods select all;

/*
  _GROUP_    OBS    FORECAST     STDERR     LOWERCL    UPPERCL

  Results    290     141.074    15.6064     110.486    171.662
  Results    291     160.254    24.3157     112.596    207.912
  Results    292     153.338    29.6120      95.300    211.377
  Results    293     125.088    31.7308      62.897    187.279
  Results    294      86.977    32.0268      24.205    149.748
  Results    295      52.711    32.0749     -10.154    115.577
*/


WPS R
=====

%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
libname hlp "C:\Program_Files\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
have<-read_sas("d:/sd1/have.sas7bdat");
head(have);
sunspots<-sunspot.year;
sunspot <- ar(sunspot.year,method="burg");
str(sunspot);
predict(sunspot, n.ahead = 25);
want<-as.data.frame(sunspot);
endsubmit;
import r=sunspots  data=wrk.want;
run;quit;
');


WORK.want total obs=25

Obs      PRED        SE

  1    139.661    14.9172
  2    152.645    22.9503
  3    137.349    26.9549
  4    107.750    27.7812
  5     71.883    27.8375
  6     39.575    27.9058
  7     18.171    28.0871

