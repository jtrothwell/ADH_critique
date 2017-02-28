*variables czone-d_tradeothi_pw_lag are from ADH directly;
*other variables are added from various sources, including AADHP

use "[DIRECTORY]\ADH_plus_other_data.dta", clear

**Create alternative outcome measures**
**Note: the other data are not formatted as long like ADH's, so one still needs
**to restrict anlaysis to single period. 

gen density=1000*(population2000 /land)
gen gr_prof_emp= (prof_cz_emp2014/ prof_cz_emp2000)-1
gen d_sh_prof_emp= (prof_cz_emp2014/tot_cz_emp2014)- (prof_cz_emp2000/tot_cz_emp2000)
gen pop_gr00_14=(population2014/population2000)-1
gen med_inc_gr=(med_hh_inc2014_5yr/ med_hh_inc1999)-1
gen xlfpr=lab_force_part2014- lab_force_part2000 
gen xurate=urate2014- urate2000
gen gr_emp=(tot_cz_emp2014/ tot_cz_emp2000)-1
gen gr_avg_pay=((tot_cz_pay2014/tot_cz_emp2014)/(tot_cz_pay2014/tot_cz_emp2000))-1
gen gr_estab=(tot_cz_estab2014/ tot_cz_estab2000)-1
gen gr_AADHP_emp=(ADH_tot_emp2011/ADH_tot_emp1999)-1
gen gr_AADHP_mfg=(ADH_mfg_emp2011/ADH_mfg_emp1999)-1
gen gr_AADHP_adv_ser=(ADH_adv_ser_emp2011/ADH_adv_ser_emp1999)-1
gen d_sh_adv_ser=(ADH_adv_ser_emp2011/ADH_tot_emp2011)-(ADH_adv_ser_emp1999/ADH_tot_emp1999)
gen pct_sh_adv_ser=(ADH_adv_ser_emp2011/ADH_tot_emp2011)
gen gr_AADHP_nonmfg=(ADH_nonmfg_emp2011/ADH_nonmfg_emp1999)-1
gen gr_nonmfg_emp=(nonmfg_cz_emp2014/nonmfg_cz_emp2000)-1
gen gr_nonmfg_estab=(nonmfg_cz_estab2014/nonmfg_cz_estab2000)-1
gen xout_cty=(1-pct_same_cty2015)-(1-pct_same_cty2000)
gen xpct_self=(pct_self_employed2015-pct_self_employed2000)
gen xpct_own=(pct_own2015-pct_own2000)
gen gr_residential_workers=(workers2015/workers2000)-1
gen lnmed_hhinc2014=ln(med_hh_inc2014_5yr)
gen lnavg_pay2014=ln(tot_cz_pay2014/tot_cz_emp2014)
gen sh_emp1999_exposed=sh_emp23_1999 +sh_emp35_1999+ sh_emp36_1999 +sh_emp39_1999
gen sh_emp1991_exposed=sh_emp23_1991 +sh_emp35_1991+ sh_emp36_1991 +sh_emp39_1991
gen density_import=d_czone_imp_exp_usch_1999_2011*density
gen xgini=Gini2014-Gini2000

*******
***REPRODUCE TABLE 4 IN ROTHWELL (2017)********
******


