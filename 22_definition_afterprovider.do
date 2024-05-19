********************************************************************************
*** CARAMAL DEFINITIONS: PROVIDER SUBSEQUENT TO ENROLLING PROVIDER *************
********************************************************************************

* Author:	NBNR
* Date:		12.03.2021

* Version control:
* 		- v1.0			NBNR		Defined subsequent provider for all countries

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

*** ALL COUNTRIES ***

capture confirm variable after_provider
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
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	D28, D28-DF

if ("$country" == "Nigeria") {

	// Provider subsequent to enrolling provider
	tempvar scnum spnum srnum
	gen `scnum' = .
	gen `spnum' = .
	gen `srnum' = .
	forvalues i = 1/4 {
		local j = `i' + 1
		replace `scnum' = d28_q15_`j' if d28_q15_`i' == 2 & `scnum' == .
		replace `spnum' = d28_q15_`j' if (d28_q15_`i' == 12 | d28_q15_`i' == 14) & `spnum' == .
		replace `srnum' = d28_q15_`j' if d28_q15_`i' == 11 & `srnum' == .
	}
	
	forvalues i = 1/5 {
		local j = `i' + 1
		replace `scnum' = df_q15_`j' if df_q15_`i' == 2 & `scnum' == .
		replace `spnum' = df_q15_`j' if (df_q15_`i' == 12 | df_q15_`i' == 14) & `spnum' == .
		replace `srnum' = df_q15_`j' if df_q15_`i' == 11 & `srnum' == .
	}
	
	gen after_provider = `scnum' if enrol_location == 1
		replace after_provider = `spnum' if enrol_location == 2
		replace after_provider = `srnum' if enrol_location == 3
		replace after_provider = 0 if first_provider != . & after_provider == .
		label define place_category 0 "No provider", add
		label values after_provider place_category
		label variable after_provider "Provider seen subsequent to enrolling provider"
	
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	D28, D28-DF

if ("$country" == "Uganda") {
	// Provider subsequent to enrolling provider
	tempvar scnum spnum srnum
	gen `scnum' = .
	gen `spnum' = .
	gen `srnum' = .
	forvalues i = 1/5 {
		local j = `i' + 1
		replace `scnum' = d28_q15_`j' if d28_q15_`i' == 2 & `scnum' == .
		replace `spnum' = d28_q15_`j' if d28_q15_`i' == 11 & `spnum' == .
		replace `srnum' = d28_q15_`j' if d28_q15_`i' == 13 & `srnum' == .
	}
	
	forvalues i = 1/7 {
		local j = `i' + 1
		replace `scnum' = df_q15_`j' if df_q15_`i' == 2 & `scnum' == .
		replace `spnum' = df_q15_`j' if df_q15_`i' == 11 & `spnum' == .
		replace `srnum' = df_q15_`j' if df_q15_`i' == 13 & `srnum' == .
	}
	
	gen after_provider = `scnum' if enrol_location == 1
		replace after_provider = `spnum' if enrol_location == 2
		replace after_provider = `srnum' if enrol_location == 3
		replace after_provider = 0 if first_provider != . & after_provider == .
		label define place_category 0 "No provider", add
		label values after_provider place_category
		label variable after_provider "Provider seen subsequent to enrolling provider"
}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	D28, D28-DF

if ("$country" == "DRC") 

{
// Provider subsequent to enrolling provider
	tempvar scnum spnum srnum
	gen `scnum' = .
	gen `spnum' = .
	gen `srnum' = .
	forvalues i = 1/6 {
		local j = `i' + 1
		replace `scnum' = d28_q15_`j' if d28_q15_`i' == 2 & `scnum' == .
		replace `spnum' = d28_q15_`j' if (d28_q15_`i' == 11 | d28_q15_`i' == 12) & `spnum' == .
		replace `srnum' = d28_q15_`j' if d28_q15_`i' == 13 & `srnum' == .
	}
	
	forvalues i = 1/4 {
		local j = `i' + 1
		replace `scnum' = df_q15_`j' if df_q15_`i' == 2 & `scnum' == .
		replace `spnum' = df_q15_`j' if (df_q15_`i' == 11 | df_q15_`i' == 12) & `spnum' == .
		replace `srnum' = df_q15_`j' if df_q15_`i' == 13 & `srnum' == .
	}
	
	gen after_provider = `scnum' if enrol_location == 1
		replace after_provider = `spnum' if enrol_location == 2
		replace after_provider = `srnum' if enrol_location == 3
		replace after_provider = 0 if first_provider != . & after_provider == .
		label define place_category 0 "No provider", add
		label values after_provider place_category
		label variable after_provider "Provider seen subsequent to enrolling provider"
	
}

	






