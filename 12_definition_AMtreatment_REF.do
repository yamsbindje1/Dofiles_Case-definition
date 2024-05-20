********************************************************************************
*** CARAMAL DEFINITIONS: INJECTABLE ANTIMALARIALS AND ACTS - REF ***************
********************************************************************************

* Author:	Yams
* Date:		31.03.2021

* Version control:
* 		- v1.0			GDEO		Defined REF AM administration for DRC
*		- v1.1			NBNR		Reviewed definitions and added UG and NG
*		- v1.2			NBNR		Set v4 variables to missing for earlier versions
*		- v1.3			AIS			Corrected any_act definition to account for the unavailable variable for ASAQ mode of administration in v4 of REF form (all countries)

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*Change applied on 31.03.2021: 
*GDEO: asaq mode of administration (q160l_med_mode) has an error in ODK form with incorrect relevance, therefore mode of administration for asaq was not considered when generating the variable "any_asaq". Change applied in DRC, need to verify for other countries. 

* Questions: 

*------------------------------------------------------------------------------*
	
capture confirm variable any_alu 
	if !_rc == 0 {	
	
*** NIGERIA ***

* Required dataset: 	REF

if ("$country" == "Nigeria") {
// Injectable antimalarials			
forval i = 1/14 {
		tempvar as_old`i' as_new`i' artem_old`i' artem_new`i' quin_old`i' quin_new`i'
		gen `as_old`i'' = .
		gen `as_new`i'' = .
		gen `artem_old`i'' = .
		gen `artem_new`i'' = .
		gen `quin_old`i'' = .
		gen `quin_new`i'' = .
		// Artesunate, IV or IM
			cap noisily replace `as_old`i'' = 1 if ref_med_10_`i' == 1 		/// 
				& (ref_q160j_med_mode_`i' == 1 | ref_q160j_med_mode_`i' == 2)		
			cap noisily replace `as_new`i'' = 1 if ref_drug_am_10_`i' == 1 	///
				& (ref_q160j_med_mode_`i' == 1 | ref_q160j_med_mode_`i' == 2)	
			local aslist `aslist' `as_old`i'' `as_new`i''
		// Artemether, IV or IM
			cap noisily replace `artem_old`i'' = 1 if ref_med_11_`i' == 1 	///
				& (ref_q160k_med_mode_`i' == 1 | ref_q160k_med_mode_`i' == 2)
			capture noisily replace `artem_new`i''=1 if ref_drug_am_nx_11_`i' == 1 ///
				& (ref_q160k_med_mode_`i' == 1 | ref_q160k_med_mode_`i' == 2)	
			local amlist `amlist' `artem_old`i'' `artem_new`i''
		// Quinine, IV or IM
			cap noisily replace `quin_old`i'' = 1 if ref_med_14_`i' == 1 	///
				& (ref_q160n_med_mode_`i' == 1 | ref_q160n_med_mode_`i' == 2)
			cap noisily replace `quin_new`i'' = 1 if ref_drug_am_14_`i' == 1 ///
				& (ref_q160n_med_mode_`i' == 1 | ref_q160n_med_mode_`i' == 2)
			local quinlist `quinlist' `quin_old`i'' `quin_new`i''
}	
		
		egen any_as = anymatch(`aslist'), values(1)			// Artesunate
			replace any_as = . if ref_KEY == ""
		egen any_artem = anymatch(`amlist'), values(1)		// Artemether
			replace any_artem = . if ref_KEY == ""
		egen any_quin = anymatch(`quinlist'), values(1)		// Quinine
			replace any_quin = . if ref_KEY == ""
		label variable any_as "REF: Received Artesunate, IM or IV"
		label variable any_artem "REF: Received Artemether, IM or IV"
		label variable any_quin "REF: Received Quinine, IM or IV"
		
// ACTs
	
	// Administration during admission
	forval i = 1/14 {
			tempvar alu_old`i' alu_new`i' asaq_old`i' asaq_new`i' 				///
				quinoral_old`i' quinoral_new`i'
			gen `alu_old`i'' = .
			gen `alu_new`i'' = .
			gen `asaq_old`i'' = .
			gen `asaq_new`i'' = .
			gen `quinoral_old`i'' = .
			gen `quinoral_new`i'' = .
			// Artemether-Lumefantrine
				cap noisily replace `alu_old`i''= 1 if ref_med_8_`i' == 1 		///
					& ref_q160h_med_mode_`i' == 4
				cap noisily replace `alu_new`i'' = 1 if ref_drug_am_8_`i' == 1 	///
					& ref_q160h_med_mode_`i' == 4
				local alulist `alulist' `alu_old`i'' `alu_new`i''
			// Artesunate-Amodiaquine - REMOVED MODE OF ADMINISTRATION STRATIFICATION FOR V4
				cap noisily replace `asaq_old`i''= 1 if ref_med_12_`i' == 1 	///
					& ref_q160l_med_mode_`i' == 4 
				cap noisily replace `asaq_new`i'' = 1 if ref_drug_am_12_`i' == 1
				
				local asaqlist `asaqlist' `asaq_old`i'' `asaq_new`i''
			// Oral Quinine
				cap noisily replace `quinoral_old`i''= 1 if ref_med_14_`i' == 1 ///	
					& ref_q160n_med_mode_`i' == 4
			capture noisily replace `quinoral_new`i''= 1 if ref_drug_am_14_`i'== 1 ///
					& ref_q160n_med_mode_`i' == 4
				local quinorallist `quinorallist' `quinoral_old`i'' `quinoral_new`i''
	}	

			egen any_alu = anymatch(`alulist'), values(1)			// ALu
				replace any_alu = . if ref_KEY == ""
			egen any_asaq = anymatch(`asaqlist'), values(1)			// ASAQ
				replace any_asaq = . if ref_KEY == ""
			egen any_quin_oral = anymatch(`quinorallist'), values(1) // Oral Quinine
				replace any_quin_oral = . if ref_KEY == ""
			egen any_act = anymatch(any_alu any_asaq), values(1)
				replace any_act = . if ref_KEY == ""
			label variable any_alu "REF: Received Artemether-Lumefantrine during admission"
			label variable any_asaq "REF: Received Artesunate-Amodiaquine during admission"
			label variable any_quin_oral "REF: Received oral Quinine during admission"
			label variable any_act "REF: Received any ACT during admission (ALu, ASAQ)"
		
	// Prescribed/recorded on discharge (REF-v4 only)
		// ALu
		gen any_alu_v4	= (ref_med_disc_act_type == 1)
			replace any_alu_v4 = . if ref_med_disc_act_type == .
		// ASAQ
		gen any_asaq_v4	= (ref_med_disc_act_type == 2)
			replace any_asaq_v4 = . if ref_med_disc_act_type == .
			replace any_asaq_v4 = 1 if ref_KEY == "uuid:d9a9282e-168b-4524-88d7-21f65496ef80"
		// Oral Quinine
		gen any_quin_oral_v4 = (ref_med_disc_quin == 1 |			/// 
								ref_med_disc_quin == 2 | 			///
								ref_med_disc_quin == 3 | 			///
								ref_med_disc_quin == 4)
			replace any_quin_oral_v4 = . if ref_med_disc_quin == .
		// Any ACT
		egen any_act_v4 = anymatch(ref_med_disc_act), values(1 2 3 -96)
			replace any_act_v4 = . if ref_med_disc_act == .
			
		label variable any_alu_v4 "REF-v4: Received or was prescribed ALu"
		label variable any_asaq_v4 "REF-v4: Received or was prescribed ASAQ"
		label variable any_quin_oral_v4 "REF-v4: Received or was prescribed oral Quinine"
		label variable any_act_v4 "REF-v4: Received or was prescribed any ACT (ALu, ASAQ)"
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required datasets:	REF

if ("$country" == "Uganda") {
// Injectable antimalarials			
forval i = 1/41 {
		tempvar as_old`i' as_new`i' artem_old`i' artem_new`i' quin_old`i' quin_new`i'
		gen `as_old`i'' = .
		gen `as_new`i'' = .
		gen `artem_old`i'' = .
		gen `artem_new`i'' = .
		gen `quin_old`i'' = .
		gen `quin_new`i'' = .
		// Artesunate, IV or IM
			cap noisily replace `as_old`i'' = 1 if ref_med_10_`i' == 1 		/// 
				& (ref_q160j_med_mode_`i' == 1 | ref_q160j_med_mode_`i' == 2)		
			cap noisily replace `as_new`i'' = 1 if ref_drug_am_10_`i' == 1 	///
				& (ref_q160j_med_mode_`i' == 1 | ref_q160j_med_mode_`i' == 2)	
			local aslist `aslist' `as_old`i'' `as_new`i''
		// Artemether, IV or IM
			cap noisily replace `artem_old`i'' = 1 if ref_med_11_`i' == 1 	///
				& (ref_q160k_med_mode_`i' == 1 | ref_q160k_med_mode_`i' == 2)
			capture noisily replace `artem_new`i''=1 if ref_drug_am_nx_11_`i' == 1 ///
				& (ref_q160k_med_mode_`i' == 1 | ref_q160k_med_mode_`i' == 2)	
			local amlist `amlist' `artem_old`i'' `artem_new`i''
		// Quinine, IV or IM
			cap noisily replace `quin_old`i'' = 1 if ref_med_14_`i' == 1 	///
				& (ref_q160n_med_mode_`i' == 1 | ref_q160n_med_mode_`i' == 2)
			cap noisily replace `quin_new`i'' = 1 if ref_drug_am_14_`i' == 1 ///
				& (ref_q160n_med_mode_`i' == 1 | ref_q160n_med_mode_`i' == 2)
			local quinlist `quinlist' `quin_old`i'' `quin_new`i''
}	
		
		egen any_as = anymatch(`aslist'), values(1)			// Artesunate
			replace any_as = . if ref_KEY == ""
		egen any_artem = anymatch(`amlist'), values(1)		// Artemether
			replace any_artem = . if ref_KEY == ""
		egen any_quin = anymatch(`quinlist'), values(1)		// Quinine
			replace any_quin = . if ref_KEY == ""
		label variable any_as "REF: Received Artesunate, IM or IV"
		label variable any_artem "REF: Received Artemether, IM or IV"
		label variable any_quin "REF: Received Quinine, IM or IV"
		
// ACTs
	
	// Administration during admission
	forval i = 1/41 {
			tempvar alu_old`i' alu_new`i' asaq_old`i' asaq_new`i' 				///
				quinoral_old`i' quinoral_new`i'
			gen `alu_old`i'' = .
			gen `alu_new`i'' = .
			gen `asaq_old`i'' = .
			gen `asaq_new`i'' = .
			gen `quinoral_old`i'' = .
			gen `quinoral_new`i'' = .
			// Artemether-Lumefantrine
				cap noisily replace `alu_old`i''= 1 if ref_med_8_`i' == 1 		///
					& ref_q160h_med_mode_`i' == 4
				cap noisily replace `alu_new`i'' = 1 if ref_drug_am_8_`i' == 1 	///
					& ref_q160h_med_mode_`i' == 4
				local alulist `alulist' `alu_old`i'' `alu_new`i''
			// Artesunate-Amodiaquine - REMOVED MODE OF ADMINISTRATION STRATIFICATION FOR V4
				cap noisily replace `asaq_old`i''= 1 if ref_med_12_`i' == 1 	///
					& ref_q160l_med_mode_`i' == 4 
				cap noisily replace `asaq_new`i'' = 1 if ref_drug_am_12_`i' == 1
				
				local asaqlist `asaqlist' `asaq_old`i'' `asaq_new`i''
			// Oral Quinine
				cap noisily replace `quinoral_old`i''= 1 if ref_med_14_`i' == 1 ///	
					& ref_q160n_med_mode_`i' == 4
			capture noisily replace `quinoral_new`i''= 1 if ref_drug_am_14_`i'== 1 ///
					& ref_q160n_med_mode_`i' == 4
				local quinorallist `quinorallist' `quinoral_old`i'' `quinoral_new`i''
	}	

			egen any_alu = anymatch(`alulist'), values(1)			// ALu
				replace any_alu = . if ref_KEY == ""
			egen any_asaq = anymatch(`asaqlist'), values(1)			// ASAQ
				replace any_asaq = . if ref_KEY == ""
			egen any_quin_oral = anymatch(`quinorallist'), values(1) // Oral Quinine
				replace any_quin_oral = . if ref_KEY == ""
			egen any_act = anymatch(any_alu any_asaq), values(1)
				replace any_act = . if ref_KEY == ""
			label variable any_alu "REF: Received Artemether-Lumefantrine during admission"
			label variable any_asaq "REF: Received Artesunate-Amodiaquine during admission"
			label variable any_quin_oral "REF: Received oral Quinine during admission"
			label variable any_act "REF: Received any ACT during admission (ALu, ASAQ)"
		
	// Prescribed/recorded on discharge (implemented with v4)
		// ALu
		gen any_alu_v4	= (ref_med_disc_act_type == 1)
			replace any_alu_v4 = . if ref_med_disc_act_type == .
		// ASAQ
		gen any_asaq_v4	= (ref_med_disc_act_type == 2)
			replace any_asaq_v4 = . if ref_med_disc_act_type == .
		// Oral Quinine
		gen any_quin_oral_v4 = (ref_med_disc_quin == 1 |			/// 
								ref_med_disc_quin == 2 | 			///
								ref_med_disc_quin == 3 | 			///
								ref_med_disc_quin == 4)
			replace any_quin_oral_v4 = . if ref_med_disc_quin == .
		// Any ACT
		egen any_act_v4 = anymatch(ref_med_disc_act), values(1 2 3 -96)
			replace any_act_v4 = . if ref_med_disc_act == .
			
		label variable any_alu_v4 "REF-v4: Received or was prescribed ALu"
		label variable any_asaq_v4 "REF-v4: Received or was prescribed ASAQ"
		label variable any_quin_oral_v4 "REF-v4: Received or was prescribed oral Quinine"
		label variable any_act_v4 "REF-v4: Received or was prescribed any ACT (ALu, ASAQ)"
			
}

*------------------------------------------------------------------------------*

*** DRC *** // 

*Injectable artesunate

* Required dataset: 	REF

if ("$country" == "DRC") 

{

// Injectable antimalarials			
forval i = 1/41 {
		tempvar as_old`i' as_new`i' artem_old`i' artem_new`i' quin_old`i' quin_new`i'
		gen `as_old`i'' = .
		gen `as_new`i'' = .
		gen `artem_old`i'' = .
		gen `artem_new`i'' = .
		gen `quin_old`i'' = .
		gen `quin_new`i'' = .
		// Artesunate, IV or IM
			cap noisily replace `as_old`i'' = 1 if ref_med_10_`i' == 1 		/// 
				& (ref_q160j_med_mode`i' == 1 | ref_q160j_med_mode`i' == 2)		
			cap noisily replace `as_new`i'' = 1 if ref_drug_am_10_`i' == 1 	///
				& (ref_q160j_med_mode`i' == 1 | ref_q160j_med_mode`i' == 2)	
			local aslist `aslist' `as_old`i'' `as_new`i''
		// Artemether, IV or IM
			cap noisily replace `artem_old`i'' = 1 if ref_med_11_`i' == 1 	///
				& (ref_q160k_med_mode`i' == 1 | ref_q160k_med_mode`i' == 2)
			capture noisily replace `artem_new`i''=1 if ref_drug_am_nx_11_`i' == 1 ///
				& (ref_q160k_med_mode`i' == 1 | ref_q160k_med_mode`i' == 2)	
			local amlist `amlist' `artem_old`i'' `artem_new`i''
		// Quinine, IV or IM
			cap noisily replace `quin_old`i'' = 1 if ref_med_14_`i' == 1 	///
				& (ref_q160n_med_mode`i' == 1 | ref_q160n_med_mode`i' == 2)
			cap noisily replace `quin_new`i'' = 1 if ref_drug_am_14_`i' == 1 ///
				& (ref_q160n_med_mode`i' == 1 | ref_q160n_med_mode`i' == 2)
			local quinlist `quinlist' `quin_old`i'' `quin_new`i''
}	
		
		egen any_as = anymatch(`aslist'), values(1)			// Artesunate
			replace any_as = . if ref_KEY == ""
		egen any_artem = anymatch(`amlist'), values(1)		// Artemether
			replace any_artem = . if ref_KEY == ""
		egen any_quin = anymatch(`quinlist'), values(1)		// Quinine
			replace any_quin = . if ref_KEY == ""
		label variable any_as "REF: Received Artesunate, IM or IV"
		label variable any_artem "REF: Received Artemether, IM or IV"
		label variable any_quin "REF: Received Quinine, IM or IV"
		
// ACTs : ACTHUNG! ISSUE WITH ASAQ MODE OF ADMINISTRATION (q160l_med_mode): wrong relevance in form of version 4! do not consider mode of administration in definition
	
	// Administration during admission
	forval i = 1/41 {
			tempvar alu_old`i' alu_new`i' asaq_old`i' asaq_new`i' 				///
				quinoral_old`i' quinoral_new`i'
			gen `alu_old`i'' = .
			gen `alu_new`i'' = .
			gen `asaq_old`i'' = .
			gen `asaq_new`i'' = .
			gen `quinoral_old`i'' = .
			gen `quinoral_new`i'' = .
			// Artemether-Lumefantrine
				cap noisily replace `alu_old`i''= 1 if ref_med_8_`i' == 1 		///
					& ref_q160h_med_mode`i' == 4
				cap noisily replace `alu_new`i'' = 1 if ref_drug_am_8_`i' == 1 	///
					& ref_q160h_med_mode`i' == 4
				local alulist `alulist' `alu_old`i'' `alu_new`i''
			// Artesunate-Amodiaquine- REMOVED MODE OF ADMINISTRATION STRATIFICATION FOR V4
				cap noisily replace `asaq_old`i''= 1 if ref_med_12_`i' == 1 	///
					& ref_q160l_med_mode`i' == 4 
				cap noisily replace `asaq_new`i'' = 1 if ref_drug_am_12_`i' == 1 	
				
				local asaqlist `asaqlist' `asaq_old`i'' `asaq_new`i''
			// Oral Quinine
				cap noisily replace `quinoral_old`i''= 1 if ref_med_14_`i' == 1 ///	
					& ref_q160n_med_mode`i' == 4
			capture noisily replace `quinoral_new`i''= 1 if ref_drug_am_14_`i'== 1 ///
					& ref_q160n_med_mode`i' == 4
				local quinorallist `quinorallist' `quinoral_old`i'' `quinoral_new`i''
	}	

			egen any_alu = anymatch(`alulist'), values(1)			// ALu
				replace any_alu = . if ref_KEY == ""
			egen any_asaq = anymatch(`asaqlist'), values(1)			// ASAQ
				replace any_asaq = . if ref_KEY == ""
			egen any_quin_oral = anymatch(`quinorallist'), values(1) // Oral Quinine
				replace any_quin_oral = . if ref_KEY == ""
			egen any_act = anymatch(any_alu any_asaq), values(1)
				replace any_act = . if ref_KEY == ""
			label variable any_alu "REF: Received Artemether-Lumefantrine during admission"
			label variable any_asaq "REF: Received Artesunate-Amodiaquine during admission"
			label variable any_quin_oral "REF: Received oral Quinine during admission"
			label variable any_act "REF: Received any ACT during admission (ALu, ASAQ)"
		
	// Prescribed/recorded on discharge (implemented with v4)
		// ALu
		gen any_alu_v4	= (ref_med_disc_act_type == 1)
			replace any_alu_v4 = . if ref_med_disc_act_type == .
			replace any_alu_v4 = 1 if ref_KEY == "uuid:df12ff3e-a91d-4e1d-bbfb-de0c78869ef5"
		// ASAQ
		gen any_asaq_v4	= (ref_med_disc_act_type == 2)
			replace any_asaq_v4 = . if ref_med_disc_act_type == .
			replace any_asaq_v4 = 1 if ref_KEY == "uuid:df12ff3e-a91d-4e1d-bbfb-de0c78869ef5"
		// Oral Quinine
		gen any_quin_oral_v4 = (ref_med_disc_quin == 1 |			/// 
								ref_med_disc_quin == 2 | 			///
								ref_med_disc_quin == 3 | 			///
								ref_med_disc_quin == 4)
			replace any_quin_oral_v4 = . if ref_med_disc_quin == .
		// Any ACT
		egen any_act_v4 = anymatch(ref_med_disc_act), values(1 2 3 -96)
			replace any_act_v4 = . if ref_med_disc_act == .
			
		label variable any_alu_v4 "REF-v4: Received or was prescribed ALu"
		label variable any_asaq_v4 "REF-v4: Received or was prescribed ASAQ"
		label variable any_quin_oral_v4 "REF-v4: Received or was prescribed oral Quinine"
		label variable any_act_v4 "REF-v4: Received or was prescribed any ACT (ALu, ASAQ)"
			
}


	
*------------------------------------------------------------------------------*

	
