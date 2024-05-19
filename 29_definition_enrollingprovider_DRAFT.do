********************************************************************************
*** CARAMAL DEFINITIONS: ENROLLING PROVIDER ***************
********************************************************************************

* Author:	TLEE GDEO
* Date:		21.06.2021

* Version control:

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 



*------------------------------------------------------------------------------*

if ("$country" == "Nigeria") {
	*Make all IDs 5 digits starting with "2" in NG 
	gen newid = cond(ccr_reporting_provider <100, "200" + string(ccr_reporting_provider), string(ccr_reporting_provider)) 
	replace newid= cond(length(newid) ==4, "2" + newid, newid)
	* Note: kept values of reporting_provider other than adding beginning "2"

	destring newid , gen(provider_id)
	labmask provider_id, values(ccr_reporting_provider) decode
	label var provider_id "Name of enrolling provider"
	
	*drop temporary variables created to generate provider_id
	drop newid 
}


if ("$country" == "Uganda") {
	g enrol_provider = ""
	replace enrol_provider = ccr_chw_name if enrol_location == 2 | enrol_location == 3
	replace enrol_provider = d28_parish if enrol_provider == ""
	replace enrol_provider = df_parish if enrol_provider == ""

	g sort_en_pr = enrol_provider
	replace sort_en_pr = "zy " + sort_en_pr if enrol_location == 2 
	replace sort_en_pr = "zz " + sort_en_pr if enrol_location == 3 

	*Generate a numeric variable from string enrol_provider: generates an id with n. from 1/176
	encode sort_en_pr, gen (en_pr)
	sort en_pr
	*Make all IDs 5 digits starting with "3" in UG
	gen newid = cond(en_pr <10, "3100" + string(en_pr), string(en_pr)) 
	replace newid= cond(length(newid) ==2, "310" + newid, newid)
	replace newid= cond(length(newid) ==3, "31" + newid, newid)
	
	*label by enrolment location
	replace newid = subinstr(newid, "31", "33", .) if enrol_location == 3
	replace newid = subinstr(newid, "31", "32", .) if enrol_location == 2
	
	destring newid , gen(provider_id)
	labmask provider_id, values(enrol_provider)
	label var provider_id "Name of enrolling provider: HF(PHC/RHF) or parish(CHW)"
	
	*drop temporary variables created to generate provider_id
	drop newid en_pr sort_en_pr enrol_provider
}

********************************************************************************

if ("$country" == "DRC") {
    
*Test data DRC
use "J:\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.1. DRC\final datasets\_archive final dataset June 2021\PSS final format\DRC_PSS_GD", clear

	gen enrol_provider = ccr_enrolling_facilityname
	drop if merge_ref==2
	
	*Generate a numeric variable from string enrol_provider: generates an id with n. from 1/166
	encode enrol_provider, gen (en_pr)
	sort en_pr
	*Make all IDs 4 digits starting with "1" in DRC
	gen newid =cond(en_pr <10, "120" + string(en_pr), string(en_pr)) 
	replace newid= cond(length(newid) ==2, "10" + newid, newid)
	replace newid= cond(length(newid) ==3, "1" + newid, newid)
	destring newid , gen(provider_id)
	labmask provider_id, values(enrol_provider)
	
	*drop temporary variables created to generate provider_id
	drop newid en_pr
	
********************************************************************************
	*Other method for creating id (not reproducible)
	*Random Number generation: generates an id with random numbers: not reproducible?
	*set seed 1234
	label var enrol_provider "Name of enrolling provider"
	gen rand_num = runiform()
	egen ordering = rank(rand_num)
	bysort enrol_prov: gen provider_id=ordering[1]

	labmask provider_id, values(enrol_provider)

	tab provider_id
	tab provider_id, nol

}