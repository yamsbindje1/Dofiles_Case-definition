********************************************************************************
*** CARAMAL DEFINITIONS: FEVER *************************************************
********************************************************************************

* Author:	NBNR
* Date:		27.01.2021

* Version control:
* 		- v1.0			NBNR		Defined fever for all countries
*		- v1.1			NBNR		Added variable label
*		- v1.2			NBNR		UG+DRC - D0: If CHW register was not filled oral 
*									confirmation of CHW is sufficient. 
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

* Questions: 

*------------------------------------------------------------------------------*

capture confirm variable anyfever
	if !_rc == 0 {
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	D28, D28-DF, REF, D0

if ("$country" == "Nigeria") {
	* Consolidate history of fever: Reported in any data source
	gen anyfever = 0
		replace anyfever = 1 if ref_fever == 1					// Fever according to REF
		replace anyfever = 1 if d28_q6 == 1 | d28_q11_18 == 1 	// Fever according to D28
		replace anyfever = 1 if df_q6 == 1 | df_q11_18 == 1		// Fever according to D28-DF
		replace anyfever = 1 if d0_danger_signs_4 == 1 			// Fever according to D0
		
		label variable anyfever "Consolidated: Fever (D0, REF, D28(-DF))"
}
		
*------------------------------------------------------------------------------*		
		
*** UGANDA ***

* Required datasets:	D28, D28-DF, REF, D0

if ("$country" == "Uganda") {
	* Consolidate history of fever: Reported in any data source
	gen anyfever = 0
		replace anyfever = 1 if ref_fever == 1				// Fever according to REF
		replace anyfever = 1 if d28_q6 == 1 | d28_q11_18 == 1
															// Fever according to D28
		replace anyfever = 1 if df_q6 == 1 | df_q11 == 18	// Fever according to D28-DF
		replace anyfever = 1 if d0_reg_fever == 1 | 		///
							(d0_vht_fever == 1 & d0_reg_fever == -99) | d0_confirm_fever 															// Fever according to D0
		
		label variable anyfever "Consolidated: Fever (D0, REF, D28(-DF))"
}
	
*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required datasets: 	D28, D28-DF, REF, D0

if ("$country" == "DRC") {
	* Consolidate history of fever: Reported in any data source
	gen anyfever = 0
		replace anyfever = 1 if ref_fever == 1				// Fever according to REF
		replace anyfever = 1 if d28_q6 == 1 | d28_q11_18 == 1 	
															// Fever according to D28 
		replace anyfever = 1 if df_q6 == 1 | df_q11_18 == 1	// Fever according to D28-DF (Code for "Nigerian-splitted" q11)
		replace anyfever = 1 if d0_reg_fever == 1 | 		///
							(d0_vht_fever == 1 & d0_reg_fever == -99)			
															// Fever according to D0
															
		label variable anyfever "Consolidated: Fever (D0, REF, D28(-DF))"
}

	}
