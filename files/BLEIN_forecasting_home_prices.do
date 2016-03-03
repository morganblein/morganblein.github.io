/*MEHTODOLOGY: 
1)	Data preparation 
a)	Manually:
Downloaded every city home price indexes, composite 20 and national index and other variables. 
Put the all in the same sheet on excel: Simple copy and paste for each variable, making sure the time period corresponds. (They are all monthly values so its simple.)
Import the xls in in stata, save to .dta making first row labels for variables. 
Couple things wrong: date is in format Xxx-YYYY where X corresponds to month and Y to years.
Ex: Nov-2015. This is a string. 
We need to generate a variable YEAR:
b)	In STATA
*/
//Extracts the year from the string:
gen Year = regexs(0) if(regexm(Effectivedate, "[0-9]*$"))

//Next, we need to create a variable T, that increments by 1 per period (month) and starts at 1. This is easy to do manually.

//For seasonality, we need to generate categorical variables for each month: 
gen Jan =regexm(Effectivedate, "Jan") for January
. gen Feb =regexm(Effectivedate, "Feb")
. gen Mar =regexm(Effectivedate, "Mar")
. gen Apr =regexm(Effectivedate, "Apr")
. gen May =regexm(Effectivedate, "May")
. gen Jun =regexm(Effectivedate, "Jun")
. gen Jul =regexm(Effectivedate, "Jul")
. gen Aug =regexm(Effectivedate, "Aug")
. gen Sep =regexm(Effectivedate, "Sep")
. gen Oct =regexm(Effectivedate, "Oct")
. gen Nov =regexm(Effectivedate, "Nov")
. gen Dec =regexm(Effectivedate, "Dec")
/*Use regex to create binary (0 = not this month, 1 = this month) variables
Those variables should be categorical: recode to byte instead of float.*/
recast byte Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

//2)	Seasonality
//Create the graph
twoway (scatter SanFranciscoHomePriceIndex t) (scatter USNationalHomePriceIndex t) (scatter CityCompositeHomePriceIndex t)

//Linear regression
regress SanFranciscoHomePriceIndex t Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

//Exponential regression
//First, generate a log(SanFranciscoHomePriceIndex) variable:
gen SanFranciscoHomePriceIndex_log = log(SanFranciscoHomePriceIndex)
//run the regression on the new variable: 
regress SanFranciscoHomePriceIndex_log t Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

//Detrending
//Detrend the SF home price index using stata:
regress SanFranciscoHomePriceIndex t
predict SFHomePriceIndex_detrended , resid
//Detrend the log(SF home price index) using stata:
regress SanFranciscoHomePriceIndex_log t
predict SFHomePriceIndexlog_detrended , resid




//running a test regression to make sure the data is de-trended. 
regress SFHomePriceIndex_detrended t

//3)	Explanatory variables

//Detrend the X variables:

//Detrend CPIAUCNS using stata:
Regress CPIAUCNS_t
predict CPIAUCNS_detrended , resid
//Detrend CPIAUCNS using stata:
Regress CPIAUCNS_t
predict CPIAUCNS_detrended , resid
//Detrend MORTGAGE30US using stata:
Regress MORTGAGE30US t
predict MORTGAGE30US_detrended , resid
//Detrend MORTGAGE15US using stata:
Regress MORTGAGE15US t
predict MORTGAGE15US_detrended , resid
//Detrend SP500 using stata:
Regress SP500 t
predict SP500_detrended , resid
//Detrend DLTIITusing stata:
Regress DLTIITt
predict DLTIIT_detrended , resid

//4)	Causal regressions

// Model a)	Using Y= SanFranciscoHomePriceIndex, t included
regress SanFranciscoHomePriceIndex t CPIAUCNS CSCICP03USM665S MORTGAGE15US MORTGAGE30US SP500 DLTIIT Unemp
//Model b)	Using Y= SanFranciscoHomePriceIndex_log, t included
regress SanFranciscoHomePriceIndex_log t CPIAUCNS CSCICP03USM665S MORTGAGE15US MORTGAGE30US SP500 DLTIIT Unemp
//Model c)	Using Y= SFHomePriceIndex_detrended
regress SFHomePriceIndex_detrended CPIAUCNS_detrended CSCICP03USM665S  MORTGAGE30US_detrended  MORTGAGE15US_detrended SP500_detrended Unemp DLTIIT_detrended
//Model d)	Using Y= SFHomePriceIndex_log_detrended
regress SFHomePriceIndex_log_detrended CPIAUCNS_detrended CSCICP03USM665S  MORTGAGE30US_detrended  MORTGAGE15US_detrended SP500_detrended Unemp DLTIIT_detrended
//final model after assumption revision: 
regress SFHomePriceIndex_detrended CPIAUCNS_detrended CSCICP03USM665S MORTGAGE15US_detrended SP500_detrended Unemp DLTIIT_detrended


//5)	Predictive model

//Setting a real time series date index: 
. generate tdate=tm(1980m1)+_n-1
. . format tdate %tm 
. . tsset tdate

//Generate lagged variables for 4 months
gen lag4SFindex = SFHomePriceIndex_detrended[_n-4]
gen lag4unemp = Unemp[_n-4]
gen lag4CPIAUCNS_detrended = CPIAUCNS_detrended[_n-4]
gen lag4CSCICP03USM665S = CSCICP03USM665S[_n-4]
gen lag4MORTGAGE15US_detrended  = MORTGAGE15US_detrended[_n-4]
gen lag4SP500_detrended  = SP500_detrended[_n-4]
gen lag4DLTIIT_detrended  = DLTIIT_detrended[_n-4]

//regression used for prediction of feb 2016: 
regress SanFranciscoHomePriceIndex lag4CPIAUCNS_detrended lag4CSCICP03USM665S lag4MORTGAGE15US_detrended lag4SP500_detrended lag4unemp lag4DLTIIT_detrended lag4SanFranciscoHomePriceIndex

//Generate lagged variables for 11 months
gen lag11SFindex = SFHomePriceIndex_detrended[_n-11]
gen lag11unemp = Unemp[_n-11]
gen lag11CPIAUCNS_detrended = CPIAUCNS_detrended[_n-11]
gen lag11CSCICP03USM665S = CSCICP03USM665S[_n-11]
gen lag11MORTGAGE15US_detrended  = MORTGAGE15US_detrended[_n-11]
gen lag11SP500_detrended  = SP500_detrended[_n-11]
gen lag11DLTIIT_detrended  = DLTIIT_detrended[_n-11]

//regression used for prediction of Oct2016: 
regress SanFranciscoHomePriceIndex lag11CPIAUCNS_detrended lag11CSCICP03USM665S lag11MORTGAGE15US_detrended lag11SP500_detrended lag11unemp lag11DLTIIT_detrended lag11SanFranciscoHomePriceIndex
