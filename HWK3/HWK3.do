**************************************************
* Development Economics: HWK3
* Author: Temulun
* Last update: 27/02/2019
**************************************************

 use "E:\Temulun Borjigen\CEMFI\Development Economics\HWK3\dataUGA.dta" , clear

* Question 1. Consumption Insurance Tests

* Step 1: Obtain the residuals

* generate year indicator
gen year1 = substr(wave, 1,4)
destring year1, replace 

* produce residuals
reg lnc age age_sq familysize i.year1 i.ethnic female urban
predict rlnc, residuals

reg lny age age_sq familysize i.year1 i.ethnic female urban
predict rlny, residuals

bysort year1: egen c_bar = mean(ctotal)
gen lnc_bar = log(c_bar)

sort hh year1

* Step 2: produce forward variables for difference
by hh: gen f_rlnc = rlnc[_n+1]
gen delta_rlnc = f_rlnc - rlnc if year1==year1[_n+1]-1
replace delta_rlnc = (f_rlnc- rlnc)/2 if year1==year1[_n+1]-2
replace delta_rlnc = (f_rlnc- rlnc)/3 if year1==year1[_n+1]-3


by hh: gen f_rlny = rlny[_n+1]
gen delta_rlny = f_rlny - rlny if year1==year1[_n+1]-1
replace delta_rlny = (f_rlny- rlny)/2 if year1==year1[_n+1]-2
replace delta_rlny = (f_rlny- rlny)/3 if year1==year1[_n+1]-3

by hh: gen f_lnc_bar = lnc_bar[_n+1]
gen delta_lnc_bar = f_lnc_bar - lnc_bar if year1==year1[_n+1]-1
replace delta_lnc_bar = (f_lnc_bar- lnc_bar)/2 if year1==year1[_n+1]-2
replace delta_lnc_bar = (f_lnc_bar- lnc_bar)/3 if year1==year1[_n+1]-3


* Step 3: regression using residuals grouped by households
* egen hhid = group(hh)
* bysort hhid: reg delta_rlnc delta_rlny delta_lnc_bar

statsby _b, by (hh) saving ("coeff1.dta", replace) : reg delta_rlnc delta_rlny delta_lnc_bar

* Step 4: summary statistics

search univar
* a command to tabulate in a nice way

use "E:\Temulun Borjigen\CEMFI\Development Economics\HWK3\coeff1.dta" , clear

univar _b_delta_rlny _b_delta_lnc_bar

/*

                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny    2291    -0.08     9.83  -345.98    -0.50     0.02     0.56   150.34
_b_delta_lnc_bar    2291     0.66   100.58 -3733.83    -2.53     0.00     3.68  1222.04
-------------------------------------------------------------------------------

*/

set more off
preserve
tab _b_delta_rlny
keep if _b_delta_rlny >= -10 & _b_delta_rlny <= 10
hist  _b_delta_rlny
restore
preserve
tab _b_delta_lnc_bar
keep if _b_delta_lnc_bar >= -50 & _b_delta_lnc_bar <= 50
hist _b_delta_lnc_bar



* Question 2. relationship between insurance and household income/wealth

bysort hh: egen y_bar = mean(inctotal)
gen lny_bar = log(y_bar)

xtile quant_y = lny_bar, nq(5)
duplicates drop lny_bar, force
merge 1:m hh using "E:\Temulun Borjigen\CEMFI\Development Economics\HWK3\coeff1.dta"
univar _b_delta_rlny _b_delta_lnc_bar , by (quant_y)

keep hh lny_bar quant_y _b_delta_rlny _b_delta_lnc_bar
save income_quantile

/*
-> quant_y=1 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny     415     0.46     8.02   -10.88    -0.38    -0.00     0.31   150.34
_b_delta_lnc_bar     415     2.14    42.16  -157.61    -1.11     0.00     4.78   734.16
-------------------------------------------------------------------------------

-> quant_y=2 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny     471     0.43     5.53   -29.05    -0.61     0.07     1.00    68.23
_b_delta_lnc_bar     471     4.06    33.65  -122.52    -1.10     0.00     5.06   455.66
-------------------------------------------------------------------------------

-> quant_y=3 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny     481    -1.22    17.68  -345.98    -0.67     0.02     0.71    52.77
_b_delta_lnc_bar     481    -8.58   186.26 -3733.83    -2.65     0.00     3.89   729.12
-------------------------------------------------------------------------------

-> quant_y=4 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny     457    -0.24     5.38   -62.34    -0.61     0.02     0.56    42.48
_b_delta_lnc_bar     457     2.00    61.38  -600.36    -3.72     0.00     2.91   555.15
-------------------------------------------------------------------------------

-> quant_y=5 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny     462     0.25     5.88   -28.95    -0.29     0.03     0.37    93.62
_b_delta_lnc_bar     462     4.16    86.82  -197.87    -6.12     0.00     2.00  1222.04
-------------------------------------------------------------------------------

*/


