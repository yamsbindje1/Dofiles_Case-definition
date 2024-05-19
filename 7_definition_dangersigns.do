********************************************************************************
*** CARAMAL DEFINITIONS: DANGER SIGNS ******************************************
********************************************************************************

* Author:	NBNR
* Date:		05.03.2021

* Version control:
* 		- v1.0			NBNR		Define DSs according to different guidelines
*		- v1.1			NBNR		Nigeria: Added d0_danger_signs_11a/11b
*		- v1.2			NBNR		UG+DRC - D0: If CHW register was not filled oral 
*									confirmation of CHW is sufficient. 
*									Added value labels
*		- v1.3			NBNR		Corrected DRC danger signs
*		- v1.4			NBNR		Correction by enrollment
*		- v1.5			NBNR		DRC: Added d28/df_q11_26 (Asthénie physique) to danger_drc_all
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

* Questions: 

*------------------------------------------------------------------------------*

capture confirm variable danger_who_ras 
	if !_rc == 0 {
		
// Check if auxiliary variable(s) already exist
capture confirm variable symptom_bloody_diarrhea
	if !_rc == 0 {
		do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\6_definition_d28symptoms.do"
	}
capture confirm variable enrol_location
	if !_rc == 0 {
		do "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\8_definition_enrollmentlocation.do"
	}
	
*------------------------------------------------------------------------------*
*** WHO guidelines *** (valid in all countries)
*------------------------------------------------------------------------------*

* Required dataset:		D28, D28-DF

	** WHO RAS danger signs (general danger signs) **
	gen danger_who_ras = 0 		
		replace danger_who_ras = 1 if symptom_convulsion == 1
		replace danger_who_ras = 1 if symptom_sleepy == 1
		replace danger_who_ras = 1 if symptom_nodrink == 1
		replace danger_who_ras = 1 if symptom_vomit == 1 
		// incl. "vomit" and "vomits everything"

	** WHO danger signs (general and other danger signs) **
	gen danger_who_all = 0
		replace danger_who_all = 1 if danger_who_ras == 1
		*1) Fever for the last 7 days or more
		replace danger_who_all = 1 if symptom_fever7 == 1 
		*2) Cough for 21 days or more (here 14 days!)
		replace danger_who_all = 1 if symptom_cough14 == 1  
		*3) Diarrhoea for 14 days or more
		replace danger_who_all = 1 if symptom_diarrhea14 == 1
		*4) Blood in stool
		replace danger_who_all = 1 if symptom_bloody_diarrhea == 1
		*5) Read on MUAC strap
		*6) Swelling of both feet
		replace danger_who_all = 1 if symptom_swelling == 1
		
	** Number of WHO RAS danger signs **
	egen danger_who_ras_num = rowtotal(symptom_nodrink symptom_sleepy symptom_convulsion symptom_vomit)
	** Number of WHO general and other danger signs **
	egen danger_who_all_num = rowtotal(symptom_nodrink symptom_sleepy symptom_convulsion symptom_vomit symptom_fever7 symptom_cough14 symptom_bloody_diarrhea symptom_diarrhea14 symptom_swelling)
		
	label variable danger_who_ras	"WHO RAS danger signs (general danger signs)"
	label variable danger_who_all	"WHO danger signs (general and other danger signs)"
	label variable danger_who_ras_num 	"Number of WHO RAS danger signs"
	label variable danger_who_all_num 	"Number of WHO danger signs (general and other danger signs)"
	label values danger_who_ras danger_who_all yesno

*------------------------------------------------------------------------------*
*** COUNTRY-SPECIFIC GUIDELINES
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	D28, D28-DF, D0

