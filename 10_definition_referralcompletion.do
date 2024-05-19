********************************************************************************
*** CARAMAL DEFINITIONS: REFERRAL COMPLETION ***********************************
********************************************************************************

* Author:	NBNR
* Date:		04.03.2021

* Version control:
* 		- v1.0			NBNR		Defined referral completion in all countries
*		- v1.1			NBNR		NG: Removed Health Post as an enrolling provider
*		- v1.2			NBNR 		Moved auxiliary variable verification to beginning
*									Set to missing if enrolling provider is missing
*									Added definition without taking account of sequence								
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

capture confirm variable referral_any 
	if !_rc == 0 {
		
// Run code for auxiliary variables
capture confirm variable enrol_location
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\8_definition_enrollmentlocation.do"
}
capture confirm variable count_provider
if !_rc == 0 {
	do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\11_definition_providernumber.do"
}
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	REF, D28, D28-DF

if ("$country" == "Nigeria") {

	* Establish sequence of providers *
	capture drop __00000*
	tempvar cnum p1num p2num rnum lnum
	gen `cnum' = .				// CORP is xth provider
	gen `p1num' = .				// Health post is xth provider
	gen `p2num' = .				// PHC is xth provider
	gen `rnum' = .				// RHF is xth provider
	gen `lnum' = .				// Last provider is xth provider

	forvalues i = 1/5 {
		// CORP
		replace `cnum' = `i' if `cnum' == . & (d28_q15_`i' == 2 | df_q15_`i' == 2)
		// Health post
		replace `p1num' = `i' if `p1num' == . & (d28_q15_`i' == 14 | df_q15_`i' == 14)
		// PHC
		replace `p2num' = `i' if `p2num' == . & (d28_q15_`i' == 12 | df_q15_`i' == 12)
		// Cottage Hospital
		replace `rnum' = `i' if `rnum' == . & (d28_q15_`i' == 11 | df_q15_`i' == 11)
		// Last provider
		replace `lnum' = `i' if d28_q15_`i' != . | df_q15_`i' != .
		}	
		
	// Establish if enrolling provider is missing
	tempvar chw phc rhf enrol_miss
	
	egen `chw' = anymatch(d28_q15_* df_q15_*), val(2)
		replace `chw' = . if d28_q15_1 == . & df_q15_1 == .
	egen `phc' = anymatch(d28_q15_* df_q15_*), val(12 14)
		replace `phc' = . if d28_q15_1 == . & df_q15_1 == .
	egen `rhf' = anymatch(d28_q15_* df_q15_*), val(11)
		replace `rhf' = . if d28_q15_1 == . & df_q15_1 == .
	
	gen `enrol_miss' = .
		replace `enrol_miss' = `chw' if enrol_location == 1
		replace `enrol_miss' = `phc' if enrol_location == 2
		replace `enrol_miss' = `rhf' if enrol_location == 3
		
*------------------------------------------------------------------------------*
** ANY PROVIDER **	
	
	* Generate referral completion variable: Going to any provider *
	gen referral_any = .
		label variable referral_any "Referral completion: Going to any provider"
		label values referral_any yesno

	* Completed referral
		// Referral complete if community enrolments have a REF form
		replace referral_any = 1 if (enrol_location == 1 | enrol_location == 2) ///
			& ref_KEY != ""	
		// Referral complete if community enrolments were subsequently seen by any provider according to D28
		* Enrolled by CORP
		replace referral_any = 1 if enrol_location == 1 			///
								& (`cnum' < `lnum' & `lnum' != .)
		* Enrolled by PHC					
		replace referral_any = 1 if enrol_location == 2				///
								& (`p2num' < `lnum' & `lnum' != .) 

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_any = 0 if referral_any == . 					///
			& (enrol_location == 1 | enrol_location == 2) 
	
	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_any = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_any = . if count_provider == 0 & ref_KEY == ""			///
			& (enrol_location == 1 | enrol_location == 2)	
			
*------------------------------------------------------------------------------*
** HIGHER PROVIDER **	
	
	* Generate referral completion variable: Going to a higher level public provider *
	gen referral_higher = .
		label variable referral_higher "Referral completion: Going to a higher level public provider"
		label values referral_higher yesno

	* Completed referral
		// Referral complete if community enrolments have a REF form
		replace referral_higher = 1 if (enrol_location == 1 | enrol_location == 2) ///
			& ref_KEY != ""	
		// Referral complete if community enrolments were subsequently seen by a higher level public provider according to D28
		* Enrolled by CORP
		replace referral_higher = 1 if enrol_location == 1 				///
								& ((`cnum' < `p1num' & `p1num' != .) 	///
								|  (`cnum' < `p2num' & `p2num' != .)	///
								|  (`cnum' < `rnum'  & `rnum' != .))
		* Enrolled by PHC					
		replace referral_higher = 1 if enrol_location == 2				///
								& (`p2num' < `rnum' & `rnum' != .)

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_higher = 0 if referral_higher == . 					///
			& (enrol_location == 1 | enrol_location == 2) 
	
	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_higher = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_higher = . if count_provider == 0 & ref_KEY == ""			///
			& (enrol_location == 1 | enrol_location == 2)
		
*------------------------------------------------------------------------------*
** REFERRAL FACILITY: RESPECTING SEQUENCE **

	* Generate referral completion variable: Referral to Cottage Hospital *
	gen referral_rhf = .
	label variable referral_rhf "Referral completion: Cottage Hospital - respecting sequence of providers"
	label values referral_rhf yesno

	* Completed referral: Referral to Cottage Hospital
		// Referral complete if community enrolments have a REF form
		replace referral_rhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& ref_KEY != ""	
		// Referral complete if community enrolments were seen at a RHF according to D28
		replace referral_rhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& (`cnum' < `rnum' | `p2num' < `rnum') & `rnum' != . 

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_rhf = 0 if referral_rhf == . & 				///
			(enrol_location == 1 | enrol_location == 2) 

	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_rhf = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_rhf = . if count_provider == 0 & ref_KEY == "" 		///
			& (enrol_location == 1 | enrol_location == 2)	
			
*------------------------------------------------------------------------------*
** REFERRAL FACILITY: IRRESPECTIVE OF SEQUENCE **

	* Generate referral completion variable: Referral to Cottage Hospital *
	gen referral_anyrhf = .
	label variable referral_anyrhf "Referral completion: Cottage Hospital - irrespective of sequence of providers"
	label values referral_anyrhf yesno

	* Completed referral: Referral to Cottage Hospital
		// Referral complete if community enrolments have a REF form
		replace referral_anyrhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& ref_KEY != ""	
		// Referral complete if community enrolments were seen at a RHF according to D28
			* Irrespective of sequence
		tempvar anyrhf
		egen `anyrhf' = anymatch(d28_q15_* df_q15_*), values(11)
		replace referral_anyrhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& `anyrhf' == 1

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_anyrhf = 0 if referral_anyrhf == . & 				///
			(enrol_location == 1 | enrol_location == 2) 

	* Referral completion: Not applicable
		// Referral completion cannot be established if providers are missing in D28
		replace referral_anyrhf = . if count_provider == 0 & ref_KEY == "" 		///
			& (enrol_location == 1 | enrol_location == 2)	

}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	REF, D28, D28-DF
	
if ("$country" == "Uganda") {
	
	* Establish sequence of providers *
	capture drop __00000*
	tempvar cnum pnum rnum lnum
	gen `cnum' = .				// VHT is xth provider
	gen `pnum' = .				// HC II is xth provider
	gen `rnum' = .				// RHF is xth provider
	gen `lnum' = .				// Last provider is xth provider

	forvalues i = 1/5 {
		// VHT
		replace `cnum' = `i' if `cnum' == . & (d28_q15_`i' == 2 | df_q15_`i' == 2)
		// Health Center II
		replace `pnum' = `i' if `pnum' == . & (d28_q15_`i' == 11 | df_q15_`i' == 11)
		// Health Center III, Health Center IV / Hospital
		replace `rnum' = `i' if `rnum' == . & 									///
									((d28_q15_`i' == 13 | df_q15_`i' == 13) |	///
									(d28_q15_`i' == 12 | df_q15_`i' == 12))	
		// Last provider
		replace `lnum' = `i' if d28_q15_`i' != . | df_q15_`i' != .
		}	
		
	// Establish if enrolling provider is missing
	tempvar chw phc rhf enrol_miss
	
	egen `chw' = anymatch(d28_q15_* df_q15_*), val(2)
		replace `chw' = . if d28_q15_1 == . & df_q15_1 == .
	egen `phc' = anymatch(d28_q15_* df_q15_*), val(11)
		replace `phc' = . if d28_q15_1 == . & df_q15_1 == .
	egen `rhf' = anymatch(d28_q15_* df_q15_*), val(12 13)
		replace `rhf' = . if d28_q15_1 == . & df_q15_1 == .
	
	gen `enrol_miss' = .
		replace `enrol_miss' = `chw' if enrol_location == 1
		replace `enrol_miss' = `phc' if enrol_location == 2
		replace `enrol_miss' = `rhf' if enrol_location == 3
		
*------------------------------------------------------------------------------*
** ANY PROVIDER **	
	
	* Generate referral completion variable: Going to any provider *
	gen referral_any = .
		label variable referral_any "Referral completion: Going to any provider"
		label values referral_any yesno

	* Completed referral
		// Referral complete if community enrolments have a REF form
		replace referral_any = 1 if (enrol_location == 1 | enrol_location == 2) ///
			& ref_KEY != ""	
		// Referral complete if community enrolments were subsequently seen by any provider according to D28
		* Enrolled by VHT
		replace referral_any = 1 if enrol_location == 1 			///
								& (`cnum' < `lnum' & `lnum' != .)
		* Enrolled by HC II					
		replace referral_any = 1 if enrol_location == 2				///
								& (`pnum' < `lnum' & `lnum' != .)

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_any = 0 if referral_any == . 					///
			& (enrol_location == 1 | enrol_location == 2) 
	
	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_any = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_any = . if count_provider == 0 & ref_KEY == ""			///
			& (enrol_location == 1 | enrol_location == 2)	
			
*------------------------------------------------------------------------------*
** HIGHER PROVIDER **	
	
	* Generate referral completion variable: Going to a higher level public provider *
	gen referral_higher = .
		label variable referral_higher "Referral completion: Going to a higher level public provider"
		label values referral_higher yesno

	* Completed referral
		// Referral complete if community enrolments have a REF form
		replace referral_higher = 1 if (enrol_location == 1 | enrol_location == 2) ///
			& ref_KEY != ""	
		// Referral complete if community enrolments were subsequently seen by a higher level public provider according to D28
		* Enrolled by VHT
		replace referral_higher = 1 if enrol_location == 1 				///
								& ((`cnum' < `pnum' & `pnum' != .) 		///
								|  (`cnum' < `rnum'  & `rnum' != .))
		* Enrolled by HC II				
		replace referral_higher = 1 if enrol_location == 2				///
								&  (`pnum' < `rnum' & `rnum' != .)	

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_higher = 0 if referral_higher == . 					///
			& (enrol_location == 1 | enrol_location == 2) 
	
	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_higher = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_higher = . if count_provider == 0 & ref_KEY == ""			///
			& (enrol_location == 1 | enrol_location == 2)
		
*------------------------------------------------------------------------------*
** REFERRAL FACILITY: RESPECTING SEQUENCE OF PROVIDERS **

	* Generate referral completion variable: Referral to HC III, HC IV , Hospital *
	gen referral_rhf = .
	label variable referral_rhf "Referral completion: HC III, HC IV , Hospital - respecting sequence of providers"
	label values referral_rhf yesno

	* Completed referral: Referral to HC III, HC IV or Hospital
		// Referral complete if community enrolments have a REF form
		replace referral_rhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& ref_KEY != ""	
		// Referral complete if community enrolments were seen at a RHF according to D28
		replace referral_rhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& (`cnum' < `rnum' | `pnum' < `rnum') & `rnum' != . 

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_rhf = 0 if referral_rhf == . & 				///
			(enrol_location == 1 | enrol_location == 2) 

	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_rhf = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_rhf = . if count_provider == 0 & ref_KEY == "" 		///
			& (enrol_location == 1 | enrol_location == 2)	
			
*------------------------------------------------------------------------------*
** REFERRAL FACILITY: IRRESPECTIVE OF SEQUENCE **

	* Generate referral completion variable: Referral to HC III, HC IV, Hospital *
	gen referral_anyrhf = .
	label variable referral_anyrhf "Referral completion: HC III, HC IV, Hospital - irrespective of sequence of providers"
	label values referral_anyrhf yesno

	* Completed referral: Referral to HC III, HC IV, Hospital
		// Referral complete if community enrolments have a REF form
		replace referral_anyrhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& ref_KEY != ""	
		// Referral complete if community enrolments were seen at a RHF according to D28
			* Irrespective of sequence
		tempvar anyrhf
		egen `anyrhf' = anymatch(d28_q15_* df_q15_*), values(12 13)
		replace referral_anyrhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& `anyrhf' == 1

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_anyrhf = 0 if referral_anyrhf == . & 				///
			(enrol_location == 1 | enrol_location == 2) 

	* Referral completion: Not applicable
		// Referral completion cannot be established if providers are missing in D28
		replace referral_anyrhf = . if count_provider == 0 & ref_KEY == "" 		///
			& (enrol_location == 1 | enrol_location == 2)	

}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	CCR, REF, D28, D28-DF

if ("$country" == "DRC") {
	
	* Establish sequence of providers *
	capture drop __00000*
	tempvar cnum p1num p2num rnum lnum
	gen `cnum' = .				// SSC is xth provider
	gen `p1num' = .				// Poste de santé is xth provider
	gen `p2num' = .				// Centre de santé is xth provider
	gen `rnum' = .				// RHF is xth provider
	gen `lnum' = .				// Last provider is xth provider

	forvalues i = 1/5 {
		// SSC
		replace `cnum' = `i' if `cnum' == . & (d28_q15_`i' == 2 | df_q15_`i' == 2)
		// Poste de Santé
		replace `p1num' = `i' if `p1num' == . & (d28_q15_`i' == 11 | df_q15_`i' == 11)
		// Centre de Santé
		replace `p2num' = `i' if `p2num' == . & (d28_q15_`i' == 12 | df_q15_`i' == 12)
		// Centre de Santé de Référence / Hôpital Général de Référence
		replace `rnum' = `i' if `rnum' == . & (d28_q15_`i' == 13 | df_q15_`i' == 13)
		// Last provider
		replace `lnum' = `i' if d28_q15_`i' != . | df_q15_`i' != .
		}
		
	// Establish if enrolling provider is missing
	tempvar chw phc rhf enrol_miss
	
	egen `chw' = anymatch(d28_q15_* df_q15_*), val(2)
		replace `chw' = . if d28_q15_1 == . & df_q15_1 == .
	egen `phc' = anymatch(d28_q15_* df_q15_*), val(11 12)
		replace `phc' = . if d28_q15_1 == . & df_q15_1 == .
	egen `rhf' = anymatch(d28_q15_* df_q15_*), val(13)
		replace `rhf' = . if d28_q15_1 == . & df_q15_1 == .
	
	gen `enrol_miss' = .
		replace `enrol_miss' = `chw' if enrol_location == 1
		replace `enrol_miss' = `phc' if enrol_location == 2
		replace `enrol_miss' = `rhf' if enrol_location == 3
		
*------------------------------------------------------------------------------*
** ANY PROVIDER **	
	
	* Generate referral completion variable: Going to any provider *
	gen referral_any = .
		label variable referral_any "Referral completion: Going to any provider"
		label values referral_any yesno

	* Completed referral
		// Referral complete if community enrolments have a REF form
		replace referral_any = 1 if (enrol_location == 1 | enrol_location == 2) ///
			& ref_KEY != ""	
		// Referral complete if community enrolments were subsequently seen by any provider according to D28
		* Enrolled by SSC
		replace referral_any = 1 if enrol_location == 1 			///
								& (`cnum' < `lnum' & `lnum' != .)
		* Enrolled by PS / CS					
		replace referral_any = 1 if enrol_location == 2				///
								& (`p1num' < `lnum' | `p2num' < `lnum') & `lnum' != . 

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_any = 0 if referral_any == . 					///
			& (enrol_location == 1 | enrol_location == 2) 
	
	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_any = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_any = . if count_provider == 0 & ref_KEY == ""			///
			& (enrol_location == 1 | enrol_location == 2)	
			
*------------------------------------------------------------------------------*
** HIGHER PROVIDER **	
	
	* Generate referral completion variable: Going to a higher level public provider *
	gen referral_higher = .
		label variable referral_higher "Referral completion: Going to a higher level public provider"
		label values referral_higher yesno

	* Completed referral
		// Referral complete if community enrolments have a REF form
		replace referral_higher = 1 if (enrol_location == 1 | enrol_location == 2) ///
			& ref_KEY != ""	
		// Referral complete if community enrolments were subsequently seen by a higher level public provider according to D28
		* Enrolled by SSC
		replace referral_higher = 1 if enrol_location == 1 				///
								& ((`cnum' < `p1num' & `p1num' != .) 	///
								|  (`cnum' < `p2num' & `p2num' != .)	///
								|  (`cnum' < `rnum'  & `rnum' != .))
		* Enrolled by PS / CS					
		replace referral_higher = 1 if enrol_location == 2				///
								& ((`p1num' < `p2num' & `p2num' != .)	///
								|  (`p1num' < `rnum' & `rnum' != . )	///
								|  (`p2num' < `rnum' & `rnum' != .))	

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_higher = 0 if referral_higher == . 					///
			& (enrol_location == 1 | enrol_location == 2) 
	
	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_higher = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_higher = . if count_provider == 0 & ref_KEY == ""			///
			& (enrol_location == 1 | enrol_location == 2)
		
*------------------------------------------------------------------------------*
** REFERRAL FACILITY: RESPECTING SEQUENCE **

	* Generate referral completion variable: Referral to CSR / HGR *
	gen referral_rhf = .
	label variable referral_rhf "Referral completion: CSR / HGR - respecting sequence of providers"
	label values referral_rhf yesno

	* Completed referral: Referral to CSR / HGR
		// Referral complete if community enrolments have a REF form
		replace referral_rhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& ref_KEY != ""	
		// Referral complete if community enrolments were seen at a RHF according to D28
		replace referral_rhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& (`cnum' < `rnum' | `p1num' < `rnum' | `p2num' < `rnum') & `rnum' != . 

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_rhf = 0 if referral_rhf == . & 				///
			(enrol_location == 1 | enrol_location == 2) 

	* Referral completion: Not applicable
		// Referral completion cannot be established if enrolling provider is missing
		replace referral_rhf = . if `enrol_miss' == 0
		// Referral completion cannot be established if providers are missing in D28
		replace referral_rhf = . if count_provider == 0 & ref_KEY == "" 		///
			& (enrol_location == 1 | enrol_location == 2)	
			
*------------------------------------------------------------------------------*
** REFERRAL FACILITY: IRRESPECTIVE OF SEQUENCE **

	* Generate referral completion variable: Referral to CSR / HGR *
	gen referral_anyrhf = .
	label variable referral_anyrhf "Referral completion: CSR / HGR - irrespective of sequence of providers"
	label values referral_anyrhf yesno

	* Completed referral: Referral to CSR / HGR
		// Referral complete if community enrolments have a REF form
		replace referral_anyrhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& ref_KEY != ""	
		// Referral complete if community enrolments were seen at a RHF according to D28
			* Irrespective of sequence
		tempvar anyrhf
		egen `anyrhf' = anymatch(d28_q15_* df_q15_*), values(13)
		replace referral_anyrhf = 1 if (enrol_location == 1 | enrol_location == 2) 	///
			& `anyrhf' == 1

	* Referral not completed
		// All remaining community enrolments did not complete referral.
		replace referral_anyrhf = 0 if referral_anyrhf == . & 				///
			(enrol_location == 1 | enrol_location == 2) 

	* Referral completion: Not applicable
		// Referral completion cannot be established if providers are missing in D28
		replace referral_anyrhf = . if count_provider == 0 & ref_KEY == "" 		///
			& (enrol_location == 1 | enrol_location == 2)	
			
}

	}
