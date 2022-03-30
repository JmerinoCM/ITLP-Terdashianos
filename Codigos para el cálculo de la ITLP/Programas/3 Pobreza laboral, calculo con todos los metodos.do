clear all
cls
set more off 
********************************************************************************
gl temp = "D:\Dataton\Out" 
gl master  = "D:\Dataton\Out" 
gl out  = "D:\Dataton\Out" 
*********************************************
**# Inicio

*ACTIVAR SI AUN NO SE HA CREADO LA BASE PARA EL CALCULO DE POBREZA
use "$out\base_master_imputada.dta",clear

gen nivel_educ=.
replace nivel_educ=1 if ((cs_p13_1==0) | (cs_p13_1==1) | ////
		(cs_p13_1==2 & cs_p13_2==0) | (cs_p13_1==99) | (cs_p13_1==.))
replace nivel_educ=1 if ((cs_p13_1==2 & (cs_p13_2>=1 & cs_p13_2<6)) | ////
		(cs_p13_1==2 & cs_p13_2==9))
replace nivel_educ=2 if ((cs_p13_1==2 & ////
	(cs_p13_2==6|cs_p13_2==7|cs_p13_2==8)) | ////
	(cs_p13_1==3 & cs_p13_2<=2) | (cs_p13_1==3 & cs_p13_2==9))
replace nivel_educ=3 if ((cs_p13_1==3 & ////
	(cs_p13_2==3 | cs_p13_2==4 |cs_p13_2==5 | cs_p13_2==6)) | ////
	(cs_p13_1==4 & (cs_p13_2<=2 | cs_p13_2==9)))
replace nivel_educ=4 if ((cs_p13_1==4 & ////
	(cs_p13_2==3 | cs_p13_2==4)) | ////
	(cs_p13_1==5 & cs_p13_2<=3) | ////
	(cs_p13_1==7 & cs_p13_2<=3) | (cs_p13_1==6))
replace nivel_educ=5 if ((cs_p13_1==7 & (cs_p13_2>=4)) | ////
	(cs_p13_1==5 & cs_p13_2>3) | (cs_p13_1==8) | (cs_p13_1==9))
	
gen edadg=1 if eda>=20 & eda<=24
replace edadg=2 if eda>=25 & eda<=29
replace edadg=3 if eda>=30 & eda<=34
replace edadg=4 if eda>=35 & eda<=39
replace edadg=5 if eda>=40 & eda<=44
replace edadg=6 if eda>=45 & eda<=49
replace edadg=7 if eda>=50 & eda<=54
replace edadg=8 if eda>=55 & eda<=59
replace edadg=9 if eda>=60 & eda<=64
replace edadg=0 if eda<20
replace edadg=10 if eda>=65 & eda<=70
replace edadg=11 if eda>70

*keep folioh foliop n_ren tamh ing* rururb factor ent sex mun mv ocupado periodo *_ingocup
*destring folioh foliop n_ren tamh ing* rururb factor ent sex mun mv ocupado periodo,replace force

save "$temp\master_IMPUTACIONES_calculo de pobreza.dta",replace

*********************************************
clear
set obs 1
gen periodo = .
save "$temp\pobreza_laboral_THT.dta" , replace
*********************************************
clear
set obs 1
gen periodo = .
save "$temp\pobreza_laboral_TMM.dta" , replace

************************************************
clear
set obs 1
gen periodo = .
save "$temp\pobreza_laboral_TSM.dta" , replace
*********************************************
scalar  uT105 = 712.54  
scalar  rT105 = 492.78  
scalar  uT205 = 741.49  
scalar  rT205 = 520.05  
scalar  uT305 = 740.37  
scalar  rT305 = 516.84  
scalar  uT405 = 736.48  
scalar  rT405 = 510.03  
     
scalar  uT106 = 754.24  
scalar  rT106 = 526.53  
scalar  uT206 = 748.55  
scalar  rT206 = 518.10  
scalar  uT306 = 764.24  
scalar  rT306 = 533.35  
scalar  uT406 = 797.76  
scalar  rT406 = 565.69  
     
scalar  uT107 = 814.70  
scalar  rT107 = 576.48  
scalar  uT207 = 803.92  
scalar  rT207 = 563.70  
scalar  uT307 = 810.79  
scalar  rT307 = 567.70  
scalar  uT407 = 830.52  
scalar  rT407 = 582.76  
     
