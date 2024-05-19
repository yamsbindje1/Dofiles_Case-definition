********************************************************************************
*** CARAMAL DEFINITIONS: DELAY TO FIRST PROVIDER *******************************
********************************************************************************

* Author:	NBNR
* Date:		29.03.2021

* Version control:
* 		- v1.0			NBNR		Defined delay to first provider for all countries

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

*** ALL COUNTRIES ***

capture confirm variable first_delay
if !_rc == 0 {
	gen first_delay = .
		replace first_delay = d28_q16_1 if d28_q16_1 <= d28_q16_2
		replace first_delay = df_q16_1 if df_q16_1 <= df_q16_2 & first_delay == .
		replace first_delay = . if first_delay == -98
		
	label variable first_delay "Time/delay to first provider after onset of illness (in days)"
}

*------------------------------------------------------------------------------*






