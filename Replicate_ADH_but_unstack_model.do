**This file uses data downloaded from Autor, Dorn, Hanson's 2013 American Economic Review article:
*"The China Syndrome", using data & code from Dorn:
*http://www.ddorn.net/data.htm 
*which is also available from the journal page:
*https://www.aeaweb.org/articles?id=10.1257/aer.103.6.2121
*After downloading their data [or .dta file I provide on GITHUB], 
*change [DIRECTORY] to the folder with their data.

cd "[DIRECTORY]"

use "[DIRECTORY]\workfile_china.dta", clear

****These are the dependent variables and models used in tables 3-9 of the paper
**TABLE 3-9 in Dorn
*****

**This merely re-runs the data and confirms the published results
*erase "[DIRECTORY]\ADH_TABLE3_9.csv"
eststo clear
set more off

foreach x in d_sh_empl_mfg ///
lnchg_popworkage lnchg_popworkage_edu_c lnchg_popworkage_edu_nc lnchg_popworkage_age1634 lnchg_popworkage_age3549 lnchg_popworkage_age5064 ///
lnchg_no_empl_mfg lnchg_no_empl_nmfg  lnchg_no_unempl lnchg_no_nilf lnchg_no_ssadiswkrs ///
d_sh_empl_nmfg d_sh_unempl  d_sh_nilf d_sh_ssadiswkrs ///
d_sh_empl_mfg_edu_c d_sh_empl_nmfg_edu_c d_sh_unempl_edu_c d_sh_nilf_edu_c ///
d_sh_empl_mfg_edu_nc d_sh_empl_nmfg_edu_nc d_sh_unempl_edu_nc d_sh_nilf_edu_nc ///
d_avg_lnwkwage d_avg_lnwkwage_m d_avg_lnwkwage_f d_avg_lnwkwage_c d_avg_lnwkwage_c_m  d_avg_lnwkwage_c_f ///
d_avg_lnwkwage_nc d_avg_lnwkwage_nc_m  d_avg_lnwkwage_nc_f ///
lnchg_no_empl_mfg_edu_c lnchg_no_empl_mfg_edu_nc  lnchg_no_empl_nmfg_edu_c lnchg_no_empl_nmfg_edu_nc ///
d_avg_lnwkwage_mfg d_avg_lnwkwage_mfg_c d_avg_lnwkwage_mfg_nc d_avg_lnwkwage_nmfg d_avg_lnwkwage_nmfg_c d_avg_lnwkwage_nmfg_nc ///
lnchg_trans_totindiv_pc lnchg_trans_taaimp_pc lnchg_trans_unemp_pc ///
lnchg_trans_ssaret_pc lnchg_trans_ssadis_pc lnchg_trans_totmed_pc  lnchg_trans_fedinc_pc ///
lnchg_trans_othinc_pc lnchg_trans_totedu_pc ///
d_trans_totindiv_pc d_trans_taaimp_pc d_trans_unemp_pc d_trans_ssaret_pc d_trans_ssadis_pc ///
d_trans_totmed_pc d_trans_fedinc_pc d_trans_othinc_pc d_trans_totedu_pc ///
relchg_avg_hhincsum_pc_pw  relchg_avg_hhincwage_pc_pw relchg_avg_hhincbusinv_pc_pw relchg_avg_hhinctrans_pc_pw  ///
relchg_med_hhincsum_pc_pw  relchg_med_hhincwage_pc_pw d_avg_hhincsum_pc_pw d_avg_hhincwage_pc_pw  ///
d_avg_hhincbusinv_pc_pw d_avg_hhinctrans_pc_pw  d_med_hhincsum_pc_pw d_med_hhincwage_pc_pw {
eststo: ivregress 2sls `x' (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* t2  [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\ADH_TABLE3_9.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(t* reg*) replace

**1990. This does the same as above but conditions the anlaysis to the first period
**1990-2000 using the if statement

*erase "[DIRECTORY]\ADH_1990_TABLE3_9.csv"
eststo clear
set more off
foreach x in d_sh_empl_mfg ///
lnchg_popworkage lnchg_popworkage_edu_c lnchg_popworkage_edu_nc lnchg_popworkage_age1634 lnchg_popworkage_age3549 lnchg_popworkage_age5064 ///
lnchg_no_empl_mfg lnchg_no_empl_nmfg  lnchg_no_unempl lnchg_no_nilf lnchg_no_ssadiswkrs ///
d_sh_empl_nmfg d_sh_unempl  d_sh_nilf d_sh_ssadiswkrs ///
d_sh_empl_mfg_edu_c d_sh_empl_nmfg_edu_c d_sh_unempl_edu_c d_sh_nilf_edu_c ///
d_sh_empl_mfg_edu_nc d_sh_empl_nmfg_edu_nc d_sh_unempl_edu_nc d_sh_nilf_edu_nc ///
d_avg_lnwkwage d_avg_lnwkwage_m d_avg_lnwkwage_f d_avg_lnwkwage_c d_avg_lnwkwage_c_m  d_avg_lnwkwage_c_f ///
d_avg_lnwkwage_nc d_avg_lnwkwage_nc_m  d_avg_lnwkwage_nc_f ///
lnchg_no_empl_mfg_edu_c lnchg_no_empl_mfg_edu_nc  lnchg_no_empl_nmfg_edu_c lnchg_no_empl_nmfg_edu_nc ///
d_avg_lnwkwage_mfg d_avg_lnwkwage_mfg_c d_avg_lnwkwage_mfg_nc d_avg_lnwkwage_nmfg d_avg_lnwkwage_nmfg_c d_avg_lnwkwage_nmfg_nc ///
lnchg_trans_totindiv_pc lnchg_trans_taaimp_pc lnchg_trans_unemp_pc ///
lnchg_trans_ssaret_pc lnchg_trans_ssadis_pc lnchg_trans_totmed_pc  lnchg_trans_fedinc_pc ///
lnchg_trans_othinc_pc lnchg_trans_totedu_pc ///
d_trans_totindiv_pc d_trans_taaimp_pc d_trans_unemp_pc d_trans_ssaret_pc d_trans_ssadis_pc ///
d_trans_totmed_pc d_trans_fedinc_pc d_trans_othinc_pc d_trans_totedu_pc ///
relchg_avg_hhincsum_pc_pw  relchg_avg_hhincwage_pc_pw relchg_avg_hhincbusinv_pc_pw relchg_avg_hhinctrans_pc_pw  ///
relchg_med_hhincsum_pc_pw  relchg_med_hhincwage_pc_pw d_avg_hhincsum_pc_pw d_avg_hhincwage_pc_pw  ///
d_avg_hhincbusinv_pc_pw d_avg_hhinctrans_pc_pw  d_med_hhincsum_pc_pw d_med_hhincwage_pc_pw  {
eststo: ivregress 2sls `x' (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* if yr==1990 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\ADH_1990_TABLE3_9.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace

**2000. This does the same as above but conditions the anlaysis to the second period
**2000-2007 using the if statement
*erase "[DIRECTORY]\ADH_2000_TABLE3_9.csv"
eststo clear
set more off
foreach x in d_sh_empl_mfg ///
lnchg_popworkage lnchg_popworkage_edu_c lnchg_popworkage_edu_nc lnchg_popworkage_age1634 lnchg_popworkage_age3549 lnchg_popworkage_age5064 ///
lnchg_no_empl_mfg lnchg_no_empl_nmfg  lnchg_no_unempl lnchg_no_nilf lnchg_no_ssadiswkrs ///
d_sh_empl_nmfg d_sh_unempl  d_sh_nilf d_sh_ssadiswkrs ///
d_sh_empl_mfg_edu_c d_sh_empl_nmfg_edu_c d_sh_unempl_edu_c d_sh_nilf_edu_c ///
d_sh_empl_mfg_edu_nc d_sh_empl_nmfg_edu_nc d_sh_unempl_edu_nc d_sh_nilf_edu_nc ///
d_avg_lnwkwage d_avg_lnwkwage_m d_avg_lnwkwage_f d_avg_lnwkwage_c d_avg_lnwkwage_c_m  d_avg_lnwkwage_c_f ///
d_avg_lnwkwage_nc d_avg_lnwkwage_nc_m  d_avg_lnwkwage_nc_f ///
lnchg_no_empl_mfg_edu_c lnchg_no_empl_mfg_edu_nc  lnchg_no_empl_nmfg_edu_c lnchg_no_empl_nmfg_edu_nc ///
d_avg_lnwkwage_mfg d_avg_lnwkwage_mfg_c d_avg_lnwkwage_mfg_nc d_avg_lnwkwage_nmfg d_avg_lnwkwage_nmfg_c d_avg_lnwkwage_nmfg_nc ///
lnchg_trans_totindiv_pc lnchg_trans_taaimp_pc lnchg_trans_unemp_pc ///
lnchg_trans_ssaret_pc lnchg_trans_ssadis_pc lnchg_trans_totmed_pc  lnchg_trans_fedinc_pc ///
lnchg_trans_othinc_pc lnchg_trans_totedu_pc ///
d_trans_totindiv_pc d_trans_taaimp_pc d_trans_unemp_pc d_trans_ssaret_pc d_trans_ssadis_pc ///
d_trans_totmed_pc d_trans_fedinc_pc d_trans_othinc_pc d_trans_totedu_pc ///
relchg_avg_hhincsum_pc_pw  relchg_avg_hhincwage_pc_pw relchg_avg_hhincbusinv_pc_pw relchg_avg_hhinctrans_pc_pw  ///
relchg_med_hhincsum_pc_pw  relchg_med_hhincwage_pc_pw d_avg_hhincsum_pc_pw d_avg_hhincwage_pc_pw  ///
d_avg_hhincbusinv_pc_pw d_avg_hhinctrans_pc_pw  d_med_hhincsum_pc_pw d_med_hhincwage_pc_pw  {
eststo: ivregress 2sls `x' (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* if yr==2000 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\ADH_2000_TABLE3_9.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace


***UNPUBLISHED ROBUSTNESS CHECK--REDO ABOVE (APPENDIX TABLE 1)
**EXCEPT WITH DEMOGRPAHIC CONTROLS FOR MEDIAN-AGE & RACE/ETHNICITY

**Assigns wide-measure of median age & race/ethnicity
*to appropriate periods
gen sh_wh=sh_wh1990 if yr==1990
gen sh_bl=sh_bl1990 if yr==1990
gen sh_lat=sh_lat1990 if yr==1990
replace sh_wh=sh_wh2000 if yr==2000
replace sh_bl=sh_bl2000 if yr==2000
replace sh_lat=sh_lat2000 if yr==2000
gen age=med_age90 if yr==1990
replace age=med_age2000 if yr==2000

*erase "[DIRECTORY]\AGE_control_ADH_TABLE3_9.csv"
*erase "[DIRECTORY]\AGE_control_ADH_1990_TABLE3_9.csv"
*erase "[DIRECTORY]\AGE_control_ADH_2000_TABLE3_9.csv"

**include these additional controls to original ADH model
*& unstacked versions, *age sh_bl sh_wh sh_lat

**ADH's original "stacked" model, including age and race controls
eststo clear
set more off
foreach x in d_sh_empl_mfg ///
lnchg_popworkage lnchg_popworkage_edu_c lnchg_popworkage_edu_nc lnchg_popworkage_age1634 lnchg_popworkage_age3549 lnchg_popworkage_age5064 ///
lnchg_no_empl_mfg lnchg_no_empl_nmfg  lnchg_no_unempl lnchg_no_nilf lnchg_no_ssadiswkrs ///
d_sh_empl_mfg d_sh_empl_nmfg d_sh_unempl  d_sh_nilf d_sh_ssadiswkrs ///
d_sh_empl_mfg_edu_c d_sh_empl_nmfg_edu_c d_sh_unempl_edu_c d_sh_nilf_edu_c ///
d_sh_empl_mfg_edu_nc d_sh_empl_nmfg_edu_nc d_sh_unempl_edu_nc d_sh_nilf_edu_nc ///
d_avg_lnwkwage d_avg_lnwkwage_m d_avg_lnwkwage_f d_avg_lnwkwage_c d_avg_lnwkwage_c_m  d_avg_lnwkwage_c_f ///
d_avg_lnwkwage_nc d_avg_lnwkwage_nc_m  d_avg_lnwkwage_nc_f ///
lnchg_no_empl_mfg lnchg_no_empl_mfg_edu_c lnchg_no_empl_mfg_edu_nc lnchg_no_empl_nmfg lnchg_no_empl_nmfg_edu_c lnchg_no_empl_nmfg_edu_nc ///
d_avg_lnwkwage_mfg d_avg_lnwkwage_mfg_c d_avg_lnwkwage_mfg_nc d_avg_lnwkwage_nmfg d_avg_lnwkwage_nmfg_c d_avg_lnwkwage_nmfg_nc ///
lnchg_trans_totindiv_pc lnchg_trans_taaimp_pc lnchg_trans_unemp_pc ///
lnchg_trans_ssaret_pc lnchg_trans_ssadis_pc lnchg_trans_totmed_pc  lnchg_trans_fedinc_pc ///
lnchg_trans_othinc_pc lnchg_trans_totedu_pc ///
d_trans_totindiv_pc d_trans_taaimp_pc d_trans_unemp_pc d_trans_ssaret_pc d_trans_ssadis_pc ///
d_trans_totmed_pc d_trans_fedinc_pc d_trans_othinc_pc d_trans_totedu_pc ///
relchg_avg_hhincsum_pc_pw  relchg_avg_hhincwage_pc_pw relchg_avg_hhincbusinv_pc_pw relchg_avg_hhinctrans_pc_pw  ///
relchg_med_hhincsum_pc_pw  relchg_med_hhincwage_pc_pw d_avg_hhincsum_pc_pw d_avg_hhincwage_pc_pw  ///
d_avg_hhincbusinv_pc_pw d_avg_hhinctrans_pc_pw  d_med_hhincsum_pc_pw d_med_hhincwage_pc_pw {
eststo: ivregress 2sls `x' (d_tradeusch_pw=d_tradeotch_pw_lag) age sh_bl sh_wh sh_lat l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* t2  [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\AGE_control_ADH_TABLE3_9.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(t* reg*) replace

**2000, including age and race controls
eststo clear
set more off
foreach x in d_sh_empl_mfg ///
lnchg_popworkage lnchg_popworkage_edu_c lnchg_popworkage_edu_nc lnchg_popworkage_age1634 lnchg_popworkage_age3549 lnchg_popworkage_age5064 ///
lnchg_no_empl_mfg lnchg_no_empl_nmfg  lnchg_no_unempl lnchg_no_nilf lnchg_no_ssadiswkrs ///
d_sh_empl_mfg d_sh_empl_nmfg d_sh_unempl  d_sh_nilf d_sh_ssadiswkrs ///
d_sh_empl_mfg_edu_c d_sh_empl_nmfg_edu_c d_sh_unempl_edu_c d_sh_nilf_edu_c ///
d_sh_empl_mfg_edu_nc d_sh_empl_nmfg_edu_nc d_sh_unempl_edu_nc d_sh_nilf_edu_nc ///
d_avg_lnwkwage d_avg_lnwkwage_m d_avg_lnwkwage_f d_avg_lnwkwage_c d_avg_lnwkwage_c_m  d_avg_lnwkwage_c_f ///
d_avg_lnwkwage_nc d_avg_lnwkwage_nc_m  d_avg_lnwkwage_nc_f ///
lnchg_no_empl_mfg lnchg_no_empl_mfg_edu_c lnchg_no_empl_mfg_edu_nc lnchg_no_empl_nmfg lnchg_no_empl_nmfg_edu_c lnchg_no_empl_nmfg_edu_nc ///
d_avg_lnwkwage_mfg d_avg_lnwkwage_mfg_c d_avg_lnwkwage_mfg_nc d_avg_lnwkwage_nmfg d_avg_lnwkwage_nmfg_c d_avg_lnwkwage_nmfg_nc ///
lnchg_trans_totindiv_pc lnchg_trans_taaimp_pc lnchg_trans_unemp_pc ///
lnchg_trans_ssaret_pc lnchg_trans_ssadis_pc lnchg_trans_totmed_pc  lnchg_trans_fedinc_pc ///
lnchg_trans_othinc_pc lnchg_trans_totedu_pc ///
d_trans_totindiv_pc d_trans_taaimp_pc d_trans_unemp_pc d_trans_ssaret_pc d_trans_ssadis_pc ///
d_trans_totmed_pc d_trans_fedinc_pc d_trans_othinc_pc d_trans_totedu_pc ///
relchg_avg_hhincsum_pc_pw  relchg_avg_hhincwage_pc_pw relchg_avg_hhincbusinv_pc_pw relchg_avg_hhinctrans_pc_pw  ///
relchg_med_hhincsum_pc_pw  relchg_med_hhincwage_pc_pw d_avg_hhincsum_pc_pw d_avg_hhincwage_pc_pw  ///
d_avg_hhincbusinv_pc_pw d_avg_hhinctrans_pc_pw  d_med_hhincsum_pc_pw d_med_hhincwage_pc_pw  {
eststo: ivregress 2sls `x' (d_tradeusch_pw=d_tradeotch_pw_lag) med_age2000 sh_bl sh_wh sh_lat l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* if yr==2000 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]AGE_control_ADH_2000_TABLE3_9.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace


**1990, including age and race controls
eststo clear
set more off
foreach x in d_sh_empl_mfg ///
lnchg_popworkage lnchg_popworkage_edu_c lnchg_popworkage_edu_nc lnchg_popworkage_age1634 lnchg_popworkage_age3549 lnchg_popworkage_age5064 ///
lnchg_no_empl_mfg lnchg_no_empl_nmfg  lnchg_no_unempl lnchg_no_nilf lnchg_no_ssadiswkrs ///
d_sh_empl_mfg d_sh_empl_nmfg d_sh_unempl  d_sh_nilf d_sh_ssadiswkrs ///
d_sh_empl_mfg_edu_c d_sh_empl_nmfg_edu_c d_sh_unempl_edu_c d_sh_nilf_edu_c ///
d_sh_empl_mfg_edu_nc d_sh_empl_nmfg_edu_nc d_sh_unempl_edu_nc d_sh_nilf_edu_nc ///
d_avg_lnwkwage d_avg_lnwkwage_m d_avg_lnwkwage_f d_avg_lnwkwage_c d_avg_lnwkwage_c_m  d_avg_lnwkwage_c_f ///
d_avg_lnwkwage_nc d_avg_lnwkwage_nc_m  d_avg_lnwkwage_nc_f ///
lnchg_no_empl_mfg lnchg_no_empl_mfg_edu_c lnchg_no_empl_mfg_edu_nc lnchg_no_empl_nmfg lnchg_no_empl_nmfg_edu_c lnchg_no_empl_nmfg_edu_nc ///
d_avg_lnwkwage_mfg d_avg_lnwkwage_mfg_c d_avg_lnwkwage_mfg_nc d_avg_lnwkwage_nmfg d_avg_lnwkwage_nmfg_c d_avg_lnwkwage_nmfg_nc ///
lnchg_trans_totindiv_pc lnchg_trans_taaimp_pc lnchg_trans_unemp_pc ///
lnchg_trans_ssaret_pc lnchg_trans_ssadis_pc lnchg_trans_totmed_pc  lnchg_trans_fedinc_pc ///
lnchg_trans_othinc_pc lnchg_trans_totedu_pc ///
d_trans_totindiv_pc d_trans_taaimp_pc d_trans_unemp_pc d_trans_ssaret_pc d_trans_ssadis_pc ///
d_trans_totmed_pc d_trans_fedinc_pc d_trans_othinc_pc d_trans_totedu_pc ///
relchg_avg_hhincsum_pc_pw  relchg_avg_hhincwage_pc_pw relchg_avg_hhincbusinv_pc_pw relchg_avg_hhinctrans_pc_pw  ///
relchg_med_hhincsum_pc_pw  relchg_med_hhincwage_pc_pw d_avg_hhincsum_pc_pw d_avg_hhincwage_pc_pw  ///
d_avg_hhincbusinv_pc_pw d_avg_hhinctrans_pc_pw  d_med_hhincsum_pc_pw d_med_hhincwage_pc_pw  {
eststo: ivregress 2sls `x' (d_tradeusch_pw=d_tradeotch_pw_lag) med_age90 sh_bl sh_wh sh_lat l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* if yr==1990 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]AGE_control_ADH_1990_TABLE3_9.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace
