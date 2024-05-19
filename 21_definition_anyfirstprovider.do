********************************************************************************
*** CARAMAL DEFINITIONS: ANY FIRST PROVIDER ************************************
********************************************************************************

* Author:	NBNR
* Date:		12.03.2021

* Version control:
* 		- v1.0			NBNR		Defined any first provider for all countries

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

*** ALL COUNTRIES ***

capture confirm variable first_provider_any
	if !_rc == 0 {
	    
capture confirm variable first_provider
if !_rc == 0 {
    do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\9_definition_firstprovider.do"
}

* Required dataset: 	D28, D28-DF

	// Any first provider seen by child
	clonevar first_provider_any = d28_q15_1
		replace first_provider_any = df_q15_1 if first_provider_any == .
		// Set to missing if enrolling provider was not mentioned
		replace first_provider_any = . if first_provider == .
		label variable first_provider_any "Any first provider seen by child"

	}




