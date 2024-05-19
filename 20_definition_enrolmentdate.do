********************************************************************************
*** CARAMAL DEFINITIONS: DATE OF ENROLMENT *************************************
********************************************************************************

* Author:	GDEO
* Date:		05.03.2021

* Version control:
* 		- v1.0			GDEO		Consolidated date of death for all countries
*		- v1.1			NBNR		Replace date of enrolment with date of admission 
*									(ref_date_adm) in Nigeria for RHF enrolments
*		- *please enter changes here

* Note: Use "J:\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.4. Impl Progress & Outcome\do.files\Analysis datasets DRC UG NG 2021.01.27.do" to test code below. 


*------------------------------------------------------------------------------*

capture confirm variable enrolmentdate
	if !_rc == 0 {
	    
// Generate auxiliary variable
capture confirm variable enrol_location
	if !_rc == 0 {
	    do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\8_definition_enrollmentlocation.do"
	}
	
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset:	CCR

if ("$country" == "Nigeria") {
	clonevar enrolmentdate = ccr_date_enrol 
	replace enrolmentdate = ref_date_adm if enrol_location == 3
	format enrolmentdate %td
	}


*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	
if ("$country" == "Uganda") {
	gen enrolmentdate = .		
		replace enrolmentdate = d0_vht_date
		replace enrolmentdate = ref_date_adm if enrolmentdate == . & ref_referral==0
		replace enrolmentdate= (d28_today-28) if enrolmentdate == .        
		replace enrolmentdate = df_d0 if enrolmentdate == .
		replace enrolmentdate = ref_date_adm if enrolmentdate == . & merge_ref == 3 // child is said to be a ref_referral case but there is no d0 or d28 (12 cases) or child refused consent

format enrolmentdate %tdDDmonCCYY
}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	CCR, D0, REF, D28, D28-DF

if ("$country" == "DRC") {
	gen enrolmentdate = .		
		replace enrolmentdate = d0_vht_date
		replace enrolmentdate = ref_date_adm if enrolmentdate == . & ref_referral==0
		replace enrolmentdate = ref_date_adm if merge_ref==3 & ref_referral== 0 & enrolmentdate == .
		replace enrolmentdate = (d28_today-28) if enrolmentdate == .                         
		replace enrolmentdate = df_d0 if enrolmentdate == .
		replace enrolmentdate = ccr_date_enrol if enrolmentdate==. //4 obs missing, pending Jean's corrections	
		format enrolmentdate %td
		
		}
	}