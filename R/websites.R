
# SLGAsWebsites
#' SLGAs Websites
#' @description Locations of the various web sites relevant to the Soil and Landscape Grid of Australia.
#' @param WebSiteName If a name is supplied the URL will be opened in your browser.
#' @details If no WebSiteName value is supplied, a list of urls will be returned. If a  WebSiteName parameter value is supplied the website will be opened in your browser

#' @author Ross Searle
#' @return dataframe
#'
#' @examples
#' SLGAWebsites()
#' SLGAWebsites('TERN Landscapes COGs Datastore Main Page')
#' @export
SLGAWebsites <- function(WebSiteName=NULL){



  Website <- c('Soil and Landscape Grid of Australia', 'TERN Landscapes COGs Datastore Main Page', 'SLGA Soil Attributes  Data Store',
               '90m Covariates Data Store', '30m Covariates Data Store', '90m PCA Covariates Data Store', '30m PCA Covariates Data Store',
               'SLGA Soil Attribute Metadata', 'Covariate Metadata', 'SLGA Methodolgy Info'
               )


  FormattedURL <- c(paste0(slgaWebPath, '/index.html'),
                    paste0(slgaWebPath, '/GetData-COGSDataStore.html'),
                    paste0(slgaWebPath, '/GetData-COGSDataStore_SLGA.html'),
                    paste0(slgaWebPath, '/GetData-COGSDataStore_90m_Covariates.html'),
                    paste0(slgaWebPath, '/GetData-COGSDataStore_30m_Covariates.html'),
                    paste0(slgaWebPath, '/GetData-COGSDataStore_90m_PCA_Covariates.html'),
                    paste0(slgaWebPath, '/GetData-COGSDataStore_30m_PCA_Covariates.html'),
                    paste0('https://data.csiro.au/search/keyword?q=tern_soil'),

                    paste0('https://shiny.esoil.io/Apps/Covariates/'),
                    paste0('https://aussoilsdsm.esoil.io/slga-version-2-products')
                    )

                # RawURL <- c( paste0(slgaWebPath, '/GetData-COGSDataStore.html'),
               # paste0('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/'),
               # paste0('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/30m/'),
               # paste0('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m_PCA/'),
               # paste0('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/930m_PCA/'))

 # odf <- data.frame(Website=Website, FormattedURL=FormattedURL, RawURL=RawURL)
    odf <- data.frame(Website=Website, FormattedURL=FormattedURL)

  if(is.null(WebSiteName)){
    return(odf)
  }else{
    url <- odf[odf$Website==WebSiteName,]$FormattedURL
    utils::browseURL(utils::URLencode(url))
  }


}


