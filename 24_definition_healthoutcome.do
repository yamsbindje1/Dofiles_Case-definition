********************************************************************************
*** CARAMAL DEFINITIONS: HEALTH OUTCOME ****************************************
********************************************************************************

* Author:	MAH
* Date:		26.03.2021

* Version control:
* 		- v1.0			MAH			Consolidated day 28 f/u health status
*									 beginning of the do-file. Deleted from country code.
*		- *please enter changes here

* Note: Use "\\KISUNDI.swisstph.ch\EPH\CARAMAL\8. Results\8.3. Analysis\8.3.1. PSS\8.3.1.0 Definitions\do-files\0_generate_testdata.do" to test code below. 


*------------------------------------------------------------------------------*

capture confirm variable healthoutcome 
	if !_rc == 0 {
	    
*------------------------------------------------------------------------------*

*** NIGERIA ***

* Required dataset:	CCR, D28, D28-DF

if ("$country" == "Nigeria") {

** FINAL HEALTH STATUS ON FOLLOW-UP DAY **
*	- D28 health status (q1)
*	- Consolidated information on death (ccr_final_outcome == 0 or 3)

	// Generate variable for health status 0=healthy, 1=sick, 2=dead
	gen healthstatus = ccr_d28_status-1
		replace healthstatus = . if healthstatus == 3	// no consent
		label variable healthstatus "Health status at follow-up"
		label define healthstatus 0 "Healthy" 1 "Sick" 2 "Dead", replace
		label values healthstatus healthstatus

	// Generate variable for dead: 0=no, 1=yes
	gen dead = .
		replace dead = 0 if healthstatus == 0 | healthstatus == 1 	// healthy or sick
		replace dead = 1 if healthstatus == 2 						// dead
		label variable dead "Dead at follow-up"
		label define dead 0 "Alive" 1 "Dead" , replace
		label values dead dead

	// Generate variable for time between enrolment and death
	gen days_death=deathdate-enrolmentdate
	replace days_death = . if days_death <0
	label var days_death "Days after enrolment when child died"
		recode days_death (0=0)(1/3=1)(4/7=2)(8/14=3)(15/28=4)(29/34=5) (35/500=6), gen(days_death_cat)
		replace days_death_cat = . if days_death <0		// deaths earlier than enrolment date
			label var days_death_cat "category: days after enrolment the child died"
			label define days_death_cat 0 "On day of enrolment" 1 "Within 3 days" 2 "Within 7 days" 3 "Within 14 days" 4 "Within 28 days" 5 "Within 34 days" 6 "35+ days / invalid"
			label values days_death_cat days_death_cat
		
	// Generate variable for dead: 0=no, 1=yes
	gen dead_31 = .
		replace dead_31 = 0 if healthstatus == 0 | healthstatus == 1 	// healthy or sick
		replace dead_31 = 1 if healthstatus == 2 						// dead
		replace dead_31 = 0 if healthstatus == 2 & days_death > 31 & days_death != .
		label variable dead "Dead within 31 days"
		label values dead_31 dead
	
}

*------------------------------------------------------------------------------*
		
*** UGANDA ***

* Required dataset: 	CCR, D28, D28-DF

if ("$country" == "Uganda") {
	
** FINAL HEALTH STATUS ON FOLLOW-UP DAY **
*	- D28 health status (q1)
*	- Consolidated information on death (ccr_final_outcome == 0 or 3)

	// Generate variable for health status 0=healthy, 1=sick, 2=dead
	gen healthstatus = d28_q1-1
		replace healthstatus = 2 if ccr_death == 1	// dead
		label variable healthstatus "Health status at follow-up"
		label define healthstatus 0 "Healthy" 1 "Sick" 2 "Dead", replace
		label values healthstatus healthstatus

	// Generate variable for dead: 0=no, 1=yes
	gen dead = .
		replace dead = 0 if healthstatus == 0 | healthstatus == 1 	// healthy or sick
		replace dead = 1 if healthstatus == 2 						// dead
		label variable dead "Dead at follow-up"
		label define dead 0 "Alive" 1 "Dead" , replace
		label values dead dead

	// Generate variable for time between enrolment and death
	gen days_death=deathdate-enrolmentdate
	replace days_death = . if days_death <0
	label var days_death "Days after enrolment when child died"
		recode days_death (0=0)(1/3=1)(4/7=2)(8/14=3)(15/28=4)(29/34=5) (35/500=6), gen(days_death_cat)
		replace days_death_cat = . if days_death <0		// deaths earlier than enrolment date
			label var days_death_cat "category: days after enrolment the child died"
			label define days_death_cat 0 "On day of enrolment" 1 "Within 3 days" 2 "Within 7 days" 3 "Within 14 days" 4 "Within 28 days" 5 "Within 34 days" 6 "35+ days / invalid"
			label values days_death_cat days_death_cat
		
	// Generate variable for dead: 0=no, 1=yes
	gen dead_31 = .
		replace dead_31 = 0 if healthstatus == 0 | healthstatus == 1 	// healthy or sick
		replace dead_31 = 1 if healthstatus == 2 						// dead
		replace dead_31 = 0 if healthstatus == 2 & days_death > 31 & days_death != .
		label variable dead "Dead within 31 days"
		label values dead_31 dead

}

*------------------------------------------------------------------------------*
	
*** DRC *** 

* Required dataset: 	CCR, D28, D28-DF

if ("$country" == "DRC") {
	
** FINAL HEALTH STATUS ON FOLLOW-UP DAY **
*	- D28 health status (q1)
*	- Consolidated information on death (ccr_final_outcome == 0 or 3)

	// Generate variable for health status 0=healthy, 1=sick, 2=dead
	gen healthstatus = d28_q1-1
		replace healthstatus = 2 if ccr_final_outcome == 0	// dead
		replace healthstatus = 2 if ccr_final_outcome == 3	// dead, no DF
		label variable healthstatus "Health status at follow-up"
		label define healthstatus 0 "Healthy" 1 "Sick" 2 "Dead", replace
		label values healthstatus healthstatus

	// Generate variable for dead: 0=no, 1=yes
	gen dead = .
		replace dead = 0 if healthstatus == 0 | healthstatus == 1 	// healthy or sick
		replace dead = 1 if healthstatus == 2 						// dead
		label variable dead "Dead at follow-up"
		label define dead 0 "Alive" 1 "Dead" , replace
		label values dead dead

	// Generate variable for time between enrolment and death
	gen days_death=deathdate-enrolmentdate
	replace days_death = . if days_death <0
	label var days_death "Days after enrolment when child died"
		recode days_death (0=0)(1/3=1)(4/7=2)(8/14=3)(15/28=4)(29/34=5) (35/500=6), gen(days_death_cat)
		replace days_death_cat = . if days_death <0		// deaths earlier than enrolment date
			label var days_death_cat "category: days after enrolment the child died"
			label define days_death_cat 0 "On day of enrolment" 1 "Within 3 days" 2 "Within 7 days" 3 "Within 14 days" 4 "Within 28 days" 5 "Within 34 days" 6 "35+ days / invalid"
			label values days_death_cat days_death_cat
		
	// Generate variable for dead: 0=no, 1=yes
	gen dead_31 = .
		replace dead_31 = 0 if healthstatus == 0 | healthstatus == 1 	// healthy or sick
		replace dead_31 = 1 if healthstatus == 2 						// dead
		replace dead_31 = 0 if healthstatus == 2 & days_death > 31 & days_death != .
		label variable dead "Dead within 31 days"
		label values dead_31 dead
}

	}