**Column1 of Table 4
*2000 to recent, using AADHP's 1999-2011 imports per worker
eststo clear
*erase "[DIRECTORY]\AADHP_2000_ALT_OUTCOME.csv"
set more off
foreach x in med_inc_gr xlfpr xurate gr_emp gr_avg_pay gr_estab pop_gr00_14 d_mort_age_adj gr_AADHP_emp gr_AADHP_mfg gr_AADHP_nonmfg gr_nonmfg_emp gr_nonmfg_estab xout_cty xpct_own gr_residential_workers  urate2014 lnmed_hhinc2014 lnavg_pay2014 x_inc_mob_80_86 x_edu_mob84_93 gr_prof_emp d_sh_prof_emp   {
eststo: ivregress 2sls `x' (d_czone_imp_exp_usch_1999_2011=d_czone_imp_exp_otch_1999_2011) l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* if yr==2000 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\AADHP_2000_ALT_OUTCOME.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace

**Column2 of Table 4
**2000 to recent, using QCEW-based ADH-like measure of imports per worker
eststo clear
*erase "[DIRECTORY]\ADH_2000_ALT_TRADE.csv"
set more off
foreach x in med_inc_gr xlfpr xurate gr_emp gr_avg_pay gr_estab pop_gr00_14 d_mort_age_adj gr_AADHP_emp gr_AADHP_mfg gr_AADHP_nonmfg gr_nonmfg_emp gr_nonmfg_estab xout_cty xpct_own gr_residential_workers  urate2014 lnmed_hhinc2014 lnavg_pay2014 x_inc_mob_80_86 x_edu_mob84_93 gr_prof_emp d_sh_prof_emp {
eststo: ivregress 2sls `x' (Dorn_CNimp_x_exp2000_2014=NonUS_CNimp_x_exp2000_2014) l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* if yr==2000 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\ADH_2000_ALT_TRADE.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace

**Column3 of Table 4
**2000--Measure exposure to import competition using
*specific industry employment shares for most exposed industries
*at SIC-level; the data are from AADHP files (i.e. County Business Patterns, adjusted/corrected for repressions).

/*
36	Comp Mfg
35	Electronics Mfg
23	Apparel Mfg
39	Mis Mfg
*/

eststo clear
erase "[DIRECTORY]\ADH_2000_by_Exposure_Shares.csv"
set more off
foreach x in med_inc_gr xlfpr xurate gr_emp gr_avg_pay gr_estab pop_gr00_14 d_mort_age_adj gr_AADHP_emp gr_AADHP_mfg gr_AADHP_nonmfg gr_nonmfg_emp gr_nonmfg_estab xout_cty xpct_own gr_residential_workers  urate2014 lnmed_hhinc2014 lnavg_pay2014 x_inc_mob_80_86 x_edu_mob84_93 {
eststo: reg  `x' sh_emp1999_exposed l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* if yr==2000 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\ADH_2000_by_Exposure_Shares.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace


**UNPUBLISHED ROBUSTNESS CHECKS WITH DEMOGRAPHIC CONTROLS
**2000=AADHP imports per worker
**med_age2000 sh_bl2000 sh_wh2000 sh_lat2000 

eststo clear
*erase "[DIRECTORY]\AADHP_2000_ALT_OUTCOME_DEMO_Controls.csv"
set more off
foreach x in med_inc_gr xlfpr xurate gr_emp gr_avg_pay gr_estab pop_gr00_14 d_mort_age_adj gr_AADHP_emp gr_AADHP_mfg gr_AADHP_nonmfg gr_nonmfg_emp gr_nonmfg_estab xout_cty xpct_own gr_residential_workers  urate2014 lnmed_hhinc2014 lnavg_pay2014 x_inc_mob_80_86 x_edu_mob84_93 gr_prof_emp d_sh_prof_emp {
eststo: ivregress 2sls `x' (d_czone_imp_exp_usch_1999_2011=d_czone_imp_exp_otch_1999_2011) l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource med_age2000 sh_bl2000 sh_wh2000 sh_lat2000 reg* if yr==2000 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\AADHP_2000_ALT_OUTCOME_DEMO_Controls.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace


*******1991-2014 analysis, unstacked
***REPRODUCES APPENDIX TABLE 2 IN ROTHWELL (2017)********
******

**This creates dependent variables used for the
**1991-2014 period
gen gr_emp90=(tot_cz_emp2014/ tot_cz_emp1990)-1
gen gr_avg_pay90=((tot_cz_pay2014/tot_cz_emp2014)/(tot_cz_pay2014/tot_cz_emp1990))-1
gen gr_estab90=(tot_cz_estab2014/ tot_cz_estab1990)-1
gen gr_nonmfg_emp90=(nonmfg_cz_emp2014/nonmfg_cz_emp1990)-1
gen gr_nonmfg_estab90=(nonmfg_cz_estab2014/nonmfg_cz_estab1990)-1

**1991-2011 use AADHP
eststo clear
*erase "[DIRECTORY]\AADHP_1990-2011.csv"
set more off
foreach x in gr_emp90 gr_avg_pay90 gr_estab90 gr_nonmfg_emp90 gr_nonmfg_estab90  x_inc_mob_80_86 x_edu_mob84_93 {
eststo: ivregress 2sls `x' (d_czone_imp_exp_usch_1991_2011=d_czone_imp_exp_otch_1999_2011) l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* if yr==1990 [aw=timepwt48], cluster(statefip) 
}
esttab using "[DIRECTORY]\AADHP_1990-2011.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(reg*) replace



