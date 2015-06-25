*** Purpose: to prepare data for analysis of attractiveness
*** Author: S Bauldry
*** Date: October 28, 2014

****** paths to data
global sb "[enter path]"


*** merging sibling IDs
use "attr-data-3", replace
merge 1:1 aid using "$sb"
keep if _merge == 3
drop _merge

*** keeping sibling pairs
bysort famid: gen cnt = _N
keep if cnt >= 2

bysort famid: gen sib = _n
keep if sib < 3

*** keeping analysis variables
rename (w1phyatt w2phyatt w3phyatt w1peratt w2peratt w3peratt w1bmi) ///
       (phy1 phy2 phy3 per1 per2 per3 bmi)
keep famid sib w4edu pvt gpa bmi phy1 phy2 phy3 per1 per2 per3 paredu lninc
reshape wide w4edu pvt gpa bmi phy1 phy2 phy3 per1 per2 per3 paredu lninc, ///
     i(famid) j(sib)

*** multiple imputation
mi set flong
mi register imputed phy* per* paredu* lninc* bmi* gpa* pvt*
mi impute chained (ologit)  phy* per* paredu* ///
                  (regress) lninc* bmi* gpa* pvt* = ///
				            w4edu*, add(10) rseed(63889535) dots augment

*** saving data for analysis in Mplus
order famid w4edu* phy* per* paredu* lninc* bmi* gpa* pvt*
forval i = 1/10 {
	preserve
	keep if _mi_m == `i'
	drop _mi*
	desc
	outsheet using attr-sib-data-3-`i'.txt, replace comma nolabel noname
	restore
}  
