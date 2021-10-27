
# codeDemo
#
#' Run through a quick demonstration of the functions
#'
#' @examples
#' codeDemo()

#' @export


codeDemo <- function(){

cat(blue("\n\n######################################  Code Demo ############################################\n"))
cat(blue("\n\nThe SLGACloud package doesn't do that much really.\n"))

cat(blue("It is essentially just meant to ease access to the TERN Landscapes COGs DataStore URLS while you are \n"))
cat(blue("working in R, Without having to jump out to the website all the time to copy the required COGs URLs.\n"))
cat(blue("\nIt also has some functions for accessing the raster covariate stacks metadata and functions to\n"))
cat(blue("access the COGS Datastore web pages.\n"))

cat(blue("\nYou might also want to have a quick look at the demo about how to access and use COGs in R - codeDemoCOGs().\n"))

cat(blue('\n\nThis code demo will quickly run you through some of the functions in SLGACloud and show you \n'))
cat(blue('what information is returned.\n\n'))
invisible(readline(prompt="Press [enter] to start the demo"))

cat(green('\n\nTo check the HTTP COGS Datastore is online use - PingDataStore()\n'))
invisible(readline(prompt="Press [enter] see if the Datastore is alive"))
cat(red(pingDataStore()))

cat(green('\n\n\nTo get a list of covariate names use - covariateNames(product = "90mCovariates")\n'))
invisible(readline(prompt="Press [enter] to get a list of covariate names"))
nms <- covariateNames(product = "90mCovariates")
nsmstr <- paste0(nms[1:10], collapse = ', ')
cat(red(paste0(nsmstr, '....')))

cat(green('\n\n\nTo return COGs URLs - covariateCOGsURLs(product = "30mCovariates", layername = NULL)\n'))
invisible(readline(prompt="Press [enter] return COGs URLs"))
print(as_tibble(covariateCOGsURLs(product = '30mCovariates', layername = NULL)))

cat(green('\n\n\nTo get covariates metadata -  covariateMetaData(product = "90mCovariates")\n'))
invisible(readline(prompt="Press [enter] to get some metadata"))
print(as_tibble(covariateMetaData(product = '90mCovariates')))

cat(green('\n\n\nAnd finally to open the Datastore web sites -  covariateMetaData(product = "90mCovariates")\n'))
invisible(readline(prompt="Press [enter] to open the Datastore website"))
openCogsWebsites('90mCovariates', type='Formatted')

cat(green('\n\nHere endeth the lesson.....\n\nBut we do recommend you have a look at  codeDemoCOGs() to see how to use these uRLs in the "terra" package\n '))

}


