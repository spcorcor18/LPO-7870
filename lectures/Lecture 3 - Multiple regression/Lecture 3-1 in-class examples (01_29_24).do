
// Lecture 3 in-class examples
// Correlation, covariance, simple linear regression

// Last updated: 1/29/24

// **************************************
// Scatterplots
// **************************************

use https://github.com/spcorcor18/LPO-7870/raw/main/data/caschool.dta, clear
scatter testscr str,  xtitle(Student-teacher ratio) ytitle(5th grade test score)


use https://github.com/spcorcor18/LPO-7870/raw/main/data/TN-lettergrades-2022-23.dta, clear

tabulate school_pool, miss
tabstat lg_score if school_pool=="HS", by(lg_grade) stat(n mean min max)

twoway scatter lg_score economically_disadvantaged if school_pool=="HS", ///
	   ytitle("Letter grade score")

** version with separate colors for each letter grade
twoway (scatter lg_score economically_disadvantaged_pct if lg_grade=="A") ///
	   (scatter lg_score economically_disadvantaged_pct if lg_grade=="B") ///
	   (scatter lg_score economically_disadvantaged_pct if lg_grade=="C") ///
	   (scatter lg_score economically_disadvantaged_pct if lg_grade=="D") ///
	   (scatter lg_score economically_disadvantaged_pct if lg_grade=="F") ///
	   if school_pool=="HS",yline(4.45 3.45 2.45 1.45) legend(off) ///
	   text(4.75 90 "A", size(large)) ///
	   text(4 90 "B", size(large)) ///
	   text(3 90 "C", size(large)) ///
	   text(2 90 "D", size(large)) ///
	   text(1.2 90 "F", size(large)) scheme(modern) ///
	   ytitle("Letter grade score")


// **************************************
// Correlation and covariance 
// **************************************

use https://github.com/spcorcor18/LPO-7870/raw/main/data/caschool.dta, clear

scatter testscr meal_pct,  xtitle(Percent low-income students) ytitle(5th grade test score)
scatter testscr el_pct,  xtitle(Percent English learners) ytitle(5th grade test score)
scatter testscr expn_stu,  xtitle(Expenditures per student) ytitle(5th grade test score)

** correlations and covariances
corr testscr meal_pct el_pct expn_stu
corr testscr meal_pct el_pct expn_stu, cov

** in the above, compare the diagonals to the variables' variances
tabstat testscr meal_pct el_pct expn_stu, stat(var)


// **************************************
// Linear regression 
// **************************************

use https://github.com/spcorcor18/LPO-7870/raw/main/data/TN-lettergrades-2022-23.dta, clear

** scatterplot and lowess
twoway (scatter lg_score economically_disadvantaged) ///
	   (lowess lg_score economically_disadvantaged) if school_pool=="HS", ///
	   ytitle("Letter grade score") legend(off)
	   
	   
use https://github.com/spcorcor18/LPO-7870/raw/main/data/caschool.dta, clear

** scatterplot and lowess
twoway (scatter testscr str) ///
	   (lowess testscr str), ///
	   xtitle(Student-teacher ratio) ytitle(5th grade test score) legend(off)


** scatterplot and lowess
twoway (scatter testscr str) ///
	   (lowess testscr str), ///
	   xtitle(Student-teacher ratio) ytitle(5th grade test score) legend(off)
	   
	   
** scatterplot and line of best fit
twoway (scatter testscr str, mcolor(gray%20) msymbol(circle) mfcolor(gray%20) mlcolor(gray%20)) ///
	(lfit testscr str) , ///
	legend(off) xtitle(Student-teacher ratio) ytitle(5th grade test score) 
	
	
** below: create figure in lecture showing four candidate best fit lines
twoway (scatter testscr str, mcolor(gray%20) msymbol(circle) mfcolor(gray%20) mlcolor(gray%20)) ///
	(lfit testscr str) (function y=610 + 2.5*x, range(14 26)) ///
	(function y=655 - 1*x, range(14 26)) (function y=720 - 4*x, range(14 26)), ///
	legend(off) xtitle(Student-teacher ratio) ytitle(5th grade test score) 
	   
	   
** below: create figure in lecture showing four candidate best fit lines, with
** some residuals illustrated
gen temp=runiform()
sort temp
gen highlight=_n<=20

reg testscr str
predict testhat

gen testhat2=610+2.5*str
gen testhat3=655-1*str
gen testhat4=720-4*str

twoway (scatter testscr str, mcolor(gray%20) msymbol(circle) mfcolor(gray%20) mlcolor(gray%20)) ///
	(rspike testscr testhat str if highlight==1, mcolor(cranberry)) ///
	(lfit testscr str) , ///
	legend(off) xtitle(Student-teacher ratio) ytitle(5th grade test score) nodraw name(fit1, replace)

twoway (scatter testscr str, mcolor(gray%20) msymbol(circle) mfcolor(gray%20) mlcolor(gray%20)) ///
	(rspike testscr testhat2 str if highlight==1, mcolor(cranberry)) ///
	(function y=610 + 2.5*x, range(14 26)), ///
	legend(off) xtitle(Student-teacher ratio) ytitle(5th grade test score) nodraw name(fit2, replace)

twoway (scatter testscr str, mcolor(gray%20) msymbol(circle) mfcolor(gray%20) mlcolor(gray%20)) ///
	(rspike testscr testhat3 str if highlight==1, mcolor(cranberry)) ///
	(function y=655 - 1*x, range(14 26)), ///
	legend(off) xtitle(Student-teacher ratio) ytitle(5th grade test score) nodraw name(fit3, replace)
	
twoway (scatter testscr str, mcolor(gray%20) msymbol(circle) mfcolor(gray%20) mlcolor(gray%20)) ///
	(rspike testscr testhat4 str if highlight==1, mcolor(cranberry)) ///
	(function y=720 - 4*x, range(14 26)), ///
	legend(off) xtitle(Student-teacher ratio) ytitle(5th grade test score) nodraw name(fit4, replace)
	
graph combine fit1 fit2 fit3 fit4, rows(2) xsize(8) ysize(6)


** simple regression
reg testscr str

** get predicted values and residuals
predict yhat, xb
predict uhat, resid

summ yhat uhat testscr
