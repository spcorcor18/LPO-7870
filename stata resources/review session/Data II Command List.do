
**********************************
*   	Running List of Codes	 *
**********************************

/*
This is a running list of code from Data I and Data II:
*/

* Getting set up:
cd 				//change directory
use 			//load a dataset into STATA
sysuse 			//use a system dataset

* Examining Data:
browse 			//browse the data spreadsheet-style
describe 		//describe the variables in the loaded dataset
count 			//count the number of (total) observations
summarize 		//summarize data (e.g. mean, min, max, standard deviation)
tabulate		//frequency distribution of variable

* Graphs:
histogram		//creates a histogram
kdensity		//creates a kernal density plot
graph bar		//creates a bar graph
graph pie		//creates a pie graph
scatter			//creates a scatterplot

* Manipulating Data:
generate		//creates a new variable
replace			//replaces the values of a variable
drop			//drops (deletes) a variable completely
recode			//recodes a variable

* Sorting data:
sort			//sorts data by the variable (lowest value to highest)
list			//lists variable values
gsort			//allows you to sort highest to lowest (be sure to add "-" before variable name)

* Rename and Lable Variables and Values
rename 			//rename variables
label var		//add a label to the variable
label define	//define a variable label set
label values	//apply a label set to a variable's values

* Converting values
display normal(sd)			//convert z-score to probability
display invnormal			//convert probability to z-score
display ttail(df, t-stat)	//convert t-stat to probability (one-tailed)
display invttail(df, prob)	//convert probability to t-stat (one-tailed)


* Relationships between two variables
pwcorr x1 x2, sig	//correlation and p-value for two variables
ttest x1=x2			//dependent t-test
ttest x1, by(x2)	//independnet t-test
oneway x1 x2		//oneway ANOVA (x1=dependent variable, x2=categories)
anova x1 x2 x3		//twoway ANOVA

* Relationships between more than two variables
regress x1 x2 x3	//regression (x1 = dependent variable)


* To learn more about the options for each command, type "help" in front of a command:
help generate	//brings up a help file, which explains how to use the command
