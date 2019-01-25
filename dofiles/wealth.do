**********************************************
* wealth
**********************************************

* Wealth：
*	Assets: GSEC14A
*	House: GSEC14A
*	Land: AGSEC2A
*	Livestock: AGSEC6A/B/C


**********************************************
*1. Assets
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC14A.dta", clear
drop if h14q3 == 2 
summarize h14q5 

* clear data and get the total value of assets for each household
drop if h14q5 == . 
collapse (sum) h14q5, by (HHID)
rename h14q5 vassets
rename HHID hh
label variable vassets "total estimated value of assets (in Shs)"
save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\wealth_asset.dta",replace



***********************************************
*2. Land

 
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC2B.dta", clear
summarize a2bq9 a2bq5 a2bq14 a2bq15 // control the size,type and quality
regress a2bq9 a2bq5 i.a2bq14 i.a2bq15
regress a2bq9 a2bq5
/*


      Source |       SS           df       MS      Number of obs   =       852
-------------+----------------------------------   F(6, 845)       =     20.18
       Model |  4.0978e+11         6  6.8297e+10   Prob > F        =    0.0000
    Residual |  2.8599e+12       845  3.3845e+09   R-squared       =    0.1253
-------------+----------------------------------   Adj R-squared   =    0.1191
       Total |  3.2697e+12       851  3.8422e+09   Root MSE        =     58177

----------------------------------------------------------------------------------
           a2bq9 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-----------------+----------------------------------------------------------------
           a2bq5 |   20370.03   1957.966    10.40   0.000     16526.98    24213.08
                 |
          a2bq14 |
Sandy Clay Loam  |    12851.4   4408.261     2.92   0.004     4198.975    21503.83
     Black Clay  |   4117.999   5868.891     0.70   0.483    -7401.315    15637.31
Other (Specify)  |      27165   26290.98     1.03   0.302    -24438.29    78768.29
                 |
          a2bq15 |
           Fair  |   495.2205   4452.348     0.11   0.911    -8243.739     9234.18
           Poor  |  -14778.62   11966.56    -1.23   0.217     -38266.3    8709.059
                 |
           _cons |   22543.67   3981.911     5.66   0.000     14728.07    30359.26
----------------------------------------------------------------------------------



      Source |       SS           df       MS      Number of obs   =       854
-------------+----------------------------------   F(1, 852)       =    109.80
       Model |  3.7369e+11         1  3.7369e+11   Prob > F        =    0.0000
    Residual |  2.8996e+12       852  3.4032e+09   R-squared       =    0.1142
-------------+----------------------------------   Adj R-squared   =    0.1131
       Total |  3.2732e+12       853  3.8373e+09   Root MSE        =     58337

------------------------------------------------------------------------------
       a2bq9 |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
       a2bq5 |   20509.44   1957.245    10.48   0.000     16667.85    24351.03
       _cons |   28210.65   2667.723    10.57   0.000     22974.57    33446.73
------------------------------------------------------------------------------


*/

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC2A.dta", clear
summarize a2aq1owned a2aq5 a2aq16 a2aq17

gen  estimated_value = 10*(28210.65+20509.44*a2aq5)
drop if estimated_value == . 
collapse (sum) estimated_value, by (hh)

* save data
rename estimated_value vland
label variable vland "total estimated value of land (in Shs)"
save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\wealth_land.dta"


*************************************************
* 3. livestock

** Big animals **
* transaction
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6A.dta", clear
summarize HHID LiveStockID a6aq3a a6aq13b a6aq14b

* price 
drop if a6aq14b==. & a6aq13b==.
summarize HHID LiveStockID a6aq3a a6aq13b a6aq14b
collapse (mean) a6aq13b a6aq14b, by (LiveStockID)

rename a6aq13b buyingp
rename a6aq14b sellingp

save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock_price1.dta"