scalar  uT108 = 839.18  
scalar  rT108 = 585.91  
scalar  uT208 = 858.24  
scalar  rT208 = 601.28  
scalar  uT308 = 875.52  
scalar  rT308 = 614.67  
scalar  uT408 = 906.75  
scalar  rT408 = 640.53  
     
scalar  uT109 = 922.00  
scalar  rT109 = 649.04  
scalar  uT209 = 949.84  
scalar  rT209 = 672.97  
scalar  uT309 = 967.60  
scalar  rT309 = 686.43  
scalar  uT409 = 968.90  
scalar  rT409 = 686.09  
     
scalar  uT110 = 992.68   
scalar  rT110 = 705.17   
scalar  uT210 = 987.38   
scalar  rT210 = 695.86   
scalar  uT310 = 979.48   
scalar  rT310 = 684.99   
scalar  uT410 = 1003.59  
scalar  rT410 = 705.71   
     
scalar  uT111 = 1021.50  
scalar  rT111 = 717.40   
scalar  uT211 = 1022.29  
scalar  rT211 = 717.83   
scalar  uT311 = 1023.17  
scalar  rT311 = 716.93   
scalar  uT411 = 1049.22  
scalar  rT411 = 740.43   
     
scalar  uT112 = 1079.48  
scalar  rT112 = 765.39   
scalar  uT212 = 1089.02  
scalar  rT212 = 770.93   
scalar  uT312 = 1130.09  
scalar  rT312 = 805.72   
scalar  uT412 = 1151.75  
scalar  rT412 = 820.38   
     
scalar  uT113 = 1166.22  
scalar  rT113 = 828.61   
scalar  uT213 = 1177.4   
scalar  rT213 = 837.18   
scalar  uT313 = 1177.99  
scalar  rT313 = 833.37   
scalar  uT413 = 1201.99  
scalar  rT413 = 853.72   
     
scalar  uT114 = 1234.8   
scalar  rT114 = 870.81   
scalar  uT214 = 1223.42  
scalar  rT214 = 854.08   
scalar  uT314 = 1243.83  
scalar  rT314 = 869.82   
scalar  uT414 = 1276.56  
scalar  rT414 = 899.27   
     
scalar  uT115 = 1264.53  
scalar  rT115 = 896.17   
scalar  uT215 = 1268.44  
scalar  rT215 = 901.34   
scalar  uT315 = 1282.51  
scalar  rT315 = 911.38   
scalar  uT415 = 1302.59  
scalar  rT415 = 926.32   
     
scalar  uT116 = 1338.64  
scalar  rT116 = 959.7    
scalar  uT216 = 1329.36  
scalar  rT216 = 947.13   
scalar  uT316 = 1323.88  
scalar  rT316 = 942.81   
scalar  uT416 = 1357.24  
scalar  rT416 = 970.61   
     
scalar  uT117 = 1376.88  
scalar  rT117 = 975.82   
scalar  uT217 = 1410.21  
scalar  rT217 = 1003.88  
scalar  uT317 = 1469.65  
scalar  rT317 = 1053.26  
scalar  uT417 = 1479.05  
scalar  rT417 = 1054.84  
     
scalar  uT118 = 1482.13  
scalar  rT118 = 1052.56  
scalar  uT218 = 1477.31  
scalar  rT218 = 1046.25  
scalar  uT318 = 1510.45  
scalar  rT318 = 1068.21  
scalar  uT418 = 1533.46 
scalar  rT418 = 1091.92 

scalar  uT119 = 1561.64  
scalar  rT119 = 1111.31  
scalar  uT219 = 1561.34  
scalar  rT219 = 1109.07 
scalar  uT319 = 1563.49  
scalar  rT319 = 1109.45 
scalar  uT419 = 1578.72  
scalar  rT419 = 1119.41  

scalar  uT120 = 1625.16  
scalar  rT120 = 1158.80 
scalar  uT320 = 1660.28  
scalar  rT320 = 1191.07  
scalar  uT420 = 1674.65  
scalar  rT420 = 1204.29 

