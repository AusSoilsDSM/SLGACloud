# devtools::document()
#
 library(testthat)
#
#
 library(SLGACloud)
PingDataStore()
covariateMetaData(product = '90mCovariates')
covariateNames(product = '90mCovariates')
covariateCOGsURLs(product = '90mCovariates', layername = 'Veg_Landsat8Bare2')
covariateCOGsURLs(product = '30mCovariates', layername = NULL)



openCogsWebsites()
openCogsWebsites('90mCovariates', type='Raw')
openCogsWebsites('90mCovariates', type='Formatted')


COGSDataStoreURLs()


SLGACodes()
SLGANames(product='CLY')

slgaCOGsURLs(product = 'AWC', layername=NULL)
slgaCOGsURLs(product = 'AWC', layername='AWC_030_060_05_N_P_AU_NAT_C_20140801')