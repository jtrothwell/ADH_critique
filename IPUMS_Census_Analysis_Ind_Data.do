*Step 1. Use IPUMS-CPS or other source for CPS data (like NBER) to get data from 
*Annual Social and Economic Supplement

use "\CPS_ASEC_RAW_1968_2016.dta", clear

*Step 2
*Merge with measures of import exposure

merge m:1 ind1990 using "[DIRECTORY]\AADHP_Imports_per_Worker1999_2011.dta"
drop if _merge==2
drop _merge
merge m:1 ind1990 using "[DIRECTORY]\Github\Industry_Shock_USITC_Census.dta"
drop if _merge==2
drop _merge

*Step 3
***Begin variable creation and analysis

*Drop if weight is zero; only relevant in 1960s;
drop if wtsupp<0
*Restrict to working-age adults
drop if age>64 | age<18

gen age2=age^2
gen age3=age^3
gen bad_health=1 if health>=4
replace bad_health=0 if health<3

gen out_labor=1 if labforce==1
replace out_labor=0 if labforce==2

gen unemploy_ly=1 if wksunem2<8
replace unemploy_ly=0 if wksunem2==0

gen male=1 if sex==1
replace male=0 if sex==2
gen latin=1 if hispan>=100 & hispan<=412
replace latin=0 if hispan==0 | hispan>412
gen white=1 if race==100
replace white=0 if race!=100
replace white=0 if latin==1
gen black=1 if race==200
replace black=0 if race!=200
replace black=0 if latin==1
gen asian2=1 if race==650 | race==651 | race==652
replace asian2=0 if race==650 & race!=651 & race!=652
replace asian2=0 if latin==1
replace asian2=0 if white==1
replace asian2=0 if black==1
replace asian=0 if race>652
mvencode asian, mv(0) override

gen less=1 if educ<71
gen HS=1 if educ==72 | educ==73
gen some=1 if educ==80 | educ==81
replace some=1 if educ==100 
gen assoc=1 if educ==91 | educ==92
gen assoc_or_two=1 if educ==90 | educ==91 | educ==92
gen BA=1 if educ==111
gen BA_or_four=1 if educ==111 | educ==110
gen postBA=1 if educ>=120
mvencode less HS some assoc assoc_or_two BA BA_or_four postBA, mv(0)


*Define manufacturing, 1950 basis
gen mfg50=1 if ind1950>=300 &  ind1950<500
replace mfg50=0 if ind1950<300 |  ind1950>=500
gen mfg50ly=1 if ind50ly>=300 &  ind50ly<500
replace mfg50ly=0 if ind50ly<300 |  ind50ly>=500
*Transistions
gen mfg_to_mfg=1 if mfg50==1 & mfg50ly==1
replace mfg_to_mfg=0 if mfg50==0 | mfg50ly==0
gen mfg_to_nomfg=1 if mfg50ly==1 & mfg50==0
replace mfg_to_nomfg=0 if mfg50==1 | mfg50ly==0

gen sector="Ag_Energy" if ind1950>=105 & ind1950<=239
replace sector="Con" if ind1950==246
replace sector="Manuf" if ind1950>=300 & ind1950<500
replace sector="Trans_Com_Util" if ind1950>=500 & ind1950<600
replace sector="Trade" if ind1950>=600 & ind1950<700
replace sector="Fin_Bus_Personal" if ind1950>=700 & ind1950<860
replace sector="Prof_Service" if ind1950>=868 & ind1950<900
replace sector="Govt" if ind1950>=900 & ind1950<997

gen sector2="Ag_Energy" if ind50ly>=105 & ind50ly<=239
replace sector2="Con" if ind50ly>=246
replace sector2="Manuf" if ind50ly>=300 & ind50ly<500
replace sector2="Trans_Com_Util" if ind50ly>500 & ind50ly<600
replace sector2="Trade" if ind50ly>=600 & ind50ly<700
replace sector2="Fin_Bus_Personal" if ind50ly>=700 & ind50ly<860
replace sector2="Prof_Service" if ind50ly>=868 & ind50ly<900
replace sector2="Govt" if ind50ly>=900 & ind50ly<900

gen same_sector=1 if sector==sector2
replace same_sector=0 if sector!=sector2
replace same_sector=0 if sector2=="" & sector!=""

gen same_ind=1 if ind50ly==ind1950
replace same_ind=0 if ind50ly!=ind1950
replace same_ind=0 if ind50ly==. & ind1950==.

sum mfg_to_mfg mfg_to_nomfg same_sector if mfg50==1 [aw=wtsupp]
sum mfg_to_mfg mfg_to_nomfg same_sector if mfg50==0 [aw=wtsupp]

gen unemployed=1 if empstat==20 | empstat==21  | empstat==22
replace unemployed=0 if empstat!=20 & empstat!=21  & empstat!=22
replace unemployed=. if labforce==1
tab empstat if unemployed==1
replace same_sector=0 if unemployed==1 & sector2!=""
replace same_sector=0 if out_labor==1 & sector2!=""

gen long_term_un=1 if durunemp>27
replace long_term_un=0 if durunemp<=27
replace long_term_un=0 if durunemp==999
replace long_term_un=. if durunemp==.
sum long_term if unemployed==1
sum unemployed if long_term_un==1

sum mfg_to_mfg mfg_to_nomfg same_sector unemployed long_term out_labor ///
if mfg50ly==1 & unemploy_ly==1 [aw=wtsupp]

*1988-1993; temporary ended is not a category
gen loser=1 if whyunemp==1
replace loser=0 if whyunemp!=1

gen job_end=1 if whyunemp<=3
replace job_end=0 if whyunemp==0
replace job_end=0 if whyunemp>3
replace job_end=. if whyunemp==.

