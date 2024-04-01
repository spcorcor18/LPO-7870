
// Lecture 7 in-class example (LPO 7870)
// Regression discontinuity

// Last updated: 4/1/24

cd "C:\Users\corcorsp\Dropbox\_TEACHING\Data II\Lectures\Lecture 7 - Regression discontinuity"

// **************************************************************************
// Mastering Metrics chapter 4 RD example based on Carptenter &
// Dobkin (2009) 
// **************************************************************************

// Read source data 

	clear
	estimates drop _all
	use https://github.com/spcorcor18/LPO-8852/raw/main/data/AEJfigs.dta

// (a) recenter running variable at 21 and define treatment assignment variable

	gen age = agecell - 21
	gen over21 = age >= 0

	
// (b) scatter and RD plots for all-causes and motor vehicles mortality

	scatter all age, xline(0) name(graph1, replace)
	scatter mva age, xline(0) name(graph2, replace)
	graph combine graph1 graph2, rows(1) xsize(8) ysize(4)
	
	// here: use agecell on the x axis instead
	scatter all agecell, xline(21) name(graph1, replace)
	scatter mva agecell, xline(21) name(graph2, replace)
	graph combine graph1 graph2, rows(1) xsize(8) ysize(4)
	graph export scatters.png, as(png) replace
	
	
// (c) OLS regressions - linear and quadratic fits
	
	// linear model in age with intercept shift at over21
	reg all age over21
	predict allfit1
	
	reg mva age over21
	predict mvafit1
	
	// linear model in age with intercept shift at over21, different slope
	// below and above c
	reg all c.age##i.over21
	predict allfit2
	
	reg mva c.age##i.over21
	predict mvafit2

	label variable all "Mortality rate from all causes (per 100,000)"
	label variable mva "Mortality rate from motor vehicles (per 100,000)"
	
	label variable allfit1 "Mortality rate from all causes (per 100,000)"
	label variable mvafit1 "Mortality rate from motor vehicles (per 100,000)"
	label variable allfit2 "Mortality rate from all causes (per 100,000)"
	label variable mvafit2 "Mortality rate from motor vehicles (per 100,000)"
	
	// Figure 4.2 in Mastering Metrics (uses age centered on x-axis)
	twoway (scatter all age) ///
		(line allfit1 age if age<0, lcolor(black) lwidth(medthick)) ///
		(line allfit1 age if age>=0, lcolor(black red) lwidth(medthick medthick)), ///
		legend(off) yline(91.84137, lpattern(dash)) yline(99.504079, lpattern(dash)) ///
		text(92.5 0 "91.84") text(100 0 "99.50") xtitle(Age (centered)) name(fit1, replace)
	graph export fit1.png, as(png) replace
	
	// Figure 4.2 using linear model with different slopes below/above c
	twoway (scatter all age) ///
		(line allfit2 age if age<0, lcolor(black) lwidth(medthick)) ///
		(line allfit2 age if age>= 0, lcolor(black red) lwidth(medthick medthick)), ///
		legend(off) name(fit2, replace)  xtitle(Age (centered)) 
	graph export fit2.png, as(png) replace
	
	// quadratic model in age with intercept shift at over21
	reg all c.age##c.age over21
	predict allfitq1
	
	reg mva c.age##c.age over21
	predict mvafitq1
	
	// quadratic model in age with intercept shift at over21, different slopes
	// below and above c
	reg all c.age##c.age##i.over21
	predict allfitq2
	
	reg mva c.age##c.age##i.over21
	predict mvafitq2

	label variable allfitq1 "Mortality rate from all causes (per 100,000)"
	label variable mvafitq1 "Mortality rate from motor vehicles (per 100,000)"
	label variable allfitq2 "Mortality rate from all causes (per 100,000)"
	label variable mvafitq2 "Mortality rate from motor vehicles (per 100,000)"
	
	// Figure overlaying scatter with linear and quadratic fits		 
	twoway (scatter all age) ///
		(line allfit1 allfitq1 age if age<0, lcolor(red black) ///
		lwidth(medthick medthick) lpattern(dash)) ///
		(line allfit1 allfitq1 age if age>=0, lcolor(red black) ///
		lwidth(medthick medthick) lpattern(dash)), legend(off) ///
		xtitle(Age (centered))  name(fit3, replace)
	graph export fit3.png, as(png) replace
	
	*graph combine fit1 fit2 fit3, rows(2) xsize(8) ysize(10) title(Scatter plots with fitted lines, size(medium))
		
			
// (d) Repeat for internal causes (placebo test)

	// linear model same slope on both sides (internal)
	reg internal age over21
	predict infit1
	
	// quadratic model, different sloeps on each side (internal)
	reg internal c.age##c.age##i.over21
	predict infitq1

	label variable infitq1  "Mortality rate (per 100,000)"

	// Figure 4.5 in Mastering Metrics
	twoway (scatter mva internal age) ///
		(line mvafitq1 infitq1 age if age < 0) ///
        (line mvafitq1 infitq1 age if age >= 0), ///
		legend(off) text(28 20.1 "Motor Vehicle Fatalities") ///
		text(17 22 "Deaths from Internal Causes") ///
		xtitle(Age (centered),size(medium)) ytitle(Mortality rate, size(medium)) ///
		name(placebo, replace)
		
	graph export placebo.png, as(png) replace 

