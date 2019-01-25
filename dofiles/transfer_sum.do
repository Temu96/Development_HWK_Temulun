*********************************************

*********************************************

* Transfers: 

* 1. food gifts from consumption Questionnaire 
* Data source: Section 15 | Part B,C,D
* Data file: GSEC15B/BB/C/D
* Variables: 
* 		h15bq11 (food, beverage, tobacco in past 7 days)
* 		h15cq9 (Non-durable and grequently purchased in last 30 days)
* 		h15dq5 (semi and Durable during last 365 days)

* use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC15B.dta", clear
collapse (sum) h15bq11, by (HHID)
save transfer1

* use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC15C.dta" , clear
collapse (sum) h15cq9, by (HHID)
save transfer2

*use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\GSEC15D.dta" , clear
collapse (sum) h15dq5, by (HHID)
save transfer3

*use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\transfer1.dta", clear
merge HHID using transfer2 transfer3
gen food = h15bq11*52
gen nondur = h15cq9*12
gen dur = h15dq5
keep HHID food nondur dur
save transfer_annual

* 2. livestock gifts
* AGSEC6A
* 	a6aq9 (received quantity) * a6aq13b (prices if bought)
*