/*
LiveStockID	        buyingp	    sellingp
Exotic/cross-Cal	310000	    400000
Exotic/cross-Bul	323333.3	740000
Exotic/cross-Oxe	.	        900000
Exotic/cross-Hei	640000	    600000
Exotic/cross-Cow	700000	    647777.8
Indigenous-Calve	317500	    278571.4
Indigenous-Bulls	394375	    562903.2
Indigenous-Oxen	    568000	    992500
Indigenous-Heife	262307.7	638571.4
Indigenous-Cows	    413478.3	1011984.1

*/

* merge price into original dta
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6A.dta", clear
merge m:1 LiveStockID using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock_price1.dta"

* calculate the total value
summarize a6aq3a a6aq6 a6aq7 a6aq8 a6aq9 a6aq10 a6aq11 a6aq12 a6aq13a a6aq14a a6aq15
/* compare to the livestock they own, the loss is small */
summarize a6aq14a a6aq14b 

gen transfer = 0
replace transfer = transfer + a6aq9 if a6aq9 !=.
replace transfer = transfer + a6aq8 if a6aq8 !=.

gen LiveStock_vasset = a6aq3a*sellingp // selling price have more data
gen LiveStock_sell = a6aq14a*a6aq14b 
gen LiveStock_buy = a6aq13a*a6aq13b
gen LiveStock_transfer = transfer*sellingp //only 178 obs

collapse (sum) LiveStock_vasset LiveStock_sell LiveStock_buy LiveStock_transfer, by (hh)
label variable LiveStock_vasset "total estimated value of big LiveStock (in Shs)"
label variable LiveStock_sell "total estimated value from selling big LiveStock (in Shs)"
label variable LiveStock_buy "total estimated value from buying big LiveStock (in Shs)"
label variable LiveStock_transfer "total estimated value from big LiveStock transfer(in Shs)"

rename LiveStock_vasset LiveStock_vasset1
rename LiveStock_sell LiveStock_sell1
rename LiveStock_buy LiveStock_buy1
rename LiveStock_transfer LiveStock_transfer1

save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock1.dta",replace


** Small animals **
* get transaction information
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6B.dta", clear
rename ALiveStock_Small_ID LiveStockID
summarize HHID LiveStockID a6bq3a a6bq13b a6bq14b

* get the price 
drop if a6bq14b==. & a6bq13b==.
summarize HHID LiveStockID a6bq3a a6bq13b a6bq14b
collapse (mean) a6bq13b a6bq14b, by (LiveStockID)

rename a6bq13b buyingp
rename a6bq14b sellingp

save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock_price2.dta"

/*
LiveStockID	buyingp	sellingp
Exotic/Cross - Male goats	    70000	    113333.3
Exotic/Cross - Female goats		            177500
Exotic/Cross - Male sheep		
Exotic/Cross - Female sheep		            70000
Exotic/Cross - Pigs	            41666.7	    190000
Indigenous - Male goats	        49473.7	    94258.8
Indigenous - Female goats   	66335.1  	107497.9
Indigenous - Male sheep     	48750	    62500
Indigenous - Female sheep     	59625	    84615.4
Indigenous - Pig	            46847.8  	160380.3


*/

* merge price into original dta
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6B.dta", clear
rename ALiveStock_Small_ID LiveStockID
merge m:1 LiveStockID using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock_price2.dta"

* calculate the total value
summarize a6bq3a a6bq6 a6bq7 a6bq8 a6bq9 a6bq10 a6bq11 a6bq12 a6bq13a a6bq14a a6bq15
summarize a6bq14a a6bq14b 

gen transfer = 0
replace transfer = transfer + a6bq9 if a6bq9 !=.
replace transfer = transfer + a6bq8 if a6bq8 !=.

gen LiveStock_vasset = a6bq3a*sellingp // selling price have more data
gen LiveStock_sell = a6bq14a*a6bq14b
gen LiveStock_buy = a6bq13a*a6bq13b
gen LiveStock_transfer = transfer*sellingp //only 178 obs

collapse (sum) LiveStock_vasset LiveStock_sell LiveStock_buy LiveStock_transfer, by (hh)
label variable LiveStock_vasset "total estimated value of small LiveStock (in Shs)"
label variable LiveStock_sell "total estimated value from selling small LiveStock (in Shs)"
label variable LiveStock_buy "total estimated value from buying small LiveStock (in Shs)"
label variable LiveStock_transfer "total estimated value from small LiveStock transfer(in Shs)"

