clear all
cls
set more off 
********************************************************************************
gl enoe = "C:\pobreza_laboral\sdem" 
gl coe2 = "C:\pobreza_laboral\coe2" 
gl temp = "C:\pobreza_laboral\temp_master" 
gl master  = "C:\pobreza_laboral\master" 

********************************************************************************
*set obs 1 
*gen periodo = . 
*gen TLP = . 
*save "$temp\master_base.dta"
********************************************************************************

********************************************************************************

foreach x in 105 205 305 405 106 206 306 406 107 207 307 407 108 208 308 408 109 209 309 409 110 210 310 410 111 211 311 411 112 212 312 412 113 213 313 413 114 214 314 414 115 215 315 415 116 216 316 416 117 217 317 417 118 218 318 418 119 219 319 419 120 320 420 121 221 {   

	if `x'==320 | `x'==420 | `x'==121 | `x'==221{
	use "$coe2\enoen_coe2t`x'.dta" , clear
	rename *, lower
	tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
	tostring con, replace format(%04.0f) force
	tostring  n_hog  h_mud tipo ca mes_cal, replace force
	gen str foliop = (cd_a + ent + con + v_sel + tipo + mes_cal + ca + n_hog + h_mud + n_ren)
	}

	else  { 
	use "$coe2\COE2T`x'.dta" , clear
	rename *, lower
	tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
	tostring con, replace format(%04.0f) force
	tostring  n_hog  h_mud, replace force
	gen str foliop = (cd_a + ent + con + v_sel + n_hog + h_mud + n_ren)
	}

	sort foliop
	save "$temp\ingresoT`x'.dta", replace

********************************************************************************

	if `x'==320  | `x'==420 | `x'==121 | `x'==221 {
	use "$enoe\enoen_sdemt`x'.dta", clear 
	rename *, lower
	tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
	tostring con, replace format(%04.0f) force
	tostring n_hog h_mud tipo ca mes_cal, replace force

	keep if r_def==0 & (c_res==1 | c_res==3)  
	gen str folioh = (cd_a + ent + con + v_sel + tipo + mes_cal + ca + n_hog + h_mud)
	gen str foliop = (cd_a + ent + con + v_sel + tipo + mes_cal + ca + n_hog + h_mud + n_ren) 
	rename t_loc_tri t_loc
	destring t_loc, replace

	}

	else{
	use "$enoe\SDEMT`x'.dta", clear 
	rename *, lower
	tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
	tostring con, replace format(%04.0f) force
	tostring n_hog h_mud, replace force
	keep if r_def==0 & (c_res==1 | c_res==3)  
	gen str folioh = (cd_a + ent + con + v_sel + n_hog + h_mud)
	gen str foliop = (cd_a + ent + con + v_sel + n_hog + h_mud + n_ren)
	}


	if `x'==320  | `x'==420 | `x'==121 {
	rename fac_tri fac
	} 

	sort foliop
	merge 1:1 foliop using "$temp\ingresoT`x'.dta"
********************************************************************************
	tab _merge
	drop _merge

*IMPUTACION del ingreso con base en el salario minimo, by(zona salarial)

*Recuperación de ingresos por rangos de salarios mínimos
	
	gen ocupado=cond(clase1==1 & clase2==1,1,0)

	destring p6b2 p6c, replace
	recode p6b2 (999998=.) (999999=.)
	
	gen ingreso=p6b2
	replace ingreso=0 if ocupado==0
	replace ingreso=0 if p6b2==. & (p6_9==9 | p6a3==3)
	replace ingreso=0.5*salario if p6b2==. & p6c==1
	replace ingreso=1*salario if p6b2==. & p6c==2
	replace ingreso=1.5*salario if p6b2==. & p6c==3
	replace ingreso=2.5*salario if p6b2==. & p6c==4
	replace ingreso=4*salario if p6b2==. & p6c==5
	replace ingreso=7.5*salario if p6b2==. & p6c==6
	replace ingreso=10*salario if p6b2==. & p6c==7

	gen tamh = 1  
	
	rename fac factor 
	gen rururb = cond(t_loc>=1 & t_loc<=3,0,1) 
	label define ru 0 "Urbano" 1 "Rural" 
	label values rururb ru 
	destring ent, replace
	
* dummy con ingreso missing

	gen mv=cond(ingreso==. & ocupado==1,1,0)

	gen periodo = `x' 
	compress
	append using "$temp\master_base.dta",force
	save "$temp\master_base.dta", replace 
} 

save "$temp\master_respaldo.dta", replace 
*********************************************************************************
use "$temp\master_respaldo.dta", clear

*******************************************************
* CONTROLANDO POR QUE QUEREMOS IMPUTAR
*********************


destring n_ren folioh foliop periodo, replace force

* destring folioh foliop, replace force
* drop if folioh == . | foliop == .

quietly destring eda sex e_con niv_ins anios_esc hrsocup imssissste rama_est2 pos_ocu ing7c clase1 clase2 cs_p13_1 cs_p13_2, replace
gen female=sex==2
gen married=e_con==1|e_con==5
gen formal=imssissste>=1 & imssissste<=3

label var clase1 "PEA 1, NoPEA 2"
label var clase2 "2 Desoc, 3 PNEA Disp"
label var pos_ocu "Ocup"
label var niv_ins "Nivel Instr"
label var rama_est2 "Rama"
label var hrsocup "Horas Ocupadas"
label var t_loc "Tam Localidad"
label var female "Female"
label var eda "Edad"
label var married "Casado"
label var ingocup "Ingreso Ocupacion"
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

label var nivel_educ "Nivel educ"
gen rural=t_loc==4
label var rural "Rural 1, <2500habs"
drop cs_p*  h_mud zona

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

replace ingocup=. if ingocup==0
gen wage_invalid=(ingocup==.)

***Solo trabajadores, con salario positivo
**Important Assumptions

keep if eda>=14
keep if clase2==1	//Población Ocupada//
keep if hrsocup>0 & hrsocup<199	//Horas Trabajo positivas//
drop if pos_ocu==4 | pos_ocu==5 | pos_ocu==. | ing7c==6 | ing7c==. //No, son Sin pago//?

quietly compress

*keep \\\ variables de interes

save "$temp\master_base a imputar.dta", replace 