if ("$country" == "Nigeria") {
	* Consolidate danger signs: 
	
	** RAS danger signs (general danger signs) **
		* D28 *
		gen danger_ng_ras = danger_who_ras		// Identical with WHO RAS danger signs
			replace danger_ng_ras = 1 if symptom_yelloweyes == 1	// Yellow eyes
			// Not included: Not responding to ACT treatment

		* D0 *
			replace danger_ng_ras = 1 if d0_danger_signs_5 == 1		/// Yellow eyes
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_ras = 1 if d0_danger_signs_8 == 1		/// Not responding to ACT
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_ras = 1 if d0_danger_signs_9 == 1		/// Convulsions
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_ras = 1 if d0_danger_signs_10 == 1	/// Not able to drink or breastfeed
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_ras = 1 if d0_danger_signs_11 == 1	/// Vomiting everything / Unusually sleepy or unconsciours (referral not completed)
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_ras = 1 if d0_danger_signs_11a == 1	/// Vomiting everything (referral completed)
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_ras = 1 if d0_danger_signs_11b == 1 	/// Unusually sleepy or unconscious (referral completed)
				& (enrol_location == 1 | enrol_location == 2)
		
		* REF * 
		    replace danger_ng_ras = 1 if ref_jaund_arrival == 1 	/// Yellow eyes
				& (enrol_location == 3)
			replace danger_ng_ras = 1 if ref_conv == 1				/// Convulsions
				& (enrol_location == 3)
			replace danger_ng_ras = 1 if ref_convuls_arrival == 1	/// Convulsions
				& (enrol_location == 3)
			replace danger_ng_ras = 1 if ref_drink == 1				/// Not able to drink or breastfeed
				& (enrol_location == 3)
			replace danger_ng_ras = 1 if ref_vomit == 1				/// Vomiting everything
				& (enrol_location == 3)
			replace danger_ng_ras = 1 if ref_consc == 1 			/// Unusually sleepy or unconscious
				& (enrol_location == 3)
			replace danger_ng_ras = 1 if ref_unconsc_arrival == 1	/// Unusually sleepy or unconscious	
				& (enrol_location == 3)
			replace danger_ng_ras = 1 if ref_lethar_arrival == 1	/// Unusually sleepy or unconscious
				& (enrol_location == 3)
			// Not included: Not responding to ACT treatment
		
	** Nigeria danger signs (general and other danger signs) **
		// General danger signs
		gen danger_ng_all = danger_ng_ras		
		
		* Other danger signs: D28 *
		replace danger_ng_all = 1 if symptom_fever7 == 1
		replace danger_ng_all = 1 if symptom_cough14 == 1
		replace danger_ng_all = 1 if symptom_diarrhea14 == 1
		replace danger_ng_all = 1 if symptom_bloody_diarrhea == 1
		replace danger_ng_all = 1 if symptom_swelling == 1
		replace danger_ng_all = 1 if symptom_whitepalms == 1
		// Not included: Red on MUAC strap
		// Not included: Chest in-drawing
		
		* Other danger signs: D0 *
			replace danger_ng_all = 1 if d0_danger_signs_1 == 1	/// Cough >= 14 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_all = 1 if d0_danger_signs_2 == 1	/// Diarrhea >= 14 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_all = 1 if d0_danger_signs_3 == 1	/// Diarrhea with blood
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_all = 1 if d0_danger_signs_4 == 1	/// Fever >= 7 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_all = 1 if d0_danger_signs_6 == 1 /// Whitish palms
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_all = 1 if d0_danger_signs_12 == 1 /// Red on MUAC strap
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ng_all = 1 if d0_danger_signs_13 == 1 /// Swelling of both feet
				& (enrol_location == 1 | enrol_location == 2)
			// Not included: Chest in-drawing
		
		* Other danger signs: REF *
		    replace danger_ng_all = 1 if ref_fever_d > 7 & ref_fever == 1	/// Fever >= 7 days
				& enrol_location == 3
			replace danger_ng_all = 1 if ref_cough_d > 14 & ref_cough == 1	/// Cough >= 14 days
				& enrol_location == 3
			replace danger_ng_all = 1 if ref_diarr_d > 21 & ref_diarr == 1	/// Diarrhea >= 14 days
				& enrol_location == 3
			replace danger_ng_all = 1 if ref_bdiarr == 1		/// Diarrhea with blood
				& enrol_location == 3
			replace danger_ng_all = 1 if ref_pallor_arrival == 1	/// Whitish palms
				& enrol_location == 3
			replace danger_ng_all = 1 if ref_muac_arrival < 11	/// Red on MUAC strap
				& enrol_location == 3
			// Not included: Swelling of both feet
			// Not included: Chest in-drawing
	
	label variable danger_ng_ras "Nigeria RAS danger signs (general danger signs)"
	label variable danger_ng_all "Nigeria danger signs (general and other danger signs)"
	label values danger_ng_ras danger_ng_all yesno

}
		
