# loadcog
#
#' Load a raster dataset from a COG URL
#' @description Uses the 'terra' rast() function and prepends the '/vsicurl/' bit to save you doing it manually
#' @param url Web location of the Cloud Optimised Geotiff
#' @return SpatRaster
#' @examples
#' loadcog('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90/Veg_Landsat8Bare2.tif')
#' @export

loadcog <- function(url=NULL){

  r <- terra::rast(paste0('/vsicurl/', url))
  return(r)
}


# downloadcog
#
#' Download a COG file
#' @description Download an entire COG Geotiff file to your local machine
#' @param url Web location of the Cloud Optimised Geotiff
#' @param dest Download file location
#' @return file
#' @examples
#' downloadcog(url = 'https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90/Veg_Landsat8Bare2.tif', dest='c:/temp/demoCOG.tif')
#' @export

downloadcog <- function(url=NULL, dest=''){

  r <- download.file(paste0(url), destfile=dest, mode='wb')
  return(r)
}

