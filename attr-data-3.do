*** Purpose: to prepare data for analysis of attractiveness
*** Author: S Bauldry
*** Date: October 28, 2014

****** paths to data (update with locations of raw data)
global w1 "[enter path]"
global w2 "[enter path]"
global w3 "[enter path]"
global w4 "[enter path]"
global wt "[enter path]"
global fs "[enter path]"


****** extracting data from wave 1
use aid imonth iday iyear h1gi1m h1gi1y bio_sex h1gi4 h1gi5c h1gi6a-h1gi6e ///
  h1ir1 h1ir2 pa12 pb8 h1rm1 h1rf1 pa55 h1gh59a h1gh59b h1gh60 h1ed11-h1ed14 ///
  ah_pvt using "$w1", replace

*** setting missing data
recode h1gi1m h1gi1y (96 = .)
recode bio_sex h1gi4 h1gi5c h1gi6a-h1gi6e (6 7 8 9 = .)
recode h1ir1 h1ir2 (6 8 9 = .)
recode pa12 pb8 h1rm1 h1rf1 (11 12 96/99 = .)
recode h1gh59a h1gh59b (96 98 99 = .)
recode h1gh60 (996 998 999 = .)
recode pa55 (9996 = .)
recode h1ed11-h1ed14 (5 6 96/99 = .)

*** preparing variables
recode iyear (94 = 1994) (95 = 1995)
gen w1age = floor( ( mdy(imonth, iday, iyear) - mdy(h1gi1m, 15, 1900 + h1gi1y) )/364.25 )
lab var w1age "w1 age"
drop i* h1gi1*

gen female = (bio_sex == 2) if !mi(bio_sex)
lab var female "w1 female"
drop bio_sex

gen race = 3 if h1gi4 == 1
replace race = 2 if h1gi6b == 1 & mi(race)
replace race = 4 if (h1gi6c == 1 | h1gi6d == 1 | h1gi6e == 1) & mi(race)
replace race = 1 if h1gi6a == 1 & mi(race)
lab def r 1 "white" 2 "black" 3 "hispanic" 4 "other"
lab val race r
lab var race "w1 race"
drop h1gi*

rename (h1ir1 h1ir2) (w1phyatt w1peratt)
lab var w1phyatt "w1 physical attract"
lab var w1peratt "w1 personality attract"

recode pa12 pb8 h1rm1 h1rf1 (10 = 1)
gen paredu = max(pa12,pb8)
gen cparedu = max(h1rm1,h1rf1)
replace paredu = cparedu if missing(paredu)
recode paredu (1 2 3 = 1) (4 5 = 2) (6 7 = 3) (8 = 4) (9 = 5)
lab var paredu "w1 parent education"
drop pa12 pb8 h1rm1 h1rf1 cparedu

gen lninc = log(pa55 + 1)
lab var lninc "w1 parent income (logged)"
drop pa55

gen w1hgt = 12*h1gh59a + h1gh59b
gen w1bmi = (h1gh60*703)/( (12*h1gh59a + h1gh59b)^2 )
lab var w1hgt "w1 height"
lab var w1bmi "w1 BMI"
drop h1gh59a h1gh59b h1gh60

recode h1ed11-h1ed14 (1 = 4) (2 = 3) (3 = 2) (4 = 1)
egen gpa = rowmean(h1ed11-h1ed14)
lab var gpa "w1 gpa"
drop h1ed11-h1ed14

rename ah_pvt pvt
lab var pvt "w1 PVT"

sort aid
tempfile wv1
save `wv1', replace


****** extracting data from wave 2
use aid calcage2 h2ir1 h2ir2 h2ws16hf h2ws16hi h2ws16w using "$w2", replace

*** setting missing data
recode h2ir1 h2ir2 (6 8 9 = .)
recode h2ws16hf h2ws16hi (96 98 = .)
recode h2ws16w (996 998 = .)

*** preparing variables
gen w2hgt = 12*h2ws16hf + h2ws16hi
gen w2bmi = (h2ws16w*703)/( (12*h2ws16hf + h2ws16hi)^2 )
lab var w2hgt "w2 height"
lab var w2bmi "w2 BMI"
drop h2ws16w h2ws16hf h2ws16hi

rename (calcage2 h2ir1 h2ir2) (w2age w2phyatt w2peratt)
lab var w2age "w2 age"
lab var w2phyatt "w2 physical attract"
lab var w2peratt "w2 personality attract"

sort aid
tempfile wv2
save `wv2', replace


****** extracting data from wave 3
use aid calcage3 h3ir1 h3ir2 h3wgt h3hgt_f h3hgt_i h3hgt_pi using "$w3", replace

*** setting missing data
recode h3ir1 h3ir2 (6 8 9 = .)
recode h3wgt (888 996 = .)
recode h3hgt_f h3hgt_i (96 98 99 = .)
recode h3hgt_pi (6 8 9 = .)

