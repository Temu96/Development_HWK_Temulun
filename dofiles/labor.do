***************************************
*-------------- Labor  ---------------*


***** Labor *****

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC8_1.dta", clear

** Labor participation

/* in 7 days： h8q4, h8q6,h8q8,h8q10,h8q12
   in 12 months: h8q5,h8q7,h8q9,h8q11,h8q13
   Not in the labor market: h8q16 NO and h8h17 NO (NO=2)
*/ 

// from 14751 samples, 11790 are 10 years old or above
summarize h8q4 h8q6 h8q8 h8q10 h8q12
generate Work_7 = 3 if  h8q4==.
replace  Work_7 = 0 if (h8q4==2&h8q6==2&h8q8==2&h8q10==2&h8q12==2)  
replace  Work_7 = 1 if (Work_7!=0&Work_7!=2 )
replace  Work_7 = 2 if (h8q16==2&h8q17==2)


/* 
. tab Work_7

     Work_7 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        739        5.01        5.01 no work
          1 |      7,453       50.53       55.54 work
          2 |      3,598       24.39       79.93 not participate
          3 |      2,961       20.07      100.00 < 10 years old
------------+-----------------------------------
      Total |     14,751      100.00

*/

* intensive margin: avg hour/worker
* extensive margin: employment rate

summarize h8q5 h8q7 h8q9 h8q11 h8q13
generate Work_12 = 3 if  h8q5==.
replace  Work_12 = 0 if (h8q5==2&h8q7==2&h8q9==2&h8q11==2&h8q13==2)
replace  Work_12 = 1 if (Work_12!=0&Work_12!=2 )
replace  Work_12 = 2 if (h8q16==2&h8q17==2)



/*
. tab Work_12

    Work_12 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        164        1.11        1.11
          1 |     10,989       74.50       75.61
          2 |      3,598       24.39      100.00
------------+-----------------------------------
      Total |     14,751      100.00

*/



** Work hour per week

/* 
   1) Main job work hour 
      h8q36 a-g which show work hour each day in last week
      h8q30 h8q30b last 12 month    
   2) Second job work hour
      h8q43 last week
	  h8q44 h8q44b  last 12 month
   3) another one 
      h8q52_2 last week 
	  h8q52 h8q52_1 last 12 month
   4) h8q57_2 last week 
      h8q57 h8q57_1 last 12 month      
*/

summarize h8q36a h8q36b h8q36c h8q36d h8q36e h8q36f h8q36g
generate mhour = h8q36a + h8q36b +h8q36c + h8q36d +h8q36e +h8q36f +h8q36g
summarize mhour h8q43 h8q52_2 h8q57_2

generate thour = 0
replace thour = mhour if mhour !=.
replace thour = thour+h8q43 if h8q43 !=.
replace thour = thour+h8q52_2 if h8q52_2 !=.
replace thour = thour+h8q57_2 if h8q57_2 !=.


/* Salary
   Main Job: h8q31a h8q31b and h8q31c is the time cover
   Second Job: h8q45a h8q45b h8q45c(time)
   another one: h8q53a h8q53b h8q53c
   secondary: h8q58a h8q58b h8q58c
*/

/* since thour 's mean is 29, I assume people work 4 days per week.*/

generate Job_value1 =0
replace Job_value1 =. if h8q31a ==. & h8q31b ==.
replace Job_value1 = Job_value1 + h8q31a if h8q31a != .
replace Job_value1 = Job_value1 + h8q31b if h8q31b != .

summarize h8q31a h8q31b h8q31c mhour h8q30a h8q30b
replace Job_value1 = Job_value1*mhour*h8q30a*h8q30b if h8q31c ==1
replace Job_value1 = Job_value1*4*h8q30a*h8q30b if h8q31c ==2
replace Job_value1 = Job_value1*h8q30a*h8q30b if h8q31c ==3
replace Job_value1 = Job_value1*h8q30a if h8q31c ==4


summarize h8q45a h8q45b h8q45c h8q43 h8q44 h8q44b
generate Job_value2 =0
replace Job_value2 =. if h8q45a ==. & h8q45b ==.
replace Job_value2 = Job_value2 + h8q45a if h8q45a != .
replace Job_value2 = Job_value2 + h8q45b if h8q45b != .

replace Job_value2 = Job_value2*h8q43*h8q44*h8q44b if h8q45c ==1
replace Job_value2 = Job_value2*4*h8q44*h8q44b if h8q45c ==2
replace Job_value2 = Job_value2*h8q44*h8q44b if h8q45c ==3
replace Job_value2 = Job_value2*h8q44 if h8q45c ==4


summarize h8q53a h8q53b h8q53c h8q52 h8q52_1 h8q52_2
generate Job_value3 =0
replace Job_value3 =. if h8q53a ==. & h8q53b ==.
replace Job_value3 = Job_value3 + h8q53a if h8q53a != .
replace Job_value3 = Job_value3 + h8q53b if h8q53b != .

replace Job_value3 = Job_value3*h8q52*h8q52_1*h8q52_2 if h8q53c ==1
replace Job_value3 = Job_value3*4*h8q52_1*h8q52_2 if h8q53c ==2
replace Job_value3 = Job_value3*h8q52_1*h8q52_2 if h8q53c ==3
replace Job_value3 = Job_value3*h8q52_1 if h8q53c ==4


summarize h8q58a h8q58b h8q58c h8q57 h8q57_1 h8q57_2
generate Job_value4 =0
replace Job_value4 =. if h8q58a ==. & h8q58b ==.
replace Job_value4 = Job_value4 + h8q58a if h8q58a != .
replace Job_value4 = Job_value4 + h8q58b if h8q58b != .

replace Job_value4 = Job_value4*h8q57*h8q57_1*h8q57_2 if h8q58c ==1
replace Job_value4 = Job_value4*4*h8q57_1*h8q57_2 if h8q58c ==2
replace Job_value4 = Job_value4*h8q57_1*h8q57_2 if h8q58c ==3
replace Job_value4 = Job_value4*h8q57_1 if h8q58c ==4

egen tlaborincome=rowtotal(Job_value1 Job_value2 Job_value3 Job_value4 )

label variable tlaborincome "total labor income annual (Ushs)"
label variable thour "total working hours per week"
label variable Work_12 "last 12 months, work participation"
label variable Work_7 "last 7 days, work participation"

save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\labordata.dta",replace


************************************************
* intensive margin

bys HHID: gen pop=_N
bys HHID: gen tot = sum(thour)
collapse (sum)thour (mean)pop, by (HHID)

gen inmar = thour / pop
save inmar, replace


************************************************
* extensive margin

gen workyes = 1 if Work_12 == 1
replace workyes = 0 if Work_12 != 1
bys HHID: gen worksum = _N
collapse (sum)workyes (mean)worksum, by (HHID)
gen exmar = workyes/worksum
save exmar




















