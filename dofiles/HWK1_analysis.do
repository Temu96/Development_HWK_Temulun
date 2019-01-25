*****************************************
* HWK1
*****************************************

use "E:\Uganda_ISA_LSMS\13-14\UGA_2013_UNPS_v01_M_STATA8\UGA_2013_UNPS_v01_M_STATA8\CIWtotal.dta" 
tostring urban, gen(urbanid)
destring urbanid, replace
tostring region, gen(regionid)
destring regionid, replace

*****************************************
* Question 1
* 


*inequality ratio
gen ci = logc/logi
gen wi = logw/logi

tabstat c i w, by (urban) stat(mean)
tabstat ci wi, by (urban) stat(mean)
tabstat logc logi logw, by (urban) stat(variance)



*histogram c i w, frequency kdensity by(urban)
twoway (hist logc if urbanid == 1, color(blue))(hist logc if urbanid == 0, color(red)), legend(order(1 "Urban" 2 "Rural"))
twoway (hist logi if urbanid == 1, color(blue))(hist logi if urbanid == 0, color(red)), legend(order(1 "Urban" 2 "Rural"))

*install corr
ssc inst cpcorr

*compute correlation
cpcorr logc logi logw \ logc logi logw
cpcorr logc logi logw \ logc logi logw if urbanid == 1
cpcorr logc logi logw \ logc logi logw if urbanid == 0

*results
*all:
*	  logc    logi    logw
*logc  1.0000
*logi  0.6143  1.0000
*logw  0.5673  0.4267  1.0000

*urban
*        logc    logi    logw
*logc  1.0000
*logi  0.6799  1.0000
*logw  0.6201  0.5088  1.0000

*rural
*        logc    logi    logw
*logc  1.0000
*logi  0.5207  1.0000
*logw  0.5516  0.3761  1.0000

*percentiles
ssc inst pshare

pshare estimate c, p(1 5 10(10)90 95 99) pvar(i) over(urbanid)
est store c1
pshare estimate w, p(1 5 10(10)90 95 99) pvar(i) over(urbanid)
est store w1
esttab c1 w1 using tb_ur.csv

pshare estimate c, p(1 5 10(10)90 95 99) pvar(i)
est store c2
pshare estimate w, p(1 5 10(10)90 95 99) pvar(i)
est store w2
esttab c2 w2 using tb_all.csv

pshare estimate c, pvar(i) over(urbanid)
est store c3
pshare estimate w, pvar(i) over(urbanid)
est store w3
esttab c3 w3 using q_ur.csv

pshare estimate c, pvar(i)
est store c4
pshare estimate w, pvar(i)
est store w4
esttab c4 w4 using q_all.csv


********************************************************
* Question 2
*

gen linmar = log(inmar)
gen lexmar = log(exmar)
tabstat inmar exmar, by (urban) stat(mean)
tabstat linmar lexmar, by (urban) stat(variance)

twoway (hist linmar if urbanid == 1, color(blue))(hist linmar if urbanid == 0, color(red)), legend(order(1 "Urban" 2 "Rural"))
twoway (hist lexmar if urbanid == 1, color(blue))(hist lexmar if urbanid == 0, color(red)), legend(order(1 "Urban" 2 "Rural"))

cpcorr linmar \ logc logi logw
cpcorr linmar \ logc logi logw if urbanid == 1
cpcorr linmar \ logc logi logw if urbanid == 0





********************************************************
* Question 3
*

twoway (histogram logi), by (regurb)

twoway (scatter logw logi) (lfit logw logi), by(region)
twoway (scatter logc logi) (lfit logc logi), by(region)
twoway (scatter inmar logi) (lfit inmar logi), by(region)

twoway (scatter logw logi) (lfit logw logi), by(regurb)
twoway (scatter logc logi) (lfit logc logi), by(regurb)
twoway (scatter inmar logi) (lfit inmar logi), by(regurb)

gen ii = linmar / logi
twoway (scatter ci logi) (lfit ci logi), by(region)
twoway (scatter wi logi) (lfit wi logi), by(region)
twoway (scatter ii logi) (lfit ii logi), by(region)

twoway (scatter ci logi) (lfit ci logi), by(regurb)
twoway (scatter wi logi) (lfit wi logi), by(regurb)
twoway (scatter ii logi) (lfit ii logi), by(regurb)

*ssc inst crossplot
cpcorr logc logi logw \ logc logi logw if regionid == 1
cpcorr logc logi logw \ logc logi logw if regionid == 2
cpcorr logc logi logw \ logc logi logw if regionid == 3
cpcorr logc logi logw \ logc logi logw if regionid == 4








