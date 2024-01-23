
// Lecture 2 in-class examples
// Descriptive and inferential statistics review

// Last updated: 1/22/24

// **************************************
// Describing data with NELS-88
// **************************************

use https://github.com/spcorcor18/LPO-7870/raw/main/data/nels.dta, clear
describe

// relative frequency of parent's marital status (categorical variable)
tabulate parmarl8, missing
tabulate parmarl8

// same using user-installed fre command (install using ssc install if necessary)
* ssc install fre
fre parmarl8

// bar graph for student's region (categorical variable)
graph bar (percent), over(region)

// histogram and density for 10th grade science achievement
histogram achsci10, fraction
kdensity achsci10

// density with area shaded between 40 and 50
twoway (kdensity achsci10) (kdensity achsci10, recast(area) range(40 50))

// density with area shaded below 44 (the 10th percentile)
twoway (kdensity achsci10) (kdensity achsci10, recast(area) range(33 44))

// summary statistics for 10th grade science achievement
summ achsci10
summ achsci10, detail

// create a z-score for 10th grade science achievement
egen zachsci10=std(achsci10)
summ zachsci10

// an easy way to get the IQR for 10th grade science achievement
tabstat achsci10, stat(iqr)


// **************************************
// Inferential statistics with NYSP data
// **************************************

use https://github.com/spcorcor18/LPO-7870/raw/main/data/nyvoucher.dta, clear
describe

// for this first example keep only the non-voucher students
keep if voucher==0

summ pre_ach

// calculate standard error in two ways
// first, manually
summ pre_ach
return list
display r(sd)/sqrt(r(N))

// now using mean estimation command
mean pre_ach

// hypothesis tests for pre_ach
ttest pre_ach=23
ttest pre_ach=21
ttest pre_ach=20

// now re-load the data so we can compare the post-test scores of voucher and
// non-voucher students

use https://github.com/spcorcor18/LPO-7870/raw/main/data/nyvoucher.dta, clear

twoway (kdensity post_ach if voucher==0) (kdensity post_ach if voucher==1)
