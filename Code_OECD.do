clear
cap drop _all
cap graph drop _all

/********************* READ IN THE DATA ***********************/
import excel "C:\Users\Marina Sanches\OneDrive\tese\submissao ocde\Dataset.xlsx", sheet("Planilha1") firstrow




*Adjust the sample - see Appendix A 
drop if id_country==1
drop if id_country==2
drop if id_country==3
drop if id_country==4
drop if id_country==5
drop if id_country==6
drop if id_country==7
drop if id_country==8
drop if id_country==9
drop if id_country==10
drop if id_country==11
drop if id_country==12
drop if id_country==13
drop if id_country==14
drop if id_country==15
drop if id_country==16
drop if id_country==17

//////////////////////////


*Panel
xtset  id_country year, yearly  

*Dependent variables for exercises 1-7, respectively - in light blue color in excel
gen lgini=log(ginidisp)	// disposable income inequality	- exercise 1				   
gen lgini=log(ginimerc)		// market income inequality	- exercise 2	   
gen lgini=log(giniwage)		// wage inequality- exercise 3  
gen lgini=log(p5010)		// earnings inequality 5010	- exercise 4		   
gen lgini=log(p9050)	// earnings inequality 9050 - exercise 5
gen lgini=log(p9010)			// earnings inequality 9010 - exercise 6
gen lshare=log(share100)	// labor share - exercise 7

*Dependent variables for the redistribution channel
gen lgini=log(dif)					 // difference between market and disposable income inequality  
	
	
*Control variables  - for robusteness tests	 - in green color in excel
	
gen logrendapc=log(pibpc)	// gdp per capita
gen diflogrendapc=d.logrendapc

gen diftrade=d.trade // trade openness
gen difunemp=d.unemp // unemployment rate

gen linfl=log(inflation) //inflation
gen difinfl=d.linfl



*Generate the dependent variables for the local projection	

foreach x in lgini {
forv h = 0/11 {
gen `x'`h' = f`h'.`x' - l.`x' 			// (1) Use for cumulative IRF
*gen `x'`h' = f`h'.`x' - l.f`h'.`x'		// (2) Use for usual IRF

}
}


********Exercise 3: gini for wages**********


eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0