gen beta = abs(_b_delta_rlny)
xtile quant_beta = beta, nq(5)

bys quant_beta: summarize lny_bar

/*
-> quant_beta = 1

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
     lny_bar |        459    6.689155      1.3128   2.148524   10.00145

-------------------------------------------------------------------------------------------------
-> quant_beta = 2

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
     lny_bar |        457     6.68643    1.223953   2.236537   10.46197

-------------------------------------------------------------------------------------------------
-> quant_beta = 3

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
     lny_bar |        456    6.795252    1.027594   3.011715   9.302387

-------------------------------------------------------------------------------------------------
-> quant_beta = 4

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
     lny_bar |        457    6.692035    .9456733   3.090533   9.489938

-------------------------------------------------------------------------------------------------
-> quant_beta = 5

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
     lny_bar |        457    6.730599    .8064243   4.224649   9.458678

-------------------------------------------------------------------------------------------------

*/






* Question 3. Uniform coeffcients across households

* pooled regression
reg delta_rlnc delta_rlny delta_lnc_bar

/*

      Source |       SS           df       MS      Number of obs   =     6,355
-------------+----------------------------------   F(2, 6352)      =     18.24
       Model |  9.41472116         2  4.70736058   Prob > F        =    0.0000
    Residual |  1639.56498     6,352  .258117912   R-squared       =    0.0057
-------------+----------------------------------   Adj R-squared   =    0.0054
       Total |   1648.9797     6,354  .259518366   Root MSE        =    .50805

-------------------------------------------------------------------------------
   delta_rlnc |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
--------------+----------------------------------------------------------------
   delta_rlny |   .0436368   .0072875     5.99   0.000     .0293508    .0579227
delta_lnc_bar |   .1259938   .1929982     0.65   0.514    -.2523478    .5043353
        _cons |  -.0027017    .006378    -0.42   0.672    -.0152046    .0098013
-------------------------------------------------------------------------------

*/


* Question 4. separating urban / rural

use "E:\Temulun Borjigen\CEMFI\Development Economics\HWK3\dataUGA.dta" , clear

* generate year indicator
gen year1 = substr(wave, 1,4)
destring year1, replace 

bysort urban: reg lnc age age_sq familysize i.year1 i.ethnic female
predict rlnc1, residuals

bysort urban: reg lny age age_sq familysize i.year1 i.ethnic female
predict rlny1, residuals

bysort year1 urban: egen c_bar1 = mean(ctotal)
gen lnc_bar1 = log(c_bar1)

sort hh year1

by hh: gen f_rlnc1 = rlnc1[_n+1]
gen delta_rlnc1 = f_rlnc1 - rlnc1 if year1==year1[_n+1]-1
replace delta_rlnc1 = (f_rlnc1- rlnc1)/2 if year1==year1[_n+1]-2
replace delta_rlnc1 = (f_rlnc1- rlnc1)/3 if year1==year1[_n+1]-3

by hh: gen f_rlny1 = rlny1[_n+1]
gen delta_rlny1 = f_rlny1 - rlny1 if year1==year1[_n+1]-1
replace delta_rlny1 = (f_rlny1 - rlny1)/2 if year1==year1[_n+1]-2
replace delta_rlny1 = (f_rlny1 - rlny1)/3 if year1==year1[_n+1]-3

by hh: gen f_lnc_bar1 = lnc_bar1[_n+1]
gen delta_lnc_bar1 = f_lnc_bar1 - lnc_bar1 if year1==year1[_n+1]-1
replace delta_lnc_bar1 = (f_lnc_bar1 - lnc_bar1)/2 if year1==year1[_n+1]-2
replace delta_lnc_bar1 = (f_lnc_bar1 - lnc_bar1)/3 if year1==year1[_n+1]-3

* pooled regression urban/rural
bysort urban: reg delta_rlnc1 delta_rlny1 delta_lnc_bar1

