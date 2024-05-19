*Definitions Other non-malaria diagnoses
*Author: Giulia Delvento

*DRC
*Data sources : REF and D28


*REF

/*Label diagnosis	
	afp	Acute flaccid paralysis
	anaemia	Anaemia
	bite	Animal/snake bite
	cholera	Cholera
	diarrhoea	Diarrhoea
	dysentry	Dysentry
	fever_unk	Pyrexia/fever of unknown origin
	gen_inf	Genital infections
	hepatitis	Hepatitis
	malnut_mild	Malnutrition - mild
	malnut_mod	Malnutrition - moderate
	malnut_sev	Malnutrition - severe
	measles	Measles
	meningitis	Meningitis
	otitis_m	Otitis media
	peritonitis	Peritonitis
	pneumonia	Pneumonia
	poison	Poisoning
	rti_unk	Respiratory tract infections (not pneumonia or tb)
	septicaemia	Septicaemia
	tb	Tuberculosis
	tetanus	Tetanus
	typhoid	Typhoid fever
	uti	Urinary tract infection (uti)
	viral_haem_fev	Viral haemorrhagic fever
	-77	None
	-96	Other specify
*/

*Consolidate diarrhea from symtpoms to diagnosis

*Pre-referral diagnosis: med_hist1 med_hist1_notlisted

*Diagnosis at facility at arrival
/*
adm_oth_arrival
adm_oth2_arrival*/

*Generate variable for diagnosis before (at pre-referral) or during admission

gen afp_admit=1 if (med_hist1_1==1 | adm_oth_arrival_1 ==1 )
gen anaemia_admit=1 if (med_hist1_2==1 | adm_oth_arrival_2==1 )
gen	bite_admit=1 if (med_hist1_3==1 | adm_oth_arrival_3==1 )
gen	cholera_admit=1 if (med_hist1_4==1 | adm_oth_arrival_4==1 )	
gen	diarrhoea_admit=1 if (med_hist1_5==1 | adm_oth_arrival_5==1 )
gen	dysentry_admit=1 if (med_hist1_6==1 | adm_oth_arrival_6==1 )
gen	fever_unk_admit=1 if (med_hist1_7==1 | adm_oth_arrival_7==1 )
gen	gen_inf_admit=1 if (med_hist1_8==1 | adm_oth_arrival_8==1 )	
gen	hepatitis_admit=1 if (med_hist1_9==1 | adm_oth_arrival_9==1 )	
gen	malnutrition=	if (med_hist1_10==1 | med_hist1_11==1 | med_hist1_12==1) | (adm_oth_arrival_10==1 | adm_oth_arrival_11==1 | adm_oth_arrival_12==1 )	
gen	measles_admit=1 if (med_hist1_13==1 | adm_oth_arrival_10==1 )
gen	meningitis_admit=1 if (med_hist1_14==1 | adm_oth_arrival_11==1 )
gen	otitis_m_admit=1 if (med_hist1_15==1 | adm_oth_arrival_12==1 )
gen	peritonitis_admit=1 if (med_hist1_16==1 | adm_oth_arrival_13==1 )
gen	pneumonia_admit=1 if (med_hist1_17==1 | adm_oth_arrival_14==1 )
gen	poison_admit=1 if (med_hist1_18==1 | adm_oth_arrival_15==1 )
gen	rti_unk_admit=1 if (med_hist1_19==1 | adm_oth_arrival_16==1 )	
gen	septicaemia_admit=1 if (med_hist1_20==1 | adm_oth_arrival_17==1 )	
gen	tb=	1 if (med_hist1_21==1 | adm_oth_arrival_18==1 )
gen	tetanus_admit=1 if (med_hist1_22==1 | adm_oth_arrival_19==1 )
gen	typhoid_admit=1 if (med_hist1_23==1 | adm_oth_arrival_20==1 )
gen	uti_admit=1 if (med_hist1_24==1 | adm_oth_arrival_22==1 )
gen viral_haem_fev=	1 if (med_hist1_25==1 | adm_oth_arrival_23==1 )

*Generate a special variable for helminths DRC (see do file on comorbidity analysis)
gen helminths_admit= 


*Diagnosis at discharge

