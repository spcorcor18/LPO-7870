
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
