
// ***********************************************************************
// LPO.8800 Problem Set 8 - Solutions
// Last updated: October 31, 2024
// ***********************************************************************

clear all
set more off
capture log close
set linesize 80

global db  "C:\Users\corcorsp\Dropbox"
global pset "$db\_TEACHING\Statistics I - PhD\Problem sets\Problem set 8"
global datetag: display %td!(NN!_DD!_YY!) date(c(current_date), "DMY")
cd "$pset"

log using "PS8_results.txt", text replace nomsg

// ***********************************************************************
// LPO.8800 Problem Set 8 
// Last updated: October 31, 2024
// ***********************************************************************

cd "$pset"

// *************
// Question 3
// *************

ttesti 391 12.8 11.6 292 8.4 9.5, level(99)


// *************
// Question 4
// *************

prtesti 700 0.2286 750 0.1733


// *************
// Question 5
// *************

use https://github.com/spcorcor18/LPO-8800/raw/main/data/nels.dta, clear

// ********
// Part b
// ********
tabulate computer if edexpect>=2

// ********
// Part d-g
// ********
ttest achmat12 if edexpect>=2, by(computer)

// ********
// Part h-i
// ********
ttest achmat12 if edexpect>=2, by(computer) level(99)

esize twosample achmat12 if edexpect>=2, by(computer)


// *************
// Question 6
// *************
power twomeans 420 441, sd(84) knownsds onesided




capture log close
translate PS8_results.txt PS8_results.pdf, translator(txt2pdf) ///
		cmdnumber(off) logo(off) header(off) replace

exit