gen temp_end=1 if whyunemp==3
replace temp_end=0 if whyunemp!=3
replace temp_end=. if whyunemp==.

tab whyunemp if mfg50ly==1 & year<2001 & unemployed==1 & ind50ly!=0 & ind50ly<900 [aw=wtsupp]
tab whyunemp if mfg50ly==0 & year<2001 & unemployed==1 & ind50ly!=0 & ind50ly<900 [aw=wtsupp]
tab whyunemp if mfg50ly==1 & year>=2001 & unemployed==1 & ind50ly!=0 & ind50ly<900 [aw=wtsupp]
tab whyunemp if mfg50ly==0 & year>=2001 & unemployed==1 & ind50ly!=0 & ind50ly<900 [aw=wtsupp]

sum job_end if   mfg50ly==1 & year<2001 & unemployed==1 & ind50ly!=0 & ind50ly<900 [aw=wtsupp]
sum job_end if   mfg50ly==0 & year<2001 & unemployed==1 & ind50ly!=0 & ind50ly<900 [aw=wtsupp]
sum job_end if   mfg50ly==1 & year>=2001 & unemployed==1 & ind50ly!=0 & ind50ly<900 [aw=wtsupp]
sum job_end if   mfg50ly==0 & year>=2001 & unemployed==1 & ind50ly!=0 & ind50ly<900 [aw=wtsupp]

*STEP 4
*********
***REGRESSIONS***
******

*Define manufacturing
gen mfg=1 if ind1990>=100 &  ind1990<400 
replace mfg=0 if ind1990<100 |  ind1990>=400 
gen china=1 if year>=2001
replace china=0 if year<2001
replace china=. if year==.
gen china_mfg=1 if mfg==1 & china==1
replace china_mfg=0 if mfg==0 | china==0

*conditional means, using current or previous industry
sum same_sector job_end unemployed long_term_un if mfg==1 & year<2001  [aw=wtsupp]
sum same_sector job_end unemployed long_term_un if mfg==0 & year<2001  [aw=wtsupp]
sum same_sector job_end unemployed long_term_un if mfg==1 & year>=2001  [aw=wtsupp]
sum same_sector job_end unemployed long_term_un if  mfg==0 & year>=2001  [aw=wtsupp]


*MFG
set more off
dprobit unemployed china_mfg mfg china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') replace 
dprobit job_end china_mfg mfg china age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
dprobit long_term_un china_mfg mfg china age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
set more off
dprobit out_labor china_mfg mfg china age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian  [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
dprobit same_sector china_mfg mfg china age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian if unemployed==1 [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 

egen zd_import_usch_1999_2011=std(d_import_usch_1999_2011)
gen ADH_china=zd_import_usch_1999_2011*china


**ADH measure of import competition
set more off
dprobit unemployed ADH_china zd_import_usch_1999_2011 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990) 
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
dprobit job_end ADH_china zd_import_usch_1999_2011 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
dprobit long_term ADH_china zd_import_usch_1999_2011 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
dprobit out_labor ADH_china zd_import_usch_1999_2011 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 

**ADH 2SLS
gen IV_ADH_china=zd_import_otch_1999_2011*china

set more off
ivregress 2sls unemployed (ADH_china=IV_ADH_china) d_import_otch_1999_2011 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [aw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\CPS_2SLS_Predict_Outcome.xls", excel  adjr2 replace
ivregress 2sls job_end (ADH_china=IV_ADH_china) d_import_otch_1999_2011 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [aw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\CPS_2SLS_Predict_Outcome.xls", excel adjr2  
ivregress 2sls long_term (ADH_china=IV_ADH_china) d_import_otch_1999_2011 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [aw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\CPS_2SLS_Predict_Outcome.xls", excel adjr2  
ivregress 2sls out_labor (ADH_china=IV_ADH_china) d_import_otch_1999_2011 china age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian  [aw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\CPS_2SLS_Predict_Outcome.xls", excel adjr2  
ivregress 2sls same_sector (ADH_china=IV_ADH_china) d_import_otch_1999_2011 china age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian if unemployed==0 [aw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\CPS_2SLS_Predict_Outcome.xls", excel adjr2  
ivregress 2sls bad_health (ADH_china=IV_ADH_china) d_import_otch_1999_2011 china age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian if out_labor==0 [aw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\CPS_2SLS_Predict_Outcome.xls", excel adjr2  

**My own measure--Rothwell import competition
egen zind_shock_00_15=std(ind_shock_00_15)
gen zind_shock_00_15_china=zind_shock_00_15*china

set more off
dprobit unemployed zind_shock_00_15_china zind_shock_00_15 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
dprobit job_end zind_shock_00_15_china zind_shock_00_15 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
dprobit long_term zind_shock_00_15_china zind_shock_00_15 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 
dprobit out_labor zind_shock_00_15_china zind_shock_00_15 china   age age2 age3 male  some assoc assoc_or_two BA postBA latin black asian [pw=wtsupp], cl(ind1990)
outreg2 using "[DIRECTORY]\Regress_predict_MFG_unemployment.xls", excel addstat(Pseudo R-squared, `e(r2_p)') 


****Figure 2. Manufacturing premium
replace incwage=. if inctot==9999999
replace incwage=. if inctot==9999998

gen lnwage=ln(incwage)

gen employ=1 if empstat==10 | empstat==12
replace employ=0 if empstat!=10 & empstat!=12
keep if employ==1

gen prem=.
set more off
forval x = 1968/2016 {
reg lnwage mfg age age2 age3 male  some assoc assoc_or_two BA postBA  if year==`x' [aw=wtsupp], cl(ind1990)
replace prem=_b[mfg] if year==`x'
}
collapse (mean) prem [aw=wtsupp], by(year)
sort year
edit year prem
