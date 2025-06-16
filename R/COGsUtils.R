# loadcog
#
#' Load a raster dataset from a COG URL
#' @description Uses the 'terra::rast' function and prepends the '/vsicurl/' bit to save you doing it manually
#' @param url Web location of the Cloud Optimised Geotiff
#' @return SpatRaster
#' @author Ross Searle
#' @examples
#' \dontrun{
#' cogLoad('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/Veg_Landsat8Bare2.tif')
#' }
#' @export

cogLoad <- function(url=NULL){

  r <- terra::rast(paste0('/vsicurl/', url))
  return(r)
}


# downloadcog
#
#' Download a COG file
#' @description Download an entire COG Geotiff file to your local machine
#' @param url Web location of the Cloud Optimised Geotiff
#' @param dest Download file location
#' @param quiet Show file download progress bar if TRUE
#' @return Cloud Optimised Geotiff
#' @author Ross Searle
#' @examples
#' \dontrun{
#' cogDownload(url = 'https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/Veg_Landsat8Bare2.tif', dest='c:/temp/demoCOG.tif')
#' }
#' @export

cogDownload <- function(url=NULL, dest='', quiet = FALSE){
  r <- utils::download.file(utils::URLencode(paste0(url)), destfile=dest, mode='wb', quiet = quiet )
  return(r)
}


# cogPreview
#
#' Preview a list of COG files
#' @description Iterate through a list of Cloud Optimised Geotiff URLs and plot them.
#' @param urls List of Cloud Optimised Geotiff URLs
#' @param delay Delay in seconds between drawing plots. Minimum = 3 seconds
#' @return plot
#' @examples
#' \dontrun{
#' cogs <- getProductMetaData(Detail = 'Low',  Attribute='Parent_Material', Resolution = '90m')
#' cogPreview(urls = cogs$COGsPath[1:6],  delay = 5)
#' }
#' @details A method for quickly viewing data products.
#' @author Ross Searle
#' @export
#' @importFrom grDevices rainbow
#'
cogPreview <- function(urls=NULL, delay=3){

  dly <- max(3, delay)
  for (i in 1:length(urls)) {
    n=stringr::str_remove(basename(urls[i]), '.tif')
    print(paste0('Plotting ', i, ' of ', length(urls), ' - ', n))
    # r <- terra::rast(paste0('/vsicurl/', urls[i]))
    # terra::plot(r, main=n)
    url <- paste0('/vsicurl/', urls[i])
    rs = stars::read_stars(url, proxy = TRUE)
    terra::plot(rs, downsample = 30, col=rainbow(10))
    Sys.sleep(dly)
  }
  print('Done')
}


# cogPlot
#
#' Plot COG files
#' @description Plot a single Cloud Optimised Geotiff.
#' @param url URL of the Cloud Optimised Geotiff.
#' @return plot
#' @examples
#' \dontrun{
#' cogPlot(url)
#' }
#' @details A method for quickly viewing a COG.
#' @author Ross Searle
#' @export
#' @importFrom grDevices rainbow

cogPlot <- function(url){
  n=stringr::str_remove(basename(url), '.tif')
  url <- paste0('/vsicurl/', url)
  rs = stars::read_stars(url, proxy = TRUE)
  terra::plot(rs, downsample = 30, col=rainbow(10), main=n)
}


pingDataStore <- function() {

  r <- httr::GET(paste0(storeRoot))

  if(r$status_code == 200){
    return(paste0('Hooray!!!! The COGs datastore is alive at - ', storeRoot))
  }else{
    return(paste0('Oops!!!! There is a problem talking to the data store at - ', storeRoot))
  }

}
