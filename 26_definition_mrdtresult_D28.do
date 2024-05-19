********************************************************************************
*** CARAMAL DEFINITIONS: MRDT RESULT ON D28 *******************************
********************************************************************************

* Author:	TLEE
* Date:		22.04.2021

* Version control:
* 		- v1.0			TLEE		Defined delay to first provider for all countries

* Note: Use "J:\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.7. Health Outcomes\do-files\D28 mrdt result_TL\2021Apr14_D28_mrdt_analysis_TL.do" to test code below. 

*------------------------------------------------------------------------------*

capture confirm variable mrdt_result_binary
	if !_rc == 0 {
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset: 	D28

if ("$country" == "Nigeria") {
    
    g mrdt_result_binary = 1 if d28_q75 == 1
	replace mrdt_result_binary = 1 if d28_q75_2 == 11 | d28_q75_2 == 12 | d28_q75_2 == 13 
	replace mrdt_result_binary = 0 if d28_q75 == 0 | d28_q75_2 == 0
	label define mrdt 0 "Test negative" 1 "Test positive"
	label val mrdt_result_binary mrdt 
	label var mrdt_result_binary "Combined mrdt result from q79(75) & q79_2(75) as binary"

	g mrdt_result_newtest = d28_q75_2 
	replace mrdt_result_newtest = . if d28_q75_2 == -96
	label define mrdt_new 0 "Test negative" 11 "Non Pf: Test positive" 12 "Pf: Test positive" 13 "Pf or mixed inf.: Test positive"
	label val mrdt_result_newtest mrdt_new
	label var mrdt_result_newtest "mrdt result if combo test used in d28"

	g mrdt_brand = d28_q75a_rdt_br
	replace mrdt_brand = . if d28_q75a_rdt_br == -96
	replace mrdt_brand = 5 if (d28_version == "NG" | d28_version == "NG2" | d28_version == "NG_v5_3ph" | d28_version == "NIGERIA") & (d28_q75 == 0 | d28_q75 == 1)
	label define mrdt_brand 1 "SD Bioline Malaria Ag P.f" 2	"SD Bioline Malaria Ag P.f/Pan (new test)" 3 "CareStart Malaria HRP2 (Pf) (old test)" 4	"CareStart Malaria Pf/PAN (HRP2/pLDH) Ag Combo (new test)" 5 "HRP2 (Pf) (old test)"
	label val mrdt_brand mrdt_brand
	label var mrdt_brand "Brand of mRDT used in D28 (value 5 in old versions)"

	
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	D28

if ("$country" == "Uganda") {
    g mrdt_result_binary = 1 if d28_q79 == 1
	replace mrdt_result_binary = 1 if d28_q79_2 != 0 & d28_q79_2 != .
	replace mrdt_result_binary = 0 if d28_q79 == 0 | d28_q79_2 == 0
	label val mrdt_result_binary mrdt 
	label var mrdt_result_binary "Combined mrdt result from q79 & q79_2 as binary"

	g mrdt_result_newtest = 0 if d28_q79_2 == 0
	*Dorcus correct interpretation
	replace mrdt_result_newtest = 11 if d28_your_name == "AK_001" & (d28_q79_2 == 11 | d28_q79_2 == 21) 
	replace mrdt_result_newtest = 12 if d28_your_name == "AK_001" & (d28_q79_2 == 12 | d28_q79_2 == 22) 
	replace mrdt_result_newtest = 13 if d28_your_name == "AK_001" & (d28_q79_2 == 13 | d28_q79_2 == 23) 
	*all others
	replace mrdt_result_newtest = 12 if d28_your_name != "AK_001" & (d28_q79_2 == 11 | d28_q79_2 == 22)
	replace mrdt_result_newtest = 11 if d28_your_name != "AK_001" & (d28_q79_2 == 12 | d28_q79_2 == 21)
	replace mrdt_result_newtest = 13 if d28_your_name != "AK_001" & (d28_q79_2 == 13 | d28_q79_2 == 23)
	replace mrdt_result_newtest = . if mrdt_result_newtest != . & d28_todaynow > td(02oct2019) & d28_todaynow < td(17oct2019) // See J:\CARAMAL\8. Results\8.3. Analysis\8.3.0. Planning\Definitions for Analysis_ PSS_v3_2021.02.22.xlsx for explanation for why this time period was dropped/results options were changed.
	label define mrdt_new 0 "Test negative" 11 "Non Pf: Test positive" 12 "Pf: Test positive" 13 "Pf or mixed inf.: Test positive"
	label val mrdt_result_newtest mrdt_new
	label var mrdt_result_newtest "mrdt result if combo test used in d28"
   
	g mrdt_brand = d28_q79a_rdt_br
	replace mrdt_brand = 2 if d28_q79a_rdt_br == -96
	label define mrdt_brand 1 "SD Bioline Malaria Ag P.f" 2	"SD Bioline Malaria Ag P.f/Pan (new test)" 3 "CareStart Malaria HRP2 (Pf) (old test)" 4	"CareStart Malaria Pf/PAN (HRP2/pLDH) Ag Combo (new test)" 5 "HRP2 (Pf) (old test)"
	label val mrdt_brand mrdt_brand
	label var mrdt_brand "Brand of mRDT used in D28 (only Carestart HRP2 in old versions)"


}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	D28

if ("$country" == "DRC") {
    g mrdt_result_binary = 1 if d28_q79 == 1
	replace mrdt_result_binary = 1 if d28_q79_2 == 11 | d28_q79_2 == 12 | d28_q79_2 == 13
	replace mrdt_result_binary = 0 if d28_q79 == 0 | d28_q79_2 == 0
	*label define mrdt 0 "Test negative" 1 "Test positive"
	label val mrdt_result_binary mrdt 
	label var mrdt_result_binary "Combined mrdt result from q79 & q79_2 as binary"

	g mrdt_result_newtest = d28_q79_2 
	replace mrdt_result_newtest = . if d28_q79_2 == -99
	label define mrdt_new 0 "Test negative" 11 "Non Pf: Test positive" 12 "Pf: Test positive" 13 "Pf or mixed inf.: Test positive"
	label val mrdt_result_newtest mrdt_new
	label var mrdt_result_newtest "mrdt result if combo test used in d28"

	g mrdt_brand = d28_q79a_rdt_br
	replace mrdt_brand = . if d28_q79a_rdt_br == -99 | d28_q79a_rdt_br == -96
	replace mrdt_brand = 5 if d28_version == "24aug18" & (d28_q79 == 0 | d28_q79 == 1)
	label define mrdt_brand 1 "SD Bioline Malaria Ag P.f" 2	"SD Bioline Malaria Ag P.f/Pan (new test)" 3 "CareStart Malaria HRP2 (Pf) (old test)" 4	"CareStart Malaria Pf/PAN (HRP2/pLDH) Ag Combo (new test)" 5 "HRP2 (Pf) (old test)"
	label val mrdt_brand mrdt_brand
	label var mrdt_brand "Brand of mRDT used in D28 (value 5 in old versions)"

	
}

	}







