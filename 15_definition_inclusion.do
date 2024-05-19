********************************************************************************
*** CARAMAL DEFINITIONS: INCLUSION CRITERIA ************************************
********************************************************************************

* Author:	NBNR
* Date:		04.03.2021

* Version control:
* 		- v1.0			NBNR		Consolidated inclusion criteria for all countries
*		- v1.1			NBNR		Replaced df_dx with consolidated date of death 	
*		- v1.2			NBNR		Correction of incl_pp (by enrollment)
*		- v1.3			NBNR		Moved code for auxiliary variable to the 
*									 beginning of the do-file. Deleted from country code.
*		- v1.4 (temp)	MAH			Added incl_pp_country to accommodate country-specific RAS danger signs
*		- v1.5			AIS			Added incl_pp_country_all to accommodate country-specific general (RAS) + other danger signs
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 


*------------------------------------------------------------------------------*

capture confirm variable incl_itt 
	if !_rc == 0 {
	    
// Run do-files for auxiliary variables
capture confirm variable agegroup
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\1_definition_age.do"
}
capture confirm variable anyfever
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\2_definition_fever.do"
}
capture confirm variable smal_admission
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\4_definition_smaldiagnosis.do"
}
capture confirm variable consent
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\5_definition_consent.do"
}
capture confirm variable danger_who_ras
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\7_definition_dangersigns.do"
}
capture confirm variable deathdate
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\19_definition_deathdate.do"
}
capture confirm variable enrol_location
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\8_definition_enrollmentlocation.do"
}
capture confirm variable enrolmentdate
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\20_definition_enrolmentdate.do"
}

*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset:	CCR, D28, D28-DF

if ("$country" == "Nigeria") {

	
** INTENTION TO TREAT (ITT) **
*	- Consent provided; 
*	- All deaths; 
*	- D28(-DF) data available

	// Generate inclusion variable 
	gen incl_itt = 0
		replace incl_itt = 1 if consent == 1 & !(d28_KEY == "" & df_KEY == "")
		label variable incl_itt "Inclusion: Intention to treat"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_itt yesno

			
** PER PROTOCOL (PP+REF) **
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- WHO danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;
*	- Deaths: Within 31 days from date of enrolment

	// Generate inclusion variable
	gen incl_pp = 0
		// Community enrollments
			replace incl_pp = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_who_ras == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2)
		// RHF enrollments
			replace incl_pp = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3
		// Death within 31 days since enrolment
		replace incl_pp = 0 if (deathdate - enrolmentdate > 31) & ccr_d28_status == 3
		label variable incl_pp "Inclusion: Per protocol (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp yesno

** PER PROTOCOL (PP+REF) - COUNTRY-SPECIFIC **
* RAS DANGER SIGNS
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- Country-specific RAS danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;
*	- Deaths: Within 31 days from date of enrolment

	// Generate inclusion variable
	gen incl_pp_country = 0
		// Community enrollments
			replace incl_pp_country = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_ng_ras == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2)
		// RHF enrollments
			replace incl_pp_country = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3
		// Death within 31 days since enrolment
		replace incl_pp_country = 0 if (deathdate - enrolmentdate > 31) & ccr_d28_status == 3
		label variable incl_pp_country "Inclusion: Per protocol - country-specific (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp_country yesno

* GENERAL (RAS) + OTHER DANGER SIGNS
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- Country-specific general + other danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;

	// Generate inclusion variable
	gen incl_pp_country_all = 0
		// Community enrollments
			replace incl_pp_country_all = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_ng_all == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2)
		// RHF enrollments
			replace incl_pp_country_all = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3		
		// Death within 31 days since enrolment
		replace incl_pp_country_all = 0 if (deathdate - enrolmentdate > 31) & ccr_d28_status == 3
		label variable incl_pp_country_all "Inclusion: Per protocol - country-specific all DS (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp_country_all yesno

		
** PER PROTOCOL (PP) **
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- WHO danger sign
*	- Deaths: Within 31 days from date of enrolment
	
	// Generate inclusion variable
	gen incl_ppds = 0
		replace incl_ppds = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_who_ras == 1 & !(d28_KEY == "" & df_KEY == "")
		// Death within 31 days since enrolment
		replace incl_ppds = 0 if (deathdate - enrolmentdate > 31) & ccr_d28_status == 3
		label variable incl_ppds "Inclusion: Per protocol (RHF enrollments with danger signs)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_ppds yesno
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	CCR, D28, D28-DF

if ("$country" == "Uganda") {
	
** INTENTION TO TREAT (ITT) **
*	- Consent provided; 
*	- All deaths; 
*	- D28(-DF) data available

	// Generate inclusion variable 
	gen incl_itt = 0
		replace incl_itt = 1 if consent == 1 & !(d28_KEY == "" & df_KEY == "")
		label variable incl_itt "Inclusion: Intention to treat"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_itt yesno

			
** PER PROTOCOL (PP+REF) **
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- WHO danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;
*	- Deaths: Within 31 days from date of enrolment

	// Generate inclusion variable
	gen incl_pp = 0
		// Community enrollments
			replace incl_pp = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_who_ras == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2)
		// RHF enrollments
			replace incl_pp = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3
		// Death within 31 days since enrolment
		replace incl_pp = 0 if (deathdate - enrolmentdate > 31) & ccr_death == 1
		label variable incl_pp "Inclusion: Per protocol (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp yesno

