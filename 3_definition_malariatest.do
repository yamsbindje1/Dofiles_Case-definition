********************************************************************************
*** CARAMAL DEFINITIONS: POSITIVE MALARIA TEST *********************************
********************************************************************************

* Author:	NBNR
* Date:		03.02.2021

* Version control:
* 		- v1.0			NBNR		Defined positive malaria test for all countries
*		- v1.1			NBNR		Redefined after discussion in weekly meeting
*		- v1.2			NBNR 		Added mtest_d28_pss and mtest_enrol_d28_pss
*									UG+DRC - D0: If CHW register was not filled oral 
*									confirmation of CHW is sufficient. 
*		- v1.3			NBNR		Added "14. Health post" to Nigerian definition of
*									mtest_d28_pss.
*		- please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

* Note: This code uses variables that were converted from long to wide format. 
* An underscore was added to variables before reshaping. I.e. d28_q25 is now
* q25_1, q25_2 etc.

*------------------------------------------------------------------------------*

capture confirm variable mtest_d28 
	if !_rc == 0 {

// Check if auxiliary variable(s) already exist
capture confirm variable enrol_location
	if !_rc == 0 {
		do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\8_definition_enrollmentlocation.do"
	}
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	REF, D0, (D28, D28-DF)

if ("$country" == "Nigeria") {
	* D28(-DF)
	// Any provider
	egen mtest_d28 = anymatch(d28_q25_* df_q25_*), val(1)
	// PSS provider
	gen mtest_d28_pss = 0
	forvalues i = 1/5 {
	    replace mtest_d28_pss = 1 if (d28_q25_`i' == 1 & (d28_q15_`i' == 2 |	///
									  d28_q15_`i' == 11 | d28_q15_`i' == 12 |	///
									  d28_q15_`i' == 14))	
		}
	forvalues i = 1/6 {
	    replace mtest_d28_pss = 1 if (df_q25_`i' == 1 & (df_q15_`i' == 2 |		///
									  df_q15_`i' == 11 | df_q15_`i' == 12 |		///
									  df_q15_`i' == 14))
		}
	* REF
	egen mtest_ref = anymatch(ref_mrdt_arrival ref_slide_arrival), val(1)
	forvalues i = 1/14	{
		replace mtest_ref = 1 if  ref_slide_`i' == 1
		replace mtest_ref = 1 if  ref_mrdt_`i' == 1
		replace mtest_ref = 1 if ref_q141_2_`i' == 1
		}

	* Consolidate positive malaria test: Reported on day of enrolment 
	* (Community enrollments: D0 / RHF enrollments: REF on arrival)
	egen mtest_enrol = anymatch(ref_mrdt_arrival ref_slide_arrival) 		///
						if enrol_location == 3, val(1)
		replace mtest_enrol = (d0_rdt_result == 1) 							///
						if enrol_location == 1 | enrol_location == 2

	* Consolidate positive malaria test: Reported on day of enrolment or D28
	* (Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28)
	clonevar mtest_enrol_d28 = mtest_enrol
		replace mtest_enrol_d28 = 1 if mtest_d28 == 1
		
	* Consolidate positiv malaria test: 
	* Reported on day of enrolment or D28 (by public provider)
	* (Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28)
	clonevar mtest_enrol_d28_pss = mtest_enrol
		replace mtest_enrol_d28_pss = 1 if mtest_d28_pss == 1

		label variable mtest_d28 "Malaria test result - D28"
		label variable mtest_d28_pss "Malaria test result - D28 (public provider)"
		label variable mtest_ref "Malaria test result - REF (on arrival / on admission)"
		label variable mtest_enrol "Malaria test result - Community enrollments: D0 / RHF enrollments: REF on arrival"
		label variable mtest_enrol_d28 "Malaria test result - Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28"
		label variable mtest_enrol_d28_pss "Malaria test result - Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28 (public provider)"
		label define test 0 "Negative / Not done" 1 "Positive", replace
		label values mtest* test
}
	
*------------------------------------------------------------------------------*		
*** UGANDA ***

* Required dataset: 	REF, D0, (D28, D28-DF)

if ("$country" == "Uganda") {
		
	* D28(-DF)
	// Any provider
	egen mtest_d28 = anymatch(d28_q25_* df_q25_*), val(1)
	// PSS provider
	gen mtest_d28_pss = 0
	forvalues i = 1/6 {
	    replace mtest_d28_pss = 1 if (d28_q25_`i' == 1 & (d28_q15_`i' == 2 |	///
									  d28_q15_`i' == 11 | d28_q15_`i' == 12 |	///
									  d28_q15_`i' == 13))	
		}
	forvalues i = 1/8 {
	    replace mtest_d28_pss = 1 if (df_q25_`i' == 1 & (df_q15_`i' == 2 |		///
									  df_q15_`i' == 11 | df_q15_`i' == 12 |		///
									  df_q15_`i' == 13))
		}
	* REF
	egen mtest_ref = anymatch(ref_mrdt_arrival ref_slide_arrival), val(1)
	forvalues i = 1/41	{
		capture replace mtest_ref = 1 if  ref_slide_`i' == 1
		capture replace mtest_ref = 1 if  ref_mrdt_`i' == 1
		}

	* Consolidate positive malaria test: Reported on day of enrolment 
	* (Community enrollments: D0 / RHF enrollments: REF on arrival)
	egen mtest_enrol = anymatch(ref_mrdt_arrival ref_slide_arrival) 		///
						if enrol_location == 3, val(1)
		replace mtest_enrol = (d0_reg_rdt == 1 | 							///
								(d0_vht_rdt == 1 & d0_reg_rdt == -99)) 		///
								if enrol_location == 1 | enrol_location == 2

	* Consolidate positiv malaria test: Reported on day of enrolment or D28
	* (Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28)
	clonevar mtest_enrol_d28 = mtest_enrol
		replace mtest_enrol_d28 = 1 if mtest_d28 == 1
		
	* Consolidate positiv malaria test: 
	* Reported on day of enrolment or D28 (by public provider)
	* (Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28)
	clonevar mtest_enrol_d28_pss = mtest_enrol
		replace mtest_enrol_d28_pss = 1 if mtest_d28_pss == 1

		label variable mtest_d28 "Malaria test result - D28"
		label variable mtest_d28_pss "Malaria test result - D28 (public provider)"
		label variable mtest_ref "Malaria test result - REF (on arrival / on admission)"
		label variable mtest_enrol "Malaria test result - Community enrollments: D0 / RHF enrollments: REF on arrival"
		label variable mtest_enrol_d28 "Malaria test result - Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28"
		label variable mtest_enrol_d28_pss "Malaria test result - Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28 (public provider)"
		label define test 0 "Negative / Not done" 1 "Positive", replace
		label values mtest* test
}	
	
*------------------------------------------------------------------------------*
	
*** DRC *** // work in progress

* Required dataset: 	REF, D0, (D28, D28-DF)

if ("$country" == "DRC") {
	* D28(-DF)
	capture rename *_oth* *oth*
	// Any provider
	egen mtest_d28 = anymatch(d28_q25_* df_q25_*), val(1)
	// PSS provider
	gen mtest_d28_pss = 0
	forvalues i = 1/7 {
	    replace mtest_d28_pss = 1 if (d28_q25_`i' == 1 & (d28_q15_`i' == 2 |	///
									  d28_q15_`i' == 11 | d28_q15_`i' == 12 |	///
									  d28_q15_`i' == 13))	
		}
	forvalues i = 1/5 {
	    replace mtest_d28_pss = 1 if (df_q25_`i' == 1 & (df_q15_`i' == 2 |		///
									  df_q15_`i' == 11 | df_q15_`i' == 12 |		///
									  df_q15_`i' == 13))
		}
	* REF
	egen mtest_ref = anymatch(ref_mrdt_arrival ref_slide_arrival), val(1)
	forvalues i = 1/41	{
		capture replace mtest_ref = 1 if  ref_slide_`i' == 1
		capture replace mtest_ref = 1 if  ref_mrdt_`i' == 1
	}

	* Consolidate positive malaria test: Reported on day of enrolment 
	* (Community enrollments: D0 / RHF enrollments: REF on arrival)
	egen mtest_enrol = anymatch(ref_mrdt_arrival ref_slide_arrival) 		///
						if enrol_location == 3, val(1)
		replace mtest_enrol = (d0_reg_rdt == 1 |							///
								(d0_vht_rdt == 1 & d0_reg_rdt == -99))		///
								if enrol_location == 1 | enrol_location == 2

	* Consolidate positiv malaria test: 
	* Reported on day of enrolment or D28 (by any kind of provider)
	* (Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28)
	clonevar mtest_enrol_d28 = mtest_enrol
		replace mtest_enrol_d28 = 1 if mtest_d28 == 1
		
	* Consolidate positiv malaria test: 
	* Reported on day of enrolment or D28 (by public provider)
	* (Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28)
	clonevar mtest_enrol_d28_pss = mtest_enrol
		replace mtest_enrol_d28_pss = 1 if mtest_d28_pss == 1

		label variable mtest_d28 "Malaria test result - D28 (any provider)"
		label variable mtest_d28_pss "Malaria test result - D28 (public provider)"
		label variable mtest_ref "Malaria test result - REF (on arrival / on admission)"
		label variable mtest_enrol "Malaria test result - Community enrollments: D0 / RHF enrollments: REF on arrival"
		label variable mtest_enrol_d28 "Malaria test result - Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28 (any provider)"
		label variable mtest_enrol_d28_pss "Malaria test result - Community enrollments: D0 or D28 / RHF enrollments: REF on arrival or D28 (public provider)"
		label define test 0 "Negative / Not done" 1 "Positive", replace
		label values mtest* test
}


	}