scalar  uT121 = 1684.84 
scalar  rT121 = 1205.15
scalar  uT221 = 1728.83 
scalar  rT221 = 1243.83

************************************************
**# CALCULO DE POBREZA CON HOTDECK
*********************************************

foreach x in 105 205 305 405 106 206 306 406 107 207 307 407 108 208 308 408 109 209 309 409 110 210 310 410 111 211 311 411 112 212 312 412 113 213 313 413 114 214 314 414 115 215 315 415 116 216 316 416 117 217 317 417 118 218 318 418 119 219 319 419 120 320 420 121 221 { 
	 
	use  "$temp\master_IMPUTACIONES_calculo de pobreza.dta", clear
	keep if periodo == "`x'"
	drop ingreso 
	egen ing_HT = rmean(ingocup1 ingocup2 ingocup3 ingocup4 ingocup5)
	rename ing_HT ingreso // ingreso de hotdeck 
	
	quietly  collapse (sum) tamh ingreso mv ocupado (mean)  rururb factor ent sex mun nivel_educ pos_ocu seg_soc  emp_ppal tue_ppal edadg, by(folioh) 
	
	*Se elimina a los hogares que tienen valores perdidos en ingreso

	*replace mv=1 if mv>0 & mv!=.
	*drop if mv==1

	*******************************************************************

	*Parte III COMPARACIÓN DEL INGRESO DEL HOGAR CON EL PROMEDIO DE LA 
	*LÍNEA DE POBREZA EXTREMA POR INGRESOS :

	******************************************************************* 

	gen factorp = factor*tamh 

	gen lpT`x' = cond(rururb==0,uT`x',rT`x') 
	gen pob = cond((ingreso/tamh)<lpT`x',1,0) 
*pobreza total
	sum pob [w=factorp] 
	gen TLP=round(r(mean)*100, 0.0001)
*pobreza urbana
	sum pob [w=factorp] if rururb==0 
	gen TLPu=round(r(mean)*100, 0.0001)
*pobreza rural
	sum pob [w=factorp] if rururb==1 
	gen TLPr=round(r(mean)*100, 0.0001)
*pobreza mujer
	sum pob [w=factorp] if sex==2
	gen TLPmuj=round(r(mean)*100, 0.0001)
*pobreza hombre
	sum pob [w=factorp] if sex==1 
	gen TLPhom=round(r(mean)*100, 0.0001)
*pobreza nivel edu
	sum pob [w=factorp] if nivel_educ == 1
	gen TLPedu1=round(r(mean)*100, 0.0001)

	sum pob [w=factorp] if nivel_educ == 2
	gen TLPedu2=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 3
	gen TLPedu3=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 4
	gen TLPedu4=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 5
	gen TLPedu5=round(r(mean)*100, 0.0001)
	
	
	foreach var in "pos_ocu" "seg_soc" "emp_ppal" "tue_ppal"{
		forvalues i = 0/4{
			sum pob [w=factorp] if `var' == `i'
			gen TLP`var'`i'=round(r(mean)*100, 0.0001)
		}
	}
	
	drop TLPseg_soc4 TLPemp_ppal4 TLPemp_ppal3 TLPtue_ppal4 TLPtue_ppal3
	
	forvalues i = 0/11{
		sum pob [w=factorp] if edadg == `i'
		gen TLPedadg`i'=round(r(mean)*100, 0.0001)
	}

	
	