/*
-> urban = 0

      Source |       SS           df       MS      Number of obs   =     5,106
-------------+----------------------------------   F(2, 5103)      =     15.85
       Model |  8.08457811         2  4.04228906   Prob > F        =    0.0000
    Residual |  1301.13446     5,103  .254974419   R-squared       =    0.0062
-------------+----------------------------------   Adj R-squared   =    0.0058
       Total |  1309.21904     5,105  .256458186   Root MSE        =    .50495

--------------------------------------------------------------------------------
   delta_rlnc1 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
---------------+----------------------------------------------------------------
   delta_rlny1 |    .041169   .0080258     5.13   0.000     .0254351    .0569029
delta_lnc_bar1 |   .1935228   .0913952     2.12   0.034     .0143489    .3726966
         _cons |   .0033027   .0071521     0.46   0.644    -.0107185    .0173239
--------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-> urban = 1

      Source |       SS           df       MS      Number of obs   =     1,249
-------------+----------------------------------   F(2, 1246)      =     10.27
       Model |  5.28016355         2  2.64008178   Prob > F        =    0.0000
    Residual |  320.377957     1,246  .257125166   R-squared       =    0.0162
-------------+----------------------------------   Adj R-squared   =    0.0146
       Total |  325.658121     1,248  .260944007   Root MSE        =    .50708

--------------------------------------------------------------------------------
   delta_rlnc1 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
---------------+----------------------------------------------------------------
   delta_rlny1 |   .0716629   .0158148     4.53   0.000     .0406364    .1026894
delta_lnc_bar1 |  -.0165752   .0858983    -0.19   0.847    -.1850964     .151946
         _cons |   .0118253   .0144703     0.82   0.414    -.0165636    .0402141
--------------------------------------------------------------------------------

*/


* for each household
statsby _b, by (hh) saving ("coeff2.dta", replace): reg delta_rlnc1 delta_rlny1 delta_lnc_bar1

bysort hh: egen y_bar1 = mean(inctotal)
gen lny_bar1 = log(y_bar)

xtile quant_y1 = lny_bar1 if urban == 1, nq(5)
xtile quant_y2 = lny_bar1 if urban == 0, nq(5)
replace quant_y1 = 0 if quant_y1 ==.
replace quant_y2 = 0 if quant_y2 ==.
gen quant_yy = quant_y1 + quant_y2
drop quant_y1 quant_y2

duplicates drop hh, force
merge 1:m hh using "E:\Temulun Borjigen\CEMFI\Development Economics\HWK3\coeff2.dta"

keep hh lny_bar1 quant_yy _b_delta_rlny1 _b_delta_lnc_bar1 urban

gen beta1 = abs(_b_delta_rlny1)

xtile quant_beta1 = beta1 if urban == 1, nq(5)
xtile quant_beta2 = beta1 if urban == 0, nq(5)
replace quant_beta1 = 0 if quant_beta1 ==.
replace quant_beta2 = 0 if quant_beta2 ==.
gen quant_beta = quant_beta1 + quant_beta2
drop quant_beta1 quant_beta2

bys urban quant_beta: summarize lny_bar1

/*
-> urban = 0, quant_beta = 0

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |        619    6.431029    1.314922   2.247687   10.68505

----------------------------------------------------------------------------------
-> urban = 0, quant_beta = 1

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |        385    6.813031    1.188232   2.148524   9.286873

----------------------------------------------------------------------------------
-> urban = 0, quant_beta = 2

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |        385     6.71978    1.277247   2.236537   10.46197

----------------------------------------------------------------------------------
-> urban = 0, quant_beta = 3

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |        384    6.750813    .9763001   3.011715   9.302387

----------------------------------------------------------------------------------
-> urban = 0, quant_beta = 4

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |        385     6.64637    .9675107   3.090533   9.489938

----------------------------------------------------------------------------------
-> urban = 0, quant_beta = 5

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |        385    6.539118    .7318922   4.625004   8.883994

----------------------------------------------------------------------------------
-> urban = 1, quant_beta = 0

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |        272    6.469471    1.603587   1.667931   10.27524

----------------------------------------------------------------------------------
-> urban = 1, quant_beta = 1

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |         73    6.713667     1.34473   4.012383   10.00145

----------------------------------------------------------------------------------
-> urban = 1, quant_beta = 2

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |         72    6.904795      1.4764   2.725369   8.955928

----------------------------------------------------------------------------------
-> urban = 1, quant_beta = 3

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |         72    6.858207    1.247591   2.481532   9.142644

----------------------------------------------------------------------------------
-> urban = 1, quant_beta = 4

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |         73    6.847664    .9217928   4.068751   8.931662

----------------------------------------------------------------------------------
-> urban = 1, quant_beta = 5

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    lny_bar1 |         72    6.930959    1.055619   4.496962   9.458678

*/


univar _b_delta_rlny _b_delta_lnc_bar, by(urban)