** PER PROTOCOL (PP+REF) - COUNTRY-SPECIFIC **
* RAS DANGER SIGNS
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- Country-specific RAS danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;
*	- Deaths: Within 31 days from date of enrolment

	// Generate inclusion variable
	gen incl_pp_country = 0
		// Community enrollments
			replace incl_pp_country = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_ug_ras == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2)
		// RHF enrollments
			replace incl_pp_country = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3
		// Death within 31 days since enrolment
		replace incl_pp_country = 0 if (deathdate - enrolmentdate > 31) & ccr_death == 1
		label variable incl_pp_country "Inclusion: Per protocol - country-specific (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp_country yesno

* GENERAL (RAS) + OTHER DANGER SIGNS
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- Country-specific general + other danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;

	// Generate inclusion variable
	gen incl_pp_country_all = 0
		// Community enrollments
			replace incl_pp_country_all = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_ug_all == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2)
		// RHF enrollments
			replace incl_pp_country_all = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3			
		// Death within 31 days since enrolment
		replace incl_pp_country_all = 0 if (deathdate - enrolmentdate > 31) & ccr_death == 1
		label variable incl_pp_country_all "Inclusion: Per protocol - country-specific all DS (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp_country_all yesno

		
** PER PROTOCOL (PP) **
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- WHO danger sign
*	- Deaths: Within 31 days from date of enrolment
	
	// Generate inclusion variable
	gen incl_ppds = 0
		replace incl_ppds = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_who_ras == 1 & !(d28_KEY == "" & df_KEY == "")
		// Death within 31 days since enrolment
		replace incl_ppds = 0 if (deathdate - enrolmentdate > 31) & ccr_death == 1 
		label variable incl_ppds "Inclusion: Per protocol (RHF enrollments with danger signs)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_ppds yesno

}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	CCR, D28, D28-DF

if ("$country" == "DRC") {
	
** INTENTION TO TREAT (ITT) **
*	- Consent provided; 
*	- All deaths; 
*	- D28(-DF) data available

	// Generate inclusion variable 
	gen incl_itt = 0
		replace incl_itt = 1 if consent == 1 & !(d28_KEY == "" & df_KEY == "")
		label variable incl_itt "Inclusion: Intention to treat"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_itt yesno
			
** PER PROTOCOL (PP+REF) **
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- WHO danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;
*	- Deaths: Within 31 days from date of enrolment

	// Generate inclusion variable
	gen incl_pp = 0
		// Community enrollments
			replace incl_pp = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_who_ras == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2) 
		// RHF enrollments
			replace incl_pp = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3
		// Death within 31 days since enrolment
		replace incl_pp = 0 if ((deathdate - enrolmentdate > 31) | deathdate == 0) & (ccr_final_outcome == 0 | ccr_final_outcome == 3)
		label variable incl_pp "Inclusion: Per protocol (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp yesno

** PER PROTOCOL (PP+REF) - COUNTRY-SPECIFIC **
* RAS DANGER SIGNS
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- Country-specific RAS danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;
*	- Deaths: Within 31 days from date of enrolment

	// Generate inclusion variable
	gen incl_pp_country = 0
		// Community enrollments
			replace incl_pp_country = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_drc_ras == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2) 
		// RHF enrollments
			replace incl_pp_country = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3
		// Death within 31 days since enrolment
		replace incl_pp_country = 0 if ((deathdate - enrolmentdate > 31) | deathdate == 0) & (ccr_final_outcome == 0 | ccr_final_outcome == 3)
		label variable incl_pp_country "Inclusion: Per protocol - country-specific (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp_country yesno

* GENERAL (RAS) + OTHER DANGER SIGNS
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- Country-specific general + other danger sign
*		or: Severe Malaria diagnosis if enrolment at RHF;

	// Generate inclusion variable
	gen incl_pp_country_all = 0
		// Community enrollments
			replace incl_pp_country_all = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_drc_all == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& (enrol_location == 1 | enrol_location == 2)
		// RHF enrollments
			replace incl_pp_country_all = 1 if consent == 1 & agegroup != . 		///
							& smal_admission == 1 & !(d28_KEY == "" & df_KEY == "")	///
							& enrol_location == 3					
		// Death within 31 days since enrolment
		replace incl_pp_country_all = 0 if ((deathdate - enrolmentdate > 31) | deathdate == 0) & (ccr_final_outcome == 0 | ccr_final_outcome == 3)
		label variable incl_pp_country_all "Inclusion: Per protocol - country-specific all DS (RHF enrollments with severe malaria diagnosis)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_pp_country_all yesno

			
** PER PROTOCOL (PP) **
*	- Consent provided;
*	- All children <5;
*	- History of fever;
* 	- WHO danger sign
*	- Deaths: Within 31 days from date of enrolment
	
	// Generate inclusion variable
	gen incl_ppds = 0
		replace incl_ppds = 1 if consent == 1 & agegroup != . & anyfever == 1 	///
							& danger_who_ras == 1 & !(d28_KEY == "" & df_KEY == "")
		// Death within 31 days since enrolment
		replace incl_ppds = 0 if ((deathdate - enrolmentdate > 31) | deathdate == 0) & (ccr_final_outcome == 0 | ccr_final_outcome == 3)
		label variable incl_ppds "Inclusion: Per protocol (RHF enrollments with danger signs)"
		label define yesno 0 "No" 1 "Yes", replace
		label values incl_ppds yesno

}

	}