gen afp_dis=1 if dis_oth_1==1
gen anaemia_dis=1 if dis_oth_2==1
gen	bite_dis=1 if dis_oth_3==1
gen	cholera_dis=1 if dis_oth_4==1 
gen	diarrhoea_dis=1 if dis_oth_5==1 
gen	dysentry_dis=1 if dis_oth_6==1 
gen	fever_unk_dis=1 if dis_oth_7==1
gen	gen_inf_dis=1 if dis_oth_8==1
gen	hepatitis_dis=1 if dis_oth_9==1
gen	malnutrition=	if (dis_oth_10==1 | dis_oth_11==1 | dis_oth_12==1)
gen	measles_dis=1 if dis_oth_13==1
gen	meningitis_dis=1 if dis_oth_14==1 
gen	otitis_m_dis=1 if dis_oth_15==1 
gen	peritonitis_dis=1 if dis_oth_16==1 
gen	pneumonia_dis=1 if dis_oth_17==1 
gen	poison_dis=1 if dis_oth_18==1 
gen	rti_unk_dis=1 if dis_oth_19==1 
gen	septicaemia_dis=1 if dis_oth_20==1	
gen	tb=	1 if dis_oth_21==1 
gen	tetanus_dis=1 if dis_oth_22==1 
gen	typhoid_dis=1 if dis_oth_23==1 
gen	uti_dis=1 if dis_oth_24==1 
gen viral_haem_fev=	1 if dis_oth_25==1 

*Generate binary variable for defining presence of comorbidity if any other condition/diagnosis present, before referral/at admission or discharge 

egen comorbidity_adm = anymatch(*_admit), values(1)
egen comorbidity_dis = anymatch(*_dis), values(1)
gen n_comorb_adm = anycount(*_admit)
gen n_comorb_dis = anycount(*_dis)


*DRC-D28 comorbidities
use "C:\Users\delvgi\Desktop\d28 do files\D28_allversions_for_analysis_final_15102020.dta", clear

* 1) q12 Q12. When ${child_name} first showed these symptoms, what illness did you think ${child_name} had?

* 2) q28	Q28. What was the diagnosis given at ${q14}?

tab1 q28*	//Q28. What was the diagnosis given at ${q14}?

gen afp_d28=1 if (q28_1==1)
gen aneamia_d28=1 if (q28_2==1 )
gen	bite_d28=1 if (q28_3==1 )
gen	cholera_d28=1 if (q28_4==1 )	
gen	diarrhoea_d28=1 if q28_5==1  | q7==1
gen	dysentry_d28=1 if (q28_6==1 )
gen	fever_unk_d28=1 if (q28_7==1 )
gen	gen_inf_d28=1 if (q28_8==1 )	
gen	hepatitis_d28=1 if (q28_9==1 )	
gen	malnutrition_d28=1	q28_==10 |  q28_==12 | q28_==12
gen	measles_d28=1 if (q28_13==1)
gen	meningitis_d28=1 if (q28_14==1)
gen	otitis_m_d28=1 if (q28_15==1)
gen	peritonitis_d28=1 if (q28_16==1)
gen	pneumonia_d28=1 if (q28_17==1)
gen	poison_d28=1 if (q28_18==1)
gen	rti_unk_d28=1 if (q28_19==1)	
gen	septicaemia_d28=1 if (q28_20==1)	
gen	tb=	1 if (q28_21==1)
gen	tetanus_d28=1 if (q28_22==1)
gen	typhoid_d28=1 if (q28_23==1)
gen	uti_d28=1 if (q28_24==1)
gen viral_haem_fev_d28=	1 if (q28_26==1)


/*
diagnosis	1	Acute flaccid paralysis
diagnosis	2	Anaemia
diagnosis	3	Animal/snake bite
diagnosis	4	Cholera
diagnosis	5	Diarrhoea
diagnosis	6	Dysentry
diagnosis	7	Pyrexia/fever of unknown origin
diagnosis	8	Genital infections
diagnosis	9	Hepatitis
diagnosis	25	Malaria
diagnosis	10	Malnutrition - mild
diagnosis	11	Malnutrition - moderate
diagnosis	12	Malnutrition - severe
diagnosis	13	Measles
diagnosis	14	Meningitis
diagnosis	15	Otitis media
diagnosis	16	Peritonitis
diagnosis	17	Pneumonia
diagnosis	18	Poisoning
diagnosis	19	Respiratory tract infections (not pneumonia or TB)
diagnosis	20	Septicaemia
diagnosis	21	Tuberculosis
diagnosis	22	Tetanus
diagnosis	23	Typhoid fever
diagnosis	24	Urinary tract infection (UTI)
diagnosis	26	Viral haemorrhagic fever
diagnosis	-96	Other Specify
diagnosis	-98	Don't Know
*/

*Consolidate diarrhea from symtpoms to diagnosis
tab q7 //15% had diarrhea



