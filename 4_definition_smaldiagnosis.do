********************************************************************************
*** CARAMAL DEFINITIONS: SEVERE MALARIA DIAGNOSIS ******************************
********************************************************************************

* Author:	NBNR
* Date:		27.01.2021

* Version control:
* 		- v1.0			NBNR		Defined severe malaria diagniosis for all countries
*		- v1.1			NBNR		Added diagnosis during admission (adm_smal)
*									Changed to one code for all countries
*		- * please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

* Question:

*------------------------------------------------------------------------------*

*** VALID IN ALL COUNTRIES ***

* Required dataset: 	REF

// Run code for enrollment location (requires CCR)
capture confirm variable enrol_location
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\8_definition_enrollmentlocation.do"
}
	
// Generate variable for severe malaria diagnosis on or during admission (RHF enrollments)
	egen smal_admission = anymatch(ref_adm_smal*), val(1)
		replace smal_admission = 1 if (ref_adm_smal_arrival == 1 | 		///	
										ref_med_hist_smal == 1) & enrol_loc == 3
		replace smal_admission = . if enrol_location != 3
										
	label variable smal_admission "Severe malaria diagnosis (RHF enrollments)"
	label define yesno 0 "No" 1 "Yes", replace
	label values smal_admission yesno
	
