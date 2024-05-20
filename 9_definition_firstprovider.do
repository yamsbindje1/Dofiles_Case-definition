********************************************************************************
*** CARAMAL DEFINITIONS: FIRST PSS PROVIDER ************************************
********************************************************************************

* Author:	Yams
* Date:		11.05.2021

* Version control:
* 		- v1.0			Yams		Defined first contact with PSS provider
*		- v1.1			Yams		Set to missing if enrolling provider is missing
*		- v1.2			Yams		Separated d28 and df
*		- v1.3			Yams		Corrected label of DRC definition
*		- *please enter changes here

* Note: Use "\\Yams.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

capture confirm variable first_provider 
	if !_rc == 0 {
	    
// Generate auxiliary variable
capture confirm variable enrol_location
	if !_rc == 0 {
	    do "\\Yams.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\8_definition_enrollmentlocation.do"
	}
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	D28, D28-DF

if ("$country" == "Nigeria") {
	/* Create variable for first contact with PSS */
	
	// Establish sequence of providers
	tempvar cnum pnum rnum
	gen `cnum' = .
	gen `pnum' = .
	gen `rnum' = .

	forvalues i = 1/5 {
		replace `cnum' = `i' if `cnum' == . & d28_q15_`i' == 2
		replace `pnum' = `i' if `pnum' == . & (d28_q15_`i' == 12 | d28_q15_`i' == 14) 
		replace `rnum' = `i' if `rnum' == . & d28_q15_`i' == 11
		}
	forvalues i = 1/6 {
		replace `cnum' = `i' if `cnum' == . & df_q15_`i' == 2
		replace `pnum' = `i' if `pnum' == . & (df_q15_`i' == 12 | df_q15_`i' == 14)
		replace `rnum' = `i' if `rnum' == . & df_q15_`i' == 11
		}
		
	// Establish if enrolling provider is missing
	tempvar chw phc rhf enrol_miss
	
	egen `chw' = anymatch(d28_q15_* df_q15_*), val(2)
		replace `chw' = . if d28_q15_1 == . & df_q15_1 == .
	egen `phc' = anymatch(d28_q15_* df_q15_*), val(12 14)
		replace `phc' = . if d28_q15_1 == . & df_q15_1 == .
	egen `rhf' = anymatch(d28_q15_* df_q15_*), val(11)
		replace `rhf' = . if d28_q15_1 == . & df_q15_1 == .
	
	gen `enrol_miss' = .
		replace `enrol_miss' = `chw' if enrol_location == 1
		replace `enrol_miss' = `phc' if enrol_location == 2
		replace `enrol_miss' = `rhf' if enrol_location == 3
	
	// Generate variable for first provider
	gen first_provider = .
		replace first_provider = 1 if `cnum' < `rnum' & `cnum' < `pnum'
		replace first_provider = 2 if `pnum' < `rnum' & `pnum' < `cnum'
		replace first_provider = 3 if `rnum' < `cnum' & `rnum' < `pnum'
	
	// Replace with missing if enrolling provider is missing
	replace first_provider = . if `enrol_miss' == 0  | `enrol_miss' == .
	
	label variable first_provider "First contact with PSS provider"
	label define hfcat 1 "CHW (CORP)" 2 "PHC (PHC / Health post)" 3 "RHF (Cottage Hospital)", replace
	label values first_provider hfcat
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	D28, D28-DF

if ("$country" == "Uganda") {
	/* Create variable for first contact with PSS */
	
	// Establish sequence of providers
	tempvar cnum pnum rnum
	gen `cnum' = .
	gen `pnum' = .
	gen `rnum' = .

	forvalues i = 1/6 {
		replace `cnum' = `i' if `cnum' == . & d28_q15_`i' == 2
		replace `pnum' = `i' if `pnum' == . & d28_q15_`i' == 11
		replace `rnum' = `i' if `rnum' == . & d28_q15_`i' == 13 
		}
	forvalues i = 1/8 {
		replace `cnum' = `i' if `cnum' == . & df_q15_`i' == 2
		replace `pnum' = `i' if `pnum' == . & df_q15_`i' == 11
		replace `rnum' = `i' if `rnum' == . & df_q15_`i' == 13
		}
		
	// Establish if enrolling provider is missing
	tempvar chw phc rhf enrol_miss
	
	egen `chw' = anymatch(d28_q15_* df_q15_*), val(2)
		replace `chw' = . if d28_q15_1 == . & df_q15_1 == .
	egen `phc' = anymatch(d28_q15_* df_q15_*), val(11)
		replace `phc' = . if d28_q15_1 == . & df_q15_1 == .
	egen `rhf' = anymatch(d28_q15_* df_q15_*), val(13)
		replace `rhf' = . if d28_q15_1 == . & df_q15_1 == .
	
	gen `enrol_miss' = .
		replace `enrol_miss' = `chw' if enrol_location == 1
		replace `enrol_miss' = `phc' if enrol_location == 2
		replace `enrol_miss' = `rhf' if enrol_location == 3
	
	// Generate variable for first provider
	gen first_provider = .
		replace first_provider = 1 if `cnum' < `rnum' & `cnum' < `pnum'
		replace first_provider = 2 if `pnum' < `rnum' & `pnum' < `cnum'
		replace first_provider = 3 if `rnum' < `cnum' & `rnum' < `pnum'
		
	// Replace with missing if enrolling provider is missing
	replace first_provider = . if `enrol_miss' == 0  | `enrol_miss' == .
	
	label variable first_provider "First contact with PSS provider"
	label define hfcat 1 "CHW (VHT)" 2 "PHC (HC II)" 3 "RHF (HC IV / Hospital)", replace
	label values first_provider hfcat
}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	D28, D28-DF

if ("$country" == "DRC") {
	/* Create variable for first contact with PSS */
	
	// Establish sequence of providers
	tempvar cnum pnum rnum
	gen `cnum' = .
	gen `pnum' = .
	gen `rnum' = .

	forvalues i = 1/7 {
		replace `cnum' = `i' if `cnum' == . & d28_q15_`i' == 2
		replace `pnum' = `i' if `pnum' == . & (d28_q15_`i' == 11 | d28_q15_`i' == 12)
		replace `rnum' = `i' if `rnum' == . & d28_q15_`i' == 13
		}
	forvalues i = 1/5 {
		replace `cnum' = `i' if `cnum' == . & df_q15_`i' == 2
		replace `pnum' = `i' if `pnum' == . & (df_q15_`i' == 11 | df_q15_`i' == 12)
		replace `rnum' = `i' if `rnum' == . & df_q15_`i' == 13
		}
		
	// Establish if enrolling provider is missing
	tempvar chw phc rhf enrol_miss
	
	egen `chw' = anymatch(d28_q15_* df_q15_*), val(2)
		replace `chw' = . if d28_q15_1 == . & df_q15_1 == .
	egen `phc' = anymatch(d28_q15_* df_q15_*), val(11 12)
		replace `phc' = . if d28_q15_1 == . & df_q15_1 == .
	egen `rhf' = anymatch(d28_q15_* df_q15_*), val(13)
		replace `rhf' = . if d28_q15_1 == . & df_q15_1 == .
	
	gen `enrol_miss' = .
		replace `enrol_miss' = `chw' if enrol_location == 1
		replace `enrol_miss' = `phc' if enrol_location == 2
		replace `enrol_miss' = `rhf' if enrol_location == 3
		
	// Generate variable for first provider
	gen first_provider = .
		replace first_provider = 1 if `cnum' < `rnum' & `cnum' < `pnum'
		replace first_provider = 2 if `pnum' < `rnum' & `pnum' < `cnum'
		replace first_provider = 3 if `rnum' < `cnum' & `rnum' < `pnum'
		
	// Replace with missing if enrolling provider is missing
	replace first_provider = . if `enrol_miss' == 0 | `enrol_miss' == .
	
	label variable first_provider "First contact with PSS provider"
	label define hfcat 1 "CHW (SSC)" 2 "PHC (PS/CS)" 3 "RHF (CSR/HGR)", replace
	label values first_provider hfcat

}

	}
