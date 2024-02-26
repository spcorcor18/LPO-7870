
// Lecture 5 in-class examples and lecture figures
// Multiple regression - nonlinear models

// Last updated: 2/26/24

cd "C:\Users\corcorsp\Dropbox\_TEACHING\Data II\Lectures\Lecture 5 - Nonlinear models and limited dependent variables\Graphics"

// **************************************
// caschool data examples
// **************************************

** caschool data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/caschool.dta, clear

** scatterplot of test scores versus avg annual per capita income
scatter testscr avginc

** overlay line of best fit
twoway (scatter testscr avginc) (lfit testscr avginc), legend(off)
graph export avginc1.png, as(png) replace

** overlay line of best fit and quadratic
twoway (scatter testscr avginc) (lfit testscr avginc) (qfit testscr avginc), ///
	legend(off)
graph export avginc2.png, as(png) replace

** linear and quadratic regression models
reg testscr avginc
reg testscr c.avginc##c.avginc
// note: factor notation c.x##c.x will include two main terms and interaction
// (which in this case is x^2)

// alternatively:
gen avginc2=avginc*avginc
reg testscr avginc avginc2

** use of margins command to get predictions
reg testscr c.avginc##c.avginc
margins , at(avginc=(10 11))
margins , at(avginc=(40 41))

** use of margins command to get predictions
reg testscr c.avginc##c.avginc
margins , at(avginc=(10)) dydx(avginc)
margins , at(avginc=(40)) dydx(avginc)

** overlay line of quadratic and reference lines
twoway (scatter testscr avginc) (qfit testscr avginc), legend(off) ///
	xline(10 11 40 41)
graph export avginc3.png, as(png) replace

** cubic regression model--note insignificance of cubic term
reg testscr c.avginc##c.avginc##c.avginc

** create a logged avginc varaible
gen logavginc=ln(avginc)

** regress test scores on logged avginc
reg testscr logavginc

** plot predicted y (from linear-log model) against avginc
predict yhat, xb
sort avginc
twoway (scatter testscr avginc) (line yhat avginc), legend(off)
graph export avginc5.png, as(png) replace

** regress test scores on logged avginc again
reg testscr logavginc

** use of margins to get predictions at avginc=10, 11
** first convert these to logs
di ln(10)
di ln(11)
margins , at(logavginc=(2.3025851))
margins , at(logavginc=(2.3978953))

** create binary high/low EL variable and high/low class size variable
gen hiel = el_pct>10 if el_pct~=.
gen lgstr= str>=20 if str~=.
tabulate hiel lgstr
label var hiel "=1 if high EL population (>10%)"
label var lgstr "=1 if high class size (>=20)"

** regression with interaction between two binary variables
reg testscr i.lgstr##i.hiel

** margins example for the above
margins , at(lgstr=0 hiel=0)

** regression with interaction bewtween continuous (str) and binary (hiel)
reg testscr c.str##i.hiel

** margins example for the above
margins , at(str=(10(1)11) hiel=(0(1)1))
margins , at(hiel=(0(1)1)) dydx(str)

** regression with interaction between continuous str and el_pct
reg testscr c.str##c.el_pct
