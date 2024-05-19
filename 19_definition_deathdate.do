********************************************************************************
*** CARAMAL DEFINITIONS: DATE OF DEATH *****************************************
********************************************************************************

* Author:	NBNR
* Date:		05.03.2021

* Version control:
* 		- v1.0			NBNR		Consolidated date of death for all countries
*		- v1.1			NBNR		UG: Added final health outcome 
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 


*------------------------------------------------------------------------------*

capture confirm variable deathdate 
	if !_rc == 0 {
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset:	CCR, REF, D28, D28-DF

if ("$country" == "Nigeria") {
	gen deathdate = 0 if ccr_d28_status == 3
		replace deathdate = ref_death_date if ref_death_date != . & deathdate == 0
		replace deathdate = d28_q1a if d28_q1a != . & deathdate == 0
		replace deathdate = df_dx if df_dx != . & deathdate == 0
	label variable deathdate "Date of death"
	format deathdate %td
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	REF, D28, D28-DF
if ("$country" == "Uganda") {
	gen deathdate = 0 if ccr_death == 1
		replace deathdate = ref_death_date if ref_death_date != . & deathdate == 0
		replace deathdate = d28_q1a if d28_q1a != . & deathdate == 0
		replace deathdate = df_dx if df_dx != . & deathdate == 0
	label variable deathdate "Date of death"
	format deathdate %td
}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	REF, D28, D28-DF

if ("$country" == "DRC") {
	gen deathdate = 0 if ccr_final_outcome == 0 | ccr_final_outcome == 3
		replace deathdate = ref_death_date if ref_death_date != . & deathdate == 0
		replace deathdate = d28_q1a if d28_q1a != . & deathdate == 0
		replace deathdate = df_dx if df_dx != . & deathdate == 0

	label variable deathdate "Date of death"
	format deathdate %td
}

	}