* lngini_rnd`h'(t) = Total(t-1) + Total(t-2) + dif_lnpib(t-1) + dif_lnpib(t-2)

forv h = 0/7 {
xtscc lgini`h' l(1/3).lgini0 l(1/2).Total i.year, fe 
replace b = _b[l.Total]                     if _n == `h'+2
replace u = _b[l.Total] + 1.645* _se[l.Total]  if _n == `h'+2
replace d = _b[l.Total] - 1.645* _se[l.Total]  if _n == `h'+2 

eststo 
}

nois esttab , p nocons keep(L.Total)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Total", color(black) size(medsmall)) ///
		ytitle("index", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))		
		gr rename ch_total, replace








eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lgini`h' l(1/3).lgini0 l(1/2).Spend i.year, fe 
replace b = _b[l.Spend]                     if _n == `h'+2
replace u = _b[l.Spend] + 1.645* _se[l.Spend]  if _n == `h'+2
replace d = _b[l.Spend] - 1.645* _se[l.Spend]  if _n == `h'+2 
eststo 
}


nois esttab , p nocons keep(L.Spend)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Spending-based", color(black) size(medsmall)) ///
		ytitle("index", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_gastos, replace




eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lgini`h' l(1/3).lgini0 l(1/2).Tax i.year, fe 
replace b = _b[l.Tax]                     if _n == `h'+2
replace u = _b[l.Tax] + 1.645* _se[l.Tax]  if _n == `h'+2
replace d = _b[l.Tax] - 1.645* _se[l.Tax]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Tax)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Tax-based", color(black) size(medsmall)) ///
		ytitle("index", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_tributos, replace
		
				
gr combine ch_gastos ch_tributos, rows(1) ///
	title("Accumulated response of wage inequality to a fiscal shock", color(black) size(medsmall)) 









**************Exercise 5: P9050***************************



eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0



forv h = 0/7 {
xtscc lgini`h' l(1/2).lgini0 l(1/1).Total i.year, fe 
replace b = _b[l.Total]                     if _n == `h'+2
replace u = _b[l.Total] + 1.645* _se[l.Total]  if _n == `h'+2
replace d = _b[l.Total] - 1.645* _se[l.Total]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Total)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Total", color(black) size(medsmall)) ///
		ytitle("P9050", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))		
		gr rename ch_total, replace




eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0


forv h = 0/7 {
xtscc lgini`h' l(1/2).lgini0 l(1/1).Spend i.year, fe 
replace b = _b[l.Spend]                     if _n == `h'+2
replace u = _b[l.Spend] + 1.645* _se[l.Spend]  if _n == `h'+2
replace d = _b[l.Spend] - 1.645* _se[l.Spend]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Spend)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Spending-based", color(black) size(medsmall)) ///
		ytitle("P9050", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_gastos, replace




eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lgini`h' l(1/2).lgini0 l(1/1).Tax i.year, fe 
replace b = _b[l.Tax]                     if _n == `h'+2
replace u = _b[l.Tax] + 1.645* _se[l.Tax]  if _n == `h'+2
replace d = _b[l.Tax] - 1.645* _se[l.Tax]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Tax)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Tax-based", color(black) size(medsmall)) ///
		ytitle("P9050", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_tributos, replace
		
				
gr combine ch_gastos ch_tributos, rows(1) ///
	title("Accumulated response of earnings inequality (P9050) to a fiscal shock", color(black) size(medsmall)) 








***************Exercise 4: P5010************************



eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=7
gen Zero =  0    if _n<=7
gen b=0
gen u=0
gen d=0



forv h = 0/5 {
xtscc lgini`h' l(1/1).lgini0 l(1/3).Total i.year, fe 
replace b = _b[l.Total]                     if _n == `h'+2
replace u = _b[l.Total] + 1.645* _se[l.Total]  if _n == `h'+2
replace d = _b[l.Total] - 1.645* _se[l.Total]  if _n == `h'+2 

eststo 
}

nois esttab , p nocons keep(L.Total)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Total", color(black) size(medsmall)) ///
		ytitle("P9010", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))		
		gr rename ch_total, replace






eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=7
gen Zero =  0    if _n<=7
gen b=0
gen u=0
gen d=0




forv h = 0/5 {
xtscc lgini`h' l(1/1).lgini0 l(1/3).Spend i.year, fe 
replace b = _b[l.Spend]                     if _n == `h'+2
replace u = _b[l.Spend] + 1.645* _se[l.Spend]  if _n == `h'+2
replace d = _b[l.Spend] - 1.645* _se[l.Spend]  if _n == `h'+2 
eststo 
}


nois esttab , p nocons keep(L.lgini0 L.Spend)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Spending-based", color(black) size(medsmall)) ///
		ytitle("P9010", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_gastos, replace

		

eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=7
gen Zero =  0    if _n<=7
gen b=0
gen u=0
gen d=0




forv h = 0/5 {
xtscc lgini`h' l(1/1).lgini0 l(1/3).Tax i.year, fe 
replace b = _b[l.Tax]                     if _n == `h'+2
replace u = _b[l.Tax] + 1.645* _se[l.Tax]  if _n == `h'+2
replace d = _b[l.Tax] - 1.645* _se[l.Tax]  if _n == `h'+2 
eststo 
}


nois esttab , p nocons keep(L.Tax)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Tax-based", color(black) size(medsmall)) ///
		ytitle("P9010", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_tributos, replace
		
				
gr combine ch_gastos ch_tributos, rows(1) ///
	title("Accumulated response of earnings inequality (P5010) to a fiscal shock", color(black) size(medsmall)) 












**************Exercise 6: P9010*****************************


eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0


forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/1).Total i.year, fe 
replace b = _b[l.Total]                     if _n == `h'+2
replace u = _b[l.Total] + 1.645* _se[l.Total]  if _n == `h'+2
replace d = _b[l.Total] - 1.645* _se[l.Total]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Total)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Total", color(black) size(medsmall)) ///
		ytitle("P5010", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))		
		gr rename ch_total, replace


		



eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/1).Spend i.year, fe 
replace b = _b[l.Spend]                     if _n == `h'+2
replace u = _b[l.Spend] + 1.645* _se[l.Spend]  if _n == `h'+2
replace d = _b[l.Spend] - 1.645* _se[l.Spend]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Spend)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Spending-based", color(black) size(medsmall)) ///
		ytitle("P5010", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_gastos, replace




eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/1).Tax i.year, fe 
replace b = _b[l.Tax]                     if _n == `h'+2
replace u = _b[l.Tax] + 1.645* _se[l.Tax]  if _n == `h'+2
replace d = _b[l.Tax] - 1.645* _se[l.Tax]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Tax)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Tax-based", color(black) size(medsmall)) ///
		ytitle("P5010", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_tributos, replace
		
				
gr combine ch_gastos ch_tributos, rows(1) ///
	title("Accumulated response of earnings inequality (P9010) to a fiscal shock", color(black) size(medsmall)) 






****************Exercise 1: disposable income inequality******************


eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=10
gen Zero =  0    if _n<=10
gen b=0
gen u=0
gen d=0



forv h = 0/8 {
xtscc lgini`h' l(1/1).lgini0 l(1/2)Total i.year, fe 
replace b = _b[l.Total]                     if _n == `h'+2
replace u = _b[l.Total] + 1.645* _se[l.Total]  if _n == `h'+2
replace d = _b[l.Total] - 1.645* _se[l.Total]  if _n == `h'+2 

eststo 
}

nois esttab , p nocons keep(L.Total)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Total", color(black) size(medsmall)) ///
		ytitle("Gini", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))		
		gr rename ch_total, replace


		

eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=10
gen Zero =  0    if _n<=10
gen b=0
gen u=0
gen d=0


forv h = 0/8 {
xtscc lgini`h' l(1/1).lgini0 l(1/2).Spend i.year, fe 
replace b = _b[l.Spend]                     if _n == `h'+2
replace u = _b[l.Spend] + 1.645* _se[l.Spend]  if _n == `h'+2
replace d = _b[l.Spend] - 1.645* _se[l.Spend]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Spend)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Spending-based", color(black) size(medsmall)) ///
		ytitle("Gini", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_gastos, replace

		

eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=11
gen Zero =  0    if _n<=11
gen b=0
gen u=0
gen d=0


forv h = 0/9 {
xtscc lgini`h' l(1/1).lgini0 l(1/2).Tax i.year, fe  
replace b = _b[l.Tax]                     if _n == `h'+2
replace u = _b[l.Tax] + 1.645* _se[l.Tax]  if _n == `h'+2
replace d = _b[l.Tax] - 1.645* _se[l.Tax]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Tax)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Tax-based", color(black) size(medsmall)) ///
		ytitle("Gini", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_tributos, replace
		
					
gr combine ch_gastos ch_tributos, rows(1) ///
	title("Accumulated response of the gini index to a fiscal shock", color(black) size(medsmall)) 






*****************Exercise 2: market income inequality *************


eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0



forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/2)Total i.year, fe 
replace b = _b[l.Total]                     if _n == `h'+2
replace u = _b[l.Total] + 1.645* _se[l.Total]  if _n == `h'+2
replace d = _b[l.Total] - 1.645* _se[l.Total]  if _n == `h'+2 

eststo 
}

nois esttab , p nocons keep(L.Total)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Total", color(black) size(medsmall)) ///
		ytitle("Gini", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))		
		gr rename ch_total, replace


		

eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0


forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/2).Spend i.year, fe 
replace b = _b[l.Spend]                     if _n == `h'+2
replace u = _b[l.Spend] + 1.645* _se[l.Spend]  if _n == `h'+2
replace d = _b[l.Spend] - 1.645* _se[l.Spend]  if _n == `h'+2 
eststo 
}


nois esttab , p nocons keep(L.Spend)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Spending-based", color(black) size(medsmall)) ///
		ytitle("Gini", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_gastos, replace

		


eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0

forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/2).Tax i.year, fe  
replace b = _b[l.Tax]                     if _n == `h'+2
replace u = _b[l.Tax] + 1.645* _se[l.Tax]  if _n == `h'+2
replace d = _b[l.Tax] - 1.645* _se[l.Tax]  if _n == `h'+2 
eststo 
}


