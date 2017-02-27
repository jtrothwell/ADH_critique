# ADH_critique
This reanalyzes the findings of Autor, Dorn, and Hanson's 2013 paper "The China Syndrome" using their data with slight modifications to their code. These results are published as a working paper here:
Rothwell, Jonathan T., Cutting the Losses: Reassessing the Costs of Import Competition to Workers and Communities (February 8, 2017). Available at SSRN: https://ssrn.com/abstract=2920188

Contact: jonathan_rothwell@gallup.com for questions/errors

This file uses data downloaded from Autor, Dorn, Hanson's 2013 American Economic Review article: "The China Syndrome", using data & code from Dorn: http://www.ddorn.net/data.htm, which is also available from the journal page: 
https://www.aeaweb.org/articles?id=10.1257/aer.103.6.2121

To extend their analysis from 2007 to 2011, I use data from Daron Acemoglu, David Autor, David Dorn, Gordon H. Hanson, and Brendan Price, "Import Competition and the Great US Employment Sag of the 2000s" Journal of Labor Economics, Vol. 34, No. S1.
These authors created a similar CZ-level measure of import competition. Dorn's homepage also publishes these data and the relevant code.

DATA FILES for ADH critique, used for Tables 3-4 and appendix

A. ADH_plus_other_data.dta
This has all the data used in ADH, plus main import competition measures in AADHP, plus data from census, QCEW, CDC, and other sources that I merged in to measure alternative outcomes. 

Do files for ADH critique

1. Replicate_ADH_but_unstack_model.do
This is the STATA code I use to re-analyze ADH's data. It is used to produce Appendix Table 1 in Rothwell (2017) & serves as the basis for Table 3, which summarizes those results.

2. Extend_ADH_to_2011_use_alternative_dependent_variables.do
This explores the 2000 to 2014 period with alternative dependent variables using AADHP's 1999-2011 measure of import competition.
It also examines 1991-2014 outcomes using various sources

DATA FILES for individual level analysis, used for Table 2

A. AADHP_Imports_per_Worker1999_2011.dta
This matches CPS ind1990 to Acemoglu, Autor, Dorn, Hanson, and Price measurs of imports per worker
B. Industry_Shock_USITC_Census.dta
This matached ind1990 to USITC data on "imports per consumption" growth from China. (Those raw data are avaialble on the USITC dataweb, but you don't need to get it yourself to replicate)
C. Need to download data from IPUMS-CPS (Annual Social and Economic Supplement).

Do file for individual level regressions

1. IPUMS_Census_Analysis_Ind_Data.do
This is STATA code needed to code the CPS variables merge the industry shock files, and run the regression analysis in Table 2.
