
// Lecture 9 in-class examples (LPO 7870)
// Panel data

// Last updated: 4/15/24


// **************************************************************************
// Reshaping example
// **************************************************************************

// Read source data 

	clear
	use https://github.com/spcorcor18/LPO-7870/raw/main/data/Census_states_1970_2000.dta

// confirm one observation per state and year
	table state year
	duplicates report state year
	browse
	
// reshape to wide
	reshape wide medhhinc unemp, i(state state_name) j(year)
	
// reshape back to long
	reshape long medhhinc unemp, i(state state_name) j(year)
	
// sample panel commands
// note: cross-sectional unit must be numeric for xtset
	encode state, gen(state2)
	xtset state2 year
	xtdescribe
	
	
// **************************************************************************
// Traffic fatalities example from Stock & Watson chapter 10
// **************************************************************************

// Read source data 

	clear
	use https://github.com/spcorcor18/LPO-7870/raw/main/data/fatality.dta

// Multiply the motor vehicle fatality rate by 10,000 to get fatalities
// per 10,000 population

	replace mrall = mrall*10000
    label var mrall "Fatality rate (per 10,000)"
	label var beertax "Beer tax (dollars per case $1988)"
	
// Scatter plots and fitted lines for 1982 and 1988. Also, fit OLS regression.

	twoway (scatter mrall beertax) (lfit mrall beertax) if year==1982, ///
		legend(off)
	twoway (scatter mrall beertax) (lfit mrall beertax) if year==1988, ///
		legend(off)
	reg mrall beertax if year==1982
	reg mrall beertax if year==1988
	
	** want to see the states as the scatterplot markers?
	twoway (scatter mrall beertax, msymbol(none) mlabel(state) mlabposition(0)) ///
		(lfit mrall beertax) if year==1988, legend(off)

// Panel data with two time periods

	// keep only 1982 and 1988 and use difference operator (d. takes the 
	// first difference)
	
	preserve
	keep if year==1982 | year==1988
    ** to use d. operator will need tsset option below and a consecutive time
	** variable (year2)
	gen year2=1 if year==1982
	replace year2=2 if year==1988
	sort state year2
	tsset state year2
	twoway (scatter d.mrall d.beertax) (lfit d.mrall d.beertax)
	reg d.mrall d.beertax
	restore
	
// Fixed effects regression

	** approach 1: dummies for every state
	reg mrall beertax i.state
	
	** approach 2: areg ("absorbs" each state effect)
	areg mrall beertax, absorb(state)
	
// Fixed effects regression with time effects included

	** approach 1: dummies for every state and year
	reg mrall beertax i.state i.year
	
	** approach 2: areg with dummies for year
	areg mrall beertax i.year, absorb(state)
	
	
// Full regression model, following Stock and Watson chapter 10. Includes other
// predictors of vehicle fatalities

	** round the MLDA (it has decimal values)
	gen mlda2=round(mlda)

	** mandatory jail or community service
	egen mandatory=rowmax(jaild comserd)
	
	** log percapita income
	gen logpercap=ln(perinc)
	
	areg mrall beertax ib21.mlda2 i.mandatory vmiles unrate logpercap i.year, ///
		absorb(state)

		
// **************************************************************************
// Class size exercise
// **************************************************************************

// Read source data: Texas elementary panel

	clear
	use https://github.com/spcorcor18/LPO-7870/raw/main/data/Texas_elementary_panel_2004_2007.dta
	
// rename avgpassing variable and calculate avg class size in the school

	rename ca311tar avgpassing
	egen avgclass=rowmean(cpctg01a-cpctgmea)
	
// cross sectional regression

	reg avgpassing avgclass if year==2007
