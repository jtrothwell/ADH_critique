# ADH_critique
Most of these files reproduce my reanalysis of the findings of Autor, Dorn, and Hanson's 2013 paper "The China Syndrome," using their data with slight modifications to their code. The data is organized at the commuting zone level. I include additional data and code used to study individual level workers. 

All of these results are published as a working paper here:
Rothwell, Jonathan T., Cutting the Losses: Reassessing the Costs of Import Competition to Workers and Communities (February 8, 2017). Available at SSRN: https://ssrn.com/abstract=2920188

Contact: jonathan_rothwell@gallup.com for questions/errors

This file uses data downloaded from Autor, Dorn, Hanson's 2013 American Economic Review article: "The China Syndrome", using data & code from Dorn: http://www.ddorn.net/data.htm, which is also available from the journal page: 
https://www.aeaweb.org/articles?id=10.1257/aer.103.6.2121

To extend their analysis from 2007 to 2011, I use data from Daron Acemoglu, David Autor, David Dorn, Gordon H. Hanson, and Brendan Price, "Import Competition and the Great US Employment Sag of the 2000s" Journal of Labor Economics, Vol. 34, No. S1.
These authors created a similar CZ-level measure of import competition. Dorn's homepage also publishes these data and the relevant code.

I also summplement the analysis with data from the Quarterly Census of Employment and Wages, https://www.bls.gov/cew/datatoc.htm
And the American Community Survey and 1990 and 2000 Decennial census surveys, using American Fact Finder and NHGIS, for 1990 county-level data, which I aggregate to commuting zones (CZs), https://www.nhgis.org/

DATA FILES for ADH critique, used for Tables 3-4 and Appendix Tables 1-2

A. ADH_plus_other_data.dta (I also made this available as .csv file)
This has all the data used in ADH, plus the main import competition measures in AADHP, plus data from census, QCEW, CDC, and other sources that I merged in to measure alternative outcomes and add additional controls. 

Do files for ADH critique

1. Replicate_ADH_but_unstack_model.do
This is the STATA code I use to re-analyze ADH's data. It is used to produce Appendix Table 1 in Rothwell (2017) & serves as the basis for Table 3, which summarizes those results. It also performs robustness checks by adding in controls for median age, race, and ethnic group population shares.

2. Extend_ADH_to_2011_use_alternative_dependent_variables.do
This explores the 2000 to 2014 period with alternative dependent variables using AADHP's 1999-2011 measure of import competition. Those results are published in Table 4 in Rothwell 2017. 
It also examines 1991-2014 outcomes using various sources; those results are published as Appendix Tables 2 and 3. The code also shows the  robustness checks (adding demographic controls), which were not published as tables but described in the text. Appendix Table 3 code compares domestic shocks to import shocks; the domestic shock data are provided in ADH_plus_other_data.dta.

DATA FILES for individual level analysis, used for Table 2

B. AADHP_Imports_per_Worker1999_2011.dta
This matches CPS ind1990 to Acemoglu, Autor, Dorn, Hanson, and Price measurs of imports per worker

C. Industry_Shock_USITC_Census.dta

This mataches ind1990 to USITC data on "imports per consumption" growth from China. (Those raw data are avaialble on the USITC dataweb, but you don't need to get it yourself to replicate)

D. You need to download data from IPUMS-CPS (Annual Social and Economic Supplement).

Do file for individual level regressions

3. IPUMS_Census_Analysis_Ind_Data.do
This is STATA code needed to code the CPS variables merge the industry shock files, and run the regression analysis in Table 2.

4. Replicate_ADH_with_interactions.do
This is STATA code to show what happens when all right-hand-side variables used in original ADH analysis are interacted with the time period dummy variable and included in the model.

SUPPLEMENTARY DATA FILES

E. USITC_1997_2015_3D.csv. 
This is U.S. International Trade Commission Data (USITC) from its Dataweb for the value of Chinese imports, measured in millions of current U.S. dollars. It is merged with the CPS data to create a measure of import exposure for individuals by industry. The data is at the 3-digit NAICS level (eg computer and electronics manufacturing, transporation equipement mfg, etc)

F. ind1990_naics_xwalk.csv
To link the USITC data to IPUMS-CPS, one needs a crosswalk between NAICS and ind1990, which is the time-consistent industry variable used in the IPUMS-CPS database. I used Dorn's files to help with the creation of this crosswalk but relied on my own judgement in some cases.

Note: The figures and Table 1 were produced from publicly available sources, often with little additional analysis. See IPUMS-CPS for documentation required to process the microdata and my do file IPUMS_Census_Analysis_Ind_Data.do.
