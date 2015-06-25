*** Purpose: descriptives for attractiveness analysis
*** Author: S Bauldry
*** Date: October 28, 2014

use "attr-data-mi-3", replace

foreach x of varlist w4edu paredu lninc {
	mi est: mean `x'
}

foreach x of varlist *phyatt *peratt {
	mi est: mean `x'
}

foreach x of varlist w1age pvt gpa w1bmi {
	mi est: mean `x'
}

foreach x of varlist female r2-r4 rg2-rg4 f2-f5 {
	mi est: mean `x'
}
