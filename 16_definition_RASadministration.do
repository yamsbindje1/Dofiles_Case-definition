********************************************************************************
*** CARAMAL DEFINITIONS: RAS ADMINISTRATION ************************************
********************************************************************************

* Author:	NBNR
* Date:		27.01.2021

* Version control:
* 		- v1.0			NBNR		Consolidate RAS administration for all countries
*		- v1.1			NBNR		UG+DRC - D0: If CHW register was not filled oral 
*									confirmation of CHW is sufficient. 
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

*------------------------------------------------------------------------------*

capture confirm anyras
	if !_rc == 0 {
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset:		D0, REF, D28, D28-DF

if ("$country" == "Nigeria") {
	
	** RAS BY ANY DATA SOURCE **
	gen anyras = 0
		* D0
		replace anyras = 1 if d0_ras_given == 1
		* REF 
		replace anyras = 1 if ref_ras_week == 1
		* D28
		tempvar d28_ras
		egen `d28_ras' = anymatch(d28_q32_*), val(1)
		replace anyras = 1 if `d28_ras' == 1
		* D28-DF
		tempvar df_ras
		egen `df_ras' = anymatch(df_q32_*), val(1)
		replace anyras = 1 if `df_ras' == 1
		
		label variable anyras "RAS administration: any data source"
		label define yesno 0 "No" 1 "Yes", replace
		label values anyras yesno
		
	** RAS BY D28(-DF) **
	gen ras_d28 = 0
		* D28
		tempvar d28_ras
		egen `d28_ras' = anymatch(d28_q32_*), val(1)
		replace ras_d28 = 1 if `d28_ras' == 1
		* D28-DF
		tempvar df_ras
		egen `df_ras' = anymatch(df_q32_*), val(1)
		replace ras_d28 = 1 if `df_ras' == 1
		
		label variable ras_d28 "RAS administration: D28(-DF)"
		label values ras_d28 yesno
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	D0, REF, D28, D28-DF

if ("$country" == "Uganda") {

	** RAS BY ANY DATA SOURCE **
	gen anyras = 0
		* D0
		replace anyras = 1 if d0_reg_ras == 1
		replace anyras = 1 if d0_vht_ras == 1 & d0_reg_ras == -99
		* REF 
		replace anyras = 1 if ref_ras_week == 1
		* D28
		tempvar d28_ras
		egen `d28_ras' = anymatch(d28_q32_*), val(1)
		replace anyras = 1 if `d28_ras' == 1
		* D28-DF
		tempvar df_ras
		egen `df_ras' = anymatch(df_q32_*), val(1)
		replace anyras = 1 if `df_ras' == 1
		
		label variable anyras "RAS administration: any data source"
		label define yesno 0 "No" 1 "Yes", replace
		label values anyras yesno
		
	** RAS BY D28(-DF) **
	gen ras_d28 = 0
		* D28
		tempvar d28_ras
		egen `d28_ras' = anymatch(d28_q32_*), val(1)
		replace ras_d28 = 1 if `d28_ras' == 1
		* D28-DF
		tempvar df_ras
		egen `df_ras' = anymatch(df_q32_*), val(1)
		replace ras_d28 = 1 if `df_ras' == 1
		
		label variable ras_d28 "RAS administration: D28(-DF)"
		label values ras_d28 yesno

}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	D0, REF, D28, D28-DF

if ("$country" == "DRC") {

	** RAS BY ANY DATA SOURCE **
	gen anyras = 0
		* D0
		replace anyras = 1 if d0_reg_ras == 1
		replace anyras = 1 if d0_vht_ras == 1 & d0_reg_ras == -99
		* REF 
		replace anyras = 1 if ref_ras_week == 1
		* D28
		tempvar d28_ras
		egen `d28_ras' = anymatch(d28_q32_*), val(1)
		replace anyras = 1 if `d28_ras' == 1
		* D28-DF
		tempvar df_ras
		egen `df_ras' = anymatch(df_q32_*), val(1)
		replace anyras = 1 if `df_ras' == 1
		
		label variable anyras "RAS administration: any data source"
		label define yesno 0 "No" 1 "Yes", replace
		label values anyras yesno
		
	** RAS BY D28(-DF) **
	gen ras_d28 = 0
		* D28
		tempvar d28_ras
		egen `d28_ras' = anymatch(d28_q32_*), val(1)
		replace ras_d28 = 1 if `d28_ras' == 1
		* D28-DF
		tempvar df_ras
		egen `df_ras' = anymatch(df_q32_*), val(1)
		replace ras_d28 = 1 if `df_ras' == 1
		
		label variable ras_d28 "RAS administration: D28(-DF)"
		label values ras_d28 yesno

}

	}