rename LiveStock_vasset LiveStock_vasset2
rename LiveStock_sell LiveStock_sell2
rename LiveStock_buy LiveStock_buy2
rename LiveStock_transfer LiveStock_transfer2

save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock2.dta",replace


** other animals **
* get transaction information
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6C.dta", clear
rename APCode LiveStockID
summarize hh LiveStockID a6cq3a a6cq13b a6cq14b

* get the price 
drop if a6cq14b==. & a6cq13b==.
summarize hh LiveStockID a6cq3a a6cq13b a6cq14b
collapse (mean) a6cq13b a6cq14b, by (LiveStockID)

rename a6cq13b buyingp
rename a6cq14b sellingp

save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock_price1.dta"

/*
LiveStockID	        buyingp	    sellingp
Indigenous dual-	11767.9  	18478.1
Layers (exotic/c	10600	    9000
Broilers (exotic	21633.3 	101583.3
Other poultry an	19181.8 	29791.7
Rabbits	            5250	    7500
*/

* merge price into original dta
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6C.dta", clear
rename APCode LiveStockID
merge m:1 LiveStockID using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock_price3.dta"

* calculate the total value
summarize a6cq3a a6cq6 a6cq7 a6cq8 a6cq9 a6cq10 a6cq11 a6cq12 a6cq13a a6cq14a a6cq15
/* compare to the livestock they own, the loss is small */
summarize a6cq14a a6cq14b 

gen transfer = 0
replace transfer = transfer + a6cq9 if a6cq9 !=.
replace transfer = transfer + a6cq8 if a6cq8 !=.

gen LiveStock_vasset = a6cq3a*sellingp 
gen LiveStock_sell = a6cq14a*a6cq14b*4 
gen LiveStock_buy = a6cq13a*a6cq13b*4
gen LiveStock_transfer = transfer*sellingp*4 

collapse (sum) LiveStock_vasset LiveStock_sell LiveStock_buy LiveStock_transfer, by (hh)
label variable LiveStock_vasset "total estimated value of other LiveStock (in Shs)"
label variable LiveStock_sell "total estimated value from selling other LiveStock (in Shs)"
label variable LiveStock_buy "total estimated value from buying ohter LiveStock (in Shs)"
label variable LiveStock_transfer "total estimated value from other LiveStock transfer(in Shs)"

rename LiveStock_vasset LiveStock_vasset3
rename LiveStock_sell LiveStock_sell3
rename LiveStock_buy LiveStock_buy3
rename LiveStock_transfer LiveStock_transfer3

save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock3.dta",replace



*********************************************************
*total wealth

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC1.dta", clear
gen hh = HHID
merge 1:1 hh using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\wealth_asset.dta"
drop _merge

merge 1:1 hh using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\wealth_land.dta"
drop _merge

merge 1:1 hh using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock1.dta"
drop _merge

merge 1:1 hh using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock2.dta"
drop _merge

merge 1:1 hh using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\livestock3.dta"
drop _merge


gen wealth =0
replace wealth =. if vassets==.&vland==. &LiveStock_vasset1==.& LiveStock_vasset2==.& LiveStock_vasset3==.
replace vassets =0 if vassets==. & wealth ==0
replace vland =0 if vland==. & wealth ==0
replace LiveStock_vasset1 =0 if LiveStock_vasset1==. & wealth ==0
replace LiveStock_vasset2 =0 if LiveStock_vasset2==. & wealth ==0
replace LiveStock_vasset3 =0 if LiveStock_vasset3==. & wealth ==0
replace wealth = vassets + vland + LiveStock_vasset1 +LiveStock_vasset2 +LiveStock_vasset3

gen lwealth = log(wealth)

label variable wealth "household total wealth (in Shs)"
label variable lwealth "(in log) household total wealth (in Shs)"

keep HHID wealth lwealth
save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\wealth.dta",replace
