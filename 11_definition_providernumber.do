********************************************************************************
*** CARAMAL DEFINITIONS: NUMBER OF PROVIDERS ***********************************
********************************************************************************

* Author:	NBNR
* Date:		12.01.2020

* Version control:
* 		- v1.0			NBNR		Defined number of providers for all countries
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

* Questions:


*------------------------------------------------------------------------------*

*** Valid in all countries ***

* Required dataset: 	D28, D28-DF

capture confirm variable count_provider
if !_rc == 0 {
	/* Create variable for number of providers */
	egen count_provider = rownonmiss(d28_q15_* df_q15_*)
	
	label variable count_provider "D28(-DF): Number of providers visited"

}