*** preparing variables
gen w3hgt = 12*h3hgt_f + h3hgt_i + h3hgt_pi
gen w3bmi = (h3wgt*703)/( (12*h3hgt_f + h3hgt_i + h3hgt_pi)^2 )
lab var w3hgt "w3 height"
lab var w3bmi "w3 BMI"
drop h3wgt h3hgt_f h3hgt_i h3hgt_pi

rename (calcage3 h3ir1 h3ir2) (w3age w3phyatt w3peratt)
lab var w3age "w3 age"
lab var w3phyatt "w3 physical attract"
lab var w3peratt "w3 personality attract"

sort aid
tempfile wv3
save `wv3', replace


****** extracting data from wave 4
use aid imonth4 iyear4 iday4 h4od1m h4od1y h4ir1 h4ir2 h4ed2 h4pe1 h4pe9 ///
  h4pe17 h4pe25 h4pe2 h4pe10 h4pe18 h4pe26 h4pe37-h4pe41 using "$w4", replace

*** setting missing data
recode h4ir1 h4ir2 (6 8 9 = .)
recode h4ed2 (96 98 = .)
recode h4pe* (6 8 = .)

*** preparing variables
gen w4age = floor( ( mdy(imonth4, iday4, iyear4) - mdy(h4od1m, 15, h4od1y) )/364.25 )
lab var w4age "w4 age"
drop i* h4od*

rename (h4ir1 h4ir2) (w4phyatt w4peratt)
lab var w4phyatt "w4 physical attract"
lab var w4peratt "w4 personality attract"

recode h4ed2 (1 2 = 1) (3 = 2) (4 5 6 = 3) (7 = 4) (8/13 = 5), gen(w4edu)
lab var w4edu "w4 education"
drop h4ed2

alpha h4pe2 h4pe10 h4pe18 h4pe26, gen(w4agr)
alpha h4pe1 h4pe9 h4pe17 h4pe25, gen(w4ext)
alpha h4pe37-h4pe41, gen(w4mas)
lab var w4agr "w4 agreeableness"
lab var w4ext "w4 extraversion"
lab var w4mas "w4 mastery"
drop h4pe*


sort aid
tempfile wv4
save `wv4', replace



****** Extracting family structure ******
use aid famst5 using "$fs", replace

sort aid
tempfile fst
save `fst', replace



****** Extracting weights ******
use aid psuscid gswgt4_2 region using "$wt", replace

*** labels
lab def rg 1 "west" 2 "midwest" 3 "south" 4 "northeast"
lab val region rg
lab var region "region"

sort aid
tempfile wgt
save `wgt', replace




****** Merging data files ******
clear
use `wv1'
merge 1:1 aid using `wv2' 
keep if _merge == 3
drop _merge

merge 1:1 aid using `wv3' 
keep if _merge == 3
drop _merge

merge 1:1 aid using `wv4' 
keep if _merge == 3
drop _merge

merge 1:1 aid using `fst'
keep if _merge == 3
drop _merge

merge 1:1 aid using `wgt'
keep if _merge == 3
drop _merge



*** keeping cases with non-missing education, sex, and race
dis _N
drop if mi(w4edu, female, race)


*** saving data for descriptive statistics
save "attr-data-3", replace


*** dropping unnecessary variables
drop aid w2age w3age w4age psuscid gswgt4_2


*** running multiple imputation
mi set flong
mi register imputed *phyatt *peratt paredu lninc pvt gpa region *bmi *hgt ///
  w1age w4agr w4ext w4mas
  
mi register regular female race w4edu famst5 
mi impute chained (ologit) *phyatt *peratt paredu (regress) lninc pvt gpa ///
  w1age *bmi *hgt w4agr w4ext w4mas (mlogit) region = female i.race i.famst5 ///
  i.w4edu, add(10) rseed(45962906) force dots
  

*** saving data for descriptive statistics
save "attr-data-mi-3", replace


*** creating indicators for family structure, race, and region and order data
forval i = 2/5 {
	mi passive: gen r`i' = ( race == `i' )
	mi passive: gen f`i' = ( famst5 == `i' )
	mi passive: gen rg`i' = ( region == `i' )
}
drop race famst5 region r5 rg5

order *phyatt *peratt w4edu w1age female r2 r3 r4 rg2 rg3 rg4 f2 f3 f4 f5 ///
  paredu lninc pvt gpa *bmi *hgt w4agr w4ext w4mas

*** saving data files for analysis in Mplus
forval i = 1/10 {
	preserve
	keep if _mi_m == `i'
	drop _mi*
	desc
	outsheet using attr-data-3-`i'.txt, replace comma nolabel noname
	restore
}
