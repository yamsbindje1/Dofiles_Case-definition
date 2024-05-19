********************************************************************************
*** CARAMAL DEFINITIONS: CONSENT ***********************************************
********************************************************************************

* Author:	NBNR
* Date:		20.01.2021

* Version control:
* 		- v1.0			NBNR		Defined overall consent for all countries
*		- v1.1			NBNR		Added variable label
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

*** ALL COUNTRIES ***

capture confirm variable consent
	if !_rc == 0 {

* Required dataset: 	D28, D28-DF, REF

* Consolidate consent: Consent on D28(-DF) F/U - no consent refused
	gen consent = 0
		replace consent = 1 if 											///
		   (d28_confirm_con_rhf == 1 | d28_confirm_con2 == 1 | df_confirm_con2 == 1) ///
		   & (d28_confirm_con2 != 0 & ref_confirm_con2 != 0 & df_confirm_con2 != 0) 
		   
	label variable consent "Consolidated: Consent"

	}




