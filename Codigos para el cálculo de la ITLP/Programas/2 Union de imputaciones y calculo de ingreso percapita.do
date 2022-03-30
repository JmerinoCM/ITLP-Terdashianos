clear all
cls
set more off 
********************************************************************************
gl temp = "D:\Dataton\Out" 
gl master  = "D:\Dataton\Out" 
gl out  = "D:\Dataton\Out" 
********************************************************************************

********************************************************************************
////////////////////////////////////////////////////////////////////////////////
********************************************************************************

**# Imputacion por Hotdeck

use "C:\pobreza_laboral\temp_master\master_base a imputar.dta", replace
keep if ent == 9
keep  ingocup periodo cd_a female edadg nivel_educ rural ing7c foliop folioh wage_invalid ingocup periodo cd_a

quietly hotdeck ingocup using "$out\A", by(periodo cd_a female edadg nivel_educ rural ing7c) store impute(5) keep(foliop folioh wage_invalid ingocup periodo cd_a) seed(12345)

quietly hotdeck ingocup using "$out\B", by(periodo cd_a female edadg nivel_educ rural) store impute(5) keep(foliop folioh wage_invalid ingocup periodo cd_a) seed(12345)

forval h=1/5 {
quietly use if wage_invalid==1 & ingocup!=. using "$out\A`h'.dta", replace
quietly gen rep=1
quietly append using "$out\B`h'.dta"
quietly replace rep=2 if rep==.
quietly sort foliop periodo cd_a rep
by foliop periodo cd_a: keep if _n==1
quietly save "$out\Data_Hotdeck`h'.dta", replace
}

forval j=2/5 {
quietly use "$out\Data_Hotdeck`j'.dta", clear
quietly rename ingocup ingocup`j'
if `j'==2 {
quietly merge 1:1 foliop folioh periodo cd_a using "$out\Data_Hotdeck1.dta"
rename ingocup ingocup1
tab _merge
drop _merge
quietly save "$out\Data_Hotdeck.dta", replace
}
else {
quietly merge 1:1 foliop folioh periodo cd_a using "$out\Data_Hotdeck.dta"
tab _merge
drop _merge
quietly save "$out\Data_Hotdeck.dta", replace
}
}

use "$out\Data_Hotdeck.dta", clear
keep foliop folioh periodo cd_a ingocup* rep
order foliop folioh periodo cd_a ingocup1 ingocup2 ingocup3 ingocup4 ingocup5 rep 
save "$out\Data_Hotdeck.dta", replace

quietly use "C:\pobreza_laboral\temp_master\master_respaldo.dta", clear
keep if ent == 9
quietly merge 1:1 foliop folioh periodo cd_a using "$out\Data_Hotdeck.dta"
tab _merge
drop _merge
quietly compress
forval j=1/5 {
replace ingocup`j'=ingocup if ingocup>0 & ingocup!=.
}
/*
	gen code_earn=.
	replace code_earn=0 if ingocup==0 & ingocup1==.
	replace code_earn=1 if ingocup==0 & (ingocup1>0 & ingocup1!=.)
	replace code_earn=2 if ingocup>0 & ingocup!=.
	label var code_earn "Codigo Imp"
	label def code_earn 0 "Sin Pago o Fuera FL" 1 "Imputado" 2 "Ing Valido"
	label val code_earn code_earn 
*/

keep foliop folioh periodo ingocup1 ingocup2 ingocup3 ingocup4 ingocup5 sex 
save "$out\imp_hotdeck.dta", replace

********************************************************************************
////////////////////////////////////////////////////////////////////////////////
********************************************************************************


**# IMPUTACION POR MATCHIN

************************************
clear
set obs 1 
gen periodo = . 
save "$out\base_imputada_MM_est.dta",replace 
************************************

* Imputacion por MATCHING MEAN

	use "C:\pobreza_laboral\temp_master\master_base a imputar.dta", clear
	keep if ent == 9
	keep factor folioh foliop periodo ingocup periodo cd_a female edadg nivel_educ rural ing7c
	destring cd_a, replace
	
	save "$temp\master_deducida.dta", replace
	
foreach x in 105 205 305 405 106 206 306 406 107 207 307 407 108 208 308 408 109 209 309 409 110 210 310 410 111 211 311 411 112 212 312 412 113 213 313 413 114 214 314 414 115 215 315 415 116 216 316 416 117 217 317 417 118 218 318 418 119 219 319 419 120 320 420 121 221 {  

	use "$temp\master_deducida.dta", clear
	
	quietly keep if periodo == `x'
	
	drop periodo
	
	mi set wide

	*Todas las variables de la base que no se van a imputar
	mi register regular factor folioh foliop

	*La variabl de imputación
	mi register imputed ingocup

	*Este es el comando de imputacion
	
	mi impute pmm ingocup cd_a female edadg nivel_educ rural ing7c, add(5) knn(5) 

	gen periodo = `x'
	
	quietly save "$out\base_imputada_MM_`x'.dta", replace 
	
}

