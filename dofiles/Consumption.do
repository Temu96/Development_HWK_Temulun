********************************************
*-------------Comsuption-------------------*

*Consumption：
*food, non-durable consumption, durable consumption, education
*

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\UNPS 2013-14 Consumption Aggregate.dta",clear
gen nexp_d = nrrexp30*12
gen cpexp_d = cpexp30*12
label variable nexp_d "nominal household expenditures in market prices & after regional price adjusted annual"
label variable cpexp_d "household expenditures in constant prices after adjusting for regional price"
keep HHID nexp_d cpexp_d
save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\consumption_d.dta",replace

********************************************
* 1. Food consumption 

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC15B.dta", clear
egen consum_food = rowtotal(h15bq5 h15bq7 h15bq9 h15bq11) 
replace consum_food = consum_food / 7 * 365
collapse (sum) consum_food, by (HHID)

label variable consum_food "annual food consumption"
save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\food_consum.dta",replace


********************************************
* 2. Non-durable Gooods and Frequently purchased services
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC15C.dta", clear 

egen consum_nondurable = rowtotal(h15cq5 h15cq7 h15cq9)
replace consum_nondurable = consum_nondurable / 30 * 365
collapse (sum) consum_nondurable, by (HHID)

label variable consum_nondurable "annual nondurable goods consumption"
save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\nondurable_consum.dta", replace


******************************************** 
* 3. durable consumption
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC15D.dta", clear 

egen consum_durable = rowtotal(h15dq3 h15dq4 h15dq5)
collapse (sum) consum_durable, by (HHID)

label variable consum_durable "annual durable goods consumption"
save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\durable_consum.dta", replace


********************************************
* 4. education
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC4.dta", clear

collapse (sum) h4q15g, by(HHID)
rename h4q15g edu

label variable edu "annual education consumption"
save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\edu_consum.dta", replace


********************************************
* Total consumption 

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\consumption_d.dta",clear

duplicates report HHID
duplicates drop HHID, force

merge 1:1 HHID using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\food_consum.dta"
drop _merge

merge 1:1 HHID using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\nondurable_consum.dta"
drop _merge

merge 1:1 HHID using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\durable_consum.dta"
drop _merge

merge 1:1 HHID using "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\edu_consum.dta"
drop _merge

egen nondurable_consum = rowtotal(consum_food consum_nondurable)
summarize nondurable_consum
egen consumption = rowtotal(consum_food consum_nondurable consum_durable)
summarize consumption
egen consumption1 = rowtotal(consum_food consum_nondurable consum_durable edu)
summarize consumption1
label variable nondurable_consum "annual nondurable consumption without education "
label variable consumption "annual consumption without education "
label variable consumption1 "annual consumption with education "

save "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\consumption.dta", replace
