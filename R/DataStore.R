
# PingData
#
#' Check that the SLGA Data Store is available
#'
#' This function hits the SLGA Data Store to check that it is available
#' @return string
#' @export


PingDataStore <- function() {

 r <- httr::GET(paste0(storeRoot))

 if(r$status_code == 200){
    return(paste0('Hooray!!!! The COGs datastore is alive at - ', storeRoot))
 }else{
    return(paste0('Oops!!!! The is a problem talking to the data store at - ', storeRoot))
 }

}


# showCOGsDataStoreURL
#
#' List relevant URLs for the TERN Landscapes COGs Data Store
#'
#' A table  of URLs
#' @return dataframe
#' @export
COGSDataStoreURLs <- function() {

    Website <- c('Soil and Landscape Grid of Australia Website', 'TERN Landscape COGs Datastore Main Page', '90m Covariates', '30m Covariates')
    FormattedURL <- c(slgaWebPath, paste0(webRoot, '/Pages/index.html'), paste0(webRoot, '/Pages/90m_Covariates.html'),
                   paste0(webRoot, '/Pages/30m_Covariates.html'))
    RawURL <- c('', '', paste0(webRoot, '/Products/TERN/Covariates/Mosaics/90m/'), paste0(webRoot, '/Products/TERN/Covariates/Mosaics/30m/'))

    odf <- data.frame(Website=Website, FormattedURL=FormattedURL, RawURL=RawURL)
   return(odf)
}
