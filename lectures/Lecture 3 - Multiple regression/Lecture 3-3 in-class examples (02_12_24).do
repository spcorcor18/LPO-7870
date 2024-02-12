
// Lecture 3 in-class examples and lecture figures
// Multiple regression

// Last updated: 2/11/24


// **************************************
// Computer ownership example
// **************************************

** NELS data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/nels.dta, clear

** mean 8th grade math score by computer ownership
tabstat achmat08, by(computer) stat(mean n)

** compare mean 8th grade math score by computer ownership using regression
reg achmat08 computer

** condition on SES (low or high)
egen ses2=cut(ses), group(2)
** the above command creates a new variable 'ses2' that splits 'ses' into two equally-sized groups

table computer ses2, contents(mean achmat08 n achmat08)

** alternatively separate regressions by SES group
reg achmat08 computer if ses2==0
reg achmat08 computer if ses2==1

** regression of 8th grade math achievement on computer, controlling for ses2
reg achmat08 computer i.ses2


// **************************************
// AP course example
// **************************************

** NELS data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/nels.dta, clear

** estimate "effect" of taking an AP course on 12th grade math achievement
reg achmat12 approg

** divide SES into quintiles
egen ses5=cut(ses), group(5)

tabstat approg, by(ses5)

** correlation between SES (continuous) and AP
corr approg ses

** regression of 12th grade math achievement on AP course, controlling for ses
reg achmat12 approg ses


// **************************************
// caschool data exercise
// **************************************

** caschool data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/caschool.dta, clear

** simple regression on class size
reg testscr str

** add percent English learners
reg testscr str el_pct

** add computers per student and percent eligible for FRPM 
reg testscr str el_pct comp_stu meal_pct


// **************************************
// collinearity examples
// **************************************

** caschool data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/caschool.dta, clear

** create a *fraction* EL
gen el_frac = el_pct/100

** try including this in the regression with el_pct
reg testscr str el_pct el_frac

** create a class size <12 variable ("very small" class size)
gen strlt12=(str<12)
tabulate strlt12

** try using this in the regression instead of str
reg testscr strlt12

** create a state variable
gen state="CA"
encode state, gen(staten)

reg testscr str i.staten


// ****************************************
// categorical explanatory variable example
// ****************************************

** NELS data
use https://github.com/spcorcor18/LPO-7870/raw/main/data/nels.dta, clear

** simple reression of math score on computer ownership
reg achmat08 computer

** educational expectations variable
tabulate edexpect

** now add dummy variables for categories of educational aspirations
reg achmat08 computer i.edexpect

** for reference, here is an alterantive way to create dummies for each category
tabulate edexpect, gen(edexpectd)
summ edexpectd*

** try to include them all in the regression (multicollinearity)
reg achmat08 computer edexpectd1 edexpectd2 edexpectd3 edexpectd4

** F-test for significance
reg achmat08 computer i.edexpect
reg, coeflegend
test 2.edexpect 3.edexpect 4.edexpect

