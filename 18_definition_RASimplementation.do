********************************************************************************
*** CARAMAL DEFINITIONS: RAS IMPLEMENTATION ************************************
********************************************************************************

* Author:	NBNR
* Date:		03.03.2021

* Version control:
* 		- v1.0			NBNR		Define cut-off between pre- and post-implementation
*		- v1.1			GDEO		Replaced country enrolment dates with enrolment date definition
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

* Questions:
*		- Which variable to use in Uganda? Which one will be cleaned?


*------------------------------------------------------------------------------*

capture confirm variable ras_intro
	if !_rc == 0 {

// Generate auxiliary variables
capture confirm variable enrolmentdate
	if !_rc == 0 {
		do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\20_definition_enrolmentdate.do"
	}	
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset:		CCR

if ("$country" == "Nigeria") {
	// Generate variable that indicates if enrollment was before or after implemetation of RAS
	gen ras_intro = 0
		replace ras_intro = 1 if enrolmentdate > td(01may2019)
		replace ras_intro = . if enrolmentdate ==.
		
		label variable ras_intro "CARAMAL project phase"
		label define ras_intro 0 "Pre-RAS" 1 "Post-RAS", replace
		label values ras_intro ras_intro
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	CCR

if ("$country" == "Uganda") {
	// Generate variable that indicates if enrollment was before or after implemetation of RAS
	gen ras_intro = 0
		replace ras_intro = 1 if enrolmentdate > td(01april2019)
		replace ras_intro = . if enrolmentdate ==.
		
		label variable ras_intro "CARAMAL project phase"
		label define ras_intro 0 "Pre-RAS" 1 "Post-RAS", replace
		label values ras_intro ras_intro
}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	CCR

if ("$country" == "DRC") {
	gen ras_intro = 0
		replace ras_intro = 1 if enrolmentdate > td(01april2019)
		replace ras_intro = . if enrolmentdate ==.
		
		label variable ras_intro "CARAMAL project phase"
		label define ras_intro 0 "Pre-RAS" 1 "Post-RAS", replace
		label values ras_intro ras_intro
}

	}
