
// Lecture 5 in-class examples and lecture figures
// Multiple regression - limited dependent variables

// Last updated: 3/18/24

// Change the file path to yours
cd "C:\Users\corcorsp\Dropbox\_TEACHING\Data II\Lectures\Lecture 5 - Nonlinear models and limited dependent variables\Graphics"

// **************************************
// NELS examples
// **************************************

** NELS data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/nels.dta, clear

** scatterplot of AP program in HS and 8th grade math achievement
scatter approg achmat08
graph export approg1.png, as(png) replace

** add best fit line
graph twoway (scatter approg achmat08) (lfit approg achmat08), legend(off) ///
	ytitle("advanced placement program taken?")
graph export approg2.png, as(png) replace

** simple regression (LPM)
reg approg achmat08

** predicted probability of AP given a math score of 70
margins, at(achmat08=70)

** multiple regression (LPM)
reg approg achmat08 i.gender i.urban ses

** show that errors are heteroskedastic (LPM)
reg approg achmat08
predict uhat, resid
scatter uhat achmat08
graph export approg6.png, as(png) replace

** show predicted probabilities that are below 0 or above 1
reg approg achmat08
margins, at(achmat08=25)
margins, at(achmat08=85)

** try a logit function instead - find slopes at x=56.6 and x=65
logit approg achmat08
margins ,at(achmat08=56.6) dydx(achmat08)
margins ,at(achmat08=65) dydx(achmat08)

** logistic command in order to get odds ratios
logistic approg achmat08

** try a probit function instead - find slopes at x=56.6 and x=65
probit approg achmat08
margins ,at(achmat08=56.6) dydx(achmat08)
margins ,at(achmat08=65) dydx(achmat08)


// **************************************
// HMDA exercise
// **************************************

** HMDA data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/hmda.dta, clear

tabstat deny, by(black) stat(n mean)

** regress deny on PI ratio (LPM), then add Black
reg deny pi_rat
reg deny pi_rat black

** same but use logit
logit deny pi_rat
logit deny pi_rat i.black
margins ,at(black=0) dydx(black)

** add explanatory variables (LPM)

reg deny pi_rat black hse_inc ltv_med ltv_high ccred mcred pubrec denpmi selfemp

** calculate slope for black at the mean values of all other x's
logit deny pi_rat i.black hse_inc ltv_med ltv_high ccred mcred pubrec denpmi selfemp
margins ,atmeans dydx(black)

** add even more explanatory variables (LPM)
reg deny pi_rat black hse_inc ltv_med ltv_high ccred mcred pubrec denpmi selfemp ///
	single hischl probunmp mcred3 mcred4 ccred3 ccred4 ccred5 ccred6 condo

