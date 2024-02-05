
// Lecture 3 in-class examples and lecture figures
// Hypothesis testing and confidence intervals

// Last updated: 2/5/24

// **********************************************
// Lecture figure - rejection region illustrated
// **********************************************

cd "C:\Users\corcorsp\Dropbox\_TEACHING\Data II\Lectures\Lecture 3 - Multiple regression"

*** Two-sided rejection region

global m 0
global s =1
global lb = $m - 3*$s
global ub = $m + 3*$s
global pr = round((normal((1.959964-0)/$s) - normal((-1.959964-0)/$s)),0.001)

global p1 -1.959964
global p2 1.959964
local overline = uchar(773)

# delimit ;

twoway function y=normalden(x,$m,$s), range($lb $ub) color(edkblue) droplines($m)  || 
	   function y=normalden(x,$m,$s), range($lb $p1) recast(area) color(eltgreen%40) ||
	   function y=normalden(x,$m,$s), range($p2 $ub) recast(area) color(eltgreen%40) 
	   xtitle("t") ytitle("") text(0.05 2.5 "{&alpha}/2=0.025") text(0.05 -2.5 "{&alpha}/2=0.025")  text(0.2 2.1 "1.96") text(0.2 -2.1 "-1.96")
	   title("Two-tailed test rejection region (H{sub:1}: {&beta}{sub:1}{&ne}0)") graphregion(fcolor(white)) name(gr1, replace)
	   legend(off) xlabel($p1 $m $p2) xline($m, lpattern(dash)) xline(1.96, lpattern(dash)) xline(-1.96, lpattern(dash))  ;
# delimit cr
graph export example1a.png, as(png) replace


*** Realized value of 2.38

global m 0
global s =1
global lb = $m - 3*$s
global ub = $m + 3*$s
global pr = round((normal((1.959964-0)/$s) - normal((-1.959964-0)/$s)),0.001)

global p1 -2.38
global p2 2.38
local overline = uchar(773)

# delimit ;

twoway function y=normalden(x,$m,$s), range($lb $ub) color(edkblue) droplines($m)  || 
	   function y=normalden(x,$m,$s), range($lb $p1) recast(area) color(eltgreen%40) ||
	   function y=normalden(x,$m,$s), range($p2 $ub) recast(area) color(eltgreen%40) 
	   xtitle("t") ytitle("") text(0.05 2.5 "p/2=0.0087") text(0.05 -2.5 "p/2=0.0087") text(0.2 2.1 "1.96") text(0.2 -2.1 "-1.96")
	   title("Two-tailed test (H{sub:1}: {&beta}{sub:1}{&ne}0)") graphregion(fcolor(white)) name(gr2, replace)
	   legend(off) xlabel($p1 $m $p2) xline($m, lpattern(dash)) xline(1.96, lpattern(dash)) xline(-1.96, lpattern(dash)) ;
# delimit cr
graph export example1b.png, as(png) replace


// **************************************
// Hypothesis tests using caschool data
// **************************************

** caschool data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/caschool.dta, clear

** hypothesis test for the slope, and 95% conidence interval
reg testscr expn_stu

** 90% and 99% confidence intervals, respectively
reg testscr expn_stu, level(90)
reg testscr expn_stu, level(99)

** creating a binary indicator for small class sizes
gen d=(str<=20) if str~=.
tabulate d

reg testscr d


// **************************************
// Work with the wage2 data
// **************************************

** wage2 data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/wage2.dta, clear

** dummy indicator for college graduates
gen college=educ>=16 if educ~=.

reg wage college

** for comparison see the ttest for differences in means
ttest wage, by(college)

** scatter plot wage vs education
scatter wage educ

** regression without and with robust option
reg wage educ
reg wage educ, robust
