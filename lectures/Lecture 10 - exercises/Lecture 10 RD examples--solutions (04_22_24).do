
// Lecture 10 in-class examples
// Regression discontinuity

// Last updated: 4/22/24

// installs rdplot, rdrobust, rdbwselect
ssc install rdrobust, replace

// installs rddensity
ssc install rddensity, replace
	
// installs binscatter
ssc install binscatter, replace
	

// *******
// (1) 
// *******
// **************************************************************************
// Simulated data 
// **************************************************************************

// create simulated data

	clear
	set seed 1234
	drawnorm x w e u, n(1000)
	gen y = 3 + 3*x + .5*x^2 + w + u
	gen t = (x >= 1)
	replace y = y + 0.5*t
	*save RDsim1.dta
	
// part 2
    clear
	use https://github.com/spcorcor18/LPO-7870/raw/main/data/RDsim1.dta
	gen xc = x-1
	
// part 3 - scatterplots - hard to see any visual evidence of a break.

	scatter y xc, xline(0) 
	
// part 4 - binscatter
	binscatter y xc, xline(0) 
	
// part 5 - rdplot

	rdplot y xc, c(0) graph_options(legend(position(6)))
	
// part 6 - regressions (linear, then quadratic)

	reg y xc t 
	reg y c.xc##i.t
	
	reg y xc t c.xc#c.xc
	reg y c.xc##c.xc##i.t
	
// part 7 - manually reduce bandwidth

	reg y c.xc##c.xc##i.t if abs(xc)<=0.5
		
// part 8 - rdrobust

	rdrobust y xc, c(0) p(2) bwselect(mserd) kernel(triangular)

// *******
// (2) 
// *******
// **************************************************************************
// Simulated data -- effect of participating in a G&T program
// **************************************************************************

// create simulated data:
//	    10,000 observations with "true ability" N(50,4) and grade 3 test
//	    score which is a noisy measure of true ability. Rounded to nearest
//		0.25 to create a more realistic "scale score"

	clear
	set seed 195423
	set obs 10000
	gen id=_n
	gen trueability = 50 + 4*rnormal()
	gen grade3test  = trueability + rnormal()
	replace grade3test = round(grade3test, 0.25)
	gen above56 = (grade3test>=56)
	gen inGT = above56
	gen grade4test = round(trueability + 5 + rnormal() + (3*inGT), 0.25)
 	
// to illustrate fuzzy RD, introduce some fuzziness into treatment assignment

	gen GTpart=round(-.77+.007*grade3test+0.7*above56+runiform())
	gen grade4testfuz = round(trueability + 5 + rnormal() + (3*GTpart), 0.25)

	drop inGT above56
	
	label var trueability "true ability (unobserved)"
	label var grade3test "grade 3 test score"
	label var grade4test "grade 4 test score"
	label var GTpart "=1 if participated in G&T (for fuzzy RD only)"
	label var grade4testfuz "grade 4 test score (assuming fuzzy RD)"
	* save RDsim2.dta
	
// parts 2-6 and 8 from Problem 1, applied here

    clear
	use https://github.com/spcorcor18/LPO-7870/raw/main/data/RDsim2.dta
	gen grade3testc = grade3test-56
	gen GT=grade3test>=56
	
	scatter grade4test grade3test, xline(56) 
	binscatter grade4test grade3test, xline(56) 
	rdplot grade4test grade3testc, c(0) graph_options(legend(position(6)))
	
	reg grade4test grade3testc GT 
	reg grade4test c.grade3testc##i.GT
	
	reg grade4test grade3testc GT c.grade3testc#c.grade3testc
	reg grade4test c.grade3testc##c.grade3testc##i.GT
	
	rdrobust grade4test grade3testc, c(0) p(2) bwselect(mserd) kernel(triangular)
	
	
// part 4 - percent complied

	tabulate GTpart
	
// part 5 - TOT

	rdrobust grade4testfuz grade3testc, c(0) p(1) kernel(triangular) fuzzy(GTpart)
