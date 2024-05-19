********************************************************************************
*** CARAMAL DEFINITIONS: ENROLLMENT LOCATION ***********************************
********************************************************************************

* Author:	NBNR
* Date:		26.01.2021

* Version control:
* 		- v1.0			NBNR		Defined enrollment location for all countries
*		- v1.1			NBNR		Corrected DRC categorization of providers
*		- v1.2			MAH			Added binary variable community-level enrolment no/yes
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

capture confirm variable enrol_location
	if !_rc == 0 {
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	CCR

if ("$country" == "Nigeria") {
    encode ccr_enrol_loc, gen(enrol_location)
	label variable enrol_location "Place of enrolment"
	label define hfcat2 1 "CHW (CORP)" 2 "PHC" 3 "RHF (Cottage Hospital)", replace
	label values enrol_location hfcat2
	
	gen enrol_community = enrol_location-3
	replace enrol_community = 1 if enrol_community <0
	label variable enrol_community "Enrolment at community provider (CHW/PHC)"
	label values enrol_community yesno
	
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	CCR

if ("$country" == "Uganda") {
    gen enrol_location = 3 if regexm(ccr_chw_name,"HC IV") 					///
							| regexm(ccr_chw_name,"Hospital")
		replace enrol_location = 2 if regexm(ccr_chw_name,"HC II")
		replace enrol_location = 1 if ccr_chw_name != "" & enrol_location == .
	label variable enrol_location "Place of enrolment"
	label define hfcat2 1 "CHW (VHT)" 2 "PHC (HC II)" 3 "RHF (HC IV/Hospital)", replace
	label values enrol_location hfcat2
	
	gen enrol_community = enrol_location-3
	replace enrol_community = 1 if enrol_community <0
	label variable enrol_community "Enrolment at community provider (CHW/PHC)"
	label values enrol_community yesno

}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	CCR

if ("$country" == "DRC") {
    gen enrol_location = 3 if ccr_place_enrolment == 13 
		replace enrol_location = 2 if ccr_place_enrolment == 11			///
										 | ccr_place_enrolment == 12
		replace enrol_location = 1 if ccr_place_enrolment == 2
	label variable enrol_location "Place of enrolment"
	label define hfcat2 1 "CHW (SSC)" 2 "PHC (PS/CS)" 3 "RHF (CSR/HGR)", replace
	label values enrol_location hfcat2
	
	gen enrol_community = enrol_location-3
	replace enrol_community = 1 if enrol_community <0
	label variable enrol_community "Enrolment at community provider (CHW/PHC)"
	label values enrol_community yesno

}

	}
