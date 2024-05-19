********************************************************************************
*** CARAMAL DEFINITIONS: INJECTABLE ANTIMALARIALS AND ACTS - D28(-DF) **********
********************************************************************************

* Author:	GDEO, NBNR
* Date:		09.03.2021

* Version control:
* 		- v1.0			GDEO		Defined D28(-DF) AM treatment for DRC
*		- v1.1			NBNR		Reviewed definitions and added UG and NG
*		- v1.2			NBNR		Activated NG after adding version variable
*		- v1.3			NBNR		NG: Changed version variable to Akena version variable

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

capture confirm variable anyAS_anyprovider
if !_rc == 0 {

*** NIGERIA ***

* Required dataset: 	D28, D28-DF

if ("$country" == "Nigeria") {
	// Antimalarial treatment by any provider - variables present in all versions
	* D28
	forval i = 1/5 {
			tempvar d28_as`i' d28_artem`i' d28_quin`i' d28_alu`i' d28_asaq`i'
			gen `d28_as`i'' = .
			gen `d28_artem`i'' = .
			gen `d28_quin`i'' = .
			gen `d28_alu`i'' = .
			gen `d28_asaq`i'' = .
			cap noisily replace `d28_as`i'' = cond(d28_q31_10_`i'==1, 1, 0)
			cap noisily replace `d28_artem`i'' = cond(d28_q31_11_`i'==1, 1, 0)
			cap noisily replace `d28_quin`i'' = cond(d28_q31_14_`i'==1, 1, 0)
			cap noisily replace `d28_alu`i'' = cond(d28_q31_8_`i'==1, 1, 0)
			cap noisily replace `d28_asaq`i'' = cond(d28_q31_12_`i'==1, 1, 0)
			local aslist `aslist' `d28_as`i''
			local artemlist `artemlist' `d28_artem`i''
			local quinlist `quinlist' `d28_quin`i''
			local alulist `alulist' `d28_alu`i''
			local asaqlist `asaqlist' `d28_asaq`i''
	}	
	* D28-DF
	forval i = 1/6 {	
			tempvar df_as`i' df_artem`i' df_quin`i' df_alu`i' df_asaq`i'
			gen `df_as`i'' = .
			gen `df_artem`i'' = .
			gen `df_quin`i'' = .
			gen `df_alu`i'' = .
			gen `df_asaq`i'' = .
			cap noisily replace `df_as`i'' = cond(df_q31_10_`i'==1, 1, 0)
			cap noisily replace `df_artem`i'' = cond(df_q31_11_`i'==1, 1, 0)
			cap noisily replace `df_quin`i'' = cond(df_q31_14_`i'==1, 1, 0)
			cap noisily replace `df_alu`i'' = cond(df_q31_8_`i'==1, 1, 0)
			cap noisily replace `df_asaq`i'' = cond(df_q31_12_`i'==1, 1, 0)
			local aslist `aslist' `df_as`i''
			local artemlist `artemlist' `df_artem`i''
			local quinlist `quinlist' `df_quin`i''
			local alulist `alulist' `df_alu`i''
			local asaqlist `asaqlist' `df_asaq`i''
	} 
	
		// No medicine was given or caregiver does not remember the name of the drugs
			* Treatment variables are set to missing if caregiver does not remember 
			*	the name of the drug and no other provider administered an AM drug. 
		tempvar mednum knownum
		egen `mednum' = anycount(d28_q29_* df_q29_*), values(1)
		egen `knownum' = anycount(d28_q30_* df_q30_*), values(1)
		label variable `mednum' "Child received medicine from x providers"
		label variable `knownum' "Caregiver remembers name of drugs from x providers"
		tab `mednum' `knownum', col
		
	* Minimum of one dose per drug from any provider
	egen anyAS_anyprovider = anymatch(`aslist'), values(1)				// Artesunate
		replace anyAS_anyprovider = . if `mednum' != `knownum' & anyAS_anyprovider == 0
		replace anyAS_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyArt_anyprovider = anymatch(`artemlist'), values(1)			// Artemether
		replace anyArt_anyprovider = . if `mednum' != `knownum' & anyArt_anyprovider == 0
		replace anyArt_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyQ_anyprovider = anymatch(`quinlist'), values(1)				// Quinine
		replace anyQ_anyprovider = . if `mednum' != `knownum' & anyQ_anyprovider == 0
		replace anyQ_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyALU_anyprovider = anymatch(`alulist'), values(1)			// ALu
		replace anyALU_anyprovider = . if `mednum' != `knownum' & anyALU_anyprovider == 0
		replace anyALU_anyprovider = . if d28_KEY == "" & df_KEY == ""	
	egen anyASAQ_anyprovider = anymatch(`asaqlist'), values(1)			// ASAQ
		replace anyASAQ_anyprovider = . if `mednum' != `knownum' & anyASAQ_anyprovider == 0
		replace anyASAQ_anyprovider = . if d28_KEY == "" & df_KEY == ""
		
	// Antimalarials shown on pictures
	* D28
		forval i = 1/5 {
			tempvar d28_aspic`i' d28_artempic`i' d28_quinpic`i' 		///
					d28_alupic`i' d28_asaqpic`i'	
			gen `d28_aspic`i'' = .
			gen `d28_artempic`i'' = .
			gen `d28_quinpic`i'' = .
			gen `d28_alupic`i'' = .
			gen `d28_asaqpic`i'' = .
			cap noisily replace `d28_aspic`i'' = cond(d28_q31d_1_`i'==1, 1, 0)
			cap noisily replace `d28_artempic`i'' = cond(d28_q31d_2_`i'==1, 1, 0)
			cap noisily replace `d28_quinpic`i'' = cond(d28_q31d_3_`i'==1, 1, 0)
			cap noisily replace `d28_alupic`i'' = cond(d28_q31a_1_`i'==1, 1, 0)
			cap noisily replace `d28_asaqpic`i'' = cond(d28_q31a_2_`i'==1, 1, 0)
			local aspiclist `aspiclist' `d28_aspic`i''
			local artempiclist `artempiclist' `d28_artempic`i''
			local quinpiclist `quinpiclist' `d28_quinpic`i''
			local alupiclist `alupiclist' `d28_alupic`i''
			local asaqpiclist `asaqpiclist' `d28_asaqpic`i''
		}
	* D28-DF
		forval i = 1/6 {
			tempvar df_aspic`i' df_artempic`i' df_quinpic`i' 		///
					df_alupic`i' df_asaqpic`i'	
			gen `df_aspic`i'' = .
			gen `df_artempic`i'' = .
			gen `df_quinpic`i'' = .
			gen `df_alupic`i'' = .
			gen `df_asaqpic`i'' = .
			cap noisily replace `df_aspic`i'' = cond(df_q31d_1_`i'==1, 1, 0)
			cap noisily replace `df_artempic`i'' = cond(df_q31d_2_`i'==1, 1, 0)
			cap noisily replace `df_quinpic`i'' = cond(df_q31d_3_`i'==1, 1, 0)
			cap noisily replace `df_alupic`i'' = cond(df_q31a_1_`i'==1, 1, 0)
			cap noisily replace `df_asaqpic`i'' = cond(df_q31a_2_`i'==1, 1, 0)
			local aspiclist `aspiclist' `df_aspic`i''
			local artempiclist `artempiclist' `df_artempic`i''
			local quinpiclist `quinpiclist' `df_quinpic`i''
			local alupiclist `alupiclist' `df_alupic`i''
			local asaqpiclist `asaqpiclist' `df_asaqpic`i''
		}

	egen anyAS_pic = anymatch(`aspiclist'), values(1)				
	egen anyArt_pic = anymatch(`artempiclist'), values(1)
	egen anyQ_pic = anymatch(`quinpiclist'), values(1)
	egen anyALU_pic = anymatch(`alupiclist'), values(1)
	egen anyASAQ_pic = anymatch(`asaqpiclist'), values(1)		
	
* Replace to missing if D28(-DF) is not the correct version 	
	foreach var in anyAS_pic anyArt_pic anyQ_pic anyALU_pic anyASAQ_pic {
		replace `var '= . if !(df_version == "NG_v2_2" | df_version == "NG_v2_2a" | d28_version == "NG_v5_2" | d28_version == "NG_v5_3ph")
	}
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required datasets:	D28, D28-DF

if ("$country" == "Uganda") {
	// Antimalarial treatment by any provider - variables present in all versions
	* D28
	forval i = 1/6 {
			tempvar d28_as`i' d28_artem`i' d28_quin`i' d28_alu`i' d28_asaq`i'
			gen `d28_as`i'' = .
			gen `d28_artem`i'' = .
			gen `d28_quin`i'' = .
			gen `d28_alu`i'' = .
			gen `d28_asaq`i'' = .
			cap noisily replace `d28_as`i'' = cond(d28_q31_10_`i'==1, 1, 0)
			cap noisily replace `d28_artem`i'' = cond(d28_q31_11_`i'==1, 1, 0)
			cap noisily replace `d28_quin`i'' = cond(d28_q31_14_`i'==1, 1, 0)
			cap noisily replace `d28_alu`i'' = cond(d28_q31_8_`i'==1, 1, 0)
			cap noisily replace `d28_asaq`i'' = cond(d28_q31_12_`i'==1, 1, 0)
			local aslist `aslist' `d28_as`i''
			local artemlist `artemlist' `d28_artem`i''
			local quinlist `quinlist' `d28_quin`i''
			local alulist `alulist' `d28_alu`i''
			local asaqlist `asaqlist' `d28_asaq`i''
	}	
	* D28-DF
	forval i = 1/8 {	
			tempvar df_as`i' df_artem`i' df_quin`i' df_alu`i' df_asaq`i'
			gen `df_as`i'' = .
			gen `df_artem`i'' = .
			gen `df_quin`i'' = .
			gen `df_alu`i'' = .
			gen `df_asaq`i'' = .
			cap noisily replace `df_as`i'' = cond(df_q31_10_`i'==1, 1, 0)
			cap noisily replace `df_artem`i'' = cond(df_q31_11_`i'==1, 1, 0)
			cap noisily replace `df_quin`i'' = cond(df_q31_14_`i'==1, 1, 0)
			cap noisily replace `df_alu`i'' = cond(df_q31_8_`i'==1, 1, 0)
			cap noisily replace `df_asaq`i'' = cond(df_q31_12_`i'==1, 1, 0)
			local aslist `aslist' `df_as`i''
			local artemlist `artemlist' `df_artem`i''
			local quinlist `quinlist' `df_quin`i''
			local alulist `alulist' `df_alu`i''
			local asaqlist `asaqlist' `df_asaq`i''
	} 
	
		// No medicine was given or caregiver does not remember the name of the drugs
			* Treatment variables are set to missing if caregiver does not remember 
			*	the name of the drug and no other provider administered an AM drug. 
		tempvar mednum knownum
		egen `mednum' = anycount(d28_q29_* df_q29_*), values(1)
		egen `knownum' = anycount(d28_q30_* df_q30_*), values(1)
		label variable `mednum' "Child received medicine from x providers"
		label variable `knownum' "Caregiver remembers name of drugs from x providers"
		tab `mednum' `knownum', col
		
	* Minimum of one dose per drug from any provider
	egen anyAS_anyprovider = anymatch(`aslist'), values(1)				// Artesunate
		replace anyAS_anyprovider = . if `mednum' != `knownum' & anyAS_anyprovider == 0
		replace anyAS_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyArt_anyprovider = anymatch(`artemlist'), values(1)			// Artemether
		replace anyArt_anyprovider = . if `mednum' != `knownum' & anyArt_anyprovider == 0
		replace anyArt_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyQ_anyprovider = anymatch(`quinlist'), values(1)				// Quinine
		replace anyQ_anyprovider = . if `mednum' != `knownum' & anyQ_anyprovider == 0
		replace anyQ_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyALU_anyprovider = anymatch(`alulist'), values(1)			// ALu
		replace anyALU_anyprovider = . if `mednum' != `knownum' & anyALU_anyprovider == 0
		replace anyALU_anyprovider = . if d28_KEY == "" & df_KEY == ""	
	egen anyASAQ_anyprovider = anymatch(`asaqlist'), values(1)			// ASAQ
		replace anyASAQ_anyprovider = . if `mednum' != `knownum' & anyASAQ_anyprovider == 0
		replace anyASAQ_anyprovider = . if d28_KEY == "" & df_KEY == ""
		
	// Antimalarials shown on pictures
	* D28
		forval i = 1/7 {
			tempvar d28_aspic`i' d28_artempic`i' d28_quinpic`i' 		///
					d28_alupic`i' d28_asaqpic`i'	
			gen `d28_aspic`i'' = .
			gen `d28_artempic`i'' = .
			gen `d28_quinpic`i'' = .
			gen `d28_alupic`i'' = .
			gen `d28_asaqpic`i'' = .
			cap noisily replace `d28_aspic`i'' = cond(d28_q31d_1_`i'==1, 1, 0)
			cap noisily replace `d28_artempic`i'' = cond(d28_q31d_2_`i'==1, 1, 0)
			cap noisily replace `d28_quinpic`i'' = cond(d28_q31d_3_`i'==1, 1, 0)
			cap noisily replace `d28_alupic`i'' = cond(d28_q31a_1_`i'==1, 1, 0)
			cap noisily replace `d28_asaqpic`i'' = cond(d28_q31a_2_`i'==1, 1, 0)
			local aspiclist `aspiclist' `d28_aspic`i''
			local artempiclist `artempiclist' `d28_artempic`i''
			local quinpiclist `quinpiclist' `d28_quinpic`i''
			local alupiclist `alupiclist' `d28_alupic`i''
			local asaqpiclist `asaqpiclist' `d28_asaqpic`i''
		}
	* D28-DF
		forval i = 1/5 {
			tempvar df_aspic`i' df_artempic`i' df_quinpic`i' 		///
					df_alupic`i' df_asaqpic`i'	
			gen `df_aspic`i'' = .
			gen `df_artempic`i'' = .
			gen `df_quinpic`i'' = .
			gen `df_alupic`i'' = .
			gen `df_asaqpic`i'' = .
			cap noisily replace `df_aspic`i'' = cond(df_q31d_1_`i'==1, 1, 0)
			cap noisily replace `df_artempic`i'' = cond(df_q31d_2_`i'==1, 1, 0)
			cap noisily replace `df_quinpic`i'' = cond(df_q31d_3_`i'==1, 1, 0)
			cap noisily replace `df_alupic`i'' = cond(df_q31a_1_`i'==1, 1, 0)
			cap noisily replace `df_asaqpic`i'' = cond(df_q31a_2_`i'==1, 1, 0)
			local aspiclist `aspiclist' `df_aspic`i''
			local artempiclist `artempiclist' `df_artempic`i''
			local quinpiclist `quinpiclist' `df_quinpic`i''
			local alupiclist `alupiclist' `df_alupic`i''
			local asaqpiclist `asaqpiclist' `df_asaqpic`i''
		}

	egen anyAS_pic = anymatch(`aspiclist'), values(1)				
	egen anyArt_pic = anymatch(`artempiclist'), values(1)
	egen anyQ_pic = anymatch(`quinpiclist'), values(1)
	egen anyALU_pic = anymatch(`alupiclist'), values(1)
	egen anyASAQ_pic = anymatch(`asaqpiclist'), values(1)		
	
* Replace to missing if D28(-DF) is not the correct version 	
	foreach var in anyAS_pic anyArt_pic anyQ_pic anyALU_pic anyASAQ_pic {
		replace `var '= . if !(df_version == "PSS D28_DF Uganda_v2_2" | d28_version == "PSS D28 Uganda_v5_2")
}

}

*------------------------------------------------------------------------------*		
*** DRC ***

* Required datasets: 	D28, D28-DF

if ("$country" == "DRC") 

{
	// Antimalarial treatment by any provider - variables present in all versions
	* D28
	forval i = 1/7 {
			tempvar d28_as`i' d28_artem`i' d28_quin`i' d28_alu`i' d28_asaq`i'
			gen `d28_as`i'' = .
			gen `d28_artem`i'' = .
			gen `d28_quin`i'' = .
			gen `d28_alu`i'' = .
			gen `d28_asaq`i'' = .
			cap noisily replace `d28_as`i'' = cond(d28_q31_10_`i'==1, 1, 0)
			cap noisily replace `d28_artem`i'' = cond(d28_q31_11_`i'==1, 1, 0)
			cap noisily replace `d28_quin`i'' = cond(d28_q31_14_`i'==1, 1, 0)
			cap noisily replace `d28_alu`i'' = cond(d28_q31_8_`i'==1, 1, 0)
			cap noisily replace `d28_asaq`i'' = cond(d28_q31_12_`i'==1, 1, 0)
			local aslist `aslist' `d28_as`i''
			local artemlist `artemlist' `d28_artem`i''
			local quinlist `quinlist' `d28_quin`i''
			local alulist `alulist' `d28_alu`i''
			local asaqlist `asaqlist' `d28_asaq`i''
	}	
	* D28-DF
	forval i = 1/5 {	
			tempvar df_as`i' df_artem`i' df_quin`i' df_alu`i' df_asaq`i'
			gen `df_as`i'' = .
			gen `df_artem`i'' = .
			gen `df_quin`i'' = .
			gen `df_alu`i'' = .
			gen `df_asaq`i'' = .
			cap noisily replace `df_as`i'' = cond(df_q31_10_`i'==1, 1, 0)
			cap noisily replace `df_artem`i'' = cond(df_q31_11_`i'==1, 1, 0)
			cap noisily replace `df_quin`i'' = cond(df_q31_14_`i'==1, 1, 0)
			cap noisily replace `df_alu`i'' = cond(df_q31_8_`i'==1, 1, 0)
			cap noisily replace `df_asaq`i'' = cond(df_q31_12_`i'==1, 1, 0)
			local aslist `aslist' `df_as`i''
			local artemlist `artemlist' `df_artem`i''
			local quinlist `quinlist' `df_quin`i''
			local alulist `alulist' `df_alu`i''
			local asaqlist `asaqlist' `df_asaq`i''
	} 
	
		// No medicine was given or caregiver does not remember the name of the drugs
			* Treatment variables are set to missing if caregiver does not remember 
			*	the name of the drug and no other provider administered an AM drug. 
		tempvar mednum knownum
		egen `mednum' = anycount(d28_q29_* df_q29_*), values(1)
		egen `knownum' = anycount(d28_q30_* df_q30_*), values(1)
		label variable `mednum' "Child received medicine from x providers"
		label variable `knownum' "Caregiver remembers name of drugs from x providers"
		*tab `mednum' `knownum', col
		
	* Minimum of one dose per drug from any provider
	egen anyAS_anyprovider = anymatch(`aslist'), values(1)				// Artesunate
		replace anyAS_anyprovider = . if `mednum' != `knownum' & anyAS_anyprovider == 0
		replace anyAS_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyArt_anyprovider = anymatch(`artemlist'), values(1)			// Artemether
		replace anyArt_anyprovider = . if `mednum' != `knownum' & anyArt_anyprovider == 0
		replace anyArt_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyQ_anyprovider = anymatch(`quinlist'), values(1)				// Quinine
		replace anyQ_anyprovider = . if `mednum' != `knownum' & anyQ_anyprovider == 0
		replace anyQ_anyprovider = . if d28_KEY == "" & df_KEY == ""
	egen anyALU_anyprovider = anymatch(`alulist'), values(1)			// ALu
		replace anyALU_anyprovider = . if `mednum' != `knownum' & anyALU_anyprovider == 0
		replace anyALU_anyprovider = . if d28_KEY == "" & df_KEY == ""	
	egen anyASAQ_anyprovider = anymatch(`asaqlist'), values(1)			// ASAQ
		replace anyASAQ_anyprovider = . if `mednum' != `knownum' & anyASAQ_anyprovider == 0
		replace anyASAQ_anyprovider = . if d28_KEY == "" & df_KEY == ""
		
	// Antimalarials shown on pictures
	* D28
		forval i = 1/7 {
			tempvar d28_aspic`i' d28_artempic`i' d28_quinpic`i' 		///
					d28_alupic`i' d28_asaqpic`i'	
			gen `d28_aspic`i'' = .
			gen `d28_artempic`i'' = .
			gen `d28_quinpic`i'' = .
			gen `d28_alupic`i'' = .
			gen `d28_asaqpic`i'' = .
			cap noisily replace `d28_aspic`i'' = cond(d28_q31d_1_`i'==1, 1, 0)
			cap noisily replace `d28_artempic`i'' = cond(d28_q31d_2_`i'==1, 1, 0)
			cap noisily replace `d28_quinpic`i'' = cond(d28_q31d_3_`i'==1, 1, 0)
			cap noisily replace `d28_alupic`i'' = cond(d28_q31a_1_`i'==1, 1, 0)
			cap noisily replace `d28_asaqpic`i'' = cond(d28_q31a_2_`i'==1, 1, 0)
			local aspiclist `aspiclist' `d28_aspic`i''
			local artempiclist `artempiclist' `d28_artempic`i''
			local quinpiclist `quinpiclist' `d28_quinpic`i''
			local alupiclist `alupiclist' `d28_alupic`i''
			local asaqpiclist `asaqpiclist' `d28_asaqpic`i''
		}
	* D28-DF
		forval i = 1/5 {
			tempvar df_aspic`i' df_artempic`i' df_quinpic`i' 		///
					df_alupic`i' df_asaqpic`i'	
			gen `df_aspic`i'' = .
			gen `df_artempic`i'' = .
			gen `df_quinpic`i'' = .
			gen `df_alupic`i'' = .
			gen `df_asaqpic`i'' = .
			cap noisily replace `df_aspic`i'' = cond(df_q31d_1_`i'==1, 1, 0)
			cap noisily replace `df_artempic`i'' = cond(df_q31d_2_`i'==1, 1, 0)
			cap noisily replace `df_quinpic`i'' = cond(df_q31d_3_`i'==1, 1, 0)
			cap noisily replace `df_alupic`i'' = cond(df_q31a_1_`i'==1, 1, 0)
			cap noisily replace `df_asaqpic`i'' = cond(df_q31a_2_`i'==1, 1, 0)
			local aspiclist `aspiclist' `df_aspic`i''
			local artempiclist `artempiclist' `df_artempic`i''
			local quinpiclist `quinpiclist' `df_quinpic`i''
			local alupiclist `alupiclist' `df_alupic`i''
			local asaqpiclist `asaqpiclist' `df_asaqpic`i''
		}

	egen anyAS_pic = anymatch(`aspiclist'), values(1)				
	egen anyArt_pic = anymatch(`artempiclist'), values(1)
	egen anyQ_pic = anymatch(`quinpiclist'), values(1)
	egen anyALU_pic = anymatch(`alupiclist'), values(1)
	egen anyASAQ_pic = anymatch(`asaqpiclist'), values(1)		
	
* Replace to missing if D28(-DF) is not the correct version 	
	foreach var in anyAS_pic anyArt_pic anyQ_pic anyALU_pic anyASAQ_pic {
		replace `var '= . if !(df_version == "v2_2" | d28_version == "v5_2")
	}
}	


