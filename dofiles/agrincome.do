*****************************************

*****************************************

* Agriculture income (net):
* agriculture production + livestock production - costs

*****************************************
* 1. agriculture production: 2 seasons
*
*		prices: GSEC15B - itmcd (id) h15bq12 (market price)
*
*		using the sold price:
*			AGSEC5A - a5aq8 (total value)
*			AGSEC5A - a5aq7a (quantity sold)
*			priceA = a5aq8 / a5aq7a 
*			*Note that the unit is the same as measurement for harvest
*
*			AGSEC5B - a5bq8 (total value)
*			AGSEC5B - a5bq7a (quantity sold)
*			priceB = a5bq8 / a5bq7a
*
*		SEASON 1: AGSE5A - a5aq6a * priceA
*		SEASON 2: AGSE5B - a5bq6a * priceB
*

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC5A.dta"
keep HHID cropID a5aq8 a5aq7a a5aq6a
preserve
collapse (sum)a5aq8 a5aq7a, by (cropID)
gen priceA = a5aq8/a5aq7a
* This is the selling price of crop avereaged over all sales
save priceA, replace
restore
merge m:1 cropID using priceA
drop _merge
gen agr_prodA = priceA * a5aq6a
collapse (sum) agr_prodA, by (HHID)
save agr_prodA, replace

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC5B.dta"
keep HHID cropID a5bq8 a5bq7a a5bq6a
preserve
collapse (sum)a5bq8 a5bq7a, by (cropID)
gen priceB = a5bq8/a5bq7a
* This is the selling price of crop avereaged over all sales
save priceB, replace
restore
merge m:1 cropID using priceB
drop _merge
gen agr_prodB = priceB * a5bq6a
collapse (sum) agr_prodB, by (HHID)
save agr_prodB, replace

merge 1:m HHID using agr_prodA
egen agr_prod = rowtotal(agr_prodA agr_prodB)
save agr_prod, replace

*****************************************
* 2. Agriculture costs:
*		SEASON1: AGSE3A/4A/5A
*			organic fertilizer - a3aq8
*			chemical - a3aq18
*			pesticides - a3aq27
*			hired labor - a3aq36
*			seed - a4aq15
*			transport - a5aq10
*			
*		SEASON2: AGSE3B/4B/5B
*			organic fertilizer - a3bq8
*			chemical - a3bq18
*			pesticides - a3bq27
*			hired labor - a3bq36
*			seed - a4bq15
*			transport - a5bq10
*		
*		rent - a2bq9 (2 seasons)

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC3A.dta" , clear
collapse (sum)a3aq8 a3aq18 a3aq27 a3aq36, by (HHID)
save inputs

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC4A.dta" , clear
collapse (sum)a4aq15, by (HHID)
save seed

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC5A.dta" , clear
collapse (sum)a5aq10, by (HHID)
save transport

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\inputs.dta" , clear
merge HHID using seed transport
drop _merge _merge1 _merge2
save agrcostA

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC3B.dta" , clear
collapse (sum)a3bq8 a3bq18 a3bq27 a3bq36, by (HHID)
save inputsB

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC4B.dta" , clear
collapse (sum)a4bq15, by (HHID)
save seedB

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC5B.dta" , clear
collapse (sum)a5bq10, by (HHID)
save transportB

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\inputsB.dta" , clear
merge HHID using seedB transportB
drop _merge _merge1 _merge2
save agrcostB, replace

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC2B.dta" , clear
collapse (sum)a2bq9, by (HHID)
save rent, replace

merge m:1 HHID using agrcostA
drop _merge
merge m:1 HHID using agrcostB
drop _merge

egen agr_cost = rowtotal(a3aq8 a3aq18 a3aq27 a3aq36 a4aq15 a5aq10 a3bq8 a3bq18 a3bq27 a3bq36 a4bq15 a5bq10 a2bq9)
save agr_cost, replace

**************************************************
*Net income from agriculture
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\agr_prod.dta" , clear
merge 1:m HHID using agr_cost
drop _merge
gen agr_income = agr_prod - agr_cost
keep HHID agr_income
save agr_income, replace

******************************************
* 3. Livestock production: 
* 		sales alive - AGSEC6A - a6aq14a*a6aq14b (cattle and pack)
*					  AGSEC6B - a6bq14a*a6bq14b (small animals)
*					  AGSEC6C - a6cq14a*a6cq14b (poultry, 3 months)
*		sales meat - AGSEC8A - a8aq5
*		sales milk - AGSEC8B - a8bq9
*		sales eggs - AGSEC8C - a8cq5 (3 months)
*

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6A.dta" , clear
gen cattle = a6aq14a*a6aq14b
collapse (sum)cattle, by (HHID)
save cattle,replace
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6B.dta" , clear
gen smallani = a6bq14a*a6bq14b
collapse (sum)smallani, by (HHID)
save smallani,replace
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6C.dta" , clear
gen poultry = a6cq14a*a6cq14b
collapse (sum)poultry, by (HHID)
gen poultry_y = poultry*4
drop poultry
save poultry
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC8A.dta" , clear
collapse (sum)a8aq5, by(HHID) 
save meat
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC8B.dta" , clear
collapse (sum)a8bq9, by (HHID) 
save milk
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC8C.dta" , clear
gen eggs = a8cq5*4
collapse (sum)eggs, by (HHID) 
save eggs

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\smallani.dta" , clear
merge m:1 HHID using cattle poultry meat milk eggs
egen live_prod_total = rowtotal(cattle smallani poultry_y a8aq5 a8bq9 eggs) 
save livestock_prod

****************************************************
* 4. Livestock costs:
*		hired labor - AGSEC6A - a6aq5c (cattle and pack)
*					  AGSEC6B - a6bq5c (small animals)
*					  AGSEC6C - a6cq5c (poultry, 3 months)
*
*		feeding - AGSEC7 - a7bq2e
*		watering - AGSEC7 - a7bq3f
*		vaccaination - AGSEC7 - a7bq5d
*		deworming - a7bq6c
*		treatment - a7bq7c	

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6A.dta" , clear
collapse (sum)a6aq5c, by (HHID) 
save l_cattle
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6B.dta" , clear
collapse (sum)a6bq5c, by (HHID) 
save l_small
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC6C.dta" , clear
collapse (sum)a6cq5c, by (HHID) 
gen l_poultry = a6cq5c*4
save l_poultry
use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\AGSEC7.dta" , clear
collapse (sum)a7bq2e a7bq3f a7bq5d a7bq6c a7bq7c, by (HHID) 
save live_inputs

merge 1:m HHID using l_poultry
drop _merge
merge 1:m HHID using l_small
drop _merge
merge 1:m HHID using l_cattle
drop _merge
egen live_cost = rowtotal(a6aq5c a6bq5c l_poultry a7bq2e a7bq3f a7bq5d a7bq6c a7bq7c)
save live_cost


****************************************************
* Net income from livestock
merge 1:m HHID using livestock_prod
drop _merge
gen live_income = live_prod_total - live_cost
save live_income


****************************************************
* Computing net income

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\agr_income.dta" , clear
merge 1:m HHID using live_income
drop _merge
gen net_income = live_income + agr_income
keep HHID net_income
save net_income, replace