* error para 2021

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

foreach x in 105 205 305 405 106 206 306 406 107 207 307 407 108 208 308 408 109 209 309 409 110 210 310 410 111 211 311 411 112 212 312 412 113 213 313 413 114 214 314 414 115 215 315 415 116 216 316 416 117 217 317 417 118 218 318 418 119 219 319 419 120 320 420 121 221 { 
	
	quietly use "$out\base_imputada_MM_`x'.dta", clear
	quietly append using "$out\base_imputada_MM_est.dta",force
	quietly save "$out\base_imputada_MM_est.dta", replace 
	
}

keep folioh foliop *_ingocup periodo

save "$out\imp_MM.dta", replace


********************************************************************************
////////////////////////////////////////////////////////////////////////////////
********************************************************************************

use "C:\pobreza_laboral\temp_master\master_respaldo.dta",clear
keep if ent == 9

merge 1:1 foliop folioh periodo using "$out\imp_hotdeck.dta"
tab _merge
drop _merge
****************************************
merge 1:1 folioh foliop periodo using "$out\imp_MM.dta"
tab _merge
drop _merge

drop if periodo == .

tostring periodo, replace

gen qtr = substr(periodo,1,1)

gen year = substr(periodo,2,3)

replace year = "20" + year


destring qtr year, replace

gen fecha = yq(year,qtr)

format %tq fecha

save "$out\base_master_imputada.dta", replace

********************************************************************************
////////////////////////////////////////////////////////////////////////////////
********************************************************************************

**# Ingreso percapita


*********************************************
clear
set obs 1
gen periodo = .
save "$out\ingreso_percapita.dta",replace
*********************************************

use "$out\base_master_imputada.dta",clear
egen ing_HT = rmean(ingocup1 ingocup2 ingocup3 ingocup4 ingocup5)
egen ingocup_MM = rmean(_1_ingocup _1_ingocup _2_ingocup _3_ingocup _4_ingocup _5_ingocup)
keep ing* folioh factor foliop ent year qtr periodo fecha



destring periodo, replace force

save "$out\base para calcular ingreso percapita.dta", replace
use "$out\base para calcular ingreso percapita.dta", clear


foreach x in 105 205 305 405 106 206 306 406 107 207 307 407 108 208 308 408 109 209 309 409 110 210 310 410 111 211 311 411 112 212 312 412 113 213 313 413 114 214 314 414 115 215 315 415 116 216 316 416 117 217 317 417 118 218 318 418 119 219 319 419 120 320 420 121 221 { 
	
	preserve
	
	keep if periodo == `x'
	
	gen tamh = 1

	collapse (sum) ing_HT ingocup_MM ingreso  tamh (mean) factor ent, by(folioh fecha)
	
	merge m:m fecha using  "$out\base_reales.dta"

	drop if _merge != 3
	drop _merge
	
	replace ingreso = (ingreso/inpc_trim_b2021t1)*100 

	replace ing_HT = (ing_HT/inpc_trim_b2021t1)*100 
	
	replace ingocup_MM = (ingocup_MM/inpc_trim_b2021t1)*100 
	
	gen factorp = factor*tamh 

	gen pob = (ingreso/tamh)
	
	gen pob_HT = (ing_HT/tamh)
	
	gen pob_MM = (ingocup_MM/tamh)

	* ingreso percapita

	sum pob [w=factorp] 

	gen ing_perca =round(r(mean)*100, 0.0001)
	
	sum pob_HT [w=factorp] 

	gen ing_perca_HT =round(r(mean)*100, 0.0001)
	
	sum pob_MM [w=factorp] 

	gen ing_perca_MM =round(r(mean)*100, 0.0001)

	* dividiendo por estado

	foreach y in 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 {  
			sum pob [w=factorp] if ent==`y' 
			gen ing_perca_`y'=r(mean)*100
			format ing_perca_`y' %12.4f
			}
			
	* dividiendo por estado

	foreach y in 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 {  
			sum pob_HT [w=factorp] if ent==`y' 
			gen ing_perca_HT_`y'=r(mean)*100
			format ing_perca_HT_`y' %12.4f
			}
			
	foreach y in 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 {  
			sum pob_MM [w=factorp] if ent==`y' 
			gen ing_perca_MM_`y'=r(mean)*100
			format ing_perca_MM_`y' %12.4f
			}

	gen periodo= `x' 
	keep ing_per* periodo
	keep in 1 

	append using "$temp\ingreso_percapita.dta",force
	save "$temp\ingreso_percapita.dta", replace 
	
	restore
} 

use "$temp\ingreso_percapita.dta", clear

drop if periodo == .

tostring periodo, replace

gen qtr = substr(periodo,1,1)

gen year = substr(periodo,2,3)

replace year = "20" + year

drop periodo

destring qtr year, replace

gen fecha = yq(year,qtr)

format %tq fecha

mi tsset fecha

save "$out\ingreso_percapita_ALL.dta",replace