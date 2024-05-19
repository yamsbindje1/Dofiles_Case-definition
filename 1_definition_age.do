********************************************************************************
*** CARAMAL DEFINITIONS: AGE ***************************************************
********************************************************************************

* Author:	Yams
* Date:		20.01.2021

* Version control:
* 		- v1.0			Yams		Defined agegroup for all countries
*		- v1.1			Yams		Corrected code: -98 is not considered anymore	
* 		- v1.2			Yams		Added variable labels	

* Note: Use "\\Yams.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 

* Questions: 

*------------------------------------------------------------------------------*

capture confirm variable agegroup 
	if !_rc == 0 {
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	CCR

if ("$country" == "Nigeria") {
	* Generate age variable based on CCR - consolidation done by Akena
		gen age = ccr_child_age_y   // categorical
		egen agegroup = cut(age), at(0,1,2,3,4,5.2)			
		// include age = 5y 2 months to allow for age 5 at enrolment + delayed D28 f/u
		
		label variable age "Consolidated: Age (continuous)"
		label variable agegroup "Consolidated: Age (categorical)"
}

*------------------------------------------------------------------------------*		
		
*** UGANDA ***

* Required datasets:	D28, D28-DF, REF, D0, CCR

if ("$country" == "Uganda") {
	* Generate age variable based on D28 / D28-DF > REF > D0 > CCR
		gen age = (d28_todaynow-d28_d_b)/365.25   				// age from D28 	
		// (conversion of todaynow to numeric date format might be necessary)
		// (see 0_generate_testdata.do)
			replace age = d28_Age_years if age == . & d28_Age_years >= 0
		
			replace age = (df_todaynow-df_d_b)/365.25 if age == . 	// age from D28-DF 
			//(conversion of todaynow to numeric date format might be necessary)
			// (see 0_generate_testdata.do)
			replace age = df_Age_years if age == . & df_Age_year >= 0
		
			replace age = ref_age_years if age == . & ref_age_year >= 0  	
			// replace missing age with age from REF form
			replace age = d0_Age_years if age == . & d0_Age_years >= 0   	
			// replace missing age with D0 age information
			replace age = ccr_age if age == . & ccr_age >= 0  				
			// replace missing age with CCR age information
		
		egen agegroup = cut(age), at(0,1,2,3,4,5.2)			
		// include age = 5y 2 months to allow for age 5 at enrolment + delayed D28 f/u
		
		label variable age "Consolidated: Age (continuous)"
		label variable agegroup "Consolidated: Age (categorical)"
}
		
*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required datasets: 	D28, D28-DF, REF, D0, CCR

if ("$country" == "DRC") {
	* Generate age variable based on D28 / D28-DF > REF > D0 > CCR
		gen age = (d28_todaynow-d28_d_b)/365.25   				// age from D28
			replace age = d28_Age_years if age == . & d28_Age_years >= 0
		
			replace age = (df_todaynow-df_d_b)/365.25 if age == . 	// age from D28-DF
			replace age = df_Age_years if age == . & df_Age_years >= 0
		
			replace age = ref_age_years if age == . & ref_age_years >= 0    
			// replace missing age with age from REF form
			replace age = d0_Age_years if age == . & d0_Age_years >= 0  	
			// replace missing age with D0 age information
			replace age = ccr_age_years_clean if age == . & ccr_age_years_clean >= 0   			// replace missing age with CCR age information
		
		egen agegroup = cut(age), at(0,1,2,3,4,5.2)	
		// include age = 5y 2 months to allow for age 5 at enrolment + delayed D28 f/u
		
		label variable age "Consolidated: Age (continuous)"
		label variable agegroup "Consolidated: Age (categorical)"
}

	}