*pobreza por delegacion
	foreach y in  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 {  
			
			sum pob [w=factorp] if mun==`y' 
			gen TLP`y'=r(mean)*100
			format TLP`y' %6.4f
			}


	keep TLP* 
	keep in 1 
	

*   rename TLP`y' Delegacion
	ren * HT_* // HOTDECK
	
	gen periodo = `x' 
	
	append using "$temp\pobreza_laboral_THT.dta",force
	save "$temp\pobreza_laboral_THT.dta", replace 
} 


************************************************
**# CALCULO DE POBREZA CON MATCHING
*********************************************

foreach x in 105 205 305 405 106 206 306 406 107 207 307 407 108 208 308 408 109 209 309 409 110 210 310 410 111 211 311 411 112 212 312 412 113 213 313 413 114 214 314 414 115 215 315 415 116 216 316 416 117 217 317 417 118 218 318 418 119 219 319 419 120 320 420 121 221 { 
	 
	use  "$temp\master_IMPUTACIONES_calculo de pobreza.dta", clear 
	egen ingocup_MM = rmean(_1_ingocup _1_ingocup _2_ingocup _3_ingocup _4_ingocup _5_ingocup)
	keep if periodo == "`x'"
	drop ingreso
	rename ingocup_MM ingreso // ingreso con matching
	

	
	quietly  collapse (sum) tamh ingreso mv ocupado (mean) rururb factor ent sex mun nivel_educ pos_ocu seg_soc emp_ppal tue_ppal edadg, by(folioh) 
	
	

	*******************************************************************

	*Parte III COMPARACIÓN DEL INGRESO DEL HOGAR CON EL PROMEDIO DE LA 
	*LÍNEA DE POBREZA EXTREMA POR INGRESOS :

	******************************************************************* 

	gen factorp = factor*tamh 

	gen lpT`x' = cond(rururb==0,uT`x',rT`x') 
	gen pob = cond((ingreso/tamh)<lpT`x',1,0) 
*pobreza total
	sum pob [w=factorp] 
	gen TLP=round(r(mean)*100, 0.0001)
*pobreza urbana
	sum pob [w=factorp] if rururb==0 
	gen TLPu=round(r(mean)*100, 0.0001)
*pobreza rural
	sum pob [w=factorp] if rururb==1 
	gen TLPr=round(r(mean)*100, 0.0001)
*pobreza mujer
	sum pob [w=factorp] if sex==2
	gen TLPmuj=round(r(mean)*100, 0.0001)
*pobreza hombre
	sum pob [w=factorp] if sex==1 
	gen TLPhom=round(r(mean)*100, 0.0001)
*pobreza nivel edu
	sum pob [w=factorp] if nivel_educ == 1
	gen TLPedu1=round(r(mean)*100, 0.0001)

	sum pob [w=factorp] if nivel_educ == 2
	gen TLPedu2=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 3
	gen TLPedu3=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 4
	gen TLPedu4=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 5
	gen TLPedu5=round(r(mean)*100, 0.0001)
	
	
	foreach var in pos_ocu seg_soc emp_ppal tue_ppal{
		forvalues i = 0/4{
			sum pob [w=factorp] if `var' == `i'
			gen TLP`var'`i'=round(r(mean)*100, 0.0001)
		}
	}
	
	drop TLPseg_soc4 TLPemp_ppal4 TLPemp_ppal3 TLPtue_ppal4 TLPtue_ppal3
	
		forvalues i = 0/11{
			sum pob [w=factorp] if edadg == `i'
			gen TLPedadg`i'=round(r(mean)*100, 0.0001)
		}


	
*pobreza por delegacion
	foreach y in  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 {  
			
			sum pob [w=factorp] if mun==`y' 
			gen TLP`y'=r(mean)*100
			format TLP`y' %6.4f
			}


	keep TLP* 
	keep in 1 

*   rename TLP`y' Delegacion
	ren * MM_*
	
	gen periodo= `x' 
	
	append using "$temp\pobreza_laboral_TMM.dta",force
	save "$temp\pobreza_laboral_TMM.dta", replace 
} 


************************************************
**# CALCULO DE POBREZA CON SM
*********************************************

foreach x in 105 205 305 405 106 206 306 406 107 207 307 407 108 208 308 408 109 209 309 409 110 210 310 410 111 211 311 411 112 212 312 412 113 213 313 413 114 214 314 414 115 215 315 415 116 216 316 416 117 217 317 417 118 218 318 418 119 219 319 419 120 320 420 121 221 { 
	 
	use  "$temp\master_IMPUTACIONES_calculo de pobreza.dta", clear
	keep if periodo == "`x'"
	
	quietly  collapse (sum) tamh ingreso mv ocupado (mean) rururb factor ent sex mun nivel_educ pos_ocu seg_soc emp_ppal tue_ppal edadg, by(folioh) 
	

	*Se elimina a los hogares que tienen valores perdidos en ingreso

	replace mv=1 if mv>0 & mv!=.
	drop if mv==1

	*******************************************************************

	*Parte III COMPARACIÓN DEL INGRESO DEL HOGAR CON EL PROMEDIO DE LA 
	*LÍNEA DE POBREZA EXTREMA POR INGRESOS :

	******************************************************************* 

	gen factorp = factor*tamh 

	gen lpT`x' = cond(rururb==0,uT`x',rT`x') 
	gen pob = cond((ingreso/tamh)<lpT`x',1,0) 
*pobreza total
	sum pob [w=factorp] 
	gen TLP=round(r(mean)*100, 0.0001)
*pobreza urbana
	sum pob [w=factorp] if rururb==0 
	gen TLPu=round(r(mean)*100, 0.0001)
*pobreza rural
	sum pob [w=factorp] if rururb==1 
	gen TLPr=round(r(mean)*100, 0.0001)
*pobreza mujer
	sum pob [w=factorp] if sex==2
	gen TLPmuj=round(r(mean)*100, 0.0001)
*pobreza hombre
	sum pob [w=factorp] if sex==1 
	gen TLPhom=round(r(mean)*100, 0.0001)
*pobreza nivel edu
	sum pob [w=factorp] if nivel_educ == 1
	gen TLPedu1=round(r(mean)*100, 0.0001)

	sum pob [w=factorp] if nivel_educ == 2
	gen TLPedu2=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 3
	gen TLPedu3=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 4
	gen TLPedu4=round(r(mean)*100, 0.0001)
	
	sum pob [w=factorp] if nivel_educ == 5
	gen TLPedu5=round(r(mean)*100, 0.0001)
	

	foreach var in pos_ocu seg_soc emp_ppal tue_ppal{
		forvalues i = 0/4{
			sum pob [w=factorp] if `var' == `i'
			gen TLP`var'`i'=round(r(mean)*100, 0.0001)
		}
	}
	
	drop TLPseg_soc4 TLPemp_ppal4 TLPemp_ppal3 TLPtue_ppal4 TLPtue_ppal3
	
		forvalues i = 0/11{
			sum pob [w=factorp] if edadg == `i'
			gen TLPedadg`i'=round(r(mean)*100, 0.0001)
		}

	
	
*pobreza por delegacion
	foreach y in  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 {  
			
			sum pob [w=factorp] if mun==`y' 
			gen TLP`y'=r(mean)*100
			format TLP`y' %6.4f
			}


	keep TLP* 
	keep in 1 
	
*   rename TLP`y' Delegacion
	
	
	ren * SM_*

	gen periodo= `x' 
	
	append using "$temp\pobreza_laboral_TSM.dta",force
	save "$temp\pobreza_laboral_TSM.dta", replace 
} 


********************************************************************************
* UNIR ITLC PARA TODAS LAS MEDIDAS
********************************************************************************
clear

use "$temp\pobreza_laboral_TSM.dta",clear
merge 1:1 periodo using "$temp\pobreza_laboral_THT.dta"
drop _merge

merge 1:1 periodo using "$temp\pobreza_laboral_TMM.dta"
drop _merge


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

save "$temp\pobreza_laboral_ALL.dta",replace

********************************************************************************
**# Graficas
*

use "$temp\pobreza_laboral_ALL.dta", clear
*keep if year >= 2019
keep if year == 2017 | year == 2018 | year == 2019
twoway (tsline *_Nacional)

twoway (tsline *_Mujer) 

twoway (tsline *_Hombre) 

twoway (tsline SM_Rural) (tsline SM_Urbano) 

twoway (tsline HT_Hombre HT_Mujer) 

twoway (tsline SM_Hombre SM_Mujer) 

twoway (tsline SM_TLPmujrur SM_TLPmujurb) 

grstyle init

grstyle set plain, nogrid

grstyle set color plasma , n(5)

grstyle set legend 6, nobox

grstyle numstyle legend_rows 4

twoway (tsline SM_TLPedadg*)
SM_TLPpos_ocu0 SM_TLPseg_soc1
twoway (tsline SM_TLPedu*)

twoway (tsline SM_TLPpos_ocu*)

twoway (tsline SM_TLPseg_soc*)

twoway (tsline HT_TLP6 HT_TLP7 HT_TLP8 HT_TLP9 )

twoway (tsline HT_TLP10 HT_TLP11 HT_TLP12 HT_TLP13 )

twoway (tsline HT_TLP14 HT_TLP15 HT_TLP16 HT_TLP17)