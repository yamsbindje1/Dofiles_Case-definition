********************************************************************************
*** CARAMAL DEFINITIONS: TEST DATASETS *****************************************
********************************************************************************

* Author:	NBNR
* Date:		04.06.2021

* Updates:
* TLEE, 2021Jun11 - removed variables that can identify a patient (NG)

*------------------------------------------------------------------------------*

clear
clear matrix
clear mata
set maxvar 30000

*------------------------------------------------------------------------------*
	
*** DRC *** 
{
* D0 
use "D:\ANALYSE FINALE CARAMAL_Modele\PSS FINAL ANALYSIS\PSS final format\PSS D0_DRC_clean_2021.02.01.dta", clear
	
	keep caramal_id Age_years						/// Age
			reg_fever vht_fever						/// Fever
			reg_rdt vht_rdt							/// Malaria test
			reg_danger* vht_danger*					/// Danger signs
			reg_ras vht_ras							/// RAS administration
			vht_date								
	
	rename * d0_*
	rename d0_caramal_id caramal_id
	
	tempfile D0
	save `D0'
	
* D28
use "D:\ANALYSE FINALE CARAMAL_Modele\PSS FINAL ANALYSIS\PSS final format\PSS D28 DRC_clean_2021.02.15.dta" , clear

	keep caramal_id KEY todaynow 								///
			Age_years d_b 										/// Age
			q6 q11_* q11_oth									/// Fever
			q7 q8 q9 q6a q7a q9a								/// Danger signs
			q10 q10_1 q10_2 q10_3 q10_4 q10_5 q10_7				/// 
			q25_*												/// Malaria test
			confirm_con2 confirm_con_rhf						/// Informed consent
			q14_* q15_* q16_*									/// Provider
			q32_*												/// RAS administration
			q31* q29* q30*										/// AM treatment
			q1 q1a												/// Date of death
			version												/// Form version
			q79*												/// mRDt on D28
			today												// Date of interview
			
	rename * d28_*
	rename d28_caramal_id caramal_id
	
	tempfile D28
	save `D28'
	
* D28-DF 
use "D:\ANALYSE FINALE CARAMAL_Modele\PSS FINAL ANALYSIS\PSS final format\PSS VA DRC_clean_2021.02.01.dta", clear

	keep caramal_id KEY											///
			todaynow Age_years d_b								/// Age 
			q6 q11* 											/// Fever
			q7 q8 q9 q6a q7a q9a								/// Danger signs
			q10 q10_1 q10_2 q10_3 q10_4 q10_5 q10_7				/// 
			q25_*												/// Malaria test
			confirm_con2										/// Informed consent
			q14_* q15_* q16_*									/// Provider
			checkdx dx											/// Date of death
			q32_*												/// RAS administration
			q31* q29* q30*										/// AM treatment
			version												/// Form version
			d0													// Date of enrolment
	
	rename * df_*
	rename df_caramal_id caramal_id
	
	tempfile D28DF
	save `D28DF'

* REF
use "D:\ANALYSE FINALE CARAMAL_Modele\PSS FINAL ANALYSIS\PSS final format\PSS REF_DRC_subset_ros3_clean_2021.02.11.dta", clear

	keep caramal_id KEY	version						///
			age_years								/// Age
			fever									/// Fever
			mrdt* slide*							/// Malaria test
			med_hist_smal adm_smal_arrival			/// Severe malaria diagnosis
			adm_smal								///
			conv consc vomit drink chest			/// Danger signs
			bdiarr palms fever_d cough_d diarr_d	///
			muac_arrival jaund_arrival pallor_arrival ///
			sitstand_arrival lethar_arrival			///
			unconsc_arrival convuls_arrival			///
			breath chest sc_reces_arrival			///
			wheez_arrival							///
			confirm_con2							/// Informed consent
			ras_week								/// RAS administration
			dispo death_date						/// Date of death
			med_* drug_am* med_disc*				/// AM treatment
			q160*_med_mode*							/// Mode of administration
			date_adm referral						// Date of enrollment
			
	rename * ref_*
	rename ref_caramal_id caramal_id
	
	tempfile REF 
	save `REF'
	
* CCR
use "D:\ANALYSE FINALE CARAMAL_Modele\PSS FINAL ANALYSIS\PSS final format\CCR_DRC_Clean_12012021.dta", clear

	keep caramal_id place_enrolment					/// Enrolment location
			age_years_clean							/// Age	
			date_enrolment							/// Date of enrolment
			final_outcome							/// Health outcome on Day 28
			child_name level2						/// Identification for Giulia
			comments comments_2
			

	rename * ccr_*
	rename ccr_caramal_id caramal_id
}
merge 1:1 caramal_id using `D0', gen(merge_d0)
merge 1:1 caramal_id using `D28', gen(merge_d28)
merge 1:1 caramal_id using `D28DF', gen(merge_df)
merge 1:1 caramal_id using `REF', gen(merge_ref)

drop if merge_d0 == 2 | merge_d28 == 2 | merge_df == 2 | merge_ref == 2

// Rename oth variables if necessary
capture rename *_oth* *oth*

*global country = "DRC"

do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\1_definition_age.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\2_definition_fever.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\3_definition_malariatest.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\4_definition_smaldiagnosis.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\5_definition_consent.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\6_definition_d28symptoms.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\7_definition_dangersigns.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\8_definition_enrollmentlocation.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\9_definition_firstprovider.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\10_definition_referralcompletion.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\11_definition_providernumber.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\12_definition_AMtreatment_REF.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\13_definition_AMtreatment_D28(-DF).do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\15_definition_inclusion.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\16_definition_RASadministration.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\18_definition_RASimplementation.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\19_definition_deathdate.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\20_definition_enrolmentdate.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\21_definition_anyfirstprovider.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\22_definition_afterprovider.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\23_definition_referraldelay.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\24_definition_healthoutcome.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\25_definition_firstproviderdelay.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\26_definition_mrdtresult_D28.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\27_definition_diagnoses.do"
do "D:\ANALYSE FINALE CARAMAL_Modele\Dofiles_Case definition\Dofiles_Case definition\29_definition_enrollingprovider_DRAFT.do"








