cd "[DIRECTORY]"

use "[DIRECTORY]\workfile_china.dta", clear

**This re-runs the data but INTERACTS all independent variables with TIME trend
*erase "[DIRECTORY]\ADH_TABLE3_9.csv"
eststo clear
set more off

*this creates the interactions
foreach x in d_tradeusch_pw l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg_midatl reg_encen reg_wncen reg_satl reg_escen reg_wscen reg_mount  {
gen i_`x'=`x'*t2
}


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
eststo: ivregress 2sls `x' i_* (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource reg* t2  [aw=timepwt48], cluster(statefip) 
testparm i_l_sh_popedu_c i_l_sh_popfborn i_l_sh_empl_f i_l_sh_routine33 i_l_task_outsource
gen SF`x'=r(p) 
gen SFC`x'=r(chi2) 
testparm i_*
gen F`x'=r(p) 
gen FC`x'=r(chi2) 
}
esttab using "[DIRECTORY]\ADH_TABLE3_9_INTERACTION.csv", wide b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01)  r2 drop(t* reg*) replace

*The F* variables show the joint significant of the interactions