nois esttab , p nocons keep(L.Tax)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Tax-based", color(black) size(medsmall)) ///
		ytitle("Gini", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_tributos, replace
		
					
gr combine ch_gastos ch_tributos, rows(1) ///
	title("Accumulated response of the gini index to a fiscal shock", color(black) size(medsmall)) 




****************difference (variable dif)*****************************


eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0



forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/2).Total i.year, fe 
replace b = _b[l.Total]                     if _n == `h'+2
replace u = _b[l.Total] + 1.645* _se[l.Total]  if _n == `h'+2
replace d = _b[l.Total] - 1.645* _se[l.Total]  if _n == `h'+2 

eststo 
}

nois esttab , p nocons keep(L.Total)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Total", color(black) size(medsmall)) ///
		ytitle("index", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))		
		gr rename ch_total, replace




eststo clear
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/2).Spend i.year, fe 
replace b = _b[l.Spend]                     if _n == `h'+2
replace u = _b[l.Spend] + 1.645* _se[l.Spend]  if _n == `h'+2
replace d = _b[l.Spend] - 1.645* _se[l.Spend]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Spend)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Spending-based", color(black) size(medsmall)) ///
		ytitle("index", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_gastos, replace



eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lgini`h' l(1/1).lgini0 l(1/2).Tax i.year, fe 
replace b = _b[l.Tax]                     if _n == `h'+2
replace u = _b[l.Tax] + 1.645* _se[l.Tax]  if _n == `h'+2
replace d = _b[l.Tax] - 1.645* _se[l.Tax]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Tax)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Tax-based", color(black) size(medsmall)) ///
		ytitle("index", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_tributos, replace
		
				
gr combine ch_gastos ch_tributos, rows(1) ///
	title("Accumulated response of the redistribution measure to a fiscal shock", color(black) size(medsmall)) 






// Dependent variables for exercise 7
foreach x in lshare {
forv h = 0/7 {
gen `x'`h' = f`h'.`x' - l.`x' 			// (1) Use for cumulative IRF
*gen `x'`h' = f`h'.`x' - l.f`h'.`x'		// (2) Use for usual IRF

}
}



eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lshare`h' l(1/2).lshare0 l(1/1).Total i.year, fe 
replace b = _b[l.Total]                     if _n == `h'+2
replace u = _b[l.Total] + 1.645* _se[l.Total]  if _n == `h'+2
replace d = _b[l.Total] - 1.645* _se[l.Total]  if _n == `h'+2 

eststo 
}

