
# covariateMetaData
#
#' Return the metadata information for the raster covariate stack
#'
#' @description Return the metadata information for the raster covariate stack. Metadata for either 30m or 90m or both laots of covariates is returned
#' @param product Filter on the covariate stack for a particular product stack. Options are 30mCovariates or 90mCovariates
#' @return dataframe
#' @examples
#' covariateMetaData()
#' covariateMetaData(product = '90mCovariates')
#' @export

covariateMetaData <- function(product=NULL){

  covMeta <- read.csv(covMetaPath)
  if(!is.null(product)){

    if(product !='30mCovariates' & product != '90mCovariates')
    {
      stop("Only valid resolution value are '30mCovariates' or '90mCovariates'")
    }
    if(product=='30mCovariates'){
      df <- covMeta[covMeta$in30mMosaic==1, ]
    }else{
      df <- covMeta[covMeta$in90mMosaic==1, ]
    }
  }
    return(df)
}


# covariateNames
#
#' List of covariate raster names
#'
#' @description Returns a list of available covariate raster names
#'
#' @param product The product to return names for. Options are '90mCovariates' & '30mCovariates'
#' @examples
#' covariateNames(product = '90mCovariates')
#' @return list
#' @export

covariateNames <- function(product='90mCovariates'){

  if(!is.null(product)){

    if(product !='30mCovariates' & product != '90mCovariates')
    {
      stop("Only valid resolution value are '30mCovariates' or '90mCovariates'")
    }
    if(product=='30mCovariates'){
      df <- covMeta[covMeta$in30mMosaic==1, ]
    }else{
      df <- covMeta[covMeta$in90mMosaic==1, ]
    }
  }
    return(df$CoVariateName)
}


# getCovariateURLs
#
#' Get covariate rasters COGs URLs
#' @description Returns a dataframe of available covariate rasters and their COGs URLs
#' @param product The product to return names for. Options are '90mCovariates' & '30mCovariates'
#' @param layername Filter on a specific layer name.
#' @examples
#' covariateCOGsURLs(product = '90mCovariates', layername = 'Veg_Landsat8Bare2')
#' covariateCOGsURLs(product = '30mCovariates', layername = NULL)

#' @return dataframe
#' @export

covariateCOGsURLs <- function(product = NULL, layername=NULL){

  if(!is.null(product)){

    if(product !='30mCovariates' & product != '90mCovariates')
    {
      stop("Only valid product value are '30mCovariates' or '90mCovariates'")
    }
    if(product=='30mCovariates'){
      df <- covMeta[covMeta$in30mMosaic==1, ]
      res=30
    }else{
      df <- covMeta[covMeta$in90mMosaic==1, ]
      res=90
    }
  }


  urls <- paste0(storeRoot, '/Covariates/Mosaics/', res, 'm/', df$CoVariateName, '.tif')
  odf <- data.frame(name=df$CoVariateName, url=urls)

  if(!is.null(layername)){
    odf <- odf[odf$name==layername, ]
  }

  return(odf)

}


