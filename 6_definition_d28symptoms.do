********************************************************************************
*** CARAMAL DEFINITIONS: D28 SYMPTOMS ******************************************
********************************************************************************

* Author:	NBNR
* Date:		05.03.2021

* Version control:
* 		- v1.0			NBNR		Defined D28 danger sign symptoms for all countries
*		- v1.1			NBNR		DRC: Added lethargie to symptom_sleepy
*									DRC: Added paleur cutanée to symptom_whitepalms
*		- *please enter changes here
*		- 				GDEO		DRC: Line 259 Removed "	|  d28_q11_27 == 1	"
*									because of wrong labeling

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

* Questions: 
*				- Vomiting everything - consider q11?
*				- Cough for 21 days or more - D28 only asks about 14 days
*				- All danger sings in all countries or only WHO + country?

*------------------------------------------------------------------------------*
// symptom_* are auxiliary variables in another do-file. 
// Check if they already exist
capture confirm variable symptom_bloody_diarrhea
	if !_rc == 0 {
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	D28, D28-DF

if ("$country" == "Nigeria") {
	* Consolidate symptoms according to D28(-DF): 

		*** D28 ***
		// q11 added after UG meeting; 18.05.2019
		gen symptom_breathing =	d28_q11_5 == 1
		gen symptom_vomit = 	d28_q11_7 == 1
		gen symptom_convulsion = d28_q11_12 == 1
		gen symptom_sleepy = 	d28_q11_16 == 1
		gen symptom_bloody_diarrhea = d28_q11_17 == 1
		gen symptom_nodrink = 	d28_q11_19 == 1
		gen symptom_swelling = 	d28_q11_20 == 1
		gen symptom_nosit = 	d28_q11_21 == 1
		gen symptom_darkurine =	d28_q11_23 == 1
		gen symptom_whitepalms = d28_q11_24 == 1
		gen symptom_yelloweyes = d28_q11_25 == 1

		** code probing questions 	// not in UG version 2
		*Q6a. How long did ${child_name} have fever? - More than one week
			gen symptom_fever7 = 1 if d28_q6a == 3
		*Q7a. How long did ${child_name} have diarrhea? - More than two weeks
			gen symptom_diarrhea14 = 1 if d28_q7a == 4
		*Q8.  During that illness, did ${child_name} have any blood in the stool?
			replace symptom_bloody_diarrhea = 1 if d28_q8 == 1
		*Q9a. How long did ${child_name} have a cough? - More than two weeks
			gen symptom_cough14 = 1 if d28_q9a == 4
		*Q10. During that illness, did ${child_name} experience fast or difficulty in breathing?
			replace symptom_breathing = 1 if d28_q10 == 1
		*Q10.1. During that illness, did ${child_name} vomit everything?
			replace symptom_vomit = 1 if d28_q10_1 == 1
		*Q10.2. During that illness, did ${child_name} have convulsions?
			replace symptom_convulsion = 1 if d28_q10_2 == 1

		*Q10.3. During that illness, was ${child_name} unusually sleepy or unconscious?
			replace symptom_sleepy = 1 if d28_q10_3 == 1
		*Q10.4. During that illness, was ${child_name} unable to sit or stand up?
			replace symptom_nosit = 1 if d28_q10_4 == 1
		*Q10.5. During that illness, was ${child_name} not able to breastfeed, drink or eat anything?
			replace symptom_nodrink = 1 if d28_q10_5 == 1
		*Q10.6. During that illness, was ${child_name} unusually tired or unconscious?
			*replace symptom_sleepy = 1 if d28_q10_6 == 1
		*Q10.7. During that illness, did  have Coke (Coca-Cola) coloured urine? 
			replace symptom_darkurine = 1 if d28_q10_7 == 1
			
		*** D28-DF ***
		replace symptom_breathing =	1 if df_q11_5 == 1
		replace symptom_vomit = 	1 if df_q11_7 == 1
		replace symptom_convulsion = 1 if df_q11_12 == 1
		replace symptom_sleepy = 	1 if df_q11_16 == 1
		replace symptom_bloody_diarrhea = 1 if df_q11_17 == 1 
		replace symptom_nodrink = 	1 if df_q11_19 == 1
		replace symptom_swelling = 	1 if df_q11_20 == 1
		replace symptom_nosit = 	1 if df_q11_21 == 1
		replace symptom_darkurine =	1 if df_q11_23 == 1
		replace symptom_whitepalms = 1 if df_q11_24 == 1
		replace symptom_yelloweyes = 1 if df_q11_25 == 1

		** code probing questions
		*Q6a. How long did ${child_name} have fever? - More than one week
			replace symptom_fever7 = 1 if df_q6a == 3
		*Q7a. How long did ${child_name} have diarrhea? - More than two weeks
			replace symptom_diarrhea14 = 1 if df_q7a == 4
		*Q8.  During that illness, did ${child_name} have any blood in the stool?
			replace symptom_bloody_diarrhea = 1 if df_q8 == 1
		*Q9a. How long did ${child_name} have a cough? - More than two weeks
			replace symptom_cough14 = 1 if df_q9a == 4
		*Q10. During that illness, did ${child_name} experience fast or difficulty in breathing?
			replace symptom_breathing = 1 if df_q10 == 1
		*Q10.1. During that illness, did ${child_name} vomit everything?
			replace symptom_vomit = 1 if df_q10_1 == 1
		*Q10.2. During that illness, did ${child_name} have convulsions?
			replace symptom_convulsion = 1 if df_q10_2 == 1
		*Q10.3. During that illness, was ${child_name} unusually sleepy or unconscious?
			replace symptom_sleepy = 1 if df_q10_3 == 1
		*Q10.4. During that illness, was ${child_name} unable to sit or stand up?
			replace symptom_nosit = 1 if df_q10_4 == 1
		*Q10.5. During that illness, was ${child_name} not able to breastfeed, drink or eat anything?
			replace symptom_nodrink = 1 if df_q10_5 == 1
		*Q10.6. During that illness, was ${child_name} unusually tired or unconscious?
		*replace symptom_sleepy = 1 if df_q10_6 == 1
		*Q10.7. During that illness, did  have Coke (Coca-Cola) coloured urine? 
			replace symptom_darkurine = 1 if df_q10_7 == 1
			
	label variable symptom_fever7 "D28 danger sign: Fever for 7 days or more"
	label variable symptom_diarrhea14 "D28 danger sign: Diarrhea for 14 days or more"
	label variable symptom_bloody_diarrhea "D28 danger sign: Bloody diarrhea"
	label variable symptom_cough14 "D28 danger sign: Cough for 14 days or more"
	label variable symptom_breathing "D28 danger sign: Fast or difficulty breathing"
	label variable symptom_vomit "D28 danger sign: Vomiting everything"
	label variable symptom_convulsion "D28 danger sign: Convulsions"
	label variable symptom_sleepy "D28 danger sign: Unusually sleepy or unconscious"
	label variable symptom_nosit "D28 danger sign: Unable to sit or stand up"
	label variable symptom_nodrink "D28 danger sign: Not able to breastfeed, drink or eat anything"
	label variable symptom_swelling "D28 danger sign: Swelling of both feet"
	label variable symptom_darkurine "D28 danger sign: Coke (Coca-Cola) coloured urine"
	label variable symptom_whitepalms "D28 danger sign: White palms or soles"
	label variable symptom_yelloweyes "D28 danger sign: Yellow eyes"
	label values symptom_* yesno
}
		
*------------------------------------------------------------------------------*			
*** UGANDA ***

* Required datasets:	D28, D28-DF

if ("$country" == "Uganda") {
	* Consolidate symptoms according to D28(-DF): 

		*** D28 ***
		// q11 added after UG meeting; 18.05.2019
		gen symptom_breathing =	d28_q11_5 == 1
		gen symptom_vomit = 	d28_q11_7 == 1
		gen symptom_convulsion = d28_q11_12 == 1
		gen symptom_sleepy = 	d28_q11_16 == 1
		gen symptom_bloody_diarrhea = d28_q11_17 == 1
		gen symptom_nodrink = 	d28_q11_19 == 1
		gen symptom_swelling = 	d28_q11_20 == 1
		gen symptom_nosit = 	d28_q11_21 == 1
		gen symptom_darkurine =	d28_q11_23 == 1
		gen symptom_whitepalms = d28_q11_24 == 1
		gen symptom_yelloweyes = d28_q11_25 == 1

		** code probing questions 	// not in UG version 2
		*Q6a. How long did ${child_name} have fever? - More than one week
			gen symptom_fever7 = 1 if d28_q6a == 3
		*Q7a. How long did ${child_name} have diarrhea? - More than two weeks
			gen symptom_diarrhea14 = 1 if d28_q7a == 4
		*Q8.  During that illness, did ${child_name} have any blood in the stool?
			replace symptom_bloody_diarrhea = 1 if d28_q8 == 1
		*Q9a. How long did ${child_name} have a cough? - More than two weeks
			gen symptom_cough14 = 1 if d28_q9a == 4
		*Q10. During that illness, did ${child_name} experience fast or difficulty in breathing?
			replace symptom_breathing = 1 if d28_q10 == 1
		*Q10.1. During that illness, did ${child_name} vomit everything?
			replace symptom_vomit = 1 if d28_q10_1 == 1
		*Q10.2. During that illness, did ${child_name} have convulsions?
			replace symptom_convulsion = 1 if d28_q10_2 == 1

		*Q10.3. During that illness, was ${child_name} unusually sleepy or unconscious?
			replace symptom_sleepy = 1 if d28_q10_3 == 1
		*Q10.4. During that illness, was ${child_name} unable to sit or stand up?
			replace symptom_nosit = 1 if d28_q10_4 == 1
		*Q10.5. During that illness, was ${child_name} not able to breastfeed, drink or eat anything?
			replace symptom_nodrink = 1 if d28_q10_5 == 1
		*Q10.6. During that illness, was ${child_name} unusually tired or unconscious?
			*replace symptom_sleepy = 1 if d28_q10_6 == 1
		*Q10.7. During that illness, did  have Coke (Coca-Cola) coloured urine? 
			replace symptom_darkurine = 1 if d28_q10_7 == 1
			
		*** D28-DF ***
		replace symptom_breathing =	1 if df_q11 == 5 
		replace symptom_vomit = 	1 if df_q11 == 7 
		replace symptom_convulsion = 1 if df_q11 == 12
		replace symptom_sleepy = 	1 if df_q11 == 16 
		replace symptom_bloody_diarrhea = 1 if df_q11 == 17 
		replace symptom_nodrink = 	1 if df_q11 == 19 
		replace symptom_swelling = 	1 if df_q11 == 20 
		replace symptom_nosit = 	1 if df_q11 == 21 
		replace symptom_darkurine =	1 if df_q11 == 23
		replace symptom_whitepalms = 1 if df_q11 == 24
		replace symptom_yelloweyes = 1 if df_q11 == 25

		** code probing questions 	// not in UG version 2
		*Q6a. How long did ${child_name} have fever? - More than one week
			replace symptom_fever7 = 1 if df_q6a == 3
		*Q7a. How long did ${child_name} have diarrhea? - More than two weeks
			replace symptom_diarrhea14 = 1 if df_q7a == 4
		*Q8.  During that illness, did ${child_name} have any blood in the stool?
			replace symptom_bloody_diarrhea = 1 if df_q8 == 1
		*Q9a. How long did ${child_name} have a cough? - More than two weeks
			replace symptom_cough14 = 1 if df_q9a == 4
		*Q10. During that illness, did ${child_name} experience fast or difficulty in breathing?
			replace symptom_breathing = 1 if df_q10 == 1
		*Q10.1. During that illness, did ${child_name} vomit everything?
			replace symptom_vomit = 1 if df_q10_1 == 1
		*Q10.2. During that illness, did ${child_name} have convulsions?
			replace symptom_convulsion = 1 if df_q10_2 == 1
		*Q10.3. During that illness, was ${child_name} unusually sleepy or unconscious?
			replace symptom_sleepy = 1 if df_q10_3 == 1
		*Q10.4. During that illness, was ${child_name} unable to sit or stand up?
			replace symptom_nosit = 1 if df_q10_4 == 1
		*Q10.5. During that illness, was ${child_name} not able to breastfeed, drink or eat anything?
			replace symptom_nodrink = 1 if df_q10_5 == 1
		*Q10.6. During that illness, was ${child_name} unusually tired or unconscious?
		*replace symptom_sleepy = 1 if df_q10_6 == 1
		*Q10.7. During that illness, did  have Coke (Coca-Cola) coloured urine? 
			replace symptom_darkurine = 1 if df_q10_7 == 1
			
	label variable symptom_fever7 "D28 danger sign: Fever for 7 days or more"
	label variable symptom_diarrhea14 "D28 danger sign: Diarrhea for 14 days or more"
	label variable symptom_bloody_diarrhea "D28 danger sign: Bloody diarrhea"
	label variable symptom_cough14 "D28 danger sign: Cough for 14 days or more"
	label variable symptom_breathing "D28 danger sign: Fast or difficulty breathing"
	label variable symptom_vomit "D28 danger sign: Vomiting everything"
	label variable symptom_convulsion "D28 danger sign: Convulsions"
	label variable symptom_sleepy "D28 danger sign: Unusually sleepy or unconscious"
	label variable symptom_nosit "D28 danger sign: Unable to sit or stand up"
	label variable symptom_nodrink "D28 danger sign: Not able to breastfeed, drink or eat anything"
	label variable symptom_swelling "D28 danger sign: Swelling of both feet"
	label variable symptom_darkurine "D28 danger sign: Coke (Coca-Cola) coloured urine"
	label variable symptom_whitepalms "D28 danger sign: White palms or sole"
	label variable symptom_yelloweyes "D28 danger sign: Yellow eyes"
	label values symptom_* yesno
}
	
*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required datasets: 	D28, D28-DF

if ("$country" == "DRC") {
	* Consolidate symptoms according to D28(-DF): 

		*** D28 ***
		// q11 added after UG meeting; 18.05.2019
		gen symptom_breathing =	d28_q11_5 == 1
		gen symptom_vomit = 	d28_q11_7 == 1
		gen symptom_convulsion = d28_q11_12 == 1
		gen symptom_sleepy = 	d28_q11_16 == 1 | d28_q11_28 == 1	// Added lethargie
		gen symptom_bloody_diarrhea = d28_q11_17 == 1
		gen symptom_nodrink = 	d28_q11_19 == 1
		gen symptom_swelling = 	d28_q11_20 == 1
		gen symptom_nosit = 	d28_q11_21 == 1
		gen symptom_darkurine =	d28_q11_23 == 1	
		gen symptom_whitepalms = d28_q11_24 == 1 
		gen symptom_yelloweyes = d28_q11_25 == 1

		** code probing questions 	// not in UG version 2
		*Q6a. How long did ${child_name} have fever? - More than one week
			gen symptom_fever7 = 1 if d28_q6a == 3
		*Q7a. How long did ${child_name} have diarrhea? - More than two weeks
			gen symptom_diarrhea14 = 1 if d28_q7a == 4
		*Q8.  During that illness, did ${child_name} have any blood in the stool?
			replace symptom_bloody_diarrhea = 1 if d28_q8 == 1
		*Q9a. How long did ${child_name} have a cough? - More than two weeks
			gen symptom_cough14 = 1 if d28_q9a == 4
		*Q10. During that illness, did ${child_name} experience fast or difficulty in breathing?
			replace symptom_breathing = 1 if d28_q10 == 1
		*Q10.1. During that illness, did ${child_name} vomit everything?
			replace symptom_vomit = 1 if d28_q10_1 == 1
		*Q10.2. During that illness, did ${child_name} have convulsions?
			replace symptom_convulsion = 1 if d28_q10_2 == 1

		*Q10.3. During that illness, was ${child_name} unusually sleepy or unconscious?
			replace symptom_sleepy = 1 if d28_q10_3 == 1
		*Q10.4. During that illness, was ${child_name} unable to sit or stand up?
			replace symptom_nosit = 1 if d28_q10_4 == 1
		*Q10.5. During that illness, was ${child_name} not able to breastfeed, drink or eat anything?
			replace symptom_nodrink = 1 if d28_q10_5 == 1
		*Q10.6. During that illness, was ${child_name} unusually tired or unconscious?
			*replace symptom_sleepy = 1 if d28_q10_6 == 1
		*Q10.7. During that illness, did  have Coke (Coca-Cola) coloured urine? 
			replace symptom_darkurine = 1 if d28_q10_7 == 1
			
		*** D28-DF ***
		replace symptom_breathing =	1 if df_q11_5 == 1
		replace symptom_vomit = 	1 if df_q11_7 == 1
		replace symptom_convulsion = 1 if df_q11_12 == 1
		replace symptom_sleepy = 	1 if df_q11_16 == 1	| df_q11_28 == 1	// Added lethargie
		replace symptom_bloody_diarrhea = 1 if df_q11_17 == 1 
		replace symptom_nodrink = 	1 if df_q11_19 == 1
		replace symptom_swelling = 	1 if df_q11_20 == 1
		replace symptom_nosit = 	1 if df_q11_21 == 1
		replace symptom_darkurine =	1 if df_q11_23 == 1
		replace symptom_whitepalms = 1 if df_q11_24 == 1 | df_q11_27 == 1	// Added paleur cutanée
		*replace symptom_yelloweyes = 1 if df_q11_25 == 1	// not selected

		** code probing questions
		*Q6a. How long did ${child_name} have fever? - More than one week
			replace symptom_fever7 = 1 if df_q6a == 3
		*Q7a. How long did ${child_name} have diarrhea? - More than two weeks
			replace symptom_diarrhea14 = 1 if df_q7a == 4
		*Q8.  During that illness, did ${child_name} have any blood in the stool?
			replace symptom_bloody_diarrhea = 1 if df_q8 == 1
		*Q9a. How long did ${child_name} have a cough? - More than two weeks
			replace symptom_cough14 = 1 if df_q9a == 4
		*Q10. During that illness, did ${child_name} experience fast or difficulty in breathing?
			replace symptom_breathing = 1 if df_q10 == 1
		*Q10.1. During that illness, did ${child_name} vomit everything?
			replace symptom_vomit = 1 if df_q10_1 == 1
		*Q10.2. During that illness, did ${child_name} have convulsions?
			replace symptom_convulsion = 1 if df_q10_2 == 1
		*Q10.3. During that illness, was ${child_name} unusually sleepy or unconscious?
			replace symptom_sleepy = 1 if df_q10_3 == 1
		*Q10.4. During that illness, was ${child_name} unable to sit or stand up?
			replace symptom_nosit = 1 if df_q10_4 == 1
		*Q10.5. During that illness, was ${child_name} not able to breastfeed, drink or eat anything?
			replace symptom_nodrink = 1 if df_q10_5 == 1
		*Q10.6. During that illness, was ${child_name} unusually tired or unconscious?
		*replace symptom_sleepy = 1 if df_q10_6 == 1
		*Q10.7. During that illness, did  have Coke (Coca-Cola) coloured urine? 
			replace symptom_darkurine = 1 if df_q10_7 == 1
			
	label variable symptom_fever7 "D28 danger sign: Fever for 7 days or more"
	label variable symptom_diarrhea14 "D28 danger sign: Diarrhea for 14 days or more"
	label variable symptom_bloody_diarrhea "D28 danger sign: Bloody diarrhea"
	label variable symptom_cough14 "D28 danger sign: Cough for 14 days or more"
	label variable symptom_breathing "D28 danger sign: Fast or difficulty breathing"
	label variable symptom_vomit "D28 danger sign: Vomiting everything"
	label variable symptom_convulsion "D28 danger sign: Convulsions"
	label variable symptom_sleepy "D28 danger sign: Unusually sleepy or unconscious"
	label variable symptom_nosit "D28 danger sign: Unable to sit or stand up"
	label variable symptom_nodrink "D28 danger sign: Not able to breastfeed, drink or eat anything"
	label variable symptom_swelling "D28 danger sign: Swelling of both feet"
	label variable symptom_darkurine "D28 danger sign: Coke (Coca-Cola) coloured urine"
	label variable symptom_whitepalms "D28 danger sign: White palms or sole"
	label variable symptom_yelloweyes "D28 danger sign: Yellow eyes"
	label values symptom_* yesno

}

	}
