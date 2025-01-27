**Assignment 1 Solutions Do File

clear all
cd "C:\Users\bjeuv\Box Sync\Data II - Spring 2025\Assignments\Assignment 1"
use 25_cps_2008, clear

*Part a
hist hours_pw, title(Histogram of Hours Worked Per Week)
sum hours_pw, d
replace hours_pw=. if hours_pw==-9
hist hours_pw, title(Histogram of Hours Worked Per Week)

*Part b
gen wages=earnings_pw/hours_pw

*Part c
sum wages, d

*Part d
bysort sex: sum wages
di 23.09-19.14
ttest wages, by(sex)
ci means wages if sex==1
ci means wages if sex==2

*Part e
scatter wages educ, title(Relationship btw Hourly Wages & Years of Education) ytitle(Hourly Wages)

*Part f
sort educ
by educ: egen mwages = mean(wages)
scatter mwage educ, title(Scatterplot of Avg Wages by Years of Education) ytitle(Mean Wages)
