********************************************************************************
*** CARAMAL DEFINITIONS: REFERRAL DELAY ****************************************
********************************************************************************

* Author:	NBNR
* Date:		23.03.2021

* Version control:
* 		- v1.0			NBNR		Defined referral delay for all countries

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

*** ALL COUNTRIES ***

capture confirm variable referral_delay
	if !_rc == 0 {
	    
// Generate auxiliary variable
capture confirm variable enrol_location
	if !_rc == 0 {
	    do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\8_definition_enrollmentlocation.do"
	}
capture confirm variable first_provider
	if !_rc == 0 {
	    do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\9_definition_firstprovider.do"
	}
capture confirm variable referral_rhf
	if !_rc == 0 {
	    do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\10_definition_referralcompletion.do"
	}
capture confirm variable enrolmentdate
	if !_rc == 0 {
		do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\20_definition_enrolmentdate.do"
	}
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	REF, D28, D28-DF

if ("$country" == "Nigeria") {

	// Referral delay D28(-DF)
	tempvar cnum pnum rnum scnum spnum srnum
	gen `cnum' = .
	gen `pnum' = .
	gen `rnum' = .
	gen `scnum' = .
	gen `spnum' = .
	gen `srnum' = .
	forvalues i = 1/5 {
	    replace `cnum' = `i' if d28_q15_`i' == 2 & `cnum' == .
		replace `pnum' = `i' if (d28_q15_`i' == 12 | d28_q15_`i' == 14) & `pnum' == .
		replace `rnum' = `i' if d28_q15_`i' == 11 & `rnum' == .
		replace `scnum' = d28_q16_`i' if d28_q15_`i' == 2 & `scnum' == .
		replace `spnum' = d28_q16_`i' if (d28_q15_`i' == 12 | d28_q15_`i' == 14) & `spnum' == .
		replace `srnum' = d28_q16_`i' if d28_q15_`i' == 11 & `srnum' == .
	}
	
	forvalues i = 1/6 {
	    replace `cnum' = `i' if df_q15_`i' == 2 & `cnum' == .
		replace `pnum' = `i' if (df_q15_`i' == 12 | df_q15_`i' == 14) & `pnum' == .
		replace `rnum' = `i' if df_q15_`i' == 11 & `rnum' == .
		replace `scnum' = df_q16_`i' if df_q15_`i' == 2 & `scnum' == .
		replace `spnum' = df_q16_`i' if (df_q15_`i' == 12 | df_q15_`i' == 14) & `spnum' == .
		replace `srnum' = df_q16_`i' if df_q15_`i' == 11 & `srnum' == .
	}
	
	gen referral_delay = `srnum' - `scnum' if enrol_location == 1 & `cnum' < `rnum'
		replace referral_delay = `srnum' - `spnum' if enrol_location == 2 & `pnum' < `rnum'
		replace referral_delay = . if first_provider == .
		replace referral_delay = . if referral_delay < 0 | referral_delay > 28
		
	// Replace with eferral delay REF if missing
	replace referral_delay = ref_date_adm - enrolmentdate if referral_rhf == 1 & referral_delay == .
		replace referral_delay = . if referral_delay < 0 | referral_delay > 28
	
	label variable referral_delay "Referral delay (days)"
	
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	D28, D28-DF

if ("$country" == "Uganda") {
    
	// Referral delay D28(-DF)
	tempvar cnum pnum rnum scnum spnum srnum
	gen `cnum' = .
	gen `pnum' = .
	gen `rnum' = .
	gen `scnum' = .
	gen `spnum' = .
	gen `srnum' = .
	forvalues i = 1/6 {
	    replace `cnum' = `i' if d28_q15_`i' == 2 & `cnum' == .
		replace `pnum' = `i' if d28_q15_`i' == 11 & `pnum' == .
		replace `rnum' = `i' if d28_q15_`i' == 13 & `rnum' == .
		replace `scnum' = d28_q16_`i' if d28_q15_`i' == 2 & `scnum' == .
		replace `spnum' = d28_q16_`i' if d28_q15_`i' == 11 & `spnum' == .
		replace `srnum' = d28_q16_`i' if d28_q15_`i' == 13 & `srnum' == .
	}
	
	forvalues i = 1/8 {
	    replace `cnum' = `i' if df_q15_`i' == 2 & `cnum' == .
		replace `pnum' = `i' if df_q15_`i' == 11 & `pnum' == .
		replace `rnum' = `i' if df_q15_`i' == 13 & `rnum' == .
		replace `scnum' = df_q16_`i' if df_q15_`i' == 2 & `scnum' == .
		replace `spnum' = df_q16_`i' if df_q15_`i' == 11 & `spnum' == .
		replace `srnum' = df_q16_`i' if df_q15_`i' == 13 & `srnum' == .
	}
	
	gen referral_delay = `srnum' - `scnum' if enrol_location == 1 & `cnum' < `rnum'
		replace referral_delay = `srnum' - `spnum' if enrol_location == 2 & `pnum' < `rnum'
		replace referral_delay = . if first_provider == .
		replace referral_delay = . if referral_delay < 0 | referral_delay > 28
		
	// Replace with eferral delay REF if missing
	replace referral_delay = ref_date_adm - enrolmentdate if referral_rhf == 1 & referral_delay == .
		replace referral_delay = . if referral_delay < 0 | referral_delay > 28
	
	label variable referral_delay "Referral delay (days)"
}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	D28, D28-DF

if ("$country" == "DRC") {
    
	// Referral delay D28(-DF)
	tempvar cnum pnum rnum scnum spnum srnum
	gen `cnum' = .
	gen `pnum' = .
	gen `rnum' = .
	gen `scnum' = .
	gen `spnum' = .
	gen `srnum' = .
	forvalues i = 1/7 {
	    capture replace `cnum' = `i' if d28_q15_`i' == 2 & `cnum' == .
		capture replace `pnum' = `i' if (d28_q15_`i' == 11 | d28_q15_`i' == 12) & `pnum' == .
		capture replace `rnum' = `i' if d28_q15_`i' == 13 & `rnum' == .
		capture replace `scnum' = d28_q16_`i' if d28_q15_`i' == 2 & `scnum' == .
		capture replace `spnum' = d28_q16_`i' if (d28_q15_`i' == 11 | d28_q15_`i' == 12) & `spnum' == .
		capture replace `srnum' = d28_q16_`i' if d28_q15_`i' == 13 & `srnum' == .
	}
	
	forvalues i = 1/5 {
	    replace `cnum' = `i' if df_q15_`i' == 2 & `cnum' == .
		replace `pnum' = `i' if (df_q15_`i' == 11 | df_q15_`i' == 12) & `pnum' == .
		replace `rnum' = `i' if df_q15_`i' == 13 & `rnum' == .
		replace `scnum' = df_q16_`i' if df_q15_`i' == 2 & `scnum' == .
		replace `spnum' = df_q16_`i' if (df_q15_`i' == 11 | df_q15_`i' == 12) & `spnum' == .
		replace `srnum' = df_q16_`i' if df_q15_`i' == 13 & `srnum' == .
	}
	
	gen referral_delay = `srnum' - `scnum' if enrol_location == 1 & `cnum' < `rnum'
		replace referral_delay = `srnum' - `spnum' if enrol_location == 2 & `pnum' < `rnum'
		replace referral_delay = . if first_provider == .
		replace referral_delay = . if referral_delay < 0 | referral_delay > 28
		
	// Replace with eferral delay REF if missing
	replace referral_delay = ref_date_adm - enrolmentdate if referral_rhf == 1 & referral_delay == .
		replace referral_delay = . if referral_delay < 0 | referral_delay > 28
	
	label variable referral_delay "Referral delay (days)"
	
}

	}