nois esttab , p nocons keep(L.Total)

twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Total", color(black) size(medsmall)) ///
		ytitle("Labor Share", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))		
		gr rename ch_total, replace



eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0




forv h = 0/7 {
xtscc lshare`h' l(1/2).lshare0 l(1/1).Spend i.year, fe 
replace b = _b[l.Spend]                     if _n == `h'+2
replace u = _b[l.Spend] + 1.645* _se[l.Spend]  if _n == `h'+2
replace d = _b[l.Spend] - 1.645* _se[l.Spend]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Spend)
twoway /// 
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Spending-based", color(black) size(medsmall)) ///
		ytitle("Labor Share", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_gastos, replace



eststo clear 
cap drop b u d Years Zero
gen Years = _n-1 if _n<=9
gen Zero =  0    if _n<=9
gen b=0
gen u=0
gen d=0


forv h = 0/7 {
xtscc lshare`h' l(1/2).lshare0 l(1/1).Tax i.year, fe 
replace b = _b[l.Tax]                     if _n == `h'+2
replace u = _b[l.Tax] + 1.645* _se[l.Tax]  if _n == `h'+2
replace d = _b[l.Tax] - 1.645* _se[l.Tax]  if _n == `h'+2 
eststo 
}

nois esttab , p nocons keep(L.Tax)
twoway ///
		(rarea u d  Years,  ///
		fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
		(line b Years, lcolor(black) ///
		lpattern(solid) lwidth(thick)) /// 
		(line Zero Years, lcolor(black)), legend(off) ///
		title("Tax-based", color(black) size(medsmall)) ///
		ytitle("Labor Share", size(medsmall)) xtitle("Year", size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white))
		
		gr rename ch_tributos, replace
		

gr combine ch_gastos ch_tributos, rows(1) ///
	title("Accumulated response of labor share to a fiscal shock", color(black) size(medsmall)) 

	
**Robustness exercises in Appendix B can be run using this code also, just making the adjustments (number of lags, including control variables, adjusting the sample of countries etc)	