/*
-> urban=0 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1    1927     1.57    85.18 -1067.01    -0.48     0.00     0.48  3518.60
_b_delta_lnc_bar1    1927    10.29   407.63 -3429.60    -0.87     0.00     3.37 16841.27
-------------------------------------------------------------------------------

-> urban=1 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1     364     0.28     4.32   -30.11    -0.56     0.11     0.96    38.89
_b_delta_lnc_bar1     364    -0.01    14.01   -66.97    -0.04     0.00     0.88    95.37
-------------------------------------------------------------------------------


*/



univar _b_delta_rlny1 _b_delta_lnc_bar1 , by (urban quant_yy)

/*
-> urban=0 quant_yy=0 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1       3    -0.05     0.49    -0.56    -0.56     0.00     0.42     0.42
_b_delta_lnc_bar1       3    -0.65     1.13    -1.96    -1.96     0.00     0.00     0.00
-------------------------------------------------------------------------------

-> urban=0 quant_yy=1 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1     352    -0.02     2.04   -18.09    -0.36     0.00     0.38    10.04
_b_delta_lnc_bar1     352     2.14    14.51   -78.18     0.00     0.00     4.00    99.13
-------------------------------------------------------------------------------

-> urban=0 quant_yy=2 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1     393    -2.73    54.04 -1067.01    -0.54     0.04     0.89    34.43
_b_delta_lnc_bar1     393    -7.86   174.62 -3429.60    -0.67     0.00     4.11   136.22
-------------------------------------------------------------------------------

-> urban=0 quant_yy=3 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1     400     0.15     8.17   -26.71    -0.64     0.00     0.59   150.91
_b_delta_lnc_bar1     400     0.61    26.15  -447.26    -0.35     0.00     4.53   124.15
-------------------------------------------------------------------------------

-> urban=0 quant_yy=4 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1     381    10.81   183.22   -27.86    -0.56    -0.00     0.44  3518.60
_b_delta_lnc_bar1     381    58.29   897.92  -185.47    -2.11     0.00     3.90 16841.27
-------------------------------------------------------------------------------

-> urban=0 quant_yy=5 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1     398    -0.15     3.15   -58.77    -0.30     0.00     0.25     9.34
_b_delta_lnc_bar1     398    -0.70    23.98  -179.02    -1.77     0.00     1.11   327.58
-------------------------------------------------------------------------------

-> urban=1 quant_yy=0 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1       2     0.73     0.34     0.49     0.49     0.73     0.96     0.96
_b_delta_lnc_bar1       2     0.00     0.00     0.00     0.00     0.00     0.00     0.00
-------------------------------------------------------------------------------

-> urban=1 quant_yy=1 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1      61    -0.33     5.09   -30.11    -0.59     0.02     0.42    20.01
_b_delta_lnc_bar1      61    -2.41    12.81   -66.97    -3.78     0.00     0.00    24.14
-------------------------------------------------------------------------------

-> urban=1 quant_yy=2 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1      76     1.38     7.29   -21.60    -0.67     0.21     1.72    38.89
_b_delta_lnc_bar1      76    -2.08    14.83   -65.47    -0.40     0.00     2.22    24.36
-------------------------------------------------------------------------------

-> urban=1 quant_yy=3 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1      74     0.07     2.68    -8.75    -0.58     0.16     1.06     8.99
_b_delta_lnc_bar1      74     1.67    17.89   -37.90    -0.61     0.00     2.34    87.94
-------------------------------------------------------------------------------

-> urban=1 quant_yy=4 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1      74     0.24     1.50    -3.36    -0.48     0.04     1.07     4.74
_b_delta_lnc_bar1      74     2.38    13.30   -28.14     0.00     0.00     1.27    95.37
-------------------------------------------------------------------------------

-> urban=1 quant_yy=5 
                                        -------------- Quantiles --------------
Variable       n     Mean     S.D.      Min      .25      Mdn      .75      Max
-------------------------------------------------------------------------------
_b_delta_rlny1      77    -0.09     2.35    -8.76    -0.53     0.01     0.54     9.48
_b_delta_lnc_bar1      77     0.04     9.77   -32.87     0.00     0.00     0.03    43.64
-------------------------------------------------------------------------------

*/


save urban-rural

* Histogram 
preserve
tab _b_delta_rlny
keep if _b_delta_rlny >= -20 & _b_delta_rlny <= 20
twoway (hist _b_delta_rlny1 if urban == 1, color(blue))(hist _b_delta_rlny1 if urban == 0, color(red)), legend(order(1 "Urban" 2 "Rural"))
restore

tab _b_delta_lnc_bar
keep if _b_delta_lnc_bar >= -50 & _b_delta_lnc_bar <= 50
twoway (hist _b_delta_lnc_bar1 if urban == 1, color(blue))(hist _b_delta_lnc_bar1 if urban == 0, color(red)), legend(order(1 "Urban" 2 "Rural"))





