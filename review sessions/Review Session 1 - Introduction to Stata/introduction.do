/******************************************************************************/
*
*
*     LPO 7870 Review 1 - Common Stata Commands
*
*
/******************************************************************************/

clear all //start your dofiles with clear all incase you have anything saved from the past

help // When in doubt...

//you can use stata like a calculator with display
display 2 + 2
di 2 + 2 // Most commands have a shorthand

*-------------------------------------------------------------------------------
* Set your working directory
*-------------------------------------------------------------------------------

	cd "H:\" // Working directory

*YOU TRY: Update the code above to the file you use for this class.

*-------------------------------------------------------------------------------
* Import and save data
*-------------------------------------------------------------------------------

	webuse "auto.dta", clear //This is an example dataset that is build into stata.

	save "auto.dta", replace //Saves the dta in your working directory.

	export excel using "auto.xls", firstrow(variables) //Saves data as excel file. Saves variable names in the first row.

	clear

	import excel "auto.xls", firstrow clear //Import data from an excel file that has variable names in the first row.

/*
*YOU TRY -
1. Download the General Social Survey dataset from brightspace (GSS08.dta). Save it in your working directory.
2. Import GSS08.dta
3. Save it as an excel file.
4. Import the excel file.
*/

*-------------------------------------------------------------------------------
* Examining Data
*-------------------------------------------------------------------------------

/*
browse 		//browse the data spreadsheet-style
describe 	//describe the variables in the loaded dataset
count 		//count the number of (total) observations
summarize 	//summarize data (e.g. mean, min, max, standard deviation)
tabulate 	//frequency distribution of variable
*/

webuse "auto.dta", clear

codebook price // Detailed descriptions of variables

list make if price>11385 // Another way of showing the data

sum price

bysort foreign: sum price

/*
YOU TRY -
Using the commands above and the GSS08 data, answer these questions:
1. How many variables are in this dataset?
2. How many observations are in this dataset?
3. What does the variable HOMPOP mean?
4. What does the variable COHORT mean?
5. What percent of respondents are female?
6. What is the average age of the respondents?
*/

*-------------------------------------------------------------------------------
* Manipulating Data
*-------------------------------------------------------------------------------

/*
generate		//creates a new variable
replace			//replaces the values of a variable
drop			//drops (deletes) a variable completely
recode			//recodes a variable
*/

use "GSS08.dta", clear

fre MARITAL //see the values a variable can take on

gen never_married=0
	replace never_married=1 if MARITAL==5

drop
drop if MARITAL==9 //drop observations

/*
YOU TRY -
Using the commands above and the GSS08 data:
1. Create a new variable that is equal to 1 if a respondent has a bachelors degree and equal to 0 if they don't have a bachelors degree.
2. Delete any respondents that are 36 years old.
*/

*-------------------------------------------------------------------------------
* Renaming variables and values
*-------------------------------------------------------------------------------

/*
* Rename and Lable Variables and Values
rename 			//rename variables
label var		//add a label to the variable
label define	//define a variable label set
label values	//apply a label set to a variable's values
*/

rename *, lower //makes all variables lowercase
rename *sei *sei2 //renames all variables that end in sei

label var never_married "Indicator for Never Married"
label define lab1 0 "Married" 1 "Never Married"
label values never_married lab1
fre never_married

/*
YOU TRY -
1. Rename the variables babies, preteen, team, and adults to begin with "inhouse_".
2. Add a variable label to the variable you created for bachelors degrees.
3. Add value labels to the variable you created for bachelors degrees.
*/

*-------------------------------------------------------------------------------
* Graphs
*-------------------------------------------------------------------------------

 webuse "auto.dta", clear

 *Histograms
 histogram price
 hist price, bins(1)
 hist price, bins(50)
 hist price, by(foreign)

 *Kernel density plots
 graph twoway (kdensity price if foreign==1) ///
		(kdensity price if foreign==0), /// Three slashes means the code continues on the next line!
		legend(label(1 "Foreign") label(2 "Domestic"))

 *Boxplot
 graph box price
 graph hbox price, over(foreign)

 *Scatterplot
 scatter price mpg

 help graph

/*
YOU TRY - Using the GSS08 data, create a graph of age by gender.
*/

*-------------------------------------------------------------------------------
* Basic Analysis
*-------------------------------------------------------------------------------

 webuse "auto.dta", clear

 pwcorr price mpg, sig	// Correlation and p-value for two variables

 ttest price=mpg // Dependent t-test
 ttest price, by(foreign) // Independent t-test

 reg price mpg // Regression of continuous variables
 reg price mpg foreign

/*
YOU TRY - Using the GSS08 data:
1. What is the correlation between age and years of education?
2. Is there a statistically significant difference between the average age for males and the average age for females in this data set?
*/




 
