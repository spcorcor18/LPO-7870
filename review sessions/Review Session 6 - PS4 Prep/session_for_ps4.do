
*-------------------------------------------------------------------------------
* TA Review Session - PS4 - RCTs and Linear Probability Models
* Created by Sara White 4.4.24
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
* Creating some fake student data for this activity
*-------------------------------------------------------------------------------

*make boy student dataset
clear
set obs 400

set seed 1329822

gen female=rbinomial(1,.5)
gen ses=rbinomial(1,.32)
gen ell=rbinomial(1,.16)
gen sat_score=rnormal(1100,100)
gen jr_gpa=rnormal(2.5,.5)

assert jr_gpa>0
assert sat_score>0

gen studentid=_n
tostring studentid, replace
order studentid

*-------------------------------------------------------------------------------
* Now we have our roster of students. We can randomly assign them to treatment and control groups.
*-------------------------------------------------------------------------------

gen rand=runiform()
sort rand
gen n1=_n

gen treat=0
replace treat=1 if _n<=200
drop rand n1

tab treat

*-------------------------------------------------------------------------------
* Now we can check the balance between our treatment and control groups using the data the student characteristics we have.
*-------------------------------------------------------------------------------

bysort treat: sum ses sat_score jr_gpa female ell

reg treat ses 
reg treat sat_score 
reg treat jr_gpa 
reg treat female 
reg treat ell

*Note: E(u|T) due to randomization

*-------------------------------------------------------------------------------
* You receive the end-of-year data on whether or not students graduated. You have to merge this data with your original student roster.
*-------------------------------------------------------------------------------

merge 1:1 studentid using "update file path here"

*Check your data for missing values 
nmissing grad

tab grad

*Check for differential attrition 
gen attrition=0
replace attrition=1 if grad==-9

tab treat attrition, row
reg treat attrition

*update values to missing 
replace grad=. if grad==-9

*-------------------------------------------------------------------------------
* Run a regression model to explore the effect of the program
*-------------------------------------------------------------------------------

reg grad treat

*may add controls to increase precision 
reg grad treat ses female sat_score

*-------------------------------------------------------------------------------
* Explore predicted values
*-------------------------------------------------------------------------------
reg grad treat ses female sat_score
predict pred, xb

sum pred, detail

assert pred<=1
assert pred>=0

*-------------------------------------------------------------------------------
* Consider gender as a potential moderator of the effect
*-------------------------------------------------------------------------------

gen treatxfemale=treat*female

reg grad treat female treatxfemale















