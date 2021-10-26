# SLGACodes
#
#' Returns a list of available SLGA product codes
#'
#' @param product Returns a list of available SLGA product codes with it plain English description
#' @examples
#' SLGACodes()
#' @return dataframe
#' @export


slgaCodes <- function(){
    return(SLGAAttributes)
}

# SLGANames
#
#' Returns a list of available SLGA raster names
#'
#' @param product The product to return names for. Options are "AWC", "BDW", "CLY", "DER", "DES", "ECE", "NTO", "pHc", "PTO", "SLT", "SND", "SOC")
#' @return list
#' @examples
#' SLGANames(product='CLY')
#' @export

slgaNames <- function(product='CLY'){

  if(!is.null(product)){

    if(!product %in% slgacodes)
    {
      vals <- paste(SLGAAttributes$code, collapse = ', ')
      stop(paste0("Only valid product codes are ", vals))
    }
    adf <- read.csv(paste0( 'https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/', product, '/files.txt'), header = F)
    adf2 <- stringr::str_remove(adf[,1], '.tif')
  }
  return(adf2)
}



# slgaCOGsURLs
#
#' Returns a dataframe of available SLGA rasters and their COGs URLs
#'
#' @param product The product to return names for. Options are "AWC", "BDW", "CLY", "DER", "DES", "ECE", "NTO", "pHc", "PTO", "SLT", "SND", "SOC")
#' @param layername Filter on a specific layer name.
#' #' @examples
#' slgaCOGsURLs(product = 'AWC', layername=NULL)
#' slgaCOGsURLs(product = 'AWC', layername='AWC_030_060_05_N_P_AU_NAT_C_20140801')
#' @return dataframe
#' @export

slgaCOGsURLs <- function(product = NULL, layername=NULL){

  if(is.null(product)){ stop(paste0("You need to specify a product code. Valid product codes are ",  paste(SLGAAttributes$code, collapse = ', ')))}

    if(!product %in% slgacodes)
    {
      vals <- paste(SLGAAttributes$code, collapse = ', ')
      stop(paste0("Only valid product codes are ", vals))
    }
    adf <- read.csv(paste0( 'https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/', product, '/files.txt'), header = F)
    adf2 <- stringr::str_remove(adf[,1], '.tif')

  urls <- paste0(storeRoot, '/SLGA/',product, '/', adf2, '.tif')
  odf <- data.frame(name=adf2, url=urls)

  if(!is.null(layername)){
    odf <- odf[odf$name==layername, ]
  }

  return(odf)

}