*------------------------------------------------------------------------------*		
*** UGANDA ***

* Required datasets:	D28, D28-DF, D0

if ("$country" == "Uganda") {
	* Consolidate danger signs:
	
	** RAS danger signs (general danger signs) **
		* D28 *
		gen danger_ug_ras = danger_who_ras		// Identical with WHO RAS danger signs

		* D0 *
		    * VHT Register
			replace danger_ug_ras = 1 if d0_reg_danger_sign_1 == 1	/// Not able to breastfeed or drink
				 & (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_ras = 1 if d0_reg_danger_sign_2 == 1	/// Vomiting everything
				 & (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_ras = 1 if d0_reg_danger_sign_4 == 1	/// Convulsions
				 & (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_ras = 1 if d0_reg_danger_sign_5 == 1	/// Very sleepy or unconscious
				 & (enrol_location == 1 | enrol_location == 2)
			
			* Oral account of VHT
			replace danger_ug_ras = 1 if d0_vht_danger_sign_1 == 1 	///
				 & d0_reg_danger == -99 							/// Not able to breastfeed or drink
				 & (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_ras = 1 if d0_vht_danger_sign_2 == 1	///
				& d0_reg_danger == -99								/// Vomiting everything
				 & (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_ras = 1 if d0_vht_danger_sign_4 == 1	///
				& d0_reg_danger == -99								/// Convulsions
				 & (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_ras = 1 if d0_vht_danger_sign_5 == 1	///
				& d0_reg_danger == -99								/// Very sleepy or unconscious
				 & (enrol_location == 1 | enrol_location == 2)
										
		* REF * 
			replace danger_ug_ras = 1 if ref_conv == 1				/// Convulsions
				& enrol_location == 3
			replace danger_ug_ras = 1 if ref_convuls_arrival == 1	/// Convulsions
				& enrol_location == 3
			replace danger_ug_ras = 1 if ref_drink == 1				/// Not able to drink or breastfeed
				& enrol_location == 3
			replace danger_ug_ras = 1 if ref_vomit == 1				/// Vomiting everything
				& enrol_location == 3
			replace danger_ug_ras = 1 if ref_consc == 1 			/// Unusually sleepy or unconscious
				& enrol_location == 3
			replace danger_ug_ras = 1 if ref_unconsc_arrival == 1	/// Unusually sleepy or unconscious
				& enrol_location == 3
			replace danger_ug_ras = 1 if ref_lethar_arrival == 1	/// Unusually sleepy or unconscious
				& enrol_location == 3
	
	** Uganda danger signs (general and other danger signs) **
		// General danger signs
		gen danger_ug_all = danger_ug_ras		
		
		* Other danger signs: D28 *
		replace danger_ug_all = 1 if symptom_fever7 == 1
		replace danger_ug_all = 1 if symptom_cough14 == 1
		replace danger_ug_all = 1 if symptom_diarrhea14 == 1
		replace danger_ug_all = 1 if symptom_bloody_diarrhea == 1
		
		* Other danger signs: D0 *
		    * VHT Register
			replace danger_ug_all = 1 if d0_reg_danger_sign_6 == 1	/// Chest in-drawing
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_all = 1 if d0_reg_danger_sign_7 == 1	/// Cough >= 21 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_all = 1 if d0_reg_danger_sign_8 == 1	/// Diarrhea >= 14 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_all = 1 if d0_reg_danger_sign_9 == 1	/// Diarrhea with blood
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_all = 1 if d0_reg_danger_sign_10 == 1	/// Fever >= 7 days
				& (enrol_location == 1 | enrol_location == 2)
			
			* Oral account of VHT 
			replace danger_ug_all = 1 if d0_vht_danger_sign_6 == 1	///
				& d0_reg_danger == -99 								/// Chest in-drawing
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_all = 1 if d0_vht_danger_sign_7 == 1	///
				& d0_reg_danger == -99								/// Cough >= 21 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_all = 1 if d0_vht_danger_sign_8 == 1	///
				& d0_reg_danger == -99								/// Diarrhea >= 14 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_all = 1 if d0_vht_danger_sign_9 == 1	///
				& d0_reg_danger == -99								/// Diarrhea with blood
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_ug_all = 1 if d0_vht_danger_sign_10 == 1	///
				& d0_reg_danger == -99								/// Fever >= 7 days
				& (enrol_location == 1 | enrol_location == 2)				
										
		* Other danger signs: REF *
		    replace danger_ug_all = 1 if ref_fever_d > 7 & ref_fever == 1	/// Fever >= 7 days
				& enrol_location == 3
			replace danger_ug_all = 1 if ref_cough_d > 14 & ref_cough == 1	/// Cough >= 14 days
				& enrol_location == 3
			replace danger_ug_all = 1 if ref_diarr_d > 21 & ref_diarr == 1	/// Diarrhea >= 14 days
				& enrol_location == 3
			replace danger_ug_all = 1 if ref_bdiarr == 1 		/// Diarrhea with blood
				& enrol_location == 3
			// Not included: Chest in-drawing
	
	label variable danger_ug_ras "Uganda RAS danger signs (general danger signs)"
	label variable danger_ug_all "Uganda danger signs (general and other danger signs)"
	label values danger_ug_ras danger_ug_all yesno
}
	
*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required datasets: 	D28, D28-DF, D0

if ("$country" == "DRC") {
	* Consolidate danger signs:
	
	** RAS danger signs (general danger signs) **
		* D28 *
		gen danger_drc_ras = danger_who_ras		// Identical with WHO RAS danger signs

		* D0 *
		    * Register
			replace danger_drc_ras = 1 if d0_reg_danger_sign_1 == 1	/// Not able to breastfeed or drink
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_ras = 1 if d0_reg_danger_sign_2 == 1	/// Vomiting everything
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_ras = 1 if d0_reg_danger_sign_4 == 1	/// Convulsions
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_ras = 1 if d0_reg_danger_sign_5 == 1	/// Very sleepy or unconscious
				& (enrol_location == 1 | enrol_location == 2)
			
			* Oral account
			replace danger_drc_ras = 1 if d0_vht_danger_sign_1 == 1 ///
				& d0_reg_danger == -99 								/// Not able to breastfeed or drink
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_ras = 1 if d0_vht_danger_sign_2 == 1	///
				& d0_reg_danger == -99								/// Vomiting everything
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_ras = 1 if d0_vht_danger_sign_4 == 1	///
				& d0_reg_danger == -99								/// Convulsions
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_ras = 1 if d0_vht_danger_sign_5 == 1	///
				& d0_reg_danger == -99								/// Very sleepy or unconscious
				& (enrol_location == 1 | enrol_location == 2)
										
		* REF * 
			replace danger_drc_ras = 1 if ref_conv == 1	 			/// Convulsions
				& enrol_location == 3
			replace danger_drc_ras = 1 if ref_convuls_arrival == 1	/// Convulsions
				& enrol_location == 3
			replace danger_drc_ras = 1 if ref_drink == 1 			/// Not able to drink or breastfeed
				& enrol_location == 3
			replace danger_drc_ras = 1 if ref_vomit == 1 			/// Vomiting everything
				& enrol_location == 3
			replace danger_drc_ras = 1 if ref_consc == 1 			/// Unusually sleepy or unconscious
				& enrol_location == 3
			replace danger_drc_ras = 1 if ref_unconsc_arrival == 1	/// Unusually sleepy or unconscious
				& enrol_location == 3
			replace danger_drc_ras = 1 if ref_lethar_arrival == 1	/// Unusually sleepy or unconscious
				& enrol_location == 3
	
	** DRC danger signs (general and other danger signs) **
		// General danger signs
		gen danger_drc_all = danger_drc_ras		
		
		* Other danger signs: D28 *
		replace danger_drc_all = 1 if symptom_fever7 == 1
		replace danger_drc_all = 1 if symptom_cough14 == 1
		replace danger_drc_all = 1 if symptom_diarrhea14 == 1
		replace danger_drc_all = 1 if symptom_whitepalms == 1
		replace danger_drc_all = 1 if symptom_nosit						// Very weak 
		replace danger_drc_all = 1 if d28_q11_26 == 1 | df_q11_26 == 1	// Very weak
		// Not included: Fast breathing with chest in-drawing or wheezing
		// Not prompted: White palms
		// Not prompted: Very weak
		
		* Other danger signs: D0 *
			replace danger_drc_all = 1 if d0_reg_danger_sign_7 == 1		/// Cough >= 21 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_all = 1 if d0_reg_danger_sign_8 == 1		/// Diarrhea >= 14 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_all = 1 if d0_reg_danger_sign_10 == 1	/// Fever >= 7 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_all = 1 if d0_reg_danger_sign_15 == 1	/// White palms
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_all = 1 if d0_reg_danger_sign_17 == 1 	/// Very weak
				& (enrol_location == 1 | enrol_location == 2)
			
			replace danger_drc_all = 1 if d0_reg_danger_sign_7 == 1		///
				& d0_reg_danger == -99									/// Cough >= 21 days
				& (enrol_location == 1 | enrol_location == 2)						
			replace danger_drc_all = 1 if d0_reg_danger_sign_8 == 1		///
				& d0_reg_danger == -99									/// Diarrhea >= 14 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_all = 1 if d0_reg_danger_sign_10 == 1	///
				& d0_reg_danger == -99									/// Fever >= 7 days
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_all = 1 if d0_reg_danger_sign_15 == 1	///
				& d0_reg_danger == -99									/// White palms
				& (enrol_location == 1 | enrol_location == 2)
			replace danger_drc_all = 1 if d0_reg_danger_sign_17 == 1 	///
				& d0_reg_danger == -99									/// Very weak
				& (enrol_location == 1 | enrol_location == 2)
			// Not included: Fast breathing with chest in-drawing or wheezing	
										
		* Other danger signs: REF *
		    replace danger_drc_all = 1 if ref_fever_d > 7 & ref_fever == 1	/// Fever >= 7 days
				& enrol_location == 3
			replace danger_drc_all = 1 if ref_cough_d > 14 & ref_cough == 1	/// Cough >= 14 days
				& enrol_location == 3
			replace danger_drc_all = 1 if ref_diarr_d > 21 & ref_diarr == 1	/// Diarrhea >= 14 days
				& enrol_location == 3
			replace danger_drc_all = 1 if ref_pallor_arrival == 1			/// Whitish palms
				& enrol_location == 3
			replace danger_drc_all = 1 if ref_palms == 1 & enrol_location == 3		
			replace danger_drc_all = 1 if ref_sitstand_arrival == 1			/// Very weak
				& enrol_location == 3
			replace danger_drc_all = 1 if ref_breath == 1 & (ref_chest == 1	///
										| ref_sc_reces_arrival == 1			/// 
										| ref_wheez_arrival == 1)				/// Difficulty breathing with chest in-drawing or wheezing
										& enrol_location == 3
	
	label variable danger_drc_ras "DRC RAS danger signs (general danger signs)"
	label variable danger_drc_all "DRC danger signs (general and other danger signs)"
	label values danger_drc_ras danger_drc_all yesno
}

	}	
	
